"use strict"

jade = require 'jade'

extensionRegex = /.html.[a-zA-Z]+$/

registration = (mimosaConfig, register) ->
  unless mimosaConfig.isVirgin
    extensions = compilers?.extensionOverrides?.jade or ["jade"]
    console.log "EXTENSION IS!!! #{extensions}"

    register ['cleanFile'],                               'init',         _removeFiles,                  extensions
    register ['add','update','remove', 'buildExtension'], 'afterRead',    _pullStaticFilesOutAndCompile, extensions
    register ['add','update','remove', 'buildExtension'], 'afterCompile', _addStaticFilesToOutput,       extensions

_pullStaticFilesOutAndCompile = (mimosaConfig, options, next) ->
  staticJadeFiles = []
  files = options.files.filter (file) ->
    _isJadeStatic file.inputFileName

  options.files = options.files.filter (file) ->
    not _isJadeStatic(file.inputFileName)

  options.staticJadeFiles = files.map (file) ->
    funct = jade.compile file.inputFileText,
      compileDebug: no,
      filename: file.inputFileName
    file.outputFileText = funct()
    file.outputFileName = file.inputFileName.replace(extensionRegex, '.html').replace(mimosaConfig.sourceDir, mimosaConfig.compiledDir)
    file

  next()

_isJadeStatic = (str) -> str.match extensionRegex

_removeFiles = (mimosaConfig, options, next) ->
  console.log "CLEAN"
  console.log options
  next()

_addStaticFilesToOutput = (mimosaConfig, options, next) ->
  options.files = options.files.concat options.staticJadeFiles
  next()

module.exports =
  registration:    registration