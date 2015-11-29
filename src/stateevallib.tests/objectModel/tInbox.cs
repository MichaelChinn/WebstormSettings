using NUnit.Framework;


namespace stateevallib.tests.objectModel
{
    [TestFixture]
    class tInbox : tBase
    {
        [Test]
        public void VerifyLoad()
        {
            var inboxAll = Inbox.GetAllInbox(Fixture.ESD101Ad_UserId);
            var inboxUnread = Inbox.GetAllInboxUnread(Fixture.ESD101Ad_UserId);
            var inboxSent = Inbox.GetAllSent(Fixture.ESD101Ad_UserId);

            //Test unread items
            foreach (var msg in inboxUnread)
            {
                Assert.AreEqual(msg.ToUserID, Fixture.ESD101Ad_UserId);
                Assert.AreEqual(msg.IsRead, false);
            }

            //Test sent items
            foreach (var msg in inboxSent)
            {
                Assert.AreEqual(msg.FromUserID, Fixture.ESD101Ad_UserId);
            }

            //Test reading inbox message
            foreach (var msg in inboxAll)
            {
                msg.Read();
                Assert.AreEqual(msg.IsRead, true);
            }
        }

        [Test]
        public void Send()
        {
            var inbox = new Inbox();
            inbox.ToUserID = Fixture.ESD101Ad_UserId;
            inbox.Subject = Fixture.MsgSubject;
            inbox.Message = Fixture.MsgBody;
            int id = inbox.Send();

            var sentItem = Inbox.Get(id);
            Assert.AreEqual(sentItem.ID, id);
            Assert.AreEqual(sentItem.Subject, Fixture.MsgSubject);
            Assert.AreEqual(sentItem.Message, Fixture.MsgBody);
            Assert.AreEqual(sentItem.FromUserID, null);
            Assert.AreEqual(sentItem.ToUserID, Fixture.ESD101Ad_UserId);
        }
    }
}
