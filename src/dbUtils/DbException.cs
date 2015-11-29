using System;

namespace DbUtils
{
	/// <summary>
	/// The DbException class is used to report errors that occur when a database
	/// operation fails.
	/// </summary>
	[Serializable]
	public class DbException : Exception
	{
		/// <summary>
		/// Create a new exception with the specified error message.
		/// </summary>
		/// <param name="message">Error message.</param>
		public DbException(string message) : base(message)
		{
		}

		/// <summary>
		/// Creates a new exception that concatenates a caught exception message to
		/// the current error message.
		/// </summary>
		/// <param name="message"></param>
		/// <param name="innerException"></param>
		public DbException(string message, Exception innerException) : base(message + ": " + innerException.Message)
		{
		}
	}
}
