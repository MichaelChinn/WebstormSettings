

(function () {

    angular
        .module('stateeval.reports')
        .factory('reportService', reportService);

    reportService.$inject = ['_', 'enums', '$http', '$q', 'logger', 'config', 'rubricUtils', 'localStorageService', 'activeUserContextService'];

    /* @ngInject */
    function reportService(_, enums, $http, $q, logger, config, rubricUtils, localStorageService, activeUserContextService) {
        var service = {
            activate: activate,
            getSummativeRport: getSummativeRport
        };

        ////////////////

        function activate() {

        }

        activate();

        return service;

        function getSummativeRport() {
            var url = config.apiUrl + 'reports/summativereport';
            return $http.get(url).then(function(reportModel) {
                return reportModel.data;
            });
        }
    }
})();

