define(['amplify', 'app/utils'],
    function (amplify, utils) {
        var 
            init = function () {

                amplify.request.define('practiceSessions', 'ajax', {
                    url: '{baseUrl}/api/{schoolYear}/{userId}/practiceSessions/{type}',
                    dataType: 'json',
                    type: 'GET',
                    crossDomain: true,
                    beforeSend: function (xhr) {
                        xhr.setRequestHeader("Authorization", "Basic " + App.basicAuthEncoding);
                    },
                    cache: false
                });

                amplify.request.define('practiceSession', 'ajax', {
                    url: '{baseUrl}/api/practiceSession/{practiceSessionId}',
                    dataType: 'json',
                    type: 'GET',
                    crossDomain: true,
                    beforeSend: function (xhr) {
                     //   alert(xhr.id);
                        xhr.setRequestHeader("Authorization", "Basic " + App.basicAuthEncoding);
                    },
                    cache: false
                });

                amplify.request.define("joinPracticeSession", "ajax", {
                    url: "{baseUrl}/api/practiceSession/join/{userId}/{sessionKey}",
                    datatype: "json",
                    type: "GET",
                     beforeSend: function (xhr) {
                         xhr.setRequestHeader("Authorization", "Basic " + App.basicAuthEncoding);
                         return true;
                     },
                     decoder: function (data, status, xhr, success, error) {
                          success(data);
                         
                       
                          var as = App.getLocalStorageValue("sessionKEY");
                         if (status === "success") {
                              if (data === as) {
                                var msg =  "session joined successfully ";
                                navigator.notification.alert(msg, null, 'Notification');
                                  
                               }
                         } else if (status === "fail" || status === "error") {
                           
                           // error(status, xhr);
                            var jsonResponse = JSON.parse(xhr.responseText);
                            var msg1 = jsonResponse.message; 
                            navigator.notification.alert(msg1, null, 'Notification');
  
                             
                        } else {
                             error(status, xhr);
                             
                          //  alert(status +"<-----s x-------->"+xhr.responseText);
                        }
                    },
                   
                    cache: false
                    
                });
                  
 

                amplify.request.define('learningWalkClassrooms', 'ajax', {
                    url: '{baseUrl}/api/practiceSession/{practiceSessionId}/classrooms',
                    dataType: 'json',
                    type: 'GET',
                    crossDomain: true,
                    beforeSend: function (xhr) {
                        xhr.setRequestHeader("Authorization", "Basic " + App.basicAuthEncoding);
                    },
                    cache: false
                });

                amplify.request.define('learningWalkClassroom', 'ajax', {
                    url: '{baseUrl}/api/learningWalkClassroom/{roomId}',
                    dataType: 'json',
                    type: 'GET',
                    crossDomain: true,
                    beforeSend: function (xhr) {
                        xhr.setRequestHeader("Authorization", "Basic " + App.basicAuthEncoding);
                    },
                    cache: false
                });

                amplify.request.define('learningWalkClassroomScoringElements', 'ajax', {
                    url: '{baseUrl}/api/learningWalkClassroom/{roomId}/scoringElements/{userId}/{focusOnly}',
                    dataType: 'json',
                    type: 'GET',
                    crossDomain: true,
                    beforeSend: function (xhr) {
                        xhr.setRequestHeader("Authorization", "Basic " + App.basicAuthEncoding);
                    },
                    cache: false
                });

                amplify.request.define('learningWalkClassroomScoringElementRubricRowData', 'ajax', {
                    url: '{baseUrl}/api/learningWalkClassroom/{roomId}/scoringElementData/{rubricRowId}/{userId}',
                    dataType: 'json',
                    type: 'GET',
                    crossDomain: true,
                    beforeSend: function (xhr) {
                        xhr.setRequestHeader("Authorization", "Basic " + App.basicAuthEncoding);
                    },
                    cache: false
                });

                amplify.request.define('scoreRubricRow', 'ajax', {
                    url: '{baseUrl}/api/learningWalkClassroom/{roomId}/scoringElementDataRR/{rubricRowId}/{userId}/{performanceLevel}',
                    dataType: 'json',
                    type: 'GET',
                    crossDomain: true,
                    beforeSend: function (xhr) {
                      
                        xhr.setRequestHeader("Authorization", "Basic " + App.basicAuthEncoding);
                    },
                    cache: false
                });

                amplify.request.define('scoreFrameworkNode', 'ajax', {
                    url: '{baseUrl}/api/learningWalkClassroom/{roomId}/scoringElementDataFN/{frameworkNodeId}/{userId}/{performanceLevel}',
                    dataType: 'json',
                    type: 'GET',
                    crossDomain: true,
                    beforeSend: function (xhr) {
                        xhr.setRequestHeader("Authorization", "Basic " + App.basicAuthEncoding);
                    },
                    cache: false
                });

            },

            scoreFrameworkNodeDS = function (callbacks, roomId, userId, frameworkNodeId, performanceLevel) {
                return amplify.request({
                    resourceId: 'scoreFrameworkNode',
                    data: { roomId: roomId, userId: userId, frameworkNodeId: frameworkNodeId, performanceLevel: performanceLevel, baseUrl: App.config.baseUrl },
                    success: callbacks.success,
                    error: callbacks.error
                });
            },

            scoreFrameworkNode = function (roomId, userId, frameworkNodeId, performanceLevel) {
                return utils.getWithFourParams(scoreFrameworkNodeDS, roomId, userId, frameworkNodeId, performanceLevel);
            },

            scoreRubricRowDS = function (callbacks, roomId, userId, rubricRowId, performanceLevel) {
               
                return amplify.request({
                    resourceId: 'scoreRubricRow',
                    data: { roomId: roomId, userId: userId, rubricRowId: rubricRowId, performanceLevel: performanceLevel, baseUrl: App.config.baseUrl },
                    success: callbacks.success,
                    error: callbacks.error
                });
            },

            scoreRubricRow = function (roomId, userId, rubricRowId, performanceLevel) {
                return utils.getWithFourParams(scoreRubricRowDS, roomId, userId, rubricRowId, performanceLevel);
            },


            getLearningWalkClassroomScoringElementRubricRowDataDS = function (callbacks, roomId, userId, rubricRowId) {
                return amplify.request({
                    resourceId: 'learningWalkClassroomScoringElementRubricRowData',
                    data: { roomId: roomId, userId: userId, rubricRowId: rubricRowId, baseUrl: App.config.baseUrl },
                    success: callbacks.success,
                    error: callbacks.error
                });
            },

            getLearningWalkClassroomScoringElementRubricRowData = function (roomId, userId, rubricRowId) {
                return utils.getWithThreeParams(getLearningWalkClassroomScoringElementRubricRowDataDS, roomId, userId, rubricRowId);
            },

            getLearningWalkClassroomScoringElementsDS = function (callbacks, roomId, userId, focusOnly) {
                return amplify.request({
                    resourceId: 'learningWalkClassroomScoringElements',
                    data: { roomId: roomId, userId: userId, focusOnly: focusOnly, baseUrl: App.config.baseUrl },
                    success: callbacks.success,
                    error: callbacks.error
                });
            },

            getLearningWalkClassroomScoringElements = function (roomId, userId, focusOnly) {
                return utils.getWithThreeParams(getLearningWalkClassroomScoringElementsDS, roomId, userId, focusOnly);
            },

            getLearningWalkClassroomDS = function (callbacks, roomId) {
                return amplify.request({
                    resourceId: 'learningWalkClassroom',
                    data: { roomId: roomId, baseUrl: App.config.baseUrl },
                    success: callbacks.success,
                    error: callbacks.error
                });
            },

            getLearningWalkClassroom = function (roomId) {
                return utils.getWithOneParam(getLearningWalkClassroomDS, roomId);
            },

            getLearningWalkClassroomsDS = function (callbacks, practiceSessionId) {
                return amplify.request({
                    resourceId: 'learningWalkClassrooms',
                    data: { practiceSessionId: practiceSessionId, baseUrl: App.config.baseUrl },
                    success: callbacks.success,
                    error: callbacks.error
                });
            },

            getLearningWalkClassrooms = function (practiceSessionId) {
                return utils.getWithOneParam(getLearningWalkClassroomsDS, practiceSessionId);
            },

            getLearningWalksForUserDS = function (callbacks, schoolYear, userId) {
                return amplify.request({
                    resourceId: 'practiceSessions',
                    data: {
                        schoolYear: schoolYear,
                        userId: userId,
                        type: 3,
                        baseUrl: App.config.baseUrl
                    },
                    success: callbacks.success,
                    error: callbacks.error
                });
            },

            getLearningWalksForUser = function (schoolYear, userId) {
                return utils.getWithTwoParams(getLearningWalksForUserDS, schoolYear, userId);
            },

            getLearningWalkDS = function (callbacks, learningWalkId) {
                return amplify.request({
                    resourceId: 'practiceSession',
                    data: { practiceSessionId: learningWalkId, baseUrl: App.config.baseUrl },
                    success: callbacks.success,
                    error: callbacks.error
                });
            },

            getLearningWalk = function (learningWalkId) {
                return utils.getWithOneParam(getLearningWalkDS, learningWalkId);
            },

            joinLearningWalkDS = function (callbacks, userId, sessionKey) {
                return amplify.request({
                    resourceId: 'joinPracticeSession',
                    data: { userId: userId, sessionKey: sessionKey, baseUrl: App.config.baseUrl },
                    success: callbacks.success,
                    error: callbacks.error
                });
            },
            
            joinLearningWalk = function (userId, sessionKey) {
                localStorage.setItem("sessionKEY", sessionKey);
               return utils.getWithTwoParams(joinLearningWalkDS, userId, sessionKey);
            };

        init();

        return {
            getLearningWalksForUser: getLearningWalksForUser,
            getLearningWalk: getLearningWalk,
            joinLearningWalk: joinLearningWalk,
            getLearningWalkClassrooms: getLearningWalkClassrooms,
            getLearningWalkClassroom: getLearningWalkClassroom,
            getLearningWalkClassroomScoringElements: getLearningWalkClassroomScoringElements,
            getLearningWalkClassroomScoringElementRubricRowData: getLearningWalkClassroomScoringElementRubricRowData,
            scoreRubricRow: scoreRubricRow,
            scoreFrameworkNode: scoreFrameworkNode
        };
    });


