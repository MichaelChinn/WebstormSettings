using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEval.Core.Constants;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
         public static FrameworkContextModel MaptoFrameworkContextModel(
            this SEFrameworkContext source, StateEvalEntities EvalEntities, FrameworkContextModel target = null)
        {
            target = target ?? new FrameworkContextModel();

            target.Id = source.FrameworkContextID;
            target.Name = source.Name;
            target.DistrictCode = source.DistrictCode;
            target.SchoolYear = (SESchoolYearEnum)source.SchoolYear;
            target.EvaluationType = (SEEvaluationTypeEnum)source.EvaluationTypeID;
            target.LoadDateTime = source.LoadDateTime;
            target.IsActive = source.IsActive;
            target.FrameworkViewType =(SEFrameworkViewTypeEnum) source.FrameworkViewTypeID;
            target.PrototypeFrameworkContextId = source.PrototypeFrameworkContextID;
    
            if (source.StateFrameworkID!=null)
            {
                SEFramework framework = EvalEntities.SEFrameworks.FirstOrDefault(x=>x.FrameworkID==source.StateFrameworkID);
                target.StateFramework = framework.MaptoFrameworkModel();
            }

            if (source.InstructionalFrameworkID != null)
            {
                SEFramework framework = EvalEntities.SEFrameworks.FirstOrDefault(x => x.FrameworkID == source.InstructionalFrameworkID);
                target.InstructionalFramework = framework.MaptoFrameworkModel();
            }

            return target;
        }

        public static SEFrameworkContext MaptoSEFrameworkContext(
            this FrameworkContextModel source, SEFrameworkContext target = null)
        {
            target = target ?? new SEFrameworkContext();

            target.FrameworkContextID = source.Id;
            target.DistrictCode = source.DistrictCode;
            target.SchoolYear = (short)source.SchoolYear;
            target.EvaluationTypeID = (short)source.EvaluationType;
            target.StateFrameworkID = source.StateFrameworkId;
            target.InstructionalFrameworkID = source.InstructionalFrameworkId;
            target.FrameworkViewTypeID = (short)source.FrameworkViewType;
            target.LoadDateTime = source.LoadDateTime;
            target.IsActive = source.IsActive;
            target.FrameworkViewTypeID = (short)source.FrameworkViewType;
            target.PrototypeFrameworkContextID = source.PrototypeFrameworkContextId;
            return target;
        }
    }
}