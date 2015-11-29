using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using DbUtils;
using StateEval;
using StateEval.Messages;
using System.Net.Mail;
using System.Net;
using System.Configuration;

namespace ProcessEmailQueue
{
    class Program
    {
        static string GetToEmailAddress(long recipientId)
        {
            SEMgr mgr = new SEMgr(ConfigurationManager.ConnectionStrings["SEDbConnection"].ConnectionString);
            // first check to see if we should send to a test account
            string toEmail = Convert.ToString(ConfigurationManager.AppSettings["UseTestEmailAccount"]);
            if (toEmail == String.Empty)
            {
                SEUser to = mgr.SEUser(recipientId);

                // check to see if they have overridden the account in EDS
                toEmail = to.MessageEmailOverride;
                if (toEmail == String.Empty)
                {
                    // use their EDS email account
                    toEmail = to.Email;
                }
            }

            return toEmail;
        }

        static string GetBodyWithoutViewLink(SEMessage m)
        {
            return m.Body.Remove(m.Body.IndexOf("To view")).Replace("\n", "<br/>");
        }

        // runs every hour
        static void ProcessIndividual()
        {
            List<SEMessage> messages = MessageManager.GetDigestMessages(EmailDeliveryType.INDIVIDUAL);
            foreach (SEMessage m in messages)
            {
                try
                {
                    string toEmail = GetToEmailAddress(Convert.ToInt64(m.RecipientUsers));
                    SendMail(toEmail, m.Subject, GetBodyWithoutViewLink(m));
                    MessageManager.MarkMessageSent(m.Id);
                }
                catch { }
            }
        }

        static int GetNextBatch(List<SEMessage> messages, int start, List<SEMessage> nextBatch)
        {
            // Get all the messages until the recipient changes
            string recipient = messages[start].RecipientUsers;
            for (int i = start; i < messages.Count; ++i)
            {
                if (recipient != messages[i].RecipientUsers)
                {
                    return i;
                }
                nextBatch.Add(messages[i]);
            }

            return -1;
        }

        static void ProcessNextBatch(List<SEMessage> messages, string subject)
        {
            StringBuilder output = new StringBuilder();

            output.Append("<table cellspacing='0' cellpadding='4' style='border: solid 1px black'>");
            output.Append("<tr><td style='border: solid 1px black; background-color:grey; font-weight:bold'>Date</td><td style='border: solid 1px black; background-color:grey; font-weight:bold'>Sender</td><td style='border: solid 1px black; background-color:grey; font-weight:bold'>Message</td></tr>");

            for (int i = 0; i < messages.Count; ++i)
            {
                SEMessage m = messages[i];
                output.Append("<tr><td valign='top' style='border: solid 1px black'>" + m.SentTime.ToShortDateString() + "</td><td valign='top' style='border: solid 1px black'>" + m.Sender + "</td><td valign='top' style='border: solid 1px black'>" + GetBodyWithoutViewLink(m) + "</td></tr>");
            }
            output.Append("</table>");

            string toEmail = GetToEmailAddress(Convert.ToInt64(messages[0].RecipientUsers));
            SendMail(toEmail, subject, output.ToString());

            for (int i = 0; i < messages.Count; ++i)
            {
                MessageManager.MarkMessageSent(messages[i].Id);
            }
        }

        static void ProcessDigest(List<SEMessage> messages, string subject)
        {
            int i = 0;
            while (i < messages.Count && i != -1)
            {
                try
                {
                    List<SEMessage> nextBatch = new List<SEMessage>();
                    i = GetNextBatch(messages, i, nextBatch);
                    ProcessNextBatch(nextBatch, subject);
                }
                catch { }
            }
        }

        static void ProcessTest()
        {
            SendMail("chnn.anne@gmail.com", "Test", "TestMessage");
        }

        static public void SendMail(string to, string subject, string body)
        {   
            AppSettingsReader settingsReader = new AppSettingsReader();
            bool sendMail = Convert.ToBoolean(settingsReader.GetValue("SendMail", typeof(bool)));
            if (!sendMail)
            {
                return;
            }

            var fromAddress = new MailAddress("eval@esd113.org", "eVAL Notification");
            var toAddress = new MailAddress(to);

            var smtp = new SmtpClient();
            using (var message = new MailMessage(fromAddress, toAddress)
            {
                Subject = subject,
                Body = body,
                IsBodyHtml = true,
                BodyEncoding = System.Text.Encoding.ASCII,
            })
            {
                string bcc = Convert.ToString(ConfigurationManager.AppSettings["bcc"]);
                if (bcc != String.Empty)
                {
                    message.Bcc.Add(bcc);
                }
                smtp.Send(message);
            }
        }

        static void Main(string[] args)
        {
            try
            {
                foreach (var asm in AppDomain.CurrentDomain.GetAssemblies())
                {
                    asm.GetTypes();
                }
            }
            catch (System.Reflection.ReflectionTypeLoadException e)
            {
                foreach (Exception x in e.LoaderExceptions)
                {
                    Console.WriteLine(x.Message);
                }
            }

            // Set message to sent that are configured to not be sent so they don't get sent after they later configure them
            DbConnector dbConn = new DbConnector(Convert.ToString(ConfigurationManager.ConnectionStrings["SEDbConnection"]));
            string query = "UPDATE  h SET EmailSent=1 " +
                           " FROM MessageHeader h" +
                           " JOIN dbo.MessageTypeRecipientConfig c ON (h.MessageTypeID=c.MessageTypeID AND h.RecipientID=c.RecipientID)" +
                           " WHERE c.EmailDeliveryTypeID=1" + 
                           " AND EmailSent=0";

            dbConn.ExecuteNonSpNonQuery(query);

            if (args[0] == "Nightly")
            {
                List<SEMessage> messages = MessageManager.GetDigestMessages(EmailDeliveryType.NIGHTLY_DIGEST);
                ProcessDigest(messages, "eVAL Nightly Digest");
            }
            else if (args[0] == "Weekly")
            {
                List<SEMessage> messages = MessageManager.GetDigestMessages(EmailDeliveryType.WEEKLY_DIGEST);
                ProcessDigest(messages, "eVAL Weekly Digest");
            }
            else if (args[0] == "Individual")
            {
                ProcessIndividual();
            }
            else
            {
                ProcessTest();
            }
        }
    }
}
