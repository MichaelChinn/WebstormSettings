(function() {
    'use strict';

    angular
        .module('stateeval.observation')
        .controller('preConferenceController', preConferenceController);

    preConferenceController.$inject = [
        '$http', '$q', 'logger', '$stateParams', '$state','$sce', 'config', 'enums',
        'observationService', 'userPromptService', '$filter', 'activeUserContextService', 'evalSessionService'
    ];

    /* @ngInject */
    function preConferenceController($http, $q, logger, $stateParams, $state, $sce, config, enums, observationService, userPromptService, $filter, activeUserContextService, evalSessionService) {
        var vm = this;
        vm.preConference = {};
        ////////////////////////////

        vm.preConfGridOptions = {};
        vm.assignChanged = assignChanged;
        //vm.openWindow = openWindow;
        vm.evalSessionId = parseInt($stateParams.evalSessionId);
        vm.gridData = [];
        vm.rubricRows = [];
        vm.evaluationType = activeUserContextService.getActiveEvaluationType();
        vm.saveRubricRowFocuses = saveRubricRowFocuses;
        vm.selectedTab = 'prconference';

        var dataSource = new kendo.data.DataSource({
            transport: {
                read: function(e) {
                    e.success(vm.gridData);
                    //e.error("XHR response", "status code", "error message");
                }
            }
        });

        function activate() {
            if (vm.evalSessionId > 0) {
                evalSessionService.getEvalSessionById(vm.evalSessionId).then(function(evalSession) {
                    vm.evalSession = evalSession;
                    vm.evalSession.evaluateePreConNotes = $sce.trustAsHtml(vm.evalSession.evaluateePreConNotes);
                    if (vm.evalSession.preConfStartTime) {
                        vm.evalSession.preConfStartTime = new Date(vm.evalSession.preConfStartTime);
                    }
                });
            }

            userPromptService.getPreConferenceUserPrompts(vm.evalSessionId).then(function(userPrompts) {
                vm.userPrompts = userPrompts;
                vm.assignedUserPrompts = _.where(userPrompts, { assigned: true });
                vm.gridData = userPrompts;
                dataSource.read();
            });

            userPromptService.getUserPromptPreConfResponses(vm.evalSessionId).then(function(userPromptResponses) {
                vm.userPromptResponses = userPromptResponses;

                for (var i in vm.userPromptResponses) {
                    var userPromptResponse = vm.userPromptResponses[i];
                    userPromptResponse.response = $sce.trustAsHtml(userPromptResponse.response);
                }

            });

            observationService.getRubricRowFocuses(vm.evalSessionId).then(function(rubricRows) {
                vm.rubricRows = rubricRows;
            });
        }

        activate();

        function assignChanged(item) {
            userPromptService.assignPrompt(item.userPromptID, item.assigned, item.evalSessionID);
        }

        function saveRubricRowFocuses() {
            observationService.saveObservation(vm.evalSession).then(function() {

            });

            observationService.saveRubricRowFocuses(vm.evalSessionId, vm.rubricRows).then(function (data) {
                logger.info("Successfully Saved.");
            });
        };

    }

})();