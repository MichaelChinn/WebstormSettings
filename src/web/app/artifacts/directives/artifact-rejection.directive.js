/**
 * Created by anne on 9/18/2015.
 */
(function () {
    'use strict';

    angular.module('stateeval.artifact')
        .directive('artifactRejection', artifactRejection)
        .controller('artifactRejectionController', artifactRejectionController);

    artifactRejectionController.$inject = ['artifactService', 'activeUserContextService', 'enums', 'utils'];

    function artifactRejection() {
        return {
            restrict: 'E',
            scope: {
                artifact: '='
            },
            templateUrl: 'app/artifacts/views/artifact-rejection.directive.html',
            controller: 'artifactRejectionController as vm',
            bindToController: true
        }
    }

    function artifactRejectionController(artifactService, activeUserContextService, enums, utils) {
        var vm = this;

        // from directive
        // vm.artifact

        vm.showDetails = false;
        vm.buttonText = 'Show Details';
        vm.rejection = null;
        vm.rejectionReason = '';
        vm.evaluatorDisplayName = '';
        vm.evaluateeDisplayName = '';

        vm.createNewMessage = createNewMessage;
        vm.communicationCreatedByEvaluator = communicationCreatedByEvaluator;
        vm.communicationCreatedBy = communicationCreatedBy;
        vm.toggleExpand = toggleExpand;

        activate();

        function activate() {

            vm.evaluateeDisplayName = activeUserContextService.context.evaluatee.displayName;

            if (vm.artifact.wfState === enums.WfState.ARTIFACT_REJECTED) {
                artifactService.getArtifactRejectionForArtifact(vm.artifact).then(function(rejection) {
                    vm.rejection = rejection;
                    vm.rejectionReason = utils.mapArtifactRejectionTypeToDescriptionString(vm.rejection.rejectionType);
                })
            }
        }

        function toggleExpand() {
            vm.showDetails = !vm.showDetails;
            vm.buttonText = vm.showDetails?"Hide Details":"Show Details";
        }
        function createNewMessage() {
            vm.rejection.communications.push(artifactService.newCommunication(vm.rejection.communnicationSessionKey, vm.rejectMessage))
            artifactService.updateArtifactRejection(vm.rejection)
                .then(function(rejection) {
                    vm.reject = rejection;
                    vm.rejectMessage = '';
                })
        }

        function communicationCreatedByEvaluator(communication) {
            return communication.createdByUserId != activeUserContextService.context.evaluatee.id;
        }

        function communicationCreatedBy(communication) {
            if (communicationCreatedByEvaluator(communication)) {
                return vm.evaluatorDisplayName;
            }
            else {
                return vm.evaluateeDisplayName;
            }
        }
    }
}) ();

