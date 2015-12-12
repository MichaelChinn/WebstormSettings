(function () {
    "use strict";
    var core = angular.module('stateeval.layout');

    core.config(configureRoutes);

    configureRoutes.$inject = ['$stateProvider', '$urlRouterProvider', '$httpProvider'];
    function configureRoutes($stateProvider, $urlRouterProvider, $httpProvider) {

        $stateProvider
            .state('evaluator-dashboard', {
                url: '/evaluator-dashboard',
                parent: 'eval-base',
                views: {
                    'content@base': {
                        templateUrl: 'app/layout/views/evaluator-dashboard.html',
                        controller: 'evaluatorDashboardController as vm'
                    }
                },

                data: {
                    title: 'Evaluator Dashboard',
                    displayName: 'Dashboard'
                }
            })
            .state('evaluatee-dashboard', {
                url: '/evaluatee-dashboard',
                abstract: true,
                parent: 'eval-base',
                views: {
                    'content@base': {
                        templateUrl: 'app/layout/views/evaluatee-dashboard.html',
                        controller: 'evaluateeDashboardController as vm'
                    }
                },
                resolve: {
                    artifacts: ['artifactService', 'activeUserContextService', 'enums', function (artifactService, activeUserContextService, enums) {
                        return artifactService.getArtifactBundlesForEvaluation(artifactService.newArtifactBundleRequest(enums.WfState.ARTIFACT_SUBMITTED, activeUserContextService.user.id))
                            .then(function (artifacts) {
                                return artifacts;
                            })
                    }]
                },
                data: {
                    title: 'Evaluatee Dashboard',
                    displayName: 'Dashboard'
                }
            })
            .state('dv-dashboard', {
                url: '/dv-dashboard',
                parent: 'left-navbar',
                views: {
                    'content@base': {
                        templateUrl: 'app/layout/views/dv-dashboard.html'
                    }
                },
                data: {
                    title: 'Dashboard'
                }
            })
            .state('evaluatee-notifications', {
                parent:'evaluatee-dashboard',
                url: '/evaluatee-notifications',
                views: {
                    'notifications@evaluatee-dashboard': {
                        controller: 'notificationsController as vm',
                        templateUrl: 'app/layout/views/notifications.html'
                    }
                },
                data: {
                    'selectedTab': 0
                }
            })
            .state('evaluatee-recent', {
                parent:'evaluatee-dashboard',
                url: '/evaluatee-recent',
                views: {
                    'recent@evaluatee-dashboard': {
                        controller: 'recentlyWorkedOnController as vm',
                        templateUrl: 'app/layout/views/recently-worked-on.html'
                    }
                },
                data: {
                    'selectedTab': 1
                }
            })
            .state('evaluatee-general', {
                parent:'evaluatee-dashboard',
                url: '/evaluatee-general',
                views: {
                    'general@evaluatee-dashboard': {
                        controller: 'generalInfoController as vm',
                        templateUrl: 'app/layout/views/general-info.html'
                    }
                },
                data: {
                    'selectedTab': 2
                }
            })
            .state('evaluatee-coverage', {
                parent:'evaluatee-dashboard',
                url: '/evaluatee-coverage',
                views: {
                    'coverage@evaluatee-dashboard': {
                        controller: 'evaluateeCoverageController as vm',
                        templateUrl: 'app/layout/views/evaluatee-coverage.html'
                    }
                },
                data: {
                    'selectedTab': 3
                }
            })
            //todo why does reloading FEV default to Notifications tab
            .state('evaluatee-framework', {
                parent:'evaluatee-dashboard',
                url: '/evaluatee-framework',
                views: {
                    'framework@evaluatee-dashboard': {
                        controller: 'frameworkEvidenceViewController as vm',
                        templateUrl: 'app/layout/views/framework-evidence-view.html'
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
                    'selectedTab': 4
                }
            })
    }

})();