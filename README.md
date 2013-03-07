mimosa-client-jade-static
===========

## Overview

For more information regarding Mimosa, see http://mimosajs.com

## Usage

Add `'client-jade-static'` to your list of modules.  That's all!  Mimosa will install the module for you when you start up.

## Functionality

If you have static HTML templates used in your web app, this module allows you to code those static HTML templates in Jade.

This module will detect any files with a double extension of `.html.jade`, compile those jade templates, and then execute the jade template resulting in html. That html will be placed in `compiledDir` at the same file location as the original file in `sourceDir` but without the `.jade` at the end of the file name.

The `.html.jade` files cannot have any dynamic pieces in it, if it does, the function execution will fail.

This module also handles deletes and cleans of static jade assets.

## Default Config

There is no config for this module.
