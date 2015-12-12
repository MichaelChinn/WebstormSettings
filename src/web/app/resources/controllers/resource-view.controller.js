(function () {
    'use strict';

    angular.module('stateeval.resource')
        .controller('resourceViewController', resourceViewController);

    resourceViewController.$inject = ['resourceService'];

    function resourceViewController(resourceService) {
        var vm = this;
        vm.localResource = resourceService.resourceBox.localResource;

        vm.back = back;

        function back() {
            resourceService.resourceBox.localResource = null;
            $state.go('resource-list');
        }
    }
})();