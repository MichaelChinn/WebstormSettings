
(function () {

    angular
        .module('stateeval.prompt')
        .factory('userPromptService', userPromptService);

    userPromptService.$inject = ['_', 'enums', '$http', '$q', 'logger', 'config', 'rubricUtils', 'localStorageService', 'activeUserContextService'];

    /* @ngInject */
    function userPromptService(_, enums, $http, $q, logger, config, rubricUtils, localStorageService, activeUserContextService) {
        var service = {
            activate: activate,
            getUserPromptById: getUserPromptById,
            getNewUserPrompt: getNewUserPrompt,
            saveUserPrompt: saveUserPrompt,
            getPreConferenceUserPrompts: getPreConferenceUserPrompts,
            insertNewConfPrompt: insertNewConfPrompt,
            getQuestionBankUserPrompts: getQuestionBankUserPrompts,
            getEvaluatorDefinedQuestionBankUserPrompts: getEvaluatorDefinedQuestionBankUserPrompts,
            getSchoolAdminDefinedQuestionBankUserPrompts: getSchoolAdminDefinedQuestionBankUserPrompts,
            getDistrictAdminDefinedQuestionBankUserPrompts: getDistrictAdminDefinedQuestionBankUserPrompts,
            deleteUserPrompt: deleteUserPrompt,
            assignPrompt: assignPrompt,
            getUserPromptPreConfResponses: getUserPromptPreConfResponses,
            saveUserPromptResponses: saveUserPromptResponses            
        };

        ////////////////

        function activate() {

        }

        activate();

        return service;

        function getNewUserPrompt(evaluationType, promptType) {
            var userPromptParam = getUserPromptParam();
            var workarea = activeUserContextService.context.orientation.workAreaTag;
            var userIsASchoolAdmin = (workarea === 'SA');
            var userIsADistrictAdmin = (workarea === 'DA');

            return {
                EvaluationTypeID: evaluationType,
                PromptTypeID: promptType,
                RubricRowAlignments: [],
                schoolYear: userPromptParam.schoolYear,
                schoolCode: userPromptParam.schoolCode,
                districtCode: userPromptParam.districtCode,
                createdByUserId: userPromptParam.createdByUserId,
                wfStateID: enums.WfState.USERPROMPT_IN_PROGRESS,
                createdAsAdmin: userIsASchoolAdmin || userIsADistrictAdmin,
                title: ''
            }
        }

        function deleteUserPrompt(userPromptId) {
            return $http.delete(config.apiUrl + 'userprompt/delete/' + userPromptId).then(function () {
            });
        }

        function getUserPromptById(userPromptId) {
            var url = config.apiUrl + 'userPrompt/' + userPromptId;
            return $http.get(url).then(function (response) {
                return response.data;
            });
        }

        function getPreConferenceUserPrompts(evalSessionId) {
            var userPromptParam = getUserPromptParam();
            var url = config.apiUrl + 'userprompts/preconference';
            userPromptParam.PromptType = enums.PromptType.PreConf;
            userPromptParam.EvalSessionId = evalSessionId;

            return $http.get(url, { params: userPromptParam }).then(function (response) {
                return response.data;
            });
        }

        function getEvaluatorDefinedQuestionBankUserPrompts(promptType, evaluationType, wfState) {
            var userPromptParam = getUserPromptParam();
            userPromptParam.evaluationType = evaluationType;
            userPromptParam.PromptType = promptType;
            userPromptParam.wfState = wfState;
            var url = config.apiUrl + 'toruserprompts/questionbank';
            return $http.get(url, { params: userPromptParam }).then(function (response) {
                return response.data;
            });
        }

        function getSchoolAdminDefinedQuestionBankUserPrompts(promptType, evaluationType, wfState) {
            var userPromptParam = getUserPromptParam();
            userPromptParam.evaluationType = evaluationType;
            userPromptParam.PromptType = promptType;
            userPromptParam.wfState = wfState;
            var url = config.apiUrl + 'sauserprompts/questionbank';
            return $http.get(url, { params: userPromptParam }).then(function (response) {
                return response.data;
            });
        }

        function getDistrictAdminDefinedQuestionBankUserPrompts(promptType, evaluationType, wfState) {
            var userPromptParam = getUserPromptParam();
            userPromptParam.evaluationType = evaluationType;
            userPromptParam.PromptType = promptType;
            userPromptParam.wfState = wfState;
            var url = config.apiUrl + 'dauserprompts/questionbank';
            return $http.get(url, { params: userPromptParam }).then(function (response) {
                return response.data;
            });
        }

        function getQuestionBankUserPrompts(promptType, evaluationType) {
            var userPromptParam = getUserPromptParam();
            userPromptParam.evaluationType = evaluationType;
            var deferred = $q.defer();
            var url = config.apiUrl + 'userprompts/questionbank?t=' + new Date();
            userPromptParam.EvalSessionId = null;
            userPromptParam.PromptType = promptType;
            //$http is not working here for two consecutive call, that's why need to use $.get
            $.get(url, userPromptParam).then(function (response) {
                deferred.resolve(response);
            });

            return deferred.promise;
        }


        function getUserPromptPreConfResponses(evalSessionId) {
            var url = config.apiUrl + "preconfresponses/" + evalSessionId;
            return $http.get(url).then(function(response) {
                return response.data;
            });
        }

        function saveUserPromptResponses(userPromptResponses) {
            var url = config.apiUrl + "userpromptresponses/save";
            for (var i in userPromptResponses) {
                userPromptResponses[i].userID = activeUserContextService.user.id;
            }

            return $http.post(url, userPromptResponses).then(function(response) {
                return response.data;
            });
        }

        function saveUserPrompt(userPrompt) {
            var url = config.apiUrl + 'userprompt/save';
            return $http.post(url, userPrompt).then(function (response) {
                return response.data;
            });
        }

        function insertNewConfPrompt(addToBank, evalSessionId, promptType, prompt) {
            var userPromptParam = getUserPromptParam();
            userPromptParam.addToBank = addToBank;
            userPromptParam.evalSessionId = evalSessionId;
            userPromptParam.promptTypeID = promptType;
            userPromptParam.prompt = prompt;


            var url = config.apiUrl + 'confprompt/insert';
            return $http.post(url, userPromptParam).then(function (response) {
                return response.data;
            });
        }

        function assignPrompt(userPromptId, assigned, evalSessionId) {
            var userpromptParam = getUserPromptParam();
            var url = config.apiUrl + 'userprompt/assign';
            return $http.post(url, {
                evalSessionId: evalSessionId,
                userPromptId: userPromptId,
                assigned: assigned,
                schoolYear: userpromptParam.schoolYear,
                districtCode: userpromptParam.districtCode,
                createdByUserID: userpromptParam.createdByUserId
            });
        }

        function getUserPromptParam() {
            var userPromptParam = {};
            userPromptParam.schoolYear = activeUserContextService.context.orientation.schoolYear;
            userPromptParam.districtCode = activeUserContextService.getActiveDistrictCode();
            userPromptParam.schoolCode = activeUserContextService.getActiveSchoolCode();
            userPromptParam.createdByUserId = activeUserContextService.user.id;;
            userPromptParam.evaluationType = activeUserContextService.getActiveEvaluationType();
            userPromptParam.evaluationTypeID = activeUserContextService.getActiveEvaluationType();
            //userPromptParam.roleName = activeUserContextService.getRolesDisplayString();
            userPromptParam.roleName = enums.Roles.SESchoolPrincipal;

            return userPromptParam;
        }        
    }
})();

