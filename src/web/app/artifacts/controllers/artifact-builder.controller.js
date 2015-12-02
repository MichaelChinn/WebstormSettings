(function () {
    'use strict';

    angular.module('stateeval.artifact')
        .controller('artifactBuilderController', artifactBuilderController);

    artifactBuilderController.$inject = ['artifactService', '$state', '_', 'enums', '$stateParams',
        'activeUserContextService', 'rubricUtils', 'studentGrowthBuildService', 'observationService',  '$q'];

    function artifactBuilderController(artifactService, $state, _, enums, $stateParams,
           activeUserContextService, rubricUtils, studentGrowthBuildService, observationService, $q) {

        var vm = this;
        vm.enums = enums;
        vm.artifactService = artifactService;

        vm.artifactId = parseInt($stateParams.artifactId);
        vm.artifact = null;
        vm.itemToEdit = null;

        vm.builderForm = {};

        // functions for artifact
        vm.cancel = cancel;
        vm.submit = submit;
        vm.saveForLater = saveForLater;

        vm.alignmentDone = alignmentDone;

        // functions for editing lib item
        // called from the directive
        vm.doneItemEdit = doneItemEdit;
        vm.cancelItemEdit = cancelItemEdit;
        vm.editItem = editItem;
        vm.createItem = createItem;
        vm.newItem = false;

        vm.deleteArtifact = deleteArtifact;

        ///////////////////////////////////////////

        activate();

        function activate() {

            artifactService.getArtifactById(vm.artifactId).then(function(artifact) {
                vm.artifact = artifact;
            });
        }

        function deleteArtifact(artifact) {
            artifactService.deleteArtifact(artifact).then(function() {
                goBack();
            })
        }

        function alignmentDone() {
            artifactService.saveArtifact(vm.artifact);
        }

        function doneItemEdit(item) {
            if (vm.newItem) {
                vm.artifact.libItems.push(item);
            }
            vm.itemToEdit = null;
        }

        function cancelItemEdit() {
            vm.itemToEdit = null;
        }

        function editItem(item) {
            vm.newItem = false;
            vm.itemToEdit = item;
        }

        function createItem(item) {
            vm.newItem = true;
            vm.itemToEdit = item;
        }

        function save(artifact) {
            return artifactService.saveArtifact(artifact);
        }

        function goBack() {
            $state.go('artifacts-private');
        }

        function cancel() {
            goBack();
        }

        function saveForLater(artifact) {
            if (vm.builderForm.$valid) {
                save(artifact).then(function () {
                    goBack();
                })
            }
        }

        function submit(artifact) {
            if (vm.builderForm.$valid) {
                artifactService.submitArtifact(artifact).then(function () {
                    $state.go('artifacts-submitted');
                })
            }
        }
    }
})
();