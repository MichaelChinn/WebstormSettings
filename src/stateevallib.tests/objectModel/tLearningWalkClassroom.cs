using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using StateEval;
using NUnit.Framework;
using DbUtils;

using RepositoryLib;

namespace StateEval.tests.objectModel
{
    [TestFixture]
    class tLearningWalkClassroom : tBase
    {
        public SEPracticeSession CreateLearningWalkInner()
        {
            int numberOfClassroomsToWalk = 10;
            SEUser u = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
            long sessionId = Fixture.SEMgr.CreateLearningWalkPracticeSession(u, "LearningWalker", Fixture.CurrentSchoolYear, numberOfClassroomsToWalk);
            SEPracticeSession s = Fixture.SEMgr.PracticeSession(sessionId);
            return s;
        }

        [Test]
        public void CreateLearninWalk()
        {
            CreateLearningWalkInner();
        }

        [Test]
        public void AddandRemoveLearningClassLabel()
        {
            SEPracticeSession s = CreateLearningWalkInner();
            SELearningWalkClassroom[] classrooms = s.LearningWalkClassrooms;
            Assert.AreEqual(10, classrooms.Length);

            SELearningWalkClassroom classroom1 = classrooms[0];
            classroom1.AddLabelToClassroom("Label1A");
            classroom1.AddLabelToClassroom("Label1B");

            SELearningWalkClassroom classroom2 = classrooms[1];
            classroom2.AddLabelToClassroom("Label2A");
            classroom2.AddLabelToClassroom("Label2B");

            SELearningWalkClassroomLabel[] labels = classroom1.ClassroomLabels;
            Assert.AreEqual(2, labels.Length);

            // labels are shared across classrooms
            SELearningWalkClassroomLabel[] walklabels = classroom1.LearningWalkLabels;
            Assert.AreEqual(4, walklabels.Length);

            // Should be in alpha order
            Assert.AreEqual("Label1A", labels[0].Label);
            Assert.AreEqual("Label1B", labels[1].Label);

            classroom1.RemoveLabelFromClassroom(labels[0].Id);
            labels = classroom1.ClassroomLabels;
            // Make sure it removed it
            Assert.AreEqual(1, labels.Length);
            // Make sure it removed the correct one.
            Assert.AreEqual("Label1B", labels[0].Label);

            // learning walk labels are still there after removal from classroom
            Assert.AreEqual(4, classroom1.LearningWalkLabels.Length);
            Assert.AreEqual(4, classroom2.LearningWalkLabels.Length);

            Assert.AreEqual(1, classroom1.ClassroomLabels.Length);
            Assert.AreEqual(2, classroom2.ClassroomLabels.Length);
        }
    }
}
