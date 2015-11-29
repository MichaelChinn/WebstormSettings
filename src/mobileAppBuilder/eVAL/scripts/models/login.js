/**
* login data-model
*/
define([
    'kendo',
    'app/api',
    'app/utils'],
    function (kendo, api, utils) {

        var viewModel = kendo.observable({

            login: function (e) {

                var uuid = App.getLocalStorageValue("UUID");
                //uuid = 'f7548bb5-69a2-4a8c-bbc5-1d880285c4bd';
                if (uuid == "") {
                    var msg = "Please scan barcode first.";
                    navigator.notification.alert(msg, null, "Notification");

                } else {
                    api.barcodeToUserId(uuid)
                                .done(function (data) {
                                    var userId = data;
                                    console.log('user id' + userId);

                                    if (userId != null) {
                                        api.getUserById(userId)
                                       .done(function (data) {
                                           App.setCurrentUserFromData(data);
                                           App.initSchoolYear();
                                           localStorage.setItem('SEUserID', userId);
                                       });

                                    } else {
                                        var msg = "Not a Valid Barcode.";
                                        navigator.notification.alert(msg, null, "Notification");
                                    }
                                });
                }
            },

            scan: function (e) {

                if (window.navigator.simulator === true) {
                    alert("Not Supported in Simulator.");
                }
                else {
                    cordova.plugins.barcodeScanner.scan(
                    function (result) {
                        if (!result.cancelled) {
                            var msg = "Scanning Successful";
                            navigator.notification.alert(msg, null, "Notification");
                            App.saveBarcodeToLocalStorage(result.text);
                        }
                    },
                    function (error) {
                        console.log("Scanning failed: " + error);
                    });
                }
            }
        });
        return viewModel;
    });