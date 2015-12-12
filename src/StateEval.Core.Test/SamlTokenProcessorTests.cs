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

            Assert.AreEqual(roleData.Count, stp.RolesAtList.Count);

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
                {"North Thurston High School;3010", new List<string>(){ TokenProcessorReferences.EDSRoleSchoolTeacher}}
            };

            ClaimsIdentity incomingClaims = GenerateToken(myUserData, roleData);

            TokenProcessor tp = new TokenProcessor(TokenProcessorReferences.RoleXlate, incomingClaims.Claims);
            Verify(myUserData, roleData, tp);
        }

        [TestMethod]
        public void HeadPrincipalGetsSchoolPrincipalIfNecessary()
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
               {"North Thurston High School;3010", new List<string>(){ TokenProcessorReferences.EDSRoleSchoolHeadPrincipal}},
                {"South Bay Elementary;2754",  new List<string>(){ TokenProcessorReferences.EDSRoleSchoolHeadPrincipal, TokenProcessorReferences.EDSRoleSchoolAdmin}}
            };

            ClaimsIdentity incomingClaims = GenerateToken(myUserData, roleData);

            TokenProcessor tp = new TokenProcessor(TokenProcessorReferences.RoleXlate, incomingClaims.Claims);

            Dictionary<string, List<string>> expectedData = new Dictionary<string, List<string>>()
            {
               {"North Thurston High School;3010", new List<string>(){ TokenProcessorReferences.EDSRoleSchoolHeadPrincipal, TokenProcessorReferences.EDSRoleSchoolPrincipal}},
                {"South Bay Elementary;2754",  new List<string>(){ TokenProcessorReferences.EDSRoleSchoolHeadPrincipal,TokenProcessorReferences.EDSRoleSchoolPrincipal, TokenProcessorReferences.EDSRoleSchoolAdmin}}
            };


            Verify(myUserData, expectedData, tp);
        }

        [TestMethod]
        public void NoDuplicateRolesAllowed()
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
               {"North Thurston High School;3010", new List<string>(){ TokenProcessorReferences.EDSRoleSchoolHeadPrincipal, TokenProcessorReferences.EDSRoleSchoolHeadPrincipal}},
                {"South Bay Elementary;2754",  new List<string>(){ TokenProcessorReferences.EDSRoleSchoolAdmin, TokenProcessorReferences.EDSRoleSchoolAdmin}},
                {"Othello School District;01147",  new List<string>(){ TokenProcessorReferences.EDSRoleDistrictTeacherEvaluator, TokenProcessorReferences.EDSRoleDistrictTeacherEvaluator}}
            };

            ClaimsIdentity incomingClaims = GenerateToken(myUserData, roleData);

            TokenProcessor tp = new TokenProcessor(TokenProcessorReferences.RoleXlate, incomingClaims.Claims);

            Dictionary<string, List<string>> expected = new Dictionary<string, List<string>>()
            {
               {"North Thurston High School;3010", new List<string>(){ TokenProcessorReferences.EDSRoleSchoolHeadPrincipal, TokenProcessorReferences.EDSRoleSchoolPrincipal}},
                {"South Bay Elementary;2754",  new List<string>(){ TokenProcessorReferences.EDSRoleSchoolAdmin}},
                {"Othello School District;01147",  new List<string>(){  TokenProcessorReferences.EDSRoleDistrictTeacherEvaluator}}
            };

            Verify(myUserData, expected, tp);
        }

        [TestMethod]
        public void NoSchoolRolesInDistrictAllowed()
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
               {"North Thurston High School;3010", new List<string>(){ TokenProcessorReferences.EDSRoleDistrictAdmin, TokenProcessorReferences.EDSRoleSchoolAdmin}},
                {"South Bay Elementary;2754",  new List<string>(){ TokenProcessorReferences.EDSRoleDistrictViewer, TokenProcessorReferences.EDSRoleSchoolPrincipal}},
            };

            ClaimsIdentity incomingClaims = GenerateToken(myUserData, roleData);

            TokenProcessor tp = new TokenProcessor(TokenProcessorReferences.RoleXlate, incomingClaims.Claims);

            Dictionary<string, List<string>> expected = new Dictionary<string, List<string>>()
            {
               {"North Thurston High School;3010", new List<string>(){TokenProcessorReferences.EDSRoleSchoolAdmin}},
                {"South Bay Elementary;2754",  new List<string>(){ TokenProcessorReferences.EDSRoleSchoolPrincipal}},
            };

            Verify(myUserData, expected, tp);
        }

        [TestMethod]
        public void NoDistrictRolesInSchoolAllowed()
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
               {"North Thurston Public Schools;34003",  new List<string>(){  TokenProcessorReferences.EDSRoleDistrictTeacherEvaluator, TokenProcessorReferences.EDSRoleSchoolTeacher}},
            };

            ClaimsIdentity incomingClaims = GenerateToken(myUserData, roleData);

            TokenProcessor tp = new TokenProcessor(TokenProcessorReferences.RoleXlate, incomingClaims.Claims);

            Dictionary<string, List<string>> expected = new Dictionary<string, List<string>>()
            {
               {"North Thurston Public Schools;34003",  new List<string>(){  TokenProcessorReferences.EDSRoleDistrictTeacherEvaluator}},
            };

            Verify(myUserData, expected, tp);
        }



        TokenProcessor GetTPForLocationRole(Dictionary<string, string>userData, string location, List<string>roleString)
        {
            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>();
            roleData.Add(location, roleString);
            
            ClaimsIdentity incomingClaims = GenerateToken(userData, roleData);

            return new TokenProcessor(TokenProcessorReferences.RoleXlate, incomingClaims.Claims);
        }

        [TestMethod]
        public void EDSRolesAreMappedCorrectly()
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

            TokenProcessor tp;
            tp = GetTPForLocationRole(myUserData, "North Thurston Public Schools;34003", new List<string>() { TokenProcessorReferences.EDSRoleDistrictAdmin });
            Assert.IsTrue(tp.RolesAtList[0].RoleList.Contains("SEDistrictAdmin"));
            Assert.AreEqual(1, tp.RolesAtList[0].RoleList.Count);
            
            tp = GetTPForLocationRole(myUserData, "North Thurston Public Schools;34003", new List<string>() { TokenProcessorReferences.EDSRoleDistrictAssignentManager });
            Assert.IsTrue(tp.RolesAtList[0].RoleList.Contains("SEDistrictAssignmentManager"));
            Assert.AreEqual(1, tp.RolesAtList[0].RoleList.Count);
         
            tp = GetTPForLocationRole(myUserData, "North Thurston Public Schools;34003", new List<string>() { TokenProcessorReferences.EDSRoleDistrictEvaluator });
            Assert.IsTrue(tp.RolesAtList[0].RoleList.Contains("SEDistrictEvaluator"));
            Assert.AreEqual(1, tp.RolesAtList[0].RoleList.Count);
          
            tp = GetTPForLocationRole(myUserData, "North Thurston Public Schools;34003", new List<string>() { TokenProcessorReferences.EDSRoleDistrictTeacherEvaluator });
            Assert.IsTrue(tp.RolesAtList[0].RoleList.Contains("SEDistrictWideTeacherEvaluator"));
            Assert.AreEqual(1, tp.RolesAtList[0].RoleList.Count);
         
            tp = GetTPForLocationRole(myUserData, "North Thurston Public Schools;34003", new List<string>() { TokenProcessorReferences.EDSRoleDistrictViewer });  
            Assert.IsTrue(tp.RolesAtList[0].RoleList.Contains("SEDistrictViewer"));
            Assert.AreEqual(1, tp.RolesAtList[0].RoleList.Count);

            tp = GetTPForLocationRole(myUserData, "North Thurston High School;3010",  new List<string>() {TokenProcessorReferences.EDSRoleSchoolAdmin         }); 
            Assert.IsTrue(tp.RolesAtList[0].RoleList.Contains("SESchoolAdmin"));
            Assert.AreEqual(1, tp.RolesAtList[0].RoleList.Count);

            tp = GetTPForLocationRole(myUserData, "North Thurston High School;3010",  new List<string>() {TokenProcessorReferences.EDSRoleSchoolHeadPrincipal });
            Assert.IsTrue(tp.RolesAtList[0].RoleList.Contains("SESchoolHeadPrincipal"));
            Assert.AreEqual(2, tp.RolesAtList[0].RoleList.Count);  //!! head principal resolves to **2*** roles
         
            tp = GetTPForLocationRole(myUserData, "North Thurston High School;3010",  new List<string>() {TokenProcessorReferences.EDSRoleSchoolPrincipal     });
            Assert.IsTrue(tp.RolesAtList[0].RoleList.Contains("SESchoolPrincipal"));
            Assert.AreEqual(1, tp.RolesAtList[0].RoleList.Count);

            tp = GetTPForLocationRole(myUserData, "North Thurston High School;3010",  new List<string>() {TokenProcessorReferences.EDSRoleSchoolTeacher       });
            Assert.IsTrue(tp.RolesAtList[0].RoleList.Contains("SESchoolTeacher"));
            Assert.AreEqual(1, tp.RolesAtList[0].RoleList.Count);

            tp = GetTPForLocationRole(myUserData, "North Thurston High School;3010",  new List<string>() {TokenProcessorReferences.EDSRoleSchoolLibrarian     });
            Assert.IsTrue(tp.RolesAtList[0].RoleList.Contains("SESchoolLibrarian"));
            Assert.AreEqual(1, tp.RolesAtList[0].RoleList.Count);


        }

    }
}
