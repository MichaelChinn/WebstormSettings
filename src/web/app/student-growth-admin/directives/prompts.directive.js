/**
 * Created by anne on 11/22/2015.
 */
/**
 * Created by anne on 11/8/2015.
 */

(function() {
    'use strict';

    angular
        .module('stateeval.student-growth-admin')
        .directive('sgSetupPrompts', sgSetupPrompts)
        .controller('sgSetupPromptsController', sgSetupPromptsController);

    sgSetupPromptsController.$inject = ['activeUserContextService', 'enums', 'rubricUtils', 'utils', 'config',
        '$scope', 'studentGrowthAdminService', '$stateParams'];

    function sgSetupPrompts() {
        return {
            templateUrl: "app/student-growth-admin/views/prompts.html",
            controller: "sgSetupPromptsController as vm",
            bindToController: true,
            scope: {
                promptType: '='
            },
            restrict: 'E'
        };
    }
    /* @ngInject */
    function sgSetupPromptsController(activeUserContextService, enums, rubricUtils, utils, config,
              $scope, studentGrowthAdminService, $stateParams) {

        var vm = this;

        vm.enums = enums;
        vm.getSafeHtml = utils.getSafeHtml;
        vm.summernoteOptions = config.summernoteDefaultOptions;
        vm.evaluationType = parseInt($stateParams.evaluationtype);

        vm.availablePrompts = [];
        vm.districtPrompts = [];
        vm.studentGrowthFrameworkNodes = [];
        vm.promptInUse = [];
        vm.prompt = '';
        vm.inEditMode = false;

        vm.togglePromptUse = togglePromptUse;
        vm.promptInUse = promptInUse;
        vm.addPrompt = addPrompt;
        vm.deletePrompt = deletePrompt;

        ////////////////////////

        activate();

        function activate() {

            var framework = activeUserContextService.context.frameworkContext.stateFramework;
            vm.studentGrowthFrameworkNodes =
                rubricUtils.getStudentGrowthFrameworkNodes(framework.frameworkNodes);

            studentGrowthAdminService.getAvailablePrompts(vm.evaluationType, vm.promptType)
                .then(function(availablePrompts) {
                    vm.availablePrompts = availablePrompts;
                    return loadDistrictPrompts();
                });
        }

        function getKey(prompt, node) {
            return prompt.id.toString()+':'+node.id.toString();
        }

        function updatePrompt(prompt) {
            studentGrowthAdminService.updatePrompt(prompt);
        }

        function deletePrompt(prompt) {
            studentGrowthAdminService.deletePrompt(prompt).then(function() {
                vm.availablePrompts = _.reject(vm.availablePrompts, {id: prompt.id});
            })
        }

        function addPrompt() {
            var newPrompt = studentGrowthAdminService.newPrompt(vm.prompt, vm.promptType, vm.evaluationType);
            studentGrowthAdminService.createPrompt(newPrompt).then(function() {
                vm.availablePrompts.push(newPrompt);
                vm.studentGrowthFrameworkNodes.forEach(function(node) {
                    var key = getKey(newPrompt, node);
                    vm.promptInUse[key] = false;
                });
                vm.inEditMode=false;
            })
        }

        function loadDistrictPrompts() {
            return studentGrowthAdminService.getDistrictPrompts(vm.evaluationType, vm.promptType)
                .then(function(districtPrompts) {
                    vm.districtPrompts = _.groupBy(districtPrompts, 'frameworkNodeId');
                    vm.availablePrompts.forEach(function(prompt) {
                        vm.studentGrowthFrameworkNodes.forEach(function(node) {
                            var key = getKey(prompt, node);
                            var match = _.find(vm.districtPrompts[node.id], {formPromptId: prompt.id});
                            vm.promptInUse[key] = match!=undefined;
                        });
                    });
                    vm.test = true;
                });
        }

        function promptInUse(node, prompt) {
            var key = getKey(prompt, node);
            return vm.promptInUse[key];
        }

        function togglePromptUse(node, prompt) {
            studentGrowthAdminService.togglePromptUse(vm.evaluationType, vm.promptType, node.id, prompt!=undefined?prompt.id:null).then(function() {
                var key;
                if (prompt) {
                    key = getKey(prompt, node);
                    vm.promptInUse[key] = !vm.promptInUse[key];
                }
                else {
                    vm.availablePrompts.forEach(function(prompt) {
                        key = getKey(prompt, node);
                        vm.promptInUse[key] = !vm.promptInUse[key];
                    })
                }
            });
        }
    }

})();



