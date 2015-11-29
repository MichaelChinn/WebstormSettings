(function () {
    'use strict';

    angular
        .module('stateeval.layout')
        .controller('evaluatorDashboardController', evaluatorDashboardController);

    evaluatorDashboardController.$inject = ['config', 'enums', 'activeUserContextService', 'utils',
        '$sce', 'notificationService', 'artifactService', 'evalSessionService', 'userActivityService',
        '$state', '$window', 'rubricRowEvaluationService', 'evidenceCollectionService'];

    /* @ngInject */
    function evaluatorDashboardController(config, enums, activeUserContextService, utils,
          $sce, notificationService, artifactService, evalSessionService, userActivityService,
          $state, $window, rubricRowEvaluationService, evidenceCollectionService) {
        var vm = this;
        //vm.testRow = activeUserContextService.context.framework.frameworkNodes[0].rubricRows[0];

        vm.rubricRowIdsByEvaluationId = null;
        vm.context = activeUserContextService.context;

        var data = {
            rubricRowEvaluations: [],
            availableEvidence: [],
            rubricRowScores:[],
            frameworkNodeScores: []

        };

        //console.log('evaluator dash');
        vm.selection = 'all';
        vm.evaluatees = [];
        vm.activeEvaluatee = null;
        vm.showEvaluateeTab = false;
        vm.defaultTabHeading = '';
        vm.evaluateeDisplayName = '';
        vm.evaluatee = null;
        vm.evaluateeTitle = '';

        // NOTE: was getting odd error about tab active expression not being assignable when I
        // used vm.evaluate != null, but it seems to work when I use single variable.
        vm.evaluateeIsNotNull = true;

        vm.setActiveEvaluatee = setActiveEvaluatee;
        vm.evaluateePlanType = evaluateePlanType;
        vm.evaluateeFocus = evaluateeFocus;
        vm.alignmentToString = artifactService.alignmentToString;
        vm.fromUseIn = fromUseIn;

        vm.recentItems = {};
        vm.evaluateeToEvaluatorNotifications = [];
        vm.evaluatorToEvaluateeNotifications = [];
        vm.evalSessions = [];
        vm.getAssignedEvaluatorDisplayName = getAssignedEvaluatorDisplayName;
        vm.observationsSummary = observationsSummary;
        vm.observationCriteriaCoverage = observationCriteriaCoverage;
        vm.getRecentActivities = [];
        vm.gotoActivity = gotoActivity;
        vm.chooseSingle = chooseSingle;
        vm.viewAll = viewAll;

        vm.rrEvalsGroupByEvalId = null;
        ////////////////////////////

        activate();

        function activate() {

            rubricRowEvaluationService.getRubricRowEvaluationsForPR_TR(activeUserContextService.user)
                .then(function(rrEvals) {
                    vm.rrEvalsGroupByEvalId = _.groupBy(rrEvals, 'id');
                    for (var evalId in vm.rrEvalsGroupByEvalId) {
                        vm.rrEvalsGroupByEvalId[evalId] = _.pluck(vm.rrEvalsGroupByEvalId[evalId], 'rubricRowId');
                    }
                });

            vm.evaluateeTitle = activeUserContextService.getEvaluateeTermUpperCase();
            vm.defaultTabHeading = 'All ' + activeUserContextService.getEvaluateeTermUpperCase() + 's';
            vm.evaluatees = activeUserContextService.getEvaluateesForActiveUser(true);
            vm.activeEvaluatee = activeUserContextService.context.evaluatee;
            vm.showEvaluateeTab = vm.activeEvaluatee != null;
            if (vm.activeEvaluatee) {
                vm.evaluatee = vm.activeEvaluatee;
            }

            notificationService.getNotificationWorkedOn()
                .then(function(notifications) {
                vm.recentItems = notifications;
            });

            if (activeUserContextService.context.evaluatee!=null) {
                vm.evaluateeDisplayName = activeUserContextService.context.evaluatee.displayName;
                notificationService.getNotificationsToTorFromTee()
                    .then(function (notifications) {
                        vm.evaluateeToEvaluatorNotifications = notifications;
                    });

                //notificationService.getNotificationsToActiveEvaluateeFromActiveEvaluator()
                //    .then(function (notifications) {
                //        vm.evaluatorToEvaluateeNotifications = notifications;
                //    });

                
            }

            userActivityService.getRecentActivities().then(function (recentActivities) {
                vm.getRecentActivities = recentActivities;
            });

            vm.evaluateeIsNotNull = vm.evaluatee != null;

            evalSessionService.getEvalSessionsForSchool(activeUserContextService.getActiveSchoolCode())
                .then(function(sessions) {
                    vm.evalSessions = sessions;
                });
        }

        function getAssignedEvaluatorDisplayName(evaluatee) {
            var evaluatorId = evaluatee.evalData.evaluatorId;
            var currentUser = activeUserContextService.getActiveUser();

            if (evaluatorId === null) {
                return $sce.trustAsHtml('<span class="label label-warning">NOT SET</span>');
            }
            else if (evaluatorId === currentUser.id) {
                return $sce.trustAsHtml(currentUser.displayName);
            }
            else {
                // todo: look up other evaluators
                return $sce.trustAsHtml("todo");
            }
        }

        function fromUseIn(notification) {
            /* TODO: how to handle artifacts that are attached to observations
            switch(eventType) {
                case enums.EventType.OBSERVATION_CREATED:
                    return "Obs";
                case enums.EventType.ARTIFACT_REJECTED:
                case enums.EventType.ARTIFACT_SUBMITTED:
                    var artifact = null;

                default:
                    return "UNK";
            }
            return utils.mapEventTypeToItemType(notification.eventType);
            */
        }

        function observationsSummary(evaluatee) {
            var observations = [];
            vm.evalSessions.forEach(function(s) {
                if (s.evaluateeId == evaluatee.id) {
                    observations.push(s);
                }
            });

            return observations.length;
        }

        function observationCriteriaCoverage(evaluatee) {
            var criteria = '';
            vm.evalSessions.forEach(function(s) {
                if (s.evaluateeId == evaluatee.id) {
                    if (s.rubricRows!=null) {
                        s.rubricRows.forEach(function (rr) {
                            criteria += rubricUtils.getFrameworkNodeForRubricRowId(
                                activeUserContextService.getActiveFramework().frameworkNodes,
                                rr.Id).shortName;
                            criteria += ' ';
                        })
                    }
                }
            });

            return criteria;
        }

        function evaluateeFocus(evaluatee) {
           return $sce.trustAsHtml(utils.mapEvaluationFocusForUserToString(activeUserContextService, evaluatee));
        }

        function evaluateePlanType(evaluatee) {
            var retval = "";
            if (evaluatee.evalData.planType === enums.EvaluationPlanType.COMPREHENSIVE) {
                retval = "Comprehensive"
            }
            else if (evaluatee.evalData.planType === enums.EvaluationPlanType.FOCUSED) {
                retval = "Focused " + utils.mapEvaluationFocusForUserToString(activeUserContextService, evaluatee);
            }
            else {
                    retval = '<span class="label label-warning"> NOT SET</span>';
                }

            return $sce.trustAsHtml(retval);
        }


        function setActiveEvaluatee(evaluatee) {
            activeUserContextService.setActiveEvaluatee(evaluatee);
        }

        function gotoActivity(item) {
            $window.location.href = item.url;
        }
        function chooseSingle(index) {
            vm.context.evaluatee = vm.context.evaluatees[index];
            vm.selection = 'single';
        }
        function viewAll() {
            vm.context.evaluatee = null;
            vm.selection = 'all';
        }
    }

})();