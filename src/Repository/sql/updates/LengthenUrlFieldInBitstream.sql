DECLARE @currentLength INT = COL_LENGTH('Bitstream', 'URL')

if @currentLength < 3000

ALTER TABLE bitstream ALTER COLUMN url VARCHAR(3000)
