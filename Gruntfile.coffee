module.exports = ->
  @initConfig
    coffee:
      dev:
        expand: true
        flatten: false
        cwd: 'src'
        src: ['**/*.coffee']
        dest: 'lib'
        ext: '.js'
    mochaTest:
      test:
        src: ['test/**/*.coffee']
        options:
          compilers: 'coffee-script'
          reporter: 'spec'
    watch:
      coffee:
        files: ['src/**/*.coffee']
        tasks: ['coffee:dev']
      mocha:
        files: ['src/**/*.coffee', 'test/**/*.coffee']
        tasks: ['mochaTest']

  @loadNpmTasks 'grunt-mocha-test'
  @loadNpmTasks 'grunt-contrib-watch'
  @loadNpmTasks 'grunt-contrib-coffee'

  @registerTask 'default', ['dev']
  @registerTask 'test', ['mochaTest', 'watch:mocha']
