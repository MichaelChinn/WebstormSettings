module.exports = function(config) {
    config.set({

        basePath: './',

        frameworks: ['jasmine', 'sinon'],

        files: [
            './lib/jquery/dist/jquery.js',
            './lib/angular/angular.js',
            './lib/angular-toastr/dist/angular-toastr.js',
            './lib/angular-ui-router/release/angular-ui-router.js',
            './lib/angular-bootstrap/ui-bootstrap.js',
            './lib/lodash/lodash.js',
            './lib/angular-lodash-module/angular-lodash-module.js',
            './lib/angular-summernote/dist/angular-summernote.js',
            './lib/angular-resource/angular-resource.js',
            './lib/angular-animate/angular-animate.js',
            './lib/angular-confirm/confirm.js',
            './lib/angular-utils-ui-breadcrumbs/uiBreadcrumbs.js',
            './lib/inspinia/js/module.js',
            './lib/inspinia/js/directives.js',
            './lib/angular-local-storage/dist/angular-local-storage.js',
            './lib/kendo/kendo.all.min.js',
            './lib/checklist-model/checklist-model.js',
            './lib/angular-cookies/angular-cookies.js',

            './node_modules/sinon/pkg/sinon.js',
            './node_modules/bardjs/dist/bard.js',

            './node_modules/angular-mocks/angular-mocks.js',

            './test-helpers/test-helper.js',
            './test-helpers/modalInstanceSpy.js',
            './app/core/core.module.js',
            './app/core/config.js',

            './app/blocks/logger/logger.module.js',
            './app/blocks/logger/logger.js',

            './app/blocks/exception/exception.module.js',
            './app/blocks/exception/exception.js',
            './app/blocks/exception/exception-handler.provider.js',

            './app/core/services/authentication.service.js',
            './app/core/services/evaluation.service.js',
            './app/core/services/user.service.js',
            './app/core/services/framework.service.js',
            './app/core/services/work-area.service.js',
            './app/core/services/active-user-context.service.js',
            './app/core/services/rubric.utils.service.js',
            './app/core/services/utils.service.js',
            './app/core/services/location.service.js',

            './app/assignments/assignments.module.js',
            './app/assignments/services/assignments.service.js',
            './app/assignments/services/assignments-model.service.js',
            './app/assignments/services/assignments-model.service.spec.js',

         /*
            './app/blocks/exception/exception-handler.provider.spec.js',
            './app/core/services/user.service.spec.js',*/


            './app/**/*.html'
        ],

        exclude: [
        ],

        preprocessors: {
            'src/**/*.html': ['ng-html2js'],
            'src/**/!(*.mock|*.spec).js': ['coverage']
        },

        ngHtml2JsPreprocessor: {
            // strip this from the file path
            stripPrefix: 'src/',
            // create a single module that contains templates from all the files
            moduleName: 'templates'
        },

        reporters: ['progress', 'coverage'],

        coverageReporter: {
            type : 'html',
            // output coverage reports
            dir : 'coverage/'
        },

        port: 9876,

        colors: true,

        logLevel: config.LOG_DEBUG,

        autoWatch: true,

        browsers: ['Chrome'],

        singleRun: false
    });
};
