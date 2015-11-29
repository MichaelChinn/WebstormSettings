(function () {
    'use strict';

    angular
        .module('stateeval.observation')
        .controller('observationBaseController', observationBaseController);

    observationBaseController.$inject = ['$q', 'logger', '$stateParams', '$state', 'config', 'enums', 'evalSessionService', '$filter', 'observationService', 'activeUserContextService'];

    /* @ngInject */
    function observationBaseController($q, logger, $stateParams, $state, config, enums, evalSessionService, $filter, observationService, activeUserContextService) {
        var vm = this;
        vm.selectedTab = $state.current.name.split('.')[1];
        vm.isEvaluator = activeUserContextService.context.isEvaluator();
    }

})();