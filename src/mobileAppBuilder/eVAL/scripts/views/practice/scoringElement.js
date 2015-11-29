/**
 * scoringElement view
 */
define([
    'views/baseview',
    'app/api',
    'text!../../../views/practice/scoringElementRubricElement_list.html',
     'text!../../../views/practice/performanceLevel_list.html'
], function (BaseView, api, listTemplate, scoreTemplate) {
    var context = null;

    var View = BaseView.extend({
        view: null,

        init: function () {
            BaseView.fn.init.call(this);
            context = this;
        },

        onInit: function (e) {
        },

        refreshCurrentScore: function (pl) {
            
            context.view.element.find('.currentScore').text(App.mapPerformanceLevelToFullDisplayName(pl));
            context.view.element.find('.currentScore').css('background-color', App.mapPerformanceLevelToColor(pl));
        },

         onShow: function (e) {

            //cache for later use
            context.view = e.view;
            
            App.models.scoringElement.id = Number(e.view.params.id);
            App.models.scoringElement.isFrameworkNode = (e.view.params.isFrameworkNode == "true");
            var performanceLevel = Number(e.view.params.performanceLevel);
         
            var color = e.view.params.color;
            var shortName = e.view.params.shortName;
            var title = e.view.params.title;

            //alert(color);

            e.view.element.find('.backbtn').css('display', 'inline-block');
            e.view.element.find('.title').css('font-weight', 'bold');
            e.view.element.find('.title').text(title);
            e.view.element.find('.currentScore').css('font-weight', 'bold');
            e.view.element.find('.currentScore').css('background-color', color);
            e.view.element.find('.currentScore').css('padding', "5px");
            e.view.element.find('.currentScore').text(App.mapPerformanceLevelToFullDisplayName(performanceLevel));

            App.models.scoringElement.dataSource.read();

            e.view.element.find('.listview').kendoMobileListView({
               dataSource: App.models.scoringElement.dataSource,
               template: listTemplate,
               style: 'inset'
           });
        }

    });

    return new View();
});