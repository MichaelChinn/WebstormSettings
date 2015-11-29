(function () {

    angular
        .module('stateeval.core')
        .factory('CHINNrubricRowEvaluationService', CHINNrubricRowEvaluationService);

    CHINNrubricRowEvaluationService.$inject = ['enums', 'evidenceService'];

    function CHINNrubricRowEvaluationService(enums, evidenceService) {

        RubricRowEvaluation.prototype = {
            addEvidence: function () {
                var ev =  evidenceService.newEvidence();
                this.evidence.push(ev);
            }
        };

        var service = {
            newRowEval: newRowEval
        };
        return service;

        function newRowEval(creatorId, evaluationId, objectType, objectId, rubricRowId) {
            return new RubricRowEvaluation(creatorId, evaluationId, objectType, objectId, rubricRowId);
        }

        function RubricRowEvaluation(creatorId, evaluationId, objectType, objectId, rubricRowId) {
            this.rubricRowId = rubricRowId;
            this.evaluationId = evaluationId;
            this.linkedItemType = objectType;
            this.evidence = [];
            this.performanceLevel = null;
            this.createdByUserId = createdByUserId;
            this.wfState = enums.WfState.RREVAL_NOT_STARTED;
            this.annotations = [];

            switch (objectType) {
                case enums.LinkedItemType.ARTIFACT:
                    this.LinkedArtifactBundleId = objectId;
                    break;
                case enums.LinkedItemType.OBSERVATION:
                    this.LinkedObjectId = objectId;
                    break;
                case enums.LinkedItemType.SELF_ASSESSMENT:
                    this.LinkedSelfAssessmentId = objectId;
                    break;
                case enums.LinkedItemType.STUDENT_GROWTH_GOAL:
                    this.LinkedStudentGrowthGoalId = objectId;
                    break;
            }

        }




    }
}) ();