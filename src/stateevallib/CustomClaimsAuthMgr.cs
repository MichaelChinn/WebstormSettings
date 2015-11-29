using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.IdentityModel.Claims;
using System.Collections;
using EDSIntegrationLib;
using StateEval.Security;


namespace StateEval
{
    class CustomClaimsAuthMgr : ClaimsAuthenticationManager
    {
        public Hashtable RoleTranslator { get { return _roleXlate; } }
        Hashtable _roleXlate = new Hashtable();
        public void HydrateEDSRoleHashtable()
        {
            if (!_roleXlate.ContainsKey(EdsIdentity.RoleSuperAdmin)) _roleXlate.Add(EdsIdentity.RoleSuperAdmin, UserRole.SESuperAdmin);
            if (!_roleXlate.ContainsKey(EdsIdentity.RoleStateAdmin)) _roleXlate.Add(EdsIdentity.RoleStateAdmin, UserRole.SEStateAdmin);

            if (!_roleXlate.ContainsKey(EdsIdentity.RoleDistrictAdmin)) _roleXlate.Add(EdsIdentity.RoleDistrictAdmin, UserRole.SEDistrictAdmin);
            if (!_roleXlate.ContainsKey(EdsIdentity.RoleDistrictEvaluator)) _roleXlate.Add(EdsIdentity.RoleDistrictEvaluator, UserRole.SEDistrictEvaluator);
            if (!_roleXlate.ContainsKey(EdsIdentity.RoleDistrictTeacherEvaluator)) _roleXlate.Add(EdsIdentity.RoleDistrictTeacherEvaluator, UserRole.SEDistrictWideTeacherEvaluator);

            if (!_roleXlate.ContainsKey(EdsIdentity.RoleSchoolAdmin)) _roleXlate.Add(EdsIdentity.RoleSchoolAdmin, UserRole.SESchoolAdmin);
            if (!_roleXlate.ContainsKey(EdsIdentity.RoleHeadPrincipal)) _roleXlate.Add(EdsIdentity.RoleHeadPrincipal, UserRole.SESchoolHeadPrincipal);
            if (!_roleXlate.ContainsKey(EdsIdentity.RoleSchoolPrincipal)) _roleXlate.Add(EdsIdentity.RoleSchoolPrincipal, UserRole.SESchoolPrincipal);

            if (!_roleXlate.ContainsKey(EdsIdentity.RoleSchoolTeacher)) _roleXlate.Add(EdsIdentity.RoleSchoolTeacher, UserRole.SESchoolTeacher);
            if (!_roleXlate.ContainsKey(EdsIdentity.RoleDistrictViewer)) _roleXlate.Add(EdsIdentity.RoleDistrictViewer, UserRole.SEDistrictViewer);
            if (!_roleXlate.ContainsKey(EdsIdentity.RoleDistrictAssignmentManager)) _roleXlate.Add(EdsIdentity.RoleDistrictAssignmentManager, UserRole.SEDistrictAssignmentManager);
        }

        public bool DummyRoleChecker(string locality, string role)
        {
            return true;
        }
        public override IClaimsPrincipal Authenticate(string resourceName, IClaimsPrincipal incomingPrincipal)
        {
            SEMgr mgr = new SEMgr();
            HydrateEDSRoleHashtable();
            if (!incomingPrincipal.Identity.IsAuthenticated)
                return (incomingPrincipal);
            ClaimCollection incomingClaims = incomingPrincipal.Identities[0].Claims;

            mgr.ProcessClaimsAndSetupUser(_roleXlate, incomingClaims);

            return incomingPrincipal;
        }
    }
}


