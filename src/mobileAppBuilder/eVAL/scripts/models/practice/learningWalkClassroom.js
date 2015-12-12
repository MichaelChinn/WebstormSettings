/**
* learningWalkClassroom data-model
*/
var mywalkroom;
define([
    'kendo',
    'app/api',
    'app/utils'],
    function (kendo, api, utils) {


        var viewModel = kendo.observable({

            classroomId: -1,
            elementId: -1,
            focusOnly: true,
            myId: -1,
            isFrameworkNode: false,

            onSetContext: function (context) {
                vars = context.split(':');
                viewModel.myId = vars[0];
                viewModel.isFrameworkNode = vars[1];
            },

            onScoreDIS: function (e) {
                viewModel.onSetContext(e.context);
                viewModel.onScoreElement(4);
            },

            onScorePRO: function (e) {
                viewModel.onSetContext(e.context);
                viewModel.onScoreElement(3);
            },

            onScoreBAS: function (e) {
                viewModel.onSetContext(e.context);
                viewModel.onScoreElement(2);
            },

            onScoreUNS: function (e) {
                viewModel.onSetContext(e.context);
                viewModel.onScoreElement(1);
            },

            onScoreElement: function (pl) {
                if (viewModel.isFrameworkNode == 'true') {
                    api.scoreFrameworkNode(App.models.learningWalkClassroom.classroomId, App.currentUser.id, viewModel.myId, pl)
                   .done(function (data) {
                       App.views.learningWalkClassroom.refreshCurrentScoreFN(pl, viewModel.myId);
                   })
                }
                else {
                    api.scoreRubricRow(App.models.learningWalkClassroom.classroomId, App.currentUser.id, viewModel.myId, pl)
                    .done(function (data) {
                        App.views.learningWalkClassroom.refreshCurrentScoreRR(pl, viewModel.myId);
                    })
                }
            },




            dataSource: new kendo.data.DataSource({
                transport: {
                    read: function (options) {
                        api.getLearningWalkClassroomScoringElements(viewModel.classroomId, App.currentUser.id, viewModel.focusOnly)
                        .done(function (data) {
                            options.success(data);
                        });
                    }
                }
            }),

            uploadSuccess: function () {
                viewModel.dataSource.read();
                App.views.learningWalkClassroom.refreshList();
            },

            onChangeFocusFilter: function (e) {
                var buttonGroup = e.sender;
                var index = buttonGroup.current().index();
                viewModel.focusOnly = (index == 0) ? true : false;
                viewModel.dataSource.read();
                App.views.learningWalkClassroom.refreshList();
            }



        });

        mywalkroom = viewModel;


        return viewModel;
    });