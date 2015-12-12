/**
 * Created by anne on 6/29/2015.
 */
/* jshint -W117, -W030 */

describe('userService userIsA', function() {

    var userService, enums,$httpBackend, config;

    beforeEach(function() {
        module('stateeval.core');
    });

    beforeEach(inject(function (_userService_, _$httpBackend_) {
        $httpBackend = _$httpBackend_;
        userService = _userService_;
    }));

    beforeEach(inject(function ($injector) {
        enums = $injector.get('enums');
        config = $injector.get('config');
    }));


    // just need to pass in the minimal user object data {role:..} that is used in userIsA...

    function createUserInRoles(roles) {
        return {
            locationRoles: [
                {
                    roles: roles
                }
            ]
        }
    }

    it('Should be in role', function () {

        var da = createUserInRoles([enums.Roles.SEDistrictAdmin]);
        var tr = createUserInRoles([enums.Roles.SESchoolTeacher]);
        var ad = createUserInRoles([enums.Roles.SESchoolAdmin]);
        var pr = createUserInRoles([enums.Roles.SESchoolPrincipal]);
        var hpr = createUserInRoles([enums.Roles.SESchoolHeadPrincipal]);
        var dte = createUserInRoles([enums.Roles.SEDistrictWideTeacherEvaluator]);
        var de = createUserInRoles([enums.Roles.SEDistrictEvaluator]);
        var dv = createUserInRoles([enums.Roles.SEDistrictViewer]);
        var dam = createUserInRoles([enums.Roles.SEDistrictAssignmentManager]);

        var tr_ad = createUserInRoles([enums.Roles.SESchoolTeacher, enums.Roles.SESchoolAdmin]);
        var pr_ad = createUserInRoles([enums.Roles.SESchoolPrincipal, enums.Roles.SESchoolAdmin]);
        var da_dte = createUserInRoles([enums.Roles.SEDistrictAdmin, enums.Roles.SEDistrictWideTeacherEvaluator]);

        expect(userService.userIsADistrictAdmin(da)).toEqual(true);
        expect(userService.userIsADistrictAdmin(da_dte)).toEqual(true);
        expect(userService.userIsADistrictWideTeacherEvaluator(dte)).toEqual(true);
        expect(userService.userIsADistrictEvaluator(de)).toEqual(true);
        expect(userService.userIsADistrictViewer(dv)).toEqual(true);
        expect(userService.userIsADistrictAssignmentManager(dam)).toEqual(true);

        expect(userService.userIsATeacher(tr)).toEqual(true);
        expect(userService.userIsATeacher(tr_ad)).toEqual(true);

        expect(userService.userIsAPrincipal(pr)).toEqual(true);
        expect(userService.userIsAPrincipal(hpr)).toEqual(true);
        expect(userService.userIsAPrincipal(pr_ad)).toEqual(true);
        
        expect(userService.userIsASchoolAdmin(ad)).toEqual(true);
    });

    it('Should not be in role', function () {

        var da = createUserInRoles([enums.Roles.SEDistrictAdmin]);
        var tr = createUserInRoles([enums.Roles.SESchoolTeacher]);
        var ad = createUserInRoles([enums.Roles.SESchoolAdmin]);
        var pr = createUserInRoles([enums.Roles.SESchoolPrincipal]);
        var hpr = createUserInRoles([enums.Roles.SESchoolHeadPrincipal]);
        var dte = createUserInRoles([enums.Roles.SEDistrictWideTeacherEvaluator]);
        var de = createUserInRoles([enums.Roles.SEDistrictEvaluator]);
        var dv = createUserInRoles([enums.Roles.SEDistrictViewer]);
        var dam = createUserInRoles([enums.Roles.SEDistrictAssignmentManager]);

        var tr_ad = createUserInRoles([enums.Roles.SESchoolTeacher, enums.Roles.SESchoolAdmin]);
        var pr_ad = createUserInRoles([enums.Roles.SESchoolPrincipal, enums.Roles.SESchoolAdmin]);
        var da_dte = createUserInRoles([enums.Roles.SEDistrictAdmin, enums.Roles.SEDistrictWideTeacherEvaluator]);

        expect(userService.userIsADistrictAdmin(ad)).toEqual(false);
        expect(userService.userIsADistrictAdmin(dte)).toEqual(false);
        expect(userService.userIsADistrictAdmin(dv)).toEqual(false);
        expect(userService.userIsADistrictAdmin(dam)).toEqual(false);

        expect(userService.userIsASchoolAdmin(da)).toEqual(false);
        expect(userService.userIsAHeadPrincipal(pr)).toEqual(false);
        expect(userService.userIsAHeadPrincipal(dte)).toEqual(false);
        expect(userService.userIsADistrictEvaluator(pr)).toEqual(false);
    });
});

describe('userService getUserById', function() {

     var userService, $httpBackend, config;

     beforeEach(function() {
        module('stateeval.core');
     });

     beforeEach(inject(function (_userService_, _$httpBackend_) {
         $httpBackend = _$httpBackend_;
         userService = _userService_;
     }));

     beforeEach(inject(function ($injector) {
        config = $injector.get('config');
     }));

    it('getUserById should exist', function () {
        expect(userService.getUserById).toBeDefined();
    });

    it('should hits /users/1 address', function () {
        $httpBackend.when('GET', config.apiUrl + '/users/1').respond(200, {});
        userService.getUserById(1).then(function (data) {
            expect(data).toBeDefined();
        });
        $httpBackend.flush();
    });

    it('should report an error if server Internal Server Error', function () {
        $httpBackend
            .when('GET', config.apiUrl + '/users/1')
            .respond(500, {message: 'you failed', messageDetail: 'the details'});
        userService.getUserById(1).catch(function (message) {
            expect(message.data.message).toMatch(/you failed/);
        });
        $httpBackend.flush();
    });
});
