using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEval.Core.Constants;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
         public static FrameworkModel MaptoFrameworkModel(
            this SEFramework source, FrameworkModel target = null)
        {
            target = target ?? new FrameworkModel();

            target.Id = source.FrameworkID;
            target.Name = source.Name;
            if (source.SEFrameworkNodes.Any())
            {
                target.FrameworkNodes = source.SEFrameworkNodes.Select(x => x.MaptoFrameworkNodeModel());
            }
            else
            {
                target.FrameworkNodes = new List<FrameworkNodeModel>();
            }

            return target;
        }

        public static SEFramework MaptoSEFramework(
            this FrameworkModel source, SEFramework target = null)
        {
            target = target ?? new SEFramework();

            target.FrameworkID = source.Id;

            // We don't need to map over the framework nodes because they are read-only
            return target;
        }
    }
}