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


using Microsoft.IdentityModel.Claims;
using Microsoft.IdentityModel.Configuration;
using Microsoft.IdentityModel.Protocols.WSTrust;
using Microsoft.IdentityModel.SecurityTokenService;

namespace StateEval.tests
{

    [TestFixture]
    class tZapColorSpans
    {
        /*  const string TestString = 
              "<span style=\"font-family: consolas; font-size: 13px;\"><p><span style=\"background-color: #ffc61c;\">"
              + "Lorem ipsum</span> dolor sit amet, consectetuer adipiscing elit. Vivamus <span style=\"background-color:"
              + "#ebdc3b;\">semper sem. Curabitur ac arcu. Duis lobortis tempus dolor. Donec libero. Morbi sed est</span>."
              + "Curabitur rutrum feugiat lectus. Cras malesuada. Proin quam quam, suscipit sit amet, fringilla ac, pretium vel, arcu. </p>"
              + "<p>Ut accumsan.<span style=\"background-color: #ff87f7;\"> Nam eget ligula. In aliquam vulputate augue. Donec tincidunt sapien</span>"
              + "sit amet lorem. Donec semper. Ut leo massa, euismod nec, sollicitudin ut, sagittis ac, lectus. Cras luctus ul<span style=\"background-color:"
              + "#9d7ee6;\">tric</span>es lectus.<span style=\"background-color: #34a628;\"> Aliquam pharetra, erat sed imperdiet volutpat, sem wisi"
              + "</span><span style=\"background-color: #ff87f7;\">congue risus, vel condimentum</span> eros velit eu nibh. Vestibulum vitae mauris "
              + "sed tortor fringilla semper. Vivamus viverra. Suspendisse feugiat. Phasellus sagittis laoreet dui. Phasellus est enim, tempus eget, "
              + "sodales nec, sollicitudin a, justo. Quisque gravida. Nunc sagittis cursus sem. Nullam id nisl. Class aptent taciti sociosqu ad litora "
              + "torquent per conubia nostra, per inceptos hymenaeos. Cras a turpis. Duis felis. </p><p>Maecenas convallis erat ut arcu. Cras rhoncus."
              + "Praesent pellentesque adipiscing libero. Fusce semper massa ac dolor nonummy viverra. Vestibulum vel nisl. </p>"
              + "<p>Suspendisse potenti. In sollicitudin condimentum quam. Cras velit arcu, euismod ut, tristique semper, vulputate nec, dolor. "
              + "Integer egestas varius lectus. Fusce vitae ipsum. Donec vestibulum, sapien a fermentum ullamcorper, lectus lectus pharetra wisi, "
              + "at placerat purus magna semper sapien. Curabitur sit amet felis. Aenean lacinia metus eget libero. Fusce sit amet nibh. Mauris "
              + "fringilla. Ut commodo. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Phasellus vitae mi. </p></span>"

         * 
          <span style="background-color: #feef01;">Ut accumsan. Nam eget ligula. In</span> aliquam vulputate augue. Donec tincidunt sapien
         * sit amet lorem. Donec semper. Ut leo massa, euismod nec, sollicitudin ut, sagittis ac, lectus. Cras luctus
         * <span style="background-color: #feef01;"> ultrices lectus. Aliquam pharetra, </span><span style="background-color: #feef01;">erat sed imperdiet 
         * volutpat, sem wisi congue risus, vel condimentum eros velit eu nibh. Vestibulum vitae mauris sed tortor fringilla semper. Vivamus viverra. 
         * Suspendisse feugiat. Phasellus sagittis laoreet dui. Phasellus est enim, tempus eget, sodales nec, sollicitudin a, justo. Quisque gravida.
         * Nunc sagittis cursus sem.</span> Nullam id nisl. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. 
         * Cras a turpis. Duis felis. <br />
  <br />
  <strong><em><span style="background-color: #feef01;">Maecenas convallis erat ut arcu. Cras rhoncus. Praesent 
         * pellentesque adipiscing libero. Fusce semper massa ac dolor nonummy viverra. Vestibulum vel nisl.<br />
  <br />
  </span>Suspendisse potenti. In sollicitudin condimentum quam. Cras velit arcu, euismod ut, tristique semper, 
         * vulputate nec, dolor. Integer egestas varius lectus. Fusce vitae ipsum. Donec <span style="background-color: 
         * #feef01;">vestibulum, sapien a fermentum</span> ullamcorper, lectus lectus pharetra wisi, at placerat purus 
         * magna semper sapien. Curabitur sit amet felis. Aenean lacinia metus eget libero. Fusce sit amet nibh. Mauris 
         * fringilla. Ut commodo. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. 
         * Phasellus vitae mi.<br />
  <br />
  </em></strong>In vel sem non leo adipiscing molestie. Praesent viverra nisl ut ante. Vestibulum vehicula, nisl et lobortis lobortis, justo lacus pharetra augue, vel fermentum <span style="background-color: #feef01;">arcu quam quis metus. Integer vulputate blandit urna. Integer eros nisl, aliquam in, viverra semper, fringilla semper, turpis. Aliquam erat volutpat.<br />
  <br />
  <span style="text-decoration: underline;">Nunc imperdiet nibh semper sem. Sed dapibus. Etiam id neque in purus imperdiet eleifend. Sed mauris. Donec tincidunt diam vitae nunc. Donec gravida, lectus sit amet sodales cursus, quam mauris fringilla dolor, vel viverra risus ipsum ac tellus. Nunc tincidunt tortor sit amet purus. Nam semper risus nec lectus temp</span></span>

          */

  //      string stupid = "<bookstore><book><title lang=\"eng\">Harry Potter</title> <price>29.99</price></book><book>"
  //     + "<title lang=\"eng\">Learning XML</title>  <price>39.95</price></book></bookstore>";

        string[] _testStrings = new string[]{
            "<div><font style=\"background-color: #ff9980;\">line1<br /></font></div>"
            ,"<div><font style=\"background-color: #80ffc9;\">line3<br />line4</font><br /></div>"
            ,"<div><font style=\"background-color: #bfd6ff;\"><strong>line3<br /></strong></font></div>"
            ,"<div><font style=\"background-color: #f8bfff;\"><em>line1</em></font></div>"
            ,"<div><span style=\"background-color: #bfd6ff;\">sfsdfdsfsd</span><br /><span style=\"background-color: #bfd6ff;\">sdfsdfsdfsdf</span></div>"
            ,"<div><li><font style=\"background-color: #ff9980;\">ine3<br />     </font></li>     <li><font style=\"background-color: #ff9980;\">line4</font></li></div>"
            ,"<div><li><font style=\"background-color: #ff9980;\">l</font><font style=\"background-color: #f8bfff;\">ine3<br />     </font></li>     <li><font><span style=\"background-color: #f8bfff;\">line4</span><br />     </font></li>     <li><font style=\"background-color: #ff9980;\">line5</font></li></div>"
    };

        string[] _expectedStrings = new string[] {
            "<div>line1<br></div>"
            ,"<div>line3<br>line4<br></div>"
            ,"<div><strong>line3<br></strong></div>"
            ,"<div><em>line1</em></div>"
            ,"<div>sfsdfdsfsd<br>sdfsdfsdfsdf</div>"
            ,"<div><li>ine3<br>     </li>     <li>line4</li></div>"
            ,"<div><li>line3<br>     </li>     <li><font>line4<br>     </font></li>     <li>line5</li></div>"
        };

        [Test]
        public void HApTest()
        {
            for (int i=0; i< _testStrings.Length; i++)
            {
                string testString = _testStrings[i];
                Fixture.SEMgr.RemoveAllColorTags(ref testString);
                Assert.AreEqual(_expectedStrings[i], testString, "at string number... " + i.ToString());
            }
        }
    }
}

