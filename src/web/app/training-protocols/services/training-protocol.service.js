(function() {
 'use strict';

    angular
        .module('stateeval.training-protocols')
        .factory('trainingProtocolService', trainingProtocolService);

    trainingProtocolService.$inject = ['config', '$http'];

    /* @ngInject */
    function trainingProtocolService(config, $http) {
        var service = {
            getTrainingProtocols : getTrainingProtocols,
            getTrainingProtocolLabelGroups: getTrainingProtocolLabelGroups
        };

        return service;

        ////////////////

        function getTrainingProtocolLabelGroups() {
            var url = config.apiUrl + '/trainingprotocollabelgroups';
            return $http.get(url)
                .then(function (response) {
                    return response.data;
                });
        }

        function getTrainingProtocols() {
            var url = config.apiUrl + '/trainingprotocols';
            return $http.get(url)
                .then(function (response) {
                    return response.data;
                });
        }
    }

})();