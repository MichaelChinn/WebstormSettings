(function () {
    angular.module("stateeval.mobile.observation").controller("observationController", observationController);

    observationController.$inject = ['$state','activeUserContextService'];

    function observationController($state,activeUserContextService) {
        var vm = this;
        vm.selectEvaluatee = selectEvaluatee;

        function activate() {
            vm.evaluatees = activeUserContextService.getEvaluateesForActiveUser();
        };

        activate();

        function selectEvaluatee(evaluatee) {
            activeUserContextService.setActiveEvaluatee(evaluatee);
            $state.go("observation-list");
        }
    }
})();