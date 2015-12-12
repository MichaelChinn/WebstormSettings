/**
* scoringElement data-model
*/
define([
    'kendo',
    'app/api',
    'app/utils'],
    function (kendo, api, utils) {

        var viewModel = kendo.observable({

            id: -1,
            isFrameworkNode: false,

            onScoreDIS: function (e) {
                viewModel.onScoreElement(4);
            },

            onScorePRO: function (e) {
                viewModel.onScoreElement(3);
            },

            onScoreBAS: function (e) {
                viewModel.onScoreElement(2);
            },

            onScoreUNS: function (e) {
                viewModel.onScoreElement(1);
            },

            onScoreElement: function (pl) {
               
                if (viewModel.isFrameworkNode) {
                    
                    api.scoreFrameworkNode(App.models.learningWalkClassroom.classroomId, App.currentUser.id, viewModel.id, pl)
                    .done(function (data) {
                        App.views.scoringElement.refreshCurrentScore(pl);
                        //  options.success(data);
                    })
                }
                else {
                    
                    api.scoreRubricRow(App.models.learningWalkClassroom.classroomId, App.currentUser.id, viewModel.id, pl)
                    .done(function (data) {
                        App.views.scoringElement.refreshCurrentScore(pl);
                        //  options.success(data);
                    })
                }
            },

            dataSource: new kendo.data.DataSource({
                transport: {
                    read: function (options) {
                        api.getLearningWalkClassroomScoringElementRubricRowData(App.models.learningWalkClassroom.classroomId, App.currentUser.id, viewModel.id)
                        .done(function (data) {
                            options.success(data);
                        });
                    }
                }
            })

        });

        return viewModel;
    });