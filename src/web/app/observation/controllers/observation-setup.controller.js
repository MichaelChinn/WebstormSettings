(function() {
    'use strict';

    angular
        .module('stateeval.observation')
        .controller('observationSetupController', observationSetupController);

    observationSetupController.$inject = ['$q', 'logger', '$stateParams', '$state', 'config', 'enums', 'evalSessionService', 'observationService', '$filter', 'userActivityService', 'activeUserContextService'];

    /* @ngInject */
    function observationSetupController($q, logger, $stateParams, $state, config, enums, evalSessionService, observationService, $filter, userActivityService, activeUserContextService) {
        var vm = this;
        vm.observation = {};
        vm.evalSessionId = parseInt($stateParams.evalSessionId);
        vm.saveObservation = saveObservation;
        vm.rubricRows = [];
        vm.evaluationType = activeUserContextService.getActiveEvaluationType();
        vm.isEvaluator = activeUserContextService.context.isEvaluator();
        vm.isObservationReadOnly = !vm.isEvaluator;

        function activate() {            
            if (vm.evalSessionId > 0) {
                observationService.getObservation(vm.evalSessionId).then(function (observation) {
                    vm.observation = observation;
                    if (vm.observation.observeStartTime) {
                        vm.observation.observeStartTime = new Date(vm.observation.observeStartTime);
                    }

                    if (vm.observation.preConfStartTime) {
                        vm.observation.preConfStartTime = new Date(vm.observation.preConfStartTime);
                    }

                    if (vm.observation.postConfStartTime) {
                        vm.observation.postConfStartTime = new Date(vm.observation.postConfStartTime);
                    }
                    
                });                


                observationService.getRubricRowFocuses(vm.evalSessionId).then(function (rubricRows) {
                    vm.rubricRows = rubricRows;
                });
            }
        }


        function saveObservation() {
            observationService.saveObservation(vm.observation).then(function (result) {
                //vm.evalSession.id = result.id;
                userActivityService.saveObservationActivity(vm.observation);
                logger.info("Successfully Saved");
                $state.go("observations");
            });

            observationService.saveRubricRowFocuses(vm.evalSessionId, vm.rubricRows).then(function (data) {
            });
        }


        activate();

    }

})();