(($) ->
  defaultOptions =
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

  self = @
  viewPort = null
  viewPortSize = null
  options = null
  axis = null

  onScroll = (e, that) ->
    pos = if that.axis is 'top' then that.viewPort.scrollTop() else that.viewPort.scrollLeft()
    if canLoading(pos)
      refreshElements(pos)
      $.fn.imageLazyLoad.unbindEvents() if that.options.$elements.length is 0

  startListenOnScroll = ->
    timer = null
    self.viewPort.on('scroll.ImageLazyLoad', (e)=>
      clearTimeout(timer)
      timer = setTimeout(
        => onScroll(e, @)
        self.options.defaultScrollTriggerDelay
      )
    )

  refreshElements = (position) ->
    self.options.$elements = self.options.$elements.map( (i, el) =>
      $el = $(el)
      elPos = $el.position()[self.axis]
      loadImg = false

      if self.options.loadingAtTopToEnd
        loadImg = elPos < position + viewPortSize + self.options.range
      else
        loadImg = position - self.options.range < elPos < position + viewPortSize + self.options.range

      if loadImg
        loadImage($el)
        null
      else
       el
    )

  loadImage = ($el) ->
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

  canLoading = (pos)->
    return true unless @loadingAtTopToEnd
    if pos > @lastTopPosition
      @lastTopPosition = pos
      true
    else
      false

  $.fn.imageLazyLoad = (options) ->
    lastTopPosition = 0

    self.options = $.extend(defaultOptions,  options)

    self.options.$container = if @ is window then $('body') else @
    self.options.$elements = self.options.$container.find(self.options.elements)
    if self.options.useFade then self.options.$elements.each( (i, el ) -> $(el).css("opacity", 0))
    self.axis = if self.options.mode is "vertical" then "top" else "left"
    self.viewPort = if self.options.container is 'body' then $(window) else self.options.$container
    self.viewPortSize = if self.axis is 'top' then self.viewPort.height() else self.viewPort.width()
    self.options.range = self.viewPortSize unless self.options.range?

    $.fn.imageLazyLoad.refreshLoader()
    startListenOnScroll()
    $(window).resize( => $.fn.imageLazyLoad.refreshLoader()) if self.options.autoUpdateOnWindowResize

  $.fn.imageLazyLoad.version = '1.0.1'

  $.fn.imageLazyLoad.refreshLoader = -> onScroll(null, self)

  $.fn.imageLazyLoad.unbindEvents = -> self.viewPort.off('.ImageLazyLoad')
) jQuery