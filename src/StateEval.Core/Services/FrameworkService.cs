using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Constants;
using StateEval.Core.Mapper;
using StateEval.Core.Models;
using StateEvalData;
using System.Data.SqlClient;

namespace StateEval.Core.Services
{
    public class FrameworkService : BaseService
    {
        public FrameworkContextModel LoadFrameworkContext(string districtCode, long protoContextId)
        {
            EvalEntities.Database.ExecuteSqlCommand(string.Format("LoadFrameworkContext {0}, {1}", districtCode, protoContextId));

            SEFrameworkContext seFrameworkContext = EvalEntities.SEFrameworkContexts
                    .FirstOrDefault(x => x.DistrictCode == districtCode && x.PrototypeFrameworkContextID == protoContextId);
            if (seFrameworkContext != null)
            {
                return seFrameworkContext.MaptoFrameworkContextModel(EvalEntities);
            }

            return null;
        }

        public List<FrameworkContextModel> GetLoadedFrameworkContexts(string districtCode)
        {
            List<FrameworkContextModel> list = new List<FrameworkContextModel>();

            var seContexts = EvalEntities.SEFrameworkContexts;
            foreach (SEFrameworkContext x in seContexts)
            {
                list.Add(x.MaptoFrameworkContextModel(EvalEntities));
            }

            return list;
        }

        public List<PrototypeFrameworkContextModel> GetPrototypeFrameworkContexts()
        {
            List<PrototypeFrameworkContextModel> list = new List<PrototypeFrameworkContextModel>();

            var seContexts = EvalEntities.vPrototypeFrameworkContexts;
            foreach (vPrototypeFrameworkContext x in seContexts)
            {
                list.Add(x.MaptoPrototypeFrameworkContextModel());
            }

            return list;
        }

        public FrameworkContextModel GetFrameworkContext(SESchoolYearEnum schoolYear, string districtCode, SEEvaluationTypeEnum evaluationTypeId)
        {
            SEFrameworkContext fs = EvalEntities.SEFrameworkContexts.FirstOrDefault(x =>
                                                    x.SchoolYear == (short)schoolYear &&
                                                    x.DistrictCode == districtCode &&
                                                    x.EvaluationTypeID == (short)evaluationTypeId);
            if (fs != null)
            {
                return fs.MaptoFrameworkContextModel(EvalEntities);
            }

            return null;
        }

        public void UpdateFrameworkContext(long frameworkContextId, SEFrameworkViewTypeEnum viewType, bool isActive)
        {
            SEFrameworkContext fs = EvalEntities.SEFrameworkContexts.FirstOrDefault(x =>x.FrameworkContextID==frameworkContextId);
            if (fs != null)
            {
                fs.FrameworkViewTypeID = (short)viewType;
                fs.IsActive = isActive;
                EvalEntities.SaveChanges();
            }
        }
    }
}