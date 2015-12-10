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

        //the following comes exactly from the old code base  
        // ...\StateEvalLib\security\EDSIdentity
        //
        //the following has been reordered, and prepended with 'EDS' for clarity
        //..also added the librarian role, new in V2

        //EDS Roles
        //district roles, alphabetically
        public const string EDSRoleDistrictAdmin = "eValDistrictAdmin";
        public const string EDSRoleDistrictAssignentManager = "eValDistrictAssignmentManager";
        public const string EDSRoleDistrictEvaluator = "eValDistrictEvaluator";
        public const string EDSRoleDistrictTeacherEvaluator = "eValDistrictTeacherEvaluator";
        public const string EDSRoleDistrictViewer = "eValDistrictViewer";

        //school roles, hierarchichally
        public const string EDSRoleSchoolAdmin = "eValSchoolAdmin";
        public const string EDSRoleSchoolHeadPrincipal = "eValHeadPrincipal";
        public const string EDSRoleSchoolPrincipal = "eValSchoolPrincipal";
        public const string EDSRoleSchoolTeacher = "eValSchoolTeacher";
        public const string EDSRoleSchoolLibrarian = "eValSchoolLibrarian";

        //never sent from EDS
        public const string EDSRoleStateAdmin = "eValStateAdmin";
        public const string EDSRoleSuperAdmin = "eValSuperAdmin";


        //SERoles from InitRoles in the sql init folder...
        public const string SESuperAdmin = "SESuperAdmin";
        public const string SECustomerSupportL1 = "SECustomerSupportL1";
        public const string SEPracticeParticipantGuest = "SEPracticeParticipantGuest";

        public const string SEDistrictAdmin = "SEDistrictAdmin";
        public const string SEDistrictAssignmentManager = "SEDistrictAssignmentManager";
        public const string SEDistrictEvaluator = "SEDistrictEvaluator";
        public const string SEDistrictWideTeacherEvaluator = "SEDistrictWideTeacherEvaluator";
        public const string SEDistrictViewer = "SEDistrictViewer";

        public const string SESchoolAdmin = "SESchoolAdmin";
        public const string SESchoolHeadPrincipal = "SESchoolHeadPrincipal";
        public const string SESchoolPrincipal = "SESchoolPrincipal";
        public const string SESchoolTeacher = "SESchoolTeacher";
        public const string SESchoolLibrarian = "SESchoolLibrarian";


        public static List<string> SchoolRoles = new List<string>()
        {
            SEPracticeParticipantGuest , 
            SECustomerSupportL1 , 
   
            SESchoolAdmin , 
            SESchoolPrincipal , 
            SESchoolTeacher , 
            SESchoolHeadPrincipal ,
            SESchoolLibrarian
        };

        public static List<string> DistrictRoles = new List<string>()
        { 
            SEDistrictAdmin , 
            SEDistrictViewer , 
            SEDistrictWideTeacherEvaluator, 
            SEDistrictAssignmentManager ,
            SEDistrictEvaluator

        };
        public static bool IsSchoolRole(string roleName)
        {
            return SchoolRoles.Contains(roleName);
        }
        public static bool IsDistrictRole(string roleName)
        {
            return DistrictRoles.Contains(roleName);
        }

        public static Dictionary<string, string> RoleXlate = new Dictionary<string, string>()
        {
            {EDSRoleDistrictAdmin                    ,  SEDistrictAdmin                  },
            {EDSRoleDistrictAssignentManager         ,  SEDistrictAssignmentManager      },
            {EDSRoleDistrictEvaluator                ,  SEDistrictEvaluator              },
            {EDSRoleDistrictTeacherEvaluator         ,  SEDistrictWideTeacherEvaluator   },
            {EDSRoleDistrictViewer                   ,  SEDistrictViewer                 }, 
                                                                       
            {EDSRoleSchoolAdmin                      ,  SESchoolAdmin                    },
            {EDSRoleSchoolHeadPrincipal              ,  SESchoolHeadPrincipal            },
            {EDSRoleSchoolPrincipal                  ,  SESchoolPrincipal                },
            {EDSRoleSchoolTeacher                    ,  SESchoolTeacher                  },
            {EDSRoleSchoolLibrarian                  ,  SESchoolLibrarian                }
        };

        public static Dictionary<string, string> School2District = new Dictionary<string, string>()
        {
            //TODO
        };
    }
}