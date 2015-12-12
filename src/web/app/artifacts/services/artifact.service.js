(function () {
    'use strict';

    angular.module('stateeval.artifact')
        .factory('artifactService', artifactService);

    artifactService.$inject = ['$http', 'config', 'enums', '_', '$q', '$sce', '$window', '$modal',
        'activeUserContextService', 'utils'];

    function artifactService($http, config, enums, _, $q, $sce, $window, $modal,
         activeUserContextService, utils) {

        var FILE = enums.ArtifactLibItemType.FILE;
        var PROFPRACTICE = enums.ArtifactLibItemType.PROFPRACTICE;
        var WEB = enums.ArtifactLibItemType.WEB;

        return {
             newArtifact: newArtifact,
            newLibItem: newLibItem,
            newRejection: newRejection,
            newCommunication: newCommunication,
            newArtifactBundleRequest: newArtifactBundleRequest,
            newAnnotation: newAnnotation,

            getArtifactBundlesForEvaluation: getArtifactBundlesForEvaluation,
            getAttachableObservationsForEvaluation: getAttachableObservationsForEvaluation,
            getAttachableStudentGrowthGoalBundlesForEvaluation: getAttachableStudentGrowthGoalBundlesForEvaluation,
            getAttachableSelfAssessmentsForEvaluation: getAttachableSelfAssessmentsForEvaluation,
            saveArtifact: saveArtifact,
            deleteArtifact: deleteArtifact,
            updateArtifactRejection: updateArtifactRejection,
            getArtifactById: getArtifactById,
            getRubricRowAnnotations: getRubricRowAnnotations,
            rejectArtifact: rejectArtifact,
            getArtifactRejectionForArtifact: getArtifactRejectionForArtifact,
            submitArtifact: submitArtifact,
            saveRubricRowAnnotation: saveRubricRowAnnotation,
            alignmentToString: alignmentToString,
            artifactAlignmentWithEval: artifactAlignmentWithEval,
            itemTypeToString: utils.mapLibItemTypeToString,
            libItemDisplayName: libItemDisplayName,

            trustAsHtml: trustAsHtml,
            viewItem: viewItem
        };

        /////////////////////////////////

        function getAttachableSelfAssessmentsForEvaluation() {
            var evaluationid = activeUserContextService.context.evaluatee.evalData.id;
            var url = config.apiUrl + evaluationid + '/attachableselfassessments';
            return $http.get(url).then(function (response) {
                return response.data;
            });
        }

        function getAttachableStudentGrowthGoalBundlesForEvaluation() {
            var evaluationid = activeUserContextService.context.evaluatee.evalData.id;
            var url = config.apiUrl + evaluationid + '/attachablesggoalbundles';
            return $http.get(url).then(function (response) {
                return response.data;
            });
        }

        function getAttachableObservationsForEvaluation() {
            var evaluationid = activeUserContextService.context.evaluatee.evalData.id;
            var url = config.apiUrl + evaluationid + '/attachableobservations';
            return $http.get(url).then(function (response) {
                return response.data;
            });
        }

        function getArtifactRejectionForArtifact(artifact) {
            var url = config.apiUrl + 'artifactbundlerejections/' + artifact.id;
            return $http.get(url).then(function (response) {
                return response.data;
            });
        }

        function rejectArtifact(rejection) {
            var url = config.apiUrl + 'artifactbundles/reject';
            return $http.put(url, rejection).then(function (response) {
                return response.data;
            });
        }

        function updateArtifactRejection(rejection) {
            var url = config.apiUrl + 'artifactbundlesrejections';
            return $http.put(url, rejection);
        }

        function getRubricRowAnnotations(artifact) {
            var url = config.apiUrl + 'artifactbundles/rubricRowAnnotations/' + artifact.id;
            return $http.get(url).then(function (response) {
                return response.data;
            });
        }

        function getArtifactById(id) {
            return $http.get(config.apiUrl + 'artifactbundles/' + id).then(function(response) {
                return response.data;
            })
        }

        function getArtifactBundlesForEvaluation(request) {
            var url = config.apiUrl + '/artifactbundles';
            return $http.get(url, {params: request})
                .then(function (response) {
                    return response.data;
                });
        }

        function submitArtifact(artifact) {

            var url = config.apiUrl + '/artifactbundles/submit';
            return $http.put(url, artifact).then(function(response) {
            })
        }

        function saveArtifact(artifact) {
            var evaluationid = activeUserContextService.context.evaluatee.evalData.id;
            var url = config.apiUrl + evaluationid + '/artifactbundles';
            if (artifact.id != 0) {
                return $http.put(url, artifact);
            } else {
                return $http.post(url, artifact).then(function(response) {
                    artifact.id = response.data.id;
                });
            }
        }

        function deleteArtifact(artifact) {
            return $http.delete(config.apiUrl + 'artifactbundles/' + artifact.id);
        }

        function artifactAlignmentWithEval(artifact) {
            var alignmentString = '';
            artifact.alignedRubricRows.forEach(function (rr) {
                if (alignmentString != '') {
                    alignmentString += ', ';
                }
                var rrEval = _.findWhere(artifact.rubricRowEvaluations, {rubricRowId: rr.id});
                if (rrEval != undefined) {
                    alignmentString += '<span class="badge badge-default">' + rr.shortName + '</span>';
                }
                else {
                    alignmentString += rr.shortName;
                }
            });

            return utils.getSafeHtml(alignmentString);
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

        function trustAsHtml(text) {
            return $sce.trustAsHtml(text);
        }

        function viewItem(item) {
            $window.event.stopPropagation();
            switch (item.itemType) {
                case (FILE):
                    console.log('opening file');
                    $window.open('http://www.ucarecdn.com/' + item.fileUUID + '/');
                    break;
                case (WEB):
                    console.log('opening website');
                    $window.open(item.webUrl);
                    break;
                case (PROFPRACTICE):
                    console.log('opening professional practice');
                    $modal.open({
                        templateUrl: 'app/artifacts/views/professional-practice-modal.html',
                        controller: 'ProfessionalPracticeController as vm',
                        resolve: {
                            libItem: function () {
                                return item;
                            }
                        }
                    });
                    break;
            }
        }

        function libItemDisplayName(item) {
            var displayName = '';
            switch (item.itemType) {
                case (FILE):
                    displayName = item.title || item.fileName;
                    break;
                case (WEB):
                    displayName = item.title || item.webUrl;
                    break;
                case (PROFPRACTICE):
                    displayName = item.title || item.profPracticeNotes;
                    break;
                default:
                    displayName = 'libItemDisplayName: unknown type: ' + item.itemType;
                    break;
            }

            if (displayName.length>25) {
                displayName = displayName.substr(0, 25) + '...';
            }
            return displayName;
        }

        function newArtifactBundleRequest(wfState, createdByUserId) {
            var evaluationId = activeUserContextService.context.evaluatee.evalData.id;
            var currentUserId = activeUserContextService.user.id;
            return {
                evaluationId: evaluationId,
                wfState: wfState,
                createdByUserId: createdByUserId,
                currentUserId: currentUserId,
                rubricRowId: 0
            }
        }

        function newCommunication(sessionKey, message) {
            return {
                createdByUserId: activeUserContextService.user.id,
                sessionKey: sessionKey,
                message: message
            }
        }

        function newRejection(artifact, rejectionType, message) {
            return {
                id: 0,
                rejectionType: rejectionType,
                message: message,
                artifactBundleId: artifact.id,
                createdByUserId:activeUserContextService.user.id,
                communicationSessionKey: null,
                communications: [{
                    id:0,
                    createdByUserId: activeUserContextService.user.id,
                    message: message,
                    communicationSessionKey: null
                }]
            }
        }

        function newAnnotation(artifactBundleId, rubricRowId, annotation, type) {
            return {
                id: 0,
                rubricRowId: rubricRowId,
                artifactBundleId: artifactBundleId,
                annotation: annotation,
                userId: activeUserContextService.user.id,
                annotationType: type
            }
        }

        // this saves the entire content, with the annotations embedded it
        function saveRubricRowAnnotation(artifact, rubricRow, text, type) {
            if (type == enums.RubricRowAnnotationType.ARTIFACT_ALIGNMENT) {
                artifact.evidence = text;
            }
            saveArtifact(artifact);
        }

        function newArtifact() {
            var evaluationid = activeUserContextService.context.evaluatee.evalData.id;
            return {
                comments: '',
                creationDateTime: new Date(),
                evaluationId: evaluationid,
                evalSessionId: null,
                id: 0,
                libItems: [],
                rubricRowAnnotations: [],
                alignedRubricRows: [],
                evidence: '',
                title: '',
                wfState: 6,
                rejectionType: null,
                createdByUserId: activeUserContextService.user.id
            }
        }

        function newLibItem(type) {
            var evaluationid = activeUserContextService.context.evaluatee.evalData.id;
            if (type) {
                return {
                    comments: '',
                    creationDateTime: new Date(),
                    evaluationId: evaluationid,
                    fileUUID: null,
                    id: 0,
                    itemType: type || -1,
                    profPracticeNotes: '',
                    title: '',
                    webUrl: '',
                    fileName: '',
                    tags: [],
                    createdByUserId: activeUserContextService.user.id
                }
            } else {
                console.log('Cannot build Item without an typeType');
            }

        }
    }
})
();