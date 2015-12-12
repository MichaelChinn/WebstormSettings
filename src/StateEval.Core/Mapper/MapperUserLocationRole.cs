using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEvalData;
using StateEval.Core.Constants;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
        public static UserLocationRoleModel MaptoUserLocationRoleModel(
           this SEUserLocationRole source, UserLocationRoleModel target = null)
        {
            target = target ?? new UserLocationRoleModel();
            target.UserLocationRoleID = source.UserLocationRoleID;
            target.SEUserID = source.SEUserId;
            target.UserName = source.UserName;
            target.RoleName = source.RoleName;
            target.RoleId = source.RoleId;
            target.DistrictCode = source.DistrictCode;
            target.SchoolCode = source.SchoolCode;
            target.LastActiveRole = source.LastActiveRole;
            target.CreateDate = source.CreateDate; ;
            target.DistrictName = source.DistrictName;
            target.SchoolName = source.SchoolName;

            return target;
        }
    }
}