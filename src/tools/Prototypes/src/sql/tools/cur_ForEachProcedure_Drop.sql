
DECLARE cur_ForEachProcedure CURSOR
READ_ONLY
FOR 
SELECT Name
  FROM dbo.sysobjects
 WHERE OBJECTPROPERTY(id, N'IsProcedure') = 1   -- it is a procedure.
   AND OBJECTPROPERTY(id, N'IsMSShipped') = 0   -- it is not a system supplied procedure.
   AND [Name] NOT LIKE '%aspnet_%'

DECLARE @name      SYSNAME
DECLARE @SQL_Text  NVARCHAR(4000)

OPEN cur_ForEachProcedure

FETCH NEXT FROM cur_ForEachProcedure INTO @name
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN

      SELECT @SQL_Text = 'DROP PROCEDURE [' + @Name + ']'
      EXEC(@SQL_Text)

	END
	FETCH NEXT FROM cur_ForEachProcedure INTO @name
END

CLOSE cur_ForEachProcedure
DEALLOCATE cur_ForEachProcedure
GO
