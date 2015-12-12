
(function () {
    'use strict';

    angular
        .module('stateeval.student-growth-goals')
        .factory('studentGrowthBuildService', studentGrowthBuildService);

    studentGrowthBuildService.$inject = ['$http', '$q', 'logger', '_', 'config', 'enums', 'rubricUtils',
        'activeUserContextService', '$httpParamSerializerJQLike', '$state'];

    function studentGrowthBuildService($http, $q, logger, _, config, enums, rubricUtils,
           activeUserContextService, $httpParamSerializerJQLike, $state) {

        var service = {

            // data service calls
            getBundleById: getBundleById,
            getGoalById: getGoalById,
            getSubmittedBundlesForEvaluation: getSubmittedBundlesForEvaluation,
            getInProgressBundlesForEvaluation: getInProgressBundlesForEvaluation,
            getSubmittedGoalsForEvaluationForFrameworkNode: getSubmittedGoalsForEvaluationForFrameworkNode,
            getInProgressGoalsForEvaluationForFrameworkNode: getInProgressGoalsForEvaluationForFrameworkNode,
            createBundleForEvaluation: createBundleForEvaluation,
            updateBundleForEvaluation: updateBundleForEvaluation,
            deleteBundleForEvaluation: deleteBundleForEvaluation,
            updateGoalForEvaluation: updateGoalForEvaluation,
            getArtifactBundlesForStudentGrowthGoalBundle: getArtifactBundlesForStudentGrowthGoalBundle,

            // utilities
            newBundle: newBundle,
            newGoal: newGoal,
            getBundleTitleForGoal: getBundleTitleForGoal,
            getBundleDisplayName:getBundleDisplayName,
            setPageTitle: setPageTitle,

            //Form prompts
            getFormPromptById: getFormPromptById
        };
    
        return service;

        function getBundleTitleForGoal(goal) {
            return 'TODO';
        }

        function setPageTitle(bundle) {
            var bundleDisplayName = getBundleDisplayName(bundle);
            $state.current.data.title = 'Student Growth Goal - ' + bundle.title;
          //  $state.current.data.displayName = bundleDisplayName;
        }

        function newBundle() {
            var currentEvaluationId = activeUserContextService.context.evaluatee.evalData.id;

            return {
                id: 0,
                evaluationId: currentEvaluationId,
                title: '',
                comments: '',
                course: '',
                grade: '',
                wfState: enums.WfState.GOAL_BUNDLE_IN_PROGRESS,
                evalWfState: enums.WfState.GOAL_BUNDLE_NOT_SCORED,
                goals: [],
                alignedRubricRows: [],
                rubricRowEvaluations: []
            }
        }

        function newGoal(bundle, frameworkNode) {
            return {
                id: 0,
                evaluationId: bundle.evaluationId,
                goalStatement: '',
                goalTargets: '',
                evidenceAll: '',
                evidenceMost: '',
                frameworkNodeId: frameworkNode.id,
                processRubricRowId: rubricUtils.getStudentGrowthProcessRubricRow(frameworkNode).id,
                resultsRubricRowId: rubricUtils.getStudentGrowthResultsRubricRow(frameworkNode).id,
                isActive: true,
                prompts: []
            }
        }

        function goalCriteriaDisplayString(frameworkNodeShortName) {
            // todo: principal
            if (frameworkNodeShortName == "C3") {
                return "Subset";
            }
            else if (frameworkNodeShortName == "C6") {
                return "Whole Class"
            }
            else if (frameworkNodeShortName == "C8") {
                return "PLC";
            }
        }

        function getBundleDisplayName (bundle) {
            var bundleDisplayName = '';
            var activeCount = 0;
            bundle.goals.forEach(function (g) {
                if (g.isActive) {
                    activeCount++;
                    if (activeCount > 1) {
                        bundleDisplayName += ', ';
                    }
                    bundleDisplayName =  bundleDisplayName + g.frameworkNodeShortName + ' (' + goalCriteriaDisplayString(g.frameworkNodeShortName) + ')';
                }
            });

            if (activeCount > 1) {
                bundleDisplayName = 'Nested Goal - ' + bundleDisplayName;
            }
            else {
                bundleDisplayName = 'Goal is for - ' + bundleDisplayName;
            }

            return bundleDisplayName;
        }

        function getArtifactBundlesForStudentGrowthGoalBundle(bundleId) {
            var url = config.apiUrl + 'artifactbundlesforsggoalbundle/' + bundleId;
            return $http.get(url).then(function(response) {
                return response.data;
            })
        }

        function getInProgressBundlesForEvaluation() {
            var currentEvaluationId = activeUserContextService.context.evaluatee.evalData.id;
            var url = config.apiUrl + currentEvaluationId + '/sggoalbundles/inprogress';
            return $http.get(url).then(function(response) {
                return response.data;
            })
        }
        function getSubmittedBundlesForEvaluation() {
            var currentEvaluationId = activeUserContextService.context.evaluatee.evalData.id;
            var url = config.apiUrl + currentEvaluationId + '/sggoalbundles/submitted';
            return $http.get(url).then(function(response) {
                return response.data;
            })
        }

        function getInProgressGoalsForEvaluationForFrameworkNode(frameworkNodeId) {
            var currentEvaluationId = activeUserContextService.context.evaluatee.evalData.id;
            var url = config.apiUrl + currentEvaluationId + '/sggoals/inprogress/' + frameworkNodeId;
            return $http.get(url).then(function(response) {
                return response.data;
            })
        }
        function getSubmittedGoalsForEvaluationForFrameworkNode(frameworkNodeId) {
            var currentEvaluationId = activeUserContextService.context.evaluatee.evalData.id;
            var url = config.apiUrl + currentEvaluationId + '/sggoals/submitted/' + frameworkNodeId;
            return $http.get(url).then(function(response) {
                return response.data;
            })
        }

        function getBundleById(id) {
            var url = config.apiUrl + '/sggoalbundles/' + id;
            return $http.get(url).then(function(response) {
                return response.data;
            });
        }

        function getGoalById(id) {
            var url = config.apiUrl + '/sggoals/' + id;
            return $http.get(url).then(function(response) {
                return response.data;
            });
        }

        // these special PUT/POST methods are necessary because nested objects do not get
        // transmitted and empty arrays get passed as null otherwise. this is due to the
        // difference in the way jQuery and angular transmit form data

        function updateGoalForEvaluation(goal) {
            var currentEvaluationId = activeUserContextService.context.evaluatee.evalData.id;
            var url = config.apiUrl + currentEvaluationId + '/sggoals';

            return $http({
                method: 'PUT',
                url: url,
                data: $httpParamSerializerJQLike(goal),
                headers: {'Content-Type': 'application/x-www-form-urlencoded'}
            });
        }

        function updateBundleForEvaluation(bundle) {
            var currentEvaluationId = activeUserContextService.context.evaluatee.evalData.id;
            var url = config.apiUrl + currentEvaluationId + '/sggoalbundles';

            return $http({
                method: 'PUT',
                url: url,
                data: $httpParamSerializerJQLike(bundle),
                headers: {'Content-Type': 'application/x-www-form-urlencoded'}
            });
        }

        function createBundleForEvaluation(bundle) {

            var currentEvaluationId = activeUserContextService.context.evaluatee.evalData.id;
            var url = config.apiUrl + currentEvaluationId + '/sggoalbundles';

            var params = null;
            if (bundle.goals.length==0) {
                params = {
                    method: 'POST',
                    url: url,
                    data: bundle
                };
            }
            else {
                params = {
                    method: 'POST',
                    url: url,
                    data: $httpParamSerializerJQLike(bundle),
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'}
                }
            }
            return $http(params)
                .then(function(response) {
                    bundle.id = response.data.id;
                    bundle.creationDateTime = new Date();
                    return response;
                })
        }

        function deleteBundleForEvaluation(bundle) {
            var url = config.apiUrl + 'sggoalbundles' + '/' + bundle.id;
            return $http.delete(url);
        }

        function getFormPromptById(id) {
            var url = config.apiUrl + '/formprompts/' + id;
            return $http.get(url).then(function(response) {
                return response.data;
            });
        }
    }
})();
