using System;
using System.Linq;
using System.Collections;
using System.Collections.Generic;
using System.Security.Claims;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using StateEval.Core.Utils;


namespace StateEval.Core.Test
{
    [TestClass]
    public class SamlTokenProcessorTests
    {
        #region test specific infrastructure

        Hashtable CCARoleTranslator { get; set; }

        ClaimsIdentity GenerateToken(Dictionary<string, string> tokenData, Dictionary<string, List<string>> roleData)
        {
            ClaimsIdentity retVal = new ClaimsIdentity();
            foreach (var item in tokenData)
            {
                Claim claim = new Claim(item.Key, item.Value, "MyValueType", "LOCALAUTHORITY", "MyOriginalIssuer");
                retVal.AddClaim(claim);
            }

            foreach (var item in roleData)
            {
                string claimValue = item.Key;
                foreach (var role in item.Value)
                {
                    claimValue = claimValue + ";" + role;
                }
                Claim claim = new Claim(MSClaimTypes.Role, claimValue, "MyValueType", "LOCALAUTHORITY", "MyOriginalIssuer");
                retVal.AddClaim(claim);
            }

            return retVal;
        }
        List<string> GetEDSRolesList(Dictionary<string, List<string>> locationRoles)
        {
            List<string> retVal = new List<string>();
            foreach (var item in locationRoles)
            {
                var roles = item.Value;
                foreach (var role in roles)
                    if (!retVal.Contains(role))
                        retVal.Add(role);
            }
            return retVal;
        }
        List<string> GetEDSLocationCodeList(Dictionary<string, List<string>> locationRoles)
        {
            List<string> retVal = new List<string>();

            foreach (var item in locationRoles)
            {
                //the lcoations are: LocationName;locationCode; 
                //got to just get the location code
                string[] tok = item.Key.Split(new char[] { ';' });
                retVal.Add(tok[1]);
            }
            return retVal;
        }

        List<string> GetEDSRolesAt(Dictionary<string, List<string>> locationRoles, string locationCode)
        {
            foreach (var item in locationRoles)
            {
                if (item.Key.Contains(locationCode))
                    return item.Value;
            }
            return null;
        }
        bool AreSame<T>(List<T> l1, List<T> l2)
        {
            if (l1.Count != l2.Count)
                return false;

            foreach (T item in l1)
                if (!l1.Contains(item))
                    return false;

            return true;
        }
        List<string> XLateRoles(List<string> edsRoleList)
        {
            List<string> retVal = new List<string>();

            foreach (var item in edsRoleList)
            {
                //have to xlate the home location, else can't pick home 
                //if (item.Contains("Home"))
                //    continue;
                retVal.Add((string)TokenProcessorReferences.RoleXlate[item]);
            }

            return retVal;
        }
        public void Verify(Dictionary<string, string> inputData
                       , Dictionary<string, List<string>> roleData
                       , TokenProcessor stp)
        {
            /*
                public string EDSUserId { get; private set; }
                public string AppUserName { get; private set; }
                public string OldEDSIds { get; private set; }
                public string FullName { get; private set; }
                public string LastName { get; private set; }
                public string FirstName { get; private set; }
                public string EMail { get; private set; }
                public string SID { get; private set; }
                public string LRString { get; private set; }
                public LocalityRoleContainer LRContainer
             */

            //check the stp Properties against the input data...
            Assert.AreEqual(inputData[MSClaimTypes.Name], stp.EDSPersonId);
            Assert.AreEqual(inputData[MSClaimTypes.GivenName], stp.FullName);
            Assert.AreEqual(inputData[MSClaimTypes.Email], stp.EMail);
            Assert.AreEqual(inputData[MSClaimTypes.Sid], stp.SID);
            Assert.AreEqual(inputData[MSClaimTypes.PPID], stp.CertNo);
            Assert.AreEqual(inputData[MSClaimTypes.NameIdentifier], stp.OldEDSIds);

            Assert.AreEqual(roleData.Count > 1 ? true : false, stp.HasMultipleLocations);

            foreach (RolesAt ra in stp.RolesAtList)
            {
                List<string> xlatedRoles = XLateRoles(roleData[ra.OrgName + ";" + ra.CDSCode]);
                List<string> processedRolesFromTP = ra.RoleList;
                //assert inputRolesAtLocation == resultantRolesAtLocation

                Assert.IsTrue(xlatedRoles.Except(processedRolesFromTP).Count() == 0 &&
                                processedRolesFromTP.Except(xlatedRoles).Count() == 0);
            }

        }

        Dictionary<string, string> _baseUserData
        {
            get
            {
                return new Dictionary<string, string>()
                    {
                        {MSClaimTypes.Name, "134"},       //personId
                        {MSClaimTypes.GivenName, "Public, John Q."},
                        {MSClaimTypes.Email, "fleeble@flooble.com"},
                        {MSClaimTypes.Sid, "Ar3948"},       //unique return identifier
                        {MSClaimTypes.NameIdentifier,""},     //previous personIds
                        {MSClaimTypes.PPID,"28-48492C"}        //cert number
                    };
            }
        }

        List<RolesAt> RoleData2RolesAt(Dictionary<string, List<string>> roleData)
        {
            List<RolesAt> retVal = new List<RolesAt>();
            foreach (string key in roleData.Keys)
            {
                string[] toks = key.Split(new char[] { ';' });
                RolesAt ra = new RolesAt(toks[0], toks[1]);
                ra.RoleList = roleData[key];
            }
            return retVal;
        }

        #endregion


        [TestMethod]
        public void BaseTokenPropertiesAreDetected()
        {

            Dictionary<string, string> myUserData = new Dictionary<string, string>()
                    {
                        {MSClaimTypes.Name, "134"},       //personId
                        {MSClaimTypes.GivenName, "Public, John Q."},
                        {MSClaimTypes.Email, "fleeble@flooble.com"},
                        {MSClaimTypes.Sid, "Ar3948"},       //unique return identifier
                        {MSClaimTypes.NameIdentifier,"X-43942"},     //previous personIds... exclude this
                        {MSClaimTypes.PPID,"28-48492C"}        //cert number
                    };


            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010", new List<string>(){ TokenProcessorReferences.RoleSchoolTeacher}}
            };

            ClaimsIdentity incomingClaims = GenerateToken(myUserData, roleData);

            TokenProcessor tp = new TokenProcessor(TokenProcessorReferences.RoleXlate, incomingClaims.Claims);
            Verify(myUserData, roleData, tp);
        }
        [TestMethod]
        public void MultipleRolesInTokenAreDetected()
        {

            Dictionary<string, string> myUserData = new Dictionary<string, string>()
                    {
                        {MSClaimTypes.Name, "134"},       //personId
                        {MSClaimTypes.GivenName, "Public, John Q."},
                        {MSClaimTypes.Email, "fleeble@flooble.com"},
                        {MSClaimTypes.Sid, "Ar3948"},       //unique return identifier
                        {MSClaimTypes.NameIdentifier,"X-43942"},     //previous personIds... exclude this
                        {MSClaimTypes.PPID,"28-48492C"}        //cert number
                    };


            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
               {"North Thurston High School;3010", new List<string>(){ TokenProcessorReferences.RoleHeadPrincipal}},
                {"South Bay Elementary;2754",  new List<string>(){ TokenProcessorReferences.RoleHeadPrincipal, TokenProcessorReferences.RoleSchoolAdmin}},
                {"Othello School District;01147",  new List<string>(){ TokenProcessorReferences.RoleDistrictTeacherEvaluator, TokenProcessorReferences.RoleSchoolAdmin}}
            };

            ClaimsIdentity incomingClaims = GenerateToken(myUserData, roleData);

            TokenProcessor tp = new TokenProcessor(TokenProcessorReferences.RoleXlate, incomingClaims.Claims);
            Verify(myUserData, roleData, tp);
        }
    }
}
