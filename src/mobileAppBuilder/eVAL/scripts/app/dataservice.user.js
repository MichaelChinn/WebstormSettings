define(['amplify', 'app/utils'],
    function (amplify, utils) {
        var 
            init = function () {

                 amplify.request.define('test', 'ajax', {
                    url: '{baseUrl}/api/Values',
                    dataType: 'json',
                    type: 'GET',
                    crossDomain: true,
                    beforeSend: function (xhr) {
                        console.log("xhr at dataservice.user.js "+xhr);
                        xhr.setRequestHeader("Authorization", "Basic " + App.basicAuthEncoding);
                     },
                    cache: false
                });

                amplify.request.define('user', 'ajax', {
                    url: '{baseUrl}/api/user/{userId}',
                    dataType: 'json',
                    type: 'GET',
                    crossDomain: true,
                    beforeSend: function (xhr) {
                        xhr.setRequestHeader("Authorization", "Basic " + App.basicAuthEncoding);
                     },
                    cache: false
                });

                amplify.request.define('evaluatees', 'ajax', {
                    url: '{baseUrl}/api/evaluatees/{schoolyear}/{evaluatorId}/{evaluatorRole}/{assignedOnly}',
                    dataType: 'json',
                    type: 'GET',
                    crossDomain: true,
                    beforeSend: function (xhr) {
                        xhr.setRequestHeader("Authorization", "Basic " + App.basicAuthEncoding);
                    },
                    cache: false
                });


                //for barcode implementation 
                amplify.request.define('barcodetouserId', 'ajax', {
                    url: '{baseUrl}/api/user/barcode/{barcode}',
                    dataType: 'json',
                    type: 'GET',
                    crossDomain: true,
                    beforeSend: function (xhr) {
                          xhr.setRequestHeader("Authorization", "Basic " + App.basicAuthEncoding);
                     },
                     cache: false
                });
     
            },
             

            loginDS = function (callbacks, username, password) {
          //      alert('in login');
                amplify.request.define('login', 'ajax', {
                    url: '{baseUrl}/api/login',
                    dataType: 'json',
                    type: 'GET',
                    crossDomain: true,
                    beforeSend: function (xhr) {
                        console.log("XHR : "+xhr);
                        xhr.setRequestHeader("Authorization", "Basic " + App.basicAuthEncoding);
                        xhr.setRequestHeader("UserName", username);
                        xhr.setRequestHeader("Password", password);
                    },
                    cache: false
                });

                return amplify.request({
                    resourceId: 'login',
                    data: { baseUrl: App.config.baseUrl, username: username, password: password },
                    success: function (data) {
                        //  alert(data);
                       // $.each(data, function (k, v) {
                       //  alert(k + ": " + v);
                       //});
                        console.log("url : " + App.config.baseUrl)
                        App.setCurrentUserFromData(data);
                        App.initSchoolYear();
                        localStorage.setItem('SEUserID', App.currentUser.id);
                    },
                    error: function (xhr, status, error) {
                         
                        alert('error: ' + xhr.responseText);
                    }
                });
            };

        testDS = function (
            ) {
            return amplify.request({
                resourceId: 'test',
                data: { baseUrl: App.config.baseUrl },
                success: callbacks.success,
                error: callbacks.error
            });
        };

        getUserDS = function (callbacks, userId) {
            console.log('in get UserDS at dataservice.user.js' + userId);
            return amplify.request({
                resourceId: 'user',
                data: { userId: userId, baseUrl: App.config.baseUrl },
                success: callbacks.success,
                error:   callbacks.error
            });
        };


        getBarcode = function (callbacks, barcode) {
            
             return amplify.request({
                resourceId: 'barcodetouserId',
                data: { barcode: barcode, baseUrl: App.config.baseUrl },
                success: callbacks.success,
                error: callbacks.error
            });

        };

 
        getEvaluateesDS = function (callbacks, evaluatorId, schoolyear, evaluatorRole, assignedOnly) {
            return amplify.request({
                resourceId: 'evaluatees',
                data: { evaluatorId: evaluatorId, schoolyear: schoolyear, evaluatorRole: evaluatorRole, assignedOnly: assignedOnly, baseUrl: App.config.baseUrl },
                success: callbacks.success,
                error: callbacks.error
            });
        };

        testService = function () {
             return utils.getWithNoParam(testDS);
        };

        getUser = function (userId) {
            console.log('in getUser at dataservice.user.js' + userId);
            return utils.getWithOneParam(getUserDS, userId);
        };


        barcodeToUserId = function (barcode) {
             return utils.getWithOneParam(getBarcode,barcode);
        };
 
        getEvaluateesForEvaluator = function (evaluatorId, schoolYear, evaluatorRole, assignedOnly) {
            return utils.getWithFourParams(getEvaluateesDS, evaluatorId, schoolYear, evaluatorRole, assignedOnly);
        };

        loginUser = function (username, password) {
            return utils.getWithTwoParams(loginDS, username, password);
        };

        init();

        return {
            getUser: getUser,
            getEvaluateesForEvaluator: getEvaluateesForEvaluator,
            loginUser: loginUser,
            testService: testService,
            barcodeToUserId:barcodeToUserId
        };
    });


