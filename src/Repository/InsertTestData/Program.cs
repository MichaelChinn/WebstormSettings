using System;
using System.Collections.Generic;
using System.Text;
using System.Configuration;
using System.Collections;
using System.IO;
using DbUtils;
using System.Data.SqlClient;
using RepositoryLib;

namespace InsertTestData
{
    class Program
    {
        static string _testDataBasePath = @"..\.\..\Data";

        public static string _repo_connectionString;
        public static string EatLeadingSlash(string s)
        {
            while (true)
            {
                if (s.IndexOf("\\") == 0)
                    s = s.Substring(1);
                else
                    break;
            }

            return s;

        }
        public static List<string> GetFolderComponents(string dirPath)
        {
            //assume that dirpath has only folder components
            dirPath = EatLeadingSlash(dirPath);
            string component;

            List<string> retVal = new List<string>();

            while (true)
            {
                int ix = dirPath.IndexOf("\\");
                if (ix > 0)
                {
                    component = dirPath.Substring(0, ix);
                    retVal.Add(component);
                    dirPath = dirPath.Substring(ix + 1);
                    dirPath = EatLeadingSlash(dirPath);
                }
                else break;
            }

            if (dirPath.Length > 0)
                retVal.Add(dirPath);

            return retVal;


        }
        public static void ReadStream(string path, out byte[] b)
        {
            System.IO.FileStream fs = new System.IO.FileStream
                        (path
                        , System.IO.FileMode.Open
                        , System.IO.FileAccess.Read);

            b = new byte[fs.Length];
            fs.Read(b, 0, b.Length);
            fs.Close();
        }
        public static void EnumerateUserItems(UserRepository repo, DirectoryInfo thisDirInfo, RepositoryFolder thisFolder, long userId)
        {
            /*
             * foreach file in this directory
             *  init folder structure in repo
             *  init an item
             *  init a bundle
             *  stuff bitstream in the right place
             *  
             * foreach directory in this directory
             *  recurse
             *  
             */

            string fullName = thisDirInfo.FullName;

            FileInfo[] fileInfos = thisDirInfo.GetFiles();

            foreach (FileInfo fileInfo in fileInfos)
            {
                RepositoryItem item = thisFolder.AddItem(fileInfo.Name, userId);
                Bundle bundle = item.Bundle;

                byte[] b;
                ReadStream(fileInfo.FullName, out b);
                bundle.AddBitstream(b, fileInfo.Name, fileInfo.Extension, "", "", true, userId);
            }

            DirectoryInfo[] dirInfos = thisDirInfo.GetDirectories();
            foreach (DirectoryInfo subDirInfo in dirInfos)
            {
                if (subDirInfo.Name == "_svn")
                    continue;
                if (subDirInfo.Name == "_Recycle Bin")
                    continue;
                //if ((subDirInfo.GetFiles().Length == 0) && (subDirInfo.GetDirectories().Length == 0))
                //  continue;
                RepositoryFolder nextFolder = thisFolder.AddFolder(subDirInfo.Name);

                EnumerateUserItems(repo, subDirInfo, nextFolder, userId);
            }
        }
        public static void DoUserRepo(RepositoryMgr mgr, DirectoryInfo thisDirInfo)
        {
            long userId = Convert.ToInt64(thisDirInfo.Name.Substring(1));
            UserRepository repo = mgr.SetupRepositoryForUser(userId);
            EnumerateUserItems(repo, thisDirInfo, repo.Root, userId);
        }
        static void Main(string[] args)
        {
            DirectoryInfo thisDirInfo = null;
            if (args.Length == 0)
            {
                _repo_connectionString = "data source=localhost;database=COE_Student_Repo;"
                        + "uid=hoc;pwd=mumBleFr@tz;Pooling=true;Max Pool Size=2000;";

                thisDirInfo = new DirectoryInfo(_testDataBasePath);
            }
            else
            {
                //first arg is the database, and this always assumes localhost and
                // sa password of '', so that it should fail anywhere else
                _repo_connectionString = "data source=localhost;database=" + args[0]
                + ";uid=hoc;pwd=mumBleFr@tz;Pooling=true;Max Pool Size=2000;";

                thisDirInfo = new DirectoryInfo(args[1]);
            }
            RepositoryMgr repoMgr = new RepositoryMgr(_repo_connectionString);
            DirectoryInfo[] dirInfos = thisDirInfo.GetDirectories("_*");
            foreach (DirectoryInfo subDirInfo in dirInfos)
            {
                if (subDirInfo.Name == "_svn")
                    continue;
                DoUserRepo(repoMgr, subDirInfo);
            }
        }
    }
}
