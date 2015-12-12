(function() {
    'use strict';

    angular
        .module('stateeval.observation')
        .controller('preConferenceTeacherController', preConferenceTeacherController);

    preConferenceTeacherController.$inject = [
        '$http', '$q', 'logger', '$stateParams', '$state', '$sce', 'config', 'enums',
        'observationService', 'userPromptService', '$filter', 'activeUserContextService', 'evalSessionService', 'utils'
    ];

    /* @ngInject */
    function preConferenceTeacherController($http, $q, logger, $stateParams, $state, $sce, config, enums, observationService, userPromptService, $filter, activeUserContextService, evalSessionService, utils) {
        var vm = this;
        vm.preConference = {};
        ////////////////////////////        
        vm.evalSessionId = parseInt($stateParams.evalSessionId);
        vm.selectedTab = 'prconference';
        vm.save = save;
        vm.sendToEvaluator = sendToEvaluator;

        function activate() {
            if (vm.evalSessionId > 0) {
                evalSessionService.getEvalSessionById(vm.evalSessionId).then(function(evalSession) {
                    vm.evalSession = evalSession;
                    vm.evalSession.evaluatorPreConNotes = $sce.trustAsHtml(vm.evalSession.evaluatorPreConNotes);
                    if (vm.evalSession.preConfStartTime) {
                        vm.evalSession.preConfStartTime = new Date(vm.evalSession.preConfStartTime);
                    }

                    if (vm.evalSession.preConfPromptState != enums.PreConfPromptStateEnum.PromptCreated) {
                        userPromptService.getUserPromptPreConfResponses(vm.evalSessionId).then(function(userPromptResponses) {
                            vm.userPromptResponses = userPromptResponses;
                            for (var i in vm.userPromptResponses) {
                                vm.userPromptResponses[i].response = utils.getTextWithoutCoding(vm.userPromptResponses[i].response);
                            }
                        });
                    }

                });
            }

            
        }

        activate();

        function save() {
            userPromptService.saveUserPromptResponses(vm.userPromptResponses).then(function(data) {
                logger.info("Successfully Saved");
            });
        }

        function sendToEvaluator() {
            observationService.updatePreConfPromptState(vm.evalSessionId, enums.PreConfPromptStateEnum.ReadyForEvaluatorCoding).then(function() {
                logger.info("Sent to evaluator");
            });
        }
    }

})();