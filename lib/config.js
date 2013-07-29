"use strict";
exports.defaults = function() {
  return {
    clientJadeStatic: {
      context: {}
    }
  };
};

exports.placeholder = function() {
  return "\t\n\n  # clientJadeStatic:   # settings for the client-jade-static module\n    # context:{}        # An object of data to be passed into jade compilation. Use this to\n                        # define the values for any variables that may be in the .html.jade\n                        # files. Make this object as big as it needs to be to satisfy the needs\n                        # of your jade files.";
};

exports.validate = function(config, validators) {
  var errors;
  errors = [];
  if (validators.ifExistsIsObject(errors, "clientJadeStatic config", config.clientJadeStatic)) {
    validators.ifExistsIsObject(errors, "clientJadeStatic.context", config.clientJadeStatic.context);
  }
  return errors;
};
