/**
* learningWalks data-model
*/
define([
    'kendo',
    'app/api',
    'app/utils'],
    function (kendo, api, utils) {

        var viewModel = kendo.observable({

            dataSource: new kendo.data.DataSource({
                transport: {
                    read: function (options) {
                        api.getLearningWalksForCurrentUser()
                        .done(function (data) {
                            options.success(data);
                        });
                    }
                }
            }),

            joinSession: function (e) {
                api.joinLearningWalk(App.currentUser.id, viewModel.get("sessionKey"))
                    .done(function (data) {
                        if (data != null) {
                            viewModel.dataSource.read();
                            App.views.learningWalks.refreshList(e);
                        }
                        else
                        {
                            alert("Key is not valid!");
                        }
                    });
            }
        });

        return viewModel;
    });