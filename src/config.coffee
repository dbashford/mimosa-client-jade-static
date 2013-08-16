"use strict"

exports.defaults = ->
  clientJadeStatic:
    outputExtension: '.html'
    extensionRegex: /.html.[a-zA-Z]+$/
    context:{}


exports.placeholder = ->
  """
  \t

    # clientJadeStatic:                     # settings for the client-jade-static module
      # context:{}                          # An object of data to be passed into jade compilation.
                                            # Use this to define the values for any variables that
                                            # may be in the .html.jade files. Make this object as
                                            # big as it needs to be to satisfy the needs of your
                                            # jade files.
      # outputExtension: '.html'            # The extension to use for files output by jade
                                            # compilation.
      # extensionRegex: /.html.[a-zA-Z]+$/  # The regex to use to match jade files to be compiled
                                            # Files must still end in .jade or in whatever the
                                            # compiler override is for the jade compiler.
  """

exports.validate = (config, validators) ->
  errors = []

  if validators.ifExistsIsObject(errors, "clientJadeStatic config", config.clientJadeStatic)
    validators.ifExistsIsObject(errors, "clientJadeStatic.context", config.clientJadeStatic.context)

    unless config.clientJadeStatic.extensionRegex instanceof RegExp
      errors.push "clientJadeStatic.extensionRegex must be an instance of RegExp"

    if validators.ifExistsIsString(errors, "clientJadeStatic.outputExtension", config.clientJadeStatic.outputExtension)
      if config.clientJadeStatic.outputExtension.indexOf('.') isnt 0
        config.clientJadeStatic.outputExtension = "." + config.clientJadeStatic.outputExtension

  errors
