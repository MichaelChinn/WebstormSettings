using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using System.Configuration;

using System.Data.SqlClient;
using StateEval.Core.Models;
using StateEval.Core.Constants;
using StateEval.Core.Services;
using System.Net.Http;
using System.Web.Http;
using System.Net;
using System.Web.Http.Routing;

using StateEvalData;
using StateEval.Core.Mapper;

namespace WebAPI.Controllers
{
    public class UserController : BaseApiController
    {
        private  readonly UserService userService = new UserService();
        public UserController()
        {
        }

        [Route("api/authenticate")]
        [HttpPost]
        public UserModel AuthenticateUser(AuthDataModel authData)
        {
            return userService.AuthenticateUser(authData);
        }

        [Route("api/users/{userId}")]
        public UserModel GetUserById(long userId)
        {
            return userService.GetUserById(userId);
        }

        [Route("api/users/evaluatees/depr/{schoolYear}/{districtCode}/{evaluatorId}/{assignedOnly}/{includeEvalData}")]
        [HttpGet]
        public IEnumerable<UserModel> GetEvaluateesForDistrictEvaluator(short schoolYear, string districtCode, long evaluatorId, bool assignedOnly, bool includeEvalData)
        {
            return userService.GetEvaluateesForDE_PR(schoolYear, districtCode, "", evaluatorId, assignedOnly, includeEvalData);
        }
     
        [Route("api/users/evaluatees/prtr/{schoolYear}/{districtCode}/{schoolCode}/{evaluatorId}/{assignedOnly}/{includeEvalData}")]
        [HttpGet]
        public IEnumerable<UserModel> GetEvaluateesForPR_TR(short schoolYear, string districtCode, string schoolCode, long evaluatorId, bool assignedOnly, bool includeEvalData)
        {
            return userService.GetEvaluateesForPR_TR(schoolYear, districtCode, schoolCode, evaluatorId, assignedOnly, includeEvalData);
        }

        [Route("api/users/evaluatees/prpr/{schoolYear}/{districtCode}/{schoolCode}/{evaluatorId}/{assignedOnly}/{includeEvalData}")]
        [HttpGet]
        public IEnumerable<UserModel> GetEvaluateesForPR_PR(short schoolYear, string districtCode, string schoolCode, long evaluatorId, bool assignedOnly, bool includeEvalData)
        {
            return userService.GetEvaluateesForPR_PR(schoolYear, districtCode, schoolCode, evaluatorId, assignedOnly, includeEvalData);
        }


        [Route("api/users/dteevaluatees/{schoolYear}/{districtCode}/{evaluatorId}")]
        [HttpGet]
        public IEnumerable<UserModel> GetObserveEvaluateesForDTEEvaluator(short schoolYear, string districtCode, long evaluatorId)
        {
            return userService.GetObserveEvaluateesForDTEEvaluator(schoolYear, districtCode, evaluatorId);
        } 

        [Route("api/usersinroleindistrict/{schoolYear}/district/{districtCode}/{roleName}")]
        [HttpGet]
        public IEnumerable<UserModel> GetUsersInRoleInDistrictBuildings( string districtCode, string roleName)
        {
            return userService.GetUsersInRoleInDistrictBuildings(districtCode, roleName);
        }

        [Route("api/usersinrole/district/{districtCode}/role/{roleName}")]
        [HttpGet]
        public IEnumerable<UserModel> GetUsersInRoleAtDistrict(string districtCode, string roleName)
        {
            return userService.GetUsersInRoleAtDistrict(districtCode, roleName);
        }

        [Route("api/usersinrole/district/{districtCode}/school/{schoolCode}/role/{roleName}")]
        [HttpGet]
        public IEnumerable<UserModel> GetUsersInRoleAtSchool(string districtCode, string schoolCode, string roleName)
        {
            return userService.GetUsersInRoleAtSchool(districtCode, schoolCode, roleName);
        }
        
    }
}
