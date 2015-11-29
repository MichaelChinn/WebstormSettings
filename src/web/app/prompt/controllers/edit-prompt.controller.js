(function () {
    'use strict';

    angular
        .module('stateeval.prompt')
        .controller('editPromptController', editPromptController);

    editPromptController.$inject = ['$q', 'logger', '$stateParams', '$state', 'config', 'enums',
       'userPromptService', '$filter', 'frameworkService', 'activeUserContextService'];

    function editPromptController($q, logger, $stateParams, $state, config, enums,
        userPromptService, $filter, frameworkService, activeUserContextService) {
        var vm = this;

        vm.userPrompt = {};
        vm.rubricRows = null;
        vm.userPromptId = parseInt($stateParams.userpromptid);
        var evaluationType = $stateParams.evaluationtype;
        var promptType = $stateParams.prompttype;
        vm.evaluationType = evaluationType;
        vm.showRetireCheckBox = false;
        vm.retire = false;
        vm.prompt = null;

        vm.cancel = cancel;
        vm.saveUserPrompt = saveUserPrompt;
        vm.deleteUserPrompt = deleteUserPrompt;

        activate();

        function activate() {

            if (vm.userPromptId == 0) {                
                vm.userPrompt = userPromptService.getNewUserPrompt(vm.evaluationType, promptType);
                vm.showSaveBtn = false;

            } else {
                userPromptService.getUserPromptById(parseInt($stateParams.userpromptid)).then(function (userPrompt) {
                    vm.userPrompt = userPrompt;
                    vm.rubricRows = userPrompt.rubricRows;
                    vm.prompt = vm.userPrompt.prompt;

                    if (vm.userPrompt.wfStateID === enums.WfState.USERPROMPT_IN_PROGRESS) {
                        vm.showSaveBtn = false;
                    }
                    else if (vm.userPrompt.wfStateID != enums.WfState.USERPROMPT_IN_PROGRESS) {
                        vm.showSaveAndFinalizeBtn = false;
                        vm.showSaveWithoutFinalizeBtn = false;
                    }
                });
            }
        }

        function saveUserPrompt() {
            vm.userPrompt.rubricRows = vm.rubricRows;
            vm.userPrompt.prompt = vm.prompt;
            vm.userPrompt.wfStateID = enums.WfState.USERPROMPT_FINALIZED;

            if (vm.retire && vm.userPrompt.wfStateID != enums.WfState.USERPROMPT_RETIRED) {
                    vm.userPrompt.wfStateID = enums.WfState.USERPROMPT_RETIRED;
            }

            userPromptService.saveUserPrompt(vm.userPrompt).then(function (data) {
                returnToPromptBank();
            });
        }

        function deleteUserPrompt(userPromptId) {

        }

        function cancel() {
            returnToPromptBank();
        }

        function returnToPromptBank() {
            $state.go("promptbank", {'evaluationtype': vm.evaluationType});
        }
    }

})();