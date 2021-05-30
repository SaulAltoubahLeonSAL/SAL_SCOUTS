-- ENCRIPTADO DE COLUMNAS

USE master
GO

-- Controlamos la existencia de la BD contenida
DROP DATABASE IF EXISTS SCOUTS_PRACTICE
GO

CREATE DATABASE SCOUTS_PRACTICE
GO

ALTER DATABASE SCOUTS_PRACTICE
	SET CONTAINMENT = PARTIAL
GO

USE SCOUTS_PRACTICE
GO

DROP SCHEMA IF EXISTS PRACTICE
GO

CREATE SCHEMA PRACTICE
GO

CREATE LOGIN PEPO WITH PASSWORD = 'Abcd1234.';
go

CREATE USER PEPO
GO

CREATE MASTER KEY ENCRYPTION BY PASSWORD='Abcd1234.'
GO

DROP TABLE IF EXISTS PRACTICE.SCOUTS_ENCRYPT
GO

SELECT fecha_compra,producto,cod_producto,cantidad,precio
	INTO SCOUTS_PRACTICE.PRACTICE.SCOUTS_ENCRYPT
	FROM SAL_SCOUTS.dbo.SAL_FACTURA_MATERIAL
GO
-- (10000 rows affected)

SELECT top 5 fecha_compra,producto,cod_producto,cantidad,precio FROM PRACTICE.SCOUTS_ENCRYPT
GO

-- fecha_compra	producto	cod_producto	cantidad	precio
-- 2020-04-05	Ziplock		83054			29			190,83
-- 2019-03-20	Ziplock		43417			12			177,08
-- 2020-06-20	Ice_chest	45414			42			70,30
-- 2021-01-13	Can_opener	64114			33			178,76
-- 2017-07-12	bed			40866			49			126,94

GRANT SELECT,INSERT,UPDATE,ALTER ON PRACTICE.SCOUTS_ENCRYPT TO PEPO
GO

CREATE CERTIFICATE Scout_CertPRACT AUTHORIZATION PEPO
   WITH SUBJECT = 'Certificate Practice', START_DATE='2021/05/05';
GO

SELECT name certName,
	certificate_id CertID,
	pvt_key_encryption_type_desc EncryptType,
	issuer_name Issuer
from sys.certificates;
go
-- (1 row affected)

-- certName			CertID	EncryptType				 Issuer
-- Scout_CertPRACT	256		ENCRYPTED_BY_MASTER_KEY	 Certificate Practice

CREATE SYMMETRIC KEY SK_SCOUT_PRACTICE
    WITH ALGORITHM = AES_256
    ENCRYPTION BY CERTIFICATE Scout_CertPRACT;
GO

SELECT name KeyName,
  symmetric_key_id KeyID,
  key_length KeyLength,
  algorithm_desc KeyAlgorithm
FROM sys.symmetric_keys;
GO
-- (1 row affected)

-- KeyName						KeyID	KeyLength	KeyAlgorithm
-- ##MS_DatabaseMasterKey##		101		256			AES_256
-- SK_SCOUT_PRACTICE			256		256			AES_256

SELECT *
FROM sys.symmetric_keys
GO

-- name							principal_id	symmetric_id	key_length	key_algorithm	algorithm_desc	create_date					modify_date					key_guid								key_thumbprint	provider_type	cryptographic_provider_guid		cryptographic_provider_algid
-- ##MS_DatabaseMasterKey##		1				101				256			A3				AES_256			2021-05-05 11:53:20.653		2021-05-05 11:53:20.653		40F09500-548F-4E10-8E4D-5F3565A651FA	NULL			NULL			NULL							NULL
-- SK_SCOUT_PRACTICE			1				256				256			A3				AES_256			2021-05-05 11:53:26.950		2021-05-05 11:53:26.950		512AD600-6729-4BD6-89EB-041592A2A561	NULL			NULL			NULL							NULL

EXECUTE AS USER = 'PEPO';
GO

PRINT USER
GO
-- PEPO

OPEN SYMMETRIC KEY SK_SCOUT_PRACTICE
   DECRYPTION BY CERTIFICATE Scout_CertPRACT;
GO
-- Msg 15151, Level 16, State 1, Line 122
-- Cannot find the symmetric key 'SK_SCOUT_PRACTICE', because it does not exist or you do not have permission.

REVERT
GO

PRINT USER
GO
-- dbo

GRANT VIEW DEFINITION ON CERTIFICATE::Scout_CertPRACT to PEPO
go
--Cannot  grant,  deny,  or  revoke  permissions  to  sa,  dbo,  entity  owner, information_schema, sys, or yourself.
GRANT VIEW DEFINITION ON SYMMETRIC KEY::SK_SCOUT_PRACTICE to PEPO
go
-- Commands completed successfully

EXECUTE AS USER = 'PEPO';
GO

PRINT USER
GO
-- PEPO

ALTER TABLE PRACTICE.SCOUTS_ENCRYPT
	add  prod_encr varbinary(max);
GO

OPEN SYMMETRIC KEY SK_SCOUT_PRACTICE
   DECRYPTION BY CERTIFICATE Scout_CertPRACT;
GO
-- Commands completed successfully

UPDATE PRACTICE.SCOUTS_ENCRYPT 
	SET prod_encr = EncryptByKey(Key_GUID('SK_SCOUT_PRACTICE'),producto);
GO 
 
-- (10000 rows affected)

CLOSE SYMMETRIC KEY SK_SCOUT_PRACTICE; 
GO 

select top 5 * from PRACTICE.SCOUTS_ENCRYPT
go

-- fecha_compra	producto	cod_producto	cantidad	precio	prod_encr
-- 2020-04-05	Ziplock		83054			29			190,83	0x00E69B66F54C624380280ABD1A506F4102000000132909999DBF894A01D8B2F050ADD1D30EDC684F2091F2FCE4EFE4846725F9A0716531A22C6CD53ED202359074CED44C
-- 2019-03-20	Ziplock		43417			12			177,08	0x00E69B66F54C624380280ABD1A506F410200000028C588E8DD4BE9C2826FAADDFF3B50B185D5E5EFD7254638695D233870891184547422FBAD461AE7F2EA8EDD8A68BD5A
-- 2020-06-20	Ice_chest	45414			42			70,30	0x00E69B66F54C624380280ABD1A506F41020000005D8FFF91D444D82FB93E36A7EB9D11C7D4E0B1C5AB833769AB7F224E7A08E87CED03A91F19E59FF8A0C062FDC7CC5D56
-- 2021-01-13	Can_opener	64114			33			178,76	0x00E69B66F54C624380280ABD1A506F41020000006B28616A19E388E661D88223C209FF7261E525D47AA5922FA46A9D2FC9E5C3F3CEA665C325058D484643B49CC0AF55BE
-- 2017-07-12	bed			40866			49			126,94	0x00E69B66F54C624380280ABD1A506F41020000001E5C698646FAB0FAEB2CC0B19A81BE47DA19A493BEE37EB42A3F5B0B7738765E

REVERT
GO

REVOKE VIEW DEFINITION ON CERTIFICATE::Scout_CertPRACT to PEPO
go
--Cannot  grant,  deny,  or  revoke  permissions  to  sa,  dbo,  entity  owner, information_schema, sys, or yourself.
REVOKE VIEW DEFINITION ON SYMMETRIC KEY::SK_SCOUT_PRACTICE to PEPO
go

EXECUTE AS USER = 'PEPO'
GO

PRINT USER
GO

SELECT top 5 producto,CONVERT(VARCHAR,DECRYPTBYKEY(prod_encr)) as PRODUCTO_ENCRIPTADO from PRACTICE.SCOUTS_ENCRYPT
GO


-- -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-
-- ENCRIPTADO DE BACKUPS

USE master
GO

SELECT * FROM master.sys.symmetric_keys
GO

-- name						principal_id	symmetric_key_id	key_length	key_algorithm	algorithm_desc	create_date				 modify_date				key_guid								key_thumbprint	provider_type	cryptographic_provider_guid		cryptographic_provider_algid
-- ##MS_ServiceMasterKey##	1				102					256			A3				AES_256			2021-02-06 13:28:01.903	 2021-02-06 13:28:01.903	E9A9DA63-5A9B-4FFF-AC5F-2ABAFAABACA5	NULL			NULL			NULL							NULL

CREATE MASTER KEY ENCRYPTION BY PASSWORD ='Abcd1234.'
GO

-- name						 principal_id	symmetric_key_id	key_length	key_algorithm	algorithm_desc	create_date				 modify_date				key_guid								key_thumbprint	provider_type	cryptographic_provider_guid		cryptographic_provider_algid
-- ##MS_DatabaseMasterKey##	 1				101					256			A3				AES_256			2021-05-05 23:21:21.707	 2021-05-05 23:21:21.707	67DB5800-5090-43BA-916E-914BD70ACD1F	NULL			NULL			NULL							NULL
-- ##MS_ServiceMasterKey##	 1				102					256			A3				AES_256			2021-02-06 13:28:01.903	 2021-02-06 13:28:01.903	E9A9DA63-5A9B-4FFF-AC5F-2ABAFAABACA5	NULL			NULL			NULL							NULL
CREATE CERTIFICATE SAL_SCOUTSCert
   WITH SUBJECT = 'CERT SAL';
GO

BACKUP MASTER KEY TO FILE = 'C:\Program Files\Microsoft SQL Server\MSSQL14.SALSCOUTS\MSSQL\DATA\kys\SAL_dmk.key'
	ENCRYPTION BY PASSWORD = 'Abcd1234.';
GO

BACKUP CERTIFICATE SAL_SCOUTSCert
	TO FILE = 'C:\backup\SALCertBAK.cer'
	WITH PRIVATE KEY (
		FILE = 'C:\backup\SAL_certKEY.pvk',
		ENCRYPTION BY PASSWORD = 'Abcd1234.')
GO

BACKUP DATABASE SAL_SCOUTS
	TO DISK = 'c:\backup\SAL_SCOUTS.bak'
	WITH ENCRYPTION (ALGORITHM = AES_256, SERVER CERTIFICATE = SAL_SCOUTSCert)
GO
-- Processed 1376 pages for database 'SAL_SCOUTS', file 'SAL_SCOUTS_main' on file 1.
-- Processed 64 pages for database 'SAL_SCOUTS', file 'SAL_SCOUTS_FG01' on file 1.
-- Processed 64 pages for database 'SAL_SCOUTS', file 'SAL_SCOUTS_FG02' on file 1.
-- Processed 1388 pages for database 'SAL_SCOUTS', file 'SAL_SCOUTS_FILESTREAM_Main' on file 1.
-- Processed 2 pages for database 'SAL_SCOUTS', file 'SAL_SCOUTS_log' on file 1.
-- Processed 0 pages for database 'SAL_SCOUTS', file 'SAL_SCOUTS_log2' on file 1.
-- BACKUP DATABASE successfully processed 2893 pages in 8.729 seconds (2.588 MB/sec).



BACKUP LOG SAL_SCOUTS
	TO DISK='C:\backup\SAL_SCOUTS_log.bak'
	WITH ENCRYPTION (ALGORITHM = AES_256, SERVER CERTIFICATE = SAL_SCOUTSCert);
GO

-- Processed 3 pages for database 'SAL_SCOUTS', file 'SAL_SCOUTS_log' on file 1.
-- Processed 0 pages for database 'SAL_SCOUTS', file 'SAL_SCOUTS_log2' on file 1.
-- BACKUP LOG successfully processed 3 pages in 0.032 seconds (0.701 MB/sec).



DROP DATABASE IF EXISTS SAL_SCOUTS
GO

RESTORE DATABASE SAL_SCOUTS
	FROM DISK = 'C:\backup\SAL_SCOUTS.bak'
GO
-- Processed 1376 pages for database 'SAL_SCOUTS', file 'SAL_SCOUTS_main' on file 1.
-- Processed 64 pages for database 'SAL_SCOUTS', file 'SAL_SCOUTS_FG01' on file 1.
-- Processed 64 pages for database 'SAL_SCOUTS', file 'SAL_SCOUTS_FG02' on file 1.
-- Processed 2 pages for database 'SAL_SCOUTS', file 'SAL_SCOUTS_log' on file 1.
-- Processed 0 pages for database 'SAL_SCOUTS', file 'SAL_SCOUTS_log2' on file 1.
-- Processed 1394 pages for database 'SAL_SCOUTS', file 'SAL_SCOUTS_FILESTREAM_Main' on file 1.
-- RESTORE DATABASE successfully processed 2899 pages in 26.417 seconds (0.857 MB/sec).



-- -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-
-- TRANSPARENT DATA ENCRYPTION (TDE)

CREATE CERTIFICATE SAL_TDEScout
	WITH SUBJECT = 'SAL TDE SCOUT';
GO
-- Commands completed successfully

SELECT TOP 1 * 
FROM sys.certificates 
ORDER BY name DESC
GO
-- name			cetificate_id	principal_id	pvt_key_encryption_type	pvt_key_encryption_type_desc	is_active_for_begin_dialog	issuer_name		cert_serial_number								sid																	string_sid														subject			expiry_date					start_date					thumbprint									attested_by	pvt_key_last_backup_date	key_length
-- SAL_TDEScout	260				1				MK						ENCRYPTED_BY_MASTER_KEY			1							SAL TDE SCOUT	79 77 ab 28 f3 0b 15 9e 4f ec 4f 0f 0c 4c 3a 1b	0x010600000000000901000000D13BB7301FDF9ED16F0377F17D7CB414F2BCAE5A	S-1-9-1-817314769-3516849951-4051108719-347372669-1521401074	SAL TDE SCOUT	2022-05-06 11:00:22.000		2021-05-06 11:00:22.000		0xD13BB7301FDF9ED16F0377F17D7CB414F2BCAE5A	NULL		NULL						2048

BACKUP CERTIFICATE SAL_TDEScout
  TO FILE = 'C:\backup\bkp_TDE\SAL_TDEScout.cer'
  WITH PRIVATE KEY ( 
    FILE = 'C:\backup\bkp_TDE\SAL_TDEkey.pvk',
	ENCRYPTION BY PASSWORD = 'Abcd1234.'
);
GO

USE SAL_SCOUTS
GO

CREATE DATABASE ENCRYPTION KEY
  WITH ALGORITHM = AES_256
  ENCRYPTION BY SERVER CERTIFICATE SAL_TDEScout;
GO

SELECT  * 
FROM sys.dm_database_encryption_keys
GO

USE master;
GO 

ALTER DATABASE SAL_SCOUTS  SET ENCRYPTION ON;
GO 

SELECT * FROM sys.dm_database_encryption_keys;
select db_name(9);
SELECT DB_Name(database_id) AS 'Database', encryption_state 
FROM sys.dm_database_encryption_keys;
GO

BACKUP DATABASE SAL_SCOUTS
	TO DISK = 'C:\backup\bkp_TDE\SAL_SCOUTS_Full.bak';
GO
-- Processed 1376 pages for database 'SAL_SCOUTS', file 'SAL_SCOUTS_main' on file 1.
-- Processed 64 pages for database 'SAL_SCOUTS', file 'SAL_SCOUTS_FG01' on file 1.
-- Processed 64 pages for database 'SAL_SCOUTS', file 'SAL_SCOUTS_FG02' on file 1.
-- Processed 1037 pages for database 'SAL_SCOUTS', file 'SAL_SCOUTS_FILESTREAM_Main' on file 1.
-- Processed 3 pages for database 'SAL_SCOUTS', file 'SAL_SCOUTS_log' on file 1.
-- Processed 0 pages for database 'SAL_SCOUTS', file 'SAL_SCOUTS_log2' on file 1.
-- BACKUP DATABASE successfully processed 2543 pages in 2.106 seconds (9.430 MB/sec).


BACKUP LOG SAL_SCOUTS
TO DISK = 'C:\backup\bkp_TDE\SAL_SCOUTS_log.bak'
With NORECOVERY
GO
-- Processed 3374 pages for database 'SAL_SCOUTS', file 'SAL_SCOUTS_log' on file 1.
-- Processed 0 pages for database 'SAL_SCOUTS', file 'SAL_SCOUTS_log2' on file 1.
-- BACKUP LOG successfully processed 3374 pages in 0.202 seconds (130.455 MB/sec).


RESTORE DATABASE SAL_SCOUTS
  FROM DISK = N'\\vmware-host\Shared Folders\SSD_host\backup\bkp_TDE\SAL_SCOUTS_Full.bak'
  WITH MOVE 'SAL_SCOUTS_main' TO N'C:\Program Files\Microsoft SQL Server\MSSQL14.SALSCOUTS\MSSQL\DATA\SAL_SCOUTS_main.mdf',
       MOVE 'SAL_SCOUTS_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL14.SALSCOUTS\MSSQL\DATA\SAL_SCOUTS_log.ldf';
GO
-- Processed 1376 pages for database 'SAL_SCOUTS', file 'SAL_SCOUTS_main' on file 1.
-- Processed 64 pages for database 'SAL_SCOUTS', file 'SAL_SCOUTS_FG01' on file 1.
-- Processed 64 pages for database 'SAL_SCOUTS', file 'SAL_SCOUTS_FG02' on file 1.
-- Processed 2 pages for database 'SAL_SCOUTS', file 'SAL_SCOUTS_log' on file 1.
-- Processed 0 pages for database 'SAL_SCOUTS', file 'SAL_SCOUTS_log2' on file 1.
-- Processed 1044 pages for database 'SAL_SCOUTS', file 'SAL_SCOUTS_FILESTREAM_Main' on file 1.
-- RESTORE DATABASE successfully processed 2549 pages in 2.753 seconds (7.232 MB/sec).
