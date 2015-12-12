(function () {
    angular.module("stateeval.mobile.observation").controller("observationListController", observationListController);

    observationListController.$inject = ['activeUserContextService', 'observationService'];

    function observationListController(activeUserContextService, observationService) {
        var vm = this;
        vm.observations = [];

        function activate() {            
            observationService.getObservations().then(function (observations) {
                vm.observations = observations;
                vm.observationsInProgress = _.where(observations, { wfState: enums.WfState.OBS_IN_PROGRESS_TOR });
                vm.observationsCompleted = _.where(observations, { wfState: enums.WfState.OBS_SUBMITTED_TOR });
            });
        };

        activate();        
    }
})();