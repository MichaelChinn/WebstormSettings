/**
* login view
*/
define([
    'app',
    'app/api',
    'views/baseview'
], function (app, api, BaseView) {
    var context = null;

    var View = BaseView.extend({
        view: null,

        init: function () {
            BaseView.fn.init.call(this);
            context = this;
        },

        onShow: function (e) {

            context.view = e.view;
            var save = App.getSaveBarcodeLS();
            if (save == "")
            {
                save = "true";
                App.setSaveBarcodeLS("true");
            }
         }
    });

    //RETURN VIEW
    return new View();
});