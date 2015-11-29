var App = {};

define([
        'jquery',
        'kendo',
        'app/api',
        'layouts/main',
        'layouts/login',
        'views/home',
        'views/settings',
        'views/evidence/artifacts',
        'views/evidence/artifact',
        'views/observe/evaluatees',
        'views/observe/evaluatee',
        'views/observe/artifact',
        'views/practice/learningWalks',
        'views/practice/learningWalk',
        'views/practice/learningWalkClassroom',
        'views/practice/scoringElement',
        'views/login',
        'views/observe/observation',
        'models/login',
        'models/home',
        'models/observe/evaluatees',
        'models/observe/evaluatee',
        'models/observe/observation',
        'models/evidence/artifacts',
        'models/evidence/artifact',
        'models/practice/learningWalks',
        'models/practice/learningWalk',
        'models/practice/learningWalkClassroom',
        'models/practice/scoringElement',
        'models/settings',
        'drawers/appDrawer'
], function ($,
            kendo,
            api,
            layoutMain,
            layoutLogin,
            viewHome,
            viewSettings,
            viewEvidenceArtifacts,
            viewEvidenceArtifact,
            viewObserveEvaluatees,
            viewObserveEvaluatee,
            viewObserveArtifact,
            viewLearningWalks,
            viewLearningWalk,
            viewLearningWalkClassroom,
            viewScoringElement,
            viewLogin,
            viewObserveObservation,
            loginModel,
            homeModel,
            observeEvaluateesModel,
            observeEvaluateeModel,
            observeObservationModel,
            evidenceArtifactsModel,
            evidenceArtifactModel,
            learningWalksModel,
            learningWalkModel,
            learningWalkClassroomModel,
            scoringElementModel,
            settingsModel,
            appDrawer) {

    var init = function () {

        console.log('init function at app.js');
        App.initialPage = 'views/login.html';
        App.currentUser = null;
        App.activeSchoolYear = 0;
        App.activeEvaluatorRole = 0;
        App.evaluationType = 0;
        App.currentSessionId = -1;
        App.basicAuthEncoding = "ZXZhbFdlYkFQSTpjYWNlNEFyMmhhUWVXckU=";
        App.userName = "";
        App.password = "";
        App.kendo = null;
        initConfig();
        initRoles();
        initActiveEvaluatorRoles();
        initMethods();
        initLayouts();
        initViews();
        initModels();
        initDrawers();
        initMobile();

        // if they have already logged in then their userid should be in local storage and we
        // don't need to login again.
        var userId = App.getLocalStorageValue('SEUserID');

        if (userId != "") {
            api.getUserById(userId)
                .done(function (data) {
                    App.setCurrentUserFromData(data);
                    App.initSchoolYear();
                });
        }
    };

    var initMobile = function () {

        // this function is called by Cordova when the application is loaded by the device
        document.addEventListener('deviceready', function () {

            // hide the splash screen as soon as the app is ready. otherwise
            // Cordova will wait 5 very long seconds to do it for you.
            navigator.splashscreen.hide();

            App.kendo = new kendo.mobile.Application(document.body, {

                // comment out the following line to get a UI which matches the look
                // and feel of the operating system
                skin: 'flat',

                // the application needs to know which view to load first
                initial: App.initialPage
            });
        });
    };

    var initConfig = function () {
        App.config = {
            baseUrl: "http://test.eval-wa.org/StateEvalTest_WebAPI"
        };
    };

    var initLayouts = function () {
        App.layouts = {
            main: layoutMain,
            login: layoutLogin
        };
    };

    var initViews = function () {
        App.views = {
            home: viewHome,
            settings: viewSettings,
            evidenceArtifacts: viewEvidenceArtifacts,
            evidenceArtifact: viewEvidenceArtifact,
            observeEvaluatees: viewObserveEvaluatees,
            observeEvaluatee: viewObserveEvaluatee,
            observeArtifact: viewObserveArtifact,
            observeObservation: viewObserveObservation,
            login: viewLogin,
            learningWalks: viewLearningWalks,
            learningWalk: viewLearningWalk,
            learningWalkClassroom: viewLearningWalkClassroom,
            scoringElement: viewScoringElement
        };
    };

    var initModels = function () {
        App.models = {
            login: loginModel,
            home: homeModel,
            observeEvaluatees: observeEvaluateesModel,
            observeEvaluatee: observeEvaluateeModel,
            observeObservation: observeObservationModel,
            evidenceArtifacts: evidenceArtifactsModel,
            evidenceArtifact: evidenceArtifactModel,
            settings: settingsModel,
            learningWalks: learningWalksModel,
            learningWalk: learningWalkModel,
            learningWalkClassroom: learningWalkClassroomModel,
            scoringElement: scoringElementModel
        };
    };

    var initDrawers = function () {
        App.drawers = {
            appDrawer: appDrawer
        };
    };

    var initRoles = function () {
        App.roles = {
            teacher: 'SESchoolTeacher',
            principal: 'SESchoolPrincipal',
            teacherEvaluator: 'SETeacherEvaluator',
            schoolAdmin: 'SESchoolAdmin',
            principalEvaluator: 'SEPrincipalEvaluator',
            districtAdmin: 'SEDistrictAdmin',
            districtEvaluator: 'SEDistrictEvaluator'
        }
    };

    /* enum SEActiveEvaluatorRole */
    var initActiveEvaluatorRoles = function () {
        App.activeEvaluatorRoles = {
            PR_PR: 1,
            PR_TR: 2,
            DE_PR: 3,
            DTE_TR: 4,
            DA_PR: 5,
            SA_TR: 6
        }
    };

    var initMethods = function () {

        App.mapActiveEvaluatorRoleToEvaluationType = function () {
            if (App.activeEvaluatorRole == App.activeEvaluatorRoles.PR_PR ||
                App.activeEvaluatorRole == App.activeEvaluatorRoles.DE_PR) {
                return 1;
            }
            else {
                return 2;
            }
        },

        App.mapPerformanceLevelToFullDisplayName = function (pl) {
            if (pl == 0) return "NOT SCORED";
            if (pl == 1) return "UNSATISFACTORY";
            if (pl == 2) return "BASIC";
            if (pl == 3) return "PROFICIENT";
            if (pl == 4) return "DISTINGUISHED";

            return "UNKNOWN";
        },

        App.mapPerformanceLevelToshortName = function (pl) {
            if (pl == 0) return "N";
            if (pl == 1) return "U";
            if (pl == 2) return "B";
            if (pl == 3) return "P";
            if (pl == 4) return "D";

            return "UNKNOWN";
        },

        App.mapPerformanceLevelToColor = function (pl) {
            if (pl == 1) return "Red";
            if (pl == 2) return "Yellow";
            if (pl == 3) return "LightBlue";
            if (pl == 4) return "Limegreen";

            return "white";
        },

        App.setEvaluationTypeFromEvaluatorRole = function () {

            App.evaluationType = App.mapActiveEvaluatorRoleToEvaluationType();
        },

        App.setEvaluationTypeFromEvaluateeRole = function () {

            if (App.currentUserIsInRole(App.roles.principal)) {
                App.evaluationType = 1;
            }
            else if (App.currentUserIsInRole(App.roles.teacher)) {
                App.evaluationType = 2;
            }
            else {
                App.evaluationType = 0;
            }
        },

        App.currentUserIsInRole = function (role) {
            return (App.currentUser.roles.indexOf(role + ";") >= 0);
        },

        App.isActiveSchoolYear = function (schoolYear) {
            return (schoolYear == App.activeSchoolYear);
        },

        App.isActiveSchool = function (school) {
            return (school == App.currentUser.school);
        },

        App.initCurrentUser = function (callback) {

            App.activeSchoolYear = 0;

            $.when(
            api.getCurrentUser()
            .done(function (data) {
                App.setCurrentUserFromData(data);
            }))
            .done(callback);
        },

        App.setCurrentUserFromData = function (data) {
            App.currentUser = data;
        },

        App.setSaveBarcodeLS = function (val) {
            localStorage.setItem('SaveBarcode', val);
        },

        App.getSaveBarcodeLS = function () {
            return App.getLocalStorageValue('SaveBarcode');
        },

        App.getLocalStorageValue = function (key) {
            var value = localStorage.getItem(key);
            if (value != "" && value != "undefined" && value != null)
                return value;
            else
                return "";
        }

        App.saveBarcodeToLocalStorage = function (barcodeText) {
            var tokens = barcodeText.split("BASEURL:");
            var uuid = tokens[0];
            var baseUrl = tokens[1];
            localStorage.setItem("UUID", uuid);
            localStorage.setItem("BASEURL", baseUrl);
            console.log("saveBarcodeToLocalStorage: UUID: " + uuid);
            console.log("saveBarcodeToLocalStorage: BASEURL: " + baseUrl);
            App.config.baseUrl = baseUrl;
        }
        
        App.initSchoolYear = function () {
            $.when(api.getDistrictConfigsForUser(App.currentUser.districtCode)
            .done(function (data) {
                var i;
                for (i = 0; i < data.length; ++i) {
                    if (data[i].schoolYearIsDefault) {
                        App.activeSchoolYear = data[i].schoolYear;
                    }
                }
                App.kendo.navigate("views/home.html");
            }));
        };
    }

    return {
        init: init
    };
});
