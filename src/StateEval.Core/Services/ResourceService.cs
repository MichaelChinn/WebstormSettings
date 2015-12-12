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
    public class ResourceService : BaseService
    {
        public ResourceModel GetResourceFromServiceById(long id)
        {
            SEResource se = EvalEntities.SEResources.FirstOrDefault(x => x.ResourceId == id);
            ResourceModel resource = se.MaptoResourceModel();
            return resource;
        }

        public IEnumerable<ResourceModel> GetResourceFromServiceBySchool(string schoolCode)
        {
            IQueryable<SEResource> resources =
                EvalEntities.SEResources.Where(x => x.SchoolCode == schoolCode);
            return resources.ToList().Select(x => x.MaptoResourceModel());
        }

        public IEnumerable<ResourceModel> GetResourceFromServiceByDistrict(string districtCode)
        {
            IQueryable<SEResource> resources =
                EvalEntities.SEResources.Where(x => x.DistrictCode == districtCode);
            return resources.ToList().Select(x => x.MaptoResourceModel());
        }

        public IEnumerable<ResourceModel> GetResourcesForDistrictAdmin(string districtCode)
        {
            IQueryable<SEResource> resources = 
                EvalEntities.SEResources.Where(x => (x.DistrictCode == districtCode) && (x.SchoolCode == ""));
            return resources.ToList().Select(x => x.MaptoResourceModel());
        }

        public object CreateResource(ResourceModel resourceModel)
        {
            SEResource seResource = new SEResource();
            resourceModel.MaptoSEResource(this.EvalEntities, seResource);
            seResource.CreationDateTime = DateTime.Now;
            EvalEntities.SEResources.Add(seResource);
            EvalEntities.SaveChanges();

            return new { Id = seResource.ResourceId };
        }

        public void saveResource(ResourceModel resourceModel) {
            SEResource seResource =
                EvalEntities.SEResources.FirstOrDefault(x => x.ResourceId == resourceModel.Id);
            if (seResource != null)
            {
                resourceModel.MaptoSEResource(this.EvalEntities, seResource);
            }
            EvalEntities.SaveChanges();
        }

        public void deleteResource(long id)
        {
            SEResource seResource =
                EvalEntities.SEResources.FirstOrDefault(x => x.ResourceId == id);
            if (seResource != null)
            {
                seResource.SERubricRows.ToList().ForEach(rr => seResource.SERubricRows.Remove(rr));
                EvalEntities.SEResources.Remove(seResource);
                EvalEntities.SaveChanges();
            }
        }
    }
}
