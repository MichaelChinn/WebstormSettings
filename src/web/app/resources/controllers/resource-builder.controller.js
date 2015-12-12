(function () {
    'use strict';

    angular.module('stateeval.resource')
        .controller('resourceBuilderController', resourceBuilderController);

    resourceBuilderController.$inject = ['resourceService', '$state'];

    function resourceBuilderController(resourceService, $state) {
        var vm = this;
        vm.resource = resourceService.resourceBox.localResource;
        vm.back = back;
        vm.save = save;


        function back() {
            resourceService.resourceBox.localResource = null;
            $state.go('resource-list');
        }

        function save(resource) {
            resourceService.saveResource(resource);
            back();
        }


    }
})();