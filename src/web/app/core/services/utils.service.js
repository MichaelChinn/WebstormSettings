/**
 * Created by anne on 6/26/2015.
 */

(function() {
    'use strict';

    angular
        .module('stateeval.core')
        .factory('utils', utils);

    utils.$inject = ['enums', '$sce', 'rubricUtils'];

    function utils(enums, $sce, rubricUtils) {

        var service = {
            mapAnnotationTypeToString: mapAnnotationTypeToString,
            mapLibItemTypeToString: mapLibItemTypeToString,
            mapEvalRequestTypeToString: mapEvalRequestTypeToString,
            mapEvalRequestStatusToString: mapEvalRequestStatusToString,
            mapEvaluationPlanTypeToString: mapEvaluationPlanTypeToString,
            mapEvaluationPlanTypeForUserToString: mapEvaluationPlanTypeForUserToString,
            mapEvaluationFocusToString: mapEvaluationFocusToString,
            mapEvaluationFocusForUserToString: mapEvaluationFocusForUserToString,
            mapRoleNameToFriendlyName: mapRoleNameToFriendlyName,
            mapFrameworkViewTypeToString: mapFrameworkViewTypeToString,
            mapArtifactRejectionTypeToString: mapArtifactRejectionTypeToString,
            mapArtifactRejectionTypeToDescriptionString:mapArtifactRejectionTypeToDescriptionString,
            getSafeHtml: getSafeHtml,
            mapEventTypeToItemType: mapEventTypeToItemType,
            mapLinkedItemTypeToFullString: mapLinkedItemTypeToFullString,
            mapLinkedItemTypeToShortString: mapLinkedItemTypeToShortString,
            getEvaluateeTermLowerCase: getEvaluateeTermLowerCase,
            getEvaluateeTermUpperCase: getEvaluateeTermUpperCase,
            stripParameters: stripParameters,
            getSelectedText: getSelectedText,
            getTextWithoutCoding: getTextWithoutCoding
        };

        return service;

        function getSelectedText() {
            var txt = '';
            if (window.getSelection) {
                txt = window.getSelection().toString();
            } else if (document.getSelection) {
                txt = document.getSelection().toString();
            } else if (document.selection) {
                txt = document.selection.createRange().text;
            }
            else return;

            return txt;
        }

        function getSafeHtml(html) {
            return $sce.trustAsHtml(html);
        }

        function stripParameters(sref) {
            var regex = /\(.*\)/;
            return sref.replace(regex, '');
        }

        function mapAnnotationTypeToString(annotationType) {
            switch(annotationType) {
                case enums.RubricRowAnnotationType.ARTIFACT_ALIGNMENT:
                    return "Artifact Compononent Reflection";
                case enums.RubricRowAnnotationType.ARTIFACT_GENERAL:
                    return "Artifact General Reflection";
                case enums.RubricRowAnnotationType.PRE_CONF_MEETING:
                    return "Pre-conference Meeting";
                case enums.RubricRowAnnotationType.PRE_CONF_QUESTION:
                    return "Pre-conference Prompts";
                case enums.RubricRowAnnotationType.OBSERVATION_NOTES:
                    return "Observation Notes";
                default:
                    return "Unknown AnnotationType: " + annotationType;
            }
        }

        function mapLibItemTypeToString(itemType) {
            var string = '';
            switch (itemType) {
                case(enums.ArtifactLibItemType.FILE):
                    string = 'File';
                    break;
                case(enums.ArtifactLibItemType.WEB):
                    string = 'Website URL';
                    break;
                case (enums.ArtifactLibItemType.PROFPRACTICE):
                    string = 'Professional Practice';
                    break;
            }
            return string;
        }

        function mapEvalRequestTypeToString(type) {
            switch (type) {
                case enums.EvalAssignmentRequestType.ASSIGNED_EVALUATOR:
                    return "ASSIGNED EVALUATOR";
                case enums.EvalAssignmentRequestType.OBSERVATION_ONLY:
                    return "OBSERVATIONS ONLY";
                default:
                    return "UNKNOWN";
            }
        }

        function mapEvalRequestStatusToString(status) {
            switch(status) {
                case enums.EvalAssignmentRequestStatus.ACCEPTED:
                    return "ACCEPTED";
                case enums.EvalAssignmentRequestStatus.REJECTED:
                    return "REJECTED";
                case enums.EvalAssignmentRequestStatus.PENDING:
                    return "PENDING";
                default:
                    return "UNKNOWN";
            }
        }

        function mapLinkedItemTypeToShortString(type) {
            switch(type){
                case enums.LinkedItemType.ARTIFACT:
                    return "OE";
                case enums.LinkedItemType.OBSERVATION:
                    return "Obs";
                case enums.LinkedItemType.SELF_ASSESSMENT:
                    return "Self";
                case enums.LinkedItemType.STUDENT_GROWTH_GOAL:
                    return "SG";
                default:
                    return "UNK";
            }
        }

        function mapLinkedItemTypeToFullString(type) {
            switch(parseInt(type)){
                case enums.LinkedItemType.ARTIFACT:
                    return "Other Evidence";
                case enums.LinkedItemType.OBSERVATION:
                    return "Observation";
                case enums.LinkedItemType.SELF_ASSESSMENT:
                    return "Self-assessment";
                case enums.LinkedItemType.STUDENT_GROWTH_GOAL:
                    return "Student Growth Goal";
                default:
                    return "Unknown";
            }
        }
        function mapEvaluationPlanTypeForUserToString (user) {
            return mapEvaluationPlanTypeToString(user.evalData.planType);
        }

        function mapEvaluationPlanTypeToString (planType) {
            switch (planType) {
                case enums.EvaluationPlanType.COMPREHENSIVE: return 'Comprehensive';
                case enums.EvaluationPlanType.FOCUSED: return 'Focused';
            }
        }

        function mapEvaluationFocusForUserToString (activeUserContextService, user) {

            var frameworkNodes = activeUserContextService.getFrameworkContext().stateFramework.frameworkNodes;
            var focusFrameworkNode = _.findWhere(frameworkNodes, {id: user.evalData.focusFrameworkNodeId});
            var sgFocusFrameworkNode = _.findWhere(frameworkNodes, {id: user.evalData.focusSGFrameworkNodeId});
            return mapEvaluationFocusToString(focusFrameworkNode, sgFocusFrameworkNode);
        }

        function mapEventTypeToItemType(eventType) {
            switch(eventType) {
                case enums.EventType.OBSERVATION_CREATED:
                    return "Obs";
                case enums.EventType.ARTIFACT_REJECTED:
                    return "OE";
                case enums.EventType.ARTIFACT_SUBMITTED:
                    return "OE";
                default:
                    return "UNK";
            }
        }
        function mapEvaluationFocusToString (focusFrameworkNode, focusSGFrameworkNode)
        {
            var str = focusFrameworkNode.shortName;
            if (focusSGFrameworkNode && focusFrameworkNode.id !== focusSGFrameworkNode.id) {
                str += ('; SG-' + focusSGFrameworkNode.shortName);
            }

            return str;
        }

        function mapRoleNameToFriendlyName (roleName)
        {
            if (roleName === enums.Roles.SESchoolTeacher) {
                return 'Teacher';
            }
            else if (roleName === enums.Roles.SESchoolPrincipal) {
                return 'Principal';
            }
            else if (roleName === enums.Roles.SESchoolHeadPrincipal) {
                return "Head Principal";
            }
            else if (roleName === enums.Roles.SEDistrictAdmin) {
                return "District Administrator";
            }
            else if (roleName === enums.Roles.SESchoolAdmin) {
                return "School Administrator";
            }
            else if (roleName === enums.Roles.SEDistrictAssignmentManager) {
                return "District Assignment Manager";
            }
            else if (roleName === enums.Roles.SEDistrictViewer) {
                return "District Viewer";
            }
            else if (roleName === enums.Roles.SEDistrictEvaluator) {
                return "District Evaluator";
            }
            else if (roleName === enums.Roles.SEDistrictWideTeacherEvaluator) {
                return "District-wide Teacher Evaluator";
            }
            else if (roleName === enums.Roles.SESuperAdmin) {
                return "Super Admin";
            }
            else if (roleName === enums.Roles.SECustomSupportL1) {
                return "Customer Support";
            }
        }

        function mapFrameworkViewTypeToString(viewType) {
            switch (viewType) {
                case enums.FrameworkViewType.INSTRUCTION_FRAMEWORK_ONLY:
                    return "Instructional Framework Only";
                case enums.FrameworkViewType.INSTRUCTIONAL_FRAMEWORK_DEFAULT:
                    return "Instructional Framework Default";
                case enums.FrameworkViewType.STATE_FRAMEWORK_DEFAULT:
                    return "State Framework Default";
                case enums.FrameworkViewType.STATE_FRAMEWORK_ONLY:
                    return "State Framework Only";
            }
        }

        function mapArtifactRejectionTypeToString(rejectionType) {
            switch (rejectionType) {
                case enums.ArtifactBundleRejectionType.NON_ESSENTIAL:
                    return "Non-essential";
                case enums.ArtifactBundleRejectionType.REQUEST_REFINEMENTS:
                    return "Request refinements";
                case enums.ArtifactBundleRejectionType.OTHER:
                    return "Other, see comments";
            }
        }

        function mapArtifactRejectionTypeToDescriptionString(rejectionType) {
            switch (rejectionType) {
                case enums.ArtifactBundleRejectionType.NON_ESSENTIAL:
                    return "Evaluator has sufficient evidence for the aligned rubric component(s)";
                case enums.ArtifactBundleRejectionType.REQUEST_REFINEMENTS:
                    return "Evaluator has requested a change in the aligned rubric components(s)";
                case enums.ArtifactBundleRejectionType.OTHER:
                    return "Other, see comments";
            }
        }

        function getEvaluateeTermLowerCase(evalType)
        {
            return (evalType == enums.EvaluationType.PRINCIPAL)? "principal":"teacher";
        }

        function getEvaluateeTermUpperCase(evalType)
        {
            return (evalType == enums.EvaluationType.PRINCIPAL)? "Principal":"Teacher";
        }

        function getTextWithoutCoding(codedString) {
            var elm = $("<div>" + codedString + "</div>");
            elm.find(".node-desc").remove();
            elm.find(".node-desc-end").remove();
            return elm.text();
        }
    }
})();
