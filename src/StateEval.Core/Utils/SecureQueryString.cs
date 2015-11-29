using System;
using System.Collections.Specialized;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;

namespace StateEval.Core.Utils
{
    /// <summary>
    /// Provides a secure means for transfering data within a query string.
    /// </summary>
    public class SecureQueryString : NameValueCollection
    {
        public SecureQueryString() : base() { }

        public SecureQueryString(string encryptedString)
        {
            // strip of the leading/trailing character. it is there
            // only to prevent '+' char from getting removed when calling
            // Request.QueryString["Data"] when it is the
            // last character in the encrypted string.
            string s = encryptedString.Substring(1, encryptedString.Length - 2);
            if (s.IndexOf(" ") != -1)
                s = s.Replace(" ", "+");
            if (s.IndexOf("|") != -1)
                s = s.Replace("|", "=");
            string decrypted = decrypt(s);
            deserialize(decrypted);
        }

        public bool QueryStringValueExists(string key)
        {
            string sVal = this[key];
            if (sVal != null && sVal != "-1" && sVal != "")
                return true;
            return false;
        }

        new public void Remove(string key)
        {
            base.Remove(key);
        }

        /// <summary>
        /// Returns the encrypted query string.
        /// </summary>
        public string EncryptedString
        {
            get
            {
                string encrypted = encrypt(serialize());
                string encoded = HttpUtility.UrlEncode(encrypted);
                return encoded;
            }
        }

        /// <summary>
        /// Returns the EncryptedString property.
        /// </summary>
        public override string ToString()
        {
            return EncryptedString;
        }

        /// <summary>
        /// Encrypts a serialized query string 
        /// </summary>
        private string encrypt(string serializedQueryString)
        {
            byte[] buffer = Encoding.ASCII.GetBytes(serializedQueryString);
            TripleDESCryptoServiceProvider des = new TripleDESCryptoServiceProvider();
            MD5CryptoServiceProvider MD5 = new MD5CryptoServiceProvider();
            des.Key = MD5.ComputeHash(ASCIIEncoding.ASCII.GetBytes(cryptoKey));
            des.IV = IV;
            // add leading/trailing character. it is there
            // only to prevent '+' char from getting removed when calling
            // Request.QueryString["Data"] when it is the
            // last character in the encrypted string.

            string encrypted = Convert.ToBase64String(
                des.CreateEncryptor().TransformFinalBlock(
                    buffer,
                    0,
                    buffer.Length
                )
            );
            if (encrypted.IndexOf("=") != -1)
                encrypted = encrypted.Replace("=", "|");
            return "a" + encrypted + "a";
        }

        /// <summary>
        /// Decrypts a serialized query string
        /// </summary>
        private string decrypt(string encryptedQueryString)
        {
            try
            {
                byte[] buffer = Convert.FromBase64String(encryptedQueryString);
                TripleDESCryptoServiceProvider des = new TripleDESCryptoServiceProvider();
                MD5CryptoServiceProvider MD5 = new MD5CryptoServiceProvider();
                des.Key = MD5.ComputeHash(ASCIIEncoding.ASCII.GetBytes(cryptoKey));
                des.IV = IV;
                return Encoding.ASCII.GetString(
                    des.CreateDecryptor().TransformFinalBlock(
                        buffer,
                        0,
                        buffer.Length
                    )
                );
            }
            catch (CryptographicException)
            {
                throw new InvalidQueryStringException();
            }
            catch (FormatException)
            {
                throw new InvalidQueryStringException();
            }
        }

        /// <summary>
        /// Deserializes a decrypted query string and stores it
        /// as name/value pairs.
        /// </summary>
        private void deserialize(string decryptedQueryString)
        {
            string[] nameValuePairs = decryptedQueryString.Split('&');
            for (int i = 0; i < nameValuePairs.Length; i++)
            {
                string[] nameValue = nameValuePairs[i].Split('=');
                if (nameValue.Length == 2)
                {
                    base.Add(nameValue[0], nameValue[1]);
                }
            }
        }

        /// <summary>
        /// Serializes the underlying NameValueCollection as a QueryString
        /// </summary>
        private string serialize()
        {
            StringBuilder sb = new StringBuilder();
            bool first = true;
            foreach (string key in base.AllKeys)
            {
                if (first)
                {
                    first = false;
                }
                else
                {
                    sb.Append('&');
                }
                sb.Append(key);
                sb.Append('=');
                sb.Append(base[key]);
            }

            return sb.ToString();
        }

        // The key used for generating the encrypted string
        private const string cryptoKey = "Don't worry.  If plan A fails, there are 25 more letters in the alphabet.";

        // The Initialization Vector for the DES encryption routine
        private readonly byte[] IV = new byte[8] { 240, 3, 45, 29, 0, 76, 173, 59 };
    }

}
