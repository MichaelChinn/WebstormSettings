/**
 * goalsController - controller
 */
(function() {
    'use strict';

angular
    .module('stateeval.student-growth-goals')
    .controller('sgGoalsController', sgGoalsController);

    sgGoalsController.$inject = ['studentGrowthBuildService', '$q', '$stateParams', 'activeUserContextService',
        '$state', 'config', 'enums', 'utils', 'rubricUtils', 'studentGrowthAdminService', 'workAreaService'];

/* @ngInject */
function sgGoalsController(studentGrowthBuildService, $q, $stateParams, activeUserContextService,
         $state, config, enums, utils, rubricUtils, studentGrowthAdminService, workAreaService) {
    var vm = this;

    vm.selectedTab = $state.current.data.selectedTab;
    vm.showPrivateTab = activeUserContextService.context.evaluatee.id == activeUserContextService.user.id;

    ////////////////////////////

    activate();

    function activate() {
    }
}

})();