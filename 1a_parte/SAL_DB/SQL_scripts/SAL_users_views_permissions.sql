USE master
GO

-- Creaci?n de usuarios en SQL Server con autenticaci?n SQL

CREATE LOGIN JRM_SCOUTS WITH PASSWORD='Abcd1234.',
	DEFAULT_DATABASE = [master],
	DEFAULT_LANGUAGE = [us_english],
	CHECK_EXPIRATION = OFF,
	CHECK_POLICY = OFF
GO

CREATE LOGIN LGM_SCOUTS WITH PASSWORD='Abcd1234.',
	DEFAULT_DATABASE = [master],
	DEFAULT_LANGUAGE = [us_english],
	CHECK_EXPIRATION = OFF,
	CHECK_POLICY = OFF
GO

CREATE LOGIN SDDT_SCOUTS WITH PASSWORD='Abcd1234.',
	DEFAULT_DATABASE = [master],
	DEFAULT_LANGUAGE = [us_english],
	CHECK_EXPIRATION = OFF,
	CHECK_POLICY = OFF
GO

CREATE LOGIN ACM_SCOUTS WITH PASSWORD='Abcd1234.',
	DEFAULT_DATABASE = [master],
	DEFAULT_LANGUAGE = [us_english],
	CHECK_EXPIRATION = OFF,
	CHECK_POLICY = OFF
GO

CREATE LOGIN AMP_SCOUTS WITH PASSWORD='Abcd1234.',
	DEFAULT_DATABASE = [master],
	DEFAULT_LANGUAGE = [us_english],
	CHECK_EXPIRATION = OFF,
	CHECK_POLICY = OFF
GO


SELECT name AS SQLuser,loginname,dbname FROM sys.syslogins
GO

-- Creaci?n de roles
DROP ROLE IF EXISTS Presidente
GO
CREATE ROLE Presidente
GO
ALTER ROLE Presidente
	ADD member [JRM_SCOUTS]
GO

-- No es necesario crear rol, Coordinador = dbowner [SAL_SCOUTS]

DROP ROLE IF EXISTS Responsable
GO
CREATE ROLE Responsable
GO
ALTER ROLE Responsable
	ADD member [LGM_SCOUTS]
GO
ALTER ROLE Responsable
	ADD member [SDDT_SCOUTS]
GO

DROP ROLE IF EXISTS Tesorero
GO
CREATE ROLE Tesorero
GO
ALTER ROLE Tesorero
	ADD member [ACM_SCOUTS]
GO
DROP ROLE IF EXISTS Scouter
GO
CREATE ROLE Scouter
ALTER ROLE Scouter	
	ADD member [AMP_SCOUTS]
GO

sp_helprolemember 'Presidente';
GO
sp_helprolemember 'Responsable';
GO
sp_helprolemember 'Tesorero';
go
sp_helprolemember 'Scouter';
GO


-- Creaci?n de esquema general
DROP SCHEMA IF EXISTS SCOUTS
GO
CREATE SCHEMA SCOUTS
GO
-- Este esquema ser? utilizado por los miembros del personal
-- para las vistas a las tablas,
-- excepto db_owner que usar? la suya propia

-- Creaci?n de vistas
DROP VIEW IF EXISTS SCOUTS.CASTORES
GO

CREATE VIEW SCOUTS.CASTORES
AS
	SELECT nombre,apellido1,apellido2,edad,foto_perfil,num_insignias
	FROM SAL_SCOUT
	WHERE SAL_GRUPO_SCOUT_ID_grupo_scout = 1
GO

DROP VIEW IF EXISTS SCOUTS.LOBATOS
GO

CREATE VIEW SCOUTS.LOBATOS
AS
	SELECT nombre,apellido1,apellido2,edad,foto_perfil,num_insignias
	FROM SAL_SCOUT
	WHERE SAL_GRUPO_SCOUT_ID_grupo_scout = 2
GO
		
DROP VIEW IF EXISTS SCOUTS.EXPLORADORES
GO

CREATE VIEW SCOUTS.EXPLORADORES
AS
	SELECT nombre,apellido1,apellido2,edad,foto_perfil,num_insignias
	FROM SAL_SCOUT
	WHERE SAL_GRUPO_SCOUT_ID_grupo_scout = 3
GO

DROP VIEW IF EXISTS SCOUTS.PIONEROS
GO

CREATE VIEW SCOUTS.PIONEROS
AS
	SELECT nombre,apellido1,apellido2,edad,foto_perfil,num_insignias
	FROM SAL_SCOUT
	WHERE SAL_GRUPO_SCOUT_ID_grupo_scout = 4
GO

DROP VIEW IF EXISTS SCOUTS.RUTAS
GO

CREATE VIEW SCOUTS.RUTAS
AS
	SELECT nombre,apellido1,apellido2,edad,foto_perfil,num_insignias
	FROM SAL_SCOUT
	WHERE SAL_GRUPO_SCOUT_ID_grupo_scout = 5
GO

SELECT * FROM SCOUTS.CASTORES;
SELECT * FROM SCOUTS.LOBATOS;
SELECT * FROM SCOUTS.EXPLORADORES;
SELECT * FROM SCOUTS.PIONEROS;
SELECT * FROM SCOUTS.RUTAS;
GO


-- Permisos

-- Presidente
GRANT SELECT ON [SCOUTS].[CASTORES] TO Presidente;
GRANT SELECT ON [SCOUTS].[LOBATOS] TO Presidente;
GRANT SELECT ON [SCOUTS].[EXPLORADORES] TO Presidente;
GRANT SELECT ON [SCOUTS].[PIONEROS] TO Presidente;
GRANT SELECT ON [SCOUTS].[RUTAS] TO Presidente;
DENY INSERT,ALTER,UPDATE,DELETE ON SCHEMA::[dbo] TO Presidente;
GO
-- Commands completed successfully

GRANT SELECT ON [SCOUTS].[CASTORES] TO Scouter;
GRANT SELECT ON [SCOUTS].[LOBATOS] TO Scouter;
GRANT SELECT ON [SCOUTS].[EXPLORADORES] TO Scouter;
GRANT SELECT ON [SCOUTS].[PIONEROS] TO Scouter;
GRANT SELECT ON [SCOUTS].[RUTAS] TO Scouter;
DENY INSERT,ALTER,UPDATE,DELETE ON SCHEMA::[dbo] TO Scouter;
GO
-- Commands completed successfully

-- Los permisos de los responsables se hacen por separado
-- Responsable - COM. RR.SS.
GRANT SELECT ON [SCOUTS].[CASTORES] TO LGM_SCOUTS;
GRANT SELECT ON [SCOUTS].[LOBATOS] TO LGM_SCOUTS;
GRANT SELECT ON [SCOUTS].[EXPLORADORES] TO LGM_SCOUTS;
GRANT SELECT ON [SCOUTS].[PIONEROS] TO LGM_SCOUTS;
GRANT SELECT ON [SCOUTS].[RUTAS] TO LGM_SCOUTS;
GRANT SELECT,INSERT,UPDATE,DELETE ON SAL_EVENTOS TO LGM_SCOUTS;
DENY ALTER ON SAL_EVENTOS TO LGM_SCOUTS;
GRANT SELECT,INSERT,UPDATE,DELETE ON SAL_PROYECTO TO LGM_SCOUTS;
DENY ALTER ON SAL_PROYECTO TO LGM_SCOUTS;
GRANT SELECT,INSERT,UPDATE,DELETE ON SAL_ENTIDAD TO LGM_SCOUTS;
DENY ALTER ON SAL_ENTIDAD TO LGM_SCOUTS;
GO
-- Commands completed successfully


-- Responsable - Materiales
GRANT SELECT,INSERT,UPDATE,DELETE ON SAL_MATERIAL TO SDDT_SCOUTS;
DENY ALTER ON SAL_MATERIAL TO SDDT_SCOUTS;
GRANT SELECT,INSERT,UPDATE,DELETE ON SAL_INVENTARIO TO SDDT_SCOUTS;
DENY ALTER ON SAL_INVENTARIO TO SDDT_SCOUTS;
GO
-- Commands completed successfully


-- Tesorero
GRANT SELECT,INSERT,UPDATE,DELETE ON SAL_DONACION TO Tesorero;
DENY ALTER ON SAL_DONACION TO Tesorero;
GRANT SELECT,INSERT,UPDATE,DELETE ON SAL_FACTURA_MATERIAL TO Tesorero;
DENY ALTER ON SAL_FACTURA_MATERIAL TO Tesorero;
GO
-- Commands completed successfully




