module.exports = function(grunt) {

    grunt.initConfig({
		connect: {
			server: {
				options: {
					port: 8001,
					base: '.'
				}
			}
		},

		jade: {
			compile: {
				options: {
					client: false,
					pretty: false
				},
				files: [ {
				  cwd: "app/views",
				  src: "**/*.jade",
				  dest: "",
				  expand: true,
				  ext: ".html"
				} ]
			}
		},

		watch: {
			html: {
				files: 'app/**/*.jade',
				tasks: ['jade:compile'],
			}
		}



	});

    grunt.loadNpmTasks('grunt-contrib-connect');
	grunt.loadNpmTasks('grunt-contrib-jade');
	grunt.loadNpmTasks('grunt-contrib-watch');

	grunt.registerTask('default', ['connect:server', 'watch']);

};