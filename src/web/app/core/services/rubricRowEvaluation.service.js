
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
            getRubricRowEvaluationsForTeeTor: getRubricRowEvaluationsForTeeTor,
            getRubricRowEvaluationsForEvalSession: getRubricRowEvaluationsForEvalSession
        };

        return service;

        ////////////////

        function activate() {

        }

        function mapEvalTypeToRole(evalType) {
            switch (evalType) {
                case enums.EvaluationType.LIBRARIAN:
                    return enums.Roles.SESchoolLibrarian;
                    break;
                case enums.EvaluationType.PRINCIPAL:
                    return enums.Roles.SESchoolPrincipal;
                    break;
                case enums.EvaluationType.TEACHER:
                    return enums.Roles.SESchoolTeacher;
                    break;
            }
        }

       function getRubricRowEvaluationsForTeeTor(evaluator,  assignedOnly) {

           var request = {
               schoolYear: activeUserContextService.context.orientation.schoolYear,
               districtCode: activeUserContextService.context.orientation.districtCode,
               schoolCode: activeUserContextService.context.orientation.schoolCode,
               evaluationType: activeUserContextService.context.workArea().evalType,
               evaluatorId: activeUserContextService.context.user,
               roleName: mapEvalTypeToRole(activeUserContextService.context.workArea().evaluationType),
               assignedOnly: assignedOnly || false
           };

            var url = config.apiUrl + 'rubricrowevaluationstortee';

            return $http.get(url, {params: request}).then(function(response) {
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

