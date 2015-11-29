/**
 * Created by anne on 9/13/2015.
 */
(function () {
    'use strict';

    angular.module('stateeval.core')
        .directive('rubricRowEvaluation', rubricRowEvaluationDirective)
        .controller('rubricRowEvaluationController', rubricRowEvaluationController);

    rubricRowEvaluationController.$inject = ['utils', 'enums', 'config', 'evidenceCollectionService', '$scope'];

    function rubricRowEvaluationDirective() {
        return {
            restrict: 'E',
            scope: {
                eval: '=',
                deleteFcn: '&',
                updateFcn: '&'
            },
            link: function (scope, el, attrs) {

            },
            templateUrl: 'app/core/views/rubric-row-evaluation.directive.html',
            controller: 'rubricRowEvaluationController as vm',
            bindToController: true
        }
    }

    function rubricRowEvaluationController(utils, enums, config, evidenceCollectionService, $scope) {
        var vm = this;
        $scope.name = 'RUBRIC ROW EVALUATION';
        console.log('RubricRow Evaluation');
        vm.enums = enums;
        vm.getSafeHtml = utils.getSafeHtml;
        vm.summernoteOptions = config.summernoteDefaultOptions;
        vm.editMode = false;
        vm.evidenceCollectionService = evidenceCollectionService;
        var evs = {}, i;
        var temp = _.groupBy(vm.eval.alignedEvidences, 'evidenceType');
        for (i in temp) {
            evs[enums.EvidenceTypeMapper[i]] = temp[i];
        }
        vm.alignedEvidence = evs;

        vm.saveEvaluation = saveEvaluation;
        vm.deleteEvaluation = deleteEvaluation;
        vm.getSafeHtml = utils.getSafeHtml;

        function deleteEvaluation() {
            vm.deleteFcn()
                .then(function () {
                    vm.editMode = false;
                })
        }

        function saveEvaluation() {
            vm.updateFcn()
                .then(function () {
                    vm.editMode = false;
                })
        }
    }
})();
