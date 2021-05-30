USE SAL_SCOUTS
GO


insert into SAL_REUNION 
	(ID_reunion, fecha_hora_inicio, fecha_hora_final, nom_reunion, descripcion, lugar, SAL_SCOUTER_ID_personal, SAL_GRUPO_SCOUT_ID_grupo_scout) 
	values (1001, '2020-07-02 01:23:52', '2021-04-08 05:03:51', 'ULTRA CORRECTION', 'Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 'Spain', 6, 3);
-- Msg 206, Level 16, State 2, Line 8
-- Operand type clash: varchar is incompatible with varchar(8000) encrypted with (encryption_type = 'RANDOMIZED', encryption_algorithm_name = 'AEAD_AES_256_CBC_HMAC_SHA_256', column_encryption_key_name = 'CEK_Auto1', column_encryption_key_database_name = 'SAL_SCOUTS') collation_name = 'Modern_Spanish_CI_AS'


DECLARE @name VARCHAR(50) = 'Carvedilol';
SELECT * FROM dbo.SAL_REUNION
WHERE nom_reunion = @name;
GO

-- Msg 33299, Level 16, State 2, Line 14
-- Encryption scheme mismatch for columns/variables '@name', 'nom_reunion'. The encryption scheme for the columns/variables is 
-- (encryption_type = 'RANDOMIZED', encryption_algorithm_name = 'AEAD_AES_256_CBC_HMAC_SHA_256', column_encryption_key_name = 'CEK_Auto1', column_encryption_key_database_name = 'SAL_SCOUTS') and the expression near line '3' expects it to be (encryption_type = 'DETERMINISTIC') (or weaker). 


DECLARE @name VARCHAR(50) = 'Carvedilol';
SELECT * FROM dbo.SAL_REUNION
WHERE nom_reunion = @name;
GO
