
(function () {
    'use strict';

    angular
        .module('stateeval.assignments')
        .factory('assignmentsService', assignmentsService);

    assignmentsService.$inject = ['$http', 'config', 'activeUserContextService', 'enums'];
    function assignmentsService($http, config, activeUserContextService, enums) {

        var service = {
            toggleDelegate: toggleDelegate,
            createDTEAssignmentRequest: createDTEAssignmentRequest,
            deleteDTEAssignmentRequest: deleteDTEAssignmentRequest,
            getDTEAssignmentRequestsForDTE: getDTEAssignmentRequestsForDTE,
            updateDTEAssignmentRequest: updateDTEAssignmentRequest,
            getDTEAssignmentRequestsForSchool:getDTEAssignmentRequestsForSchool,
            getTeachersForAssignment: getTeachersForAssignment,
            getPrincipalsForAssignment: getPrincipalsForAssignment,
            assignComprehensiveEvaluateePlanType: assignComprehensiveEvaluateePlanType,
            assignFocusedEvaluateePlanType: assignFocusedEvaluateePlanType,
            assignEvaluator: assignEvaluator,
            districtDelegatedTeacherAssignmentsForSchool:districtDelegatedTeacherAssignmentsForSchool
        };

        return service;

        function newComprehensiveAssignmentRequest(evaluatee) {
            return {
                schoolYear: activeUserContextService.context.orientation.schoolYear,
                districtCode: activeUserContextService.getActiveDistrictCode(),
                evaluateePlanType: enums.EvaluationPlanType.COMPREHENSIVE,
                evaluationType: evaluatee.evalData.evalType,
                evaluateeId: evaluatee.id,
                FocusFrameworkNodeId: null,
                SGFocusFrameworkNodeId: null
            }
        }

        function newFocusedAssignmentRequest(evaluatee, focusFrameworkNodeId, sgFocusFrameworkNodeId) {
            return {
                schoolYear: activeUserContextService.context.orientation.schoolYear,
                districtCode: activeUserContextService.getActiveDistrictCode(),
                evaluateePlanType: enums.EvaluationPlanType.FOCUSED,
                evaluationType: evaluatee.evalData.evalType,
                evaluateeId: evaluatee.id,
                FocusFrameworkNodeId: focusFrameworkNodeId,
                SGFocusFrameworkNodeId: sgFocusFrameworkNodeId
            }
        }

        function newEvaluatorAssignmentRequest(evaluatee, evaluator) {
            return {
                schoolYear: activeUserContextService.context.orientation.schoolYear,
                districtCode: activeUserContextService.getActiveDistrictCode(),
                evaluationType: evaluatee.evalData.evalType,
                evaluateeId: evaluatee.id,
                evaluatorId: evaluator?evaluator.id:null
            }
        }

        function newEvalAssignmentRequestForDTE(dte, teacher) {
            return {
                schoolYear: activeUserContextService.context.orientation.schoolYear,
                districtCode: activeUserContextService.getActiveDistrictCode(),
                evaluatorId: dte.id,
                evaluateeId: teacher.id
            }
        }

        function districtDelegatedTeacherAssignmentsForSchool(schoolCode) {
            var districtCode = activeUserContextService.getActiveDistrictCode();
            var url = config.apiUrl + 'delegateassignments/' + activeUserContextService.context.orientation.schoolYear + '/' + districtCode + '/' + schoolCode;
            return $http.get(url).then(function(response) {
                return response.data;
            });
        }

        function toggleDelegate(schoolCode, delegate) {
            var request = {
                schoolYear: activeUserContextService.context.orientation.schoolYear,
                districtCode: activeUserContextService.getActiveDistrictCode(),
                schoolCode: schoolCode,
                delegateTeacherAssignments: delegate
            }
            var districtCode = activeUserContextService.getActiveDistrictCode();
            var url = config.apiUrl + 'delegateassignments';
            return $http.post(url, request).then(function(response) {
            });
        }

        function deleteDTEAssignmentRequest(request) {
            var url = config.apiUrl + 'dteassignmentrequest/' + request.id;
            return $http.delete(url).then(function(response) {
            });
        }

        function createDTEAssignmentRequest(dte, teacher) {
            var request = newEvalAssignmentRequestForDTE(dte, teacher)
            var url = config.apiUrl + 'dteassignmentrequest';
            return $http.post(url, request).then(function(response) {
            });
        }

        function updateDTEAssignmentRequest(request) {
            var url = config.apiUrl + 'dteassignmentrequest';
            return $http.put(url, request).then(function(response) {
            });
        }

        function getDTEAssignmentRequestsForDTE(dte) {
            var url = config.apiUrl + 'dteassignmentrequests/' + activeUserContextService.context.orientation.schoolYear + '/' +
                                        activeUserContextService.getActiveDistrictCode() + '/' + dte.id;
            return $http.get(url).then(function(response) {
                return response.data;
            });
        }

        function getDTEAssignmentRequestsForSchool(schoolCode) {
            var url = config.apiUrl + 'dteassignmentrequestsforschool/' + activeUserContextService.context.orientation.schoolYear + '/' +
                activeUserContextService.getActiveDistrictCode() + '/' + schoolCode;
            return $http.get(url).then(function(response) {
                return response.data;
            });
        }

        function assignComprehensiveEvaluateePlanType(evaluatee) {
            var request = newComprehensiveAssignmentRequest(evaluatee)
            var url = config.apiUrl + 'assignplantype/comprehensive';
            return $http.post(url, request).then(function(response) {
            });
        }

        function assignFocusedEvaluateePlanType(evaluatee, focusFrameworkNodeId, sgFocusFrameworkNodeId) {
            var request = newFocusedAssignmentRequest(evaluatee, focusFrameworkNodeId, sgFocusFrameworkNodeId)
            var url = config.apiUrl + 'assignplantype/focused';
            return $http.post(url, request).then(function(response) {
            });
        }

        function assignEvaluator(evaluatee, evaluator) {
            var request = newEvaluatorAssignmentRequest(evaluatee, evaluator);
            var url = config.apiUrl + 'assignevaluator';
            return $http.post(url, request).then(function(response) {
            });
        }

        function getTeachersForAssignment(districtCode, schoolCode) {
            var url = config.apiUrl + 'teachersforassignment/schoolyear/' + activeUserContextService.context.orientation.schoolYear + '/district/' + districtCode + '/school/' + schoolCode;
            return $http.get(url).then(function(response) {
                return response.data;
            });
        }

        function getPrincipalsForAssignment(districtCode) {
            var url = config.apiUrl + 'principalsforassignment/schoolyear/' + activeUserContextService.context.orientation.schoolYear + '/district/' + districtCode;
            return $http.get(url).then(function(response) {
                return response.data;
            });
        }

    }
})();