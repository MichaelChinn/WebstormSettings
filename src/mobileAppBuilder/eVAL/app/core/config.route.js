(function () {
    "use strict";
    var core = angular.module('stateeval.core');

    core.config(configureRoutes);

    configureRoutes.$inject = ['$stateProvider', '$urlRouterProvider', '$httpProvider'];
    function configureRoutes($stateProvider, $urlRouterProvider, $httpProvider) {

        $urlRouterProvider.otherwise('/login');

        $stateProvider
            //Error states
            // todo: create custom page for these
            .state('404', {
                url: '/404',
                templateUrl: 'app/core/views/404.html'
            })
            .state('no-frameworks', {
                url: '/no-frameworks',
                templateUrl: 'app/core/views/no-frameworks.html'
            })
            .state('server-error', {
                url: '/server-error',
                templateUrl: 'app/core/views/server-error.html'
            })
            .state('login', {
                url: '/login',
                controller: 'loginController',
                templateUrl: 'app/login/login.html',
                controllerAs: 'vm'
            })
            .state('base', {
                abstract: true,
                templateUrl: 'app/core/views/base.html',
                controller: 'baseController as vm',
                resolve: {
                    activeUserContext: ['startupService', function (startupService) {
                        return startupService.load();
                    }]
                }
            })
            .state('left-navbar', {
                parent: 'base',
                abstract: true,
                views: {
                    'left-navbar@base': {
                        templateUrl: 'app/layout/views/left-navbar.html',
                        controller: 'leftNavbarController as vm'
                    }
                }
            })
            .state('rightInformationPanel', {
                abstract: true,
                parent: 'left-navbar',
                views: {
                    'content@base': {
                        templateUrl: 'app/layout/views/rightInformationPanel.html'
                    }
                }
            })
            .state('eval-base', {
                abstract: true,
                parent: 'rightInformationPanel',
                views: {
                    'eval-profile@base': {
                        templateUrl: 'app/layout/views/evaluating-user-profile.html',
                        controller: 'evaluatingUserProfileController as vm'
                    }
                }
            })
            .state('generic-dashboard', {
                parent: 'left-navbar',
                views: {
                    'content@base': {
                        templateUrl: 'app/core/views/generic-dashboard.html',
                        controller: 'genericDashboardController as vm'
                    }
                },
                data: {
                    title: 'WELCOME',
                    displayName: 'WELCOME'
                }
            })
            .state('VOID', {});

        $httpProvider.interceptors.push('apiInterceptor');
    }

})();