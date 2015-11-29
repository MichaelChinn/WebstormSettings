/**
 * editFrameworkController - controller
 */
(function () {
    'use strict';

    angular
        .module('stateeval.district-admin')
        .controller('editFrameworkController', editFrameworkController);

    editFrameworkController.$inject = ['districtAdminService', 'config', 'enums', '_', 'frameworkService', 'utils', '$state'];

    /* @ngInject */
    function editFrameworkController(districtAdminService, config, enums, _, frameworkService, utils, $state) {
        var vm = this;

        vm.back = back;

        ////////////////////////////
        activate();

        function activate() {
        }

        function back() {
            $state.go('select-frameworks');
        }
    }

})();