_ = require 'lodash'
hogan = require 'hogan.js'
path = require 'path'
fs = require 'fs'

iterator = (options, os) ->

module.exports = (grunt) ->
  DEFAULT_OPTIONS =
    sourceRoot: './public/scripts/templates-mustache'
    destination: './public/scripts/templates-mustache.js'
    extension: '.mustache'
    namespace: 'MST'
    hoganModule: 'hogan'
    hoganAlias: 'Hogan'
    filter: ({filename, options}) ->
      path.extname(filename) == options.extension
    nameMapper: ({filename, options}) ->
      path.basename(filename, options.extension)

  grunt.registerMultiTask 'mustache_precompiler', 'Grunt plugin for mustache precompile using Hogan.', ->

    done = @async()
    options = _.extend {}, DEFAULT_OPTIONS, @options()
    destinationDir = path.dirname options.destination
    counter = 0
    try
      grunt.file.mkdir destinationDir
      os = fs.createWriteStream options.destination
      os
        .on 'finish', ->
          grunt.log.ok "#{counter} mustache templates have been precompiled to #{options.target}"
          done()
        .on 'error', (err) ->
          grunt.log.error err
          done

      os.write("define(['#{options.hoganModule}'],function(#{options.hoganAlias}){")
      os.write("var x = {};\n")

      grunt.file.recurse options.sourceRoot, (abspath, rootdir, subdir, filename) ->
        ctx =
          abspath: abspath
          rootdir: rootdir
          subdir: subdir
          filename: filename
          options: options
        if options.filter ctx
          name = options.nameMapper ctx
          template = grunt.file.read abspath
          os.write("x['#{name}']=new #{options.hoganAlias}.Template(")
          os.write(hogan.compile(template, asString: 1))
          os.write(");\n")
          grunt.log.ok "Compiling:   #{abspath} -> #{name}"
          counter++

      os.write("return x;});")
      os.end()
    catch err
      grunt.log.error err
      done(err)

