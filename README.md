mimosa-client-jade-static
===========

## Overview

For more information regarding Mimosa, see http://mimosajs.com

## Usage

Add `'client-jade-static'` to your list of modules.  That's all!  Mimosa will install the module for you when you start up.

## Functionality

If you have static HTML templates used in your web app, this module allows you to code those static HTML templates in Jade.

This module will detect any files with a double extension of `.html.jade`, compile those jade templates, and then execute the jade template resulting in html. That html will be placed in `compiledDir` at the same file location as the original file in `sourceDir` but without the `.jade` at the end of the file name.

This module also handles deletes and cleans of static jade assets.

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
