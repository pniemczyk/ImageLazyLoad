'use strict'
log = (msg) -> console.log msg

describe "Self test", ->

  it "is ok", -> expect(true).toBe(true)

describe "ImageLazyLoad", ->

  it 'is defined', -> expect(ImageLazyLoad).toBeDefined()

  describe "instance has base property", ->
    beforeEach -> @subject = new ImageLazyLoad()

    it 'version equal "1.0.0"', -> expect(@subject.version).toEqual('1.0.0')

    describe "options as default", ->
      it 'with range equal 200',                   -> expect(@subject.options.range).toEqual(200)
      it 'with elements equal "img"',              -> expect(@subject.options.elements).toEqual("img")
      it 'with container equal "body"',            -> expect(@subject.options.container).toEqual("body")
      it 'with errorImage equal "about:blank"',    -> expect(@subject.options.errorImage).toEqual("about:blank")
      it 'with mode equal "vertical"',             -> expect(@subject.options.mode).toEqual("vertical")
      it 'with realSrcAttribute equal "data-src"', -> expect(@subject.options.realSrcAttribute).toEqual("data-src")
      it 'with fadeAtStart equal true',            -> expect(@subject.options.fadeAtStart).toEqual(true)
      it 'with afterImageLoaded be null',          -> expect(@subject.options.afterImageLoaded).toBeNull()
      it 'with afterImageLoadError be null',       -> expect(@subject.options.afterImageLoadError).toBeNull()

  describe "class has method", ->

