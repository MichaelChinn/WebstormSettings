using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StateEval.Core.Constants;
using StateEval.Core.Mapper;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Services
{
    public class LocationService : BaseService
    {
        public IEnumerable<LocationModel> GetSchoolsInDistrict(string districtCode)
        {
            IQueryable<SEDistrictSchool> districtSchools = EvalEntities.SEDistrictSchools
                .Where(ds => ds.districtCode == districtCode && ds.isSchool==true)
                .OrderBy(ds => new { ds.districtSchoolName });

            return districtSchools.ToList().Select(x => x.MaptoLocationModel());
        }
    }
}
