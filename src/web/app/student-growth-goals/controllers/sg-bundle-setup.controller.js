/**
 * Created by anne on 11/8/2015.
 */

(function() {
    'use strict';

    angular
        .module('stateeval.student-growth-goals')
        .controller('sgBundleSetupController', sgBundleSetupController);

    sgBundleSetupController.$inject = ['studentGrowthBuildService', 'activeUserContextService' , '$stateParams',
        '$state', 'rubricUtils', 'studentGrowthAdminService', 'enums', 'evidenceCollectionService', 'evidenceCollection'];

    /* @ngInject */
    function sgBundleSetupController(studentGrowthBuildService, activeUserContextService, $stateParams,
         $state, rubricUtils, studentGrowthAdminService, enums, evidenceCollectionService, evidenceCollection) {
        var vm = this;
        vm.new = false;
        vm.studentGrowthFrameworkNodes = [];
        vm.activeGoals = [];
        vm.bundle = null;
        vm.bundleDisplayName = '';
        vm.promptsByFrameworkNode = [];

        vm.toggleGoalActivation = toggleGoalActivation;
        vm.goalIsActive = goalIsActive;
        vm.save = save;
        vm.completeScoring = completeScoring;
        vm.returnToNotScored = returnToNotScored;
        vm.back = back;
        vm.submitted = false;
        vm.showCompleteScoringBtn = false;
        vm.showReturnToNotScoredBtn = false;
        vm.isEvaluatee = false;
        vm.evidenceCollection = evidenceCollection;

        ////////////////////////

        activate();

        function activate() {

            vm.studentGrowthFrameworkNodes = activeUserContextService.getFrameworkContext().studentGrowthFrameworkNodes;
            vm.isEvaluatee = activeUserContextService.context.evaluatee.id == activeUserContextService.user.id;
            studentGrowthAdminService.getDistrictPrompts(activeUserContextService.context.evaluatee.evalData.evalType).then(function (prompts) {
                vm.promptsByFrameworkNode = _.groupBy(prompts, 'frameworkNodeId');

                studentGrowthBuildService.getBundleById($stateParams.id).then(function (bundle) {
                    vm.bundle = bundle;
                    vm.submitted = (vm.bundle.wfState >= enums.WfState.GOAL_BUNDLE_PROCESS_SUBMITTED);
                    buildActiveGoalList();
                    setBundleDisplayName();

                    if (vm.submitted) {
                        vm.showCompleteScoringBtn = !vm.isEvaluatee &&
                                                    vm.bundle.evalWfState == enums.WfState.GOAL_BUNDLE_NOT_SCORED;

                        vm.showReturnToNotScoredBtn = !vm.isEvaluatee &&
                                                    vm.bundle.evalWfState >= enums.WfState.GOAL_BUNDLE_PROCESS_SCORED;
                    }
                });
            });
        }

        function addGoalToBundle(goal) {
            vm.bundle.goals.push(goal);
            vm.bundle.goals = _.sortBy(vm.bundle.goals, 'frameworkNodeId');
            buildActiveGoalList();
        }

        function toggleGoalActivation(fn) {
            var goal = _.findWhere(vm.bundle.goals, { 'frameworkNodeId': fn.id });

            if (goal === undefined) {
                goal = studentGrowthBuildService.newGoal(vm.bundle, fn);
                var fnode = _.findWhere(vm.studentGrowthFrameworkNodes, {id: goal.frameworkNodeId});
                goal.frameworkNodeShortName = fnode.shortName;
                vm.promptsByFrameworkNode[fnode.id].forEach(function(promptFrameworkNode) {
                    promptFrameworkNode.formPrompt.userId = activeUserContextService.context.evaluatee.id;
                    goal.prompts.push(promptFrameworkNode.formPrompt);
                });
                Array.prototype.push.apply(vm.bundle.alignedRubricRows, rubricUtils.getStudentGrowthRubricRowsForFrameworkNode(fn));
                addGoalToBundle(goal);
            }
            else {
                goal.isActive = !goal.isActive;
                if (goal.isActive) {
                    Array.prototype.push.apply(vm.bundle.alignedRubricRows, rubricUtils.getStudentGrowthRubricRowsForFrameworkNode(fn));
                }
                else {
                    vm.bundle.alignedRubricRows = _.reject(vm.bundle.alignedRubricRows, {frameworkNodeId: fn.id});
                }
            }

            buildActiveGoalList();
            setBundleDisplayName();
        }

        function setBundleDisplayName () {
            vm.bundleDisplayName = studentGrowthBuildService.getBundleDisplayName(vm.bundle);
        }

        function buildActiveGoalList() {
            vm.activeGoals = [];
            vm.bundle.goals.forEach(function (goal) {
                if (goal.isActive) {
                    vm.activeGoals.push(goal);
                }
            })
        }

        function goalIsActive(fn) {
            var goal = _.findWhere(vm.activeGoals, { 'frameworkNodeId': fn.id });
            return !(goal === undefined || !goal.isActive);
        }

        function back() {
            $state.go('sg-goals-private');
        }

        // todo: need a way to communicate that the page needs to be updated so it
        // changes to read-only after this
        function completeScoring() {
            vm.bundle.evalWfState = enums.WfState.GOAL_BUNDLE_PROCESS_SCORED;
            studentGrowthBuildService.updateBundleForEvaluation(vm.bundle)
                .then(function()
                {
                    vm.showCompleteScoringBtn = false;
                });

        }

        function returnToNotScored() {
            vm.bundle.evalWfState = enums.WfState.GOAL_BUNDLE_NOT_SCORED;
            studentGrowthBuildService.updateBundleForEvaluation(vm.bundle)
                .then(function()
                {
                    vm.showReturnToNotScoredBtn = false;
                    vm.showCompleteScoringBtn = true;
                });

        }

        function save(submit) {

            if (submit) {
                vm.bundle.wfState = enums.WfState.GOAL_BUNDLE_PROCESS_SUBMITTED;
            }

            studentGrowthBuildService.updateBundleForEvaluation(vm.bundle)
                .then(function()
                {
                    back();
                });
        }
    }

})();

