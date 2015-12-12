/**
 * learningWalks view
 */
define([
    'views/baseview',
    'app/api',
    'text!../../../views/practice/learningWalks_list.html'
], function (BaseView, api, listTemplate) {
    var context = null;

    var View = BaseView.extend({
        view: null,

        init: function () {
            BaseView.fn.init.call(this);
            context = this;
        },

        onInit: function (e) {
        },

        refreshList: function (e) {
            e.sender.element.closest("[data-role=modalview]").data("kendoMobileModalView").close();
            context.view.element.find('.listview').data('kendoMobileListView').refresh();
        },

        onShow: function (e) {
           
            //cache for later use
            context.view = e.view;

            e.view.element.find('.backbtn').css('display', 'inline-block');

            App.models.learningWalks.dataSource.read();

            e.view.element.find('.listview').kendoMobileListView({
                dataSource: App.models.learningWalks.dataSource,
                template: listTemplate,
                style: 'inset'
            });
        }

    });

    return new View();
});