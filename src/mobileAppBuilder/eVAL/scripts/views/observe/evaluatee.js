/**
 * evaluatee view
 */
define([
    'app/api',
    'views/baseview',
    'text!../../../views/observe/observation_list.html'
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

        refreshList: function (e) {
            e.sender.element.closest("[data-role=modalview]").data("kendoMobileModalView").close();
            context.view.element.find('.listview').data('kendoMobileListView').refresh();
        },

        onShow: function (e) {
            //cache for later use
            context.view = e.view;
            
            console.log("view.observeEvaluatee:onShow");
            App.models.observeEvaluatee.evaluateeId = parseInt(e.view.params.id);

            e.view.element.find('.evaluateeTitle').css('font-weight', 'bold');
            e.view.element.find('.backbtn').css('display', 'inline-block');

            if (App.activeEvaluatorRole == App.activeEvaluatorRoles.PR_TR ||
                App.activeEvaluatorRole == App.activeEvaluatorRoles.DTE_TR) {
                BaseView.fn.setNavBarTitle(this, "Teacher Detail");
            }
            else {
                BaseView.fn.setNavBarTitle(this, "Principal Detail");
            }

            $.when(api.getUserById(parseInt(e.view.params.id)))
                .done(function (user) {
                    e.view.element.find('.evaluateeTitle').text(user.firstName + ' ' + user.lastName);
                });

            App.models.observeEvaluatee.dataSource.read();

            e.view.element.find('.listview').kendoMobileListView({
                dataSource: App.models.observeEvaluatee.dataSource,
                template: listTemplate,
                style: 'inset'
            });

        }
    });

    //RETURN VIEW
    return new View();
});