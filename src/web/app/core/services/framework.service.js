/**
 * Created by anne on 6/27/2015.
 */

(function () {

    angular
        .module('stateeval.core')
        .factory('frameworkService', frameworkService);

    /* @ngInject */
    frameworkService.$inject = ['$http', '$q', 'logger', 'config', 'enums', 'rubricUtils', 'activeUserContextService'];
    function frameworkService($http, $q, logger, config, enums, rubricUtils, activeUserContextService) {

        var service = {
            getFrameworkContext: getFrameworkContext,
            getLoadedFrameworkContexts: getLoadedFrameworkContexts,
            getPrototypeFrameworkContexts: getPrototypeFrameworkContexts,
            updateFrameworkContext: updateFrameworkContext,
            loadFrameworkContext: loadFrameworkContext
        };

        return service;

        function loadFrameworkContext(protoContextId) {
            var districtCode = activeUserContextService.context.orientation.districtCode;
            var url = config.apiUrl + '/loadframeworkcontext/' + districtCode + '/' + protoContextId;
            return $http.put(url, protoContextId);
        }

        function updateFrameworkContext(frameworkContext) {

            var params = {
                frameworkContextId: frameworkContext.id,
                frameworkViewType: frameworkContext.frameworkViewType,
                isActive: frameworkContext.isActive
            };

            var url = config.apiUrl + '/frameworkcontexts';
            return $http.put(url, params);
        }


        function getLoadedFrameworkContexts() {
            var districtCode = activeUserContextService.context.orientation.districtCode;
            var url = config.apiUrl + '/loadedframeworkcontexts/' + districtCode;
            return $http.get(url).then(function (response) {
                return response.data;
            });
        }

        function getPrototypeFrameworkContexts() {
            var url = config.apiUrl + '/protoframeworkcontexts';
            return $http.get(url).then(function (response) {
                return response.data;
            });
        }

        function getFrameworkContextInternal(evalType) {
            var params = {
                schoolYear: activeUserContextService.context.orientation.schoolYear,
                districtCode: activeUserContextService.context.orientation.districtCode,
                evaluationType: evalType
            };

            var url = config.apiUrl + '/frameworkcontexts';
            return $http.get(url, { params: params}).then(function (response) {
                return response.data;
            });
        }
        
        function getFrameworkContext(evalType) {
            return getFrameworkContextInternal(evalType).then(function(frameworkContext) {
                frameworkContext.frameworks = [];
                frameworkContext.showStateFramework = (
                frameworkContext.frameworkViewType === enums.FrameworkViewType.STATE_FRAMEWORK_DEFAULT ||
                frameworkContext.frameworkViewType === enums.FrameworkViewType.STATE_FRAMEWORK_ONLY ||
                frameworkContext.frameworkViewType === enums.FrameworkViewType.INSTRUCTIONAL_FRAMEWORK_DEFAULT);

                frameworkContext.showInstructionalFramework = (
                frameworkContext.frameworkViewType === enums.FrameworkViewType.STATE_FRAMEWORK_DEFAULT ||
                frameworkContext.frameworkViewType === enums.FrameworkViewType.INSTRUCTION_FRAMEWORK_ONLY ||
                frameworkContext.frameworkViewType === enums.FrameworkViewType.INSTRUCTIONAL_FRAMEWORK_DEFAULT);

                frameworkContext.studentGrowthFrameworkNodes =
                    rubricUtils.getStudentGrowthFrameworkNodes(frameworkContext.stateFramework.frameworkNodes);

                frameworkContext.defaultFramework = frameworkContext.showInstructionalFramework?
                    frameworkContext.instructionalFramework:
                    frameworkContext.stateFramework;

                if (frameworkContext.stateFramework) {
                    frameworkContext.stateFramework.frameworkNodes.forEach(function(fn) {
                        fn.rrIds = _.pluck(fn.rubricRows, 'id');
                    });

                    frameworkContext.frameworks.push(
                        {
                            state: true,
                            id: frameworkContext.stateFramework.id,
                            name: frameworkContext.stateFramework.name,
                            framework: frameworkContext.stateFramework
                        });
                }

                if (frameworkContext.instructionalFramework) {

                    frameworkContext.instructionalFramework.frameworkNodes.forEach(function(fn) {
                        fn.rrIds = _.pluck(fn.rubricRows, 'id');
                    });

                    frameworkContext.frameworks.push(
                        {
                            state: false,
                            id: frameworkContext.instructionalFramework.id,
                            name: frameworkContext.instructionalFramework.name,
                            framework: frameworkContext.instructionalFramework
                        });
                }

                return frameworkContext;
            });
        }
    }

})();

