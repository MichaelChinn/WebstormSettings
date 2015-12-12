using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StateEval.Core.Models;

namespace StateEval.Core.Services
{
    public class TypeDataService:BaseService
    {
        public List<EmailDeliveryTypeModel> GetEmailDeliveryTypes()
        {
            var emailDeliveryTypes = EvalEntities.EmailDeliveryTypes.ToList().Select(x => new EmailDeliveryTypeModel
            {
                Id = x.EmailDeliveryTypeID,
                Name = x.Name
            }).ToList();

            return emailDeliveryTypes;
        }
    }
}
