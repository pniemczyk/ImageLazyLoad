class window.ImageLazyLoad
  version: '1.0.1'
  lastTopPosition: 0

  options:
    range: null
    elements: "img"
    errorImage: "about:blank"
    container: 'body'
    mode: "vertical"
    realSrcAttribute: "data-src"
    useFade: true
    afterImageLoaded: null
    afterImageLoadError: null
    defaultScrollTriggerDelay: 150
    loadingAtTopToEnd: true
    autoUpdateOnWindowResize: false

  setOptions: (options) ->
    return unless options?
    @options[prop] = options[prop] for prop of options when options.hasOwnProperty(prop)
    if typeof @options.errorImage is 'string'
      src = @options.errorImage
      @options.errorImage = new Image()
      @options.errorImage.src = src

  constructor: (options) ->
    @setOptions options
    @$container = $(@options.container)
    @$elements = @$container.find(@options.elements)
    @fadeAll() if @options.useFade
    @axis = if @options.mode is "vertical" then "top" else "left"
    @container = if @options.container is 'body' then $(window) else @$container
    @viewPortSize = if @axis is 'top' then @container.height() else @container.width()
    @options.range = @viewPortSize if @options.range?
    @refreshLoader()
    @startListenOnScroll()
    $(window).resize( => @refreshLoader()) if @options.autoUpdateOnWindowResize

  fadeAll: ->
    @$elements.each( (i, el ) -> $(el).css("opacity", 0))

  startListenOnScroll: ->
    @timer
    @container.on('scroll.ImageLazyLoad', (e)=>
      clearTimeout(@timer)
      @timer = setTimeout(
        => @onScroll(e, @)
        @options.defaultScrollTriggerDelay
      )
    )

  refreshLoader: ->
    @onScroll(null, @)

  refreshElements: (position) ->
    @$elements = @$elements.map( (i, el)=>
      $el = $(el)
      elPos = $el.position()[@axis]
      loadImg = false

      if @loadingAtTopToEnd
        loadImg = elPos < position + @viewPortSize + @options.range
      else
        loadImg = position - @options.range < elPos < position + @viewPortSize + @options.range

      if loadImg
        @loadImage($el)
        null
      else
       el
    )

  loadImage: ($el) ->
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

  onScroll: (e, that)->
    pos = if that.axis is 'top' then that.container.scrollTop() else that.container.scrollLeft()
    if that.canLoading(pos)
      that.refreshElements(pos)
      that.unbindEvents() if that.$elements.length is 0

  canLoading: (pos)->
    return true unless @loadingAtTopToEnd
    if pos > @lastTopPosition
      @lastTopPosition = pos
      true
    else
      false

  unbindEvents: ->
    @container.off('.ImageLazyLoad')