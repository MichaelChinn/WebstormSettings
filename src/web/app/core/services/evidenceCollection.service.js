(function () {

    angular
        .module('stateeval.core')
        .factory('evidenceCollectionService', evidenceCollectionService);
    evidenceCollectionService.$inject = ['activeUserContextService', 'rubricUtils', 'enums', 'localStorageService',
        'config', '$http', 'rubricRowEvaluationService', '$rootScope', '$q'];

    function evidenceCollectionService(activeUserContextService, rubricUtils, enums, localStorageService,
                                       config, $http, rubricRowEvaluationService, $rootScope, $q) {

        var frameworkList = {};
        // todo: handle switching frameworks
        function EvidenceCollection(name, request, data) {
            this.name = name;
            this.request = request;
            this.creationDate = new Date();
            this.instantiator = activeUserContextService.user;
            this.observation = data.observation;
            this.selfAssessment = data.selfAssessment;
            this.studentGrowthGoalBundle = data.studentGrowthGoalBundle;
            this.associatedCollections = {};

            if (request.collectionType === enums.EvidenceCollectionType.SUMMATIVE) {
                for (var i in enums.EvColTypeAccessor) {
                    // this.associatedCollections['observations'] = array of observations
                    // this.associatedCollections['studentGrowthGoalBundles'] = array of bundles
                    // this.associatedCollections[linkedItemType][linkedItemId]: object
                    this.associatedCollections[enums.EvidenceCollectionType[i]] = data[enums.EvColTypeAccessor[i]] || [];
                    for (var j in this.associatedCollections) {
                        this.associatedCollections[j] = _.groupBy(this.associatedCollections[j], 'id');
                        for (var k in this.associatedCollections[j]) {
                            this.associatedCollections[j][k] = this.associatedCollections[j][k][0];
                        }
                    }
                }
            }
            var stateV = activeUserContextService.context.frameworkContext.stateFramework;
            var instrV = activeUserContextService.context.frameworkContext.instructionalFramework;
            var arr = [];
            if (stateV) {
                arr.push(stateV);
            }
            if (instrV) {
                arr.push(instrV);
            }
            var build = buildFramework(arr, data, this);
            this.score = null;
            this.frameworkNodeScores = _.groupBy(data.frameworkNodeScores, 'frameworkNodeId') || [];
            for (var i in this.frameworkNodeScores) {
                //todo each evaluation needs a original creation source obj
                this.frameworkNodeScores[i] = this.frameworkNodeScores[i][0];
            }
            this.rubric = build.rubric;
            this.tree = build.tree;
            var frameName = activeUserContextService.context.framework.name;
            //this.rubric = buildFrameworkFromActive(data.rubricRowEvaluations, data.availableEvidence);
            console.log(name, ': ', this);

            //if the ECOL is a summative obj new score objs will come in through the data property
            //data.summativeRubricRowScore, data.summativeFrameworkNode scores

            //other evidence and goals do not retrieve any scores

            //summative ECOL does not recieve available evidence
        }

        EvidenceCollection.prototype = {
            getRows: function (nodeShortName) {
                var that = this;
                return _.filter(this.rubric, function (n) {
                    var mapper = that.tree[activeUserContextService.context.framework.name].frameworkMapper;
                    return mapper[n.data.id] === nodeShortName;
                });
            },
            getNode: function (nodeShortName) {
                var node = this.tree[activeUserContextService.context.framework.name][nodeShortName];
                return node || console.log('Node not in current framework.');
            },
            getRow: function (rowShortName) {
                return _.find(this.rubric, {shortName: rowShortName});
            },
            getRowById: function (rowId) {
                return this.rubric[rowId];
            },
            newRubricRowScore: function newRubricRowScore(rowId, performanceLevel) {
                var newScore = {
                    id: 0,
                    evaluationId: activeUserContextService.context.evaluatee.evalData.id,
                    createdByUserId: activeUserContextService.user.id,
                    performanceLevel: performanceLevel,
                    rubricRowId: rowId,
                    linkedItemType: 0
                };

                switch (this.request.collectionType) {
                    case enums.EvidenceCollectionType.OBSERVATION:
                        newScore.linkedItemId = this.request.collectionObjectId;
                        newScore.linkedItemType = enums.LinkedItemType.OBSERVATION;
                        break;
                    case enums.EvidenceCollectionType.SELF_ASSESSMENT:
                        newScore.linkedItemId = this.request.collectionObjectId;
                        newScore.linkedItemType = enums.LinkedItemType.SELF_ASSESSMENT;
                        break;
                    case enums.EvidenceCollectionType.STUDENT_GROWTH_GOALS:
                        newScore.linkedItemId = this.request.collectionObjectId;
                        newScore.linkedItemType = enums.LinkedItemType.STUDENT_GROWTH_GOAL;
                        break;
                    case enums.EvidenceCollectionType.OTHER_EVIDENCE:
                        newScore.linkedItemType = enums.LinkedItemType.ARTIFACT;
                        break;
                    case enums.EvidenceCollectionType.SUMMATIVE:
                        newScore.linkedItemType = 0;
                        break;
                }

                return newScore;
            },
            newFrameworkNodeScore: function newFrameworkNodeScore(nodeId, performanceLevel) {
                var newScore = {
                    id: 0,
                    evaluationId: activeUserContextService.context.evaluatee.evalData.id,
                    createdByUserId: activeUserContextService.user.id,
                    performanceLevel: performanceLevel,
                    frameworkNodeId: nodeId,
                    linkedItemType: 0,
                    statementOfPerformance: ''
                };

                switch (this.request.collectionType) {
                    case enums.EvidenceCollectionType.OBSERVATION:
                        newScore.linkedItemId = this.request.collectionObjectId;
                        newScore.linkedItemType = enums.LinkedItemType.OBSERVATION;
                        break;
                    case enums.EvidenceCollectionType.SELF_ASSESSMENT:
                        newScore.linkedItemId = this.request.collectionObjectId;
                        newScore.linkedItemType = enums.LinkedItemType.SELF_ASSESSMENT;
                        break;
                }

                return newScore;
            },

            scoreItem: function scoreItem(score) {
                var url = config.apiUrl;
                if (this.request.collectionType === enums.EvidenceCollectionType.SUMMATIVE) {
                    url += (score.frameworkNodeId ?
                        'evidencecollections/scoresummativeframeworknode' : 'evidencecollections/scoresummativerubricrow');
                } else {
                    url += (score.frameworkNodeId ?
                        'evidencecollections/scoreframeworknode' : 'evidencecollections/scorerubricrow');
                }
                return $http.put(url, score)
                    .then(function (response) {
                        score.id = response.data.id
                    })
            },


            addNewEvaluation: function addNewEvaluation(performanceLevel, rubricStatement, alignedEvidence, row) {
                if (!performanceLevel) {
                    console.log('saved without level');
                    return $q.when();
                }
                var newEval = newRubricRowEvaluation(performanceLevel, rubricStatement, alignedEvidence, row, this);
                return createEvaluation(newEval, row, this)
                    .then(function () {
                        var level = enums.PerformanceLevels[performanceLevel - 1];
                        updateMergeText(row, level);
                    })
            },
            deleteEvaluation: function deleteEvaluation(evaluation) {
                var that = this;
                return deleteRubricRowEvaluation(evaluation)
                    .then(function () {
                        var list = that.rubric[evaluation.rubricRowId].evaluations;
                        list.splice(list.indexOf(evaluation), 1);
                        var level = enums.PerformanceLevels[evaluation.performanceLevel - 1];
                        var pLList = that.rubric[evaluation.rubricRowId][level].evaluations;
                        pLList.splice(pLList.indexOf(evaluation), 1);
                        updateMergeText(that.rubric[evaluation.rubricRowId], level);
                        var x = 1;
                    });
            },
            updateEvaluation: function updateEvaluation(evaluation) {
                return updateRubricRowEvaluation(evaluation);
            }
        };

        function updateMergeText(row, level) {
            row[level].descriptor = rubricUtils.mergeEvidenceToHtml(row.data[enums.PLAccessor[level]], row[level].evaluations)

        }

        function createEvaluation(evaluation, row, collection) {
            return createRubricRowEvaluation(evaluation)
                .then(function () {
                    collection.rubric[row.data.id].evaluations.push(evaluation);
                    collection.rubric[row.data.id][enums.PerformanceLevels[evaluation.performanceLevel - 1]].evaluations.push(evaluation);
                });

        }

        function newRubricRowEvaluation(performanceLevel, rubricStatement, alignedEvidence, row, collection) {
            var newEval = {
                rubricRowId: row.data.id,
                evaluationId: activeUserContextService.context.evaluatee.evalData.id,
                evidenceCollectionType: collection.request.collectionType,
                createdByUserId: activeUserContextService.user.id,
                rubricStatement: rubricStatement,
                performanceLevel: performanceLevel,
                alignedEvidences: alignedEvidence,
                additionalInput: ''
            };

            switch (collection.request.collectionType) {
                case enums.EvidenceCollectionType.OBSERVATION:
                    newEval.linkedObservationId = collection.request.collectionObjectId;
                    newEval.linkedItemType = enums.LinkedItemType.OBSERVATION;
                    break;
                case enums.EvidenceCollectionType.SELF_ASSESSMENT:
                    newEval.linkedSelfAssessmentId = collection.request.collectionObjectId;
                    newEval.linkedItemType = enums.LinkedItemType.SELF_ASSESSMENT;
                    break;
                case enums.EvidenceCollectionType.STUDENT_GROWTH_GOALS:
                    newEval.linkedStudentGrowthGoalBundleId = collection.request.collectionObjectId;
                    newEval.linkedItemType = enums.LinkedItemType.STUDENT_GROWTH_GOAL;
                    break;
                case enums.EvidenceCollectionType.OTHER_EVIDENCE:
                    newEval.linkedItemType = enums.LinkedItemType.ARTIFACT;
                    break;
            }

            return newEval;
        }

        var state = {
            evidenceVisible: []
        }

        var service = {
            getFramework: getFramework,
            getCurrentFramework: getCurrentFramework,
            getEvidenceCollection: getEvidenceCollection,
            newEvidenceCollection: newEvidenceCollection,
            newAlignedEvidence: newAlignedEvidence,
            state: state
        };


        return service;

        function newAlignedEvidence(availableEvidence) {
            var alignedEvidence = {
                rubricRowEvaluationId: 0,
                alignedEvidenceId: 0,
                data: availableEvidence,
                availableEvidenceId: availableEvidence.id,
                additionalInput: '',
                evidenceType: availableEvidence.evidenceType,
                availableEvidenceObjectId: 0
            };

            switch (availableEvidence.evidenceType) {
                case enums.EvidenceType.ARTIFACT:
                    alignedEvidence.availableEvidenceObjectId = availableEvidence.artifactBundleId;
                    break;
                case enums.EvidenceType.STUDENT_GROWTH_GOAL:
                    alignedEvidence.availableEvidenceObjectId = availableEvidence.studentGrowthGoalBundleId;
                    break;
                default:
                    alignedEvidence.availableEvidenceObjectId = availableEvidence.rubricRowAnnotationId;
                    break;
            }

            return alignedEvidence;
        }

        function newEvidenceCollection(name, request, data) {
            return new EvidenceCollection(name, request, data);
        }

        function getEvidenceCollection(name, collectionType, collectionObjectId, frameworkNodeId, rubricRowId) {
            var request = {
                evaluationId: activeUserContextService.context.evaluatee.evalData.id,
                //todo: need to filter which ones we want
                // usually it should be all evaluations except for those done by evaluatee, but in some
                // cases, i.e. when evaluatee scores observations, we will want to get both
                currentUserId: 0,
                collectionType: collectionType,
                collectionObjectId: collectionObjectId,
                frameworkNodeId: frameworkNodeId,
                rubricRowId: rubricRowId
            };

            if (collectionType === enums.EvidenceCollectionType.STUDENT_GROWTH_GOALS) {
                request.currentUserId = activeUserContextService.context.evaluatee.evalData.evaluatorId;
            }

            var url = config.apiUrl + 'evidencecollections/';
            return $http.get(url, {params: request}).then(function (response) {
                return new EvidenceCollection(name, request, response.data);
            });
        }

        function getFramework(name) {
            return frameworkList[name]
        }

        function getCurrentFramework() {
            return frameworkList[activeUserContextService.context.framework.name]
        }

        //function buildFrameworkFromActive(evaluations, evidences) {
        //    var stateV = activeUserContextService.context.frameworkContext.stateFramework;
        //    var instrV = activeUserContextService.context.frameworkContext.instructionalFramework;
        //    return buildFramework([stateV, instrV], evaluations, evidences);
        //}

        function buildFramework(frameworkViews, data, evidenceCollection) {
            var evaluations = _.groupBy(data.rubricRowEvaluations, 'rubricRowId');
            var frameworkNodeScores = _.groupBy(data.frameworkNodeScores, 'frameworkNodeId');
            var evidences = _.groupBy(data.availableEvidence, 'rubricRowId');
            var rubricRowScores = _.groupBy(data.rubricRowScores, 'rubricRowId');
            var nodeSumScores = _.groupBy(data.summativeFrameworkNodeScores, 'frameworkNodeId');
            var rowSumScores = _.groupBy(data.summativeRubricRowScores, 'rubricRowId');
            var views = [];
            for (var i in frameworkViews) {
                views.push(_.cloneDeep(frameworkViews[i]))
            }
            //builds .rubric
            var fullRows = _(_.reduce(views,
                function (total, next) {
                    return total.concat(rubricUtils.getFlatRows(next));
                }, []))
                .uniq('id')
                .filter(function (n) {
                    return n
                })
                .groupBy('id')
                .mapValues(function (value) {
                    var temp = value[0];
                    var r = rubricUtils.formatRubricRow(value[0], undefined, evaluations[temp.id]);
                    r.evaluations = evaluations[r.data.id] || [];
                    if (evidenceCollection.request.collectionType === enums.EvidenceCollectionType.SUMMATIVE) {
                        r.scores = rubricRowScores[temp.id] || [];
                        r.score = rowSumScores[temp.id] && rowSumScores[temp.id][0]
                            || evidenceCollection.newRubricRowScore(temp.id, null);
                    } else {
                        r.score = rubricRowScores[temp.id] && rubricRowScores[temp.id][0]
                            || evidenceCollection.newRubricRowScore(temp.id, null);
                    }
                    r.parent = {};
                    var evs = _.groupBy(evidences[r.data.id], 'evidenceType');
                    for (var i in enums.EvidenceTypeMapper) {
                        r[enums.EvidenceTypeMapper[i]] = evs[i] || [];
                    }
                    return r;
                }).value();
            //builds .tree
            var tree = {};
            for (var i in views) {
                var name = views[i].name;
                tree[name] = {};
                tree[name].nodes = [];
                for (var j in views[i].frameworkNodes) {
                    var nodeShortName = views[i].frameworkNodes[j].shortName;
                    var nodeId = views[i].frameworkNodes[j].id;
                    tree[name].nodes.push(nodeShortName);
                    tree[name][nodeShortName] = {};
                    tree[name][nodeShortName].rows = [];
                    tree[name][nodeShortName].root = evidenceCollection;
                    for (var k in views[i].frameworkNodes[j].rubricRows) {
                        var rowShortName = views[i].frameworkNodes[j].rubricRows[k].shortName;
                        var rowId = views[i].frameworkNodes[j].rubricRows[k].id;
                        tree[name][nodeShortName].rows.push(rowShortName);
                        tree[name][nodeShortName][rowShortName] = fullRows[rowId];
                        tree[name][nodeShortName][rowShortName].parent[name] = tree[name][nodeShortName];
                        tree[name][nodeShortName][rowShortName].root = evidenceCollection;
                        delete views[i].frameworkNodes[j].rubricRows[k].frameworkNodeShortName;
                    }
                    tree[name][nodeShortName].parent = tree[name];
                    tree[name][nodeShortName].data = views[i].frameworkNodes[j];

                    //fills scores with non summative scores during summative scoring
                    if (evidenceCollection.request.collectionType === enums.EvidenceCollectionType.SUMMATIVE) {
                        tree[name][nodeShortName].scores = frameworkNodeScores[nodeId] || [];
                        tree[name][nodeShortName].score = nodeSumScores[nodeId] && nodeSumScores[nodeId][0]
                            || evidenceCollection.newFrameworkNodeScore(nodeId, null);
                    } else {
                        tree[name][nodeShortName].score = frameworkNodeScores[nodeId] && frameworkNodeScores[nodeId][0]
                            || evidenceCollection.newFrameworkNodeScore(nodeId, null);
                    }
                }
                tree[name].data = views[i];
                tree[name].parent = tree;
                tree[name].frameworkMapper = rubricUtils.getFrameworkMapper(views[i]);


            }
            tree.parent = evidenceCollection;
            return {
                rubric: fullRows,
                tree: tree
            };
        }


        function deleteRubricRowEvaluation(rrEvaluation) {
            var url = config.apiUrl + 'rubricrowevaluations/' + rrEvaluation.id;
            return $http.delete(url);
        }

        function createRubricRowEvaluation(rrEvaluation) {
            var url = config.apiUrl + rrEvaluation.evaluationId + '/rubricrowevaluations/';
            return $http.post(url, rrEvaluation).then(function (response) {
                rrEvaluation.id = response.data.id;
                return response.data;
            });
        }

        function updateRubricRowEvaluation(rrEvaluation) {
            var url = config.apiUrl + rrEvaluation.evaluationId + '/rubricrowevaluations/';
            return $http.put(url, rrEvaluation).then(function (response) {
                //rrEvaluation.id = response.date.id;
                return response.data;
            });
        }

    }
})();