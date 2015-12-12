
angular.module('stateeval.assignments')
    .config(configureRoutes);

function configureRoutes($stateProvider, $urlRouterProvider) {
    $stateProvider
        .state('assignments', {
            url: '/assignments/:evaluationtype',
            parent: 'left-navbar',
            views: {
                'content@base': {
                    templateUrl: 'app/assignments/views/assignments.html',
                    controller: 'assignmentsController as vm'
                }
            },
            resolve: {
                initModel: ['assignmentsModel', '$stateParams', function (assignmentsModel, $stateParams) {
                    return assignmentsModel.activate(parseInt($stateParams.evaluationtype));
                }],
                displayName: function($stateParams, enums) {
                    var evalType = parseInt($stateParams.evaluationtype);
                    return (evalType===enums.EvaluationType.PRINCIPAL)?"Principal Assignments":"Teacher Assignments";
                }
            },
            data: {
                title: 'Assignments',
                displayName: '{{displayName}}'
            }
        })
        .state('dte-request-assignment', {
            url: '/dte-request-assignment/',
            parent: 'da-base',
            views: {
                'content@base': {
                    templateUrl: 'app/assignments/views/dte-request-assignment.html',
                    controller: 'dteRequestAssignmentController as vm'
                }
            },
            data: {
                title: 'Request Assignments',
                displayName: 'Request Assignments'
            }
        });
}

