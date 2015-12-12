angular.module('stateeval.observation')
    .config(configureRoutes);

configureRoutes.$inject = ['$stateProvider'];

function configureRoutes($stateProvider, $urlRouterProvider) {
    $stateProvider
        .state('observation-home', {
            url: '/observation-home',
            parent: 'eval-base',
            abstract: true
        })
        .state('observations', {
            url: '/observations',
            parent: 'observation-home',
            views: {
                'content@base': {
                    templateUrl: 'app/observation/views/observation-list.html',
                    controller: 'observationListController as vm'
                }
            },
            data: {
                title: 'Observations',
                displayName: 'Observations'
            }
        })
        .state('observation', {
            url: '/observation/:evalSessionId',
            parent: 'observation-home',
            views: {
                'content@base': {
                    templateUrl: 'app/observation/views/observation-base.html',
                    controller: 'observationBaseController as vm'
                }
            },
            resolve: {
                evidenceCollection: ['evidenceCollectionService', 'enums', '$stateParams', function (evidenceCollectionService, enums, $stateParams) {
                    return evidenceCollectionService.getEvidenceCollection("OBSERVATION", enums.EvidenceCollectionType.OBSERVATION, parseInt($stateParams.evalSessionId))
                        .then(function (evidenceCollection) {
                            return evidenceCollection;
                        }
                    )
                }]
            },
            data: {
                title: 'Observeation/Score',
                displayName: 'Observation/Score'
            },
            abstract: true
        })
        .state("observation.setup",
        {
            url: '/setup',
            parent: 'observation',
            views: {
                'content@observation': {
                    templateUrl: 'app/observation/views/observation-setup.html',
                    controller: 'observationSetupController as vm'
                }
            }
        })
        .state("observation.observation",
        {
            url: '/observation',
            parent: 'observation',
            views: {
                'content@observation': {
                    templateUrl: 'app/observation/views/observation.html',
                    controller: 'observationController as vm'
                }
            },
            data: {
                title: 'Observeation/Score',
                displayName: 'Observation/Score'
            }
        })
        .state('observation.preconference', {
            url: '/preconference',
            parent: 'observation',
            views: {
                'content@observation': {
                    templateUrl: 'app/observation/views/pre-conference.html',
                    controller: 'preConferenceController as vm'
                }
            }
        })
        .state('observation.preconferenceteacher', {
            url: '/preconferenceteacher',
            parent: 'observation',
            views: {
                'content@observation': {
                    templateUrl: 'app/observation/views/pre-conference-teacher.html',
                    controller: 'preConferenceTeacherController as vm'
                }
            }
        })
        .state('observation.postconference', {
            url: '/postconference',
            parent: 'observation',
            views: {
                'content@observation': {
                    templateUrl: 'app/observation/views/post-conference.html',
                    controller: 'postConferenceController as vm'
                }
            }
        })
        .state('observation.artifacts', {
            url: '/artifacts',
            parent: 'observation',
            views: {
                'content@observation': {
                    templateUrl: 'app/observation/views/artifacts.html',
                    controller: 'observationArtifactController as vm'
                }
            }
        });
}

