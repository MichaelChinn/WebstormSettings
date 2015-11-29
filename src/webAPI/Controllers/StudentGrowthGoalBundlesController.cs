using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using System.Configuration;

using System.Data.SqlClient;
using StateEval.Core.Mapper;
using StateEval.Core.Models;
using StateEval.Core.Constants;
using StateEval.Core.Services;
using System.Net.Http;
using System.Web.Http;
using System.Net;
using System.Web.Http.Routing;

using StateEvalData;
using webAPI.Models;

namespace WebAPI.Controllers
{
    public class StudentGrowthGoalBundlesController : BaseApiController
    {
        private readonly StudentGrowthGoalBundleService studentGrowthGoalBundleService =
            new StudentGrowthGoalBundleService();

        public StudentGrowthGoalBundlesController()
        {
        }

        [Route("api/artifactbundlesforsggoalbundle/{sggoalbundleId}")]
        public IEnumerable<ArtifactBundleModel> GetArtifactBundlesForStudentGrowthGoalBundle(long sggoalbundleId)
        {
            return studentGrowthGoalBundleService.GetArtifactBundlesForStudentGrowthGoalBundle(sggoalbundleId);
        }

        [Route("api/{evaluationId}/sggoalbundles")]
        public IEnumerable<StudentGrowthGoalBundleModel> GetStudentGrowthGoalBundlesForEvaluation(long evaluationId)
        {
            return studentGrowthGoalBundleService.GetStudentGrowthGoalBundlesForEvaluation(evaluationId);
        }

        [Route("api/{evaluationId}/sggoalbundles/inprogress")]
        public IEnumerable<StudentGrowthGoalBundleModel> GetInProgressStudentGrowthGoalBundlesForEvaluation(long evaluationId)
        {
            return studentGrowthGoalBundleService.GetInProgressStudentGrowthGoalBundlesForEvaluation(evaluationId);
        }

        [Route("api/{evaluationId}/sggoalbundles/submitted")]
        public IEnumerable<StudentGrowthGoalBundleModel> GetSubmittedStudentGrowthGoalBundlesForEvaluation(long evaluationId)
        {
            return studentGrowthGoalBundleService.GetSubmittedStudentGrowthGoalBundlesForEvaluation(evaluationId);
        }

        [Route("api/sggoals/{id}")]
        public StudentGrowthGoalModel GetStudentGrowthGoalById(long id)
        {
            return studentGrowthGoalBundleService.GetStudentGrowthGoalById(id);
        }

        [Route("api/sggoalbundles/{id}")]
        public StudentGrowthGoalBundleModel GetStudentGrowthGoalBundleById(long id)
        {
            return studentGrowthGoalBundleService.GetStudentGrowthGoalBundleById(id);
        }

        [Route("api/{evaluationId}/sggoals")]
        [HttpPut]
        public void UpdateStudentGrowthGoal(StudentGrowthGoalModel studentGrowthGoalModel)
        {
            studentGrowthGoalBundleService.UpdateStudentGrowthGoal(studentGrowthGoalModel);
        }

        [Route("api/{evaluationId}/sggoalbundles")]
        [HttpPut]
        public void UpdateStudentGrowthGoalBundle(StudentGrowthGoalBundleModel studentGrowthGoalBundleModel)
        {
           studentGrowthGoalBundleService.UpdateStudentGrowthGoalBundle(studentGrowthGoalBundleModel);
        }

        [Route("api/{evaluationId}/sggoalbundles")]
        [HttpPost]
        public object CreateStudentGrowthGoalBundle(StudentGrowthGoalBundleModel studentGrowthGoalBundleModel)
        {
            return studentGrowthGoalBundleService.CreateStudentGrowthGoalBundle(studentGrowthGoalBundleModel);
        }

        [Route("api/sggoalbundles/{id}")]
        [HttpDelete]
        public HttpResponseMessage DeleteStudentGrowthGoalBundle(long id)
        {
            studentGrowthGoalBundleService.DeleteStudentGrowthGoalBundle(id);
            return Request.CreateResponse(HttpStatusCode.OK);
        }
    }
}
