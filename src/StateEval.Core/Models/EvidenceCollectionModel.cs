using System;
using System.Collections.Generic;
using StateEval.Core.Constants;

namespace StateEval.Core.Models
{
    public class EvidenceCollectionModel
    {
        public long Id { get; set; }
        public long EvaluationId { get; set; }
        public SEEvidenceCollectionTypeEnum CollectionType { get; set; }
        public Nullable<long> CollectionObjectId { get; set; }
        public EvalSessionModel Observation { get; set; }
        public SelfAssessmentModel SelfAssessment { get; set; }
        public StudentGrowthGoalBundleModel StudentGrowthGoalBundle { get; set; }
        public long RubricRowId { get; set; }

        public List<AvailableEvidenceModel> AvailableEvidence { get; set; }
        public List<RubricRowEvaluationModel> RubricRowEvaluations { get; set; }

        public List<FrameworkNodeScoreModel> FrameworkNodeScores { get; set; }
        public List<RubricRowScoreModel> RubricRowScores { get; set; }

        public List<SummativeFrameworkNodeScoreModel> SummativeFrameworkNodeScores { get; set; }
        public List<SummativeRubricRowScoreModel> SummativeRubricRowScores { get; set; }

        public List<EvalSessionModel> Observations { get; set; }
        public List<StudentGrowthGoalBundleModel> StudentGrowthGoalBundles { get; set; }

    }
}
