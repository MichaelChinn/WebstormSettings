/**
 * Created by anne on 6/26/2015.
 */

(function() {

    angular
        .module('stateeval.core')
        .factory('userService', userService);

    userService.$inject = ['enums', '$http', 'config', 'activeUserContextService'];

    /* @ngInject */
    function userService(enums, $http, config, activeUserContextService) {

        var service = {
            getUserById: getUserById,
            getEvaluateesForEvaluatorPR_PR: getEvaluateesForEvaluatorPR_PR,
            getEvaluateesForEvaluatorPR_TR: getEvaluateesForEvaluatorPR_TR,
            getEvaluateesForEvaluatorPR_LIB: getEvaluateesForEvaluatorPR_LIB,
            getEvaluateesForEvaluatorDE_PR: getEvaluateesForEvaluatorDE_PR,
            getObserveEvaluateesForDTEEvaluator: getObserveEvaluateesForDTEEvaluator,
            getPrincipalsInDistrict: getPrincipalsInDistrict,
            getTeachersInDistrict: getTeachersInDistrict,
            getUsersInRoleAtSchool: getUsersInRoleAtSchool,
            getUsersInRoleAtDistrict: getUsersInRoleAtDistrict
        };

        return service;

        ////////////////

        function getUserById(userId) {
            return $http.get(config.apiUrl + '/users/' + userId)
                .then(function(response) {
                    return response.data;
                })
        }

        function getObserveEvaluateesForDTEEvaluator(districtCode, evaluator) {
            var url = config.apiUrl + 'users/dteevaluatees/' + activeUserContextService.context.orientation.schoolYear + '/' + districtCode + '/' + evaluator.id;
            return $http.get(url).then(function(response) {
                return response.data;
            });
        }

        function getEvaluateesForEvaluatorDE_PR(evaluator, districtCode,  assignedOnly) {
            assignedOnly = assignedOnly || false;
            var url = config.apiUrl + 'users/evaluatees/depr/' + activeUserContextService.context.orientation.schoolYear + '/' + districtCode + '/';

            url+= (evaluator.id + '/' + assignedOnly + '/true');

            return $http.get(url).then(function(response) {
                return response.data;
            });
        }

        function getEvaluateesForEvaluatorPR_PR(evaluator, districtCode, schoolCode,  assignedOnly) {
            assignedOnly = assignedOnly || false;
            var url = config.apiUrl + 'users/evaluatees/prpr/' + activeUserContextService.context.orientation.schoolYear + '/' + districtCode + '/'
                     + schoolCode + '/' + evaluator.id + '/' + assignedOnly + '/true';

            return $http.get(url).then(function(response) {
                return response.data;
            });
        }

        function getEvaluateesForEvaluatorPR_TR(evaluator, districtCode, schoolCode,  assignedOnly) {
            assignedOnly = assignedOnly || false;
            var url = config.apiUrl + 'users/evaluatees/prtr/' + activeUserContextService.context.orientation.schoolYear + '/' + districtCode + '/'
                        + schoolCode + '/' + evaluator.id + '/' + assignedOnly + '/true';

            return $http.get(url).then(function(response) {
                return response.data;
            });
        }

        function getEvaluateesForEvaluatorPR_LIB(evaluator, districtCode, schoolCode,  assignedOnly) {
            assignedOnly = assignedOnly || false;
            var url = config.apiUrl + 'users/evaluatees/prlib/' + activeUserContextService.context.orientation.schoolYear + '/' + districtCode + '/'
                + schoolCode + '/' + evaluator.id + '/' + assignedOnly + '/true';

            return $http.get(url).then(function(response) {
                return response.data;
            });
        }

        function getUsersInRoleAtSchool(districtCode, schoolCode, roleName) {
            var url = config.apiUrl + 'usersinrole/district/' + districtCode + '/school/' + schoolCode + '/role/' + roleName;
            return $http.get(url).then(function(response) {
                return response.data;
            });
        }

        function getUsersInRoleAtDistrict(districtCode, roleName) {
            var url = config.apiUrl + '/usersinrole/district/' +  districtCode + '/role/' + roleName;
            return $http.get(url).then(function(response) {
                return response.data;
            });
        }

        function getPrincipalsInDistrict(districtCode) {
            var url = config.apiUrl + 'usersinroleindistrict/' + activeUserContextService.context.orientation.schoolYear + '/district/' + districtCode + '/SESchoolPrincipal';
            return $http.get(url).then(function(response) {
                return response.data;
            });
        }

        function getTeachersInDistrict(districtCode) {
            var url = config.apiUrl + 'usersinroleindistrict/' + activeUserContextService.context.orientation.schoolYear + '/district/' + districtCode + '/SESchoolTeacher';
            return $http.get(url).then(function(response) {
                return response.data;
            });
        }
    }
})();

