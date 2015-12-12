using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Constants;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {

        public static SEUserPrompt MaptoSEUserPrompt(this UserPromptModel source, StateEvalEntities evalEntities, SEUserPrompt target = null)
        {
            source.RubricRows = source.RubricRows ?? new List<RubricRowModel>();
            target = target ?? new SEUserPrompt();           
            target.UserPromptID = source.UserPromptID;
            target.PromptTypeID = (short)source.PromptTypeID;
            target.Title = source.Title;
            target.Prompt = source.Prompt;
            target.DistrictCode = source.DistrictCode;
            target.SchoolCode = source.SchoolCode;
            target.CreatedByUserID = source.CreatedByUserID;
            target.Published = source.Published;
            target.PublishedDate = source.PublishedDate;
            target.Retired = source.Retired;
            target.EvaluationTypeID = source.EvaluationTypeID;
            target.Private = source.Private;
            target.EvaluateeID = source.EvaluateeID;
            target.EvalSessionID = source.EvalSessionID;
            target.CreatedAsAdmin = source.CreatedAsAdmin;
            target.Sequence = source.Sequence;
            target.SchoolYear = source.SchoolYear;
            target.GUID = source.GUID;
            target.WfStateID = source.WfStateID;
            
            if (target.Published)
            {
                target.PublishedDate = DateTime.Now;
            }

            if (target.SERubricRows.Count > 0)
            {
                target.SERubricRows.Where(
                    x => source.RubricRows.All(y => y.Id != x.RubricRowID))
                    .ToList().ForEach(rr => target.SERubricRows.Remove(rr));
            }

            source.RubricRows.ForEach(x =>
            {
                var rubricRow = evalEntities.SERubricRows.FirstOrDefault(y => y.RubricRowID == x.Id);

                if (!target.SERubricRows.Any(y => rubricRow != null && y.RubricRowID == rubricRow.RubricRowID))
                {
                    target.SERubricRows.Add(rubricRow);
                }
            });


            return target;
        }

        public static UserPromptModel MapToUserPromptModel(this SEUserPrompt source, UserPromptModel target = null)
        {
            target = target ?? new UserPromptModel();
            target.UserPromptID = source.UserPromptID;
            target.PromptTypeID = (SEUserPromptTypeEnum)source.PromptTypeID;
            target.Title = source.Title;
            target.Prompt = source.Prompt;
            target.DistrictCode = source.DistrictCode;
            target.SchoolCode = source.SchoolCode;
            target.CreatedByUserID = source.CreatedByUserID;
            target.Published = source.Published;
            target.PublishedDate = source.PublishedDate;
            target.Retired = source.Retired;
            target.EvaluationTypeID = source.EvaluationTypeID;
            target.EvaluationType = ((SEEvaluationTypeEnum) source.EvaluationTypeID).ToString();
            target.Private = source.Private;
            target.EvaluateeID = source.EvaluateeID;
            target.EvalSessionID = source.EvalSessionID;
            target.CreatedAsAdmin = source.CreatedAsAdmin;
            target.Sequence = source.Sequence;
            target.SchoolYear = source.SchoolYear;            
            target.GUID = source.GUID;
            target.WfStateID = source.WfStateID;
            target.Assigned = source.SEUserPromptResponses != null && source.SEUserPromptResponses.Any();

            target.InUse = source.SEUserPromptResponses.Any(x => x.UserPromptID == source.UserPromptID) ||
                           source.SEUserPromptConferenceDefaults.Any(x => x.UserPromptID == source.UserPromptID);

            if (source.SERubricRows != null && source.SERubricRows.Count > 0)
            {
                target.RubricRows =
                    source.SERubricRows.Select(x => x.MaptoRubricRowModel(0)).ToList();

            }          
            
            if (source.Private)
            {
                target.DefinedBy = "Private";
            }
            //else if ((source.CreatedByUserID == UiUtils.SiteSettings.CurrentUser.Id) && !createdAsAdmin && RoleUtils.UserIsInEvaluatorRole())
            //{
            //    definedByLabel.Text = "My Question Bank";
            //}
            else if (source.SchoolCode == String.Empty)
            {
                target.DefinedBy = "District";
            }
            else if (source.SchoolCode != String.Empty)
            {
                target.DefinedBy = "School";
            }
            return target;
        }
    }
}

