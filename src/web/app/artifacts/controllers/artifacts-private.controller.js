(function () {
    'use strict';

    angular.module('stateeval.artifact')
        .controller('artifactsPrivateController', artifactsPrivateController);

    artifactsPrivateController.$inject = ['artifactService', 'enums', '$state', 'activeUserContextService', 'rubricUtils', 'utils'];

    function artifactsPrivateController(artifactService, enums, $state, activeUserContextService, rubricUtils, utils) {
        var vm = this;
        vm.artifactService = artifactService;
        vm.enums = enums;

        vm.privateArtifacts = null;
        vm.alignment = [];
        vm.wfState = [];

        vm.mapArtifactWfStateToString = mapArtifactWfStateToString;
        vm.getSafeHtml = utils.getSafeHtml;
        vm.editArtifact = editArtifact;
        vm.deleteArtifact = deleteArtifact;
        vm.submitArtifact = submitArtifact;

        ///////////////////////////////

        activate();

        function activate() {
            var request = artifactService.newArtifactBundleRequest(enums.WfState.UNDEFINED, activeUserContextService.user.id);

            artifactService.getArtifactBundlesForEvaluation(request).then(function(artifacts) {
                 vm.privateArtifacts = artifacts;

                loadAlignment();
                loadWfState();
            })
        }

        function mapArtifactWfStateToString(wfState) {
            switch (wfState) {
                case enums.WfState.ARTIFACT:
                    return "Save for Later";
                    break;
                case enums.WfState.ARTIFACT_REJECTED:
                    return 'Needs further input';
                    break;
                case enums.WfState.ARTIFACT_SUBMITTED:
                    return "<span class='fa fa-check-circle'>&nbsp;Shared</span>";
                    break;
                default:
                    return 'Unknown';
                    break;
            }
        }

        function loadWfState() {
            vm.privateArtifacts.forEach(function (artifact) {
                vm.wfState[artifact.id] = mapArtifactWfStateToString(artifact.wfState);
            });
        }

        function loadAlignment() {

            var map = rubricUtils.getFrameworkMapper(activeUserContextService.getActiveFramework());
            vm.privateArtifacts.forEach(function(artifact) {
                artifact.alignedRubricRows.forEach(function(rr) {
                    rr.frameworkNodeShortName = map[rr.id];
                })
            });
            vm.privateArtifacts.forEach(function(artifact) {
                var alignment = "";
                var groupedByFN = _.groupBy(artifact.alignedRubricRows, 'frameworkNodeShortName');
                var keys = Object.keys(groupedByFN);
                for (var key in keys) {
                    var fnShortName = keys[key];
                    alignment+= "<b>" + fnShortName + "</b>&nbsp;(";
                    var alignedRubricRows = groupedByFN[fnShortName];
                    for (var i=0; i<alignedRubricRows.length; ++i) {
                        if (i>0) {
                            alignment+= ", ";
                        }
                        alignment+= alignedRubricRows[i].shortName;
                    }
                    alignment+= ")<br/>";
                }
                vm.alignment[artifact.id] = alignment;
            })
        }

        function editArtifact(artifact) {
            $state.go('artifact-builder', {artifactId: artifact?artifact.id:0});
        }

        function deleteArtifact(artifact) {
            artifactService.deleteArtifact(artifact).then(function() {
                vm.privateArtifacts = _.reject(vm.privateArtifacts, {id: artifact.id});
            })
        }

        function submitArtifact(artifact) {
            artifactService.submitArtifact(artifact).then(function() {
                vm.privateArtifacts = _.reject(vm.privateArtifacts, {id: artifact.id});
            })
        }

        function alignmentToString(artifact) {
            var list = '' ;
            for (var i in artifact.alignedRubricRows) {
                if (list != '')
                {
                    list += ', ';
                }
                list+= (artifact.alignedRubricRows[i].shortName);
            }
            return list;
        }
    }

})();