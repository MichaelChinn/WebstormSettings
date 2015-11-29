/**
 * Created by anne on 11/8/2015.
 */
/// <reference path="../views/student-growth-information.html" />
/**
 * editBundleController - controller
 */

(function() {
    'use strict';

angular
    .module('stateeval.student-growth-goals')
    .controller('sgGoalBundleController', sgGoalBundleController);

sgGoalBundleController.$inject = ['studentGrowthBuildService', 'activeUserContextService' , '$state', '$stateParams'];

/* @ngInject */
function sgGoalBundleController(studentGrowthBuildService, activeUserContextService, $state, $stateParams) {
    var vm = this;
    vm.selectedTab = $state.current.data.selectedTab;
    vm.changeTab = changeTab;

    ////////////////////////

    activate();

    function activate() {
    }

    function changeTab(state) {
        $state.go(state, {id: $stateParams.id});
    }
}


})();

