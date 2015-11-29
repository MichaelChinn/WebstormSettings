using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using NUnit.Framework;
using StateEval;
using StateEval.Security;
using StateEval.Messages;

namespace StateEval.tests
{
    [TestFixture]
    class tMessageManager : tBase
    {
        protected void TestMessageTypeInner(MessageType expectedType)
        {
            MessageType actualType = (MessageType)Convert.ToInt32(Fixture.SEMgr.DbConnector.ExecuteNonSpScalar("select MessageTypeID from MessageType where MessageTypeID=" + Convert.ToInt32(expectedType)));
            // It will throw an exception if there isn't a case for it
            try
            {
                string value = MessageManager.MessageTypeToString(expectedType);

                if (Convert.ToString(expectedType).Contains("UG"))
                {
                    Assert.IsTrue(value.Contains("UG"));
                }
                else if (Convert.ToString(expectedType).Contains("SG"))
                {
                    Assert.IsTrue(value.Contains("SG"));
                }
            }
            catch
            {
                Assert.Fail("Missing or incorrect name for case for " + expectedType);
            }

            try
            {
                string value = MessageManager.MapAttachedObjectTypeToMessageFormatString(expectedType);
            }
            catch
            {
                Assert.Fail("Missing or incorrect name for case for " + expectedType);
            }

        }

        [Test]
        public void MessageTypes()
        {
            List<MessageType> vals = new List<MessageType>((MessageType[])Enum.GetValues(typeof(MessageType)));
            Assert.AreEqual(21, vals.Count);

            foreach (MessageType v in vals)
            {
                // obsolete
                if (v == MessageType.MESSAGE_TYPE_UG_EVALSESSION)
                    continue;

                TestMessageTypeInner(v);
            }

            // add +1 for first value that equals zero
            Assert.AreEqual(Convert.ToInt32(MessageType.MESSAGE_TYPE_SG_EVAL_VISIBILITY_CHANGES)+1, Convert.ToInt32(Fixture.SEMgr.DbConnector.ExecuteNonSpScalar("select COUNT(*) from MessageType")));
        }

        [Test]
        public void FormatString()
        {
            List<MessageType> vals = new List<MessageType>((MessageType[])Enum.GetValues(typeof(MessageType)));
            foreach (MessageType v in vals)
            {
                string format = MessageManager.MapAttachedObjectTypeToMessageFormatString(v);
                string body = String.Format(format, "First", "Second", "Thirst");
                Assert.IsFalse(body.Contains("{0}"));
                Assert.IsFalse(body.Contains("{1}"));
                Assert.IsFalse(body.Contains("{2}"));
            }
        }

        public void MapMessageTypeToFormatString(MessageType messageType, string formatContains)
        {
            string format = MessageManager.MapAttachedObjectTypeToMessageFormatString(messageType);
            Assert.IsTrue(format.Contains(formatContains));

        }

        [Test]
        public void MapMessageTypeToFormatString()
        {
            MapMessageTypeToFormatString(MessageType.MESSAGE_TYPE_UG_EVALUATOR_GOAL, "has sent you a notification from his/her Goal Settings");
            MapMessageTypeToFormatString(MessageType.MESSAGE_TYPE_UG_EVALUATEE_GOAL, "has sent you a notification from his/her Goal Settings");
            MapMessageTypeToFormatString(MessageType.MESSAGE_TYPE_UG_SELFASSESS, "has sent you a notification from his/her Self-Assessments");
            MapMessageTypeToFormatString(MessageType.MESSAGE_TYPE_UG_ARTIFACT, "has sent you a notification from his/her Artifacts section");
            MapMessageTypeToFormatString(MessageType.MESSAGE_TYPE_UG_EVALSESSION_SETTINGS, "has sent you a notification from his/her Settings");
            MapMessageTypeToFormatString(MessageType.MESSAGE_TYPE_UG_EVALSESSION_PRE, "has sent you a notification from his/her Pre-Conference");
            MapMessageTypeToFormatString(MessageType.MESSAGE_TYPE_UG_EVALSESSION_OBSERVE, "has sent you a notification from his/her Scorin");
            MapMessageTypeToFormatString(MessageType.MESSAGE_TYPE_UG_EVALSESSION_POST, "has sent you a notification from his/her Post-Conference");


            MapMessageTypeToFormatString(MessageType.MESSAGE_TYPE_SG_ARTIFACT_NEW, "has created a new artifact named");
            MapMessageTypeToFormatString(MessageType.MESSAGE_TYPE_SG_PRECONF_PUBLIC, "has made the pre-conference section of the observation session titled");
            MapMessageTypeToFormatString(MessageType.MESSAGE_TYPE_SG_OBSERVE_PUBLIC, "has made the observation section of the observation session titled");
            MapMessageTypeToFormatString(MessageType.MESSAGE_TYPE_SG_POSTCONF_PUBLIC, "has made the post-conference section of the observation session titled");
            MapMessageTypeToFormatString(MessageType.MESSAGE_TYPE_SG_PRECONF_COMPLETE, "has marked the pre-conference section of the observation session titled");
            MapMessageTypeToFormatString(MessageType.MESSAGE_TYPE_SG_OBSERVE_COMPLETE, "has marked the observation section of the observation session titled");
            MapMessageTypeToFormatString(MessageType.MESSAGE_TYPE_SG_POSTCONF_COMPLETE, "has marked the post-conference section of the observation session titled");
            MapMessageTypeToFormatString(MessageType.MESSAGE_TYPE_SG_EVAL_SUBMITTED, "has submitted your final evaluation for the ");
            MapMessageTypeToFormatString(MessageType.MESSAGE_TYPE_SG_EVAL_VISIBILITY_CHANGES, "has changed the visibility settings");
            MapMessageTypeToFormatString(MessageType.MESSAGE_TYPE_SG_EVALSESSION_LOCK, "has locked the Observation Session");
        }

        protected void SendMessage(SEUser sender, SEUser recipient, MessageType messageType)
        {
            string subject = MessageManager.MessageTypeToString(messageType);
            string format = MessageManager.MapAttachedObjectTypeToMessageFormatString(messageType);
            string body = String.Format(format, sender.DisplayName, "CONTENT", "URL");

            MessageManager.SendMessage(sender.Id, sender.DisplayName, recipient.Id, MessageManager.MessageTypeToString(messageType), body, messageType, Fixture.CurrentSchoolYear);
        }

        [Test]
        public void SendMessage()
        {
            SEUser teacher = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
            SendMessage(principal, teacher, MessageType.MESSAGE_TYPE_SG_ARTIFACT_NEW);
            List<SEMessageHeader> messages = MessageManager.GetMessages(teacher.Id, Fixture.CurrentSchoolYear);
            Assert.AreEqual(1, messages.Count);
        }

        [Test]
        public void Notifications()
        {
            SEUser teacher = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
            SendMessage(principal, teacher, MessageType.MESSAGE_TYPE_SG_ARTIFACT_NEW);
           List<SEMessageHeader> messages = MessageManager.GetMessages(teacher.Id, Fixture.CurrentSchoolYear);

            MessageNotifications notifications = MessageManager.GetNotifications(teacher.Id, Fixture.CurrentSchoolYear);
            Assert.AreEqual(1, notifications.NewMessageCount);
            Assert.AreEqual(1, notifications.TotalMessageCount);

            MessageManager.MarkMessageRead(teacher.Id, messages[0].Id);

            notifications = MessageManager.GetNotifications(teacher.Id, Fixture.CurrentSchoolYear);
            Assert.AreEqual(0, notifications.NewMessageCount);
            Assert.AreEqual(1, notifications.TotalMessageCount);
        }

        [Test]
        public void EmailDeliveryTypeConfig()
        {
            SEUser teacher = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);

            // Call this to initialize the configuration
            Fixture.SEMgr.GetRecipientMessageTypeConfig(teacher.Id);

            Fixture.SEMgr.ChangeEmailDeliveryType(teacher.Id, MessageType.MESSAGE_TYPE_SG_ARTIFACT_NEW, EmailDeliveryType.INDIVIDUAL);
            Fixture.SEMgr.ChangeEmailDeliveryType(teacher.Id, MessageType.MESSAGE_TYPE_SG_EVAL_SUBMITTED, EmailDeliveryType.NIGHTLY_DIGEST);
            Fixture.SEMgr.ChangeEmailDeliveryType(teacher.Id, MessageType.MESSAGE_TYPE_SG_EVAL_VISIBILITY_CHANGES, EmailDeliveryType.WEEKLY_DIGEST);
            Fixture.SEMgr.ChangeEmailDeliveryType(teacher.Id, MessageType.MESSAGE_TYPE_SG_OBSERVE_COMPLETE, EmailDeliveryType.NONE);

            SendMessage(principal, teacher, MessageType.MESSAGE_TYPE_SG_ARTIFACT_NEW);
            SendMessage(principal, teacher, MessageType.MESSAGE_TYPE_SG_EVAL_SUBMITTED);
            SendMessage(principal, teacher, MessageType.MESSAGE_TYPE_SG_EVAL_VISIBILITY_CHANGES);
            SendMessage(principal, teacher, MessageType.MESSAGE_TYPE_SG_OBSERVE_COMPLETE);

            List<SEMessage> messages = MessageManager.GetDigestMessages(EmailDeliveryType.INDIVIDUAL);
            Assert.AreEqual(1, messages.Count);
            Assert.IsTrue(messages[0].Body.Contains("has created a new artifact named"));
            MessageManager.MarkMessageSent(messages[0].Id);
            messages = MessageManager.GetDigestMessages(EmailDeliveryType.INDIVIDUAL);
            Assert.AreEqual(0, messages.Count);

            messages = MessageManager.GetDigestMessages(EmailDeliveryType.NIGHTLY_DIGEST);
            Assert.AreEqual(1, messages.Count);
            Assert.IsTrue(messages[0].Body.Contains("has submitted your final evaluation"));

            messages = MessageManager.GetDigestMessages(EmailDeliveryType.WEEKLY_DIGEST);
            Assert.AreEqual(1, messages.Count);
            Assert.IsTrue(messages[0].Body.Contains("has changed the visibility settings"));

            messages = MessageManager.GetDigestMessages(EmailDeliveryType.NONE);
            Assert.AreEqual(1, messages.Count);
            Assert.IsTrue(messages[0].Body.Contains("has marked the observation section"));
        }
    }
}
