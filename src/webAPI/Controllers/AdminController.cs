using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;

using System.Data.SqlClient;
using StateEval.Core.Models;
using System.Net.Http;
using System.Web.Http;
using System.Net;
using System.Web.Http.Routing;

using StateEval.Core.Services;
using StateEval.Core.Constants;
using webAPI.Models;

namespace WebAPI.Controllers
{
    public class AdminController : BaseApiController
    {

        private readonly EDSImportInfoService _edsImportInfoService = new EDSImportInfoService();
        public AdminController()
        {
        }

        [Route("api/dteassignmentrequests/{schoolYear}/{districtCode}/{dteId}")]
        [HttpGet]
        public IEnumerable<EvalAssignmentRequestModel> GetEvalAssignmentRequestsForDTE(short schoolYear, string districtCode, long dteId)
        {
            AssignmentsService assignmentsService = new AssignmentsService();
            return assignmentsService.GetEvalAssignmentRequestsForDTE(schoolYear, districtCode, dteId);
        }

        [Route("api/dteassignmentrequestsforschool/{schoolYear}/{districtCode}/{schoolCode}")]
        [HttpGet]
        public IEnumerable<EvalAssignmentRequestModel> GetEvalAssignmentRequestForSchool(short schoolYear, string districtCode, string schoolCode)
        {
            AssignmentsService assignmentsService = new AssignmentsService();
            return assignmentsService.GetEvalAssignmentRequestForSchool(schoolYear, districtCode, schoolCode);
        }

        [Route("api/dteassignmentrequest")]
        [HttpPost]
        public object CreateEvalAssignmentRequestForDTE(EvalAssignmentRequestModel requestModel)
        {
            AssignmentsService assignmentsService = new AssignmentsService();
            return assignmentsService.CreateEvalAssignmentRequestForDTE(requestModel);
        }

        [Route("api/dteassignmentrequest")]
        [HttpPut]
        public void UpdateEvalAssignmentRequestForDTE(EvalAssignmentRequestModel requestModel)
        {
            AssignmentsService assignmentsService = new AssignmentsService();
            assignmentsService.UpdateEvalAssignmentRequestForDTE(requestModel);
        }


        [Route("api/dteassignmentrequest/{id}")]
        [HttpDelete]
        public HttpResponseMessage DeleteAssignmentRequestForDTE(long id)
        {
            AssignmentsService assignmentsService = new AssignmentsService();
            assignmentsService.DeleteAssignmentRequestForDTE(id);
            return Request.CreateResponse(HttpStatusCode.OK);
        }

        [Route("api/assignevaluator")]
        [HttpPost]
        public void AssignEvaluator(AssignmentRequestModel requestModel)
        {
            AssignmentsService assignmentsService = new AssignmentsService();
            assignmentsService.AssignEvaluator(requestModel.SchoolYear, requestModel.DistrictCode, requestModel.EvaluationType,
                requestModel.EvaluateeId, requestModel.EvaluatorId);
        }

        [Route("api/delegateassignments")]
        [HttpPost]
        public void DelegateAssignments(AssignmentRequestModel requestModel)
        {
            AssignmentsService assignmentsService = new AssignmentsService();
            assignmentsService.DelegateAssignments(requestModel.SchoolYear, requestModel.DistrictCode, requestModel.SchoolCode, requestModel.DelegateTeacherAssignments);
        }

        [Route("api/delegateassignments/{schoolYear}/{districtCode}/{schoolCode}")]
        [HttpGet]
        public bool DistrictDelegatedTeacherAssignmentsForSchool(SESchoolYearEnum schoolYear, string districtCode, string schoolCode)
        {
            AssignmentsService assignmentsService = new AssignmentsService();
            return assignmentsService.DistrictDelegatedTeacherAssignmentsForSchool(schoolYear, districtCode, schoolCode);
        }

        [Route("api/assignplantype/comprehensive")]
        [HttpPost]
        public void AssignComprehensiveEvaluateePlanType(AssignmentRequestModel requestModel)
        {
            AssignmentsService assignmentsService = new AssignmentsService();
            assignmentsService.AssignEvaluateePlanType(requestModel.SchoolYear, requestModel.DistrictCode, requestModel.EvaluationType,
                requestModel.EvaluateeId, SEEvaluateePlanTypeEnum.COMPREHENSIVE, null, null);
        }

        [Route("api/assignplantype/focused")]
        [HttpPost]
        public void AssignFocusedEvaluateePlanType(AssignmentRequestModel requestModel)
        {
            AssignmentsService assignmentsService = new AssignmentsService();
            assignmentsService.AssignEvaluateePlanType(requestModel.SchoolYear, requestModel.DistrictCode, requestModel.EvaluationType,
                requestModel.EvaluateeId, SEEvaluateePlanTypeEnum.FOCUSED, requestModel.FocusFrameworkNodeId, requestModel.SGFocusFrameworkNodeId);
        }

        [Route("api/principalsforassignment/schoolyear/{schoolyear}/district/{districtCode}")]
        [HttpGet]
        public IEnumerable<UserModel> GetPrincipalsForAssignment(SESchoolYearEnum schoolYear, string districtCode)
        {
            AssignmentsService assignmentsService = new AssignmentsService();
            return assignmentsService.GetPrincipalsForAssignment(schoolYear, districtCode);
        }

        [Route("api/teachersforassignment/schoolyear/{schoolyear}/district/{districtCode}/school/{schoolCode}")]
        [HttpGet]
        public IEnumerable<UserModel> GetPrincipalsForAssignment(SESchoolYearEnum schoolYear, string districtCode, string schoolCode)
        {
            AssignmentsService assignmentsService = new AssignmentsService();
            return assignmentsService.GetTeachersForAssignment(schoolYear, districtCode, schoolCode);
        }


        [Route("api/admin/importErrorRecords")]
        public List<EDSErrorModel> GetImportErrorRecords()
        {
            return _edsImportInfoService.GetEDSErrors();
        }

        [Route("api/admin/importStagingRecords/{lastName}")]
        public List<EDSUserLocationRoleModel> GetImportItemsForLastName(string lastName)
        {
            return _edsImportInfoService.GetEDSUserLocationRoleForLastName(lastName);
        }

        /*
        [Route("api/admin/importStagingRecords/{lastName}")]
        public IEnumerable<ImportStagingRecordModel> GetImportStagingRecords(string lastName)
        {
            string qStaging = qBase + " where lastname = '" + lastName + "'";

            SqlDataReader r = null;
            List<ImportStagingRecordModel> list = new List<ImportStagingRecordModel>();
            try
            {
                r = SEMgr.Instance.DbConnector.ExecuteNonSpDataReader(qStaging);
                while (r.Read())
                {
                    ImportStagingRecordModel m = new ImportStagingRecordModel();
                    m.FirstName = Convert.ToString(r["FirstName"]);
                    m.LastName = Convert.ToString(r["LastName"]);
                    m.Email = Convert.ToString(r["Email"]);
                    m.OSPILegacyCode = Convert.ToString(r["OSPILegacyCode"]);
                    m.DistrictCode = Convert.ToString(r["DistrictCode"]);
                    m.SchoolCode = Convert.ToString(r["SchoolCode"]);
                    m.LocationName = Convert.ToString(r["LocationName"]);
                    m.RawRoleString = Convert.ToString(r["RawRoleString"]);

                    list.Add(m);
                }
            }
            catch (Exception) { }
            finally
            {
                if (r != null)
                    r.Close();
            }

            return list;
        }*/
    }
}
