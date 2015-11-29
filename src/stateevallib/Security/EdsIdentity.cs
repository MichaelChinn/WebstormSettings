using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace StateEval.Security
{
	public static class EdsIdentity
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
        public const string RoleDistrictAssignmentManager = "eValDistrictAssignmentManager";

	}
}
