/**
 * Created by anne on 6/19/2015.
 */
(function () {
    'use strict';

    angular
        .module('stateeval.core', [
            'blocks.exception',
            'blocks.logger',
            'ui.router',                    // Routing
            'ui.bootstrap',                  // Angular Bootstrap
            'lodash',
            'summernote',                    // wysiwyg editor
            'ngResource',                    // $resource
            'ngAnimate',
            'angular-confirm',
            'angularUtils.directives.uiBreadcrumbs',
            'inspinia',
            'LocalStorageModule',
            'kendo.directives',
            'checklist-model',
            'ngCookies',
            'ngMessages',
            'ya.nouislider'
        ]);
})();

