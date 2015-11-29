/**
* artifacts data-model
*/
var myArtifact;
define([
    'kendo',
    'app/api',
    'app/camera'],
    function (kendo, api, camera) {

        var viewModel = kendo.observable({

            dataSource: new kendo.data.DataSource({
                transport: {
                    read: function (options) {
                        api.getArtifactsForCurrentUser()
                        .done(function (data) {
                            //App.views.evidenceArtifacts.refreshList();
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
                App.views.evidenceArtifacts.refreshList();
            }
        });
        myArtifact = viewModel;
        return viewModel;
    });