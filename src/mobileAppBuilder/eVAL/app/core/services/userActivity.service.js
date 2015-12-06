/**
 * Created by anne on 8/23/2015.
 */

(function () {
    'use strict';

    angular
        .module('stateeval.core')
        .factory('userActivityService', userActivityService);

    userActivityService.$inject = ['$http', '$rootScope', '$timeout', 'config', 'activeUserContextService'];
    function userActivityService($http, $rootScope, $timeout, config, activeUserContextService) {
        var service = {};

        service.saveObservationActivity = saveObservationActivity;
        service.getuserActivities = getUserActivities;
        service.getRecentActivities = getRecentActivities;

        return service;

        function newUserActivity() {
            var userId = activeUserContextService.getActiveUser().id;
            return {
                userId: userId
            }
        }

        function saveObservationActivity(evalSession) {
            
            var userActivity = newUserActivity();
            userActivity.objectId = evalSession.id;            
            userActivity.type = "Observation";
            userActivity.title = evalSession.title;
            userActivity.url = "#/observation-home/observation/" + evalSession.id + "/observation";
            var evaluatee = activeUserContextService.context.evaluatee;
            if (evaluatee) {
                userActivity.name = evaluatee.displayName;
            }

            return $http.post(config.apiUrl + 'useractivity/save', userActivity)
                .then(function (response) {
                    return response.data;
                });
        }

        function getUserActivities() {
            var userId = activeUserContextService.getActiveUser().id;
            return $http.get(config.apiUrl + 'useractivities/' + userId).then(function (response) {
                return response.data;
            });
        }

        function getRecentActivities() {
            var userId = activeUserContextService.getActiveUser().id;
            return $http.get(config.apiUrl + 'recentactivities/' + userId).then(function (response) {
                return response.data;
            });
        }
    };

})();
