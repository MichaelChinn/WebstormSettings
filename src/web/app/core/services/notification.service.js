(function() {

    angular
        .module('stateeval.core')
        .factory('notificationService', notificationService);

    /* @ngInject */
    notificationService.$inject = ['$http', '$q', 'logger', 'config', 'enums', 'activeUserContextService'];

    function notificationService($http, $q, logger, config, enums, activeUserContextService) {

        var service = {
            getNotificationWorkedOn: getNotificationsWorkedOn,
            getNotificationsToTorFromTee: getNotificationsToTorFromTee,
            getNotificationsToTeeFromTor: getNotificationsToTeeFromTor
        };

        return service;

        function getNotificationsWorkedOn() {
            var userId = activeUserContextService.getActiveUser().id;
            var url = config.apiUrl + 'notifications/workedon/' + userId;

            return $http.get(url).then(function(response) {
                return response.data;
            });
        }

        function getNotificationsToTorFromTee() {
            var evaluatorId = activeUserContextService.getActiveUser().id;
            var evaluateeId = activeUserContextService.context.evaluatee.id;
            var url = config.apiUrl + 'notifications/receivedby/' + evaluatorId + '/createdBy/' + evaluateeId;

            return $http.get(url).then(function(response) {
                return response.data;
            });
        }

        function getNotificationsToTeeFromTor() {
            var evaluatorId = activeUserContextService.getActiveUser().id;
            var evaluateeId = activeUserContextService.context.evaluatee.id;
            var url = config.apiUrl + 'notifications/receivedby/' + evaluateeId + '/createdBy/' + evaluatorId;

            return $http.get(url).then(function(response) {
                return response.data;
            });
        }
    }

})();

