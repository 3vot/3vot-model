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

    s3: 
      options: 
        key: 'AKIAJP5OIVAJN3XSMBPQ',
        secret: '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',
        bucket: 'test.3vot.com',
        access: 'public-read',
        headers: 
          "Cache-Control": "max-age=0, public",
          "Expires": new Date(Date.now() + 1).toUTCString()

      dev:
        upload: [
          src: './dist/*.js',
          options: { gzip: true }
        ]
   

  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-jasmine');
  grunt.loadNpmTasks('grunt-contrib-watch');

  grunt.loadNpmTasks('grunt-browserify');
  grunt.loadNpmTasks('grunt-s3');


  grunt.registerTask("pack",["coffee", "browserify"])

  grunt.registerTask("dev",["coffee", "browserify", "s3"])
  
  grunt.registerTask('default', ['clean','coffee', "browserify" , 'jasmine']);