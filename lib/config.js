"use strict";
exports.defaults = function() {
  return {
    clientJadeStatic: {
      outputExtension: '.html',
      extensionRegex: /.html.[a-zA-Z]+$/,
      prettyOutput: false,
      context: {}
    }
  };
};

exports.placeholder = function() {
  return "\t\n\n  clientJadeStatic:                     # settings for the client-jade-static module\n    context:{}                          # An object of data to be passed into jade compilation.\n                                        # Use this to define the values for any variables that may\n                                        # be in the .html.jade files. Make this object as big as\n                                        # it needs to be to satisfy the needs of your jade files.\n    outputExtension: '.html'            # The extension to use for files output by jade compilation\n    extensionRegex: /.html.[a-zA-Z]+$/  # The regex to use to match jade files to be compiled\n                                        # Files must still end in .jade or in whatever the\n                                        # compiler override is for the jade compiler.\n    prettyOutput: false                 # Indicates if the Jade compiler should output\n                                        # pretty-indentation whitespace\n";
};

exports.validate = function(config, validators) {
  var errors;
  errors = [];
  if (validators.ifExistsIsObject(errors, "clientJadeStatic config", config.clientJadeStatic)) {
    validators.ifExistsIsObject(errors, "clientJadeStatic.context", config.clientJadeStatic.context);
    if (!(config.clientJadeStatic.extensionRegex instanceof RegExp)) {
      errors.push("clientJadeStatic.extensionRegex must be an instance of RegExp");
    }
    if (validators.ifExistsIsString(errors, "clientJadeStatic.outputExtension", config.clientJadeStatic.outputExtension)) {
      if (config.clientJadeStatic.outputExtension.indexOf('.') !== 0) {
        config.clientJadeStatic.outputExtension = "." + config.clientJadeStatic.outputExtension;
      }
    }
    validators.ifExistsIsBoolean(errors, "clientJadeStatic.prettyOutput", config.clientJadeStatic.prettyOutput);
  }
  return errors;
};
