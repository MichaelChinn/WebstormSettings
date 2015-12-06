(function () {
    'use strict';

    var core = angular.module('stateeval.core');

    /*
     // configure toaster
     core.config(toastrConfig);
     toastrConfig.$inject = ['toastr'];

     function toastrConfig(toastr) {
     // need to do this here manually to prevent a circular reference
     toastr.options.timeOut = 4000;
     toastr.options.positionClass = 'toast-bottom-right';
     }
     */

    function getAPIUrl() {
        var host = window.location.host;
        if (host.indexOf("localhost")!=-1) {
            return 'http://localhost/StateEvalWebAPI/api/';
        }
        else if (host.indexOf('test')!=-1) {
            return 'http://test.eval-wa.org/StateEval_WebAPI_Test/api/';
        }
        else if (host.indexOf('sandbox')!=-1) {
            return 'http://sandbox.eval-wa.org/StateEval_WebAPI_Sandbox/api/';
        }
        else if (host.indexOf('demo')!=-1) {
            return 'http://test.eval-wa.org/StateEval_WebAPI_Demo/api/';
        }
        else if (host.indexOf('eval-wa.org')===0) {
            return 'https://eval-wa.org/StateEval_WebAPI_WA_Prod/api/';
        }
    }

    // global constants
    var config = {
        appErrorPrefix: '[eval Error] ',
        appTitle: 'eval',
        // apiUrl: 'http://test.eval-wa.org/StateEval_WebAPI_Test/api/',
        // apiUrl:  'http://localhost/StateEvalWebAPI/api/',
        apiUrl: getAPIUrl(),
        schoolYear: 2016,
        summernoteDefaultOptions: {
            height: 100,
            toolbar: [
                ['edit', ['undo', 'redo']],
                ['style', ['bold', 'italic', 'underline']],
                ['alignment', ['ul', 'ol']]
            ]
        }
    };

    var enums = {
        StudentGrowthFormPromptType: {
            'GOAL_SETTING': 1,
            'GOAL_MONITORING': 2,
            'GOAL_REVIEW': 3
        },
        EvColTypeAccessor: {
           'OBSERVATION' : 'observations',
            'STUDENT_GROWTH_GOALS': 'studentGrowthGoalBundles'
        },
        EvidenceCollectionType: {
            'UNDEFINED': 0,
            'OTHER_EVIDENCE': 1,
            'OBSERVATION': 2,
            'SELF_ASSESSMENT': 3,
            'STUDENT_GROWTH_GOALS': 4,
            'SUMMATIVE': 5
        },
        EvidenceType: {
            'ARTIFACT': 1,
            'RR_ANNOTATION_OBSERVATION_NOTES': 2,
            'RR_ANNOTATION_PRECONF_PROMPT': 3,
            'RR_ANNOTATION_PRECONF_SUMMARY': 4,
            'RR_ANNOTATION_POST_CONF_PROMPT': 5,
            'RR_ANNOTATION_POST_CONF_SUMMARY': 6,
            'STUDENT_GROWTH_GOAL': 7
        },
        EvidenceTypeMapper: {
            '1': 'Artifact',
            '2': 'Observation Notes',
            '3': 'Pre-Conference Prompt',
            '4': 'Pre-Conference Summary',
            '5': 'Post-Conference Prompt',
            '6': 'Post-Conference Summary',
            '7': 'Student Growth Goal'
        },
        PerformanceLevelShortNameMapper: {
            '1': 'UNS',
            '2': 'BAS',
            '3': 'PRO',
            '4': 'DIS'
        },
        AnnotationTypeMapper: {
            '1': 'Observation Notes',
            '2': 'Artifact Alignment',
            '3': 'Additional Input',
            '4': 'Pre-conference Prompt',
            '5': 'Pre-conference Summary'
        },
        itemTypeMapper: {
            '1': 'Artifact',
            '2': 'Artifact Linked to Student Growth Goal',
            '3': 'Artifact Linked to Observation',
            '4': 'Artifact Linked to Self Assessment',
            '5': 'Observation',
            '6': 'Self-Assessment',
            '7': 'Student Growth Goal'
        },
        ItemType: {
            'ARTIFACT_OTHER_EVIDENCE': 1,
            'ARTIFACT_LINKED_TO_SG_GOAL': 2,
            'ARTIFACT_LINKED_TO_OBSERVATION': 3,
            'ARTIFACT_LINKED_TO_SELF_ASSESSMENT': 4,
            'OBSERVATION': 5,
            'SELF_ASSESSMENT': 6,
            'STUDENT_GROWTH_GOAL': 7
        },
        ArtifactWfStates: [
            'Undefined',
            'Uploaded',
            'Needs Further Input',
            'Submitted'
        ],
        EvaluationTypes: [
            'Undefined',
            'Principal Evaluation',
            'Teacher Evaluation',
            'Librarian Evaluation'
        ],
        RubricRowAnnotationType: {
            'UNDEFINED': 0,
            'OBSERVATION_NOTES': 1,
            'ARTIFACT_ALIGNMENT': 2,
            'ADDITIONAL_INPUT': 3,
            'PRE_CONF_QUESTION': 4,
            'PRE_CONF_MEETING':5,
            'ARTIFACT_GENERAL': 6
        },
        Order: [
            'schoolYear',
            'districtName',
            'schoolName',
            'workAreaTag'
        ],
        PLAccessor: {
            UNSATISFACTORY: 'pL1Descriptor',
            BASIC: 'pL2Descriptor',
            PROFICIENT: 'pL3Descriptor',
            DISTINGUISHED: 'pL4Descriptor'
        },
        PerformanceLevels: [
            'UNSATISFACTORY',
            'BASIC',
            'PROFICIENT',
            'DISTINGUISHED'
        ],
        EvalAssignmentRequestStatus: {
            'PENDING': 1,
            'ACCEPTED': 2,
            'REJECTED': 3
        },
        EvalAssignmentRequestType: {
            'OBSERVATION_ONLY': 1,
            'ASSIGNED_EVALUATOR': 2
        },
        EventType: {
            'OBSERVATION_CREATED': 1,
            'ARTIFACT_SUBMITTED': 2,
            'ARTIFACT_REJECTED': 3
        },
        ArtifactBundleRejectionType: {
            'UNDEFINED': 0,
            'NON_ESSENTIAL': 1,
            'REQUEST_REFINEMENTS': 2,
            'OTHER': 3
        },
        RubricPerformanceLevel: {
            'UNDEFINED': 0,
            'PL1': 1,
            'PL2': 2,
            'PL3': 3,
            'PL4': 4
        },
        LinkedItemType: {
            'ARTIFACT': 1,
            'OBSERVATION': 2,
            'SELF_ASSESSMENT': 3,
            'STUDENT_GROWTH_GOAL': 4
        },
        StudentGrowthGoalProcessType: {
            'UNDEFINED': 0,
            'DEFAULT_FORM': 1,
            'DISTRICT_FORM': 2,
            'OFFLINE_FORM': 3
        },
        WfState: {
            'UNDEFINED': 0,
            'DRAFT': 1,
            'READY_FOR_CONFERENCE': 2,
            'READY_FOR_FORMAL_RECEIPT': 3,
            'RECEIVED': 4,
            'SUBMITTED': 5,
            'ARTIFACT': 6,
            'ARTIFACT_REJECTED': 7,
            'ARTIFACT_SUBMITTED': 8,
            'GOAL_BUNDLE_IN_PROGRESS': 9,
            'GOAL_BUNDLE_PROCESS_SUBMITTED': 10,
            'GOAL_BUNDLE_RESULTS_SUBMITTED': 11,
            'GOAL_BUNDLE_NOT_SCORED': 12,
            'GOAL_BUNDLE_PROCESS_SCORED': 13,
            'GOAL_BUNDLE_RESULST_SCORED': 14,
            'OBS_IN_PROGRESS_TOR': 15,
            'OBS_SUBMITTED_TOR': 16,
            'ARTIFACT_EVALUATED': 17,
            'GOAL_BUNDLE_EVALUATED': 18,
            'RREVAL_NOT_STARTED_OBSOLETE': 19,
            'RREVAL_IN_PROGRESS_OBSOLETE': 20,
            'RREVAL_DONE_OBSOLETE': 21,
            'USERPROMPT_IN_PROGRESS': 22,
            'USERPROMPT_FINALIZED': 23,
            'USERPROMPT_RETIRED': 24,
            'SG_GOAL_SETUP_IN_PROGRESS': 25,
            'SG_GOAL_SETUP_DONE': 26
        },
        ArtifactLibItemType: {
            'UNDEFINED': 0,
            'FILE': 1,
            'WEB': 2,
            'PROFPRACTICE': 3
        },
        SchoolYear: {
            'UNDEFINED': 0,
            'SY_2012_2013': 2013,
            'SY_2013_2014': 2014,
            'SY_2014_2015': 2015,
            'SY_2015_2016': 2016
        },
        EvaluationType: {
            'UNDEFINED': 0,
            'PRINCIPAL': 1,
            'TEACHER': 2,
            'LIBRARIAN': 3
        },
        PromptType: {
            'PreConf': 1,
            'PostConf': 2
        },
        EvaluationPlanType: {
            'UNDEFINED': 0,
            'COMPREHENSIVE': 1,
            'FOCUSED': 2
        },
        FrameworkViewType: {
            'UNDEFINED': 0,
            'STATE_FRAMEWORK_ONLY': 1,
            'STATE_FRAMEWORK_DEFAULT': 2,
            'INSTRUCTIONAL_FRAMEWORK_DEFAULT': 3,
            'INSTRUCTION_FRAMEWORK_ONLY': 4
        },
        Roles: {
            'SESuperAdmin': 'SESuperAdmin',
            'SEDistrictAdmin': 'SEDistrictAdmin',
            'SEDistrictViewer': 'SEDistrictViewer',
            'SESchoolAdmin': 'SESchoolAdmin',
            'SESchoolPrincipal': 'SESchoolPrincipal',
            'SESchoolTeacher': 'SESchoolTeacher',
            'SEDistrictEvaluator': 'SEDistrictEvaluator',
            'SEDistrictWideTeacherEvaluator': 'SEDistrictWideTeacherEvaluator',
            'SESchoolHeadPrincipal': 'SESchoolHeadPrincipal',
            'SECustomSupportL1': 'SECustomSupportL1',
            'SEDistrictAssignmentManager': 'SEDistrictAssignmentManager'
        },
        ActiveEvaluationRole: {
            'UNDEFINED': 0,
            'PR_PR': 1,
            'PR_TR': 2,
            'DE_PR': 3,
            'DTE_TR': 4,
            'DA_PR': 5,
            'SA_TR': 6
        },
        PreConfPromptStateEnum: {
            PromptCreated: 1,
            WaitingForEvaluateeResponse: 2,
            ReadyForEvaluatorCoding: 3,
            UpdateRequested: 4
        }

    };

    core
        .constant('HTTP_DEFAULT_ERROR_MSG',
        'An error has occured. Please contact customer support for assistance.')
        .constant('HTTP_NETWORK_ERROR_MSG',
        'Unable to communicate with the server. Make sure you are connected to the internet and try again.')
        .constant('SCRIPT_ERROR_MSG',
        'An error has occured and the details have been logged. Please contact customer support for assistance.');

    // make the config settings available to config fucntions
    // old way only makes it visible to current module?
    // core.value('config', config);

    core.config(configure);

    configure.$inject = ['$logProvider', 'exceptionHandlerProvider', '$provide'];
    function configure($logProvider, exceptionHandlerProvider, $provide) {

        // $provider makes it injectible to other modules
        $provide.constant('config', config);
        $provide.constant('enums', enums);

        // todo-anne get default schoolyear from db
        $provide.value('schoolYear', enums.SchoolYear.SY_2014_2015);

        if ($logProvider.debugEnabled) {
            $logProvider.debugEnabled(true);
        }
        exceptionHandlerProvider.configure(config.appErrorPrefix);
    }


    core.run(run);

    run.$inject = ['$rootScope', '$state', '$location', '$cookieStore', '$http', 'enums'];

    function run($rootScope, $state, $location, $cookieStore, $http, enums) {
        $rootScope.$state = $state;
        $rootScope.enums = enums;

        // keep user logged in after page refresh
        $rootScope.globals = $cookieStore.get('globals') || {};
        if ($rootScope.globals.currentUser) {
            //TODO: Request header field Authorization is not allowed by Access-Control-Allow-Headers.
            //  $http.defaults.headers.common['Authorization'] = 'Basic ' + $rootScope.globals.currentUser.authdata; // jshint ignore:line
        }

        $rootScope.$on('$stateChangeError', function (event, toState, toParams, fromState, fromParams, error) {
            console.log(error);
        });
        $rootScope.$on('$stateChangeStart', function (event, toParams, fromParams) {
            //console.log(event);
        });
        //$rootScope.$on('$stateChangeStart', function(event, toState, toParams, fromParams) {
        //    if(artifactService.artifactBox.localArtifact) {
        //    }
        //    console.log('changing states');
        //});

        $rootScope.$on('$locationChangeStart', function (event, next, current) {
            // redirect to login page if not logged in and trying to access a restricted page
            var restrictedPage = $.inArray($location.path(), ['/login']) === -1;
            var loggedIn = $rootScope.globals.currentUser;
            if (restrictedPage && !loggedIn) {
                $location.path('/login');
            }
        });

    }

})();
