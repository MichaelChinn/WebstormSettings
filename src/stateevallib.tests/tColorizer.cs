using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using DbUtils;
using StateEval;
using System.Xml;
using System.Xml.Schema;


using NUnit.Framework;

namespace StateEval.tests
{

    [TestFixture]
    class tColorizer
    {
        void VerifyTag(string inputString, string tagType, string tagText
            , int startPos, int endPos
            , bool isStartTag, bool isEndTag, bool isOnesey
            , Tag terminates
            )
        {
            string s = inputString;

            Tag tagToTest = new Tag(ref s, s.IndexOf("<"));
            Assert.AreEqual(tagType, tagToTest.Type, inputString);
            Assert.AreEqual(startPos, tagToTest.TagStartIndex, inputString);
            Assert.AreEqual(endPos, tagToTest.TagEndIndex, inputString);
            Assert.AreEqual(isStartTag, tagToTest.IsStartTag, inputString);
            Assert.AreEqual(isEndTag, tagToTest.IsEndTag, inputString);
            Assert.AreEqual(isOnesey, tagToTest.TagIsSelfContainedEll, inputString);
            Assert.AreEqual(tagText, tagToTest.Text, inputString);

            if (terminates != null)
                Assert.IsTrue(tagToTest.IsEndOf(terminates));
        }
        [Test]
        public void tTagBasic()
        {
            string input = "h<f>x";

            Tag tFirst = new Tag(ref input, 1);

            VerifyTag("h<f>x", "f", "<f>", 1, 3, true, false, false, null);
            VerifyTag("h<f  >x", "f", "<f  >", 1, 5, true, false, false, null);

            VerifyTag("mff</f>fjfjf", "f", "</f>", 3, 6, false, true, false, tFirst);
            VerifyTag("fjfmmmmpppp</ f > ", "f", "</ f >", 11, 16, false, true, false, null);
            VerifyTag("mmm </f> fmfmfm", "f", "</f>", 4, 7, false, true, false, null);
        }
        private void RunColorizer(string ts, string te, string input, string output)
        {
            NotesColorizer nc = new NotesColorizer(input, "#FFFF00");
            nc.BeginTag = ts;
            nc.EndTag = te;
            Assert.AreEqual(output, nc.Colorized, input);
        }
        [Test]
        public void SimpleTest()
        {
            string ts = "<foo>";
            string te = "<bar>";

            string input = "slkjfdslkj";
            string output = ts + input + te;
            RunColorizer(ts, te, input, output);

            input = "mmm</my>yyyy";
            output = ts + "mmm" + te + "</my>" + ts + "yyyy" + te;
            RunColorizer(ts, te, input, output);

            input = "mmm</my> yyyy";
            output = ts + "mmm" + te + "</my>" + ts + " yyyy" + te;
            RunColorizer(ts, te, input, output);

            input = "mmm </my> yyyy";
            output = ts + "mmm " + te + "</my>" + ts + " yyyy" + te;
            RunColorizer(ts, te, input, output);

            input = "mmm</my>mmm</mother>ffff<told>llll<me>yyyy";
            output = ts + "mmm" + te + "</my>" + ts + "mmm" + te + "</mother>" + ts + "ffff" + te + "<told>" + ts + "llll" + te + "<me>" + ts + "yyyy" + te;
            RunColorizer(ts, te, input, output);

            input = "mmm</my>mmm </mother>ffff<told>llll <me>yyyy";
            output = ts + "mmm" + te + "</my>" + ts + "mmm " + te + "</mother>" + ts + "ffff" + te + "<told>" + ts + "llll " + te + "<me>" + ts + "yyyy" + te;
            RunColorizer(ts, te, input, output);

        }

        [Test]
        public void TestBitBlock()
        {
            BitArray bits = new BitArray(new Boolean[] { true, true, true, true });

            int startBlock= 0;
            int blockLength = 0;
            Assert.IsTrue(Fixture.SEMgr.GetNextBlock(ref bits, 0, ref startBlock, ref blockLength));

            Assert.AreEqual(0, startBlock);
            Assert.AreEqual(4, blockLength);

            Assert.IsTrue(Fixture.SEMgr.GetNextBlock(ref bits, 2, ref startBlock, ref blockLength));
            Assert.AreEqual(2, startBlock);
            Assert.AreEqual(2, blockLength);

            bits = new BitArray(new Boolean[] { false, false, false, false });

            startBlock = 0;
            blockLength = 0;
            Assert.IsFalse(Fixture.SEMgr.GetNextBlock(ref bits, 0, ref startBlock, ref blockLength));

            Assert.AreEqual(0, startBlock);
            Assert.AreEqual(4, blockLength);

            Assert.IsFalse(Fixture.SEMgr.GetNextBlock(ref bits, 2, ref startBlock, ref blockLength));
            Assert.AreEqual(2, startBlock);
            Assert.AreEqual(2, blockLength);

            bits = new BitArray(new Boolean[] { false, true, true, true });

            startBlock = 0;
            blockLength = 0;
            Assert.IsFalse(Fixture.SEMgr.GetNextBlock(ref bits, 0, ref startBlock, ref blockLength));

            Assert.AreEqual(0, startBlock);
            Assert.AreEqual(1, blockLength);

            Assert.IsTrue(Fixture.SEMgr.GetNextBlock(ref bits, startBlock+blockLength, ref startBlock, ref blockLength));
            Assert.AreEqual(1, startBlock);
            Assert.AreEqual(3, blockLength);

            bits = new BitArray(new Boolean[] { true, false, false, false });

            startBlock = 0;
            blockLength = 0;
            Assert.IsTrue(Fixture.SEMgr.GetNextBlock(ref bits, 0, ref startBlock, ref blockLength));

            Assert.AreEqual(0, startBlock);
            Assert.AreEqual(1, blockLength);

            Assert.IsFalse(Fixture.SEMgr.GetNextBlock(ref bits, startBlock + blockLength, ref startBlock, ref blockLength));
            Assert.AreEqual(1, startBlock);
            Assert.AreEqual(3, blockLength);

            bits = new BitArray(new Boolean[] { false, false, true, true, false, true, true });

            startBlock = 0;
            blockLength = 0;
            Assert.IsFalse(Fixture.SEMgr.GetNextBlock(ref bits, 0, ref startBlock, ref blockLength));

            Assert.AreEqual(0, startBlock);
            Assert.AreEqual(2, blockLength);

            Assert.IsTrue(Fixture.SEMgr.GetNextBlock(ref bits, startBlock + blockLength, ref startBlock, ref blockLength));
            Assert.AreEqual(2, startBlock);
            Assert.AreEqual(2, blockLength);

            Assert.IsFalse(Fixture.SEMgr.GetNextBlock(ref bits, startBlock + blockLength, ref startBlock, ref blockLength));
            Assert.AreEqual(4, startBlock);
            Assert.AreEqual(1, blockLength);

            Assert.IsTrue(Fixture.SEMgr.GetNextBlock(ref bits, startBlock + blockLength, ref startBlock, ref blockLength));
            Assert.AreEqual(5, startBlock);
            Assert.AreEqual(2, blockLength);



        }
    }
}
