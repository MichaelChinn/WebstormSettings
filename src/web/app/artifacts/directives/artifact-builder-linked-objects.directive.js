/**
 * Created by anne on 11/30/2015.
 */

(function() {
    'use strict';

    angular.module('stateeval.artifact')
        .directive('artifactBuilderLinkedObjects', artifactBuilderLinkedObjectsDirective)
        .controller('artifactBuilderLinkedObjectsController', artifactBuilderLinkedObjectsController);

    artifactBuilderLinkedObjectsController.$inject = ['enums', 'artifactService', '$scope'];

    function artifactBuilderLinkedObjectsDirective() {
        return {
            scope: {
                artifact: '='
            },
            templateUrl: 'app/artifacts/views/artifact-builder-linked-objects.directive.html',
            controller: 'artifactBuilderLinkedObjectsController as vm',
            bindToController: true
        }
    }

    function artifactBuilderLinkedObjectsController(enums, artifactService, $scope) {
        var vm = this;
        vm.enums = enums;
        vm.editModeLinkObject = false;
        vm.linkObjectType = 0;
        vm.unlinkedObservations = [];
        vm.unlinkedGoalBundles = [];
        vm.selectedObservation = null;
        vm.selectedGoalBundle = null;

        vm.doneLinkObject = doneLinkObject;
        vm.cancelLinkObject = cancelLinkObject;
        vm.removeLinkedObservation = removeLinkedObservation;
        vm.removeLinkedGoalBundle = removeLinkedGoalBundle;

        activate();

        function activate() {

            $scope.$watch('vm.artifact', function(newValue, oldValue) {
                if (newValue) {
                    vm.artifact = newValue;
                    loadObservations().then(function () {
                        loadGoalBundles();
                    });
                }
            });
        }

        function loadObservations() {
            return artifactService.getLinkedObservationsForArtifact(vm.artifact.id)
                .then(function (linkedObservations) {
                    vm.artifact.linkedObservations = linkedObservations;
                    return artifactService.getAttachableObservationsForEvaluation();
                }).then(function (observations) {
                    observations.forEach(function (observation) {
                        var match = _.find(vm.artifact.linkedObservations, {id: observation.id});
                        if (!match) {
                            vm.unlinkedObservations.push(observation);
                        }
                    })
                });
        }

        function loadGoalBundles() {
            return artifactService.getLinkedStudentGrowthGoalBundlesForArtifact(vm.artifact.id)
                .then(function (linkedGoalBundles) {
                    vm.artifact.linkedStudentGrowthGoalBundles = linkedGoalBundles;
                    return artifactService.getAttachableStudentGrowthGoalBundlesForEvaluation();
                }).then(function (goalBundles) {
                    goalBundles.forEach(function (goalBundle) {
                        var match = _.find(vm.artifact.linkedStudentGrowthGoalBundles, {id: goalBundle.id});
                        if (!match) {
                            vm.unlinkedGoalBundles.push(goalBundle);
                        }
                    })
                });
        }

        function doneLinkObject() {
            switch (vm.linkObjectType) {
                case enums.LinkedItemType.OBSERVATION:
                    vm.artifact.linkedObservations.push(vm.selectedObservation);
                    vm.unlinkedObservations = _.reject(vm.unlinkedObservations, {id: vm.selectedObservation});
                    artifactService.saveArtifact(vm.artifact);
                    break;
                case enums.LinkedItemType.STUDENT_GROWTH_GOAL:
                    vm.artifact.linkedStudentGrowthGoals.push(vm.selectedGoalBundle);
                    vm.unlinkedGoalBundles = _.reject(vm.unlinkedGoalBundles, {id: vm.selectedGoalBundle});
                    artifactService.saveArtifact(vm.artifact);
                    break;
            }

            vm.editModeLinkObject = false;
        }

        function cancelLinkObject() {
            vm.editModeLinkObject = false;
        }

        function removeLinkedObservation(observation) {
            vm.artifact.linkedObservations = _.reject(vm.artifact.linkedObservations, {id: observation.id});
            vm.unlinkedObservations.push(observation);
            artifactService.saveArtifact(vm.artifact);
        }

        function removeLinkedGoalBundle(goalBundle) {
            vm.artifact.linkedStudentGrowthGoals = _.reject(vm.artifact.linkedStudentGrowthGoals, {id: goalBundle.id});
            vm.unlinkedGoalGundles.push(goalBundle);
            artifactService.saveArtifact(vm.artifact);
        }
    }

})();
