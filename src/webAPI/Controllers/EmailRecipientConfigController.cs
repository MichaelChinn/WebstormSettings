using System.Collections.Generic;
using System.Diagnostics.Eventing.Reader;
using System.Linq;
using System.Web.Http;
using StateEval.Core.Mapper;
using StateEval.Core.Models;
using StateEval.Core.Services;
using StateEvalData;

namespace WebAPI.Controllers
{
    public class EmailRecipientConfigController : BaseApiController
    {
        private readonly EmailRecipientConfigService emailRecipientConfigService = new EmailRecipientConfigService();

        [Route("api/emailrecipientconfigs/{userId}")]
        public IList<EmailRecipientConfigModel> GetEmailRecipientConfigs(long userId)
        {
            return emailRecipientConfigService.GetEmailRecipientConfigModels(userId).ToList();
        }

        [HttpPost]
        [Route("api/emailrecipientconfig/save")]
        public void SaveConfig(List<EmailRecipientConfigModel> emailRecipientConfigs)
        {
            emailRecipientConfigService.SaveEmailRecipientConfigs(emailRecipientConfigs);
        }
    }
}