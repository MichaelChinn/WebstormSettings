
(function() {

    angular
        .module('stateeval.configuration')
        .factory('emailRecipientService', emailRecipientService);

    emailRecipientService.$inject = ['_', 'enums', '$http', '$q', 'logger', 'config'];

    /* @ngInject */
    function emailRecipientService(_, enums, $http, $q, logger, config) {
        var service = {
            activate: activate,
            getEventTypes: getEventTypes,
            getMailDeliveryTypes: getMailDeliveryTypes,
            getEmailRecipientConfigs: getEmailRecipientConfigs,
            saveEmailRecipientConfigs: saveEmailRecipientConfigs
        };

        ////////////////

        function activate() {

        }

        activate();

        function getEventTypes() {
            var url = config.apiUrl + 'eventtypes';

            return $http.get(url).then(function (events) {
                return events.data;
            });            
        }

        function getMailDeliveryTypes() {
            var url = config.apiUrl + 'typedata/emaildeliverytypes';

            return $http.get(url).then(function (emailDeliveryTypes) {
                return emailDeliveryTypes.data;
            });
        }
        
        function getEmailRecipientConfigs(userId) {
            var url = config.apiUrl + 'emailrecipientconfigs/' + userId;

            return $http.get(url).then(function (emailRecipients) {
                return emailRecipients.data;
            });
        }

        function saveEmailRecipientConfigs(emailRecipientConfigs) {
            var url = config.apiUrl + 'emailrecipientconfig/save';

            return $http.post(url, emailRecipientConfigs).then(function (emailRecipients) {
                return emailRecipients.data;
            });
        }

        return service;
    }

})();

