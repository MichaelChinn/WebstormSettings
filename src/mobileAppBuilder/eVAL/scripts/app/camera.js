define(['app/api'],
    function (api) {
        var 
        successCallBack = null,
        pictureSource = navigator.camera.PictureSourceType,
        destinationType = navigator.camera.DestinationType,
        mediaType = navigator.camera.MediaType,



        onCaptureAudioSuccess = function (fileURI) {
            var mediaFilePath = fileURI[0].fullPath;
            var mediaFileName = fileURI[0].name;
  
            transferFile(mediaFilePath, mediaFileName);
           
         },




        onCaptureVideoSuccess = function (fileURI) {
            var mediaFilePath = fileURI[0].fullPath;
            var mediaFileName = fileURI[0].name;
            transferFile(mediaFilePath, mediaFileName);
        },




        onCapturePhotoSuccess = function (fileURI) {
            console.log("File URI : " + fileURI[0].fullPath);
            var mediaFilePath = fileURI[0].fullPath;
            var mediaFileName = fileURI[0].name;
            transferFile(mediaFilePath, mediaFileName);
        },




        getFileNameFromPath = function (path) {
            return path.substring(path.lastIndexOf('/') + 1);
        },


 

   
        onGetPhotoSuccess = function (fileURI) {
            var fileName = getFileNameFromPath(fileURI);
            if (fileName.indexOf('.') == -1) {
                if (kendo.support.mobileOS.android) {
                    fileName = "image.jpg";
                }
                else {
                    fileName = "unknown";
                }
            }

            transferFile(fileURI, fileName);
        },
 
   
        onGetVideoSuccess = function (fileURI) {
            var fileName = getFileNameFromPath(fileURI);
            if (fileName.indexOf('.') == -1) {
                if (kendo.support.mobileOS.android) {
                    fileName = "video/mp4";
                }
                else {
                    fileName = "unknown";
                }
            }

            transferFile(fileURI, fileName);
        },


        onCaptureFail = function (e) {
            if (e.code != 3) { //     FileTransferError.ABORT_ERR
                alert('Capture Error: ' + e.code);
            }
            App.kendo.pane.loader.hide();
        },



        onGetFail = function (e) {
            if (e.toString().toUpperCase() != "SELECTION CANCELLED.") {
                alert('Get Error: ' + e);
            }
            App.kendo.pane.loader.hide();
        },



        onTransferSuccess = function () {
            successCallBack();
            console.log("Success!!");
            var msg = 'File Uploaded!';
            navigator.notification.alert(msg, null, 'Notification');
            App.kendo.pane.loader.hide();
        },



        onTransferError = function (e) {
            console.log("Error!!" + e.code);
            App.kendo.pane.loader.hide();
            alert('File Transfer Error: ' + e.code);
        },


        transferFile = function (mediaFilePath, mediaFileName) {

            try {
                var options = new FileUploadOptions();
                options.fileKey = "file";
                options.fileName = mediaFileName;
                //options.mimeType = mimeType;

                var params = new Object();
                params.fullpath = mediaFilePath;
                params.name = mediaFileName;

                options.params = params;
                options.chunkedMode = false;
                options.httpMethod = "POST";
                options.headers = {
                    Connection: "close"
                };

                var ft = new FileTransfer();

                var url = App.config.baseUrl + "/api/" + App.activeSchoolYear + "/" + App.currentUser.districtCode + "/user/" + App.currentUser.id + "/" + App.evaluationType + "/uploadMedia/" + App.currentSessionId;
                console.log("URL : " + url);
                ft.upload(mediaFilePath, url, onTransferSuccess, onTransferError, options);
                console.log("process completed");
            }
            catch (ex) {
                alert('exception: ' + ex);
            }
        },

         

        captureAudio = function (cb) {
            successCallBack = cb;
            App.kendo.pane.loader.show();
            navigator.device.capture.captureAudio(onCaptureAudioSuccess, onCaptureFail, { limit: 1 });
        },



        captureVideo = function (cb) {
            successCallBack = cb;
            App.kendo.pane.loader.show();
            navigator.device.capture.captureVideo(onCaptureVideoSuccess, onCaptureFail, { limit: 1 });
        },



        capturePhoto = function (cb) {
            successCallBack = cb;
            App.kendo.pane.loader.show();
            navigator.device.capture.captureImage(onCapturePhotoSuccess, onCaptureFail, { limit: 1 });
        },



        getPhoto = function (cb) {
            successCallBack = cb;
            App.kendo.pane.loader.show();
            navigator.camera.getPicture(onGetPhotoSuccess, onGetFail, { quality: 10,
                destinationType: destinationType.FILE_URI,
                mediaType: mediaType.PICTURE,
                sourceType: pictureSource.SAVEDPHOTOALBUM
            });
        },

         
   
         getVideo = function (cb) {
            successCallBack = cb;
            App.kendo.pane.loader.show();
            navigator.camera.getPicture(onGetVideoSuccess, onGetFail, { quality: 10,
                destinationType: destinationType.FILE_URI,
                mediaType: mediaType.VIDEO,
                sourceType: pictureSource.SAVEDPHOTOALBUM
            });
        };


         
        return {
            captureAudio: captureAudio,
            captureVideo: captureVideo,
            capturePhoto: capturePhoto,
            getPhoto: getPhoto,
            getVideo: getVideo,
            successCallBack: successCallBack
        };

         
     });
