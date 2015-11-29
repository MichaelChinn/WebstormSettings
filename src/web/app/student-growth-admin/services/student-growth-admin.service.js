(function () {
    'use strict';

    angular
        .module('stateeval.student-growth-admin')
        .factory('studentGrowthAdminService', studentGrowthAdminService);

    studentGrowthAdminService.$inject = ['$http', 'config', 'activeUserContextService'];
    function studentGrowthAdminService($http, config, activeUserContextService) {

        var currentDistrictCode = '';

        var service = {
            getAvailablePrompts: getAvailablePrompts,
            getDistrictPrompts: getDistrictPrompts,
            getActivePrompts: getActivePrompts,
            togglePromptUse: togglePromptUse,
            newPrompt: newPrompt,
            createPrompt: createPrompt,
            deletePrompt: deletePrompt,
            updatePrompt: updatePrompt,
            submitSettings: submitSettings,
            getSettingsHaveBeenSubmitted: getSettingsHaveBeenSubmitted
        };

        return service;

        function newPrompt(prompt, promptType, evalType) {
            return {
                schoolYear: activeUserContextService.context.orientation.schoolYear,
                districtCode: activeUserContextService.getActiveDistrictCode(),
                evaluationType: evalType,
                promptType: promptType,
                prompt: prompt
            }
        }
        function requestParams(evalType, promptType) {
            return {
                schoolYear: activeUserContextService.context.orientation.schoolYear,
                districtCode: activeUserContextService.getActiveDistrictCode(),
                evaluationType: evalType,
                promptType: promptType,
                frameworkNodeId: 0,
                promptId: 0
            }
        }

        function requestToggleParams(evalType, promptType, frameworkNodeId, promptId) {
            return {
                schoolYear: activeUserContextService.context.orientation.schoolYear,
                districtCode: activeUserContextService.getActiveDistrictCode(),
                evaluationType: evalType,
                frameworkNodeId: frameworkNodeId,
                promptType: promptType,
                promptId: promptId
            }
        }

        function createPrompt(prompt) {
            var url = config.apiUrl + 'sgformprompts/';

            return $http.post(url, prompt).then(function(response) {
                prompt.id = response.data.id;
            })
        }


        function updatePrompt(prompt) {
            var url = config.apiUrl + 'sgformprompts/';

            return $http.put(url, prompt).then(function(response) {
                prompt.id = response.data.id;
            })
        }

        function deletePrompt(prompt) {
            return $http.delete(config.apiUrl + 'sgformprompts/' + prompt.id);
        }

        function togglePromptUse(evalType, promptType, frameworkNodeId, promptId) {
            var params = requestToggleParams(evalType, promptType, frameworkNodeId, promptId);
            var url = config.apiUrl + 'sgtogglepromptuse/';

            return  $http.put(url, params).then(function(response) {
                return response.data;
            });
        }

        function getAvailablePrompts(evalType, promptType) {
            var params = requestParams(evalType, promptType);
            var url = config.apiUrl + 'sgavailableprompts/';

            return  $http.get(url, {params: params}).then(function(response) {
                return response.data;
            });
        }

        function getDistrictPrompts(evalType, promptType) {
            var params = requestParams(evalType, promptType);
            var url = config.apiUrl + 'sgdistrictprompts/';

            return  $http.get(url, {params: params}).then(function(response) {
                return response.data;
            });
        }

        function getActivePrompts(evalType) {
            var params = requestParams(evalType, promptType);
            var url = config.apiUrl + 'sgactiveprompts/';

            return  $http.get(url, {params: params}).then(function(response) {
                return response.data;
            });
        }

        function getSettingsHaveBeenSubmitted() {
            var contextId = activeUserContextService.context.frameworkContext.id;
            var url = config.apiUrl + 'settingshavebeensubmitted/' + contextId;

            return  $http.get(url).then(function(response) {
                return response.data;
            });
        }

        function submitSettings() {
            var contextId = activeUserContextService.context.frameworkContext.id;
            var url = config.apiUrl + 'sgprocesssettings/submit/' + contextId;
            return $http.put(url, contextId);
        }
    }
})();