
(function () {
    'use strict';

    angular
        .module('stateeval.assignments')
        .controller('dteRequestAssignmentController', dteRequestAssignmentController);

    dteRequestAssignmentController.$inject = ['assignmentsService', 'userService', 'activeUserContextService', 'enums',
        '$modal', 'utils', '$stateParams', 'locationService'];

    /* @ngInject */
    function dteRequestAssignmentController(assignmentsService, userService, activeUserContextService, enums,
                                   $modal, utils, $stateParams, locationService) {

        var vm = this;
        vm.districtCode = '';
        vm.teacherSearchInput = '';

        vm.requests = [];
        vm.teachers = [];
        vm.schools = [];
        vm.schoolCode = '';
        vm.currentUser = null;

        vm.changeSchool = changeSchool;
        vm.createRequest = createRequest;
        vm.requestSchools = requestSchools;
        vm.requestStatus = requestStatus;
        vm.requestType = requestType;
        vm.removeRequest = removeRequest;

      ////////////////////////////

        activate();

        function activate() {
            vm.districtCode = activeUserContextService.getActiveDistrictCode();
            vm.currentUser = activeUserContextService.getActiveUser();

            locationService.getSchoolsInDistrict(vm.districtCode)
                .then(function(schools) {
                    vm.schools = schools;
                    vm.schoolCode = schools[0].schoolCode;
                    loadRequests();
                })
        }

        function removeRequest(request) {
            assignmentsService.deleteDTEAssignmentRequest(request).then(function() {
                vm.requests = _.reject(vm.requests, {id: request.id});
                loadTeachers();
            })
        }

        function requestStatus(request) {
           return utils.mapEvalRequestStatusToString(request.evalRequestStatus);
        }

        function requestType(request) {
            if (request.evalRequestStatus === enums.EvalAssignmentRequestStatus.PENDING) {
                return "PENDING";
            }
            else {
                return utils.mapEvalRequestTypeToString(request.evalRequestType);
            }
        }

        function requestSchools(request) {
            // todo: request.teacher doesn't exist now, but we need a way to get teacher
            // return _.pluck(request.teacher.locationRoles, 'schoolName').join(', ');
        }

        function loadRequests() {
            assignmentsService.getDTEAssignmentRequestsForDTE(vm.currentUser).then(function(requests) {
                vm.requests = requests;
                loadTeachers();
            });
        }
        function loadTeachers() {
            vm.teachers = [];
            userService.getUsersInRoleAtSchool(vm.districtCode, vm.schoolCode, enums.Roles.SESchoolTeacher)
                .then(function(teachers) {
                    teachers.forEach(function(teacher) {
                        if (!_.findWhere(vm.requests, {evaluateeId: teacher.id})) {
                            vm.teachers.push(teacher);
                        }
                    })
                })
        }

        function changeSchool() {
           loadTeachers();
        }

        function createRequest(teacher) {
            assignmentsService.createDTEAssignmentRequest(vm.currentUser, teacher).then(function() {
                loadRequests();
            })
        }
    }

})();

