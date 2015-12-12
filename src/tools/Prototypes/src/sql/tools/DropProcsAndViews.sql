DECLARE @procedureName varchar(500)
DECLARE cur CURSOR
      FOR SELECT [name] FROM sys.objects WHERE type = 'p'
      OPEN cur

      FETCH NEXT FROM cur INTO @procedureName
      WHILE @@fetch_status = 0
      BEGIN
            EXEC('DROP PROCEDURE ' + @procedureName)
            FETCH NEXT FROM cur INTO @procedureName
      END
      CLOSE cur
      DEALLOCATE cur
GO

DECLARE @viewName varchar(500)
DECLARE cur CURSOR
      FOR SELECT [name] FROM sys.objects WHERE type = 'v'
      OPEN cur

      FETCH NEXT FROM cur INTO @viewName
      WHILE @@fetch_status = 0
      BEGIN
            EXEC('DROP VIEW ' + @viewName)
            FETCH NEXT FROM cur INTO @viewName
      END
      CLOSE cur
      DEALLOCATE cur
GO




