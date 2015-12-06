/**
 * Created by anne on 6/26/2015.
 */

(function () {

    angular
        .module('stateeval.core')
        .factory('evaluationService', evaluationService);

    evaluationService.$inject = ['_', 'enums', '$http', '$q', 'logger', 'config', 'frameworkService', 'rubricUtils', 'localStorageService',
        'evalSessionService', 'artifactService'];
    //'evalSessionService', 'artifactService', 'studentGrowthBuildService'];

    /* @ngInject */
    function evaluationService(_, enums, $http, $q, logger, config, frameworkService, rubricUtils, localStorageService,
        evalSessionService, artifactService, studentGrowthBuildService) {
   //evalSessionService, artifactService, studentGrowthBuildService) {

        var service = {
            getEvaluationById: getEvaluationById,
            getEvaluationForUser: getEvaluationForUser,
            getAllEvaluationsFORNOW: getAllEvaluationsFORNOW,
            getAllObjectsForEvaluation: getAllObjectsForEvaluation
        };

        return service;

        ////////////////

        function getAllObjectsForEvaluation() {
            var list = [];
            return evalSessionService.getObservationsForEvaluation()
                .then(function (data) {
                    for(var i in data) {
                        data[i].linkedItemType = enums.LinkedItemType.OBSERVATION;
                    }
                    list = list.concat(data);
                    return null;
                    //return studentGrowthBuildService.getSubmittedBundlesForEvaluation();
                })
                .then(function (data) {
                    for(var i in data) {
                        data[i].linkedItemType = enums.LinkedItemType.STUDENT_GROWTH_GOAL;
                    }
                    return list.concat(data);
                })
        }


        function getAllEvaluationsFORNOW() {
            var list = [];
            return artifactService.getArtifactBundlesForEvaluation(artifactService.newArtifactBundleRequest(
                enums.WfState.ARTIFACT_SUBMITTED, 0))
                .then(function (data) {
                    for(var i in data) {
                        data[i].linkedItemType = enums.LinkedItemType.ARTIFACT;
                        data[i].itemType = data[i].artifactType;
                    }
                    list = list.concat(data);
                    return evalSessionService.getObservationsForEvaluation();
                })
                .then(function (data) {
                    for(var i in data) {
                        data[i].linkedItemType = enums.LinkedItemType.OBSERVATION;
                        data[i].itemType = enums.ItemType.OBSERVATION;
                    }
                    list = list.concat(data);
                    return null;
                    //return studentGrowthBuildService.getSubmittedBundlesForEvaluation();
                })
                .then(function (data) {
                    for(var i in data) {
                        data[i].linkedItemType = enums.LinkedItemType.STUDENT_GROWTH_GOAL;
                        data[i].itemType = enums.ItemType.STUDENT_GROWTH_GOAL;
                    }
                    return list.concat(data);
                })
        }

        function getEvaluationById(evaluationId) {
            var s = '/evaluations/' + evaluationId;
            return $http.get(config.apiUrl + s).then(function (response) {
                return response.data;
            });
        }

        function getEvaluationForUser(userId, districtCode, schoolYear, evalType) {
            var s = '/evaluations/' + userId + '/' + districtCode + '/' + schoolYear + '/' + evalType;
            return $http.get(config.apiUrl + s).then(function (response) {
                return response.data;
            })
        }
    }
})
();

