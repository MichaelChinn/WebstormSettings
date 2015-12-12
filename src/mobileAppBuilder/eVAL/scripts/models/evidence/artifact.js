/**
* artifact data-model
*/
define([
    'kendo',
    'app/api'],
    function (kendo, api) {

        var viewModel = kendo.observable({

            artifactId: -1,
        /*
            dataSource: new kendo.data.DataSource({
                transport: {
                    read: function (options) {
                        api.getArtifactsForCurrentUser()
                        .done(function (data) {
                            options.success(data);
                        });
                    }
                }
            }),
            */
        });

        return viewModel;
    });