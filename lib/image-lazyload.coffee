class window.ImageLazyLoad

  version: '1.0.0'

  options:
    range: 200
    elements: "img"
    container: "body"
    errorImage: "about:blank"
    mode: "vertical"
    realSrcAttribute: "data-src"
    fadeAtStart: true
    afterImageLoaded: null
    afterImageLoadError: null
    defaultScrollTriggerDelay: 150
    listIsSorted: true
    loadingAtTopToEnd: true

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
    @axis = if @options.mode is "vertical" then "top" else "left"
    @container = if @options.container is 'body' then $(window) else @$container
    @containerSize = if @axis is 'top' then @container.height() else @container.width()
    @refreshElements(@containerSize)
    @startListenOnScroll()

  startListenOnScroll: ->
    @timer
    @container.on('scroll.ImageLazyLoad', (e)=>
      clearTimeout(@timer)
      @timer = setTimeout(
        => @onScroll(e, @)
        @options.defaultScrollTriggerDelay
      )
    )

  refreshElements: (viewPortSize) ->
    @$elements = @$elements.map( (i, el)=>
      $el = $(el)
      $el.css("opacity", 0)  if @options.fadeAtStart
      elPos = $el.position()[@axis]
      if elPos < viewPortSize + @options.range
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
        $el.css("opacity", 1) if @options.fadeAtStart
    img.onerror = =>
      if typeof @options.afterImageLoadError is 'function'
        @options.afterImageLoadError($el, @options.errorImage.src)
      else
        $el.attr('src', @options.errorImage.src)
        $el.css("opacity", 1) if @options.fadeAtStart
    img.src = $el.attr(@options.realSrcAttribute)

  onScroll: (e, that) ->
    pos = if that.axis is 'top' then that.container.scrollTop() else that.container.scrollLeft()
    if that.canLoading(pos)
      that.refreshElements(pos + that.containerSize)
    if that.$elements.length is 0
      that.unbindEvents()
  visitedViewPorts: []
  canLoading: (pos)->
    start = pos - @options.range
    end = pos + @containerSize + @options.range
    $.each(@visitedViewPorts, (i, item) ->
      if start =< item[0]
    )
    console.log
    true

  calculate: ->

  unbindEvents: ->
    console.log 'unbind'
    @container.off('.ImageLazyLoad')
