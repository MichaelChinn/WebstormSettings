(function() {
    'use strict';

    angular
        .module('stateeval.observation')
        .controller('postConferenceController', postConferenceController);

    postConferenceController.$inject = ['$q', 'logger', '$stateParams', '$state', 'config', 'enums', 'evalSessionService', 'userPromptService', '$filter'];

    /* @ngInject */
    function postConferenceController($q, logger, $stateParams, $state, config, enums, evalSessionService, userPromptService, $filter) {
        var vm = this;
        ////////////////////////////
        activate();
        vm.postConfGridOptions = {};
        vm.openWindow = openWindow;
        vm.assignChanged = assignChanged;

        function activate() {
        }

        function assignChanged(item) {
            var url = config.apiUrl + 'userprompt/assign';

            $http.post(url, { userPromptId: item.userPromptID, assigned: item.assigned }).then(function(data) {
                var k = 1;
            });
        }

        vm.postConfGridOptions =
        {
            dataSource: {
                type: "json",
                transport: {
                    read: "/StateEvalWebAPI/api/userprompts/postconference"
                },
                serverPaging: false,
                serverSorting: false
            },
            sortable: true,
            pageable: false,
            columns: [
                {
                    field: "evaluationType",
                    title: "Evaluation Type",
                    width: "80px",
                    hidden: true
                },
                {
                    field: "definedBy",
                    title: "Defined By",
                    width: "100px"
                },
                {
                    field: "title",
                    title: "Title",
                    width: "120px"
                },
                {
                    field: "prompt",
                    width: "450px"
                },
                {
                    field: "publishedDate",
                    title: "Finalized",
                    width: "80px",
                    template: "#= kendo.toString(kendo.parseDate(publishedDate, 'yyyy-MM-dd'), 'dd/MM/yyyy') #"
                },
                {
                    field: "inUse",
                    title: "In Use",
                    width: "60px"
                },
                {
                    field: "retired",
                    title: "Retired",
                    width: "60px"
                },
                {
                    title: "Action",
                    "template": "<a href=\"\\#/prompt-home/edit-prompt/#=userPromptID#\">Edit</a>&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' ng-click='deleteuserPrompt(#=userPromptID#)'>Delete</a>",
                }
            ]
        };

        vm.window = {};


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
            vm.window.saveNewPostConferencePrompt = function saveNewPostConferencePrompt() {
                userPromptService.insertNewConfPrompt(false, 1, enums.PromptType.PostConf, vm.newPrompt.prompt).then(function (data) {
                    vm.window.close();
                });                
            }

            vm.window.center();
            vm.window.open();
        };
    }

})();