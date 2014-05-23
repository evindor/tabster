var gulp = require("gulp"),
	browserify = require("gulp-browserify"),
	rename = require("gulp-rename");

gulp.task('build:content', function() {
	gulp.src('extension/content.coffee', {read: false})
		.pipe(browserify({
			transform: ['coffeeify'],
			extensions: ['.coffee']
		}))
		.pipe(rename('content.js'))
		.pipe(gulp.dest('build/'));
})

gulp.task('build:bg', function() {
	gulp.src('extension/background.coffee', {read: false})
		.pipe(browserify({
			transform: ['coffeeify'],
			extensions: ['.coffee']
		}))
		.pipe(rename('background.js'))
		.pipe(gulp.dest('build/'));
})

gulp.task('copy', function() {
	gulp.src([
		'extension/manifest.json',
		'extension/content.css',
		'extension/doc.png',
		'extension/icon128.png'])
		.pipe(gulp.dest('build/'));
})

gulp.task('build', ['build:content', 'build:bg', 'copy']);
