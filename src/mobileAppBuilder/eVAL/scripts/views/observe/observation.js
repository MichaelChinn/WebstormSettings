/**
 * observation view
 */
define([
    'app/api',
    'views/baseview',
    'text!../../../views/observe/artifact_list.html'
], function (api, BaseView, listTemplate) {
    var context = null;

    var View = BaseView.extend({
        view: null,


        init: function () {
            BaseView.fn.init.call(this);
            context = this;
        },

        onInit: function (e) {
        },

        onShow: function (e) {
            context.view = e.view;

            App.models.observeObservation.sessionId = parseInt(e.view.params.id);
            App.currentSessionId = App.models.observeObservation.sessionId;

            e.view.element.find('.evaluateeTitle').css('font-weight', 'bold');
            e.view.element.find('.observationTitle').css('font-weight', 'bold');
            e.view.element.find('.observationArrow').css('font-weight', 'bold');
            e.view.element.find('.observationArrow').html('&nbsp > &nbsp');
            e.view.element.find('.backbtn').css('display', 'inline-block');
            App.setEvaluationTypeFromEvaluatorRole();

            $.when(api.getEvalSessionById(parseInt(e.view.params.id)))
                .done(function (session) {
                    e.view.element.find('.observationTitle').text(session.title);
                });

            $.when(api.getUserById(parseInt(App.models.observeEvaluatee.evaluateeId)))
                .done(function (user) {
                    e.view.element.find('.evaluateeTitle').text(user.firstName + ' ' + user.lastName);
                });

            App.models.observeObservation.dataSource.read();

            e.view.element.find('.listview').kendoMobileListView({
                dataSource: App.models.observeObservation.dataSource,
                template: listTemplate,
                style: 'inset'
            });


        },

        refreshList: function () {
            context.view.element.find('.listview').data('kendoMobileListView').refresh();
        }
    });

    //RETURN VIEW
    return new View();
});