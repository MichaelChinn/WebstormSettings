(function () {
    'use strict';

    angular.module('stateeval.resource')
        .controller('resourceListController', resourceListController);

    resourceListController.$inject = ['resourceService', '$state', 'rubricUtils', 'frameworkService'];

    function resourceListController(resourceService, $state, rubricUtils, frameworkService) {
        var vm = this;
        vm.activeUser = resourceService.activeUser;
        vm.resourceBox = resourceService.resourceBox;
        console.log(vm.activeUser);


        vm.alignmentToString = alignmentToString;
        vm.resourceTypeToString = resourceTypeToString;
        vm.deleteResource = deleteResource;
        vm.editResource = editResource;
        vm.view = view;
        vm.click = click;

        function click() {
            console.log(vm.resourceBox);
        }
        function resourceTypeToString(resource) {
            return 'this is what kind of resource it is';
        }

        function alignmentToString(resource) {
            return 'these are the alignments';
        }

        function deleteResource(resource) {
            resourceService.deleteResource(resource);
        }

        function editResource(resource, evaluationType) {
            var framework = frameworkService.get

            resourceService.resourceBox.localResource = resource || resourceService.newResource();
            $state.go('resource-builder');
        }

        function view(resource) {
            resourceService.resourceBox.localResource = resource;
            $state.go('resource-view');
        }
    }
})
();