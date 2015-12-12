using StateEval.Core.Constants;

namespace StateEval.Core.RequestModel
{
    public class EvalSessionRequestModel
    {
        public int EvaluatorId { get; set; }
        public int EvaluateeId { get; set; }
        public SEEvaluationTypeEnum EvaluationType { get; set; }
        public string SchoolCode { get; set; }
        public SESchoolYearEnum SchoolYear { get; set; }
        public string DistrictCode { get; set; }

        public int EvaluationId { get; set; }
        
        public bool IsEvaluator { get; set; }

    }
}