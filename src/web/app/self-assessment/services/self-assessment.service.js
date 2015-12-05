/**
 * Created by anne on 12/5/2015.
 */
angular
    .module('stateeval.self-assessment')
    .factory('selfAssessmentService', selfAssessmentService);

selfAssessmentService.$inject = ['activeUserContextService', 'config', '$http'];

/* @ngInject */
function selfAssessmentService(activeUserContextService, config, $http) {
    var service = {
        getSelfAssessmentsForEvaluation: getSelfAssessmentsForEvaluation,
        getSelfAssessmentById: getSelfAssessmentById,
        newSelfAssessmentRequest: newSelfAssessmentRequest,
        newSelfAssessment: newSelfAssessment,
        saveSelfAssessment: saveSelfAssessment
    };

    return service;

    ////////////////

    function newSelfAssessment() {
        return {
            creationDateTime: new Date(),
            evaluationId: activeUserContextService.context.evaluatee.evalData.id,
            evaluateeId: activeUserContextService.user.id,
            id: 0,
            alignedRubricRows: [],
            title: '',
            focused: false,
            performanceLevel: null,
            includeInFinalReport: false,
            isSharedWithEvaluator: false
        }
    }

    function newSelfAssessmentRequest() {
        var evaluationId = activeUserContextService.context.evaluatee.evalData.id;
        var currentUserId = activeUserContextService.user.id;
        return {
            evaluationId: evaluationId,
            currentUserId: currentUserId
        }
    }

    function saveSelfAssessment(selfAssessment) {
         var url = config.apiUrl + '/selfassessments';
        if (selfAssessment.id != 0) {
            return $http.put(url, selfAssessment);
        } else {
            return $http.post(url, selfAssessment).then(function(response) {
                selfAssessment.id = response.data.id;
            });
        }
    }

    function getSelfAssessmentById(id) {
        return $http.get(config.apiUrl + 'selfassessments/' + id).then(function(response) {
            return response.data;
        })
    }

    function getSelfAssessmentsForEvaluation() {
        var request = newSelfAssessmentRequest();
        var url = config.apiUrl + '/selfassessments';
        return $http.get(url, {params: request})
            .then(function (response) {
                return response.data;
            });
    }

}

