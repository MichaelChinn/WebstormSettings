﻿using StateEval.Core.Constants;

namespace StateEval.Core.RequestModel
{
    public class UserPromptRequestModel
    {
        public SESchoolYearEnum SchoolYear { get; set; }
        public string DistrictCode { get; set; }
        public string SchoolCode { get; set; }
        public int CreatedByUserId { get; set; }
        public SEEvaluationTypeEnum EvaluationType { get; set; }
        public string RoleName { get; set; }
        public int EvalSessionId { get; set; }
        public long? EvaluateeId { get; set; }
        public SEUserPromptTypeEnum PromptType { get; set; }
    }
}