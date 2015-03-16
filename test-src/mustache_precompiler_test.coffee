_ = require('lodash')
grunt = require('grunt')

exports.mustache_precompiler =
  setUp: (done) -> done()

  custom_options: (test) ->
    test.expect(3)
    lines = grunt.file.read('tmp/templates-mustache.js').split("\n")

    test.equal lines.length, 4
    test.equal lines[1].indexOf("x['molecules-partial']=new Hogan.Template"), 0
    test.equal lines[2].indexOf("x['organisms-test']=new Hogan.Template"), 0
    test.done()
