define(['amplify', 'app/utils'],
    function (amplify, utils) {
        var 
            init = function () {

                amplify.request.define('districtConfigs', 'ajax', {
                    url: '{baseUrl}/api/{districtCode}/districtConfigs',
                    dataType: 'json',
                    type: 'GET',
                    crossDomain: true,
                    beforeSend: function (xhr) {
                        xhr.setRequestHeader("Authorization", "Basic " + App.basicAuthEncoding);
                    }
                    //cache:
                });
            },

            getDistrictConfigsDS = function (callbacks, districtCode) {
                return amplify.request({
                    resourceId: 'districtConfigs',
                    data: { districtCode: districtCode, baseUrl: App.config.baseUrl },
                    success: callbacks.success,
                    error: callbacks.error
                });
            };

        getDistrictConfigsForUser = function (districtCode) {
            return utils.getWithOneParam(getDistrictConfigsDS, districtCode);
        };

        init();

        return {
            getDistrictConfigsForUser: getDistrictConfigsForUser
        };
    });


