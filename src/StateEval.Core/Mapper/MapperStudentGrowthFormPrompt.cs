using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
        public static StudentGrowthFormPromptModel MaptoStudentGrowthFormPromptModel(this SEStudentGrowthFormPrompt source, StudentGrowthFormPromptModel target = null)
        {
            target = target ?? new StudentGrowthFormPromptModel();

            target.Id = source.StudentGrowthFormPromptID;
            target.Prompt = source.Prompt;
            target.DistrictCode = source.DistrictCode;
            target.EvaluationType = source.EvaluationTypeID;
            target.SchoolYear = source.SchoolYear;
            target.PromptType = (short)source.FormPromptTypeID;
            return target;
        }

        public static SEStudentGrowthFormPrompt MaptoSEStudentGrowthFormPrompt(this StudentGrowthFormPromptModel source, SEStudentGrowthFormPrompt target = null)
        {
            target = target ?? new SEStudentGrowthFormPrompt();

            target.StudentGrowthFormPromptID = source.Id;
            target.Prompt = source.Prompt;
            target.DistrictCode = source.DistrictCode;
            target.EvaluationTypeID = source.EvaluationType;
            target.SchoolYear = source.SchoolYear;
            target.FormPromptTypeID = source.PromptType;
            return target;
        }

        public static SEStudentGrowthFormPromptResponse MaptoSEStudentGrowthFormPromptResponse(this StudentGrowthFormPromptModel source,
            SEStudentGrowthFormPromptResponse target = null)
        {
            target = target ?? new SEStudentGrowthFormPromptResponse();
            target.Response = source.Response ?? "";
            target.UserID = source.UserId;
            target.FormPromptID = source.Id;
            return target;
        }
    }
}