
(function() {

    angular
        .module('stateeval.core')
        .factory('locationService', locationService);

    locationService.$inject = ['_', '$http', 'config'];

    /* @ngInject */
    function locationService(_, $http, config) {

        var service = {
            getSchoolsInDistrict: getSchoolsInDistrict
        };

        return service;

        ////////////////

        function getSchoolsInDistrict(districtCode) {
            var url = config.apiUrl + 'schoolsInDistrict/' + districtCode;
            return $http.get(url).then(function(response) {
                return response.data;
            })
        }
    }
})();

