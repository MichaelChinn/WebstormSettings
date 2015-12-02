(function () {
'use strict';

    angular.module('stateeval.artifact')
    .directive('artifactLinkedObjects', artifactLinkedObjects)
    .controller('artifactLinkedObjectsController', artifactLinkedObjectsController);

    artifactLinkedObjectsController.$inject = ['artifactService'];

    function artifactLinkedObjects() {
        return {
            restrict: 'E',
            scope: {
                artifact: '='
            },
            templateUrl: 'app/artifacts/views/artifact-builder-linked-objects.directive.html',
            controller: 'artifactLinkedObjectsController as vm',
            bindToController: true
        }
    }

    function artifactLinkedObjectsController(artifactService) {
        var vm = this;
        //@Params
        //artifact = artifact with current rubric rows

        vm.view = view;
        vm.itemTypeToString = artifactService.itemTypeToString;
        vm.alignmentToString = artifactService.alignmentToString;

        function view(item) {
            artifactService.viewItem(item);
        }

        activate();

        function activate() {

        }

    }

}) ();
