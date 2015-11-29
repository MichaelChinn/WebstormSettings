define(['amplify', 'app/utils'],
    function (amplify, utils) {
        var 
            init = function () {

                amplify.request.define('evalsessions', 'ajax', {
                    url: '{baseUrl}/api/evalsessions/{schoolyear}/{evaluatorId}/{evaluateeId}/{districtCode}/{schoolCode}/{evalType}',
                    dataType: 'json',
                    type: 'GET',
                    crossDomain: true,
                    beforeSend: function (xhr) {
                        xhr.setRequestHeader("Authorization", "Basic " + App.basicAuthEncoding);
                    },
                    cache: false
                });

                amplify.request.define('evalsession', 'ajax', {
                    url: '{baseUrl}/api/evalsession/{sessionId}',
                    dataType: 'json',
                    type: 'GET',
                    crossDomain: true,
                    beforeSend: function (xhr) {
                        xhr.setRequestHeader("Authorization", "Basic " + App.basicAuthEncoding);
                    },
                    cache: false
                });

                amplify.request.define('insertevalsession', 'ajax', {
                    url: '{baseUrl}/api/evalsession',
                    dataType: 'json',
                    contentType: 'application/json; charset=utf-8',
                    type: 'POST',
                    dataMap: function (data) {
                        return JSON.stringify(data);
                    },
                    beforeSend: function (xhr) {
                        xhr.setRequestHeader("Authorization", "Basic " + App.basicAuthEncoding);
                    },
                    crossDomain: true,     
                    cache: false
                });

            },

            getEvalSessionsForEvaluateeDS = function (callbacks, schoolyear, evaluatorId, evaluateeId, districtCode, schoolCode, evalType) {
                console.log("getEvalSessionsForEvaluateeDS");
                return amplify.request({
                    resourceId: 'evalsessions',
                    data: {
                        schoolyear: schoolyear,
                        evaluatorId: evaluatorId,
                        evaluateeId: evaluateeId,
                        districtCode: districtCode,
                        schoolCode: schoolCode,
                        evalType: evalType,
                        baseUrl: App.config.baseUrl
                    },
                    success: callbacks.success,
                    error: callbacks.error
                });
            },

            getEvalSessionsForEvaluatee = function (schoolYear, evaluatorId, evaluateeId, districtCode, schoolCode, evalType) {
                return utils.getWithSixParams(getEvalSessionsForEvaluateeDS, schoolYear, evaluatorId, evaluateeId, districtCode, schoolCode, evalType);
            },


            getEvalSessionDS = function (callbacks, sessionId) {
                return amplify.request({
                    resourceId: 'evalsession',
                    data: { sessionId: sessionId, baseUrl: App.config.baseUrl },
                    success: callbacks.success,
                    error: callbacks.error
                });
            },

            getEvalSession = function (sessionId) {
                return utils.getWithOneParam(getEvalSessionDS, sessionId);
            };

            putEvalSessionDS = function (callbacks, data) {
                return amplify.request({
                    resourceId: 'insertevalsession',
                    data: data,
                    success: callbacks.success,
                    error: callbacks.error
                });
            },

            newEvalSession = function (data) {
               
                return utils.getWithOneParam(putEvalSessionDS, data );
            }

        init();

        return {
            getEvalSessionsForEvaluatee: getEvalSessionsForEvaluatee,
            getEvalSession: getEvalSession,
            newEvalSession: newEvalSession

        };
    });


 