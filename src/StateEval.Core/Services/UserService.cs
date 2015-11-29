using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Security.Cryptography;
using StateEval.Core.Constants;
using StateEval.Core.Mapper;
using StateEval.Core.Models;
using StateEval.Core.RequestModel;
using StateEvalData;

using System.Data.SqlClient;
using System.Data;

using StateEval.Core.Utils;

namespace StateEval.Core.Services
{
    public class UserService : BaseService
    {
        public List<UserOrientationModel> GetUserOrientationsForUser(long userId)
        {
            List<UserOrientationModel> list = new List<UserOrientationModel>();

            var orientations = EvalEntities.vUserOrientations.Where(x => x.SEUserID == userId);
            foreach (vUserOrientation x in orientations)
            {
                list.Add(x.MapToUserOrientationModel());
            }

            return list;
        }

        public UserModel AuthenticateUser(AuthDataModel authData)
        {
            SEUser user = EvalEntities.SEUsers.FirstOrDefault(x => x.aspnet_Users.LoweredUserName == authData.Username.ToLower());

            if (user != null)
            {
                UserModel userModel = user.MapToUserModel(null);
                userModel.UserOrientations = GetUserOrientationsForUser(userModel.Id);
                return userModel;
            }

            return null;
        }

        public UserModel GetUserById(long userId)
        {
            SEUser user = EvalEntities.SEUsers.FirstOrDefault(x => x.SEUserID == userId);

            if (user != null)
            {
                return user.MapToUserModel(null);
            }

            return null;
        }

        public IEnumerable<UserModel> GetUsersInRoleAtSchool(string districtCode, string schoolCode, string roleName)
        {
            IQueryable<SEUser> users = EvalEntities.SEUsers
                .Where(u => u.SEUserLocationRoles.Any(r => r.RoleName == roleName && r.SchoolCode==schoolCode))
                .OrderBy(u => new { u.LastName, u.FirstName });

            return users.ToList().Select(x => x.MapToUserModel(null));
        }


        public IEnumerable<UserModel> GetUsersInRoleAtDistrict(string districtCode, string roleName)
        {
            IQueryable<SEUser> users = EvalEntities.SEUsers
                .Where(u => u.SEUserLocationRoles.Any(r => r.RoleName == roleName && r.SchoolCode == "" && r.DistrictCode == districtCode))
                .OrderBy(u => new { u.LastName, u.FirstName });

            return users.ToList().Select(x => x.MapToUserModel(null));
        }

        public IEnumerable<UserModel> GetUsersInRoleInDistrictBuildings(string districtCode, string roleName)
        {
            IQueryable<SEUser> users = EvalEntities.SEUsers
                .Where(u => u.SEUserLocationRoles.Any(r => r.RoleName == roleName && r.SchoolCode == "" && r.DistrictCode == districtCode))
                .OrderBy(u => new { u.LastName, u.FirstName });


            return users.ToList().Select(x => x.MapToUserModel(null));
        }

        public IEnumerable<UserModel> GetObserveEvaluateesForDTEEvaluator(short schoolYear, string districtCode, long evaluatorId)
        {
            short evalAssignmentRequestStatus = Convert.ToInt16(SEEvalRequestStatusEnum.ACCEPTED);
            short evalRequestType = Convert.ToInt16(SEEvalRequestTypeEnum.OBSERVATION_ONLY);
            short evalType = Convert.ToInt16(SEEvaluationTypeEnum.TEACHER);

            IQueryable<SEUser> users = EvalEntities.SEUsers

                .Where(u => u.SEUserLocationRoles.Any(r => r.RoleName == RoleName.SESchoolTeacher && r.SchoolCode == "" && r.DistrictCode == districtCode))
                .Where(u => u.SEEvaluations.Any(e => e.EvaluateeID == u.SEUserID
                                                && e.SchoolYear == schoolYear
                                                && e.EvaluationTypeID == evalType
                                                && e.DistrictCode == districtCode))
                //TODO: change the name of the FK so we can differentiate between the evaluator and evaluatee FK
                .Where(u => u.SEEvalAssignmentRequests1.Any(r => r.Status == evalAssignmentRequestStatus
                                                                && ((r.RequestTypeID == (short)(SEEvalRequestTypeEnum.OBSERVATION_ONLY)) ||
                                                                    (r.RequestTypeID == (short)(SEEvalRequestTypeEnum.ASSIGNED_EVALUATOR)))
                                                                && r.EvaluateeID == u.SEUserID
                                                                && r.EvaluatorID == evaluatorId))
                .OrderBy(u => new { u.LastName, u.FirstName });

            return users.ToList().Select(x => x.MapToUserModel(new CoreRequestModel((SESchoolYearEnum)schoolYear, districtCode, "", SEEvaluationTypeEnum.TEACHER)));
        }

        IEnumerable<UserModel> GetEvaluateesInSchool(short schoolYear, string districtCode, string schoolCode, long evaluatorId, bool assignedOnly, bool includeEvalData, short evalType, string roleName)
        {
            IQueryable<SEUser> users = EvalEntities.SEUsers
                .Where(u => u.SEUserLocationRoles.Any(r => r.RoleName == roleName && r.SchoolCode == schoolCode && r.DistrictCode == districtCode))
                .Where(u => u.SEEvaluations.Any(e => e.EvaluateeID == u.SEUserID
                                                && e.SchoolYear == schoolYear
                                                && e.EvaluationTypeID == evalType
                                                && e.DistrictCode == districtCode
                                                && (!assignedOnly || e.EvaluatorID == evaluatorId)))
                .Where(u => u.SEUserID != evaluatorId)
                .OrderBy(u => new { u.LastName, u.FirstName });

            return users.ToList().Select(x => x.MapToUserModel(new CoreRequestModel((SESchoolYearEnum)schoolYear, districtCode, "", (SEEvaluationTypeEnum)evalType)));
        }

        IEnumerable<UserModel> GetPrincipalsInDistrict(short schoolYear, string districtCode, long evaluatorId, bool assignedOnly, bool includeEvalData)
        {
            IQueryable<SEUser> users = EvalEntities.SEUsers
                .Where(u => u.SEUserLocationRoles.Any(r => r.RoleName == RoleName.SESchoolPrincipal && r.DistrictCode == districtCode))
                .Where(u => u.SEEvaluations.Any(e => e.EvaluateeID == u.SEUserID
                                                && e.SchoolYear == schoolYear
                                                && e.EvaluationTypeID == (short)SEEvaluationTypeEnum.PRINCIPAL
                                                && e.DistrictCode == districtCode
                                                && (!assignedOnly || e.EvaluatorID == evaluatorId)))
                .Where(u => u.SEUserID != evaluatorId)
                .OrderBy(u => new { u.LastName, u.FirstName });

            CoreRequestModel requestModel = null;
            if (includeEvalData)
            {
                requestModel = new CoreRequestModel((SESchoolYearEnum)schoolYear, districtCode, "", SEEvaluationTypeEnum.PRINCIPAL);
            }

            return users.ToList().Select(x => x.MapToUserModel(requestModel));
        }

        public IEnumerable<UserModel> GetEvaluateesForPR_TR(short schoolYear, string districtCode, string schoolCode, long evaluatorId, bool assignedOnly, bool includeEvalData)
        {
            return GetEvaluateesInSchool(schoolYear, districtCode, schoolCode, evaluatorId, assignedOnly, includeEvalData,
                                        (short)SEEvaluationTypeEnum.TEACHER, StateEval.Core.Constants.RoleName.SESchoolTeacher);
        }

        public IEnumerable<UserModel> GetEvaluateesForPR_PR(short schoolYear, string districtCode, string schoolCode, long evaluatorId, bool assignedOnly, bool includeEvalData)
        {
            return GetEvaluateesInSchool(schoolYear, districtCode, schoolCode, evaluatorId, assignedOnly, includeEvalData,
                                        (short)SEEvaluationTypeEnum.PRINCIPAL, StateEval.Core.Constants.RoleName.SESchoolPrincipal);
        }

        public IEnumerable<UserModel> GetEvaluateesForDE_PR(short schoolYear, string districtCode, string schoolCode, long evaluatorId, bool assignedOnly, bool includeEvalData)
        {
            return GetPrincipalsInDistrict(schoolYear, districtCode, evaluatorId, assignedOnly, includeEvalData);
        }


        public long InsertOrFindSeUserId(long edsPersonId, string lastName, string firstName, string eMail, string certNo, bool hasMultipleLocations)
        {
            /*string sqlCmd = string.Format(
                "exec InsertSEUser @pUserName = '{0}', @pFirstName = '{1}', @pLastName = '{2}', @pEmail = '{3}', @pCertNo = '{4}', @pHasMultipleLocations = {5}"
                , edsPersonId.ToString() + "_edsUser"
                , firstName
                , lastName
                , eMail
                , certNo
                , hasMultipleLocations);

            long seUserId = EvalEntities.Database.ExecuteSqlCommand(sqlCmd);
             * */
            SqlParameter seUserParameter = new SqlParameter("@pSEUserIdOut", -1);
            seUserParameter.Direction = System.Data.ParameterDirection.Output;

            var lParams = new List<SqlParameter>{
                new SqlParameter("@pUserName", edsPersonId.ToString() + "_edsUser")
                ,new SqlParameter("@pFirstName", firstName)
                ,new SqlParameter("@pLastName", lastName)
                ,new SqlParameter("@pEmail", eMail)
                ,new SqlParameter("@pCertNo", certNo)
                ,new SqlParameter("@pHasmultipleLocations", hasMultipleLocations)
                ,seUserParameter
            };

            EvalEntities.Database.ExecuteSqlCommand(
                "FindInsertUpdateSeUser @pUserName, @pFirstName, @pLastName, @pEMail, @pCertNo, @pHasMultipleLocations, @pSEUserIdOut OUTPUT"
                , lParams.ToArray());

            long seUserId = Convert.ToInt64(seUserParameter.Value);
            return seUserId;
        }

        public void InsertUpdateUserReferenceTables(long edsPersonId, string locationRoleString)
        {
            string sqlCmd = string.Format(
                "exec InsertUserReferenceTables @pUserName = '{0}', @pLRString = '{1}'"
                , edsPersonId.ToString() + "_edsUser"
                , locationRoleString);

            EvalEntities.Database.ExecuteSqlCommand(sqlCmd);
        }

        public void PersistOTPW(string userName, string password)
        {
            var hash = SecurePasswordHasher.Hash(password);
            string sqlCmd = string.Format("exec SaveOTPW @pUserName = '{0}', @pPWHash = '{1}'", userName, hash);
            EvalEntities.Database.ExecuteSqlCommand(sqlCmd);
        }

        public bool VerifyHashedOTPW(string userName, string password)
        {
            SqlParameter pwHashOut = new SqlParameter("@pPWHashOut", "");
            pwHashOut.Direction = System.Data.ParameterDirection.Output;
            pwHashOut.Size = 500;

            var lParams = new List<SqlParameter> {
                new SqlParameter("@pUserName", userName)
                ,pwHashOut
            };

            EvalEntities.Database.ExecuteSqlCommand(
                "FetchOTPW @pUserName, @pPWHashOut OUTPUT", lParams.ToArray()
                );

            string hash = (string)pwHashOut.Value; // go get the hash from the database based on the userName
            return SecurePasswordHasher.Verify(password, hash);
        }
        public bool VerifyHashedMembershipPW(string userName, string password)
        {
            SqlParameter pwHashOut = new SqlParameter("@pPWHashOut", "");
            pwHashOut.Direction = System.Data.ParameterDirection.Output;
            pwHashOut.Size = 500;

            SqlParameter salt = new SqlParameter("@pSalt", "");
            salt.Direction = System.Data.ParameterDirection.Output;
            salt.Size = 500;

            var lParams = new List<SqlParameter> {
                new SqlParameter("@pUserName", userName)
                ,new SqlParameter("@pPasswordFormat", 1)
                ,pwHashOut
                ,salt
            };

            EvalEntities.Database.ExecuteSqlCommand(
                "FetchMembershipPW @pUserName, @pPasswordFormat, @pPWHashOut OUTPUT, @pSalt OUTPUT", lParams.ToArray()
                );

            return MembershipPasswordHasher.Verify(password, (string)salt.Value, (string)pwHashOut.Value);
        }
        public void RemoveOTPW(string userName)
        {
            string sqlCmd = string.Format("exec RemoveOTPW @pUserName = '{0}'", userName);
            EvalEntities.Database.ExecuteSqlCommand(sqlCmd);
        }

        public ClientApp FindClientApp(string ClientAppId)
        {
            var ClientApp = EvalEntities.ClientApps.Find(ClientAppId);

            return ClientApp;
        }

        public async Task<bool> AddRefreshToken(RefreshToken token)
        {

            var existingToken = EvalEntities.RefreshTokens.Where(r => r.Subject == token.Subject && r.ClientAppId == token.ClientAppId).SingleOrDefault();

            if (existingToken != null)
            {
                var result = await RemoveRefreshToken(existingToken);
            }

            EvalEntities.RefreshTokens.Add(token);

            return await EvalEntities.SaveChangesAsync() > 0;
        }

        public async Task<bool> RemoveRefreshToken(string refreshTokenId)
        {
            var refreshToken = await EvalEntities.RefreshTokens.FindAsync(refreshTokenId);

            if (refreshToken != null)
            {
                EvalEntities.RefreshTokens.Remove(refreshToken);
                return await EvalEntities.SaveChangesAsync() > 0;
            }

            return false;
        }

        public async Task<bool> RemoveRefreshToken(RefreshToken refreshToken)
        {
            EvalEntities.RefreshTokens.Remove(refreshToken);
            return await EvalEntities.SaveChangesAsync() > 0;
        }

        public async Task<RefreshToken> FindRefreshToken(string refreshTokenId)
        {
            var refreshToken = await EvalEntities.RefreshTokens.FindAsync(refreshTokenId);

            return refreshToken;
        }

        public List<RefreshToken> GetAllRefreshTokens()
        {
            return EvalEntities.RefreshTokens.ToList();
        }

        public string GetHash(string input)
        {
            HashAlgorithm hashAlgorithm = new SHA256CryptoServiceProvider();
       
            byte[] byteValue = System.Text.Encoding.UTF8.GetBytes(input);

            byte[] byteHash = hashAlgorithm.ComputeHash(byteValue);

            return Convert.ToBase64String(byteHash);
        }

        public IEnumerable<UserLocationRoleModel> GetLocationRolesForUser(long seUserId)
        {
            IQueryable<SEUserLocationRole> ulrs = EvalEntities.SEUserLocationRoles
                .Where(ulr => ulr.SEUserId == seUserId);

            return ulrs.ToList().Select(x => x.MaptoUserLocationRoleModel(null));
        }

        public UserModel GetUserByUserName(string userName)
        {
            SEUser user = EvalEntities.SEUsers.FirstOrDefault(x => x.Username == userName);

            if (user != null)
            {
                return user.MapToUserModel(null);
            }

            return null;
        }

        public IEnumerable<UserDistrictSchoolModel> GetDistrictSchoolsForUser(long seUserID)
        {
            IQueryable<SEUserDistrictSchool> uds = EvalEntities.SEUserDistrictSchools
                .Where(ulr => ulr.SEUserID == seUserID);

            return uds.ToList().Select(x => x.MaptoUserDistrictSchoolModel(null));

        }
    }
}
