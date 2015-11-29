(function () {
    'use strict';

    angular.module('stateeval.artifact')
        .controller('submittedArtifactSummaryController', submittedArtifactSummaryController);

    submittedArtifactSummaryController.$inject = ['artifactService', 'enums', 'activeUserContextService',
        '$stateParams', '_', 'artifact', 'utils', 'rubricUtils'];

    function submittedArtifactSummaryController(artifactService, enums, activeUserContextService,
         $stateParams, _, artifact, utils, rubricUtils) {
        var vm = this;

        // from resolve
        vm.artifact = artifact;

        vm.objectType = enums.LinkedItemType.ARTIFACT;
        vm.getEvaluatorDisplayName = activeUserContextService.getEvaluatorDisplayName;
        vm.evaluateeDisplayName = '';

        //////////////////////////////////////

        activate();

        function activate() {
            vm.evaluateeDisplayName = activeUserContextService.context.evaluatee.displayName;
        }
    }
})();


