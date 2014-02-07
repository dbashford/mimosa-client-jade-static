"use strict"

fs = require 'fs'

jade = require 'jade'

config = require './config'
extensionRegex = null

registration = (mimosaConfig, register) ->
  extensionRegex = mimosaConfig.clientJadeStatic.extensionRegex
  extensions = mimosaConfig.compilers?.extensionOverrides?.jade or ["jade"]
  register ['add','update','buildExtension'], 'afterRead',    _pullStaticFilesOutAndCompile, extensions
  register ['add','update','buildExtension'], 'afterCompile', _addStaticFilesToOutput,       extensions
  register ['remove','cleanFile'],            'afterRead',    _removeStaticJade,             extensions

__outputFileName = (mimosaConfig, inputFileName) ->
  inputFileName
    .replace(mimosaConfig.clientJadeStatic.extensionRegex, mimosaConfig.clientJadeStatic.outputExtension)
    .replace(mimosaConfig.watch.sourceDir, mimosaConfig.watch.compiledDir)

__isJadeStatic = (str) -> str.match extensionRegex

_pullStaticFilesOutAndCompile = (mimosaConfig, options, next) ->
  hasFiles = options.files?.length > 0
  return next() unless hasFiles

  files = options.files.filter (file) ->
    __isJadeStatic file.inputFileName

  # if is jade static file, and the result of a single add/update
  # then clean out options.files, don't want to compile templates
  options.files = if options.inputFile? and __isJadeStatic options.inputFile
    []
  else
    options.files.filter (file) ->
      not __isJadeStatic(file.inputFileName)

  options.staticJadeFiles = files
    .map (file) ->
      file.outputFileName = __outputFileName(mimosaConfig, file.inputFileName)
      file
    .filter (file) ->
      if fs.existsSync file.outputFileName
        outStats = fs.statSync file.outputFileName
        inStats = fs.statSync file.inputFileName
        inStats.mtime > outStats.mtime
      else
        true
    .map (file) ->
      try
        funct = jade.compile file.inputFileText,
          compileDebug: no
          filename: file.inputFileName
          pretty: mimosaConfig.clientJadeStatic.prettyOutput
        file.outputFileText = funct mimosaConfig.clientJadeStatic.context
      catch err
        mimosaConfig.log.error err
        file.outputFileText = null
      file

  next()

_removeStaticJade = (mimosaConfig, options, next) ->
  if __isJadeStatic options.inputFile
    # removed file was a static file, don't need to compile templates too
    options.files = []
    outputFileName = __outputFileName mimosaConfig, options.inputFile
    if fs.existsSync outputFileName
      fs.unlinkSync outputFileName
      mimosaConfig.log.success "Deleted file [[ #{outputFileName} ]] "
  next()

_addStaticFilesToOutput = (mimosaConfig, options, next) ->
  return next() unless options.files?.length > 0 or options.staticJadeFiles?.length > 0

  unless options.files?
    options.files = []

  options.files = options.files.concat options.staticJadeFiles
  next()

module.exports =
  registration: registration
  defaults:     config.defaults
  placeholder:  config.placeholder
  validate:     config.validate