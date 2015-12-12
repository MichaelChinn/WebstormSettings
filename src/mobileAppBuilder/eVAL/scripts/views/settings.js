/**
 * settings view
 */
define([
    'app/api',
    'views/baseview',
    'text!../../views/settings/_schoolYearListItem.html',
    'text!../../views/settings/_schoolListItem.html',
], function (api, BaseView, schoolYearListTemplate, schoolListTemplate) {
    var context = null;

    var View = BaseView.extend({
        view: null,

        init: function () {
            BaseView.fn.init.call(this);
            context = this;
        },

        onInit: function (e) {

            context.view = e.view;
             e.view.element.find('.schoolYearListView').kendoMobileListView({
                dataSource: App.models.settings.schoolYearsDataSource,
                template: schoolYearListTemplate,
                style: 'inset'
            });

            e.view.element.find('.schoolListView').kendoMobileListView({
                dataSource: App.models.settings.schoolsDataSource,
                template: schoolListTemplate,
                style: 'inset'
            });
        },

        onShow: function (e) {
            context.view = e.view;

            e.view.element.find('.schoolinfo').css('display', 'block');
            e.view.element.find('.backbtn').css('display', 'block');

            if (App.currentUser.schoolCode == "") {
                context.view.element.find('.schoolinfo').css('display', 'none');
            }

            App.models.settings.schoolYearsDataSource.read();
            App.models.settings.schoolsDataSource.read();

            var save = App.getSaveBarcodeLS();
            if (save == "") {
                save = "true";
                App.setSaveBarcodeLS("true");
            }
            context.view.element.find('.saveBarcode').checked = ((save == "true") ? true : false);

        },

        onChangeYear: function (e) {
            App.activeSchoolYear = e.value;
        },

        onChangeSchool: function (orgCode, orgName) {
            App.currentUser.school = orgName;
            App.currentUser.schoolCode = orgCode;
        }
    });

    return new View();
});