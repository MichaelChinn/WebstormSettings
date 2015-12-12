using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using StateEval.Core.Constants;
using StateEval.Core.Services;

namespace StateEval.Core.Test
{
    [TestClass]
    public class EventServiceTest
    {
        EventService eventService = new EventService();
        NotificationService notificaiService = new NotificationService();

        [TestMethod]
        public void SaveObservationCreatedEventTest()
        {
            using (TransactionScope transactionScope = new TransactionScope())
            {
                var evalSessionModel = TestHelper.CreateEvalSessionModel("S1", DefaultTeacher.EvaluationId, DefaultPrincipal.UserId, DefaultTeacher.UserId,
                      SEEvaluationTypeEnum.TEACHER);

                var eventId = eventService.SaveObservationCreatedEvent(evalSessionModel);
                Assert.IsTrue(eventId > 0);

                var notifications = notificaiService.GetNotifications();
                Assert.IsTrue(notifications.Count > 0);
            }
        }
    }
}
