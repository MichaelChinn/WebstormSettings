(function () {
    'use strict';

    angular.module('stateeval.artifact')
        .controller('artifactsSubmittedController', artifactsSubmittedController);

    artifactsSubmittedController.$inject = ['artifactService', 'enums', '$state', 'activeUserContextService',
        '$sce', 'utils', 'rubricUtils', '$rootScope'];

    function artifactsSubmittedController(artifactService, enums, $state, activeUserContextService,
          $sce, utils, rubricUtils, $rootScope) {

        var vm = this;
        vm.submittedArtifacts = null;

        ///////////////////////////////

        activate();

        function activate() {

            var request = artifactService.newArtifactBundleRequest(enums.WfState.ARTIFACT_SUBMITTED, 0);

            artifactService.getArtifactBundlesForEvaluation(request).then(function(artifacts) {
                vm.submittedArtifacts = artifacts;
            });
        }
    }

})();