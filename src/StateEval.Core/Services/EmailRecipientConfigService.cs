using System;
using System.Collections.Generic;
using System.IdentityModel.Metadata;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StateEval.Core.Mapper;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Services
{
    public class EmailRecipientConfigService : BaseService
    {
        public IEnumerable<EmailRecipientConfigModel> GetEmailRecipientConfigModels(long userId)
        {
            return EvalEntities.EventTypeEmailRecipientConfigs.Where(x => x.RecipientID == userId).ToList()
                .Select(x => x.MaptoEmailRecipientConfigModel());
        }

        public EmailRecipientConfigModel GetEmailRecipientConfigModel(int id)
        {
            return
                EvalEntities.EventTypeEmailRecipientConfigs.FirstOrDefault(x => x.EventTypeEmailRecipientConfigID == id)
                    .MaptoEmailRecipientConfigModel();
        }

        public long SaveEmailRecipientConfigModel(EmailRecipientConfigModel emailRecipientConfigModel)
        {
            EventTypeEmailRecipientConfig eventTypeEmailRecipientConfigDb = null;

            if (emailRecipientConfigModel.Id == 0)
            {
                eventTypeEmailRecipientConfigDb = new EventTypeEmailRecipientConfig();
                EvalEntities.EventTypeEmailRecipientConfigs.Add(eventTypeEmailRecipientConfigDb);
            }
            else
            {
                eventTypeEmailRecipientConfigDb =
                    EvalEntities.EventTypeEmailRecipientConfigs.FirstOrDefault(
                        x => x.EventTypeEmailRecipientConfigID == emailRecipientConfigModel.Id);
            }

            eventTypeEmailRecipientConfigDb =
                emailRecipientConfigModel.MaptoEventTypeEmailRecipientConfig(eventTypeEmailRecipientConfigDb);

            return eventTypeEmailRecipientConfigDb.EventTypeEmailRecipientConfigID;
        }

        public void SaveEmailRecipientConfigs(List<EmailRecipientConfigModel> emailRecipientConfigs)
        {
            foreach(EmailRecipientConfigModel emailRecipientConfig in emailRecipientConfigs)
            {
                var emailRecipientConfigDb =
                    EvalEntities.EventTypeEmailRecipientConfigs.FirstOrDefault(
                        x => x.EventTypeEmailRecipientConfigID == emailRecipientConfig.Id);

                if (emailRecipientConfigDb == null)
                {
                    emailRecipientConfigDb = new EventTypeEmailRecipientConfig
                    {
                        EmailDeliveryTypeID = emailRecipientConfig.EmailDeliveryTypeID,
                        EventTypeID = emailRecipientConfig.EventTypeID,
                        RecipientID = emailRecipientConfig.RecipientID
                    };

                    EvalEntities.EventTypeEmailRecipientConfigs.Add(emailRecipientConfigDb);
                }
                else
                {
                    emailRecipientConfigDb.EmailDeliveryTypeID = emailRecipientConfig.EmailDeliveryTypeID;
                }
            }

            EvalEntities.SaveChanges();

        }
    }
}