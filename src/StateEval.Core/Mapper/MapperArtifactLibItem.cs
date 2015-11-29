using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
         public static ArtifactLibItemModel MaptoArtifactLibItemModel(
            this SEArtifactLibItem source, ArtifactLibItemModel target = null)
        {
            target = target ?? new ArtifactLibItemModel();

            target.Id = source.ArtifactLibItemID;
            target.CreationDateTime = source.CreationDateTime;
            target.EvaluationId = source.EvaluationID;
            target.Title = source.Title;
            target.Comments = source.Comments;
            target.ItemType = Convert.ToInt16(source.ItemTypeID);
            target.FileUUID = source.FileUUID;
            target.WebUrl = source.WebUrl;
            target.ProfPracticeNotes = source.ProfPracticeNotes;
            target.CreatedByUserId = source.CreatedByUserID;

            return target;
        }

        public static SEArtifactLibItem MaptoSEArtifactLibItem(
            this ArtifactLibItemModel source, SEArtifactLibItem target = null)
        {
            target = target ?? new SEArtifactLibItem();

            target.ArtifactLibItemID = source.Id;
            target.EvaluationID = source.EvaluationId;
            target.Title = source.Title ?? "";
            target.Comments = source.Comments ?? "";
            target.ItemTypeID = Convert.ToInt16(source.ItemType);
            target.FileUUID = source.FileUUID;
            target.FileName = source.FileName ?? "";
            target.WebUrl = source.WebUrl;
            target.ProfPracticeNotes = source.ProfPracticeNotes;
            target.CreationDateTime = DateTime.Now;
            target.CreatedByUserID = source.CreatedByUserId;

            return target;
        }
    }
}