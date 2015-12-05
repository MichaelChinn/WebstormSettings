(function () {
    angular.module("stateeval.mobile.observation").controller("observationController", observationController);

    observationController.$inject = ['activeUserContextService'];

    function observationController(activeUserContextService) {
        var vm = this;

        vm.initialize = function () {
            vm.evaluatees = activeUserContextService.getEvaluateesForActiveUser();
        };

        vm.initialize();
    }
})();