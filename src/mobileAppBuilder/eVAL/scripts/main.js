(function () {

    require.config({
        paths: {
            jquery: '../scripts/lib/jquery.min',
            kendo: '../scripts/lib/kendo.mobile.min',
            app: '../scripts/app',
            layouts: '../scripts/layouts',
            views: '../scripts/views',
            models: '../scripts/models',
            drawers: '../scripts/drawers',
            amplify: '../scripts/lib/amplify.min',
            text: '../scripts/lib/text'
        },
        // The shim config allows us to configure dependencies for
        // scripts that do not call define() to register a module
        shim: {
            kendo: {
                deps: ['jquery']
            },
            amplify: {
                deps: ['jquery'],
                exports: 'amplify'
            }
        }
    });

    require(['app', 'kendo'],
    function (app, kendo) {
        app.init();
    });

})();
