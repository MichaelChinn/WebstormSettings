/**
 * Created by anne on 6/19/2015.
 */

angular.module('stateeval.student-growth-goals')
    .config(configureRoutes);

function configureRoutes($stateProvider, $urlRouterProvider) {

    $stateProvider
        .state('sg-goals', {
            url: '/sg-goals',
            abstract:true,
            parent: 'eval-base',

            views: {
                'content@base': {
                    templateUrl: 'app/student-growth-goals/views/goals.html',
                    controller: 'sgGoalsController as vm'
                }
            }
        })
        .state('sg-goals-private', {
            parent:'sg-goals',
            url: '/sg-goals-private',
            views: {
                'goals-private@sg-goals': {
                    controller: 'sgGoalsPrivateController as vm',
                    templateUrl: 'app/student-growth-goals/views/goals-private.html'
                }
            },
            data: {
                selectedTab: 0,
                title: 'Student Growth Goals',
                displayName: 'Build Goals'
            }
        })
        .state('sg-goals-submitted', {
            parent:'sg-goals',
            url: '/sg-goals-submitted',
            views: {
                'goals-submitted@sg-goals': {
                    controller: 'sgGoalsSubmittedController as vm',
                    templateUrl: 'app/student-growth-goals/views/goals-submitted.html'
                }
            },
            data: {
                selectedTab: 1,
                title: 'Student Growth Goals',
                displayName: 'Submitted Goals'
            }
        })
        .state('edit-goal-bundle', {
            url: '/edit-goal-bundle/:id',
            parent: 'sg-goals',
            views: {
                'content@base': {
                    templateUrl: 'app/student-growth-goals/views/edit-bundle.html',
                    controller: 'editBundleController as vm'
                }
            },
            data: {
                title: 'Edit Student Growth Goal',
                displayName: 'Edit Student Growth Goal'
            }
        })
        .state('sg-goal-bundle', {
            url: '/sg-goal-bundle/:id',
            abstract:true,
            parent: 'eval-base',
            resolve: {
                // has to be state framework to see student growth rubric rows
                changeFramework: function (activeUserContextService) {
                    activeUserContextService.setActiveFramework(
                        activeUserContextService.context.frameworkContext.stateFramework);
                }
            },
            views: {
                'content@base': {
                    templateUrl: 'app/student-growth-goals/views/bundle.html',
                    controller: 'sgGoalBundleController as vm'
                }
            },
            data: {
                displayName: 'Goals',
                breadcrumbProxy: 'sg-goals-private'
            }
        })
        .state('sg-bundle-setup', {
            parent:'sg-goal-bundle',
            url: '/sg-bundle-setup/:id',
            views: {
                'sg-bundle-setup@sg-goal-bundle': {
                    controller: 'sgBundleSetupController as vm',
                    templateUrl: 'app/student-growth-goals/views/sg-bundle-setup.html'
                }
            },
            resolve: {
                evidenceCollection: ['evidenceCollectionService', 'enums', '$stateParams', '$q', function (evidenceCollectionService, enums, $stateParams, $q) {
                    var bundleId = parseInt($stateParams.id);
                    if (bundleId==="-1") {
                        return $q.where(null);
                    }
                    else {
                    return evidenceCollectionService.getEvidenceCollection("SG GOAL BUNDLE", enums.EvidenceCollectionType.STUDENT_GROWTH_GOALS, bundleId)
                        .then(function (evidenceCollection) {
                            return evidenceCollection;
                        });
                    }
                }]
            },
            data: {
                selectedTab: 0,
                title: 'Student Growth Goal',
                displayName: 'Goal Setting'
            }
        })
        .state('sg-bundle-monitor', {
            parent:'sg-goal-bundle',
            url: '/sg-bundle-monitor/:id',
            views: {
                'sg-bundle-statement@sg-goal-bundle': {
                    controller: 'sgBundleMonitorController as vm',
                    templateUrl: 'app/student-growth-goals/views/sg-bundle-monitor.html'
                }
            },
            data: {
                selectedTab: 1,
                title: 'Student Growth Goal',
                displayName: 'Monitor Goal'
            }
        })
        .state('sg-bundle-review', {
            parent:'sg-goal-bundle',
            url: '/sg-bundle-score/:id/:rubricRowId',
            views: {
                'sg-bundle-score@sg-goal-bundle': {
                    controller: 'sgGoalScoreRubricRowController as vm',
                    templateUrl: 'app/student-growth-goals/views/sg-goal-score-rubricrow.html'
                }
            },
            resolve: {
                bundle: function (studentGrowthBuildService, $stateParams) {
                    return studentGrowthBuildService.getBundleById($stateParams.id)
                        .then(function (bundle) {
                            return bundle;
                        });
                }
            },
            data: {
                selectedTab: 2,
                title: 'Student Growth Goal',
                displayName: 'Review'
            }
        })


}

