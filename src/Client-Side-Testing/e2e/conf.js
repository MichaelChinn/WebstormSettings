//var ScreenShotReporter = require('protractor-screenshot-reporter');
exports.config = {
    allScriptsTimeout: 11000,
    specs: [
        '*.js'
    ],
    capabilities: {
        'browserName': 'chrome'
    },
    chromeOnly: true,
    baseUrl: 'http://localhost/',
    framework: 'jasmine2',

    jasmineNodeOpts: {
        defaultTimeoutInterval: 30000
    },

    onPrepare: function() {
        // Add a screenshot reporter and store screenshots to `/tmp/screnshots`:
        //jasmine.getEnv().addReporter(new ScreenShotReporter({
        //    baseDirectory: '/tmp/screenshots', takeScreenShotsOnlyForFailedSpecs: true
        //}));
    }

    //framework: 'jasmine2',
    //seleniumAddress: 'http://localhost:4444/wd/hub',
    //specs: ['spec.js']
}