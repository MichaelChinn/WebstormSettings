/**
 * Created by anne on 6/26/2015.
 */

(function() {

    angular
        .module('stateeval.core')
        .factory('apiInterceptor', apiInterceptor);

    apiInterceptor.$inject = ['$rootScope', '$q', 'HTTP_DEFAULT_ERROR_MSG', 'HTTP_NETWORK_ERROR_MSG'];

    /* @ngInject */
    function apiInterceptor($rootScope, $q, HTTP_DEFAULT_ERROR_MSG, HTTP_NETWORK_ERROR_MSG) {

        return {
  /*          request: function(config) {
                var currentUser = userStore.getCurrentUser();
                var accessToken = currentUser ? currentUser.accessToken : null;

                if (accessToken) {
                    config.headers.authorization = accessToken;
                }
                return config;
            },*/
            responseError: function error(response) {
                if (response.status === 401) {
                    $rootScope.$broadcast('unauthorized');
                }
                else {
                    //todo-anne: not sure whether these are the correct data fields for all error
                    // conditions
                    var message;
                    if (response.status === 0) {
                        message = response.headers('status-text') || HTTP_DEFAULT_ERROR_MSG;
                        message = HTTP_NETWORK_ERROR_MSG;
                        $rootScope.$broadcast('server-error', message);
                        return $q.reject(response);
                    }
                    if (response.status === 400) {
                        message = response.headers('status-text') || HTTP_DEFAULT_ERROR_MSG;
                        message += ' STATUS: ' + response.status;
                        message += ' URL: ' + response.config.url;
                        message += ' MESSAGE: ' + response.data.message;
                        message += ' DETAIL: ' + response.data.messageDetail;
                        $rootScope.$broadcast('server-error', message);
                        return $q.reject(message);
                    }
                    // todo=anne not sure whether all of the response fields are available for the remaining types
                    else if (response.status == 500) { // internal server error
                        message = response.headers('status-text') || HTTP_DEFAULT_ERROR_MSG;
                        message += ' STATUS: ' + response.status;
                        message += ' URL: ' + response.config.url;
                        message += ' MESSAGE: ' + response.data.message;
                        message += ' DETAIL: ' + response.data.exceptionMessage;
                        $rootScope.$broadcast('server-error', message);
                        return $q.reject(message);
                    }
                }
                return response;
            }
        };
    }

})();

