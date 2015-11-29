/**
 * Created by anne on 11/3/2015.
 */
angular.module('stateeval.summative-eval')
    .config(configureRoutes);

function configureRoutes($stateProvider, $urlRouterProvider) {

    $stateProvider

        .state('summative-eval', {
            url: '/summative-eval',
            parent: 'left-navbar',
            views: {
                'content@base': {
                    controller: 'summativeEvalController as vm',
                    templateUrl: 'app/summative-eval/views/summative-eval.html'
                }
            },
            resolve: {
                evidenceCollection: ['evidenceCollectionService', 'enums', function (evidenceCollectionService, enums) {
                    return evidenceCollectionService.getEvidenceCollection("SUMMATIVE", enums.EvidenceCollectionType.SUMMATIVE)
                        .then(function (evidenceCollection) {
                            return evidenceCollection;
                        }
                    )
                }]
            },
            data: {
                title: 'Summative Evaluation',
                displayName: 'Summative Evaluation'
            }
        });

}
