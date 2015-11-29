/**
 * This is a base drawer
 */
define([
    'jquery',
    'kendo'
], function ($, kendo) {

    //CREATE BASE CLASS FOR LATER INHERITANCE
    var BaseDrawer = kendo.Class.extend({

        //CONSTRUCTOR CALLED ON NEW INSTANCES
        init: function () {
            //MUST CALL BELOW IN DERIVED CLASSES IF NEEDED
            //BaseDrawer.fn.init.call(this);
        },

        //EVENTS
        onInit: function (e) {
        },

        onShow: function (e) {
        },

        onHide: function (e) {

        }
    });

    return BaseDrawer;
});