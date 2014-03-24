module.exports = (grunt) ->

  grunt.initConfig

    clean:
      source: ['./lib/*.js']
      
    coffee:
      sourceFiles:
        expand: true,
        flatten: true,
        cwd: './src',
        src: ['*.coffee'],
        dest: './lib/',
        ext: '.js'
  
      testFiles:
        expand: true,
        flatten: true,
        cwd: './test/specs/src',
        src: ['*.coffee'],
        dest: './test/specs/',
        ext: '.js'

    watch:
      source:
        files: ["src/*.coffee"]
        tasks: ['clean','coffee:sourceFiles',"jasmine:salesforceModel"]

      test_src:
        files: ["test/specs/src/*.coffee"]
        tasks: ['coffee:testFiles',"jasmine:salesforceModel"]

    jasmine:
      model: 
        src: ["./lib/index.js"]
        options: 
          specs: ['./specs/class.js', './specs/events.js' , './specs/model.js']

    browserify:
      basic: 
        src: ['lib/index.js']
        dest: 'dist/3model.js'
        options:
          alias: ['./lib/index.js:3vot-model']
       
      ajax: 
        src: ['lib/ajax.js']
        dest: 'dist/3ajax.js'
        options:
          alias: ["./lib/ajax.js:_3Ajax"]
          external: ["3vot-model"]

  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-jasmine');
  grunt.loadNpmTasks('grunt-contrib-watch');

  grunt.loadNpmTasks('grunt-browserify');

  grunt.registerTask("pack",["coffee", "browserify"])
  
  grunt.registerTask('default', ['clean','coffee', "browserify" , 'jasmine']);