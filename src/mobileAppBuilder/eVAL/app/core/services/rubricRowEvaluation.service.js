
(function () {

    angular
        .module('stateeval.core')
        .factory('rubricRowEvaluationService', rubricRowEvaluationService);

    rubricRowEvaluationService.$inject = ['_', 'enums', '$http', 'config', 'activeUserContextService'];

    /* @ngInject */
    function rubricRowEvaluationService(_, enums, $http, config, activeUserContextService) {
        var service = {
            activate: activate,
            getRubricRowEvaluationById: getRubricRowEvaluationById,
            getRubricRowEvaluationsForEvaluation: getRubricRowEvaluationsForEvaluation,
            getRubricRowEvaluationsForEvaluationById: getRubricRowEvaluationsForEvaluationById,
            getRubricRowEvaluationsForPR_TR: getRubricRowEvaluationsForPR_TR,
            getRubricRowEvaluationsForEvalSession: getRubricRowEvaluationsForEvalSession
        };

        return service;

        ////////////////

        function activate() {

        }

       function getRubricRowEvaluationsForPR_TR(evaluator,  assignedOnly) {
            assignedOnly = assignedOnly || false;
            var districtCode = activeUserContextService.context.orientation.districtCode;
            var schoolCode = activeUserContextService.context.orientation.schoolCode;
            var url = config.apiUrl + 'rubricrowevaluations/prtr/' + activeUserContextService.context.orientation.schoolYear + '/' + districtCode + '/'
                + schoolCode + '/' + evaluator.id + '/' + assignedOnly;

            return $http.get(url).then(function(response) {
                return response.data;
            });
        }

        function getRubricRowEvaluationById(id) {
            var url = config.apiUrl + 'rubricrowevaluations/' + id;
            return $http.get(url).then(function (response) {
                return response.data;
            });
        }

        function getRubricRowEvaluationsForEvalSession(id) {
            var evaluationid = activeUserContextService.context.evaluatee.evalData.id;
            var url = config.apiUrl + 'evalSession/' + id + '/rubricrowevaluations/';
            return $http.get(url).then(function (response) {
                return response.data;
            });
        }

        function getRubricRowEvaluationsForEvaluation() {
            var evaluationid = activeUserContextService.context.evaluatee.evalData.id;
            var url = config.apiUrl + evaluationid + '/rubricrowevaluations/';
            return $http.get(url).then(function (response) {
                return response.data;
            });
        }

        function getRubricRowEvaluationsForEvaluationById(id) {
            var url = config.apiUrl + id + '/rubricrowevaluations/';
            return $http.get(url).then(function (response) {
                return response.data;
            });
        }
    }
})();

