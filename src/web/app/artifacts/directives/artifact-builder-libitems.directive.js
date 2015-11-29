(function () {
'use strict';

    angular.module('stateeval.artifact')
    .directive('artifactBuilderLibItems', artifactBuilderLibItems)
        .controller('artifactBuilderLibItemsController', artifactBuilderLibItemsController);

    artifactBuilderLibItems.$inject = [];
    artifactBuilderLibItemsController.$inject = ['artifactService', '$state', 'enums'];

    function artifactBuilderLibItems() {
        return {
            restrict: 'E',
            scope: {
                artifact: '=',
                editItemFcn: '=',
                createItemFcn: '='
            },
            templateUrl: 'app/artifacts/views/artifact-builder-libitems.directive.html',
            controller: 'artifactBuilderLibItemsController as vm',
            bindToController: true
        }
    }

    function artifactBuilderLibItemsController(artifactService, $state, enums) {
        var vm = this;

        vm.enums = enums;
        vm.createItem = createItem;
        vm.removeItem = removeItem;
        vm.editItem = editItem;
        vm.viewItem = viewItem;

        vm.itemTypeToString = artifactService.itemTypeToString;
        vm.itemDisplayName = artifactService.libItemDisplayName;

        function editItem(item) {
            vm.editItemFcn(item);
        }

        function createItem(itemType) {
            vm.createItemFcn(artifactService.newLibItem(itemType));
        }
        function removeItem(item) {
            _.remove(vm.artifact.libItems, function (itemInList) {
                return itemInList.id === item.id;
            })
        }

        function viewItem(item) {
            artifactService.viewItem(item);
        }
    }

}) ();
