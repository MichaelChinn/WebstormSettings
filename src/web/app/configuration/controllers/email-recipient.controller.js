(function () {
    'use strict';

    angular
        .module('stateeval.prompt')
        .controller('emailRecipientController', emailRecipientController);

    emailRecipientController.$inject = [
        '$q', 'logger', '$stateParams', '$state', 'emailRecipientService', 'activeUserContextService'
    ];

    function emailRecipientController($q, logger, $stateParams, $state, emailRecipientService, activeUserContextService) {
        var vm = this;
        vm.userPrompt = {};
        vm.saveEmailDeliveryConfigs = saveEmailDeliveryConfigs;



        var userId = activeUserContextService.getActiveUser().id;

        function activate() {
            vm.mailRecipientConfigs = [];
            emailRecipientService.getEmailRecipientConfigs(userId).then(function (emailReceipientConfigs) {
                emailRecipientService.getEventTypes().then(function (eventTypes) {
                    vm.eventTypes = eventTypes;
                    for (var i in vm.eventTypes) {
                        var eventType = vm.eventTypes[i];
                        var mailConfig = _.where(emailReceipientConfigs, { eventTypeID: eventType.eventTypeId });
                        if (mailConfig && mailConfig.length > 0) {
                            mailConfig = mailConfig[0];
                            vm.mailRecipientConfigs.push(mailConfig);
                        } else {
                            vm.mailRecipientConfigs.push(
                            {
                                eventTypeName: eventType.name,
                                id: 0,
                                recipientId: userId,
                                eventTypeID: eventType.eventTypeId                                
                            });
                        }
                    }

                });
            });


            emailRecipientService.getMailDeliveryTypes().then(function (mailDeliveryTypes) {
                vm.mailDeliveryTypes = mailDeliveryTypes;
            });


        }

        function saveEmailDeliveryConfigs() {
            emailRecipientService.saveEmailRecipientConfigs(vm.mailRecipientConfigs);
        }
        activate();
    }
})();