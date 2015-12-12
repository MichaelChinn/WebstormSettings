/**
 * baseController - controller
 */
(function() {
    angular
        .module('stateeval.core')
        .controller('baseController', baseController);

    baseController.$inject = ['$rootScope', '$state', 'activeUserContextService'];

    /* @ngInject */

    function baseController($rootScope, $state, activeUserContextService) {
        var vm = this;

        vm.activeEvaluatee = null;
        vm.isEvaluating = false;

        activate();

        function activate() {
            //vm.activeEvaluatee = activeUserContextService.context.evaluatee();
            vm.isEvaluating = activeUserContextService.currentUserIsEvaluating;
            //todo find which of this is relevent
        }
    }
})();

