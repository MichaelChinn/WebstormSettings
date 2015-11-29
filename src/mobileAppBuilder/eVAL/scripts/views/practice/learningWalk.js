/**
 * learningWalks view
 */
define([
    'views/baseview',
    'app/api',
    'text!../../../views/practice/classroom_list.html'
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

        onShow: function (e) {

            //cache for later use
            context.view = e.view;
        
            App.models.learningWalk.sessionId = parseInt(e.view.params.id);

            e.view.element.find('.backbtn').css('display', 'inline-block');
            e.view.element.find('.title').css('font-weight', 'bold');

            
            $.when(api.getLearningWalk(parseInt(e.view.params.id)))
                .done(function (learningWalk) {
                    e.view.element.find('.title').text(learningWalk.title);
                });

            App.models.learningWalk.dataSource.read();

            e.view.element.find('.listview').kendoMobileListView({
                dataSource: App.models.learningWalk.dataSource,
                template: listTemplate,
                style: 'inset'
            })
 
        }

    });

    return new View();
});