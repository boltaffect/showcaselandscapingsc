module.exports = function(grunt) {

    grunt.initConfig({
		serve: {
			options: {
				port: 8001
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
		}



	});

    grunt.loadNpmTasks('grunt-serve');
	grunt.loadNpmTasks('grunt-contrib-jade');
};