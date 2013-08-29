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
    watch:
      coffee:
        files: ['src/**/*.coffee']
        tasks: ['coffee:dev']

  @loadNpmTasks 'grunt-contrib-watch'
  @loadNpmTasks 'grunt-contrib-coffee'

  @registerTask 'default', ['dev']
  @registerTask 'dev', ['coffee:dev', 'watch']

