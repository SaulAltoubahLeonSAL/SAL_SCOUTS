USE MASTER
GO

USE SAL_SCOUTS
GO

-- Nivel Servidor (DDL trigger)

IF OBJECT_ID('SAL_tr_OnlyDBOwner','TR') IS NOT NULL
	DROP TRIGGER SAL_tr_OnlyDBOwner;
GO

CREATE OR ALTER TRIGGER SAL_tr_OnlyDBOwner ON ALL SERVER
FOR CREATE_DATABASE,CREATE_TABLE
AS
	BEGIN
		RAISERROR('PROHIBIDO CREAR NUEVAS BASES DE DATOS O TABLAS SIN CONSENTIMIENTO DEL db_owner',16,1)
		ROLLBACK
	END
GO

CREATE DATABASE SAL_TESTER
GO
CREATE TABLE tempdb.dbo.SAL_testTBL (
	ID INT NOT NULL, 
	name VARCHAR(MAX) NULL
);
GO

-- Nivel base de datos (DDL)

IF OBJECT_ID('SAL_tr_NoTouch','TR') IS NOT NULL
	DROP TRIGGER SAL_tr_NoTouch;
GO

CREATE OR ALTER TRIGGER SAL_tr_NoTouch 
	ON DATABASE
		FOR ALTER_TABLE
AS
	BEGIN
		RAISERROR('NO SE TE PERMITE LA ALTERACIÓN DE NINGÚN DATO RELACIONADO CON LA BASE DE DATOS',16,1)
		ROLLBACK
	END
GO

ALTER TABLE SAL_FACTURA_MATERIAL
	ADD mini_id INT null
GO

-- Nivel de tablas
IF OBJECT_ID('SAL_tr_welcomeScout','TR') IS NOT NULL
	DROP TRIGGER SAL_tr_welcomeScout;
GO

CREATE OR ALTER TRIGGER SAL_tr_welcomeScout
	ON SAL_SCOUT
		FOR INSERT
AS
	BEGIN
		 DECLARE @name VARCHAR(MAX) -- nombre
		 DECLARE @IDgroup int -- grupo scout

		 SELECT TOP 1 @name = nombre, @IDgroup = SAL_GRUPO_SCOUT_ID_grupo_scout  FROM SAL_SCOUT ORDER BY ID_scout DESC
		 -- se selecciona el primer último valor añadido

		 IF @IDgroup = 1
		 BEGIN
			PRINT 'Bienvenid@ '+@name+' al grupo de LOS CASTORES'
		 END
		 ELSE
			 IF @IDgroup = 2
			 BEGIN
				PRINT 'Bienvenid@ '+@name+' al grupo de LOS LOBATOS'
			 END
			 IF @IDgroup = 3
			 BEGIN
				PRINT 'Bienvenid@ '+@name+' al grupo de LOS EXPLORADORES'
			 END
			 IF @IDgroup = 4
			 BEGIN
				PRINT 'Bienvenid@ '+@name+' al grupo de LOS PIONEROS'
			 END
			 IF @IDgroup = 5
			 BEGIN
				PRINT 'Bienvenid@ '+@name+' al grupo de LOS RUTAS'
			 END
	END
GO

DELETE FROM SAL_SCOUT WHERE ID_scout = 1000
DELETE FROM SAL_SCOUT WHERE ID_scout = 1001
DELETE FROM SAL_SCOUT WHERE ID_scout = 1002
DELETE FROM SAL_SCOUT WHERE ID_scout = 1003
DELETE FROM SAL_SCOUT WHERE ID_scout = 1004


--EXEC SALnewPerson 1,1000,'Saúl','Altoubah','León','12345678A','1997-03-08',123456789,'Fake Street 123',24,'C:\SAL_imgs\sal.jpg',3,0,1,1;
--EXEC SALnewPerson 1,1001,'Saúl','Altoubah','León','12345678B','1997-03-08',123456789,'Fake Street 123',24,'C:\SAL_imgs\sal.jpg',3,0,1,2;
--EXEC SALnewPerson 1,1002,'Saúl','Altoubah','León','12345678C','1997-03-08',123456789,'Fake Street 123',24,'C:\SAL_imgs\sal.jpg',3,0,1,3;
--EXEC SALnewPerson 1,1003,'Saúl','Altoubah','León','12345678D','1997-03-08',123456789,'Fake Street 123',24,'C:\SAL_imgs\sal.jpg',3,0,1,4;
--EXEC SALnewPerson 1,1004,'Saúl','Altoubah','León','12345678E','1997-03-08',123456789,'Fake Street 123',24,'C:\SAL_imgs\sal.jpg',3,0,1,5;
