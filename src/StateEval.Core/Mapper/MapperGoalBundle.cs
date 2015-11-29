using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
        public static SEStudentGrowthGoalBundle MaptoSEStudentGrowthGoalBundle(
            this StudentGrowthGoalBundleModel source, StateEvalEntities evalEntities, SEStudentGrowthGoalBundle target = null)
        {
            target = target ?? new SEStudentGrowthGoalBundle();
            target.EvaluationID = source.EvaluationId;
            target.Title = source.Title;
            target.Comments = source.Comments;
            target.Course = source.Course;
            target.Grade = source.Grade;
            target.WfStateID = source.WfState;
            target.EvalWfStateID = source.EvalWfState;

           
            // We don't delete goals once they are created, just de-activate them. Goals are not shared across 
            // bundles, so we should only be adding new ones here if they don't exist yet
            List<StudentGrowthGoalModel> toAdd = source.Goals.Where(n => !target.SEStudentGrowthGoals.Select(db => db.StudentGrowthGoalID).Contains(n.Id)).ToList();
            List<StudentGrowthGoalModel> toUpdateOnly = source.Goals.Where(n => target.SEStudentGrowthGoals.Select(db => db.StudentGrowthGoalID).Contains(n.Id)).ToList();

            toUpdateOnly.ForEach(x => x.MaptoSEStudentGrowthGoal(evalEntities, target.SEStudentGrowthGoals.FirstOrDefault(y => y.StudentGrowthGoalID == x.Id)));
            toAdd.ForEach(x =>
            {
                var goal = new SEStudentGrowthGoal();
                target.SEStudentGrowthGoals.Add(x.MaptoSEStudentGrowthGoal(evalEntities, goal));
                goal.GoalBundleID = source.Id;
            });

            //Adding and removing RubricRows
            if (source.AlignedRubricRows == null)
            {
                source.AlignedRubricRows = new List<RubricRowModel>();
            }

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

        public static StudentGrowthGoalBundleModel MaptoStudentGrowthGoalBundleModel(
            this SEStudentGrowthGoalBundle source, StudentGrowthGoalBundleModel target = null)
        {
            target = target ?? new StudentGrowthGoalBundleModel();

            target.Id = source.StudentGrowthGoalBundleID;
            target.CreationDateTime = source.CreationDateTime;
            target.EvaluationId = source.EvaluationID;
            target.Title = source.Title;
            target.Comments = source.Comments;
            target.Course = source.Course;
            target.Grade = source.Grade;
            target.WfState = Convert.ToInt16(source.WfStateID);
            target.EvalWfState = Convert.ToInt16(source.EvalWfStateID);

            if (source.SEStudentGrowthGoals.Any())
            {
                target.Goals = source.SEStudentGrowthGoals.Select(x => x.MaptoStudentGrowthGoalModel(source.StudentGrowthGoalBundleID, target.Title)).OrderBy(goal => goal.FrameworkNodeId).ToList();
            }
            else
            {
                target.Goals = new List<StudentGrowthGoalModel>();
            }

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