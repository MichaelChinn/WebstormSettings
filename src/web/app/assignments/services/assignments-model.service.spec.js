/**
 * Created by anne on 10/5/2015.
 */
describe('DA teacher assignments', function() {

    beforeEach(function() {
        bard.appModule('stateeval.assignments');

        bard.inject('assignmentsModel', '$httpBackend', 'config', 'enums','$state',
            'authenticationService', 'activeUserContextService', 'locationService',
            'assignmentsService', 'userService', '$q', '$rootScope');

        spyOn(activeUserContextService, "getActiveUser").and.callFake(function() {
            return TestHelper.DefaultDA;
        });

        spyOn(activeUserContextService, "getActiveDistrictCode").and.callFake(function() {
            return TestHelper.DistrictCodes.NorthThurston;
        });

        spyOn(activeUserContextService, "getFrameworkContext").and.callFake(function() {
            return TestHelper.TR_FrameworkContext;
        });

        spyOn(locationService, "getSchoolsInDistrict").and.callFake(function() {
            return $q.when(TestHelper.SchoolsInDistrict);
        });

        spyOn(assignmentsService, "districtDelegatedTeacherAssignmentsForSchool").and.callFake(function() {
            return $q.when(false);
        });

        spyOn(assignmentsService, "getDTEAssignmentRequestsForSchool").and.callFake(function() {
            return $q.when(TestHelper.DTEAssignmentRequests);
        });

        spyOn(assignmentsService, "getTeachersForAssignment").and.callFake(function() {
            return $q.when(TestHelper.Teachers);
        });

        spyOn(assignmentsService, "assignEvaluator").and.callFake(function() {
            return $q.when(true);
        });

        spyOn(assignmentsService, "updateDTEAssignmentRequest").and.callFake(function() {
            return $q.when(true);
        });

        spyOn(assignmentsService, "assignComprehensiveEvaluateePlanType").and.callFake(function() {
            return $q.when(true);
        });

        spyOn(userService, "getPrincipalsInDistrict").and.callFake(function() {
            return $q.when(TestHelper.Principals);
        });

        spyOn(userService, "getUsersInRoleAtDistrict").and.callFake(function() {
            return $q.when(TestHelper.DistrictWideTeacherEvaluators);
        });

        //spyOn($state, 'go');
    });

    afterEach(function () {
    });

    it('ensure grids are editable', function (done) {

        assignmentsModel.activate(enums.EvaluationType.TEACHER)
           .then(function() {
               var model = assignmentsModel.getModel();
               expect(model.assignmentGridIsReadOnly).toEqual(false);
               expect(model.dteGridIsReadOnly).toEqual(false);
           }, done.fail)
            .then(done, done.fail);

        $rootScope.$digest();
    });

    it('ensure userIsSchoolAdmin is false', function (done) {

        assignmentsModel.activate(enums.EvaluationType.TEACHER)
            .then(function() {
                var model = assignmentsModel.getModel();
                expect(model.userIsSchoolAdmin).toEqual(false);
            }, done.fail)
            .then(done, done.fail);

        $rootScope.$digest();
    });

    it('ensure retrieve schools in district and sets default school', function (done) {

        assignmentsModel.activate(enums.EvaluationType.TEACHER)
            .then(function() {
                var model = assignmentsModel.getModel();
                expect(model.schools.length).toBeGreaterThan(1);
                expect(model.schoolCode).not.toEqual('');
            }, done.fail)
            .then(done, done.fail);

        $rootScope.$digest();
    });

    it('ensure initial lists populated', function (done) {

        assignmentsModel.activate(enums.EvaluationType.TEACHER)
            .then(function() {
                var model = assignmentsModel.getModel();
                expect(model.evaluatees.length).toBeGreaterThan(0);
                expect(model.principals.length).toBeGreaterThan(0);
                expect(model.districtWideTeacherEvaluators.length).toBeGreaterThan(0);
                expect(model.delegates[model.schoolCode]).toBeDefined();
                expect(model.dteAssignmentRequests.length).toBeGreaterThan(0);
                expect(model.acceptedDTEAssignmentRequests.length).toEqual(0);
                expect(model.evaluatorOptionsForEvaluatee.length).toBeGreaterThan(0);
            }, done.fail)
            .then(done, done.fail);

        $rootScope.$digest();
    });

    it('ensure assignedEvaluators populated', function (done) {

        assignmentsModel.activate(enums.EvaluationType.TEACHER)
            .then(function() {
                var model = assignmentsModel.getModel();
                model.evaluatees.forEach(function(evaluatee) {
                    expect(model.assignedEvaluators[evaluatee.id]).toBeDefined();
                })
            }, done.fail)
            .then(done, done.fail);

        $rootScope.$digest();
    });

    it('ensure evaluatorOptionsForEvaluatee populated', function (done) {

        assignmentsModel.activate(enums.EvaluationType.TEACHER)
            .then(function() {
                var model = assignmentsModel.getModel();
                model.evaluatees.forEach(function(evaluatee) {
                    expect(model.evaluatorOptionsForEvaluatee[evaluatee.id]).toBeDefined();
                })
            }, done.fail)
            .then(done, done.fail);

        $rootScope.$digest();
    });

    it('ensure planTypes populated', function (done) {

        assignmentsModel.activate(enums.EvaluationType.TEACHER)
            .then(function() {
                var model = assignmentsModel.getModel();
                model.evaluatees.forEach(function(evaluatee) {
                    expect(model.planTypes[evaluatee.id]).toBeDefined();
                })
            }, done.fail)
            .then(done, done.fail);

        $rootScope.$digest();
    });

    it('ensure assignEvaluator calls assignmentsService.assigneEvaluator', function (done) {

        assignmentsModel.activate(enums.EvaluationType.TEACHER)
            .then(function() {
                var model = assignmentsModel.getModel();
                model.assignEvaluator((model.evaluatees[0])).then(function() {
                    expect(assignmentsService.assignEvaluator).toHaveBeenCalled();
                })
            }, done.fail)
            .then(done, done.fail);

        $rootScope.$digest();
    });


    it('ensure changesSchools calls expected assignmentsService functions', function (done) {

        assignmentsModel.activate(enums.EvaluationType.TEACHER)
            .then(function() {
                var model = assignmentsModel.getModel();
                model.assignEvaluator((model.evaluatees[0])).then(function() {
                    expect(assignmentsService.getDTEAssignmentRequestsForSchool).toHaveBeenCalled();
                    expect(assignmentsService.districtDelegatedTeacherAssignmentsForSchool).toHaveBeenCalled();
                    expect(assignmentsService.getTeachersForAssignment).toHaveBeenCalled();
                })
            }, done.fail)
            .then(done, done.fail);

        $rootScope.$digest();
    });

    it('ensure setComprehensivePlanType calls expected assignmentsService.assignComprehensiveEvaluateePlanType', function (done) {

        assignmentsModel.activate(enums.EvaluationType.TEACHER)
            .then(function() {
                var model = assignmentsModel.getModel();
                model.setComprehensivePlanType((model.evaluatees[0])).then(function() {
                    expect(assignmentsService.assignComprehensiveEvaluateePlanType).toHaveBeenCalled();
                })
            }, done.fail)
            .then(done, done.fail);

        $rootScope.$digest();
    });

    it('ensure setComprehensivePlanType COMPREHENSIVE sets evaluatee state', function (done) {

        assignmentsModel.activate(enums.EvaluationType.TEACHER)
            .then(function() {
                var model = assignmentsModel.getModel();
                model.setFocusedPlanType((model.evaluatees[0])).then(function() {
                    expect(model.evaluatees[0].evalData.planType).toEqual(enums.EvaluationPlanType.COMPREHENSIVE);
                    expect(model.evaluatees[0].evalData.focusFrameworkNodeId).not.toBeDefined();
                    expect(model.evaluatees[0].evalData.focusSGFrameworkNodeId).not.toBeDefined();
                })
            }, done.fail)
            .then(done, done.fail);

        $rootScope.$digest();
    });

    it('ensure setComprehensivePlanType FOCUSED sets evaluatee state', function (done) {

        assignmentsModel.activate(enums.EvaluationType.TEACHER)
            .then(function() {
                var model = assignmentsModel.getModel();
                model.setFocusedPlanType((model.evaluatees[0])).then(function() {
                    expect(model.evaluatees[0].evalData.planType).toEqual(enums.EvaluationPlanType.FOCUSED);
                    expect(model.evaluatees[0].evalData.focusFrameworkNodeId).toBeDefined();
                    expect(model.evaluatees[0].evalData.focusSGFrameworkNodeId).toBeDefined();
                })
            }, done.fail)
            .then(done, done.fail);

        $rootScope.$digest();
    });

    it('ensure changeRequestStatus calls assignmentService.updateDTEAssignmentRequest', function (done) {

        assignmentsModel.activate(enums.EvaluationType.TEACHER)
            .then(function() {
                var model = assignmentsModel.getModel();
                model.changeRequestStatus(model.dteAssignmentRequests[0]).then(function() {
                    expect(assignmentsService.updateDTEAssignmentRequest).toHaveBeenCalled();
                })
            }, done.fail)
            .then(done, done.fail);

        $rootScope.$digest();
    });

    it('ensure changeRequestType calls assignmentService.updateDTEAssignmentRequest', function (done) {

        assignmentsModel.activate(enums.EvaluationType.TEACHER)
            .then(function() {
                var model = assignmentsModel.getModel();
                model.changeRequestType(model.dteAssignmentRequests[0]).then(function() {
                    expect(assignmentsService.updateDTEAssignmentRequest).toHaveBeenCalled();
                })
            }, done.fail)
            .then(done, done.fail);

        $rootScope.$digest();
    });

});

