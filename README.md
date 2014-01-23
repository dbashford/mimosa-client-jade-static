mimosa-client-jade-static
===========

## Overview

For more information regarding Mimosa, see http://mimosa.io

## Usage

Add `'client-jade-static'` and "`jade`" to your list of modules.  That's all!  Mimosa will install the module for you when you start up.

As of Mimosa `2.0` `jade` must be a module of your app for this to work as Mimosa no longer supports jade right out of the box.

## Functionality

If you have static HTML templates used in your web app, this module allows you to code those static HTML templates in Jade.

This module will detect any files with a double extension of `.html.jade`, compile those jade templates, and then execute the jade template resulting in html. That html will be placed in `compiledDir` at the same file location as the original file in `sourceDir` but without the `.jade` at the end of the file name.

This module also handles deletes and cleans of static jade assets.

Note: If you are optimizing your JavaScript using `mimosa-minify` or `mimosa-minify-js` or something similar, then you may get odd messages about minification failing on your compiled Jade files.  Nothing bad is happening, so if you are ok with the messages, you can do nothing.  Another option is to add `/.html$/` to the `minify[JS].exclude` array. This will prevent the `minify` modules from attempting to minify the HTML output of this module. See [this Mimosa issue](https://github.com/dbashford/mimosa/issues/320) for more details.

## Default Config

```
clientJadeStatic:
  context:{}
  outputExtension: '.html'
  extensionRegex: /.html.[a-zA-Z]+$/
  prettyOutput: false
```

* `context`: An object of data to be passed into jade compilation.  Use this to define the values for any variables that may be in the `.html.jade` files. Make this object as big as it needs to be to satisfy the needs of your jade files.
* `outputExtension`: The extension to use for files output by jade compilation.
* `extensionRegex`: The regex to use to match jade files to be compiled. Files must still end in .jade or in whatever the compiler override is for the jade compiler.  By default this captures `.html.jade` files, but you could change it to something like `.static.jade`.
* `prettyOutput`: Indicates if the Jade compiler should output pretty-indentation whitespace.
