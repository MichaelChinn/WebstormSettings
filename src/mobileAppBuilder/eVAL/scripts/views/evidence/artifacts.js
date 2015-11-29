/**
 * settings view
 */
define([
    'kendo',
    'views/baseview',
    'app/api',
    'text!../../../views/evidence/_list.html'
], function (kendo, BaseView, api, listTemplate) {
    var context = null;

    var View = BaseView.extend({
        view: null,


        init: function () {
            context = this;
        },

        onInit: function (e) {
            
        },

        onShow: function (e) {

            // need to clear this because it is used by UploadMediaControl to transfer artifacts and is set in uploading artifacts
            // associated with an observation
            App.currentSessionId = -1;
            dataSource: App.models.evidenceArtifacts.dataSource;
            context.view = e.view;
            BaseView.fn.setNavBarTitle(this, "My Artifacts");
            e.view.element.find('.backbtn').css('display', 'inline-block');
            App.setEvaluationTypeFromEvaluateeRole();
            //alert(e.view.element.find('.listview'));
            e.view.element.find('.listview').kendoMobileListView({
                dataSource: App.models.evidenceArtifacts.dataSource,
                template: listTemplate,
                style: 'inset'
            });
            myArtifact.uploadSuccess();
        },

        onHide: function (e) {
            //alert("close");
        },

        refreshList : function () {
            context.view.element.find('.listview').data('kendoMobileListView').refresh();
        }
    });

    return new View();
});