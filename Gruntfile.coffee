path = require('path');

module.exports = (grunt) ->
  grunt.initConfig(
    jshint:
      all: [
        'Gruntfile.js'
        'tasks/*.js'
        '<%= nodeunit.tests %>'
      ],
      options:
        jshintrc: '.jshintrc'

    clean:
      tests: ['tmp']

    mustache_precompiler:
      custom_options:
        options:
            sourceRoot: "test/data/templates-mustache",
            destination: "tmp/templates-mustache.js",
            extension: '.mustache',
            namespace: 'MST',
            hoganModule: 'hogan',
            hoganAlias: 'Hogan',
            nameMapper: (ctx) ->
                match = ctx.abspath.match(/\/([0-9]){2}-([^\/]+)\/([^@]*)@?([^\.]*)\.mustache$/)
                match[2] + '-' + match[3]
    nodeunit:
      tests: ['test/*_test.js']
  )
  grunt.loadTasks('tasks')

  grunt.loadNpmTasks('grunt-contrib-jshint')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-nodeunit')

  grunt.registerTask('test', ['clean', 'mustache_precompiler', 'nodeunit'])

  grunt.registerTask('default', ['test'])
