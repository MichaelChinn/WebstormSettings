(function () {
'use strict';

    angular.module('stateeval.artifact')
    .directive('artifactLibitems', artifactLibitems)
    .controller('artifactLibItemsController', artifactLibItemsController);

    artifactLibItemsController.$inject = ['artifactService'];

    function artifactLibitems() {
        return {
            restrict: 'E',
            scope: {
                artifact: '=',
                showHeader: '='
            },
            templateUrl: 'app/artifacts/views/artifact-libitems.directive.html',
            controller: 'artifactLibItemsController as vm',
            bindToController: true
        }
    }

    function artifactLibItemsController(artifactService) {
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
