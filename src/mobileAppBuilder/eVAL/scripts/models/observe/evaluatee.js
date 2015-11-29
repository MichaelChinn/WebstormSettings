/**
* evaluatee data-model
*/
define([
    'kendo',
    'app/api'],
    function (kendo, api) {

        var viewModel = kendo.observable({

            newSessionTitle: "New Session",
            evaluateeId: -1,

            dataSource: new kendo.data.DataSource({
                transport: {
                    read: function (options) {
                        console.log("viewModel.observeEvaluatee.read");
                        api.getEvalSessionsForEvaluatee(App.activeSchoolYear,
                                    App.currentUser.id,
                                    viewModel.evaluateeId,
                                    App.currentUser.districtCode,
                                    App.currentUser.schoolCode == "" ? "0" : App.currentUser.schoolCode,
                                    App.mapActiveEvaluatorRoleToEvaluationType())
                            .done(function (data) {                  
                                options.success(data);
                            });
                    }
                }
            }),

            newSession: function (e) {

                var evaluatee = null;
                var session = "";

                api.getUserById(viewModel.evaluateeId)
                    .done(function (data) {
                        evaluatee = data;
                        session = {
                            Title: viewModel.get("newSessionTitle"),
                            EvaluatorId: App.currentUser.id,
                            EvaluateeId: evaluatee.id,
                            DistrictCode: evaluatee.districtCode,
                            SchoolCode: evaluatee.schoolCode,
                            EvaluationType: 2,
                            SchoolYear: App.activeSchoolYear,
                            baseUrl: App.config.baseUrl
                        };
                        api.newEvalSession(session)
                            .done(function (data) {
                                viewModel.dataSource.read();
                                App.views.observeEvaluatee.refreshList(e);
                            });

                    })
            }
        });

        return viewModel;
    });