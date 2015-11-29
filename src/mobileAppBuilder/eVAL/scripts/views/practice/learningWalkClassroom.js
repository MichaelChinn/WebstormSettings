/**
 * learningWalkClassroom view
 */
define([
    'views/baseview',
    'app/api',
    'text!../../../views/practice/scoringElement_list.html'
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

        refreshCurrentScoreFN: function (pl, myId) {
            context.view.element.find('.currentScoreFN' + myId).text(App.mapPerformanceLevelToshortName(pl));
            context.view.element.find('.currentScoreFN_color'+myId).css('background-color', App.mapPerformanceLevelToColor(pl));
            refreshList();
        },

        refreshCurrentScoreRR: function (pl, myId) {
            context.view.element.find('.currentScoreRR' + myId).text(App.mapPerformanceLevelToshortName(pl));
            context.view.element.find('.currentScoreRR_color' + myId).css('background-color', App.mapPerformanceLevelToColor(pl));
            refreshList();
        },

        onShow: function (e) {
          
            //cache for later use
            context.view = e.view;
          
            App.models.learningWalkClassroom.classroomId = parseInt(e.view.params.id);

            e.view.element.find('.backbtn').css('display', 'inline-block');
            e.view.element.find('.title').css('font-weight', 'bold');
            e.view.element.find('.arrowtitle').css('font-weight', 'bold');
            e.view.element.find('.title_learningWalk').css('font-weight', 'bold');
            e.view.element.find('.arrowtitle').html('&nbsp > &nbsp');
            

            $.when(api.getLearningWalkClassroomById(parseInt(e.view.params.id)))
                .done(function (classroom) {
                    e.view.element.find('.title').text(classroom.name);
                });

            $.when(api.getLearningWalk(parseInt(e.view.params.learningWalk_id)))
                .done(function (learningWalk) {
                    e.view.element.find('.title_learningWalk').text(learningWalk.title);
                });


            App.models.learningWalkClassroom.dataSource.read();

            e.view.element.find('.listview').kendoMobileListView({
                dataSource: App.models.learningWalkClassroom.dataSource,
                template: listTemplate,
                style: 'inset'
            });
        }
    });

    return new View();
});