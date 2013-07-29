"use strict"

exports.defaults = ->
  clientJadeStatic:
    context:{}

exports.placeholder = ->
  """
  \t

    # clientJadeStatic:   # settings for the client-jade-static module
      # context:{}        # An object of data to be passed into jade compilation. Use this to
                          # define the values for any variables that may be in the .html.jade
                          # files. Make this object as big as it needs to be to satisfy the needs
                          # of your jade files.
  """

exports.validate = (config, validators) ->
  errors = []

  if validators.ifExistsIsObject(errors, "clientJadeStatic config", config.clientJadeStatic)
    validators.ifExistsIsObject(errors, "clientJadeStatic.context", config.clientJadeStatic.context)

  errors
