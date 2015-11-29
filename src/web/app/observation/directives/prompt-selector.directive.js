(function () {
    'use strict';
    angular.module('stateeval.observation')
        .directive('promptSelector', promptSelectorDirective)
        .controller('promptSelectorController', promptSelectorController);

    promptSelectorDirective.$inject = ['$rootScope', '$q', '$http', '$timeout'];
    promptSelectorController.$inject = ['$scope', 'activeUserContextService', 'userPromptService', 'observationService',
        'config', '_', '$rootScope', '$stateParams', 'enums', 'logger'];
    function promptSelectorDirective($rootScope, $q, $http, $timeout) {
        return {
            restrict: 'E',
            scope: {                
                userPrompts: '='
            },
            templateUrl: 'app/observation/views/prompt-selector.html',
            link: function (scope, elm, attrs) {
                scope.$watch('framework', function (newValue, oldValue) {

                });
            },
            controller: 'promptSelectorController as vm'
        }
    }

    function promptSelectorController($scope, activeUserContextService, userPromptService, observationService, config, _, $rootScope, $stateParams, enums, logger) {
        var vm = this;
        vm.evalSessionId = parseInt($stateParams.evalSessionId);
        vm.assignedUserPrompts = [];
        vm.selectedPrompt = {};
        vm.selectedPromptAssigned = {};
        vm.selectPromptRow = selectPromptRow;
        vm.selectPromptAssignedRow = selectPromptAssignedRow;
        vm.assign = assign;
        vm.unAssign = unAssign;
        vm.done = done;
        vm.editView = false;
        vm.edit = edit;
        vm.send = send;
        vm.addNewPrompt = addNewPrompt;
        

        activate();
        function activate() {
            userPromptService.getPreConferenceUserPrompts(vm.evalSessionId).then(function (userPrompts) {
                vm.userPrompts = userPrompts;
                vm.assignedUserPrompts = _.where(userPrompts, { assigned: true });
            });

            userPromptService.getUserPromptPreConfResponses(vm.evalSessionId).then(function (userPromptResponses) {
                vm.userPromptResponses = userPromptResponses;
            });
        }

        function assign() {
            var item = vm.selectedPrompt;
            if (_.findWhere(vm.assignedUserPrompts, { userPromptID: item.userPromptID })) {
                return;
            }

            if (item) {
                item.assigned = !item.assigned;
                userPromptService.assignPrompt(item.userPromptID, item.assigned, item.evalSessionID).then(function (data) {
                    vm.selectedPrompt = {};
                    activate();
                });
                //vm.selectedPrompt = {};
            }
        }

        function unAssign() {
            var item = vm.selectedPromptAssigned;
            if (item) {
                item.assigned = !item.assigned;
                userPromptService.assignPrompt(item.userPromptID, item.assigned, item.evalSessionID).then(function (data) {
                    vm.selectedPromptAssigned = {};
                    activate();
                });
                //vm.selectedPromptAssigned = {};
            }
        }

        function selectPromptRow(userPrompt) {
            vm.selectedPrompt = userPrompt;
        }

        function selectPromptAssignedRow(assignedPrompt) {
            vm.selectedPromptAssigned = assignedPrompt;
        }

        function done() {

            vm.editView = false;
        }

        function edit() {
            vm.editView = true;
        }

        vm.saveNewPreConferencePrompt = function saveNewPreConferencePrompt() {
            if (!vm.newPrompt.prompt) {
                return;
            }

            userPromptService.insertNewConfPrompt(false, vm.evalSessionId, enums.PromptType.PreConf, vm.newPrompt.prompt).then(function () {
                vm.showNewPromptArea = false;
                activate();                
            });
        }

        vm.cancelAddPrompt = function () {
            if (vm.newPrompt) {
                vm.newPrompt.prompt = "";
            }
            vm.showNewPromptArea = false;
        }

        function send() {
            observationService.updatePreConfPromptState(vm.evalSessionId, enums.PreConfPromptStateEnum.WaitingForEvaluateeResponse).then(function(data) {
                logger.info("Successfully Sent");
            });                        
        }

        function addNewPrompt() {
            if (vm.newPrompt) {
                vm.newPrompt.prompt = "";
            }
            
            vm.showNewPromptArea = true;
        }


     /*   vm.window = {};
        vm.openWindow = openWindow;

        function openWindow() {
            var dlgOptions = {
                width: 620,
                height: 350,
                visible: false,
                actions: [

                    "Maximize",
                    "Close"
                ]
            };

            vm.window.setOptions(dlgOptions);
            vm.window.saveNewPreConferencePrompt = function saveNewPreConferencePrompt() {
                userPromptService.insertNewConfPrompt(false, vm.evalSessionId, enums.PromptType.PreConf, vm.newPrompt.prompt).then(function () {
                    activate();
                    vm.window.close();
                });
            }

            vm.window.center();
            vm.window.open();
        };
        */
    }
})();


