/**
 * Created by anne on 6/19/2015.
 */
(function () {
    'use strict';

    angular
        .module('stateeval.super-admin')
        .factory('superAdminService', superAdminService);

    superAdminService.$inject = ['$http', 'config'];

    function superAdminService($http, config) {

        var service = {
            getImportStagingRecords: getImportStagingRecords,
            getImportErrorRecords: getImportErrorRecords
        };

        return service;

        function getImportStagingRecords(lastName) {
            var url = config.apiUrl + 'admin/importStagingRecords/' + lastName;
            return $http.get(url).then(function(response) {
                return response.data;
            });
        }

        function getImportErrorRecords() {
            var url = config.apiUrl + 'admin/importErrorRecords';
            return $http.get(url).then(function(response) {
                return response.data;
            });
        }
    }
})();

