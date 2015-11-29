/**
 * globalController - controller
 */
(function() {
    angular
        .module('stateeval.core')
        .controller('globalController', globalController);

    globalController.$inject = ['$rootScope'];

    /* @ngInject */

    function globalController($rootScope) {
        var vm = this;

        vm.errorMessage = '';

        activate();

        function activate() {

            $rootScope.$on('server-error', function (name, message) {
                vm.errorMessage = message;
                //  $state.go('server-error');
            });
            $rootScope.$on('script-error', function (name, message) {
                vm.errorMessage = message;
                //  $state.go('server-error');
            });
        }
    }
})();

