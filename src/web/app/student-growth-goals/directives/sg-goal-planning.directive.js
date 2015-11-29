/**
 * Created by anne on 11/8/2015.
 */

(function() {
    'use strict';

    angular
        .module('stateeval.student-growth-goals')
        .directive('sgGoalPlanning', sgGoalPlanning)
        .controller('sgGoalPlanningController', sgGoalPlanningController);

    sgGoalPlanningController.$inject = ['activeUserContextService', 'enums', 'rubricUtils', 'utils', 'config',
        '$scope', 'evidenceCollectionService'];

    function sgGoalPlanning() {
        return {
            templateUrl: "app/student-growth-goals/views/sg-goal-planning.directive.html",
            controller: "sgGoalPlanningController as vm",
            bindToController: true,
            scope: {
                bundle: '=',
                goal: '=',
                evidenceCollection: '='
            },
            restrict: 'E'
        };
    }
    /* @ngInject */
    function sgGoalPlanningController(activeUserContextService, enums, rubricUtils, utils, config,
        $scope, evidenceCollectionService) {

        var vm = this;

        vm.enums = enums;
        vm.getSafeHtml = utils.getSafeHtml;
        vm.summernoteOptions = config.summernoteDefaultOptions;

        vm.planningExpanded = false;
        vm.node = null;
        vm.submitted = false;
        vm.processScored = false;
        vm.isEvaluatee = false;
        vm.showScores = false;
        vm.processRubricRows = [];
        vm.resultsRubricRows = [];
        vm.context = activeUserContextService.context;
        vm.frameworkNode = null;
        vm.toggle = [];
        vm.row = null;
        vm.scoreRow = scoreRow;


        ////////////////////////

        activate();

        function activate() {
            vm.submitted = vm.bundle.wfState >= enums.WfState.GOAL_BUNDLE_PROCESS_SUBMITTED;
            vm.processScored = vm.bundle.evalWfState >= enums.WfState.GOAL_BUNDLE_PROCESS_SCORED;
            vm.planningExpanded = false;
            vm.isEvaluatee = activeUserContextService.context.isEvaluatee();
            vm.showScores = !vm.isEvaluatee || vm.processScored;
            vm.frameworkNode = _.find(vm.context.framework.frameworkNodes,{id:vm.goal.frameworkNodeId});

            evidenceCollectionService.evaluationsReadOnly = vm.isEvaluatee || vm.processScored;

            var processRowId = rubricUtils.getStudentGrowthProcessRubricRow(vm.frameworkNode).id;
            evidenceCollectionService.state.view = "row";
            vm.row = vm.evidenceCollection.rubric[processRowId];
            vm.node = vm.row.parent;
            vm.defaults = {
                row: vm.row,
                node: vm.node
            };
            evidenceCollectionService.state.scoring = activeUserContextService.context.isAssignedEvaluator();
            evidenceCollectionService.state.scoringVisible = activeUserContextService.context.isAssignedEvaluator();
            evidenceCollectionService.state.functionality = activeUserContextService.context.isAssignedEvaluator();

        }

        function scoreRow(row, level) {
            return vm.evidenceCollection.scoreRubricRow(row.data.id, level);
        }


    }

})();

