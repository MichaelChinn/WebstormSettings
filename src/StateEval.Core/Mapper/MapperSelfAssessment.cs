using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Data.Entity;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using StateEval.Core.Models;
using StateEval.Core.Constants;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
        public static SESelfAssessment MaptoSESelfAssessment(
            this SelfAssessmentModel source, StateEvalEntities evalEntities, SESelfAssessment target = null)
        {
            target = target ?? new SESelfAssessment();
            source.AlignedRubricRows = source.AlignedRubricRows ?? new List<RubricRowModel>();
            target.EvaluationID = source.EvaluationId;
            target.ShortName = source.ShortName;
            target.Title = source.Title;
            target.PerformanceLevelID = source.PerformanceLevel;
            target.EvaluateeID = source.EvaluateeId;
            target.EvaluationTypeID = (short)source.EvaluationType;
            target.IsSharedWithEvaluator = source.IsSharedWithEvaluator;
            target.IncludeInFinalReport = source.IncludeInFinalReport;
            target.FocusedFrameworkNodeID = source.FocusedFrameworkNodeId;
            target.FocusedSGFrameworkNodeID = source.FocusedSGFrameworkNodeId;

            //Adding and removing RubricRows
            List<SERubricRow> toRemoveRR = target.SERubricRows.Where(x => !source.AlignedRubricRows.Select(y => y.Id).Contains(x.RubricRowID)).ToList();
            List<RubricRowModel> toAddRR = source.AlignedRubricRows.Where(n => !target.SERubricRows.Select(db => db.RubricRowID).Contains(n.Id)).ToList();

            toRemoveRR.ForEach(x => target.SERubricRows.Remove(x));
            toAddRR.ForEach(x =>
            {
                SERubricRow rr = evalEntities.SERubricRows.FirstOrDefault(y => y.RubricRowID == x.Id);
                target.SERubricRows.Add(rr);
            });

            return target;
        }

        public static SelfAssessmentModel MaptoSelfAssessmentModel(
            this SESelfAssessment source, SelfAssessmentModel target = null)
        {
            target = target ?? new SelfAssessmentModel();
            target.EvaluationId = source.EvaluationID;
            target.ShortName = source.ShortName;
            target.PerformanceLevel = (short)source.PerformanceLevelID;
            target.EvaluateeId = source.EvaluateeID;
            target.EvaluationType = (SEEvaluationTypeEnum)source.EvaluationTypeID;
            target.IsSharedWithEvaluator = source.IsSharedWithEvaluator;
            target.IncludeInFinalReport = source.IncludeInFinalReport;
            target.FocusedFrameworkNodeId = source.FocusedFrameworkNodeID;
            target.FocusedSGFrameworkNodeId = source.FocusedSGFrameworkNodeID;

            if (source != null && source.SERubricRows.Any())
            {
                target.AlignedRubricRows = source.SERubricRows.Select(x => x.MaptoRubricRowModel(0)).ToList();
            }
            else
            {
                target.AlignedRubricRows = new List<RubricRowModel>();
            }

            return target;
        }
    }
}