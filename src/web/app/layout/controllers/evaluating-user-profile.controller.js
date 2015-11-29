/**
 * evaluatingUserProfileController - controller
 */
(function() {
    angular
        .module('stateeval.layout')
        .controller('evaluatingUserProfileController', evaluatingUserProfileController);

    evaluatingUserProfileController.$inject = ['$rootScope', '$state', 'activeUserContextService',
    'workAreaService'];

    /* @ngInject */

    function evaluatingUserProfileController($rootScope, $state, activeUserContextService,
        workAreaService) {
        var vm = this;
        vm.context = activeUserContextService.context;

        vm.activeEvaluatee = null;
        vm.isEvaluating = false;

        activate();

        function activate() {
            vm.activeEvaluatee = activeUserContextService.context.evaluatee;
            vm.isEvaluating =  vm.context.isEvaluating();
        }
    }
})();

