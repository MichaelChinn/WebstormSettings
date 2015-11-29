using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StateEval.Core.Constants;

namespace StateEval.Core.Models
{
    public class RubricRowAnnotationModel
    {
        // TODO: use Id instead of ID to be consistent with the rest of models
        public long Id { get; set; }
        public long RubricRowID { get; set; }
        public long EvaluationID { get; set; }
        public Nullable<long> EvalSessionID { get; set; }
        public Nullable<long> ArtifactBundleID { get; set; }
        public Nullable<long> StudentGrowthGoalBundleID { get; set; }
        public SELinkedItemTypeEnum LinkedItemType { get; set; }
        public string Annotation { get; set; }
        public Nullable<long> UserID { get; set; }
        public SERubricRowAnnotationTypeEnum AnnotationType { get; set; }
    }
}
