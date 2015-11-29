(function () {
    'use strict';

    angular
        .module('stateeval.prompt')
        .controller('promptBankController', promptBankController);

    promptBankController.$inject = ['$q', 'logger', '$stateParams', 'config', 'enums', '$filter',
        'activeUserContextService', 'userService', 'userPromptService'];

    function promptBankController($q, logger, $stateParams, config, enums, $filter,
                                  activeUserContextService, userService, userPromptService) {
        var vm = this;

        vm.evaluationType = $stateParams.evaluationtype;
        vm.showEvaluatorPrompts = false;
        vm.showSchoolPrompts = false;
        vm.districtTabIsActive = false;
        vm.schoolTabIsActive = false;
        vm.evaluatorTabIsActive = false;

        vm.preConfEvaluatorGridOption = {
            evaluationType: vm.evaluationType,
            promptType: enums.PromptType.PreConf,
            editable: true,
            admin: false,
            gridDataFcn: function() {
                return userPromptService.getEvaluatorDefinedQuestionBankUserPrompts(
                    enums.PromptType.PreConf,
                    vm.evaluationType,
                    enums.WfState.USERPROMPT_FINALIZED);
            }
        };

        vm.postConfEvaluatorGridOption = {
            evaluationType: vm.evaluationType,
            promptType: enums.PromptType.PostConf,
            editable: true,
            gridDataFcn: function() {
                return userPromptService.getEvaluatorDefinedQuestionBankUserPrompts(
                    enums.PromptType.PostConf,
                    vm.evaluationType,
                    enums.WfState.USERPROMPT_FINALIZED);
            }
        };

        vm.preConfSchoolGridOption = {
            evaluationType: vm.evaluationType,
            promptType: enums.PromptType.PreConf,
            editable: false,
            gridDataFcn: function() {
                return userPromptService.getSchoolAdminDefinedQuestionBankUserPrompts(
                    enums.PromptType.PreConf,
                    vm.evaluationType,
                    enums.WfState.USERPROMPT_FINALIZED);
            }
        };

        vm.postConfSchoolGridOption = {
            evaluationType: vm.evaluationType,
            promptType: enums.PromptType.PostConf,
            editable: false,
            gridDataFcn: function() {
                return userPromptService.getSchoolAdminDefinedQuestionBankUserPrompts(
                    enums.PromptType.PostConf,
                    vm.evaluationType,
                    enums.WfState.USERPROMPT_FINALIZED);
            }
        };

        vm.preConfDistrictGridOption = {
            evaluationType: vm.evaluationType,
            promptType: enums.PromptType.PreConf,
            editable: false,
            gridDataFcn: function() {
                return userPromptService.getDistrictAdminDefinedQuestionBankUserPrompts(
                    enums.PromptType.PreConf,
                    vm.evaluationType,
                    enums.WfState.USERPROMPT_FINALIZED);
            }
        };

        vm.postConfDistrictGridOption = {
            evaluationType: vm.evaluationType,
            promptType: enums.PromptType.PostConf,
            editable: false,
            gridDataFcn: function() {
                return userPromptService.getDistrictAdminDefinedQuestionBankUserPrompts(
                    enums.PromptType.PostConf,
                    vm.evaluationType,
                    enums.WfState.USERPROMPT_FINALIZED);
            }
        };

        activate();

        function activate() {

            // can't just check their role, need to see what area they are actively working in.
            var workAreaTag = activeUserContextService.context.orientation.workAreaTag;
            var userIsASchoolAdmin = (workAreaTag === 'SA');
            var userIsADistrictAdmin = (workAreaTag === 'DA');
            var userIsDistrictEvaluator = (workAreaTag === 'DE' || workAreaTag === 'DTE');

             vm.showSchoolPrompts = !userIsADistrictAdmin && !userIsDistrictEvaluator;
            vm.showEvaluatorPrompts = !userIsADistrictAdmin && !userIsASchoolAdmin;

            vm.districtTabIsActive = userIsADistrictAdmin;
            vm.schoolTabIsActive = userIsASchoolAdmin;
            vm.evaluatorTabIsActive = !userIsADistrictAdmin && !userIsASchoolAdmin;

            vm.preConfDistrictGridOption.editable = userIsADistrictAdmin;
            vm.postConfDistrictGridOption.editable = userIsADistrictAdmin;

            vm.preConfSchoolGridOption.editable = userIsASchoolAdmin;
            vm.postConfSchoolGridOption.editable = userIsASchoolAdmin;
        }
    }

})();