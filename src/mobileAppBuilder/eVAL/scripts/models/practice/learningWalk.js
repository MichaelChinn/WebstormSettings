/**
* learningWals data-model
*/
define([
    'kendo',
    'app/api',
    'app/utils'],
    function (kendo, api, utils) {

        
        var viewModel = kendo.observable({

            sessionId: -1,

            dataSource: new kendo.data.DataSource({
                transport: {
                    read: function (options) {
                        api.getLearningWalkClassrooms(viewModel.sessionId)
                        .done(function (data) {
                            options.success(data);
                        });
                    }
                }
            })

        });

        return viewModel;
    });