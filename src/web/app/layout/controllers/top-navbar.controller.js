/**
 * topNavBarController - controller
 */
(function() {
    angular
        .module('stateeval.layout')
        .controller('topNavBarController', topNavBarController);

    topNavBarController.$inject = ['$rootScope', '$state', 'activeUserContextService'];

    /* @ngInject */

    function topNavBarController($rootScope, $state, activeUserContextService) {
        var vm = this

        vm.frameworks = null;
        vm.framework = null;
        vm.frameworkId = null;

        vm.changeFramework = changeFramework;

        $rootScope.$on('change-framework-context', function () {
            setupFrameworkContext();
        });

        $rootScope.$on('change-framework', function () {
            setupFrameworkContext();
        });

        activate();

        function activate() {
            setupFrameworkContext();
        }

        function setupFrameworkContext() {
            if (activeUserContextService.getActiveFramework() != null) {

                var frameworkContext = activeUserContextService.getFrameworkContext();
                vm.frameworks = frameworkContext.frameworks;
                vm.framework = activeUserContextService.getActiveFramework();
                vm.frameworkId = vm.framework.id;
            }
        }

        function changeFramework() {
            vm.framework = _.findWhere(vm.frameworks, {'id': vm.frameworkId}).framework;
            activeUserContextService.setActiveFramework(vm.framework);
        }
    }
})();

