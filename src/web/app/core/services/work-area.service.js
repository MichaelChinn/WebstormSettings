(function () {
    'use strict';

    angular
        .module('stateeval.core')
        .factory('workAreaService', WorkAreaService);

    WorkAreaService.$inject = ['enums', '$state', 'frameworkService', 'userService', 'evaluationService', 'config', '_', '$q', '$modal'];

    function WorkAreaService(enums, $state, frameworkService, userService, evaluationService, config, _, $q, $modal) {

        var nextWorkAreaId = 1;
        var evalT = enums.EvaluationType.TEACHER;
        var evalP = enums.EvaluationType.PRINCIPAL;
        var evalU = enums.EvaluationType.UNDEFINED;


        //LINKS
        var artifacts = NavLink('Artifacts', 'artifacts-private', 'fa fa-clipboard');
        var otherEvidence = NavLink('Other Evidence', 'other-evidence', 'fa fa-file');
        var sgGrowthGoalsTee = NavLink('Student Growth Goals', 'sg-goals-private', 'fa fa-child');
        var sgGrowthGoalsTor = NavLink('Student Growth Goals', 'sg-goals-submitted', 'fa fa-child');
        var observations = NavLink('Observations', 'observations', 'fa fa-eye');
        var selfAssessments = NavLink('Self-Assessments', 'self-assessments', 'fa fa-coffee');
        var summativeEval = NavLink('Summative Evaluation', 'summative-eval', 'fa fa-table');


        var importErrors = NavLink('Import Errors', 'super-admin-import-errors', 'fa fa-user-secret');
        var setup_DE = NavLink('Setup', 'VOID', 'fa fa-gear',
            [PromptBankNavLink(evalP)]);
        var setup_PR_PR = NavLink('Setup', 'VOID', 'fa fa-gear',
            [PromptBankNavLink(evalP)]);
        var setup_PR_TR = NavLink('Setup', 'VOID', 'fa fa-gear',
            [PromptBankNavLink(evalT)]);
        var setup_DTE = NavLink('Setup', 'VOID', 'fa fa-gear',
            [PromptBankNavLink(evalT),
                NavLink('Assignment Requests', 'dte-request-assignment')
            ]);
        var evaluatorReports = NavLink('Reports', 'evaluator-reports', 'fa fa-bar-chart');
        var evaluateeReports = NavLink('Reports', 'evaluatee-reports', 'fa fa-bar-chart');

        var impersonation = NavLink('Evaluations', 'impersonation', 'fa fa-user-secret');
        var modifyFramework = NavLink('Modify Framework', 'modify-framework', 'fa fa-map');
        var evaluateeDashboard = NavLink('Dashboard', 'evaluatee-notifications', 'fa fa-th-large');
        //todo the evaluator dashboard needs to go to a lower level tab page
        var evaluatorDashboard = NavLink('Dashboard', 'evaluator-dashboard', 'fa fa-th-large');
        var saDashboard = NavLink('Dashboard', 'sa-dashboard', 'fa fa-th-large');
        var daDashboard = NavLink('Dashboard', 'da-dashboard', 'fa fa-th-large');
        var dvDashboard = NavLink('Dashboard', 'dv-dashboard', 'fa fa-th-large');
        var teeNav = [evaluateeDashboard, artifacts, otherEvidence, sgGrowthGoalsTee, observations, selfAssessments, summativeEval, evaluateeReports];
        var pr_trNav = [evaluatorDashboard, artifacts, otherEvidence, sgGrowthGoalsTor, observations, selfAssessments, summativeEval, evaluateeReports, setup_PR_TR];
        var pr_prNav = [evaluatorDashboard, artifacts, otherEvidence, sgGrowthGoalsTor, observations, selfAssessments, summativeEval, evaluateeReports, setup_PR_PR];
        var de_prNav = [evaluatorDashboard, artifacts, otherEvidence, sgGrowthGoalsTor, observations, selfAssessments, summativeEval, evaluateeReports, setup_DE];
        var dteNav = [evaluatorDashboard, artifacts, otherEvidence, sgGrowthGoalsTor, observations, selfAssessments, summativeEval, evaluateeReports, setup_DTE];

        //AREAS

        // Admin Work-areas
        var SUPER = new WorkArea('SUPER', 'Super Administrator', evalU, noAdditionalInfoWorkArea,
            [importErrors]);

        var DA_TR = new WorkArea('DA_TR', 'Admin Teacher Evaluations', evalT, noAdditionalInfoWorkArea,
            [daDashboard, FrameworkNavLink(evalT), impersonation, PromptBankNavLink(evalT), AssignmentsNavLink(evalT),
                SGGoalsNavLink(evalT), ResourcesNavLink(evalT), ReportsNavLink(evalT), modifyFramework]);
        var DA_PR = new WorkArea('DA_PR', 'Admin Principal Evaluations', evalP, noAdditionalInfoWorkArea,
            [daDashboard, FrameworkNavLink(evalP), impersonation, PromptBankNavLink(evalP),
                AssignmentsNavLink(evalP), SGGoalsNavLink(evalP), ResourcesNavLink(evalP), ReportsNavLink(evalP), modifyFramework]);
        var SA_TR = new WorkArea('SA_TR', 'Admin Teacher Evaluations', evalT, noAdditionalInfoWorkArea,
            [saDashboard, PromptBankNavLink(evalT), AssignmentsNavLink(evalT), SGGoalsNavLink(evalT), ResourcesNavLink(evalT), ReportsNavLink(evalT)]);
        var SA_PR = new WorkArea('SA_PR', 'Admin Principal Evaluations', evalP, noAdditionalInfoWorkArea,
            [saDashboard, PromptBankNavLink(evalP), AssignmentsNavLink(evalP), SGGoalsNavLink(evalP), ResourcesNavLink(evalP), ReportsNavLink(evalP)]);

        var DAM_TR = new WorkArea('DAM_TR', 'Teacher Assignment', evalT, noAdditionalInfoWorkArea,
            [daDashboard, AssignmentsNavLink(evalT)]);
        var DAM_PR = new WorkArea('DAM_PR', 'Principal Assignment', evalP, noAdditionalInfoWorkArea,
            [daDashboard, AssignmentsNavLink(evalP)]);

        var DV_TR = new WorkArea('DV_TR', 'View Teacher Evaluations', evalT, noAdditionalInfoWorkArea,
            [dvDashboard, impersonation]);
        var DV_PR = new WorkArea('DV_PR', 'View Principal Evaluations', evalP, noAdditionalInfoWorkArea,
            [dvDashboard, impersonation]);
        // Evaluation Work-areas
        var TR_ME = new WorkArea('TR_ME', 'Prepare for My Evaluation', evalT, getEvaluationForUserTeacher,
            teeNav);
        var PR_ME = new WorkArea('PR_ME', 'Prepare for My Evaluation', evalP, getEvaluationForUserPrincipal,
            teeNav);
        var PR_PR = new WorkArea('PR_PR', 'Evaluate Principals', evalP, getEvaluateesForEvaluatorPR_PR,
            pr_prNav);
        var PR_TR = new WorkArea('PR_TR', 'Evaluate Teachers', evalT, getEvaluateesForEvaluatorPR_TR,
            pr_trNav);
        var DE = new WorkArea('DE', 'Evaluate Principals', evalP, getEvaluateesForEvaluatorDE_PR,
            de_prNav);
        var DTE = new WorkArea('DTE', 'Evaluate Teachers', evalT, getObserveEvaluateesForDTEEvaluator,
            dteNav);

        // Other
        var RS = new WorkArea('RS', 'Resources', evalU, noAdditionalInfoWorkArea,
            [NavLink('Resources', 'resource-list', 'fa fa-bomb')]);
        var TRAIN = new WorkArea('TRAIN', 'Training', evalU, noAdditionalInfoWorkArea,
            [NavLink('Training Protocols', 'training-protocols', 'fa fa-magic')]);

        //todo create videos and resources
        //todo what links should an impersonate get how to switch between impersonations
        var CST = new WorkArea('CST', 'Customer Support', evalU, noAdditionalInfoWorkArea,
            []);

        var IMP_TR = new WorkArea('IMP_TR', 'Impersonate TR', evalT, impersonateTR,
            []);
        var IMP_PR = new WorkArea('IMP_PR', 'Impersonate PR', evalP, impersonatePR,
            []);

        var NMP = new WorkArea('NMP', 'Go Back', evalU, stopImpersonation,
            []);


        var roleAreaMapper = {
            SESuperAdmin: [SUPER],
            SEDistrictAdmin: [DA_TR, DA_PR, IMP_TR, IMP_PR],
            SEDistrictViewer: [DV_TR, DV_PR, IMP_TR, IMP_PR],
            SESchoolAdmin: [SA_TR, SA_PR],
            SESchoolPrincipal: [PR_TR, PR_ME],
            SESchoolTeacher: [TR_ME],
            SEDistrictEvaluator: [DE],
            SEDistrictWideTeacherEvaluator: [DTE],
            SESchoolHeadPrincipal: [PR_PR],
            SECustomSupportL1: [CST],
            SEDistrictAssignmentManager: [DAM_TR, DAM_PR]
        };

        var viewableImpersonateRoles = [PR_PR, PR_TR, DTE];

        var evaluators = [PR_PR, PR_TR, DTE, DE];

        WorkArea.prototype.isEvaluatorWorkArea = function () {
            var wa = this;
            return !!_.find(evaluators, function (n) {
                return n.tag === wa.tag;
            })
        };

        var service = {
            SA_TR: SA_TR,
            SA_PR: SA_PR,
            TR_ME: TR_ME,
            PR_PR: PR_PR,
            DA_TR: DA_TR,
            DA_PR: DA_PR,
            PR_ME: PR_ME,
            PR_TR: PR_TR,
            DTE: DTE,
            DE: DE,
            SUPER: SUPER,
            DAM_TR: DAM_TR,
            DAM_PR: DAM_PR,
            DV_PR: DV_PR,
            DV_TR: DV_TR,
            RS: RS,
            TRAIN: TRAIN,
            IMP_TR: IMP_TR,
            IMP_PR: IMP_PR,
            NMP: NMP,
            roleAreaMapper: roleAreaMapper,
            getAreaById: getAreaById,
            showOnImpersonate: showOnImpersonate,
            isEvaluator: isEvaluator,
            getTagsOfRole: getTagsOfRole,
            getSingleTagOfRole: getSingleTagOfRole
        };

        return service;

        //SERVICE FUNCTIONS

        //Returns if given workArea is seen from the impersonator position
        function showOnImpersonate(workArea) {
            return !!_.find(viewableImpersonateRoles, function (n) {
                return workArea.id === n.id;
            });
        }

        //Finds workArea with given id, for finding programatically
        function getAreaById(id) {
            for (var i in service) {
                if (service[i].id === id) {
                    return service[i];
                }
            }
            return -1;
        }

        function getSingleTagOfRole(role, evaluationType) {
            return _.findWhere(roleAreaMapper[role], {'evaluationType': evaluationType}).tag;
        }

        function isEvaluator(workAreaTag) {
            return !!_.find(evaluators, function (n) {
                return workAreaTag === n.tag;
            });
        }

        function getTagsOfRole(role, evaluationType) {
            return _.filter(roleAreaMapper[role], {'evaluationType': evaluationType})
        }

        //GOTO WORKAREA FUNCTIONS

        function getEvaluationForEvaluatee(activeUserContextService, evalType) {
            var user = activeUserContextService.user;
            var context = activeUserContextService.context;
            return evaluationService.getEvaluationForUser(user.id, context.orientation.districtCode, context.orientation.schoolYear, evalType)
                .then(function (evalData) {
                    user.evalData = evalData;
                    context.evaluatee = user;
                    context.evaluatees = null;
                    return evalData.evaluatorId;
                })
                .then(function (id) {
                    if (id != null) {
                        return userService.getUserById(id).then(function (evaluator) {
                            context.evaluator = evaluator;
                        })
                    }
                    else {
                        context.evaluator = null;
                    }
                })
        }

        //Loads evaluator and evaluation for Principal
        function getEvaluationForUserPrincipal(activeUserContextService) {
            activeUserContextService.context.evaluatees = null;
            return getEvaluationForEvaluatee(activeUserContextService, evalP);
        }

        //Loads evaluatee and evaluation for a teacher
        function getEvaluationForUserTeacher(activeUserContextService) {
            activeUserContextService.context.evaluatees = null;
            return getEvaluationForEvaluatee(activeUserContextService, evalT);
        }

        //loads all observable evaluatees for DTE
        function getObserveEvaluateesForDTEEvaluator(activeUserContextService) {
            var user = activeUserContextService.user;
            var context = activeUserContextService.context;
            return userService.getObserveEvaluateesForDTEEvaluator(context.orientation.districtCode, {id: user.id})
                .then(function (evaluatees) {
                    context.evaluatees = evaluatees;
                });
        }

        //when called generates all evaluatees for evaluator
        function getEvaluateesForEvaluatorPR_PR(activeUserContextService) {
            var user = activeUserContextService.user;
            var context = activeUserContextService.context;
            return userService.getEvaluateesForEvaluatorPR_PR({id: user.id}, context.orientation.districtCode, context.orientation.schoolCode)
                .then(function (evaluatees) {
                    context.evaluatees = evaluatees;
                })
        }

        function getEvaluateesForEvaluatorDE_PR(activeUserContextService) {
            var user = activeUserContextService.user;
            var context = activeUserContextService.context;
            return userService.getEvaluateesForEvaluatorDE_PR({id: user.id}, context.orientation.districtCode, context.orientation.schoolCode)
                .then(function (evaluatees) {
                    context.evaluatees = evaluatees;
                })
        }

        function getEvaluateesForEvaluatorPR_TR(activeUserContextService) {
            var user = activeUserContextService.user;
            var context = activeUserContextService.context;
            return userService.getEvaluateesForEvaluatorPR_TR({id: user.id}, context.orientation.districtCode, context.orientation.schoolCode)
                .then(function (evaluatees) {
                    context.evaluatees = evaluatees;
                })
        }

        function impersonatePR(activeUserContextService) {
            var district = activeUserContextService.context.orientation.districtCode;
            var context = activeUserContextService.context;
            context.impersonatees = [];
            return userService.getUsersInRoleAtDistrict(district, enums.Roles.SEDistrictEvaluator)
                .then(function (data) {
                    context.impersonatees = context.impersonatees.concat(data);
                    $modal.open({
                        templateUrl: 'app/layout/views/impersonate-setup-modal.html',
                        controller: 'impersonateSettingsModalController as vm'
                    }).result
                        .then(function (chosenImpersonatee) {
                        })
                });
        }

        function impersonateTR(activeUserContextService) {
            var district = activeUserContextService.context.orientation.districtCode;
            var context = activeUserContextService.context;
            context.impersonatees = [];
            return userService.getPrincipalsInDistrict(district)
                .then(function (data) {
                    context.impersonatees = context.impersonatees.concat(data);
                    return 'EHYE';
                });
        }

        function stopImpersonation() {

        }

        //For workAreas that do not need any information to be loaded
        //Reminder, this service does not have direct access to the ActiveUserContextService
        function noAdditionalInfoWorkArea(activeUserContextService) {
            if (activeUserContextService.context) {
                activeUserContextService.context.evaluatees = null;
            }
            console.log('No special information is loaded for this work area');
            return $q.when();
        }


        //Oversees state change and framework setup
        //thisBinding = current workArea
        function enterWorkArea(activeUserContextService, thisBinding) {
            var user = activeUserContextService.user;
            var context = activeUserContextService.context;
            //if there is a relevant framework to get the assign framework
            if ((thisBinding.isEvaluatorWorkArea())) {
                activeUserContextService.context.evaluator = user;
            }
            if (thisBinding.evaluationType) {
                return frameworkService.getFrameworkContext(thisBinding.evaluationType)
                    .then(function (frameworkContext) {
                        context.frameworkContext = frameworkContext;
                        context.framework = frameworkContext.defaultFramework;
                        context.frameworkContexts.push(frameworkContext);
                    });
            } else {
                return $q.when();
            }
        }

        //CONSTRUCTOR -
        //    each work area gets an additional method called from the change-work-area controller
        //    to initialize the workArea and load appropriate information
        function WorkArea(tag, title, evaluationType, loadInformation, navbar) {
            this.id = nextWorkAreaId++;
            this.tag = tag;
            this.title = title;
            this.evaluationType = evaluationType;
            this.navbar = navbar;
            this.initializeWorkArea = function (activeUserContextService, hasOrientation) {
                var context = activeUserContextService.context;
                var nav = context.navOptions;
                if (hasOrientation) {
                    context.orientation = activeUserContextService.getOrientationWithNav(0, context.orientationOptions, nav);
                } else {
                    context.orientation.workAreaTag = context.navOptions.workAreaTag;
                }
                //todo set evaluatees/ framework/other loaded info to 0 before init WA
                var that = this;
                return enterWorkArea(activeUserContextService, that)
                    .then(function () {
                        return loadInformation(activeUserContextService, that)
                            .then(function () {
                            if (activeUserContextService.context.evaluatees) {
                                activeUserContextService.context.evaluatee = activeUserContextService.context.evaluatees[0];
                            }
                            //return defaultLink || service[context.orientation.workAreaTag].navbar[0].state;
                        });
                    })
                    .then(function () {
                        activeUserContextService.save();
                        $state.go(service[context.orientation.workAreaTag].navbar[0].state, {}, {reload: true});
                        console.log('Initializing Work Area: ', context.orientation.workAreaTag, context);
                    })
            }

        }

        //The specific object that the change-work-area directive uses to create the navbar
        function NavLink(title, state, icon, subLinks) {
            return {
                title: title,
                state: state,
                icon: icon,
                subLinks: subLinks
            }
        }

        // Helpers


        //todo should change the pages that use parameters to take information from the activeUserContextService.context.workArea().evaluationType
        function FrameworkNavLink(evalType) {
            return NavLink('Framework', 'select-framework({evaluationtype: ' + evalType + '})', 'fa fa-list-ul');
        }

        function PromptBankNavLink(evalType) {
            return NavLink('Prompt Bank', 'promptbank({evaluationtype: ' + evalType + '})', 'fa fa-question-circle');
        }

        function AssignmentsNavLink(evalType) {
            return NavLink('Assignments', 'assignments({evaluationtype: ' + evalType + '})', 'fa fa-link');
        }

        function SGGoalsNavLink(evalType) {
            return NavLink('Student Growth Goals', 'setup-student-growth({evaluationtype: ' + evalType + '})', 'fa fa-bar-chart');
        }

        function ResourcesNavLink(evalType) {
            return NavLink('Resources', 'resource-list({evaluationtype: ' + evalType + '})', 'fa fa-list-ol');
        }

        function ReportsNavLink(evalType) {
            return NavLink('Reports', 'reports({evaluationtype: ' + evalType + '})', 'fa fa-table');
        }
    }
})();