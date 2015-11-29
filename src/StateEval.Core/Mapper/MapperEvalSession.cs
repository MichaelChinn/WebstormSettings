using System.Linq;
using StateEval.Core.Constants;
using StateEval.Core.Models;
using StateEvalData;
using SEEvaluationType = StateEvalData.SEEvaluationType;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
        public static EvalSessionModel MaptoEvalSessionModel(this SEEvalSession source, EvalSessionModel target = null)
        {
            target = target ?? new EvalSessionModel();
            target.Id = source.EvalSessionID;
            target.DistrictCode = source.DistrictCode;
            target.SchoolCode = source.SchoolCode;
            target.Title = source.Title;
            target.ObserveStartTime = source.ObserveStartTime;
            target.EvaluatorId = source.EvaluatorUserID;
            target.EvaluateeId = source.EvaluateeUserID;
            target.EvaluationType = (SEEvaluationTypeEnum)source.EvaluationTypeID;
            target.ObserveNotes = source.ObserveNotes;
            target.EvaluatorNotes = source.EvaluatorNotes;
            target.Duration = source.Duration;
            target.WfState = System.Convert.ToInt16(source.WfStateID);
            target.EvaluationId = source.EvaluationID;
            target.SessionKey = source.SessionKey;
            target.PreConfStartTime = source.PreConfStartTime;
            target.PostConfStartTime = source.PostConfStartTime;
            

            target.EvaluatorPreConNotes = source.EvaluatorPreConNotes;
            target.EvaluateePreConNotes = source.EvaluateePreConNotes;
            target.IsSharedWithEvaluatee = source.IsSharedWithEvaluatee;
            target.PreConfPromptState = source.PreConfPromptState;

            target.CreatedByDisplayName = source.SEUser.FirstName + " " + source.SEUser.LastName;
            
            if (source.SchoolYear != null)
            {
                target.SchoolYear = (SESchoolYearEnum)source.SchoolYear;
            }

            target.Focused = source.IsFocused ?? false;
            if (source.SERubricRows != null && source.SERubricRows.Count > 0)
            {
                target.RubricRowNames = string.Join(",", source.SERubricRows.Select(x => x.ShortName).ToList());
                target.RubricRows = source.SERubricRows.Select(x => x.MaptoRubricRowModel(0)).ToList();
            }

            // TODO: needed for demo
            if (source.SERubricRows != null && source.SERubricRows.Count > 0)
            {
                target.AlignedRubricRows = source.SERubricRows.Select(x => x.MaptoRubricRowModel(0)).ToList();
            }
           
            return target;
        }

        public static SEEvalSession MaptoSEEvalSession(this EvalSessionModel source, SEEvalSession target = null)
        {
            target = target ?? new SEEvalSession();
            target.EvalSessionID = source.Id;
            target.DistrictCode = source.DistrictCode;
            target.SchoolCode = source.SchoolCode;
            target.Title = source.Title;            
            target.EvaluatorUserID = source.EvaluatorId;
            target.EvaluateeUserID = source.EvaluateeId;
            target.EvaluationTypeID = (short)source.EvaluationType;
            target.SchoolYear = (short?)source.SchoolYear;
            target.IsFocused = source.Focused;
            target.EvaluatorNotes = source.EvaluatorNotes;
            target.EvaluationID = source.EvaluationId;
            target.Duration = source.Duration;
            target.WfStateID = source.WfState;
            target.SessionKey = source.SessionKey;
            target.ObserveNotes = source.ObserveNotes;
            target.ObserveStartTime = source.ObserveStartTime;
            target.PreConfStartTime = source.PreConfStartTime;
            target.PostConfStartTime = source.PostConfStartTime;
            target.EvaluatorPreConNotes = source.EvaluatorPreConNotes;
            target.EvaluateePreConNotes = source.EvaluateePreConNotes;
            target.IsSharedWithEvaluatee = source.IsSharedWithEvaluatee;
            target.PreConfPromptState = source.PreConfPromptState;
         
            return target;
        }
    }
}