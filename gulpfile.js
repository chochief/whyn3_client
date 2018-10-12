var gulp = require('gulp');
var del = require('del');

/**
 * Web Server for Develop
 * gulp srv
 */
var browserSync = require('browser-sync');
var devsrv = {
    server: {
        baseDir: './dist/public'
    },
    ghostMode: false,
    tunnel: false,
    host: 'whyn.client',
    port: 6999,
    https: true,
    localOnly: true,
    logPrefix: 'whyn.client'
};
gulp.task('srv', function () {
    browserSync(devsrv);
});

/**
 * JADE
 * gulp jade
 */
jade = require('gulp-jade'),
gulp.task('jade', function () {
    return gulp.src('src/index.jade')
        .pipe(jade({
            locals: { lang: 'ru', l: 1 },
            pretty: true,
        }))
        // .pipe(rename('app-ru.php'))
        .pipe(gulp.dest('dist/public/'));
});

/**
 * SASS
 * gulp sass
 */
var sass = require('gulp-sass');
var autoprefixer = require('gulp-autoprefixer');
var cleanCSS = require('gulp-clean-css');
gulp.task('sass', function () {
    gulp.src('src/sass/style.sass')
        .pipe(sass())
        .pipe(autoprefixer('last 15 versions', '> 1%', 'ie 9'))
        .pipe(cleanCSS())
        .pipe(gulp.dest('dist/public/css/'))
        ;
});

/**
 * build\web\main.dart.js -> dist\public\bundle.js
 * gulp copy
 */
var rename = require("gulp-rename");
gulp.task('copy', function () {
    return gulp.src('build/web/main.dart.js')
        .pipe(rename('bundle.js'))
        .pipe(gulp.dest('dist/public/js'));
});

/**
 * Make browser js
 * gulp bjs
 */
var uglify = require('gulp-uglify');
gulp.task('bjs', function () {
    var options = {
        mangle: true,
    };
    gulp.src([
        'src/js-browser/modernizr.js',
        'src/js-browser/detectizr.js',
    ]).pipe(gulp.dest('dist/public/js'));
    return gulp.src(
        'src/js-browser/browser.js'
    )
    .pipe(uglify(options).on('error', function (e) {
        console.log(e);
    }))
    .pipe(gulp.dest('dist/public/js'));
});

/**
 * Make map js
 * gulp mjs
 */
var concat = require('gulp-concat');
gulp.task('mjs', function () {
    var options = {
        mangle: true,
    };
    return gulp.src([
        'src/js-map/a.js_',
        'src/js-map/*.js',
        'src/js-map/z.js_'
    ])
    .pipe(concat('map.js'))
    .pipe(uglify(options).on('error', function (e) {
        console.log(e);
    }))
    .pipe(gulp.dest('dist/public/js'));
});

/**
 * Uglify JS Дополнительные файлы на js
 * gulp jss
 */
// var uglify = require('gulp-uglify');
// gulp.task('jss', function () {
//     var options = {
//         mangle: true,
//     };
//     // del(['dist/public/js/bundle.js.map']);
//     return gulp.src('src/js/*.js')
//         .pipe(uglify(options).on('error', function (e) {
//             console.log(e);
//         }))
//         .pipe(gulp.dest('dist/public/js'));
// });

/**
 * TypeScript
 * gulp ts
 */
// var browserify = require('browserify');
// var source = require('vinyl-source-stream');
// var tsify = require('tsify');
// var sourcemaps = require('gulp-sourcemaps');
// var buffer = require('vinyl-buffer');
// gulp.task('ts', function () {
//     return browserify({
//         basedir: '.',
//         debug: true,
//         entries: ['src/ts/Main.ts'],
//         cache: {},
//         packageCache: {}
//     })
//         .plugin(tsify)
//         // .transform("babelify")
//         .transform('babelify', {
//             presets: ['es2015'],
//             extensions: ['.ts']
//         })
//         .bundle()
//         .pipe(source('bundle.js'))
//         .pipe(buffer())
//         .pipe(sourcemaps.init({ loadMaps: true }))
//         .pipe(sourcemaps.write('./'))
//         .pipe(gulp.dest('dist/public/js'));
// });

/**
 * Uglify JS
 * gulp js
 */
// var uglify = require('gulp-uglify');
// gulp.task('js', function () {
//     var options = {
//         mangle: true,
//     };
//     del(['dist/public/js/bundle.js.map']);
//     return gulp.src('dist/public/js/bundle.js')
//         .pipe(uglify(options).on('error', function(e){
//         	console.log(e);
//         }))
//         .pipe(gulp.dest('dist/public/js'));
// });

// gulp.task('default', ['copyHtml'], function () {
// gulp.task('default', function () {
//     return browserify({
//         basedir: '.',
//         debug: true,
//         entries: ['src/ts/Main.ts'],
//         cache: {},
//         packageCache: {}
//     })
//         .plugin(tsify)
//         // .transform("babelify")
//         .transform('babelify', {
//             presets: ['es2015'],
//             extensions: ['.ts']
//         })        
//         .bundle()
//         .pipe(source('bundle.js'))
//         .pipe(buffer())
//         .pipe(sourcemaps.init({ loadMaps: true }))
//         .pipe(sourcemaps.write('./'))
//         .pipe(gulp.dest('dist/public/js'));
// });

/**
 * WATCHER
 * gulp watch
 */
// gulp.task('watch', function () {
//     gulp.watch('src/sass/*.sass', ['sass']);
//     gulp.watch('src/ts/**', ['ts']);
//     gulp.watch('src/**/*.jade', ['jade']);
//     gulp.watch('src/*.jade', ['jade']);
// });

/**
 * Default task - выполнить все задачи develop
 * gulp
 */
// gulp.task('default',
//     [
//         'sass',
//         'ts',
//         'jade'
//     ]
// );
