using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
        public static StudentGrowthFormPromptFrameworkNodeModel MaptoStudentGrowthFormPromptFrameworkNodeModel(this SEStudentGrowthFormPromptFrameworkNode source, StateEvalEntities entities, StudentGrowthFormPromptFrameworkNodeModel target = null)
        {
            target = target ?? new StudentGrowthFormPromptFrameworkNodeModel();

            target.Id = source.StudentGrowthFormPromptFrameworkNodeID;
            target.FrameworkNodeId = source.FrameworkNodeID;
            target.DistrictCode = source.DistrictCode;
            target.EvaluationType = source.EvaluationTypeID;
            target.SchoolYear = source.SchoolYear;
            target.FormPromptId = source.FormPromptID;
            target.FormPrompt = entities.SEStudentGrowthFormPrompts.FirstOrDefault(x => x.StudentGrowthFormPromptID == source.FormPromptID).MaptoStudentGrowthFormPromptModel();
            return target;
        }

        public static SEStudentGrowthFormPromptFrameworkNode MaptoSEStudentGrowthFormPromptFrameworkNode(this StudentGrowthFormPromptFrameworkNodeModel source, SEStudentGrowthFormPromptFrameworkNode target = null)
        {
            target = target ?? new SEStudentGrowthFormPromptFrameworkNode();

            target.StudentGrowthFormPromptFrameworkNodeID = source.Id;
            target.FrameworkNodeID = source.FrameworkNodeId;
            target.DistrictCode = source.DistrictCode;
            target.EvaluationTypeID = source.EvaluationType;
            target.SchoolYear = source.SchoolYear;
            target.FormPromptID = source.FormPromptId;
            return target;
        }
    }
}