/**
 * Created by anne on 10/5/2015.
 */

(function () {
    'use strict';

    angular
        .module('stateeval.assignments')
        .factory('assignmentsModel', assignmentsModel);

    assignmentsModel.$inject = ['activeUserContextService', 'enums', 'userService', 'utils',
        'locationService', 'assignmentsService', '$q', '$sce', '$modal'];
    function assignmentsModel(activeUserContextService, enums, userService, utils,
        locationService, assignmentsService, $q, $sce, $modal) {

        var modalInstance = null;

        var service = {
            activate: activate,
            model: {
                schools : [],
                evaluatees : [],
                principals : [],
                districtWideTeacherEvaluators : [],
                delegates : [],
                dteAssignmentRequests : [],
                acceptedDTEAssignmentRequests : [],
                assignedEvaluators : [],
                evaluatorOptionsForEvaluatee : [],
                planTypes : [],
                frameworkNodes : [],
                sgFrameworkNodes : [],
                focusDisplayStrings : [],
                headPrincipals : [],
                districtEvaluators : [],
                schoolCode : '',
                districtCode : '',
                userIsSchoolAdmin : false,
                assignmentGridIsReadOnly : false,
                dteGridIsReadOnly : false,
                evaluationType : null,
                evaluateeTerm : '',

                changeSchool: changeSchool,
                toggleDelegate: toggleDelegate,
                loadTeachers: loadTeachers,
                evaluatorDisplayName: evaluatorDisplayName,
                planTypeDisplayString: planTypeDisplayString,
                setComprehensivePlanType: setComprehensivePlanType,
                setFocusedPlanType: setFocusedPlanType,
                getSafeHtml: utils.getSafeHtml,
                modifyFocus: modifyFocus,
                assignEvaluator: assignEvaluator,
                getFocusDisplayString: getFocusDisplayString,
                requestTypeDisplayString: requestTypeDisplayString,
                changeRequestStatus: changeRequestStatus,
                changeRequestType: changeRequestType
            }
        }

        return service;


        function init() {
            service.model.schools = [];
            service.model.evaluatees = [];
            service.model.principals = [];
            service.model.districtWideTeacherEvaluators = [];
            service.model.delegates = [];
            service.model.dteAssignmentRequests = [];
            service.model.acceptedDTEAssignmentRequests = [];
            service.model.assignedEvaluators = [];
            service.model.evaluatorOptionsForEvaluatee = [];
            service.model.planTypes = [];
            service.model.frameworkNodes = [];
            service.model.sgFrameworkNodes = [];
            service.model.focusDisplayStrings = [];
            service.model.headPrincipals = [];
            service.model.districtEvaluators = [];
            service.model.schoolCode = '';
            service.model.districtCode = '';
            service.model.userIsSchoolAdmin = false;
            service.model.assignmentGridIsReadOnly = false;
            service.model.dteGridIsReadOnly = false;
            service.model.evaluationType = null;
            service.model.evaluateeTerm = '';
        }

        function activate(evalType) {

            init();

            service.model.evaluationType = evalType;
            var workAreaTag = activeUserContextService.context.orientation.workAreaTag;
            service.model.userIsSchoolAdmin = (workAreaTag === 'SA');
            service.model.dteGridIsReadOnly = service.model.userIsSchoolAdmin;

            if (service.model.evaluationType === enums.EvaluationType.PRINCIPAL && service.model.userIsSchoolAdmin) {
                service.model.assignmentGridIsReadOnly = true;
            }

            service.model.evaluateeTerm = utils.getEvaluateeTermUpperCase(service.model.evaluationType);
            service.model.districtCode = activeUserContextService.getActiveDistrictCode();

            if (service.model.evaluationType === enums.EvaluationType.PRINCIPAL) {
                return activatePrincipalAssignments();
            }
            else {
                return activateTeacherAssignments();
            }
        }

        function evaluatorDisplayName(evaluatee) {
            var evaluatorId = evaluatee.evalData.evaluatorId;
            var currentUser = activeUserContextService.getActiveUser();
            if (evaluatorId === null) {
                return $sce.trustAsHtml('<span class="label label-warning">NOT SET</span>');
            }
            else {
                var evaluator = service.model.assignedEvaluators[evaluatee.id];
                if (evaluator) {
                    return $sce.trustAsHtml(evaluator.displayName);
                }
                else {
                    return $sce.trustAsHtml('not found')
                }
            }
        }

        function planTypeDisplayString(evaluatee) {
            var retval = utils.mapEvaluationPlanTypeToString(evaluatee.evalData.planType);

            if (service.model.planTypes[evaluatee.id] === enums.EvaluationPlanType.FOCUSED) {
                retval+= (' ' + utils.mapEvaluationFocusForUserToString(activeUserContextService, evaluatee));
            }

            return retval;
        }

        function toggleDelegate() {
            assignmentsService.toggleDelegate(service.model.schoolCode, service.model.delegates[service.model.schoolCode]);
        }

        function changeSchool() {

            setupDTEAssignmentRequestsForSchool()
                .then(function() {
                    return setDelegateStatusForSchool();
                })
                .then(function() {
                    loadTeachers();
                })
        }

        function getSchools() {
            if (service.model.userIsSchoolAdmin) {
                service.model.schoolCode = activeUserContextService.getActiveSchoolCode();
                return $q.when(true);
            }
            else {
                return locationService.getSchoolsInDistrict(service.model.districtCode)
                    .then(function (data) {
                        service.model.schools = data;
                        service.model.schoolCode = service.model.schools[0].schoolCode;
                    })
            }
        }

        function activateTeacherAssignments() {
            return getSchools()
                .then(function () {
                    return setDelegateStatusForSchool();
                })
                .then(function () {
                    return userService.getPrincipalsInDistrict(activeUserContextService.getActiveDistrictCode());
                })
                .then(function (data) {
                    service.model.principals = data;
                    return userService.getUsersInRoleAtDistrict(service.model.districtCode, enums.Roles.SEDistrictWideTeacherEvaluator);
                })
                .then(function (data) {
                    service.model.districtWideTeacherEvaluators = data;
                    return setupDTEAssignmentRequestsForSchool();
                })
                .then(function () {
                    return loadTeachers();
                })
        }

        function activatePrincipalAssignments() {
            return assignmentsService.getPrincipalsForAssignment(service.model.districtCode)
                .then(function(principals) {
                    service.model.evaluatees = principals;
                    service.model.evaluatees.forEach(function(principal) {
                        if (principalIsAHeadPrincipal(principal)) {
                            service.model.headPrincipals.push(principal);
                        }
                    })
                })
                .then(function() {
                    return userService.getUsersInRoleAtDistrict(activeUserContextService.getActiveDistrictCode(), enums.Roles.SEDistrictEvaluator)
                        .then(function(data) {

                            service.model.districtEvaluators = data;

                            service.model.evaluatees.forEach(function(principal) {
                                service.model.evaluatorOptionsForEvaluatee[principal.id] = [];
                                Array.prototype.push.apply(service.model.evaluatorOptionsForEvaluatee[principal.id], service.model.districtEvaluators);
                                var headPrincipals = findHeadPrincipalsForPrincipal(principal);
                                Array.prototype.push.apply(service.model.evaluatorOptionsForEvaluatee[principal.id], service.model.headPrincipals);
                                setupAssignedEvaluatorAndPlanTypes(principal);
                            })
                        })
                        .then(function() {
                            setFocusDisplayStrings(enums.EvaluationType.PRINCIPAL);
                        })
                })
        }

        function loadTeachers() {
            return assignmentsService.getTeachersForAssignment(service.model.districtCode, service.model.schoolCode)
                .then(function(teachers) {
                    service.model.evaluatees = teachers;

                    service.model.evaluatees.forEach(function(teacher) {
                        service.model.evaluatorOptionsForEvaluatee[teacher.id] = [];
                        var dte = findDTEForTeacher(teacher);
                        if (dte) {
                            service.model.evaluatorOptionsForEvaluatee[teacher.id].push(dte);
                        }
                        else {
                            var principals = findPrincipalsThatCanEvaluateTeacher(teacher);
                            Array.prototype.push.apply(service.model.evaluatorOptionsForEvaluatee[teacher.id], principals);
                        }
                        setupAssignedEvaluatorAndPlanTypes(teacher);
                        setFocusDisplayStrings(enums.EvaluationType.TEACHER);
                    });
                })
        }

        function setDelegateStatusForSchool() {
            return assignmentsService.districtDelegatedTeacherAssignmentsForSchool(service.model.schoolCode)
                .then(function(delegate) {
                    service.model.delegates[service.model.schoolCode] = delegate;
                    service.model.assignmentGridIsReadOnly = !delegate && service.model.userIsSchoolAdmin;
                })
        }

        function setupDTEAssignmentRequestsForSchool() {
            return assignmentsService.getDTEAssignmentRequestsForSchool(service.model.schoolCode)
                .then(function(requests) {
                    service.model.dteAssignmentRequests = requests;
                    service.model.dteAssignmentRequests.forEach(function (request) {
                        request.statusAsString = request.evalRequestStatus.toString();
                        request.typeAsString = request.evalRequestType.toString();

                        if (request.evalRequestStatus == enums.EvalAssignmentRequestStatus.ACCEPTED) {
                            service.model.acceptedDTEAssignmentRequests.push(request);
                        }
                    })
                });
        }

        function setFocusDisplayStrings(evalType) {
            service.model.frameworkNodes = activeUserContextService.getFrameworkContext().stateFramework.frameworkNodes;
            service.model.sgFrameworkNodes = activeUserContextService.getFrameworkContext().studentGrowthFrameworkNodes;
            if (evalType === enums.EvaluationType.TEACHER) {
                service.model.sgFrameworkNodes = _.reject(service.model.sgFrameworkNodes, {'shortName': 'C8'});
            }
            service.model.evaluatees.forEach(function(evaluatee) {
                if (evaluatee.evalData.planType === enums.EvaluationPlanType.FOCUSED) {
                    service.model.focusDisplayStrings[evaluatee.id] = buildFocusDisplayString(evaluatee);
                }
            });
        }

        function setupAssignedEvaluatorAndPlanTypes(evaluatee) {
            if (evaluatee.evalData.evaluatorId!=null) {
                for (var i=0; i<service.model.evaluatorOptionsForEvaluatee[evaluatee.id].length; ++i) {
                    var evaluator = service.model.evaluatorOptionsForEvaluatee[evaluatee.id][i];
                    if (evaluatee.evalData.evaluatorId === evaluator.id) {
                        service.model.assignedEvaluators[evaluatee.id] = evaluator;
                        break;
                    }
                }
                if (evaluatee.evalData.planType!==null) {
                    service.model.planTypes[evaluatee.id] = evaluatee.evalData.planType;
                }
            }
        }

        function buildFocusDisplayString(evaluatee) {
            var focusFrameworkNode = findFrameworkNode(evaluatee.evalData.focusFrameworkNodeId);
            var sgFocusFrameworkNode = findSGFrameworkNode(evaluatee.evalData.focusSGFrameworkNodeId);

            var displayString = '<label>Focus:</label>';
            displayString+=(focusFrameworkNode.shortName);
            if (sgFocusFrameworkNode != null) {
                displayString+=('&nbsp;&nbsp;<label>Student Growth:</label>');
                displayString+=(sgFocusFrameworkNode.shortName);
            }
            return displayString;
        }

        function principalIsAHeadPrincipal(principal) {
            for (var i=0;i<principal.locationRoles.length; ++i) {
                var isHeadPrincipalAtLocation =
                    principal.locationRoles[i].roles.indexOf(enums.Roles.SESchoolHeadPrincipal) != -1;
                if (isHeadPrincipalAtLocation) {
                    return true;
                }
            }

            return false;
        }

        function findHeadPrincipalsForPrincipal(principal) {
            var matches = [];
            principal.locationRoles.forEach(function(locationRole) {
                service.model.headPrincipals.forEach(function(headPrincipal) {
                    var match = _.findWhere(headPrincipal.locationRoles, {schoolCode: locationRole.schoolCode});
                    var isHeadPrincipalAtLocation = locationRole.roles.indexOf(enums.Roles.SESchoolHeadPrincipal) != -1;
                    if (match && !isHeadPrincipalAtLocation) {
                        matches.push(headPrincipal);
                    }
                })
            });

            return matches;
        }

        function findSGFrameworkNode(id) {
            return _.findWhere(service.model.sgFrameworkNodes, {id: id});
        }

        function findFrameworkNode(id) {
            return _.findWhere(service.model.frameworkNodes, {id: id});
        }

        function findDTEForTeacher(teacher) {
            return _.findWhere(service.model.districtWideTeacherEvaluators, {id: teacher.evalData.evaluatorId});
        }

        function findPrincipalsThatCanEvaluateTeacher(teacher) {
            var principalsList = [];
            teacher.locationRoles.forEach(function(locationRole) {
                service.model.principals.forEach(function(principal) {
                    var match = _.findWhere(principal.locationRoles, {schoolCode: locationRole.schoolCode});
                    if (match) {
                        match = _.findWhere(principalsList, {id: principal.id});
                        if (!match) {
                            principalsList.push(principal);
                        }
                    }
                })
            });

            return principalsList;
        }

        function requestStatus(request) {
            return utils.mapEvalRequestStatusToString(request.evalRequestStatus);
        }

        function getFocusDisplayString(evaluatee) {
            return utils.getSafeHtml(service.model.focusDisplayStrings[evaluatee.id]);
        }

        function requestTypeDisplayString(request) {
            return utils.mapEvalRequestTypeToString(request.evalRequestType);
        }

        function setComprehensivePlanType(evaluatee) {
            service.model.planTypes[evaluatee.id] = 1;
            assignmentsService.assignComprehensiveEvaluateePlanType(evaluatee)
                .then(function() {
                    evaluatee.evalData.planType = enums.EvaluationPlanType.COMPREHENSIVE;
                    evaluatee.evalData.focusFrameworkNodeId = null;
                    evaluatee.evalData.focusSGFrameworkNodeId = null;
                })
        }

        function setFocusedPlanType(evaluatee) {
            return openSelectFocusModal(evaluatee);
        }

        function assignEvaluator(evaluatee) {
            return assignmentsService.assignEvaluator(evaluatee, service.model.assignedEvaluators[evaluatee.id]);
        }

        function modifyFocus(evaluatee) {
            openSelectFocusModal(evaluatee);
        }

        function changeRequestStatus(request) {
            request.evalRequestStatus = parseInt(request.statusAsString);
            request.evalRequestType = parseInt(request.typeAsString);
            assignmentsService.updateDTEAssignmentRequest(request).then(function() {
                loadTeachers();
            })
        }

        function changeRequestType(request) {
            request.evalRequestStatus = parseInt(request.statusAsString);
            request.evalRequestType = parseInt(request.typeAsString);
            assignmentsService.updateDTEAssignmentRequest(request).then(function() {
                loadTeachers();
            })
        }

        function openSelectFocusModal(evaluatee) {

            modalInstance = $modal.open({
                animation: false,
                templateUrl: 'app/assignments/views/select-focus-modal.html',
                controller: 'selectFocusModalController as vm',
                size: 'lg',
                resolve: {
                    evaluatee: function () {
                        return evaluatee;
                    }
                }
            });

            modalInstance.result.then(function (result) {
                service.model.planTypes[result.evaluatee.id] = enums.EvaluationPlanType.FOCUSED;
                service.model.focusDisplayStrings[result.evaluatee.id] = result.focusDisplayString;
                assignmentsService.assignFocusedEvaluateePlanType(result.evaluatee, result.focusFrameworkNodeId, result.sgFocusFrameworkNodeId)
                    .then(function() {
                        result.evaluatee.evalData.planType = enums.EvaluationPlanType.FOCUSED;
                        result.evaluatee.evalData.focusFrameworkNodeId = result.focusFrameworkNodeId;
                        result.evaluatee.evalData.focusSGFrameworkNodeId = result.sgFocusFrameworkNodeId;
                    })
            });
        }
    }

})();
