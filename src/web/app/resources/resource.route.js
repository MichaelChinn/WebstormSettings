(function () {
    'use strict';

    angular.module('stateeval.resource')
        .config(configureRoutes);

    configureRoutes.$inject = ['$stateProvider'];

    function configureRoutes($stateProvider) {

        $stateProvider
            .state('resource-home', {
                url: '/resource-home',
                abstract: true,
                parent: 'da-base',
                resolve: {
                    resource: ['resourceService', function(resourceService) {
                        return resourceService.activate();
                    }]
                }
            })
            .state('resource-list', {
                url: '/resource-list',
                parent: 'resource-home',
                views: {
                    'content@base': {
                        templateUrl: 'app/resources/views/resource-list.html',
                        controller: 'resourceListController as vm'
                    }

                },
                data: {
                    displayName: 'Resources'
                }
            })
            .state('resource-builder', {
                url: '/resource-builder',
                parent: 'resource-home',
                views: {
                    'content@base': {
                        templateUrl: 'app/resources/views/resource-builder.html',
                        controller: 'resourceBuilderController as vm'
                    }
                }
            });

    }
})();