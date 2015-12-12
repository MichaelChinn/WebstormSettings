
(function () {

    angular
        .module('stateeval.core')
        .factory('evalSessionService', evalSessionService);

    evalSessionService.$inject = ['_', 'enums', '$http', '$q', 'logger', 'config', 'frameworkService', 'rubricUtils', 'localStorageService', 'activeUserContextService'];

    /* @ngInject */
    function evalSessionService(_, enums, $http, $q, logger, config, frameworkService, rubricUtils, localStorageService, activeUserContextService) {
        var service = {
            activate: activate,
            getEvalSessionById: getEvalSessionById,
            saveObserveNotes: saveObserveNotes,
            saveEvalSession:saveEvalSession,
            getEvalSessionsForSchool: getEvalSessionsForSchool,
            getObservationsForEvaluation: getObservationsForEvaluation,
            getObservationsForEvaluationById: getObservationsForEvaluationById

        };

        return service;

        ////////////////

        function activate() {

        }

        function updateRubricRowScore(scoreModel) {
            var url = config.apiUrl + 'evalsessionrubricrowscore/';
            return $http.put(url, scoreModel).then(function (response) {
            });
        }

        function getObservationsForEvaluationById(id) {
            var url = config.apiUrl + 'observationsforevaluation/' + id;
            return $http.get(url).then(function (response) {
                return response.data;
            });
        }

        function getObservationsForEvaluation() {
            var url = config.apiUrl + 'observationsforevaluation/' + activeUserContextService.context.evaluatee.evalData.id;
            return $http.get(url).then(function (response) {
                return response.data;
            });
        }

        function getEvalSessionById(evalSessionId) {
            var url = config.apiUrl + 'evalsession/' + evalSessionId;
            return $http.get(url).then(function (response) {
                return response.data;
            });
        }

        function saveObserveNotes(evalSessionId, note, noteProperty) {
            var url = config.apiUrl + 'evalsession/updateobservenotes';
            var obj = { id: evalSessionId};
            obj[noteProperty] = note;
            return $http.post(url, obj).then(function (response) {
                return response.data;
            });
        }

        function saveEvalSession(evalSession) {
            var url = config.apiUrl + 'evalsession/saveevalsession';
            return $http.post(url, evalSession).then(function (response) {
                return response.data;
            });
        }

        function getEvalSessionsForSchool(schoolCode) {
            var url = config.apiUrl + 'evalsessionsforschool/' + activeUserContextService.context.orientation.schoolYear + '/' + schoolCode;
            return $http.get(url).then(function (response) {
                return response.data;
            });
        }
    }
})();

