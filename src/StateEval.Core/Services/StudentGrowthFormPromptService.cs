using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StateEval.Core.Mapper;
using StateEval.Core.Models;
using StateEval.Core.RequestModel;
using StateEval.Core.Constants;
using StateEvalData;

namespace StateEval.Core.Services
{
    public class StudentGrowthFormPromptService : BaseService
    {
        public void SubmitSettings(long frameworkContextId)
        {

            SEDistrictConfiguration seConfig = EvalEntities.SEDistrictConfigurations.FirstOrDefault(x => x.FrameworkContextID == frameworkContextId);

            if (seConfig != null)
            {
                seConfig.StudentGrowthGoalSetupWfStateID = (short)SEWfStateEnum.SG_GOAL_SETUP_DONE;
                EvalEntities.SaveChanges();
            }
        }

        public bool GetStudentGrowthProcessSettingsHaveBeenSubmitted(long frameworkContextId)
        {
            SEDistrictConfiguration seConfig = EvalEntities.SEDistrictConfigurations.FirstOrDefault(x => x.FrameworkContextID == frameworkContextId);

            if (seConfig != null)
            {
                return seConfig.StudentGrowthGoalSetupWfStateID == (long)SEWfStateEnum.SG_GOAL_SETUP_DONE;
            }

            return false;
        }

        public object CreatePrompt(StudentGrowthFormPromptModel formPromptModel)
        {
            SEStudentGrowthFormPrompt seFormPrompt = formPromptModel.MaptoSEStudentGrowthFormPrompt();
            EvalEntities.SEStudentGrowthFormPrompts.Add(seFormPrompt);
            EvalEntities.SaveChanges();

            return new { Id = seFormPrompt.StudentGrowthFormPromptID };
        }

        public void UpdatePrompt(StudentGrowthFormPromptModel formPromptModel)
        {
            SEStudentGrowthFormPrompt seFormPrompt = EvalEntities.SEStudentGrowthFormPrompts.FirstOrDefault(x => x.StudentGrowthFormPromptID == formPromptModel.Id);
            if (seFormPrompt != null)
            {
                formPromptModel.MaptoSEStudentGrowthFormPrompt(seFormPrompt);
                EvalEntities.SaveChanges();
            }
        }

        public void DeletePrompt(long id)
        {
            SEStudentGrowthFormPrompt seFormPrompt = EvalEntities.SEStudentGrowthFormPrompts.FirstOrDefault(x => x.StudentGrowthFormPromptID == id);
            if (seFormPrompt != null)
            {
                seFormPrompt.SEStudentGrowthFormPromptFrameworkNodes.ToList().ForEach(x => seFormPrompt.SEStudentGrowthFormPromptFrameworkNodes.Remove(x));
                EvalEntities.SEStudentGrowthFormPrompts.Remove(seFormPrompt);
                EvalEntities.SaveChanges();
            }
        }

        public IEnumerable<StudentGrowthFormPromptModel> GetAvailablePrompts(StudentGrowthFormPromptRequestModel requestModel)
        {
            IQueryable<SEStudentGrowthFormPrompt> prompts = EvalEntities.SEStudentGrowthFormPrompts
                .Where(x => (x.DistrictCode == "" || x.DistrictCode == requestModel.DistrictCode) && 
                            x.EvaluationTypeID == (short)requestModel.EvaluationType && 
                            x.SchoolYear == (short)requestModel.SchoolYear &&
                            x.FormPromptTypeID == requestModel.PromptType);
            return prompts.ToList().Select(x => x.MaptoStudentGrowthFormPromptModel());
        }

        public IEnumerable<StudentGrowthFormPromptModel> GetActivePrompts(StudentGrowthFormPromptRequestModel requestModel)
        {
            IEnumerable<StudentGrowthFormPromptFrameworkNodeModel> districtPrompts = GetDistrictPrompts(requestModel);

            IQueryable<SEStudentGrowthFormPrompt> prompts = EvalEntities.SEStudentGrowthFormPrompts
                .Where(x => districtPrompts.Select(y => y.FormPromptId).Contains(x.StudentGrowthFormPromptID));

            return prompts.ToList().Select(x => x.MaptoStudentGrowthFormPromptModel());
        }

        public IEnumerable<StudentGrowthFormPromptFrameworkNodeModel> GetDistrictPrompts(StudentGrowthFormPromptRequestModel requestModel)
        {
            return EvalEntities.SEStudentGrowthFormPromptFrameworkNodes
            .Where(x => x.DistrictCode == requestModel.DistrictCode &&
                        x.EvaluationTypeID == (short)requestModel.EvaluationType &&
                        x.SchoolYear == (short)requestModel.SchoolYear).ToList()
            .Select(x => x.MaptoStudentGrowthFormPromptFrameworkNodeModel(EvalEntities)).ToList();

        }

        public void TogglePromptUse(StudentGrowthFormPromptRequestModel requestModel)
        {
            // do it for a specific prompt
            if (requestModel.PromptId != 0)
            {
                SEStudentGrowthFormPromptFrameworkNode prompt = EvalEntities.SEStudentGrowthFormPromptFrameworkNodes
                .FirstOrDefault(x => x.DistrictCode == requestModel.DistrictCode &&
                                x.EvaluationTypeID == (short)requestModel.EvaluationType &&
                                x.SchoolYear == (short)requestModel.SchoolYear &&
                            x.FrameworkNodeID == requestModel.FrameworkNodeId &&
                            x.FormPromptID == requestModel.PromptId);
                if (prompt != null)
                {
                    EvalEntities.SEStudentGrowthFormPromptFrameworkNodes.Remove(prompt);
                }
                else
                {
                    prompt = new SEStudentGrowthFormPromptFrameworkNode();
                    prompt.FormPromptID = requestModel.PromptId;
                    prompt.SchoolYear = (short)requestModel.SchoolYear;
                    prompt.EvaluationTypeID = (short)requestModel.EvaluationType;
                    prompt.FrameworkNodeID = requestModel.FrameworkNodeId;
                    prompt.DistrictCode = requestModel.DistrictCode;

                    EvalEntities.SEStudentGrowthFormPromptFrameworkNodes.Add(prompt);
                }
            }
            else
            {
                // do it for all prompts for frameworknodeid
                IEnumerable<StudentGrowthFormPromptModel> prompts = GetAvailablePrompts(requestModel);
                prompts.ToList().ForEach(x =>
                {
                    requestModel.PromptId = x.Id;
                    TogglePromptUse(requestModel);
                });   
            }

            EvalEntities.SaveChanges();
        }
    }
}
