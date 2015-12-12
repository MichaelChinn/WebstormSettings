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
         public static PrototypeFrameworkContextModel MaptoPrototypeFrameworkContextModel(
            this vPrototypeFrameworkContext source, PrototypeFrameworkContextModel target = null)
        {
            target = target ?? new PrototypeFrameworkContextModel();

            target.Id = source.FrameworkContextID;
            target.Name = source.Name;
            target.SchoolYear = (SESchoolYearEnum)source.SchoolYear;
            target.EvaluationType = (SEEvaluationTypeEnum)source.EvaluationTypeID;;

            return target;
        }

         public static vPrototypeFrameworkContext MaptoSEPrototypeFrameworkContext(
            this PrototypeFrameworkContextModel source, vPrototypeFrameworkContext target = null)
        {
            target = target ?? new vPrototypeFrameworkContext();

            target.FrameworkContextID = source.Id;
            target.Name = source.Name;
            target.SchoolYear = (short)source.SchoolYear;
            target.EvaluationTypeID = (short)source.EvaluationType;
            return target;
        }
    }
}