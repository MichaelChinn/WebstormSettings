
(function () {
    'use strict';

    angular
        .module('stateeval.district-admin')
        .controller('daDashboardController', daDashboardController);

    daDashboardController.$inject = ['districtAdminService'];

    /* @ngInject */
    function daDashboardController(districtAdminService) {
        var vm = this;

        ////////////////////////////

        activate();

        function activate() {
        }
    }

})();