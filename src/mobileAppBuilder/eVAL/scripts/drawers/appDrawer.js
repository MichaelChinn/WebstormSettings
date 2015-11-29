/**
 * This is a main drawer
 */
define([
    'drawers/basedrawer'
], function (BaseDrawer) {

    var Drawer = BaseDrawer.extend({

        init: function () {
            BaseDrawer.fn.init.call(this);
        },

        onShow: function (e) {
            //alert("drawer")
            this.wrapper.find('.admin').css('display', 'none');
            /* TODO: not implemented yet
            this.wrapper.find('.admin').css('display', 'block');
            if (!App.currentUserIsInRole(App.roles.schoolAdmin) && !App.currentUserIsInRole(App.roles.districtAdmin)) {
                this.wrapper.find('.admin').css('display', 'none');
            }
            */

            this.wrapper.find('.evalPrincipals').css('display', 'block');
            if (!App.currentUserIsInRole(App.roles.principalEvaluator)) {
                this.wrapper.find('.evalPrincipals').css('display', 'none');
            }

            this.wrapper.find('.evalTeachers').css('display', 'block');
            if (!App.currentUserIsInRole(App.roles.teacherEvaluator)) {
                this.wrapper.find('.evalTeachers').css('display', 'none');
            }

            this.wrapper.find('.myEval').css('display', 'block');
            if (!App.currentUserIsInRole(App.roles.teacher) && !App.currentUserIsInRole(App.roles.principal)) {
                this.wrapper.find('.myEval').css('display', 'none');
            }
        },

        onBeforeShow: function (e) {
            if (App.currentUser == null) {
                e.preventDefault();
            }
        }
    });

    return new Drawer();
});