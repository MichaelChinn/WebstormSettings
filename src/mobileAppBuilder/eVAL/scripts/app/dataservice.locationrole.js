define(['amplify', 'app/utils'],
    function (amplify, utils) {
        var 
            init = function () {

                amplify.request.define('locationRoles', 'ajax', {
                    url: '{baseUrl}/api/user/{userId}/locationRoles',
                    dataType: 'json',
                    type: 'GET',
                    crossDomain: true,
                    beforeSend: function (xhr) {
                        xhr.setRequestHeader("Authorization", "Basic " + App.basicAuthEncoding);
                    },
                    cache: false
                });
            },

            getLocationRolesDS = function (callbacks, userId) {
                return amplify.request({
                    resourceId: 'locationRoles',
                    data: {
                        userId: userId,
                        baseUrl: App.config.baseUrl
                    },
                    success: callbacks.success,
                    error: callbacks.error
                });
            },

            getLocationRolesForUser = function (userId) {
                return utils.getWithOneParam(getLocationRolesDS, userId);
            }

        init();

        return {
            getLocationRolesForUser: getLocationRolesForUser
        };
    });


