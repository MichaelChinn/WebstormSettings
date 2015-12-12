/**
* settings data-model
*/
define([
    'kendo',
    'app/api'],
    function (kendo, api) {

        var viewModel = kendo.observable({

            schoolYearsDataSource: new kendo.data.DataSource({
                transport: {
                    read: function (options) {
                        api.getDistrictConfigsForUser(App.currentUser.districtCode)
                        .done(function (data) {
                            options.success(data);
                        });
                    }
                }
            }),

            schoolsDataSource: new kendo.data.DataSource({
                transport: {
                    read: function (options) {
                        api.getLocationRolesForUser(App.currentUser.id)
                            .done(function (data) {
                                options.success(data);
                            });
                    }
                }
            })

        });

        return viewModel;
    });