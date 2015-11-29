/**
 * Created by anne on 9/27/2015.
 */

angular.module('stateeval.school-admin')
    .config(configureRoutes);

function configureRoutes($stateProvider, $urlRouterProvider) {

    $stateProvider
        .state('sa-base', {
            abstract: true,
            url: '/sa-base',
            parent: 'rightInformationPanel'
        })
        .state('sa-dashboard', {
            url: '/sa-dashboard',
            parent: 'sa-base',
            views: {
                'content@base': {
                    templateUrl: 'app/school-admin/views/sa-dashboard.html',
                    controller: 'saDashboardController as vm'
                }
            },
            data: {
                title: 'School Admin Dashboard',
                displayName: 'School Admin Dashboard'
            }
        })
        .state('sa-assignments', {
            url: '/assignments/:evaluationtype',
            parent: 'ds-base',
            views: {
                'content@base': {
                    templateUrl: 'app/assignments/views/sa-assignments.html',
                    controller: 'assignmentsController as vm'
                }
            },
            data: {
                title: 'Assignments',
                displayName: 'Assignments'
            }
        })
}

