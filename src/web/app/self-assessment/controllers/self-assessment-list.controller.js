/**
 * Created by anne on 12/5/2015.
 */
(function() {
 'use strict';
    angular
        .module('stateeval.self-assessment')
        .controller('selfAssessmentListController', selfAssessmentListController);

    selfAssessmentListController.$inject = ['selfAssessmentService', '$state'];

    /* @ngInject */
    function selfAssessmentListController(selfAssessmentService, $state) {
        /* jshint validthis: true */
        var vm = this;

        vm.activate = activate;
        vm.assessments = [];

        vm.newAssessment = newAssessment;
        vm.editAssessment = editAssessment;
        vm.deleteAssessment = deleteAssessment;

        activate();

        ////////////////

        function activate() {
                selfAssessmentService.getSelfAssessmentsForEvaluation().then(function(assessments) {
                    vm.assessments = assessments;
                })
        }

        function newAssessment() {
            var assessment = selfAssessmentService.newSelfAssessment();
            selfAssessmentService.saveSelfAssessment(assessment).then(function() {
                $state.go('self-assessment', {id: assessment.id});
            });
        }
        function editAssessment(assessment) {
            $state.go('self-assessment', {id: assessment.id});
        }

        function deleteAssessment(assessment) {
            selfAssessmentService.deleteAssessment(assessment).then(function() {
                vm.assessments = _.reject(vm.assessments, {id: assessment.id});
            })
        }
    }
})();