/**
 * Created by anne on 11/30/2015.
 */

(function() {
    'use strict';

    angular.module('stateeval.artifact')
        .directive('linkedObjectSelector', linkedObjectSelector)
        .controller('linkedObjectSelectorController', linkedObjectSelectorController);

        linkedObjectSelectorController.$inject = ['evaluationService', '_', 'utils'];

    function linkedObjectSelector() {
        return {
            restrict: 'E',
            scope: {
                artifact: '='
            },
            templateUrl: 'app/artifacts/views/linked-object-selector.directive.html',
            controller: 'linkedObjectSelectorController as vm',
            bindToController: true
        }
    }

    function linkedObjectSelectorController(evaluationService, _, utils) {

        var vm = this;
        vm.objectsGroupedByType = null;
        vm.linkedObjects = [];
        vm.linkedObjectTypes = null;

        vm.toggleEditMode = toggleEditMode;
        vm.mapLinkedItemTypeToFullString = utils.mapLinkedItemTypeToFullString;
        vm.clear = clear;
        vm.editMode=true;
        vm.editModeBtnText = 'Done';


        activate();

        function activate() {
            evaluationService.getAllObjectsForEvaluation().then(function (objects) {
                vm.objectsGroupedByType = _.groupBy(objects, 'linkedItemType');
                vm.linkedObjectTypes = Object.keys(vm.objectsGroupedByType);
            });
        }

        function clear() {
            vm.linkedObjects = [];
        }

        function toggleEditMode() {
            vm.editMode=!vm.editMode;
            vm.editModeBtnText = vm.editMode?"Done":"Edit";
        }
    }

})();
