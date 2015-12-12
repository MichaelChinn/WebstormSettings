/**
 * selectFrameworkController - controller
 */
(function () {
    'use strict';

    angular
        .module('stateeval.district-admin')
        .controller('selectFrameworkController', selectFrameworkController);

    selectFrameworkController.$inject = ['districtAdminService', 'config', 'enums', '_',
        'frameworkService', 'utils', '$state', 'activeUserContextService', '$stateParams'];

    /* @ngInject */
    function selectFrameworkController(districtAdminService, config, enums, _,
       frameworkService, utils, $state, activeUserContextService, $stateParams) {
        var vm = this;
        vm.enums = enums;

        vm.frameworkContextsBySchoolYear = [];
        vm.evaluateeTerm = activeUserContextService.getEvaluateeTermUpperCase();

        vm.updateFrameworkContext = updateFrameworkContext;
        vm.loadFrameworkContext = loadFrameworkContext;

        ////////////////////////////

        activate();

   /*     var x =
            {   '2015': {'1': { frameworkContext: null, selectedProto: null, prototypes: []}, '2': { frameworkContext: null, selectedProto: null, prototypes: [] }},
                '2016': {'1': { frameworkContext: null, selectedProto: null, prototypes: []}, '2': { frameworkContext: null, selectedProto: null, prototypes: [] }}
            }*/


        function activate() {
            return loadFrameworks();
        }

        function loadFrameworks() {

            var schoolYear, evalType;
            return frameworkService.getPrototypeFrameworkContexts()
            .then(function(prototypeContexts) {
                vm.prototypeContextsBySchoolYear = _.groupBy(prototypeContexts, 'schoolYear');
                for (schoolYear in vm.prototypeContextsBySchoolYear) {
                    var bySchoolYear = vm.prototypeContextsBySchoolYear[schoolYear];
                    vm.prototypeContextsBySchoolYear[schoolYear] = _.groupBy(bySchoolYear, 'evaluationType');
                    for (evalType in vm.prototypeContextsBySchoolYear[schoolYear]) {
                        var byEvalType = vm.prototypeContextsBySchoolYear[schoolYear][evalType];
                        vm.prototypeContextsBySchoolYear[schoolYear][evalType] = {
                            frameworkContext: null,
                            selectedProto: null,
                            protoTypes: byEvalType
                        }
                    }
                }

                return frameworkService.getLoadedFrameworkContexts();

            }).then(function(loadedContexts) {
                loadedContexts.forEach(function(context) {

                    for (schoolYear in vm.prototypeContextsBySchoolYear) {
                        for (evalType in vm.prototypeContextsBySchoolYear[schoolYear]) {
                            var byEvalType = vm.prototypeContextsBySchoolYear[schoolYear][evalType];
                            if (context.schoolYear === parseInt(schoolYear) && context.evaluationType === parseInt(evalType)) {
                                byEvalType.frameworkContext = context;
                            }
                        }
                    }
                });

                for (schoolYear in vm.prototypeContextsBySchoolYear) {
                    for (evalType in vm.prototypeContextsBySchoolYear[schoolYear]) {
                        var byEvalType = vm.prototypeContextsBySchoolYear[schoolYear][evalType];
                        if (!byEvalType.frameworkContext) {
                            var prevSchoolYear = parseInt(schoolYear)-1;
                            if (vm.prototypeContextsBySchoolYear[prevSchoolYear.toString()]) {
                                var prevYear = vm.prototypeContextsBySchoolYear[prevSchoolYear.toString()][evalType];
                                if (prevYear) {
                                    byEvalType.selectedProto = _.find(byEvalType.protoTypes, {name: prevYear.frameworkContext.name});
                                }
                            }
                        }
                    }
                }
            })
        }

        function loadFrameworkContext(protoId) {

            frameworkService.loadFrameworkContext(protoId).then(function() {
                return loadFrameworks();
            })
        }

        function updateFrameworkContext(frameworkContext) {
            if (frameworkContext.id == activateUserContextService.context.frameworkContext.id) {
                // in addition to updating the db, we need to save the cached version
                activeUserContextService.save();
            }

            frameworkService.updateFrameworkContext(frameworkContext);
        }

    }

})();