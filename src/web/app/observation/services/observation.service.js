/**
 * Created by anne on 6/19/2015.
 */
(function () {
    'use strict';

    angular
        .module('stateeval.observation')
        .factory('observationService', observationService);

    observationService.$inject = ['$http', '$q', 'logger', '_', 'config', 'enums', 'rubricUtils', 'activeUserContextService'];

    function observationService($http, $q, logger, _, config, enums, rubricUtils, activeUserContextService) {
        var service = {
            getObservations: getObservations,
            getObservation: getObservation,
            getNewObservation: getNewObservation,
            saveObservation: saveObservation,
            createNewObservation: createNewObservation,
            getRubricRowFocuses: getRubricRowFocuses,
            saveRubricRowFocuses: saveRubricRowFocuses,
            saveRubricRowAnnotation: saveRubricRowAnnotation,
            getArtifactBundles: getArtifactBundles,
            getRubricRowAnnotations: getRubricRowAnnotations,
            getUnlinkedArtifactBundles: getUnlinkedArtifactBundles,
            getObservationParam: getObservationParam,
            updateUserPromptResponse: updateUserPromptResponse,
            updatePreConfPromptState: updatePreConfPromptState
        };

        function getObservationParam() {
            var observationParam = {};
            observationParam.evaluatorId = activeUserContextService.user.id;
            observationParam.evaluateeId = activeUserContextService.context.evaluatee.id;
            observationParam.districtCode = activeUserContextService.getActiveDistrictCode();
            observationParam.schoolYear = activeUserContextService.context.orientation.schoolYear;
            observationParam.schoolCode = activeUserContextService.getActiveSchoolCode();
            observationParam.evaluationType = activeUserContextService.getActiveEvaluationType();
            observationParam.evaluationId = activeUserContextService.context.evaluatee.evalData.id;
            observationParam.isEvaluator = activeUserContextService.context.isEvaluator();            
            return observationParam;
        }

        function getObservations() {
            var url = config.apiUrl + 'evalsessions';
            return $http.get(url, { params: getObservationParam() }).then(function (evalSessions) {
                return evalSessions.data;
            });
        }

        function getObservation(evalSessionId) {
            var url = config.apiUrl + 'evalsession/' + evalSessionId;
            return $http.get(url, { params: getObservationParam() }).then(function (evalSessions) {
                return evalSessions.data;
            });
        }
        
        function getNewObservation() {
            var observationParam = getObservationParam();

            return {
                evaluationScoreTypeID: 1,
                evaluationType: observationParam.evaluationType,
                schoolYear: observationParam.schoolYear,
                schoolCode: observationParam.schoolCode,
                districtCode: observationParam.districtCode,
                evaluateeId: observationParam.evaluateeId,
                evaluatorId: observationParam.evaluatorId,
                wfState: enums.WfState.OBS_IN_PROGRESS_TOR,
                evaluationId: activeUserContextService.context.evaluatee.evalData.id,
                preConfPromptState: enums.PreConfPromptStateEnum.PromptCreated
            };
        }

        function saveObservation(observation) {
            var url = config.apiUrl + 'evalsession/saveevalsession';
            return $http.post(url, observation).then(function (response) {
                return response.data;
            });
        }

        function createNewObservation() {
            var observation = getNewObservation();
            return saveObservation(observation);
        }

        function getRubricRowFocuses(evalSessionId) {
            var url = config.apiUrl + 'evalsession/rubricRowFocuses/' + evalSessionId;
            return $http.get(url).then(function (response) {
                return response.data;
            });
        }

        function saveRubricRowFocuses(evalSessionId, rubricRows) {
            var url = config.apiUrl + 'evalsession/saveRubricRowFocuses';
            return $http.post(url, { id: evalSessionId, rubricRows: rubricRows }).then(function (data) {

            });
        }

        function saveRubricRowAnnotation(evalSession, rubric, annotation, annotationType) {
            var url = config.apiUrl + 'rubricrowannotation/create';
            return $http.post(url, {
                evalSessionId: evalSession.id,
                evaluationId: evalSession.evaluationId,
                linkedItemType: enums.LinkedItemType.OBSERVATION,
                rubricRowId: rubric.id,
                annotation: annotation,
                userId: activeUserContextService.getActiveUser().id,
                annotationType:annotationType
            }).then(function (data) {

            });
        }

        function getRubricRowAnnotations(evalSessionId, rubricRowId) {
            var url = config.apiUrl + 'evalsession/' + evalSessionId + '/' + rubricRowId + '/rubricrowannotations';
            return $http.get(url).then(function (response) {
                return response.data;
            });
        }

        function getArtifactBundles(evalSessionId) {
            var url = config.apiUrl + 'evalsession/' + evalSessionId + '/artifactbundles';
            return $http.get(url).then(function (response) {
                return response.data;
            });
        }

        function getUnlinkedArtifactBundles() {
            var observationParam = getObservationParam();
            var url = config.apiUrl + 'artifactbundlesunlinkedObs';
            return $http.get(url, { params: observationParam }).then(extractData);
        }

        function updateUserPromptResponse(userPromptResponseId, response) {
            var url = config.apiUrl + 'userpromptresponse/savecodedresponse';
            var userPromptResponse = {
                userPromptResponseID: userPromptResponseId,
                response: response
            }

            return $http.post(url, userPromptResponse).then(function(result) {
                return result.data;
            });
        }

        function updatePreConfPromptState(evalSessionId, preConfPromptState) {
            var url = config.apiUrl + 'evalsession/' + evalSessionId + '/updatePreConfPromptState?preConfPromptState=' + preConfPromptState;
            return $http.post(url).then(function(result) {
                return result.data;
            });
        }

        var extractData = function (response) {
            return response.data;
        }
        return service;

    }
})();

