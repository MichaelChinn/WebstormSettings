/**
* observation data-model
*/
define([
    'kendo',
    'app/api',
    'app/camera'],
    function (kendo, api, camera) {

        var viewModel = kendo.observable({

            sessionId: -1,

            dataSource: new kendo.data.DataSource({
                transport: {
                    read: function (options) {
                        api.getArtifactsForEvalSession(viewModel.sessionId)
                            .done(function (data) {
                                options.success(data);
                            });
                    }
                }
            }),

            onUploadVideo: function (e) {
                camera.getVideo(viewModel.uploadSuccess);
            },
            onUploadPhoto: function (e) {
                camera.getPhoto(viewModel.uploadSuccess);
            },
            onCapturePhoto: function (e) {
                camera.capturePhoto(viewModel.uploadSuccess);
            },
            onCaptureVideo: function (e) {
                camera.captureVideo(viewModel.uploadSuccess);
            },
            onCaptureAudio: function (e) {
                camera.captureAudio(viewModel.uploadSuccess);
            },

            uploadSuccess: function () {
                viewModel.dataSource.read();
                App.views.observeObservation.refreshList();
            }

        });

        return viewModel;
    });