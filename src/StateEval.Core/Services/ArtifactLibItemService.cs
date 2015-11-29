using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StateEval.Core.Mapper;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Services
{
    public class ArtifactLibItemService : BaseService
    {
        public IEnumerable<ArtifactLibItemModel> GetArtifactLibItemsForEvaluation(long evaluationId)
        {
            IQueryable<SEArtifactLibItem> items =
                EvalEntities.SEArtifactLibItems.Where(x => x.EvaluationID == evaluationId);
            return items.ToList().Select(x => x.MaptoArtifactLibItemModel());
        }

        public ArtifactLibItemModel GetArtifactLibItemById(long id)
        {
            SEArtifactLibItem artifactLibItem =
                EvalEntities.SEArtifactLibItems.FirstOrDefault(x => x.ArtifactLibItemID == id);
            if (artifactLibItem != null)
            {
                return artifactLibItem.MaptoArtifactLibItemModel();
            }

            return null;
        }

        public void UpdateArtifactLibItem(ArtifactLibItemModel artifactLibItemModel)
        {
            SEArtifactLibItem seArtifactLibItem =
                EvalEntities.SEArtifactLibItems.FirstOrDefault(x => x.ArtifactLibItemID == artifactLibItemModel.Id);

            if (seArtifactLibItem != null)
            {
                artifactLibItemModel.MaptoSEArtifactLibItem(seArtifactLibItem);
            }

            EvalEntities.SaveChanges();
        }

        public object CreateArtifactLibItem(ArtifactLibItemModel artifactLibItemModel)
        {
            SEArtifactLibItem seArtifactLibItem = artifactLibItemModel.MaptoSEArtifactLibItem();
            seArtifactLibItem.CreationDateTime = DateTime.Now;
            EvalEntities.SEArtifactLibItems.Add(seArtifactLibItem);
            EvalEntities.SaveChanges();

            return new { Id = seArtifactLibItem.ArtifactLibItemID };
        }

        public void DeleteArtifactLibItem(long id)
        {
            SEArtifactLibItem ArtifactLibItem =
                EvalEntities.SEArtifactLibItems.FirstOrDefault(x => x.ArtifactLibItemID == id);
            if (ArtifactLibItem != null)
            {
                EvalEntities.SEArtifactLibItems.Remove(ArtifactLibItem);
                EvalEntities.SaveChanges();
            }
        }
    }
}
