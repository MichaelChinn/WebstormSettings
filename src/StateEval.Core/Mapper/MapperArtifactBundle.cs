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
        public static SEArtifactBundle MaptoSEArtifactBundle(
            this ArtifactBundleModel source, StateEvalEntities evalEntities, SEArtifactBundle target = null)
        {
            target = target ?? new SEArtifactBundle();
            target.SERubricRows = target.SERubricRows ?? new List<SERubricRow>();
            source.AlignedRubricRows = source.AlignedRubricRows ?? new List<RubricRowModel>();
            source.LibItems = source.LibItems ?? new List<ArtifactLibItemModel>();
            target.ArtifactBundleID = source.Id;
            target.EvaluationID = source.EvaluationId;
            target.Title = source.Title;
            target.Context = source.Context;
            target.Evidence = source.Evidence;
            target.WfStateID = Convert.ToInt16(source.WfState);
            target.EvaluationID = source.EvaluationId;
            target.CreatedByUserID = source.CreatedByUserId;
            target.RejectionTypeID = source.RejectionType;       

            //Adding and removing RubricRows
            List<SERubricRow> toRemoveRR = target.SERubricRows.Where(x => !source.AlignedRubricRows.Select(y => y.Id).Contains(x.RubricRowID)).ToList();
            List<RubricRowModel> toAddRR = source.AlignedRubricRows.Where(n => !target.SERubricRows.Select(db => db.RubricRowID).Contains(n.Id)).ToList();

            toRemoveRR.ForEach(x => target.SERubricRows.Remove(x));
            toAddRR.ForEach(x =>
            {
                SERubricRow rr = evalEntities.SERubricRows.FirstOrDefault(y => y.RubricRowID == x.Id);
                target.SERubricRows.Add(rr);
            });

            target.SERubricRows.ToList().ForEach(x =>
            {
                SEAvailableEvidence evidence = evalEntities.SEAvailableEvidences.FirstOrDefault(y => y.ArtifactBundleID == source.Id && y.RubricRowID == x.RubricRowID);
                if (evidence == null)
                {
                    evalEntities.SEAvailableEvidences.Add(source.MapToAvailableEvidence(x.RubricRowID));
                }
            });

            //Adding and removing Library Items
            List<SEArtifactLibItem> toRemoveLI = target.SEArtifactLibItems.Where(x => !source.LibItems.Select(y => y.Id).Contains(x.ArtifactLibItemID)).ToList();
            List<ArtifactLibItemModel> toAddLI = source.LibItems.Where(n => !target.SEArtifactLibItems.Select(db => db.ArtifactLibItemID).Contains(n.Id)).ToList();
            List<ArtifactLibItemModel> toUpdateOnlyLI = source.LibItems.Where(n => target.SEArtifactLibItems.Select(db => db.ArtifactLibItemID).Contains(n.Id)).ToList();

            toRemoveLI.ForEach(x => target.SEArtifactLibItems.Remove(x));
            toUpdateOnlyLI.ForEach(x => x.MaptoSEArtifactLibItem(target.SEArtifactLibItems.FirstOrDefault(y => y.ArtifactLibItemID == x.Id)));
            toAddLI.ForEach(x =>
            {
                SEArtifactLibItem libItem = evalEntities.SEArtifactLibItems.FirstOrDefault(y => y.ArtifactLibItemID == x.Id);
                if (libItem == null)
                {
                    libItem = new SEArtifactLibItem();
                }
                target.SEArtifactLibItems.Add(x.MaptoSEArtifactLibItem(libItem));
            });

            //Adding and removing linked observations
            if (source.LinkedObservations != null)
            {
                List<SEEvalSession> toRemoveSessions = target.SEEvalSessions.Where(x => !source.LinkedObservations.Select(y => y.Id).Contains(x.EvalSessionID)).ToList();
                List<EvalSessionModel> toAddSessions = source.LinkedObservations.Where(n => !target.SEEvalSessions.Select(db => db.EvalSessionID).Contains(n.Id)).ToList();

                toRemoveSessions.ForEach(x => target.SEEvalSessions.Remove(x));
                toAddSessions.ForEach(x =>
                {
                    SEEvalSession session = evalEntities.SEEvalSessions.FirstOrDefault(y => y.EvalSessionID == x.Id);
                    target.SEEvalSessions.Add(session);
                });
            }

            //Adding and removing linked sg goal bundles
            if (source.LinkedStudentGrowthGoalBundles != null)
            {
                List<SEStudentGrowthGoalBundle> toRemoveGoals = target.SEStudentGrowthGoalBundles.Where(x => !source.LinkedStudentGrowthGoalBundles.Select(y => y.Id).Contains(x.StudentGrowthGoalBundleID)).ToList();
                List<StudentGrowthGoalBundleModel> toAddGoals = source.LinkedStudentGrowthGoalBundles.Where(n => !target.SEStudentGrowthGoalBundles.Select(db => db.StudentGrowthGoalBundleID).Contains(n.Id)).ToList();

                toRemoveGoals.ForEach(x => target.SEStudentGrowthGoalBundles.Remove(x));
                toAddGoals.ForEach(x =>
                {
                    SEStudentGrowthGoalBundle goalBundle = evalEntities.SEStudentGrowthGoalBundles.FirstOrDefault(y => y.StudentGrowthGoalBundleID == x.Id);
                    target.SEStudentGrowthGoalBundles.Add(goalBundle);
                });
            }

            return target;
        }

        public static ArtifactBundleModel MaptoArtifactBundleModel(
            this SEArtifactBundle source, ArtifactBundleModel target = null)
        {
            target = target ?? new ArtifactBundleModel();

            target.Id = source.ArtifactBundleID;
            target.CreationDateTime = source.CreationDateTime;
            target.EvaluationId = source.EvaluationID;
            target.Title = source.Title;
            target.Context = source.Context;
            target.Evidence = source.Evidence;
            target.WfState = Convert.ToInt16(source.WfStateID);
            target.CreatedByUserId = source.CreatedByUserID;
            target.CreatedByDisplayName = source.SEUser.FirstName + " " + source.SEUser.LastName;
            target.RejectionType = source.RejectionTypeID;

            if (source != null && source.SEArtifactLibItems.Any())
            {
                target.LibItems = source.SEArtifactLibItems.Select(x => x.MaptoArtifactLibItemModel()).ToList();
            }
            else
            {
                target.LibItems = new List<ArtifactLibItemModel>();
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