/**
 * Created by anne on 10/6/2015.
 */
/**
 * Created by anne on 6/19/2015.
 */
angular.module('stateeval.student-growth-admin')
    .config(configureRoutes);

function configureRoutes($stateProvider, $urlRouterProvider) {

    $stateProvider
        .state('setup-student-growth', {
            url: '/setup-student-growth/:evaluationtype',
            parent: 'left-navbar',
            views: {
                'content@base': {
                    controller: 'setupStudentGrowthController as vm',
                    templateUrl: 'app/student-growth-admin/views/setup-student-growth.html'
                }
            },
            resolve: {
                displayName: function($stateParams, enums) {
                    var evalType = parseInt($stateParams.evaluationtype);
                    return (evalType===enums.EvaluationType.PRINCIPAL)?"Principal Student Growth Goals Setup":"Teacher Student Growth Goals Setup";
                }
            },
            data: {
                title: 'Student Growth Goal Planning Configuration',
                displayName: '{{displayName}}'
            }
        })

}


