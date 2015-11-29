(function () {
    'use strict';

    angular.module('stateeval.artifact')
        .config(configureRoutes);

    configureRoutes.$inject = ['$stateProvider', '$urlRouterProvider'];

    function configureRoutes($stateProvider, $urlRouterProvider) {

        $stateProvider
            .state('artifacts', {
                url: '/artifacts',
                abstract:true,
                parent: 'eval-base',
                views: {
                    'content@base': {
                        templateUrl: 'app/artifacts/views/artifacts.html',
                        controller: 'artifactsController as vm'
                    }
                }
            })
            .state('artifacts-private', {
                parent:'artifacts',
                url: '/artifacts-private',
                views: {
                    'artifacts-private@artifacts': {
                        controller: 'artifactsPrivateController as vm',
                        templateUrl: 'app/artifacts/views/artifacts-private.html'
                    }
                },
                data: {
                    selectedTab: 0,
                    title: 'Artifacts',
                    displayName: 'Private Artifacts'
                }
            })
            .state('artifacts-submitted', {
                parent:'artifacts',
                url: '/artifacts-submitted',
                views: {
                    'artifacts-submitted@artifacts': {
                        controller: 'artifactsSubmittedController as vm',
                        templateUrl: 'app/artifacts/views/artifacts-submitted.html'
                    }
                },
                data: {
                    selectedTab: 1,
                    title: 'Artifacts',
                    displayName: 'Submitted as Evidence'
                }
            })
            .state('other-evidence', {
                parent:'eval-base',
                url: '/other-evidence',
                views: {
                    'content@base': {
                        controller: 'otherEvidenceController as vm',
                        templateUrl: 'app/artifacts/views/other-evidence.html'
                    }
                },
                resolve: {
                  evidenceCollection: ['evidenceCollectionService', 'enums', function (evidenceCollectionService, enums) {
                      return evidenceCollectionService.getEvidenceCollection("OTHER EVIDENCE",
                                                        enums.EvidenceCollectionType.OTHER_EVIDENCE)
                          .then(function (evidenceCollection) {
                              return evidenceCollection;
                          }
                      )
                  }]
                },
                data: {
                    title: 'Other Evidence',
                    displayName: 'Other Evidence'
                }
            })
            .state('artifacts-rejected', {
                parent:'artifacts',
                url: '/artifacts-returned',
                views: {
                    'artifacts-rejected@artifacts': {
                        controller: 'artifactsRejectedController as vm',
                        templateUrl: 'app/artifacts/views/artifacts-rejected.html'
                    }
                },
                data: {
                    selectedTab: 3,
                    title: 'Artifacts',
                    displayName: 'Request for Further Input'
                }
            })
            // duplicate to get breadcrumbs to work from multiple sources
            .state('artifact-builder-rejected', {
                url: '/artifact-builder:artifactId',
                parent: 'artifacts-rejected',
                views: {
                    'content@base': {
                        templateUrl: 'app/artifacts/views/artifact-builder.html',
                        controller: 'artifactBuilderController as vm'
                    }
                },
                data: {
                    title: 'Edit Artifact',
                    displayName: 'Edit Artifact'
                }
            })
            .state('artifact-builder', {
                url: '/artifact-builder:artifactId',
                parent: 'artifacts-private',
                views: {
                    'content@base': {
                        templateUrl: 'app/artifacts/views/artifact-builder.html',
                        controller: 'artifactBuilderController as vm'
                    }
                },
                data: {
                    title: 'Edit Artifact',
                    displayName: 'Edit Artifact'
                }
            })
            .state('submitted-artifact-summary', {
                url: '/submitted-artifact-summary/{artifactId}',
                parent: 'artifacts-submitted',
                resolve: {
                    artifact: function(artifactService, $stateParams) {
                        return artifactService.getArtifactById($stateParams.artifactId)
                            .then(function(artifact) {
                                return artifact;
                            });
                    }
                },
                views: {
                    'content@base': {
                        templateUrl: 'app/artifacts/views/submitted-artifact-summary.html',
                        controller: 'submittedArtifactSummaryController as vm'
                    }
                },
                data: {
                    title: 'Artifact Summary',
                    displayName: 'Artifact Summary'
                }
            })
    }
})();