(function () {
    angular.module("stateeval.mobile.observation").controller("observationController", observationController);

    observationController.$inject = ['activeUserContextService'];

    function observationController(activeUserContextService) {
        var vm = this;
        vm.selectEvaluatee = selectEvaluatee;

        function activate() {
            vm.evaluatees = activeUserContextService.getEvaluateesForActiveUser();
        };

        activate();

        function selectEvaluatee(evaluatee) {
            activeUserContextService.setActiveEvaluatee(evaluatee);
        }
    }
})();