(function () {
    'use strict';

    angular.module('stateeval.artifact')
        .controller('artifactBuilderController', artifactBuilderController);

    artifactBuilderController.$inject = ['artifactService', '$state', '_', 'enums', '$stateParams',
        'activeUserContextService', 'rubricUtils', 'studentGrowthBuildService', 'observationService',  '$q'];

    function artifactBuilderController(artifactService, $state, _, enums, $stateParams,
           activeUserContextService, rubricUtils, studentGrowthBuildService, observationService, $q) {

        var vm = this;
        vm.artifactService = artifactService;

        vm.artifactId = parseInt($stateParams.artifactId);

        vm.goalBundles = [];
        vm.observations = [];

        vm.selectedRubricRow = null;
         vm.itemToEdit = null;

        vm.builderForm = {};

        // functions for artifact
        vm.cancel = cancel;
        vm.submit = submit;
        vm.saveForLater = saveForLater;

        // functions for editing lib item
        // called from the directive
        vm.doneItemEdit = doneItemEdit;
        vm.cancelItemEdit = cancelItemEdit;
        vm.editItem = editItem;
        vm.createItem = createItem;
        vm.linkToObservation = linkToObservation;

        vm.newItem = false;

        ///////////////////////////////////////////

        activate();

        function activate() {

            if (vm.artifactId === 0) {
                vm.artifact = artifactService.newArtifact();
                loadGoalsAndObservations();
            } else {
                artifactService.getArtifactById(vm.artifactId).then(function(artifact) {
                    vm.artifact = artifact;
                    loadGoalsAndObservations();
                })
            }
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

        function linkToObservation(observation) {
            artifactService.linkArtifactToObservation(vm.artifact, observation).then(function() {
                observation.linked = true;
            });
        }

        function linkToStudentGrowthGoalBundle(goalBundle) {
            artifactService.linkArtifactToStudentGrowthGoalBundle(vm.artifact, goalBundle).then(function() {
                goalBundle.linked = true;
            });
        }

        function loadGoalsAndObservations() {
            artifactService.getAttachableObservationsForEvaluation()
                .then(function(observations) {
                    vm.observations = observations;
                    vm.observations.forEach(function(observation) {
                        observation.linked = false;
                    })

                    if (vm.artifact.id !==0) {
                        return artifactService.getLinkedObservationsForArtifact(vm.artifact.id);
                    }
                    else {
                        return $q.when([]);
                    }
                }).then(function(linkedObservations) {

                    linkedObservations.forEach(function(linkedObservation) {
                        var match = _.find(vm.observations, {id: linkedObservation.id});
                        match.linked = true;
                    });

                    return artifactService.getAttachableStudentGrowthGoalBundlesForEvaluation();

                }).then(function(goalBundles) {
                    vm.goalBundles = goalBundles;
                    vm.goalBundles.forEach(function(goalBundle) {
                        goalBundle.linked = false;
                    })

                    // set name to show in dropdown, includes goals so they have sg alignment when choosing their own alignment
                    vm.goalBundles.forEach(function(bundle) {
                        bundle.displayName = (bundle.title + ' - ' + studentGrowthBuildService.getBundleDisplayName(bundle));
                    });

                    if (vm.artifact.id !==0) {
                        return artifactService.getLinkedStudentGrowthGoalBundlesForArtifact(vm.artifact.id);
                    }
                    else {
                        return $q.when([]);
                    }
                }).then (function(linkedBundles) {
                    linkedBundles.forEach(function(linkedBundle) {
                        var match = _.find(vm.goalBundles, {id: linkedBundle.id});
                        match.linked = true;
                    });
                })
        }

        function updateLinkedItems(artifact) {
            artifact.linkedObservations = [];
            vm.observations.forEach(function(observation) {
                if (observation.linked) {
                    artifact.linkedObservations.push(observation);
                }
            });

            artifact.linkedStudentGrowthGoalBundles = [];
            vm.goalBundles.forEach(function(goalBundle) {
                if (goalBundle.linked) {
                    artifact.linkedStudentGrowthGoalBundles.push(goalBundle);
                }
            })
        }

        function save(artifact) {
            updateLinkedItems(artifact);
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
                updateLinkedItems(artifact);
                artifactService.submitArtifact(artifact).then(function () {
                    $state.go('artifacts-submitted');
                })
            }
        }
    }
})
();