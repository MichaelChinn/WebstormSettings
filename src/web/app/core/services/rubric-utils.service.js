/**
 * Created by anne on 6/24/2015.
 */
/**
 * rubricUtils - service
 */

(function () {
    'use strict';

    angular
        .module('stateeval.core')
        .factory('rubricUtils', rubricUtils);

    rubricUtils.$inject = ['$sce', 'logger', '_', 'enums'];

    function rubricUtils($sce, logger, _, enums) {

        var service = {
            getRubricRowById: getRubricRowById,
            getFrameworkNodeForRubricRowId: getFrameworkNodeForRubricRowId,
            getStudentGrowthFrameworkNodes: getStudentGrowthFrameworkNodes,
            getStudentGrowthProcessRubricRow: getStudentGrowthProcessRubricRow,
            getStudentGrowthResultsRubricRow: getStudentGrowthResultsRubricRow,
            getStudentGrowthRubricRows: getStudentGrowthRubricRows,
            getStudentGrowthRubricRowsForFrameworkNode: getStudentGrowthRubricRowsForFrameworkNode,

            mapPerformanceLevelToDisplayString: mapPerformanceLevelToDisplayString,
            mapPerformanceLevelToShortDisplayString: mapPerformanceLevelToShortDisplayString,

            generateHighlightedRubricDescriptorTextFromEvaluations: generateHighlightedRubricDescriptorTextFromEvaluations,

            getRubricDescriptorText: getRubricDescriptorText,
            newRubricEvaluationDescriptorArray: newRubricEvaluationDescriptorArray,
            getFrameworkTree: getFrameworkTree,
            mergeEvidenceToHtml: mergeEvidenceToHtml,
            highlightSelectedHtml: highlightSelectedHtml,

            getFrameworkMapper: getFrameworkMapper,
            getRowMapper: getRowMapper,
            getNodeNumbers: getNodeNumbers,

            newSeparatedEvaluationDescriptorArray: newSeparatedEvaluationDescriptorArray,
            getFlatRows: getFlatRows,
            formatRubricRow: formatRubricRow
        };

        return service;


        function formatRubricRow(row, parent, evaluations) {
            var temp = {
                data: row,
                parent: parent
            };
            var separated = newSeparatedEvaluationDescriptorArray(row, evaluations);
            for(var i in enums.PerformanceLevels    ) {
                temp[enums.PerformanceLevels[i]] = separated[enums.PerformanceLevels[i]];
            }
            return temp
        }

        function newSeparatedEvaluationDescriptorArray(row, evaluations) {
            var obj = {};
            evaluations = evaluations || [];
            var unseparated = newRubricEvaluationDescriptorArray(row);
            if(evaluations.length > 0) {
                evaluations = _.groupBy(evaluations, 'performanceLevel');
            }
            for (var i in enums.PerformanceLevels) {
                var descriptorHolder = unseparated[i].descriptorText;
                var levelEvals = evaluations[parseInt(i) + 1] || [];
                if(levelEvals.length > 0) {
                    descriptorHolder = mergeEvidenceToHtml(unseparated[i].descriptorText, levelEvals);
                }
                obj[enums.PerformanceLevels[i]] = {
                    paragraphs: separateParagraphs(unseparated[i].descriptorText),
                    descriptor: descriptorHolder,
                    parent: row,
                    data: unseparated[i],
                    evaluations: levelEvals,
                    checked: false
                }
            }
            return obj;
        }

        function getFlatRows(framework) {
            var list = [];
            for(var i in framework.frameworkNodes) {
                for(var j in framework.frameworkNodes[i].rubricRows) {
                    list[framework.frameworkNodes[i].rubricRows[j].id] = framework.frameworkNodes[i].rubricRows[j]
                }
            }
            return list;
        }

        function getNodeNumbers(framework) {
            var list = [];
            for (var i in framework.frameworkNodes) {
                for (var j in framework.frameworkNodes[i].rubricRows) {
                    if (list[framework.frameworkNodes[i].shortName]) {
                        list[framework.frameworkNodes[i].shortName] += 1;
                    } else {
                        list[framework.frameworkNodes[i].shortName] = 1;
                    }
                }
            }
            return list;
        }

        // maps rubricRowId->frameworkNode.shortName
        function getFrameworkMapper(framework) {
            var list = [];
            for (var i in framework.frameworkNodes) {
                for (var j in framework.frameworkNodes[i].rubricRows) {
                    list[framework.frameworkNodes[i].rubricRows[j].id] = framework.frameworkNodes[i].shortName;
                }
            }
            return list;
        }

        // maps rubricRowId -> rubricRow.shortName
        function getRowMapper(framework) {
            var list = [];
            for (var i in framework.frameworkNodes) {
                for (var j in framework.frameworkNodes[i].rubricRows) {
                    list[framework.frameworkNodes[i].rubricRows[j].id] = framework.frameworkNodes[i].rubricRows[j].shortName;
                }
            }
            return list;
        }

        function getFrameworkTree(framework) {
            var frameworkNodes = framework.frameworkNodes;
            var list = [];
            for (var i = 0; i < frameworkNodes.length; i++) {
                list.push(frameworkNodes[i]);
                for (var j = 0; j < frameworkNodes[i].rubricRows.length; j++) {
                    list.push(frameworkNodes[i].rubricRows[j])
                }
            }

            return list;
        }

        function newRubricEvaluationDescriptorArray(rubricRow) {
            var rubricDescriptors = [
                {
                    performanceLevel: enums.RubricPerformanceLevel.PL1,
                    performanceLevelDisplayName: mapPerformanceLevelToDisplayString((enums.RubricPerformanceLevel.PL1)),
                    descriptorText: '',
                    checked: false
                },
                {
                    performanceLevel: enums.RubricPerformanceLevel.PL2,
                    performanceLevelDisplayName: mapPerformanceLevelToDisplayString((enums.RubricPerformanceLevel.PL2)),
                    descriptorText: '',
                    checked: false
                },
                {
                    performanceLevel: enums.RubricPerformanceLevel.PL3,
                    performanceLevelDisplayName: mapPerformanceLevelToDisplayString((enums.RubricPerformanceLevel.PL3)),
                    descriptorText: '',
                    checked: false
                },
                {
                    performanceLevel: enums.RubricPerformanceLevel.PL4,
                    performanceLevelDisplayName: mapPerformanceLevelToDisplayString((enums.RubricPerformanceLevel.PL4)),
                    descriptorText: '',
                    checked: false
                }
            ];

            for (var i = 0; i < 4; ++i) {
                var performanceLevel = i + 1;
                rubricDescriptors[i].descriptorText = getRubricDescriptorText(rubricRow, performanceLevel);
            }

            return rubricDescriptors;
        }

        function getRubricDescriptorText(rubricRow, performanceLevel) {

            if(!rubricRow) {
                console.log('none');
            }
            switch (performanceLevel) {
                case enums.RubricPerformanceLevel.PL1:
                    return rubricRow.pL1Descriptor;
                case enums.RubricPerformanceLevel.PL2:
                    return rubricRow.pL2Descriptor;
                case enums.RubricPerformanceLevel.PL3:
                    return rubricRow.pL3Descriptor;
                case enums.RubricPerformanceLevel.PL4:
                    return rubricRow.pL4Descriptor;
            }
        }

        function mapPerformanceLevelToDisplayString(plEnum) {
            switch (plEnum) {
                case enums.RubricPerformanceLevel.PL1:
                    return "Unsatisfactory";
                case enums.RubricPerformanceLevel.PL2:
                    return "Basic";
                case enums.RubricPerformanceLevel.PL3:
                    return "Proficient";
                case enums.RubricPerformanceLevel.PL4:
                    return "Distinguished";
            }
        }

        function mapPerformanceLevelToShortDisplayString(plEnum) {
            switch (plEnum) {
                case enums.RubricPerformanceLevel.PL1:
                    return "UNS";
                case enums.RubricPerformanceLevel.PL2:
                    return "BAS";
                case enums.RubricPerformanceLevel.PL3:
                    return "PRO";
                case enums.RubricPerformanceLevel.PL4:
                    return "DIS";
            }
        }

        function separateParagraphs(text) {
            var list = [];
            var split = text.split('<\/p>');
            for (var i in split) {
                var pieces = split[i].split('<p>');
                for (var j in pieces) {
                    var removeWhiteSpace = pieces[j].trim();
                    if (!(removeWhiteSpace === '')) {
                        list.push(removeWhiteSpace);
                    }
                }
            }
            return list;
        }


        //todo this is currently a workaround to try to bring all the different formats of the html text together
        function standardizeHtml(rubricDescriptorText) {
            var arr = separateParagraphs(rubricDescriptorText);
            var cleanedText = '';
            for (var i in arr) {
                cleanedText += (arr[i] + '\u000A\u000A');
            }
            return cleanedText.trim();
        }

        function highlightSelectedHtml(rubricDescriptorText, selectedText) {
            rubricDescriptorText = standardizeHtml(rubricDescriptorText);
            var combinedBinaryString = createBinaryString(rubricDescriptorText);
            var selectedTextBinaryString = createBinaryString(rubricDescriptorText, selectedText);
            combinedBinaryString = mergeBinaryString(combinedBinaryString, selectedTextBinaryString);
            return highlightFromBinaryString(rubricDescriptorText, combinedBinaryString);
        }

        //not quite what you want
        //this method should rather take it on per performance level instead
        // so it doesn't end up doing the additional iteration through the evidenceArray to pull out relevant PL's

        function mergeEvidenceToHtml(rubricDescriptorText, evaluations) {
            rubricDescriptorText = standardizeHtml(rubricDescriptorText);
            var combinedBinaryString = createBinaryString(rubricDescriptorText);
            for (var i in evaluations) {
                var evidenceBinaryString = createBinaryString(rubricDescriptorText, evaluations[i].rubricStatement);
                combinedBinaryString = mergeBinaryString(combinedBinaryString, evidenceBinaryString);
            }
            return highlightFromBinaryString(rubricDescriptorText, combinedBinaryString);
        }

        function generateHighlightedRubricDescriptorTextFromEvaluations(performanceLevel, rubricDescriptorText, evaluationsArray) {
            //changing paragraph tags into \u000A
            rubricDescriptorText = standardizeHtml(rubricDescriptorText);

            var combinedBinaryString = createBinaryString(rubricDescriptorText);
            for (var i in evaluationsArray) {

                if (evaluationsArray[i].performanceLevel === performanceLevel) {
                    var evidenceBinaryString = createBinaryString(rubricDescriptorText, evaluationsArray[i].rubricStatement);
                    combinedBinaryString = mergeBinaryString(combinedBinaryString, evidenceBinaryString);
                }
            }
            var finalHtml = highlightFromBinaryString(rubricDescriptorText, combinedBinaryString);
            return finalHtml;
        }

        function createBinaryString(fullText, criticalText) {
            var binaryString = '';
            if (criticalText) {
                var startIndex = fullText.indexOf(criticalText);
                var endIndex = startIndex + criticalText.length - 1;

            }
            for (var i = 0; i < fullText.length; i++) {
                if (i < startIndex || i > endIndex || !criticalText) {
                    binaryString += '0';
                } else {
                    binaryString += '1';
                }
            }
            return binaryString;
        }

        function mergeBinaryString(string1, string2) {
            //strings must be of equal length
            var binaryString = '';
            for (var i = 0; i < string1.length; i++) {
                if (string1[i] === '1' || string2[i] === '1') {
                    binaryString += 1;
                } else {
                    binaryString += 0;
                }
            }
            return binaryString;
        }

        function highlightFromBinaryString(actualText, binaryString) {
            //todo is not compatible with non-span browsers
            var highlightOpen = '<span style="background-color:#ffea8c">';
            var highlightClose = '</span>';
            var html = '';
            var isHighlighted = -1;
            for (var i = 0; i < actualText.length; i++) {
                if (binaryString[i] === '1' && isHighlighted === -1) {
                    html += highlightOpen;
                    isHighlighted = isHighlighted * -1;
                } else if (binaryString[i] === '0' && isHighlighted === 1) {
                    html += highlightClose;
                    isHighlighted = isHighlighted * -1;
                }

                if (actualText.substring(i, i + 2) === '\u000A\u000A' && isHighlighted === 1) {
                    html += highlightClose + '</p><p>' + highlightOpen;
                    i += 1;
                } else if (actualText.substring(i, i + 2) === '\u000A\u000A' && isHighlighted === -1) {
                    html += '</p><p>';
                    i += 1;
                } else {
                    html += actualText[i];
                }
            }
            html = '<p>' + html + '</p>';
            return html;
        }

        function addCorrectHighlightTag(html, id) {
            var teehighlightOpen = '<span style="background-color:#ffcc00">';
            var torhighlightOpen = '<span style="background-color:#ffff00">';
            var combhighlightOpen = '<span style="background-color:#ffae00">';
            switch (id) {
                case '1':
                    html += teehighlightOpen;
                    break;
                case '2':
                    html += torhighlightOpen;
                    break;
                case '3':
                    html += combhighlightOpen;
                    break;
            }
            return html;
        }

        function highlightFromTrinaryString(actualText, trinaryString) {
            var highlightClose = '</span>';
            var highlighter = '0';
            var isHighlighted = -1;
            var html = '';
            for (var i = 0; i < actualText.length; i++) {
                if (trinaryString[i] !== '0' && isHighlighted === -1) {
                    html = addCorrectHighlightTag(html, trinaryString[i]);
                    highlighter = trinaryString[i];
                    isHighlighted = isHighlighted * -1;
                } else if (trinaryString[i] === '0' && isHighlighted === 1) {
                    html += highlightClose;
                    isHighlighted = isHighlighted * -1;
                } else if (isHighlighted === 1 && highlighter !== trinaryString[i]) {
                    html += highlightClose;
                    html = addCorrectHighlightTag(html, trinaryString[i]);
                    highlighter = trinaryString[i];
                }

                if (actualText.substring(i, i + 2) === '\u000A\u000A' && isHighlighted === 1) {
                    html += highlightClose + '</p><p>';
                    html = addCorrectHighlightTag(html, trinaryString[i]);
                    i += 1;
                } else if (actualText.substring(i, i + 2) === '\u000A\u000A' && isHighlighted === -1) {
                    html += '</p><p>';
                    i += 1;
                } else {
                    html += actualText[i];
                }
            }
            html = '<p>' + html + '</p>';
            return html;

        }

        function mergeToTrinaryString(string1, string2) {
            var trinaryString = '';
            for (var i = 0; i < string1.length; i++) {
                if (string1[i] === '1' && string2[i] === '1') {
                    trinaryString += '3';
                    //combined is 3
                } else if (string1[i] === '1') {
                    trinaryString += '1';
                    //evaluatee is 1
                } else if (string2[i] === '1') {
                    trinaryString += '2';
                    //evaluator is 2
                } else {
                    trinaryString += '0';
                }
            }
            return trinaryString;
        }


        function getFrameworkNodeForRubricRowId(frameworkNodes, rubricRowId) {
            for (var i = 0; i < frameworkNodes.length; ++i) {
                var rr = _.find(frameworkNodes[i].rubricRows, {id: rubricRowId});
                if (rr != null) {
                    return frameworkNodes[i];
                }
            }
            return null;
        }

        function getRubricRowById(frameworkNodes, rubricRowId) {
            for (var i = 0; i < frameworkNodes.length; ++i) {
                var rr = _.find(frameworkNodes[i].rubricRows, {id: rubricRowId});
                if (rr != null) {
                    return rr;
                }
            }

            return null;
        }

        function getStudentGrowthProcessRubricRow(frameworkNode) {
            return getStudentGrowthRubricRow(frameworkNode, true);
        }

        function getStudentGrowthResultsRubricRow(frameworkNode) {
            return getStudentGrowthRubricRow(frameworkNode, false);
        }

        function getStudentGrowthRubricRow(frameworkNode, dot1) {
            var rr;
            for (var i = 0; i < frameworkNode.rubricRows.length; ++i) {
                rr = frameworkNode.rubricRows[i];
                if (rr.isStudentGrowthAligned && rr.shortName.match(dot1 ? /.1/ : /.2/)) {
                    return rr;
                }
            }
            return null;
        }

        function getStudentGrowthFrameworkNodes(frameworkNodes) {
            var fn, rr;
            var fnArray = [];
            for (var i = 0; i < frameworkNodes.length; ++i) {
                for (var j = 0; j < frameworkNodes[i].rubricRows.length; ++j) {
                    rr = frameworkNodes[i].rubricRows[j];
                    if (rr.isStudentGrowthAligned) {
                        fnArray.push(frameworkNodes[i]);
                        break;
                    }
                }
            }
            return fnArray;
        }

        function getStudentGrowthRubricRows(studentGrowthFrameworkNodes) {
            var rr;
            var rrArray = [];
            for (var i = 0; i < studentGrowthFrameworkNodes.length; ++i) {
                for (var j = 0; j < studentGrowthFrameworkNodes[i].rubricRows.length; ++j) {
                    rr = studentGrowthFrameworkNodes[i].rubricRows[j];
                    if (rr.isStudentGrowthAligned) {
                        rrArray.push(rr);
                    }
                }
            }
            return rrArray;
        }

        function getStudentGrowthRubricRowsForFrameworkNode(studentGrowthFrameworkNode) {
            var rr;
            var rrArray = [];
            for (var j = 0; j < studentGrowthFrameworkNode.rubricRows.length; ++j) {
                rr = studentGrowthFrameworkNode.rubricRows[j];
                if (rr.isStudentGrowthAligned) {
                    rrArray.push(rr);
                }
            }
            return rrArray;
        }
    }
})
();
