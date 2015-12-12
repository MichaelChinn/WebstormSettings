/**
 * home view
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
            BaseView.fn.init.call(this, 'Home', false);
            context = this;
        },

        onShow: function (e) {

            context.view = e.view;

            e.view.element.find('.username').text(App.currentUser.firstName + ' ' + App.currentUser.lastName + "!");
            e.view.element.find('.schoolyear').text(App.activeSchoolYear);
            e.view.element.find('.schoolListItem').css('display', 'block');
            if (!App.currentUser.hasMultipleBuildings) {
                e.view.element.find('.schoolListItem').css('display', 'none');
            }
            else {
                e.view.element.find('.school').text(App.currentUser.school);
            }

            e.view.element.find('.backbtn').css('display', 'none');
        }
    });

    //RETURN VIEW
    return new View();
});