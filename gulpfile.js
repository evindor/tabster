var gulp = require("gulp"),
	browserify = require("gulp-browserify");

gulp.task('build:content', function() {
	gulp.src('extension/content.coffee')
		.pipe(browserify({
			transform: ['coffeeify'],
			extensions: ['.coffee']
		}))
		.pipe(gulp.dest('build/'))
})

gulp.task('copy', function() {
	gulp.src(['extension/manifest.json', 'extension/content.css'])
		.pipe(gulp.dest('build/'));
})

gulp.task('build', ['build:content', 'copy']);
