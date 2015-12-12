/**
 * Created by anne on 9/14/2015.
 */
angular.module('stateeval.reports')
    .config(configureRoutes);

configureRoutes.$inject = ['$stateProvider'];

function configureRoutes($stateProvider, $urlRouterProvider) {
    $stateProvider
        .state('reports-home', {
            url: '/reports-home',
            parent: 'eval-base',
            abstract: true
        })
        .state('evaluatee-reports', {
            url: '/evaluatee-reports',
            parent: 'reports-home',
            views: {
                'content@base': {
                    templateUrl: 'app/reports/views/evaluatee-reports.html',
                    controller: 'evaluateeReportsController as vm'
                }
            }
        })
        .state('evaluator-reports', {
            url: '/evaluator-reports',
            parent: 'reports-home',
            views: {
                'content@base': {
                    templateUrl: 'app/reports/views/evaluator-reports.html',
                    controller: 'evaluatorReportsController as vm'
                }
            }
        })
        .state('summative-report', {
            url: '/summative-report',
            parent: 'reports-home',
            views: {
                'content@base': {
                    templateUrl: 'app/reports/views/summative-report.html',
                    controller: 'summativeReportController as vm'
                }
            }

});
}


