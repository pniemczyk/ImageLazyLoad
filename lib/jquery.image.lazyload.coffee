(($) ->
  getViewPort = (el)   -> if el is 'body' || el = $('body') then $(window) else $(el)
  getAxis = (mode)     -> if mode is "vertical" then "top" else "left"
  fadeAll = (elements) -> elements.each( (i, el ) -> $(el).css("opacity", 0))
  getViewPortSize = (axis , viewPort) -> if axis is 'top' then viewPort.height() else viewPort.width()
  getPosition     = (axis, viewPort)  -> if axis is 'top' then viewPort.scrollTop() else viewPort.scrollLeft()
  isPositionToLoadImages = (loadingAtTopToEnd, elementPosition, currentPosition, viewPortSize, range)-> 
    if loadingAtTopToEnd 
      elementPosition < currentPosition + viewPortSize + range 
    else
      currentPosition - range < elementPosition < currentPosition + viewPortSize + range

  $.imageLazyLoad = (el, options) -> 

    @version         = '1.0.2'
    @options         = {}
    @lastTopPosition = 0
    @$container      = null
    @$elements       = []
    @viewPort        = null
    @viewPortSize    = null
    @axis            = null

    @$elements = -> @options.$elements

    @init = (el, options) -> 
      @options       = $.extend({}, $.imageLazyLoad.defaultOptions, options)
      @$container    = if el is window then $('body') else $(el)
      @$elements = @$container.find(@options.elements)
      @axis          = getAxis(@options.mode)
      @viewPort      = getViewPort(@$container)
      @viewPortSize  = getViewPortSize(@axis, @viewPort)
      @options.range = @viewPortSize unless @options.range?
      
      fadeAll(@$elements) if @options.useFade
          
      @refreshLoader()
      startListenOnScroll()
      $(window).resize( => @refreshLoader()) if @options.autoUpdateOnWindowResize

    startListenOnScroll = =>
      timer = null
      @viewPort.on('scroll.ImageLazyLoad', (e) =>
        clearTimeout(timer)
        timer = setTimeout(
          => onScroll(e, @)
          @options.defaultScrollTriggerDelay
        )
      )

    @unbindEvents = -> @viewPort.off('.ImageLazyLoad')
    @bindEvents = -> startListenOnScroll()
    @loadAll = ->
      @$elements.each( (i, item) => loadImage($(item)))
      @$elements = []
      @unbindEvents()

    refreshElements = (position, that, isWindow) => 
      that.$elements = that.$elements.map( (i, item) =>
        $item = $(item)
        elPos = if isWindow then $item.offset()[that.axis] else $item.position()[that.axis]
        if isPositionToLoadImages(@options.loadingAtTopToEnd, elPos, position, @viewPortSize, @options.range)
          loadImage($item)
        else
          item
      )

    loadImage = ($el) =>
      img  = new Image()
      img.onload = =>
        if typeof @options.afterImageLoaded is 'function'
          @options.afterImageLoaded($el, img.src)
        else
          $el.attr('src', img.src)
          $el.css("opacity", 1) if @options.useFade
      img.onerror = =>
        if typeof @options.afterImageLoadError is 'function'
          @options.afterImageLoadError($el, @options.errorImage.src)
        else
          $el.attr('src', @options.errorImage.src)
          $el.css("opacity", 1) if @options.useFade
      img.src = $el.attr(@options.realSrcAttribute)
      null

    onScroll = (e, that) ->
      pos = getPosition(that.axis, that.viewPort)
      if !that.options.loadingAtTopToEnd || pos >= that.lastTopPosition
        that.lastTopPosition = pos
        refreshElements(pos, that, $.isWindow(that.viewPort[0]))
        that.unbindEvents() if that.$elements.length is 0    
    
    @refreshLoader = => onScroll(null, @)

    @init(el, options)
 
  $.fn.imageLazyLoad = (options) -> new $.imageLazyLoad(@, options)

  $.imageLazyLoad.defaultOptions =
    range: null
    elements: "img"
    errorImage: "about:blank"
    mode: "vertical"
    realSrcAttribute: "data-src"
    useFade: true
    afterImageLoaded: null
    afterImageLoadError: null
    defaultScrollTriggerDelay: 150
    loadingAtTopToEnd: true
    autoUpdateOnWindowResize: false
) jQuery