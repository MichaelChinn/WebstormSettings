using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using System.Configuration;
using EDSIntegrationLib.OSPIEntityLookupService;

namespace EDSIntegrationLib
{
    public static class DistrictSchoolEntityLookup
    {
        public static OrganizationServiceClient CreateEntityLookupServiceInstance()
        {
            var serviceClient = new OSPIEntityLookupService.OrganizationServiceClient();

            serviceClient.ClientCredentials.Windows.ClientCredential.UserName
                = ConfigurationManager.AppSettings["EntityLookupServiceUserName"];

            serviceClient.ClientCredentials.Windows.ClientCredential.Password
                = ConfigurationManager.AppSettings["EntityLookupServicePassword"];
            return serviceClient;
        }

        public static void GetInfoForSchoolCode(string schoolCode, ref string districtCode, ref string districtName, ref string schoolName)
        {
            OrganizationServiceClient LookupService = CreateEntityLookupServiceInstance();

            OrganizationRelationship r = LookupService.GetOrganizationRelationshipByOSPILegacyCode(schoolCode);

            districtCode = r.ParentOrganizationOSPILegacyCode;
            districtName = r.ParentOrganizationName;
            schoolName = r.OrganizationName;
        }

        public static string GetDistrictName(string districtCode)
        {
            OrganizationServiceClient LookupService = CreateEntityLookupServiceInstance();

            OrganizationRelationship r = LookupService.GetOrganizationRelationshipByOSPILegacyCode(districtCode);

            return r.OrganizationName;
        }
    }
}
