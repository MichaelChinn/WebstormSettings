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
    public class RubricRowAnnotationService : BaseService
    {
        public IEnumerable<RubricRowAnnotationModel> GetRubricRowAnnotations(int evalSessionId)
        {
            var rubricRowAnnotations = EvalEntities.SERubricRowAnnotations.Where(x => x.EvalSessionID == evalSessionId)
                .ToList().Select(x => x.MaptoRubricRowAnnotationModel());
            return rubricRowAnnotations;
        }

        public IEnumerable<RubricRowAnnotationModel> GetRubricRowAnnotations(int evalSessionId, int rubricRowId)
        {
            var rubricRowAnnotations = EvalEntities.SERubricRowAnnotations.Where(
                x => x.EvalSessionID == evalSessionId && x.RubricRowID == rubricRowId)
                .ToList().Select(x => x.MaptoRubricRowAnnotationModel());
            return rubricRowAnnotations;
        }

        public RubricRowAnnotationModel GetRubricRowAnnotationById(long id)
        {
            SERubricRowAnnotation annotation =
                EvalEntities.SERubricRowAnnotations.FirstOrDefault(x => x.RubricRowAnnotationID == id);

            if (annotation != null)
            {
                return annotation.MaptoRubricRowAnnotationModel();
            }

            return null;
        }

        public void SaveRubricRowAnnotation(RubricRowAnnotationModel rubricRowAnnotationModel)
        {
            if (!string.IsNullOrEmpty(rubricRowAnnotationModel.Annotation))
            {
                SERubricRowAnnotation seRubricRowAnnotation = null;
                seRubricRowAnnotation = new SERubricRowAnnotation();
                EvalEntities.SERubricRowAnnotations.Add(seRubricRowAnnotation);
                rubricRowAnnotationModel.MaptoSERubricRowAnnotationModel(EvalEntities, seRubricRowAnnotation);
                seRubricRowAnnotation.Annotation = rubricRowAnnotationModel.Annotation;
            }

            EvalEntities.SaveChanges();
        }

        public void DeleteRubricRowAnnotation(long id)
        {
            SERubricRowAnnotation annotation =
                EvalEntities.SERubricRowAnnotations.FirstOrDefault(x => x.RubricRowAnnotationID == id);
            EvalEntities.SERubricRowAnnotations.Remove(annotation);
        }
    }
}
