(function () {
    'use strict';

    angular.module('stateeval.artifact')
        .controller('artifactsPrivateController', artifactsPrivateController);

    artifactsPrivateController.$inject = ['artifactService', 'enums', '$state', 'activeUserContextService', '$sce', 'utils'];

    function artifactsPrivateController(artifactService, enums, $state, activeUserContextService, $sce, utils) {
        var vm = this;
        vm.artifactService = artifactService;
        vm.enums = enums;

        vm.privateArtifacts = null;

        vm.editArtifact = editArtifact;
        vm.deleteArtifact = deleteArtifact;
        vm.submitArtifact = submitArtifact;
        vm.artifactAlignment = artifactService.artifactAlignmentWithEval;

        ///////////////////////////////

        activate();

        function activate() {
            var request = artifactService.newArtifactBundleRequest(enums.WfState.ARTIFACT, activeUserContextService.user.id);

            artifactService.getArtifactBundlesForEvaluation(request).then(function(artifacts) {
                 vm.privateArtifacts = artifacts;
            })
        }

        function editArtifact(artifact) {
            $state.go('artifact-builder', {artifactId: artifact?artifact.id:0});
        }

        function deleteArtifact(artifact) {
            artifactService.deleteArtifact(artifact).then(function() {
                vm.privateArtifacts = _.reject(vm.privateArtifacts, {id: artifact.id});
            })
        }

        function submitArtifact(artifact) {
            artifactService.submitArtifact(artifact).then(function() {
                vm.privateArtifacts = _.reject(vm.privateArtifacts, {id: artifact.id});
            })
        }
    }

})();