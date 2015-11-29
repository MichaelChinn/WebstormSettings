using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace StateEval.Security
{
	public class UserRole
	{
        // District-level roles
		public const string SEDistrictAdmin = "SEDistrictAdmin";
        public const string SEDistrictViewer = "SEDistrictViewer";
        public const string SEDistrictEvaluator = "SEDistrictEvaluator";
        public const string SEDistrictAssignmentManager = "SEDistrictAssignmentManager";
        public const string SEDistrictWideTeacherEvaluator = "SEDistrictWideTeacherEvaluator";

        // School-level roles
		public const string SESchoolAdmin = "SESchoolAdmin";
		public const string SESchoolPrincipal = "SESchoolPrincipal";
		public const string SESchoolTeacher = "SESchoolTeacher";
        public const string SESchoolHeadPrincipal = "SESchoolHeadPrincipal";

        // Special eVAL internal roles (don't come in through EDS)
        public const string SESuperAdmin = "SESuperAdmin";
        public const string SECustomSupportL1 = "SECustomerSupportL1";

		public const string Key_DistrictAdmin = "D9A2E5E8-5598-458F-98A7-5CFC6D512AF5";
		public const string Key_DistrictEvaluator = "5F4C1CE0-D01C-4CCA-982C-C307C0DD2111";
		public const string Key_ESDAdmin = "D08BD14C-933D-4BB0-9A23-BDB9AA492E8D";
		public const string Key_SchoolAdmin = "5BDA72C8-5C1C-44C5-8294-AC1CCB774D95";
		public const string Key_SchoolPrincipal = "9479D229-BCF0-4A9B-A267-729F3F9A7E8E";
		public const string Key_SchoolTeacher = "7658B0BB-1920-4427-AC98-1D44F82F9A18";
		public const string Key_StateAdmin = "1B1A4B99-0743-4D5D-874A-45754B9598A6";
		public const string Key_SuperAdmin = "5AAB32A1-32B0-44F2-93FA-44617A6F39D4";


        public Dictionary<string, bool> IsOkForSchool = new Dictionary<string, bool>()
        {
            {SESchoolAdmin , true},
            {SESchoolPrincipal , true},
            {SESchoolTeacher , true},
            {SESchoolHeadPrincipal, true}
        };

        public Dictionary<string, bool> IsOkForDistrict = new Dictionary<string, bool>()
        {
            {SEDistrictAdmin , true},
            {SEDistrictViewer , true},  
            {SEDistrictEvaluator , true},
            {SEDistrictAssignmentManager , true},
            {SEDistrictWideTeacherEvaluator , true}
        };

        // TODO: Not sure if these are used
        public const string SEStateAdmin = "SEStateAdmin";
        public const string SEESDAdmin = "SEESDAdmin";
        public const string SEPracticeParticipantGuest = "SEPracticeParticipantGuest";
	}
}
