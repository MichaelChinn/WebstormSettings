/**
 * Created by anne on 6/26/2015.
 */

(function () {

    angular
        .module('stateeval.core')
        .factory('activeUserContextService', activeUserContextService);

    activeUserContextService.$inject = ['$q', '_', 'enums', 'config', 'localStorageService', '$state',
        'utils', '$rootScope', '$sce'];

    /* @ngInject */
    function activeUserContextService($q, _, enums, config, localStorageService, $state,
                  utils, $rootScope, $sce) {


        var service = {
            //All fields on the user and context objects can be directly accessed and modified in other services
            //or controllers, setting anything directly with user= or context= will create a new object unbinding
            //the other services and controllers from the activeUserContextService
            save: save,

            getActiveUser: getActiveUser,
            getActiveEvaluatee: getActiveEvaluatee,
            getEvaluateesForActiveUser: getEvaluateesForActiveUser,
            currentUserIsEvaluating: currentUserIsEvaluating,
            getShowAssignedEvaluateesOnly: getShowAssignedEvaluateesOnly,
            setShowAssignedEvaluateesOnly: setShowAssignedEvaluateesOnly,

            getEvaluatorDisplayName: getEvaluatorDisplayName,

            getActiveEvaluationType: getActiveEvaluationType,
            getActiveDistrictCode: getActiveDistrictCode,
            getActiveSchoolCode: getActiveSchoolCode,
            getActiveDistrictName: getActiveDistrictName,
            getActiveSchoolName: getActiveSchoolName,

            getFrameworkContext: getFrameworkContext,

            getActiveFramework: getActiveFramework,

            setActiveFramework: setActiveFramework,

            // utilities
            getRolesDisplayStringForActiveUser: getRolesDisplayStringForActiveUser,
            getRolesDisplayStringForLoggedInUser: getRolesDisplayStringForLoggedInUser,
            getEvaluateeTermUpperCase: getEvaluateeTermUpperCase,
            getEvaluateeTermLowerCase: getEvaluateeTermLowerCase,

            getImpersonatedUser: getImpersonatedUser,
            getLoggedInUser: getLoggedInUser,

            clear: clear,
            selfPrint: selfPrint,
            getOrientationWithNav: getOrientationWithNav
        };

        service.user = {};
        service.context = {};

        return service;
        function selfPrint() {
            console.log(service.context);
        }


        //user: {
        //        NOT KEEPING LOCATION ROLES OR HAS MULTIPLE BUILDINGS
        //        id,
        //        firstName,
        //        lastName,
        //        displayName,
        //        evaluationId,
        //        schoolCode,
        //        schoolName,
        //        districtCode,
        //        districtName,
        //        role,
        //        evalData
        //},
        //context = {
        //    orientationOptions: { -
        //        years: {,
        //          districtCode: {
        //              schools: {
        //                  roles: {
        //                      workAreaTitle: {
        //                          workAreaTag,
        //                          schoolName,
        //                          schoolCode,
        //                          districtName,
        //                          districtCode,
        //                          roleName,
        //                          schoolYear
        //    },
        //    orientation = current low branch of orientation options, updated once per change work area
        //    frameworkContext: {} - resultingObject from frameworkService.getFrameworkContext()
        //    framework - set to frameworkContext.defaultFramework
        //    frameworkContexts: [] - holds on to a list of used frameworks
        //    evaluator
        //    evaluatee
        //    evalutees,
        //}
        //Context.prototype {
        //    workArea(),
        //    isEvaluating,
        //    isEvaluator,
        //}


        function getOrientationWithNav(index, current, navObj) {
            var nextDown = current[navObj[enums.Order[index]]];
            if(enums.Order[index + 1]) {
                return getOrientationWithNav(index + 1, nextDown, navObj)
            } else {
                return current[navObj[enums.Order[index]]];
            }
        }

        function getActiveEvaluatee() {
            return service.context.evaluatee;
        }

        function getActiveUser() {
            return service.user
        }

        function getLoggedInUser() {
            return service.user;
        }

        function getActiveDistrictName() {
            return service.context.orientation.districtName;
        }

        function getActiveSchoolName() {
            return service.context.orientation.schoolName;
        }


        function getActiveFramework() {
            return service.context.framework;
        }

        function setActiveFramework(framework) {
            service.context.framework = framework;
            console.log('Changing framework', framework);
            $rootScope.$broadcast('change-framework');
            save();
        }


        //TODO find where is being used and fix this!
        
        function setShowAssignedEvaluateesOnly(val) {
            console.log('set assigned evaluatee only');
            //activeUserContext.showAssignedEvaluateesOnly = val;
        }

        function getShowAssignedEvaluateesOnly() {
            return true;
            //return activeUserContext.showAssignedEvaluateesOnly;
        }

        //clears all context and user info by property iteration
        function clear() {
            localStorageService.set('context', null);
            localStorageService.set('user', null);
            for (var i in service.context) {
                delete service.context[i];
            }
            for (var i in service.user) {
                delete service.user[i];
            }
        }

        //Saves to local storage (user, context)
        function save() {
            localStorageService.set('context', service.context);
            localStorageService.set('user', service.user);

        }

        function getImpersonatedUser() {
            return service.user.impersonatedUser;
        }


        function getActiveEvaluationType() {
            return service.context.workArea().evaluationType;
        }

        function getActiveDistrictCode() {
            return service.context.orientation.districtCode;
        }

        function getActiveSchoolCode() {
            return service.context.orientation.schoolCode;
        }

        function getEvaluateesForActiveUser() {
            return service.context.evaluatees;
        }

        function getEvaluatorDisplayName() {
            if (service.context.evaluator === null) {
                return $sce.trustAsHtml('<span class="label label-warning">NOT SET</span>');
            }
            else {
                return $sce.trustAsHtml(service.context.evaluator.displayName);
            }
        }

        //todo have not handled case to look at assigned only evaluatees


        function currentUserIsEvaluating() {
            return service.context.workArea().isEvaluatorWorkArea();
        }

        function getFrameworkContext() {
            return service.context.frameworkContext;
        }

        function getRolesDisplayStringForActiveUser() {
            return utils.mapRoleNameToFriendlyName(service.context.orientation.role);
        }

        function getRolesDisplayStringForLoggedInUser() {
            //todo: should be logged in user
            return utils.mapRoleNameToFriendlyName(service.context.orientation.role);
        }

        function getEvaluateeTermLowerCase() {
            return utils.getEvaluateeTermLowerCase(service.context.workArea().evaluationType);
        }

        function getEvaluateeTermUpperCase() {
            return utils.getEvaluateeTermUpperCase(service.context.workArea().evaluationType);
        }
    }
})
();

