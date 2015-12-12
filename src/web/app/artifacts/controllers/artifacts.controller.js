(function () {
    'use strict';

    angular.module('stateeval.artifact')
        .controller('artifactsController', artifactsController);

    artifactsController.$inject = ['activeUserContextService', '$state'];

    function artifactsController(activeUserContextService, $state) {
        var vm = this;
         vm.isEvaluatee = activeUserContextService.context.evaluatee.id === activeUserContextService.user.id;

        vm.selectedTab = $state.current.data.selectedTab;

        ///////////////////////////////

        activate();

        function activate() {
        }
    }

})();