/**
 * evaluatorLeftNavBarController - controller
 */
(function() {
    angular
        .module('stateeval.layout')
        .controller('evalLeftNavBarController', evalLeftNavBarController);

    evalLeftNavBarController.$inject = ['$rootScope', '$state', 'activeUserContextService'];

    /* @ngInject */

    function evalLeftNavBarController($rootScope, $state, activeUserContextService) {
        var vm = this;

        vm.activeEvaluatee = null;
        vm.changeEvaluatee = changeEvaluatee;
        vm.evaluatees = [];
        vm.isEvaluator = false;
        vm.assignedOnly = false;

        vm.toggleAssignedOnly = toggleAssignedOnly;

        activate();

        function activate() {
            vm.assignedOnly = activeUserContextService.getShowAssignedEvaluateesOnly();
            vm.isEvaluator = activeUserContextService.getActiveWorkArea().isEvaluator;
            if (vm.isEvaluator) {
                loadEvaluatees();
            }
        }

        function loadEvaluatees() {
            vm.evaluatees = activeUserContextService.getEvaluateesForActiveUser();
            vm.showDropDown = vm.evaluatees.length > 0;
            vm.activeEvaluatee = activeUserContextService.getActiveEvaluatee();
        }

        function toggleAssignedOnly() {
            activeUserContextService.setShowAssignedEvaluateesOnly(vm.assignedOnly);
            loadEvaluatees();
        }

        function getActiveWorkAreaDisplayName() {
            activeUserContextService.getActiveWorkAreaDisplayName();
        }

        function changeEvaluatee()
        {
            activeUserContextService.setActiveEvaluatee(vm.activeEvaluatee);
        }
    }
})();

