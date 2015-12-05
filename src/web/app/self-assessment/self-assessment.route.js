angular.module('stateeval.self-assessment')
    .config(configureRoutes);

configureRoutes.$inject = ['$stateProvider'];

function configureRoutes($stateProvider, $urlRouterProvider) {
    $stateProvider
        .state('self-assessment-home', {
            url: '/self-assessment-home',
            parent: 'eval-base',
            abstract: true
        })
        .state('self-assessments', {
            url: '/self-assessments',
            parent: 'self-assessment-home',
            views: {
                'content@base': {
                    templateUrl: 'app/self-assessment/views/self-assessment-list.html',
                    controller: 'selfAssessmentListController as vm'
                }
            },
            data: {
                title: 'Self-Assessments',
                displayName: 'Self-Assessments'
            }
        })
        .state('self-assessment', {
            url: '/self-assessment/:id',
            parent: 'self-assessment-home',
            views: {
                'content@base': {
                    templateUrl: 'app/self-assessment/views/self-assessment.html',
                    controller: 'selfAssessmentController as vm'
                }
            },
            resolve: {
                evidenceCollection: ['evidenceCollectionService', 'enums', '$stateParams', function (evidenceCollectionService, enums, $stateParams) {
                    return evidenceCollectionService.getEvidenceCollection("SELF-ASSESSMENT", enums.EvidenceCollectionType.SELF_ASSESSMENT, parseInt($stateParams.id))
                        .then(function (evidenceCollection) {
                            return evidenceCollection;
                        }
                    )
                }]
            },
            data: {
                title: 'Self-Assessment/Score',
                displayName: 'Self-Assessment/Score'
            }
        })
}


