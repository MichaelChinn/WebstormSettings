define([
    'jquery',
    'app/api',
    'kendo'
], function ($, api, kendo) {
    var context = null;

    var BaseView = kendo.Class.extend({

        init: function (scope, title, showBackBtn) {
        },

        onInit: function (e) {
        },

        onBeforeShow: function (e) {
        },

        onAfterShow: function (e) {
        },

        onShow: function (e) {
        },

        onHide: function (e) {
        },

        setNavBarTitle: function (view, title) {
            view.header.find('[data-role="navbar"]').data('kendoMobileNavBar').title(title);
        }
    });

    //STORE ORIGINAL SCOPE FOR LATER USE
    context = BaseView.fn;

    return BaseView;
});