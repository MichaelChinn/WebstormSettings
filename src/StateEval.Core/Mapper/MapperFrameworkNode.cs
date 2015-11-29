using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
         public static FrameworkNodeModel MaptoFrameworkNodeModel(
            this SEFrameworkNode source, FrameworkNodeModel target = null)
        {
            target = target ?? new FrameworkNodeModel();

            target.Id = source.FrameworkNodeID;
            target.ShortName = source.ShortName;
            target.Title = source.Title;
            target.Sequence = source.Sequence;

            if (source.SERubricRowFrameworkNodes.Any())
            {
                target.RubricRows = source.SERubricRowFrameworkNodes.Select(x => x.SERubricRow.MaptoRubricRowModel(x.Sequence));
            }
            else
            {
                target.RubricRows = new List<RubricRowModel>();
            }

            return target;
        }

        public static SEFrameworkNode MaptoSEFrameworkNode(
            this FrameworkNodeModel source, SEFrameworkNode target = null)
        {
            target = target ?? new SEFrameworkNode();

            target.FrameworkNodeID = source.Id;
            target.ShortName = source.ShortName;
            target.Title = source.Title;
            target.Sequence = source.Sequence;

            // We don't need to map over the rubric rows because they are read-only.

            return target;
        }
    }
}