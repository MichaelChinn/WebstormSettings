using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
        public static SEStudentGrowthGoal MaptoSEStudentGrowthGoal(this StudentGrowthGoalModel source,
            StateEvalEntities evalEntities, 
            SEStudentGrowthGoal target = null)
        {
            target = target ?? new SEStudentGrowthGoal();
            target.StudentGrowthGoalID = source.Id;
            target.EvaluationID = source.EvaluationId;
            target.EvidenceAll = source.EvidenceAll;
            target.EvidenceMost = source.EvidenceAll;
            target.FrameworkNodeID = source.FrameworkNodeId;
            target.ProcessRubricRowID = source.ProcessRubricRowId;
            target.ResultsRubricRowID = source.ResultsRubricRowId;
            target.GoalStatement = source.GoalStatement ?? "";
            target.GoalTargets = source.GoalTargets ?? "";
            target.EvidenceAll = source.EvidenceAll ?? "";
            target.EvidenceMost = source.EvidenceMost ?? "";
            target.IsActive = source.IsActive;

            if (source.Prompts == null)
            {
                source.Prompts = new List<StudentGrowthFormPromptModel>();
            }
            // Prompts are created and modified, not deleted
            // The response is stored in the FormPromptModel on the client but a corresponding SEFormPromptResponse is created/updated in the db
            List<StudentGrowthFormPromptModel> toAdd = source.Prompts.Where(x => !target.SEStudentGrowthFormPromptResponses.Select(db => db.FormPromptResponseID).Contains(x.ResponseId)).ToList();
            List<StudentGrowthFormPromptModel> toUpdateOnly = source.Prompts.Where(n => target.SEStudentGrowthFormPromptResponses.Select(db => db.FormPromptResponseID).Contains(n.ResponseId)).ToList();

            toUpdateOnly.ForEach(x => x.MaptoSEStudentGrowthFormPromptResponse(target.SEStudentGrowthFormPromptResponses.FirstOrDefault(y => y.FormPromptResponseID == x.ResponseId)));
            toAdd.ForEach(x =>
            {
                x.Response = x.Response ?? "";
                SEStudentGrowthFormPromptResponse promptResponse = new SEStudentGrowthFormPromptResponse();

                target.SEStudentGrowthFormPromptResponses.Add(x.MaptoSEStudentGrowthFormPromptResponse(promptResponse));
                promptResponse.SEStudentGrowthGoal = target;
                SEStudentGrowthFormPrompt prompt = evalEntities.SEStudentGrowthFormPrompts.FirstOrDefault(y => y.StudentGrowthFormPromptID == x.Id);
                promptResponse.SEStudentGrowthFormPrompt = prompt;
            });

            return target;
        }

        public static StudentGrowthGoalModel MaptoStudentGrowthGoalModel(this SEStudentGrowthGoal source, long bundleId, string bundleTitle,
            StudentGrowthGoalModel target = null)
        {
            target = target ?? new StudentGrowthGoalModel();

            target.Id = source.StudentGrowthGoalID;
            target.FrameworkNodeId = source.FrameworkNodeID;
            target.FrameworkNodeShortName = source.SEFrameworkNode == null ? "" : source.SEFrameworkNode.ShortName;
            target.ProcessRubricRowId = source.ProcessRubricRowID;
            target.ResultsRubricRowId = source.ResultsRubricRowID ?? 0;
            target.EvaluationId = source.EvaluationID;
            target.GoalStatement = source.GoalStatement;
            target.GoalTargets = source.GoalTargets;
            target.EvidenceAll = source.EvidenceAll;
            target.EvidenceMost = source.EvidenceMost;
            target.IsActive = source.IsActive;
            target.GoalBundleId = bundleId;
            target.GoalBundleTitle = bundleTitle;

            if (source.SEStudentGrowthFormPromptResponses.Any())
            {
                target.Prompts = source.SEStudentGrowthFormPromptResponses.Select(x => new StudentGrowthFormPromptModel
                {
                    Response = x.Response,
                    Id = x.FormPromptID,
                    Prompt = x.SEStudentGrowthFormPrompt.Prompt,
                    ResponseId = x.FormPromptResponseID,
                    UserId = x.UserID
                }).ToList();
            }
            else
            {
                target.Prompts = new List<StudentGrowthFormPromptModel>();
            }

            return target;
        }
    }
}