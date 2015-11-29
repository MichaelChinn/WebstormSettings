using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
        public static SEResource MaptoSEResource(
            this ResourceModel source, StateEvalEntities evalEntities, SEResource target = null)
        {
            target = target ?? new SEResource();
            target.ResourceId = source.Id;
            target.CreationDateTime = source.CreationDateTime;
            target.Title = source.Title ?? "";
            target.Comments = source.Comments;
            target.FileUUID = source.FileUUID;
            target.WebUrl = source.WebUrl;
            target.FileName = source.FileName;
            target.ResourceType = source.ResourceType;
            target.ItemTypeID = source.ItemType;
            target.SchoolCode = source 
                .SchoolCode;
            target.DistrictCode = source.DistrictCode;

            List<SERubricRow> toRemoveRR = target.SERubricRows.Where(x => !source.AlignedRubricRows.Select(y => y.Id).Contains(x.RubricRowID)).ToList();
            List<RubricRowModel> toAddRR = source.AlignedRubricRows.Where(n => !target.SERubricRows.Select(db => db.RubricRowID).Contains(n.Id)).ToList();

            toRemoveRR.ForEach(x => target.SERubricRows.Remove(x));
            toAddRR.ForEach(x =>
            {
                SERubricRow rr = evalEntities.SERubricRows.FirstOrDefault(y => y.RubricRowID == x.Id);
                target.SERubricRows.Add(rr);
            });

            return target;
        }
        public static ResourceModel MaptoResourceModel(
            this SEResource source, ResourceModel target = null)
        {
            target = target ?? new ResourceModel();

            //adding 1-to-1 mapped properties
            target.Id = source.ResourceId;
            target.CreationDateTime = source.CreationDateTime;
            target.Title = source.Title;
            target.Comments = source.Comments;
            target.FileUUID = source.FileUUID;
            target.WebUrl = source.WebUrl;
            target.FileName = source.FileName;
            target.ResourceType = source.ResourceType;
            target.ItemType = source.ItemTypeID;
            target.SchoolCode = source.SchoolCode;
            target.DistrictCode = source.DistrictCode;

            if (source != null && source.SERubricRows.Any())
            {
                target.AlignedRubricRows = source.SERubricRows.Select(x => x.MaptoRubricRowModel(0)).ToList();
            }
            else
            {
                target.AlignedRubricRows = new List<RubricRowModel>();
            }

            return target;
        }
    }
}
