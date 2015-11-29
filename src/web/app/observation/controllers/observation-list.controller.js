(function() {
    'use strict';

    angular
        .module('stateeval.observation')
        .controller('observationListController', observationListController);

    observationListController.$inject = ['$q', 'logger', '$stateParams', '$state', 'config', 'enums', 'evalSessionService', 'observationService', '$filter', 'activeUserContextService'];

    /* @ngInject */
    function observationListController($q, logger, $stateParams, $state, config, enums, evalSessionService, observationService, $filter, activeUserContextService) {
        var vm = this;
        vm.observations = [];
        vm.createNewObservation = createNewObservation;
        vm.editObservation = editObservation;
        vm.obsTypeSelectionWindow = {};
        vm.openObsSelectionWindow = openObsSelectionWindow;
        vm.isEvaluator = activeUserContextService.context.isEvaluator();

        vm.frameworks = [
            {
                id: 1,
                name: "Instructinal Framework"
            },
            {
                id: 2,
                name: "State Framework"
            }
        ];

        ////////////////////////////

        activate();
 

        function activate() {
            observationService.getObservations().then(function(observations) {
                vm.observations = observations;
                vm.observationsInProgress = _.where(observations, { wfState: enums.WfState.OBS_IN_PROGRESS_TOR });
                vm.observationsCompleted = _.where(observations, { wfState: enums.WfState.OBS_SUBMITTED_TOR });
            });

            observationService.getUnlinkedArtifactBundles().then(function (artifactBundles) {
                var observationParam = observationService.getObservationParam();
                for (var i in artifactBundles) {
                    var artifactBundle = artifactBundles[i];
                    if (artifactBundle.createdByUserId == observationParam.evaluatorId) {
                        artifactBundle.source = "Principal";
                    }

                    if (artifactBundle.createdByUserId == observationParam.evaluateeId) {
                        artifactBundle.source = "Teacher";
                    }
                }

                vm.unlinkedEvidences = artifactBundles;

            });
        }

        function createNewObservation() {
            observationService.createNewObservation().then(function(data) {
                $state.go("observation.setup", { evalSessionId: data.id });
            });
            
        }

        function editObservation(evalSessionId) {
            $state.go("observation.setup", { evalSessionId: evalSessionId });
        }        
        

        function openObsSelectionWindow() {
            var dlgOptions = {
                width: 380,
                height: 150,
                visible: false,
                actions: [

                    "Maximize",
                    "Close"
                ]
            };

            vm.obsTypeSelectionWindow.setOptions(dlgOptions);
            

            vm.obsTypeSelectionWindow.center();
            vm.obsTypeSelectionWindow.open();
        };
    }

})();