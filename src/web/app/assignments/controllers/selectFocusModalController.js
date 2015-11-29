
(function () {
    'use strict';

    angular
        .module('stateeval.assignments')
        .controller('selectFocusModalController', selectFocusModalController);

    selectFocusModalController.$inject = ['$modalInstance', 'enums', 'userService',
        'activeUserContextService', 'evaluatee'];

    /* @ngInject */
    function selectFocusModalController($modalInstance, enums, userService,
        activeUserContextService, evaluatee) {
        var vm = this;

        vm.focusSelectionMissing = false;
        vm.growthSelectionMissing = false;

        vm.evaluatee = evaluatee;
        vm.showStudentGrowthDropdown = false;
        vm.focusFrameworkNode = null;
        vm.sgFocusFrameworkNode = null;

        vm.frameworkNodes = [];
        vm.sgFrameworkNodes = [];

        vm.save = save;
        vm.cancel = cancel;
        vm.changeFocus = changeFocus;


        /////////////////////////////////

        activate();

        function activate() {

            vm.frameworkNodes = activeUserContextService.getFrameworkContext().stateFramework.frameworkNodes;
            vm.sgFrameworkNodes = activeUserContextService.getFrameworkContext().studentGrowthFrameworkNodes;
            if (vm.evaluatee.evalData.evalType === enums.EvaluationType.TEACHER) {
                vm.sgFrameworkNodes = _.reject(vm.sgFrameworkNodes, {'shortName': 'C8'});
            }

            vm.focusFrameworkNode = findFrameworkNode(vm.evaluatee.evalData.focusFrameworkNodeId);
            vm.sgFocusFrameworkNode = findSGFrameworkNode(vm.evaluatee.evalData.focusSGFrameworkNodeId);
            setShowStudentGrowthOption();
        }

        function findSGFrameworkNode(id) {
            return _.findWhere(vm.sgFrameworkNodes, {id: id});
        }

        function findFrameworkNode(id) {
            return _.findWhere(vm.frameworkNodes, {id: id});
        }

        function setShowStudentGrowthOption() {

            if (!vm.focusFrameworkNode) {
                vm.showStudentGrowthDropdown=false;
                return;
            }
            var match = findSGFrameworkNode(vm.focusFrameworkNode.id);
            vm.showStudentGrowthDropdown = (match===undefined);
        }

        function changeFocus() {
            setShowStudentGrowthOption();
        }

        function buildFocusDisplayString() {
            var displayString = '<label>Focus:</label>';
            displayString+=(vm.focusFrameworkNode.shortName);
            if (vm.sgFocusFrameworkNode != null) {
                displayString+=('&nbsp;&nbsp;<label>Student Growth:</label>');
                displayString+=(vm.sgFocusFrameworkNode.shortName);
            }
            return displayString;
        }

        function save() {
            vm.growthSelectionMissing = false;
            vm.focusSelectionMissing = false;
            if (!vm.focusFrameworkNode) {
                vm.focusSelectionMissing = true;
                return;
            }

            if (_.findWhere(vm.sgFrameworkNodes, {id: vm.focusFrameworkNode.id})) {
                vm.sgFocusFrameworkNode = undefined;
            }
            else {
                if (!vm.sgFocusFrameworkNode) {
                    vm.growthSelectionMissing = true;
                    return;
                }
            }

            $modalInstance.close({
                evaluatee: vm.evaluatee,
                focusFrameworkNodeId: vm.focusFrameworkNode.id,
                sgFocusFrameworkNodeId: vm.sgFocusFrameworkNode==undefined?null:vm.sgFocusFrameworkNode.id,
                focusDisplayString: buildFocusDisplayString()
            });
        }

        function cancel() {
            $modalInstance.dismiss('cancel');
        }
    }

})();

