'use strict'
log = (msg) -> console.log msg

describe "Self test", ->

  it "is ok", -> expect(true).toBe(true)

describe "ImageLazyLoad", ->

  it 'is defined', -> expect(ImageLazyLoad).toBeDefined()

  describe "instance has base property", ->
    beforeEach ->
      @viePort = $(window)
      @subject = new ImageLazyLoad()

    it 'version equal "1.0.1"', -> expect(@subject.version).toEqual('1.0.1')

    describe "options as default", ->
      it 'with range be viewPort size',            -> expect(@subject.options.range).toEqual(@viePort.height())
      it 'with elements equal "img"',              -> expect(@subject.options.elements).toEqual("img")
      it 'with container equal "body"',            -> expect(@subject.options.container).toEqual("body")
      it 'with errorImage equal "about:blank"',    -> expect(@subject.options.errorImage).toEqual("about:blank")
      it 'with mode equal "vertical"',             -> expect(@subject.options.mode).toEqual("vertical")
      it 'with realSrcAttribute equal "data-src"', -> expect(@subject.options.realSrcAttribute).toEqual("data-src")
      it 'with useFade equal true',                -> expect(@subject.options.useFade).toEqual(true)
      it 'with afterImageLoaded be null',          -> expect(@subject.options.afterImageLoaded).toBeNull()
      it 'with afterImageLoadError be null',       -> expect(@subject.options.afterImageLoadError).toBeNull()
      it 'with defaultScrollTriggerDelay be 150',  -> expect(@subject.options.defaultScrollTriggerDelay).toEqual(150)
      it 'with loadingAtTopToEnd be true',         -> expect(@subject.options.loadingAtTopToEnd).toBe(true)
      it 'with autoUpdateOnWindowResize be false', -> expect(@subject.options.autoUpdateOnWindowResize).toBe(false)

  describe "class has method", ->

