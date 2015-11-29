(function () {
    'use strict';

    angular.module('stateeval.video-library')
        .config(configureRoutes);

    configureRoutes.$inject = ['$stateProvider'];

    function configureRoutes($stateProvider) {

    $stateProvider
        .state('video-library-base', {
            url: '/video-library-base',
            parent: 'left-navbar',
            abstract: true
        })
        .state('video-list', {
            url: '/video-list',
            parent: 'video-library-base',
            views: {
                'content@base': {
                    templateUrl: 'app/video-library/views/video-list.html',
                    controller: 'videoListController as vm'
                }
            },
            data: {
                displayName: 'Video Library'
            }
        });
    }
})();