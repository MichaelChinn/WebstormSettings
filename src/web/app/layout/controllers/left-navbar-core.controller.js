/**
 * leftNavCoreController - controller
 */
(function() {
    angular
        .module('stateeval.layout')
        .controller('leftNavCoreController', leftNavCoreController);

    leftNavCoreController.$inject = ['$rootScope', '$state', 'activeUserContextService'];

    /* @ngInject */

    function leftNavCoreController($rootScope, $state, activeUserContextService) {
        var vm = this;

        vm.impersonating = false;

        vm.getRolesDisplayString = getRolesDisplayString;
        vm.getUserDisplayName = getUserDisplayName;
        vm.impersonatedUser = null;
        vm.getLoggedInUserDisplayName = getLoggedInUserDisplayName;
        vm.getLoggedInUserRolesDisplayString = getLoggedInUserRolesDisplayString;
        vm.stopImpersonation = stopImpersonation;

        activate();

        function activate() {
            vm.impersonatedUser = activeUserContextService.getImpersonatedUser();
        }

        function getRolesDisplayString() {
            return activeUserContextService.getRolesDisplayStringForActiveUser();
        }

        function getUserDisplayName() {
            return activeUserContextService.getActiveUser().displayName;
        }

        function getLoggedInUserDisplayName() {
            return activeUserContextService.getLoggedInUser().displayName;
        }

        function getLoggedInUserRolesDisplayString() {
            return activeUserContextService.getRolesDisplayStringForLoggedInUser();
        }

        function stopImpersonation() {
            activeUserContextService.stopImpersonation();
        }
    }
})();

