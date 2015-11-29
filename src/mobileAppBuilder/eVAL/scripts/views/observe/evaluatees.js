/**
 * evaluatees view
 */
define([
    'views/baseview',
    'app/api',
    'text!../../../views/observe/evaluatee_list.html'
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

        refreshList: function () {
            context.view.element.find('.listview').data('kendoMobileListView').refresh();
        },

        onShow: function (e) {

            //cache for later use
            context.view = e.view;

            e.view.element.find('.backbtn').css('display', 'inline-block');

            var section = e.view.params.section.toString();

            if (App.currentUserIsInRole(App.roles.principal) && section == "evalTeachers") {
                App.activeEvaluatorRole = App.activeEvaluatorRoles.PR_TR;
                BaseView.fn.setNavBarTitle(this, "My Teachers");
            }
            else if (App.currentUserIsInRole(App.roles.districtEvaluator)) {
                BaseView.fn.setNavBarTitle(this, "My Principals");
                App.activeEvaluatorRole = App.activeEvaluatorRoles.DE_PR;
            }
            else if (App.currentUserIsInRole(App.roles.principalEvaluator) && section == "evalPrincipals") {
                BaseView.fn.setNavBarTitle(this, "My Principals");
                App.activeEvaluatorRole = App.activeEvaluatorRoles.PR_PR;
            }
            else if (App.currentUserIsInRole(App.roles.teacherEvaluator)) {
                BaseView.fn.setNavBarTitle(this, "My Teachers");
                App.activeEvaluatorRole = App.activeEvaluatorRoles.DTE_TR;
            }

            App.models.observeEvaluatees.dataSource.read();

            e.view.element.find('.listview').kendoMobileListView({
                dataSource: App.models.observeEvaluatees.dataSource,
                template: listTemplate,
                style: 'inset'
            });
        }

    });

    return new View();
});