module.exports = (grunt) ->
	grunt.initConfig
		pkg: grunt.file.readJSON 'package.json'
		coffee:
			compile:
				expand: true
				cwd: 'public/coffee'
				src: '**/*.coffee'
				dest: 'public/javascripts/compiled'
				ext: '.js'
				flatten: true
				options:
					bare: true
					
		watch:
			self:
				files: ['Gruntfile.coffee']
			coffee:
				files: ['public/**/*.coffee']
				tasks: ['default']

	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.registerTask 'default', 'coffee'