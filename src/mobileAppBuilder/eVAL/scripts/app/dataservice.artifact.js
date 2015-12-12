define(['amplify', 'app/utils'],
    function (amplify, utils) {
        var 
            init = function () {
           //     alert('in init at dataservice.artifact.js');

                amplify.request.define('artifactsForEvalSession', 'ajax', {
                    url: '{baseUrl}/api/{sessionId}/artifacts',
                    dataType: 'json',
                    type: 'GET',
                    crossDomain: true,
                    beforeSend: function (xhr) {
                         xhr.setRequestHeader("Authorization", "Basic " + App.basicAuthEncoding);
                    },
                    cache: false
                });

                amplify.request.define('artifacts', 'ajax', {
                    url: '{baseUrl}/api/{schoolYear}/{districtCode}/user/{userId}/artifacts',
                    dataType: 'json',
                    type: 'GET',
                    crossDomain: true,
                    beforeSend: function (xhr) {
                        xhr.setRequestHeader("Authorization", "Basic " + App.basicAuthEncoding);
                    },
                    cache: false
                });

                amplify.request.define('artifact', 'ajax', {
                    url: '{baseUrl}/api/artifact/{artifactId}',
                    dataType: 'json',
                    type: 'GET',
                    crossDomain: true,
                    beforeSend: function (xhr) {
                        xhr.setRequestHeader("Authorization", "Basic " + App.basicAuthEncoding);
                    },
                    cache: false
                });

                amplify.request.define('delArtifact', 'ajax', {
                    url: '{baseUrl}/api/artifact/{artifactId}',
                    dataType: 'json',
                    type: 'DELETE',
                    crossDomain: true,
                    beforeSend: function (xhr) {
                        xhr.setRequestHeader("Authorization", "Basic " + App.basicAuthEncoding);
                    },
                    cache: false
                });

                amplify.request.define('bitstream', 'ajax', {
                    url: '{baseUrl}/api/bitstream/{bitstreamId}',
                    dataType: 'json',
                    type: 'GET',
                    crossDomain: true,
                    beforeSend: function (xhr) {
                        xhr.setRequestHeader("Authorization", "Basic " + App.basicAuthEncoding);
                    },
                    cache: false
                });
            },

            getBitstreamForRepositoryItemDS = function (callbacks, bitstreamId) {
                return amplify.request({
                    resourceId: 'bitstream',
                    data: {
                        sessionId: bitstreamId,
                        baseUrl: App.config.baseUrl
                    },
                    success: callbacks.success,
                    error: callbacks.error
                });
            },

            getBitstreamForRepositoryItem = function (bitstreamId) {
                return utils.getWithOneParam(getBitstreamForRepositoryItemDS, artifactId);
            },

            getArtifactsForEvalSessionDS = function (callbacks, sessionId) {
                return amplify.request({
                    resourceId: 'artifactsForEvalSession',
                    data: {
                        sessionId: sessionId,
                        baseUrl: App.config.baseUrl
                    },
                    success: callbacks.success,
                    error: callbacks.error
                });
            },

            getArtifactsForEvalSession = function (sessionId) {
                return utils.getWithOneParam(getArtifactsForEvalSessionDS, sessionId);
            },

            getArtifactsDS = function (callbacks, schoolYear, districtCode, userId) {
                return amplify.request({
                    resourceId: 'artifacts',
                    data: {
                        schoolYear: schoolYear,
                        districtCode: districtCode,
                        userId: userId,
                        baseUrl: App.config.baseUrl
                    },
                    success: callbacks.success,
                    error: callbacks.error
                });
            },

            getArtifactsForUser = function (schoolYear, districtCode, userId) {
                return utils.getWithThreeParams(getArtifactsDS, schoolYear, districtCode, userId);
            },

            getArtifactDS = function (callbacks, artifactId) {
                return amplify.request({
                    resourceId: 'artifact',
                    data: { artifactId: artifactId, baseUrl: App.config.baseUrl },
                    success: callbacks.success,
                    error: callbacks.error
                });
            },

            getArtifact = function (artifactId) {
                return utils.getWithOneParam(getArtifactDS, artifactId);
            };
          init();
         return {
            getArtifactsForUser: getArtifactsForUser,
            getArtifactsForEvalSession: getArtifactsForEvalSession,
            getArtifact: getArtifact,
            getBitstreamForRepositoryItem: getBitstreamForRepositoryItem
        };
    });


