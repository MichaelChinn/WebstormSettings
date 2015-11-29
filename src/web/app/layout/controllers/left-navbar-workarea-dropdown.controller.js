/**
 * leftNavWorkAreaDropDownController - controller
 */
(function() {
    angular
        .module('stateeval.layout')
        .controller('leftNavWorkAreaDropDownController', leftNavWorkAreaDropDownController);

    leftNavWorkAreaDropDownController.$inject = ['$rootScope', '$state', 'activeUserContextService', '$modal'];

    /* @ngInject */

    function leftNavWorkAreaDropDownController($rootScope, $state, activeUserContextService, $modal) {
        var vm = this;

        vm.workArea = '';
        vm.changeWorkArea = changeWorkArea;
        vm.workAreas = [];

        activate();

        function activate() {

            vm.workArea =  activeUserContextService.getActiveWorkArea();
            vm.workAreas =  activeUserContextService.getWorkAreas();
        }

        function changeWorkArea()
        {
            activeUserContextService.changeWorkArea(vm.workArea);
            var activeWorkArea = activeUserContextService.getActiveWorkArea();
            if (activeWorkArea.impersonate) {
                openImpersonateModal();
            }
        }

        function openImpersonateModal() {

            vm.modalInstance = $modal.open({
                animation: false,
                templateUrl: 'app/layout/views/impersonate-setup-modal.html',
                controller: 'impersonateSettingsModalController as vm',
                size: 'lg'
            });

            vm.modalInstance.result.then(function (result) {
                activeUserContextService.setImpersonatedUser(result.impersonatedUser);
            });
        }

    }
})();

