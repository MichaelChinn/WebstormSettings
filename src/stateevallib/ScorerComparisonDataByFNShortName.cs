using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;

using System.Data.SqlClient;

using DbUtils;

namespace StateEval
{
    public class ScorerComparisonDataByFNShortName
    {
        DbConnector _conn;
        long _practiceSessionId;
        SEFramework _framework;
        SEFrameworkNode _node;
        ICalibrationScoreElement[] _elements;
        string _sproc;
        string _field;

        List<long> _scorers = new List<long>();
        Hashtable _scorerHash = new Hashtable();
        Hashtable _scoreHash = new Hashtable();

        public List<long> ScorerIds { get { return _scorers; } }

        public string ScorerName(long scorerId)
        {
            return Convert.ToString(_scorerHash[scorerId.ToString()]);
        }

        public SERubricPerformanceLevel Score(string key)
        {
            return (SERubricPerformanceLevel)Convert.ToInt32(_scoreHash[key]);
        }

        public int ScoreAsInt(string key)
        {
            return Convert.ToInt32(Score(key));
        }

        public SERubricPerformanceLevel ScoreForScorer(long scorerId, string criteria)
        {
            return (SERubricPerformanceLevel)Convert.ToInt32(_scorerHash[scorerId + ":" + criteria]);
        }

        public ScorerComparisonDataByFNShortName(DbConnector conn, string sproc, string field, long practiceSessionId, SEFramework framework, SEFrameworkNode node, ICalibrationScoreElement[] elements)
        {
            _conn = conn;
            _practiceSessionId = practiceSessionId;
            _framework = framework;
            _node = node;
            _elements = elements;
            _sproc = sproc;
            _field = field;
        }
        
        void LoadNonAdjacentCountsFromReader(SqlDataReader reader)
        {
            while (reader.Read())
            {
                string c = Convert.ToString(reader[_field]);
                int count = (int)reader["Count"];

                string key = c + "NONADJACENTCOUNT";
                _scoreHash[key] = (Convert.ToInt32(_scoreHash[key]) + count).ToString();
                key = c + "COUNT";
                _scoreHash[key] = (Convert.ToInt32(_scoreHash[key]) + count).ToString();
                key = "NONADJACENTCOUNT";
                _scoreHash[key] = (Convert.ToInt32(_scoreHash[key]) + count).ToString();
                key = "TOTALCOUNT";
                _scoreHash[key] = (Convert.ToInt32(_scoreHash[key]) + count).ToString();
            }
        }

        void LoadSummativeNonAdjacentCountsFromReader(SqlDataReader reader)
        {
            while (reader.Read())
            {
                int count = (int)reader["Count"];
                _scoreHash["SUMNONADJACENTCOUNT"] = (Convert.ToInt32(_scoreHash["SUMNONADJACENTCOUNT"]) + count).ToString();
                _scoreHash["SUMCOUNT"] = (Convert.ToInt32(_scoreHash["SUMCOUNT"]) + count).ToString();
                _scoreHash["NONADJACENTCOUNT"] = (Convert.ToInt32(_scoreHash["NONADJACENTCOUNT"]) + count).ToString();
                _scoreHash["TOTALCOUNT"] = (Convert.ToInt32(_scoreHash["TOTALCOUNT"]) + count).ToString();
            }
        }
        
        void LoadNonAdjacentLowCountsFromReader(SqlDataReader reader)
        {
            while (reader.Read())
            {
                string c = Convert.ToString(reader[_field]);
                int count = (int)reader["Count"];

                string key = c + "NONADJACENTLOWCOUNT";
                _scoreHash[key] = (Convert.ToInt32(_scoreHash[key]) + count).ToString();
                 key = "NONADJACENTLOWCOUNT";
                _scoreHash[key] = (Convert.ToInt32(_scoreHash[key]) + count).ToString();
            }
        }

        void LoadSummativeNonAdjacentLowCountsFromReader(SqlDataReader reader)
        {
            while (reader.Read())
            {
                int count = (int)reader["Count"];
                _scoreHash["SUMNONADJACENTLOWCOUNT"] = (Convert.ToInt32(_scoreHash["SUMNONADJACENTLOWCOUNT"]) + count).ToString();
            }
        }
   
        void LoadNonAdjacentHighCountsFromReader(SqlDataReader reader)
        {
            while (reader.Read())
            {
                string c = Convert.ToString(reader[_field]);
                int count = (int)reader["Count"];

                string key = c + "NONADJACENTHIGHCOUNT";
                _scoreHash[key] = (Convert.ToInt32(_scoreHash[key]) + count).ToString();
                key = "NONADJACENTHIGHCOUNT";
                _scoreHash[key] = (Convert.ToInt32(_scoreHash[key]) + count).ToString();
            }
        }

        void LoadSummativeNonAdjacentHighCountsFromReader(SqlDataReader reader)
        {
            while (reader.Read())
            {
                int count = (int)reader["Count"];
                _scoreHash["SUMNONADJACENTHIGHCOUNT"] = (Convert.ToInt32(_scoreHash["SUMNONADJACENTHIGHCOUNT"]) + count).ToString();
            }
        }
  
        void LoadAdjacentCountsFromReader(SqlDataReader reader)
        {
            while (reader.Read())
            {
                string c = Convert.ToString(reader[_field]);
                int count = (int)reader["Count"];

                string key = c + "ADJACENTCOUNT";
                _scoreHash[key] = (Convert.ToInt32(_scoreHash[key]) + count).ToString();
                key = c + "COUNT";
                _scoreHash[key] = (Convert.ToInt32(_scoreHash[key]) + count).ToString();
                key = "ADJACENTCOUNT";
                _scoreHash[key] = (Convert.ToInt32(_scoreHash[key]) + count).ToString();
                key = "TOTALCOUNT";
                _scoreHash[key] = (Convert.ToInt32(_scoreHash[key]) + count).ToString();
            }
        }

        void LoadSummativeAdjacentCountsFromReader(SqlDataReader reader)
        {
            while (reader.Read())
            {
                int count = (int)reader["Count"];
                _scoreHash["SUMADJACENTCOUNT"] = (Convert.ToInt32(_scoreHash["SUMADJACENTCOUNT"]) + count).ToString();
                _scoreHash["SUMCOUNT"] = (Convert.ToInt32(_scoreHash["SUMCOUNT"]) + count).ToString();
                _scoreHash["ADJACENTCOUNT"] = (Convert.ToInt32(_scoreHash["ADJACENTCOUNT"]) + count).ToString();
                _scoreHash["TOTALCOUNT"] = (Convert.ToInt32(_scoreHash["TOTALCOUNT"]) + count).ToString();

            }
        }
  
        void LoadAdjacentLowCountsFromReader(SqlDataReader reader)
        {
            while (reader.Read())
            {

                string c = Convert.ToString(reader[_field]);
                int count = (int)reader["Count"];

                string key = c + "ADJACENTLOWCOUNT";
                _scoreHash[key] = (Convert.ToInt32(_scoreHash[key]) + count).ToString();
                key = "ADJACENTLOWCOUNT";
                _scoreHash[key] = (Convert.ToInt32(_scoreHash[key]) + count).ToString();
             }
        }

        void LoadSummativeAdjacentLowCountsFromReader(SqlDataReader reader)
        {
            while (reader.Read())
            {
                int count = (int)reader["Count"];
                _scoreHash["SUMADJACENTLOWCOUNT"] = (Convert.ToInt32(_scoreHash["SUMADJACENTLOWCOUNT"]) + count).ToString();
            }
        }
      
        void LoadAdjacentHighCountsFromReader(SqlDataReader reader)
        {
            while (reader.Read())
            {
                string c = Convert.ToString(reader[_field]);
                int count = (int)reader["Count"];

                string key = c + "ADJACENTHIGHCOUNT";
                _scoreHash[key] = (Convert.ToInt32(_scoreHash[key]) + count).ToString();
                key = "ADJACENTHIGHCOUNT";
                _scoreHash[key] = (Convert.ToInt32(_scoreHash[key]) + count).ToString();
             }
        }

        void LoadSummativeAdjacentHighCountsFromReader(SqlDataReader reader)
        {
            while (reader.Read())
            {
                int count = (int)reader["Count"];
                _scoreHash["SUMADJACENTHIGHCOUNT"] = (Convert.ToInt32(_scoreHash["SUMADJACENTHIGHCOUNT"]) + count).ToString();
            }
        }
 
        void LoadExactCountsFromReader(SqlDataReader reader)
        {
            while (reader.Read())
            {
                string c = Convert.ToString(reader[_field]);
                int count = (int)reader["Count"];

                string key = c + "EXACTCOUNT";
                _scoreHash[key] = (Convert.ToInt32(_scoreHash[key]) + count).ToString();
                key = c + "COUNT";
                _scoreHash[key] = (Convert.ToInt32(_scoreHash[key]) + count).ToString();
                key = "EXACTCOUNT";
                _scoreHash[key] = (Convert.ToInt32(_scoreHash[key]) + count).ToString();
                key = "TOTALCOUNT";
                _scoreHash[key] = (Convert.ToInt32(_scoreHash[key]) + count).ToString();
            }
        }

        void LoadSummativeExactCountsFromReader(SqlDataReader reader)
        {
            while (reader.Read())
            {
                int count = (int)reader["Count"];
                _scoreHash["SUMEXACTCOUNT"] = (Convert.ToInt32(_scoreHash["SUMEXACTCOUNT"]) + count).ToString();
                _scoreHash["SUMCOUNT"] = (Convert.ToInt32(_scoreHash["SUMCOUNT"]) + count).ToString();
                _scoreHash["EXACTCOUNT"] = (Convert.ToInt32(_scoreHash["EXACTCOUNT"]) + count).ToString();
                _scoreHash["TOTALCOUNT"] = (Convert.ToInt32(_scoreHash["TOTALCOUNT"]) + count).ToString();
            }
        }
        
        void LoadScoreDistributionCountsFromReader(SqlDataReader reader)
        {
            while (reader.Read())
            {

                string c = Convert.ToString(reader[_field]);
                int score = Convert.ToInt32(reader["NonAnchorScore"]);
                int count = (int)reader["Count"];
                string key = c + score.ToString() + "COUNT";
                _scoreHash[key] = (Convert.ToInt32(_scoreHash[key]) + count).ToString();
            }
        }

        void LoadSummativeScoreDistributionCountsFromReader(SqlDataReader reader)
        {
            _scoreHash["SUM1COUNT"] = "0";
            _scoreHash["SUM2COUNT"] = "0";
            _scoreHash["SUM3COUNT"] = "0";
            _scoreHash["SUM4COUNT"] = "0";
 
            while (reader.Read())
            {
                int score = Convert.ToInt32(reader["NonAnchorScore"]);
                int count = (int)reader["Count"];
                string key = "SUM" + score.ToString() + "COUNT";
                _scoreHash[key] = (Convert.ToInt32(_scoreHash[key]) + count).ToString();
            }
        }

        void LoadScorersFromReader(SqlDataReader reader)
        {
            while (reader.Read())
            {
                long id = (long)reader["SEUserID"];
                string lastname = (string)reader["LastName"];
                string firstname = (string)reader["FirstName"];

                _scorers.Add(id);

                _scorerHash[id.ToString()] = lastname + ", " + firstname;
              }
        }

        void LoadSummativeScorersFromReader(SqlDataReader reader)
        {
            while (reader.Read())
            {
                long id = (long)reader["SEUserID"];
                string lastname = (string)reader["LastName"];
                string firstname = (string)reader["FirstName"];

                if (_scorerHash[id.ToString()] == null)
                {
                    _scorers.Add(id);
                    _scorerHash[id.ToString()] = lastname + ", " + firstname;
                }

                _scorerHash[id.ToString() + ":SUM"] = "0";
            }
        }

        void LoadNonAnchorScoresFromReader(SqlDataReader reader)
        {
            while (reader.Read())
            {
                string c = Convert.ToString(reader[_field]);
                string userId = Convert.ToString(reader["SEUserID"]);
                string key = userId.ToString() + ":" + c;
   
                if (_scorerHash[key] == null) _scorerHash[key] = "0";

                SERubricPerformanceLevel score = (SERubricPerformanceLevel)Convert.ToInt32(reader["NonAnchorScore"]);
                _scorerHash[key] = Convert.ToInt32(score).ToString();
            }
        }
        void LoadSummativeNonAnchorScoresFromReader(SqlDataReader reader)
        {
            while (reader.Read())
            {
                 string userId = Convert.ToString(reader["SEUserID"]);
                SERubricPerformanceLevel score = (SERubricPerformanceLevel)Convert.ToInt32(reader["NonAnchorScore"]);
                _scorerHash[userId.ToString() + ":SUM"] = Convert.ToInt32(score).ToString();
            }
        }
  
        void LoadAnchorScoresFromReader(SqlDataReader reader)
        {
            while (reader.Read())
            {
                string c = Convert.ToString(reader[_field]);
                SERubricPerformanceLevel score = (SERubricPerformanceLevel)Convert.ToInt32(reader["AnchorScore"]);
                _scoreHash[c + "AnchorScore"] = Convert.ToInt32(score).ToString();
            }
        }

        void LoadSummativeAnchorScoresFromReader(SqlDataReader reader)
        {
            if (reader.Read())
            {
                SERubricPerformanceLevel score = (SERubricPerformanceLevel)Convert.ToInt32(reader["AnchorScore"]);
                _scoreHash["SUMANCHORSCORE"] = Convert.ToInt32(score).ToString();
            }
        }

        public void LoadData(DbConnector conn)
        {
            _scoreHash["ADJACENTHIGHCOUNT"] = "0";
            _scoreHash["ADJACENTLOWCOUNT"] = "0";
            _scoreHash["NONADJACENTHIGHCOUNT"] = "0";
            _scoreHash["NONADJACENTLOWCOUNT"] = "0";
            _scoreHash["ADJACENTCOUNT"] = "0";
            _scoreHash["NONADJACENTCOUNT"] = "0";
            _scoreHash["TOTALCOUNT"] = "0";
            _scoreHash["SUMEXACTCOUNT"] = "0";
            _scoreHash["SUMCOUNT"] = "0";
            _scoreHash["SUMADJACENTCOUNT"] = "0";
            _scoreHash["SUMNONADJACENTCOUNT"] = "0";
            _scoreHash["SUMADJACENTHIGHCOUNT"] = "0";
            _scoreHash["SUMADJACENTLOWCOUNT"] = "0";
            _scoreHash["SUMNONADJACENTHIGHCOUNT"] = "0";
            _scoreHash["SUMNONADJACENTLOWCOUNT"] = "0";
            _scoreHash["SUMANCHORSCORE"] = "0";

            foreach (ICalibrationScoreElement n in _elements)
            {
                _scoreHash[n.Field + "EXACTCOUNT"] = "0";
                _scoreHash[n.Field + "ADJACENTCOUNT"] = "0";
                _scoreHash[n.Field + "ADJACENTHIGHCOUNT"] = "0";
                _scoreHash[n.Field + "ADJACENTLOWCOUNT"] = "0";
                _scoreHash[n.Field + "NONADJACENTCOUNT"] = "0";
                _scoreHash[n.Field + "NONADJACENTHIGHCOUNT"] = "0";
                _scoreHash[n.Field + "NONADJACENTLOWCOUNT"] = "0";
                _scoreHash[n.Field + "COUNT"] = "0";
            }

            SqlDataReader reader = null;
            try
            {
                if (_node == null)
                {
                    SqlParameter[] aParams = new SqlParameter[]
				    {
                        new SqlParameter("@ppracticeSessionId", _practiceSessionId),
                        new SqlParameter("@pFrameworkId", _framework.Id)
                    };

                    reader = conn.ExecuteDataReader(_sproc, aParams);
                }
                else
                {
                    SqlParameter[] aParams = new SqlParameter[]
				    {
                        new SqlParameter("@ppracticeSessionId", _practiceSessionId),
                        new SqlParameter("@pFrameworkId", _framework.Id),
                        new SqlParameter("@pFrameworkNodeShortName", _node.ShortName)
                    };

                    reader = conn.ExecuteDataReader(_sproc, aParams);
                }

                LoadAnchorScoresFromReader(reader);

                reader.NextResult();

                LoadScorersFromReader(reader);

                reader.NextResult();

                LoadNonAnchorScoresFromReader(reader);

                reader.NextResult();

                LoadExactCountsFromReader(reader);

                reader.NextResult();

                LoadAdjacentCountsFromReader(reader);

                reader.NextResult();

                LoadAdjacentHighCountsFromReader(reader);

                reader.NextResult();

                LoadAdjacentLowCountsFromReader(reader);

                reader.NextResult();

                LoadNonAdjacentCountsFromReader(reader);

                reader.NextResult();

                LoadNonAdjacentHighCountsFromReader(reader);

                reader.NextResult();

                LoadNonAdjacentLowCountsFromReader(reader);

                reader.NextResult();

                LoadScoreDistributionCountsFromReader(reader);

                // Now read the summative session scores if we are at the criteria level

                reader.NextResult();

                LoadSummativeAnchorScoresFromReader(reader);

                reader.NextResult();

                LoadSummativeScorersFromReader(reader);

                reader.NextResult();

                LoadSummativeNonAnchorScoresFromReader(reader);

                reader.NextResult();

                LoadSummativeExactCountsFromReader(reader);

                reader.NextResult();

                LoadSummativeAdjacentCountsFromReader(reader);

                reader.NextResult();

                LoadSummativeAdjacentHighCountsFromReader(reader);

                reader.NextResult();

                LoadSummativeAdjacentLowCountsFromReader(reader);

                reader.NextResult();

                LoadSummativeNonAdjacentCountsFromReader(reader);

                reader.NextResult();

                LoadSummativeNonAdjacentHighCountsFromReader(reader);

                reader.NextResult();

                LoadSummativeNonAdjacentLowCountsFromReader(reader);

                reader.NextResult();

                LoadSummativeScoreDistributionCountsFromReader(reader);

                reader.Close();
            }
            catch (Exception e)
            {
                if (reader != null)
                    reader.Close();

                throw e;
            }
        }

    }
}
