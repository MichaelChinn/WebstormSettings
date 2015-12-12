(function () {
    'use strict';

    angular.module('stateeval.artifact')
        .controller('artifactsRejectedController', artifactsRejectedController);

    artifactsRejectedController.$inject = ['artifactService', 'enums', '$state', 'activeUserContextService', '$sce', 'utils'];

    function artifactsRejectedController(artifactService, enums, $state, activeUserContextService, $sce, utils) {
        var vm = this;
        vm.artifactService = artifactService;
        vm.enums = enums;

        vm.rejectedArtifacts = null;

        vm.editArtifact = editArtifact;
        vm.deleteArtifact = deleteArtifact;
        vm.submitArtifact = submitArtifact;
        vm.rejectionReason = rejectionReason;
        vm.artifactAlignment = artifactService.artifactAlignmentWithEval;

        ///////////////////////////////

        activate();

        function activate() {
            var request = artifactService.newArtifactBundleRequest(enums.WfState.ARTIFACT_REJECTED, activeUserContextService.user.id);

            artifactService.getArtifactBundlesForEvaluation(request).then(function(artifacts) {
                vm.rejectedArtifacts = artifacts;
            })
        }

        function rejectionReason(artifact) {
            return utils.mapArtifactRejectionTypeToString(artifact.rejectionType);
        }

        function editArtifact(artifact) {
            $state.go('artifact-builder-rejected', {artifactId: artifact?artifact.id:0});
        }

        function deleteArtifact(artifact) {
            artifactService.deleteArtifact(artifact).then(function() {
                vm.rejectedArtifacts = _.reject(vm.rejectedArtifacts, {id: artifact.id});
            })
        }

        function submitArtifact(artifact) {
            artifactService.submitArtifact(artifact).then(function() {
                vm.rejectedArtifacts = _.reject(vm.rejectedArtifacts, {id: artifact.id});
            })
        }
    }

})();