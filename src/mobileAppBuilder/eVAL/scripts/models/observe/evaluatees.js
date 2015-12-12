/**
* evaluatees data-model
*/
define([
    'kendo',
    'app/api',
    'app/utils'],
    function (kendo, api, utils) {

        var viewModel = kendo.observable({

            assignedOnly: true,
            dataSource: new kendo.data.DataSource({
                assignedOnly: true,
                transport: {
                    read: function (options) {
                        api.getEvaluateesForEvaluator(viewModel.assignedOnly)
                        .done(function (data) {
                            options.success(data);
                        });
                    }
                }
            }),

            onChangeFilter: function (e) {
                var buttonGroup = e.sender;
                var index = buttonGroup.current().index();
                viewModel.assignedOnly = (index==0)?true:false;
                viewModel.dataSource.read();
                App.views.observeEvaluatees.refreshList();
            }
        });

        return viewModel;
    });