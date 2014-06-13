module.exports = (grunt) ->

  grunt.initConfig
  
    aws: grunt.file.readJSON('./aws_key.json')

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
        dest: 'dist/3model.v1.js'
        options:
          alias: ['./lib/index.js:3vot-model']

    s3: 
      options: 
        key: '<%= aws.key %>',
        secret: '<%= aws.secret %>',
        bucket: 'dist.3vot.com',
        access: 'public-read',
        headers: 
          "Cache-Control": "max-age=0, public",
          "Expires": new Date(Date.now() + 1).toUTCString()

      dev:
        upload: [
          src: './dist/*.*',
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