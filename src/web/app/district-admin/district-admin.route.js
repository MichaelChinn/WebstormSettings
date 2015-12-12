/**
 * Created by anne on 6/19/2015.
 */
(function () {
    'use strict';
    angular.module('stateeval.district-admin')
        .config(configureRoutes);

    configureRoutes.$inject = ['$stateProvider'];

    function configureRoutes($stateProvider) {

        $stateProvider
            .state('da-base', {
                abstract: true,
                url: '/da-base',
                parent: 'rightInformationPanel'
            })
            .state('da-dashboard', {
                url: '/da-dashboard',
                parent: 'da-base',
                views: {
                    'content@base': {
                        templateUrl: 'app/district-admin/views/da-dashboard.html',
                        controller: 'daDashboardController as vm'
                    }
                },
                data: {
                    title: 'Dashboard',
                    displayName: 'Dashboard'
                }
            })
            .state('select-framework', {
                url: '/select-framework/:evaluationtype',
                parent: 'da-base',
                views: {
                    'content@rightInformationPanel': {
                        controller: 'selectFrameworkController as vm',
                        templateUrl: 'app/district-admin/views/select-framework.html'
                    },
                    'rightInformationPanel@rightInformationPanel': {
                        templateUrl: 'app/district-admin/views/select-framework-information.html'
                    }
                }
            })
            .state('impersonation', {
                url: '/impersonation',
                parent: 'left-navbar',
                views: {
                    'content@base': {
                        templateUrl: 'app/district-admin/views/impersonation.html'
                    }
                },
                data: {
                    title: 'Evaluations'
                }
            })
            .state('modify-framework', {
                url: '/modify-framework/',
                parent: 'left-navbar',
                views: {
                    'content@base': {
                        templateUrl: 'app/district-admin/views/modify-framework.html',
                        controller: 'modifyFrameworkController as vm'
                    }
                },
                data: {
                    displayName: 'Modify Framework'
                }
            });


    }
    /*
     .state('edit-framework', {
     url: '/edit-framework',
     parent: 'da-base',
     views: {
     'content@rightInformationPanel': {
     controller: 'editFrameworkController as vm',
     templateUrl: 'app/district-admin/views/edit-framework.html'
     },
     'rightInformationPanel@rightInformationPanel': {
     templateUrl: 'app/district-admin/views/edit-framework-information.html'
     }
     }
     })
     */
}) ();

