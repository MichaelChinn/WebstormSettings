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

        vm.editMode=true;
        vm.editModeBtnText = 'Done';
        vm.observations = [];
        vm.goalBundles = [];
        vm.assessments = [];

        vm.toggleEditMode = toggleEditMode;
        vm.clear = clear;

        activate();

        function activate() {

            $scope.$watch('vm.artifact', function(newValue, oldValue) {
                if (newValue) {
                    vm.artifact = newValue;
                    loadObservations()
                        .then(function () {
                            return loadGoalBundles();
                        })
                        .then(function() {
                            return loadSelfAssessments();
                        })
                        .then(function() {
                            if (vm.artifact.linkedObservations.length>0 ||
                                vm.artifact.linkedStudentGrowthGoalBundles.length>0 ||
                                vm.artifacts.linkedSelfAssessments.length>0) {
                                vm.editMode=false;
                                vm.editModeBtnText = 'Edit';
                            }
                        })
                }
            });
        }

        function clear() {
            vm.artifact.linkedObservations = [];
            vm.artifact.linkedStudentGrowthGoals = [];
            artifactService.saveArtifact(vm.artifact);
        }

        function toggleEditMode() {
            vm.editMode=!vm.editMode;
            vm.editModeBtnText = vm.editMode?"Done":"Edit";
            artifactService.saveArtifact(vm.artifact);
        }

        function loadSelfAssessments() {
            return artifactService.getAttachableSelfAssessmentsForEvaluation().then(function(assessments) {
                vm.assessments = assessments;
            })
        }

        function loadObservations() {
            return artifactService.getAttachableObservationsForEvaluation().then(function(observations) {
                vm.observations = observations;
            })
        }

        function loadGoalBundles() {
            return artifactService.getAttachableStudentGrowthGoalBundlesForEvaluation().then(function (goalBundles) {
                vm.goalBundles = goalBundles;
            });
        }
    }

})();
