using System;
using System.Collections.Generic;
using System.Data.Entity.Migrations.Model;
using System.Diagnostics.Eventing.Reader;
using System.Linq;
using System.Runtime.Remoting.Messaging;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using StateEval.Core.Constants;
using StateEval.Core.Mapper;
using StateEval.Core.Models;
using StateEval.Core.Models.Report;
using StateEvalData;

namespace StateEval.Core.Services
{
    public class ReportService : BaseService
    {
        public SummativeReportModel GetSummativeReport()
        {
            short schoolYear=1;
            string districtCode="";
            string schoolCode="";
            long evaluatorId=1;
            short evaluationRole=1;
            bool assignedOnly=true;
            bool includeEvalData=true;

            //var reportItems = GetTeachersInSchool(schoolYear, districtCode, schoolCode, evaluatorId,
            //    evaluationRole, assignedOnly, includeEvalData);

            SummativeReportModel summativeReport = new SummativeReportModel
            {
                Items = new List<SummativeReportItem>()
            };

            for (int i = 0; i < 10; i++)
            {
                var summativeReportItem = new SummativeReportItem
                {
                    Name = "Hp Aberdeen SD School 1",
                    EvalType = "C",
                    Submitted = "No",
                    Criteria = "INC*",
                    Growth = "INC*",
                    Final = "INC*",
                    Evaluator = "DE Aberdeen SD",
                    C1 = "",
                    C2 = "",
                    C3 = "",
                    C4 = "",
                    C5 = "",
                    C6 = "",
                    C7 = "",
                    C8 = "",
                    Observe = "",
                    Self = "",
                    Evidence = 0
                };

                summativeReport.Items.Add(summativeReportItem);
            }

            return summativeReport;
        }

        /* TODO: use SEEvaluation.WfStateID instead of HasBeenSubmitted
        public IList<SummativeReportItem> GetTeachersInSchool(int frameworkId, int evaluatorId, SESchoolYearEnum schoolYear, string districtCode, string schoolCode, bool assignedOnly = false, SEEvaluateeSubmissionRetrievalType submissionRetrievalType = SEEvaluateeSubmissionRetrievalType.All,
            SEUser evaluator = null, SEWfStateEnum ws = SEWfStateEnum.UNDEFINED)
        {            
            var seEvaluations = EvalEntities.SEEvaluations

                .Where(
                    x => x.DistrictCode == districtCode && x.SchoolYear == (short) schoolYear && x.EvaluationTypeID == 2)
                .Where(x => x.SEUser.SEUserLocationRoles.Any(y => y.RoleName == "SESchoolTeacher"))
                .Where(x => assignedOnly == false || x.EvaluatorID == evaluatorId)
                .Where(x => submissionRetrievalType == SEEvaluateeSubmissionRetrievalType.All
                            ||
                            (submissionRetrievalType == SEEvaluateeSubmissionRetrievalType.Submitted &&
                             x.HasBeenSubmitted == true)
                            ||
                            (submissionRetrievalType == SEEvaluateeSubmissionRetrievalType.NotSubmitted &&
                             x.HasBeenSubmitted == false))
                .Where(x => ws == SEWfStateEnum.UNDEFINED || x.WfStateID == (long) ws)
                // TODO: use SEUserLocationRoles
                .Where(x => x.SEUser.SEUserDistrictSchools.Any(y => y.SchoolCode == schoolCode));
            
            IList<SummativeReportItem> summativeReportItems = new List<SummativeReportItem>();
            var seFramework = EvalEntities.SEFrameworks.FirstOrDefault(x => x.FrameworkID == frameworkId);
            
            foreach (var seEvaluation in seEvaluations)
            {                
                SummativeReportItem reportItem = new SummativeReportItem();
                reportItem.Name = seEvaluation.SEUser.FirstName + " " + seEvaluation.SEUser.LastName;
                reportItem.EvalType = seEvaluation.SEEvaluationType.Name;
                reportItem.Submitted = seEvaluation.HasBeenSubmitted
                    ? seEvaluation.SubmissionDate.Value.ToString("dd/MM/yyyy")
                    : "No";
                reportItem.Evaluator = seEvaluation.SEUser1 == null
                    ? "Unassigned"
                    : seEvaluation.SEUser1.FirstName + " " + seEvaluation.SEUser1.LastName;
                reportItem.SchoolName =
                    seEvaluation.SEUser.SEUserDistrictSchools.FirstOrDefault(y => y.SchoolCode == schoolCode).SchoolName;
                SetScore(reportItem, seFramework, seEvaluation);
            }
   
            return summativeReportItems.ToList();
        }
         */

        private void SetScore(SummativeReportItem reportItem, SEFramework framework, SEEvaluation evalData)
        {
            var performanceLevels =
                EvalEntities.SEFrameworkPerformanceLevels.Where(x => x.FrameworkID == framework.FrameworkID).ToList();
            SEEvaluateePlanType planType = evalData.SEEvaluateePlanType; //          
            var scores = evalData.SEFrameworkNode.SESummativeFrameworkNodeScores;
            var nodes = framework.SEFrameworkNodes;
            var evaluateeId = evalData.SEUser.SEUserID;
            
            reportItem.C1 = GetSummativeFrameworkNodeScore("C1", evalData.EvaluationID, scores, performanceLevels);
            reportItem.C2 = GetSummativeFrameworkNodeScore("C2", evalData.EvaluationID, scores, performanceLevels);
            reportItem.C3 = GetSummativeFrameworkNodeScore("C3", evalData.EvaluationID, scores, performanceLevels);
            reportItem.C4 = GetSummativeFrameworkNodeScore("C4", evalData.EvaluationID, scores, performanceLevels);
            reportItem.C5 = GetSummativeFrameworkNodeScore("C5", evalData.EvaluationID, scores, performanceLevels);
            reportItem.C6 = GetSummativeFrameworkNodeScore("C6", evalData.EvaluationID, scores, performanceLevels);
            reportItem.C7 = GetSummativeFrameworkNodeScore("C7", evalData.EvaluationID, scores, performanceLevels);
            reportItem.C8 = GetSummativeFrameworkNodeScore("C8", evalData.EvaluationID, scores, performanceLevels);

            
        }
        public string GetSummativeFrameworkNodeScore(string shortName, long evaluationId, IEnumerable<SESummativeFrameworkNodeScore> scores, IList<SEFrameworkPerformanceLevel> performanceLevels)
        {
            var node = EvalEntities.SEFrameworkNodes.FirstOrDefault(x => x.ShortName == shortName);
            
            foreach (SESummativeFrameworkNodeScore score in scores)
            {
                if (score.FrameworkNodeID == node.FrameworkNodeID && score.EvaluationID == evaluationId)
                {
                    var frameworkLevel =
                        performanceLevels.FirstOrDefault(
                            x =>
                                x.FrameworkPerformanceLevelID ==
                                (short) score.SERubricPerformanceLevel.PerformanceLevelID);

                    return frameworkLevel.ShortName;
                }
            }

            return "";
        }
        
    }
}