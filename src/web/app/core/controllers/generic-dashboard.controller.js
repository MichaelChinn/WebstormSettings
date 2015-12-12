(function () {
    'use strict';

    angular.module('stateeval.core')
        .controller('genericDashboardController', genericDashboardController);

    genericDashboardController.$inject = ['activeUserContextService', 'workAreaService'];

    function genericDashboardController(activeUserContextService, workAreaService) {
        var vm = this;
        console.log('If you got here something broke');
    }
})();