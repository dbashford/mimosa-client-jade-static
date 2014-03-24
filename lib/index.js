"use strict";
var config, extensionRegex, fs, jade, registration, __isJadeStatic, __outputFileName, _addStaticFilesToOutput, _pullStaticFilesOutAndCompile, _removeStaticJade;

fs = require('fs');

jade = require('jade');

config = require('./config');

extensionRegex = null;

registration = function(mimosaConfig, register) {
  var extensions, _ref, _ref1;
  extensionRegex = mimosaConfig.clientJadeStatic.extensionRegex;
  extensions = ((_ref = mimosaConfig.compilers) != null ? (_ref1 = _ref.extensionOverrides) != null ? _ref1.jade : void 0 : void 0) || ["jade"];
  register(['add', 'update', 'buildExtension'], 'afterRead', _pullStaticFilesOutAndCompile, extensions);
  register(['add', 'update', 'buildExtension'], 'afterCompile', _addStaticFilesToOutput, extensions);
  return register(['remove', 'cleanFile'], 'afterRead', _removeStaticJade, extensions);
};

__outputFileName = function(mimosaConfig, inputFileName) {
  return inputFileName.replace(mimosaConfig.clientJadeStatic.extensionRegex, mimosaConfig.clientJadeStatic.outputExtension).replace(mimosaConfig.watch.sourceDir, mimosaConfig.watch.compiledDir);
};

__isJadeStatic = function(str) {
  return str.match(extensionRegex);
};

_pullStaticFilesOutAndCompile = function(mimosaConfig, options, next) {
  var files, hasFiles, _ref;
  hasFiles = ((_ref = options.files) != null ? _ref.length : void 0) > 0;
  if (!hasFiles) {
    return next();
  }
  files = options.files.filter(function(file) {
    return __isJadeStatic(file.inputFileName);
  });
  options.files = (options.inputFile != null) && __isJadeStatic(options.inputFile) ? [] : options.files.filter(function(file) {
    return !__isJadeStatic(file.inputFileName);
  });
  options.staticJadeFiles = files.map(function(file) {
    file.outputFileName = __outputFileName(mimosaConfig, file.inputFileName);
    return file;
  }).filter(function(file) {
    var inStats, outStats;
    if (fs.existsSync(file.outputFileName)) {
      outStats = fs.statSync(file.outputFileName);
      inStats = fs.statSync(file.inputFileName);
      return inStats.mtime > outStats.mtime;
    } else {
      return true;
    }
  }).map(function(file) {
    var err, funct;
    try {
      funct = jade.compile(file.inputFileText, {
        compileDebug: false,
        filename: file.inputFileName,
        pretty: mimosaConfig.clientJadeStatic.prettyOutput
      });
      file.outputFileText = funct(mimosaConfig.clientJadeStatic.context);
    } catch (_error) {
      err = _error;
      mimosaConfig.log.error(err, {
        exitIfBuild: true
      });
      file.outputFileText = null;
    }
    return file;
  });
  return next();
};

_removeStaticJade = function(mimosaConfig, options, next) {
  var outputFileName;
  if (__isJadeStatic(options.inputFile)) {
    options.files = [];
    outputFileName = __outputFileName(mimosaConfig, options.inputFile);
    if (fs.existsSync(outputFileName)) {
      fs.unlinkSync(outputFileName);
      mimosaConfig.log.success("Deleted file [[ " + outputFileName + " ]] ");
    }
  }
  return next();
};

_addStaticFilesToOutput = function(mimosaConfig, options, next) {
  var _ref, _ref1;
  if (!(((_ref = options.files) != null ? _ref.length : void 0) > 0 || ((_ref1 = options.staticJadeFiles) != null ? _ref1.length : void 0) > 0)) {
    return next();
  }
  if (options.files == null) {
    options.files = [];
  }
  options.files = options.files.concat(options.staticJadeFiles);
  return next();
};

module.exports = {
  registration: registration,
  defaults: config.defaults,
  placeholder: config.placeholder,
  validate: config.validate
};
