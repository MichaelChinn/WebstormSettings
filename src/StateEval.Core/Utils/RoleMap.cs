using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections;

namespace StateEval.Core.Utils
{
    public static class TokenProcessorReferences
    {
        public const string Issuer = "eds.ospi.k12.wa.us";

        public const string EdsNameTag = "_edsUser";

        public const string RoleDistrictAdmin = "eValDistrictAdmin";
        public const string RoleDistrictEvaluator = "eValDistrictEvaluator";
        public const string RoleSchoolAdmin = "eValSchoolAdmin";
        public const string RoleSchoolPrincipal = "eValSchoolPrincipal";
        public const string RoleSchoolTeacher = "eValSchoolTeacher";
        public const string RoleStateAdmin = "eValStateAdmin";
        public const string RoleSuperAdmin = "eValSuperAdmin";
        public const string RoleHeadPrincipal = "eValHeadPrincipal";
        public const string RoleDistrictTeacherEvaluator = "eValDistrictTeacherEvaluator";
        public const string RoleDistrictViewer = "eValDistrictViewer";
        public const string RoleDistrictRoleManager = "eValDistrictAssignmentManager";

    



        public const string SESuperAdmin = "SESuperAdmin";
        public const string SEStateAdmin = "SEStateAdmin";
        public const string SEDistrictAdmin = "SEDistrictAdmin";
        public const string SEDistrictViewer = "SEDistrictViewer";
        public const string SESchoolAdmin = "SESchoolAdmin";
        public const string SESchoolPrincipal = "SESchoolPrincipal";
        public const string SESchoolTeacher = "SESchoolTeacher";
        public const string SEDistrictEvaluator = "SEDistrictEvaluator";
        public const string SEESDAdmin = "SEESDAdmin";
        public const string SEPracticeParticipantGuest = "SEPracticeParticipantGuest";
        public const string SETeacherEvaluator = "SETeacherEvaluator";
        public const string SEPrincipalEvaluator = "SEPrincipalEvaluator";
        public const string SECustomSupportL1 = "SECustomerSupportL1";
        public const string SEDistrictRoleManager = "SEDistrictRoleManager";
        public const string SEHomeLocation = "SEHomeLocation";
        public const string SEDistrictWideTeacherEvaluator = "SEDistrictWideTeacherEvaluator";
        public const string SESchoolHeadPrincipal = "SESchoolHeadPrincipal";
        public const string SEDistrictAssignmentManager = "SEDistrictAssignmentManager";


        public static Dictionary<string, bool> IsOkForSchool = new Dictionary<string, bool>()
        {
            {SESchoolAdmin , true},
            {SESchoolPrincipal , true},
            {SESchoolTeacher , true},
            
            {SEPracticeParticipantGuest , true},
            {SETeacherEvaluator , true},
            {SEPrincipalEvaluator , true},
            {SECustomSupportL1 , true},
            
        };



                public static Dictionary<string, bool> IsOkForDistrict = new Dictionary<string, bool>()
        { 
            {SEDistrictAdmin , true},
            {SEDistrictViewer , true},

            {SEDistrictEvaluator , true},
            
            {SEPracticeParticipantGuest , true},
            {SETeacherEvaluator , true},
            {SEPrincipalEvaluator , true},
            
            {SEDistrictRoleManager , true}
        };
        
        public static Dictionary<string, string> RoleXlate = new Dictionary<string, string>()
        {
            {RoleSuperAdmin, SESuperAdmin},
            {RoleStateAdmin, SEStateAdmin},
            
            {RoleDistrictAdmin, SEDistrictAdmin},
            {RoleDistrictEvaluator, SEDistrictEvaluator},
            {RoleDistrictTeacherEvaluator, SEDistrictWideTeacherEvaluator},

            {RoleSchoolAdmin, SESchoolAdmin},
            {RoleHeadPrincipal, SESchoolHeadPrincipal},
            {RoleSchoolPrincipal, SESchoolPrincipal},
            
            {RoleSchoolTeacher, SESchoolTeacher},
            {RoleDistrictViewer, SEDistrictViewer},
            {RoleDistrictRoleManager, SEDistrictAssignmentManager},
        };

        public static Dictionary<string, string> School2District = new Dictionary<string, string>()
        {
            //TODO
        };
    }
}