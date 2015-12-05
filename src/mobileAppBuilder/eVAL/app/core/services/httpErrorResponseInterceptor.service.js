/**
 * Created by anne on 6/26/2015.
 */

(function() {

    angular
        .module('stateeval.core')
        .factory('httpErrorResponseInterceptor', httpErrorResponseInterceptor);

    httpErrorResponseInterceptor.$inject = ['$q', '$location'];

    /* @ngInject */
    function httpErrorResponseInterceptor($q, $location) {

        return {
            response: function(responseData) {
                return responseData;
            },
            responseError: function error(response) {
                switch (response.status) {
                    case 401:
                        $location.path('/login');
                        break;
                    case 404:
                        $location.path('/404');
                        break;
                    default:
                        $location.path('/server-error');
                }

                return $q.reject(response);
            }
        };
    }

    /*
    angular.module('stateeval.core')
        .config(['$httpProvider', function($httpProvider) {
            $httpProvider.interceptors.push('httpErrorResponseInterceptor');
        }
    ]);
    */

})();

