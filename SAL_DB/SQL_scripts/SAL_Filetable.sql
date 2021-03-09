USE master
GO

DROP DATABASE IF EXISTS SAL_SCOUTS_FT
GO

-- Crear previamente el directorio "C:\SAL_FT"
CREATE DATABASE SAL_SCOUTS_FT
ON PRIMARY (
	NAME = SAL_SCOUTS_FT_data,
	FILENAME = 'C:\SAL_FT\SAL_SCOUTS_FT.mdf'
),
FILEGROUP SAL_FileStream CONTAINS FILESTREAM (
	NAME = SAL_SCOUTS_FT,
	FILENAME = 'C:\SAL_FT\SAL_SCOUTS_FT_Container'
)
LOG ON (
	NAME = SAL_SCOUTS_FT_log,
	FILENAME = 'C:\SAL_FT\SAL_SCOUTS_FT_log.ldf'
)
WITH FILESTREAM (
	NON_TRANSACTED_ACCESS = FULL,
	DIRECTORY_NAME = 'SAL_SCOUTS_FTContainer'
);
GO
 
-- REVISIÓN DE METADATOS

-- Realizar un SELECT para revisar las opciones de FileStream
SELECT DB_NAME(database_id),
non_transacted_access,
non_transacted_access_desc
FROM sys.database_filestream_options;
GO
-- DatabaseName			non_transacted_access	non_transacted_access_desc
-- master				0						OFF
-- model				0						OFF
-- SAL_SCOUTS_FT		2						FULL
-- msdb					0						OFF
-- WideWorldImporters	0						OFF
-- NULL					0						OFF
-- AdventureWorks2017	0						OFF
-- Northwind			0						OFF
-- tempdb				0						OFF
-- SAL_SCOUTS			0						OFF
-- pubs					0						OFF



-- Alternativa de revisión de opciones FS
SELECT DB_NAME(database_id) as DatabaseName, non_transacted_access, non_transacted_access_desc 
FROM sys.database_filestream_options
where DB_NAME(database_id)='SAL_SCOUTS_FT';
GO

-- DatabaseName		non_transacted_access	non_transacted_access_desc
-- SAL_SCOUTS_FT	2						FULL

USE SAL_SCOUTS_FT
GO

DROP TABLE IF EXISTS SAL_factura_material
GO

CREATE TABLE SAL_factura_material 
AS FILETABLE WITH(
    FileTable_Directory = 'SAL_SCOUTS_FTContainer',
    FileTable_Collate_Filename = database_default
);
GO
-- No es necesario indicar las columnas ya que automáticamente lo hará el sistema.
-- Ahora cada vez que se introduzca un archivo en el FileTable, se mostrará la información
-- ejecutando SELECT a la tabla con FileTable





SELECT * from SAL_factura_material
GO
