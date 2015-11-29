-- ==============================================
--
-- Add Auditing columns to tables
-- ==============================================



ALTER TABLE SERubricRowScore 
ADD EditUsername NVARCHAR(256) NULL, 
	EditDate DATE null DEFAULT(GetUTCDate())
	

