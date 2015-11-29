/**
 * Created by anne on 7/30/2015.
 */

(function () {
    'use strict';

    angular
        .module('stateeval.district-admin')
        .factory('districtAdminService', districtAdminService);

    districtAdminService.$inject = ['$http', 'config', 'activeUserContextService'];
    function districtAdminService($http, config, activeUserContextService) {

        var currentDistrictCode = '';

        var service = {
        };

        return service;

    }
})();