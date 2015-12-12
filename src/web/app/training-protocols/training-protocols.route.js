(function() {
 'use strict';

    angular.module('stateeval.training-protocols')
        .config(configureRoutes);

    configureRoutes.$inject = ['$stateProvider'];

    function configureRoutes($stateProvider, $urlRouterProvider) {
        $stateProvider
            .state('training-protocols-home', {
                url: '/training-protocols-home',
                parent: 'eval-base',
                abstract: true
            })

            .state('training-protocols', {
                url: '/training-protocols',
                parent: 'training-protocols-home',
                views: {
                    'content@base': {
                        templateUrl: 'app/training-protocols/views/training-protocol-list.html',
                        controller: 'trainingProtocolListController as vm'
                    }
                },
                data: {
                    title: 'Training Protocols',
                    displayName: 'Training Protocols'
                }
            })
            .state('training-protocol', {
                url: '/training-protocol/:id',
                parent: 'training-protocols-home',
                views: {
                    'content@base': {
                        templateUrl: 'app/training-protocols/views/training-protocol.html',
                        controller: 'trainingProtocolController as vm'
                    }
                },
                data: {
                    title: 'Training Protocol',
                    displayName: 'Training Protocol'
                }
            })

    }
})();
