(function () {
    'use strict';
    angular.module('stateeval.prompt')
        .directive('promptGrid', promptGridDirective)
        .controller('promptGridController', promptGridController);

    promptGridDirective.$inject = ['$rootScope', '$q', '$http', '$timeout'];
    promptGridController.$inject = ['$scope', '$state', 'enums', 'userPromptService',
        'activeUserContextService', 'userService'];

    function promptGridDirective($rootScope, $q, $http, $timeout) {
        return {
            restrict: 'E',
            scope: {
                gridOption: '='
            },
            templateUrl: 'app/prompt/views/prompt-grid.html',
            controller: 'promptGridController as vm',
            link: function (scope, elm, attrs) {
            }
        }
    }

    function promptGridController($scope, $state, enums, userPromptService,
          activeUserContextService, userService) {
        var vm = this;

        vm.gridData = [];
        vm.dataSource = null;
        vm.promptBankGridOptions = null;
        vm.showAddNewBtn = false;

        vm.editPrompt = editPrompt;
        vm.deletePrompt = deletePrompt;
        vm.addNewPrompt = addNewPrompt;

        activate();

        function activate() {

            vm.showAddNewBtn = $scope.gridOption.editable;

            vm.dataSource = new kendo.data.DataSource({
                transport: {
                    read: function (e) {
                        e.success(vm.gridData);
                    }
                }
            });

            var columns = [];

            columns.push({
                field: "prompt",
                title: "Prompt",
                    width: "350px"
            });

            columns.push({
                field: "inUse",
                title: "In Use",
                width: "60px"
            });

            if ($scope.gridOption.editable) {
                columns.push({
                    title: "Action",
                    "template": "<button class='btn btn-default btn-outline btn-xs' confirm='Are you sure you want to delete this prompt? If the prompt is in use within observations, then it will not be deleted, but just retired so that it is not an option for future observations.' ng-click='vm.deletePrompt(#=userPromptID#)'>Delete</button>&nbsp;&nbsp;&nbsp;<button class='btn btn-primary btn-xs' ng-click='vm.editPrompt(#=userPromptID#)'>Edit</button>"
                });
            }

            vm.promptBankGridOptions =
            {
                dataSource: vm.dataSource,
                    dataBound: function () {
                this.expandRow(this.tbody.find("tr.k-master-row").first());
            },
                sortable: true,
                pageable: false,
                columns: columns
            };

            loadData().then(function() {
                
            })
        }

        function loadData() {
            return $scope.gridOption.gridDataFcn().then(function (userPrompts) {
                vm.gridData = userPrompts;
                vm.dataSource.read();
            });
        }

        function deletePrompt(userPromptId) {
            userPromptService.deleteUserPrompt(userPromptId).then(function() {
                loadData();
            });
        }

        function editPrompt(userPromptId) {
            $state.go("editprompt", { userpromptid: userPromptId, evaluationtype: $scope.gridOption.evaluationType });
        }

        function addNewPrompt() {
            $state.go("editprompt", { userpromptid: 0, evaluationtype: $scope.gridOption.evaluationType, prompttype: $scope.gridOption.promptType });
        }
    }
})();


