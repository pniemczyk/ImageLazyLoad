ImageLazyLoad
=============

## Usage
Here is an example:

``` html
<body>
  <table>
    <tbody>
      <tr>
        <td><img src="../media/img/blank.jpg" data-src="../media/img/001.jpg" /></td>
        <td><img src="../media/img/blank.jpg" data-src="../media/img/002.jpg" /></td>
        <td><img src="../media/img/blank.jpg" data-src="../media/img/003.jpg" /></td>
      </tr>
      ...
      <tr>
        <td><img src="../media/img/blank.jpg" data-src="../media/img/004.jpg" /></td>
        <td><img src="../media/img/blank.jpg" data-src="../media/img/005.jpg" /></td>
        <td><img src="../media/img/blank.jpg" data-src="../media/img/006.jpg" /></td>
      </tr>
    </tbody>
  </table>
</body>
```

Js with base configuration:

``` js
var lazyload = new window.ImageLazyLoad()
```

or as Jquery plugin
``` js
var $('body').imageLazyLoad()
```

## Config Options

- **container** String *(default: 'body')* - elements tag or id, not present in jQuery plugin

- **range** Integer *(default: is container size)* - additional range out of view port to load

- **elements** String *(default:'img')* - elements tag or class with images to lazyload

- **errorImage** String or Image(object) *(default:'about:blank')* - image for not loaded images

- **mode** String *(default:vertical)* - vertical or horizontal image detection

- **realSrcAttribute** String *(default:data-src)* - html attribute holding true src of the image

- **useFade** Boolean *(default:true)* - hide images on load or not :D

- **afterImageLoaded** Function *(default:null)* - override default function displaying image after load

- **afterImageLoadError** Function *(default:null)* - override default function displaying error image after load

- **defaultScrollTriggerDelay** Integer *(default:150)* - delay to execute loading images after scrolling

- **loadingAtTopToEnd** Boolean *(default:true)* - loading all images from start list to current position

- **autoUpdateOnWindowResize** Boolean *(default:false)* - update loading images in view port after window resize

### Example

``` js

window.lazyload = new window.ImageLazyLoad({
  range: 300,
  container, '#container',
  elements: "div",
  errorImage: "about:blank",
  mode: "vertical",
  realSrcAttribute: "data-src",
  useFade: false,
  afterImageLoaded: function($el, src){ $el.css('background-image', 'url(' + src + ')')); },
  afterImageLoadError: function($el, src){ $el.css('background-image', 'url(' + src + ')')); },
  defaultScrollTriggerDelay: 0,
  loadingAtTopToEnd: false,
  autoUpdateOnWindowResize: false
});

```
### To run tests (in browser):

```shell
grunt build
serve .
visit <url>/test/test.html
```

### To see simple build in browser:

serve the root dir, `<url>/samples/*.html`

## ImageLazyLoad API

`version` display version of plugin

`unbindEvents()` stop listen on scroll

`bindEvents()` start listen on scroll

`loadAll()` load all not loaded images

## Browser Support
?
