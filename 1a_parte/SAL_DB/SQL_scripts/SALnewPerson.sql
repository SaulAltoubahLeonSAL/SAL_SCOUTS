USE SAL_SCOUTS
GO

DROP PROC iF EXISTS SALnewPerson
GO

CREATE OR ALTER PROC SALnewPerson
	@case INT, -- 1 = scout, 2 = personal
	@id VARCHAR(10),
	@name NVARCHAR(255),
	@sName1 NVARCHAR(255),
	@sName2 NVARCHAR(255),
	@DNI VARCHAR(9),
	@bDate DATE,
	@tlf INT,
	@direccion NVARCHAR(250),
	@edad INT, -- si se trata de personal, indicar 0
	@fPerfil VARCHAR(max),
	@nBadges INT,
	@yearXP INT, -- si se trata de scout, indicar 0
	@numParents INT, -- si se trata de personal, indicar 0
	@groupScout INT -- si se trata de personal, indicar 0
AS
	BEGIN
		IF @case = 1 -- SAL_SCOUT
			BEGIN
				DECLARE @img VARBINARY(max) -- declaramos @img VARBINARY(max)
				DECLARE @stringSQL NVARCHAR(max)
					SET @stringSQL = N'SELECT @img = CAST(bulkcolumn AS VARBINARY(MAX)) FROM '
					SET @stringSQL += N'OPENROWSET(BULK '''
					SET @stringSQL += @fPerfil
					SET @stringSQL += N''',SINGLE_BLOB) AS x'
				-- La sintaxis original es: 
				-- "SELECT @img = CAST(BulkColumn AS VARBINARY(max)) FROM OPENROWSET (BULK @fPerfil, AS SINGLE_BLOB) AS x;"
				-- El inconveniente al ejecutar esta sentencia T-SQL se trata de que la función OPENROWSET
				-- solo permite introducir un parámetro STRING, el cual ya va introducido al ejecutar el procedimiento almacenado,
				-- pero aún así muestra un error de sintaxis.
				-- Para poder ejecutar el comando adecuadamente, se declara @stringSQL NVARCHAR(max) que
				-- nos ayudará a segmentar mediante concatenación de STRINGS dicho comando a ejecutar que sería así:
				-- SET @stringSQL=N'SELECT @img = CAST(BulkColumn AS VARBINARY(max)) FROM OPENROWSET (BULK '''+@fPerfil+''', AS SINGLE_BLOB) AS x';
				-- Desgraciadamente tampoco funcionaría porque no se puede usar el operador '+' 
				-- para unir tipos de datos VARCHAR/NVARCHAR con VARBINARY, que es lo que la sentencia ha estado intentando hacer.
				EXEC sp_executesql @stringSQL,N'@img VARBINARY(max) OUT',@img OUTPUT
				-- ejecutamos el procedimiento almacenado sp_executesql junto con las variables de la concatenación a unir
  				INSERT INTO SAL_SCOUT([ID_scout],[nombre],[apellido1],[apellido2],[DNI],[fecha_nacimiento],[direccion],[foto_perfil],[telefono],[edad],[ID_img],[num_insignias],[SAL_SCOUT_PADRES_ID_scout_padres],[SAL_GRUPO_SCOUT_ID_grupo_scout])
					values (@id,@name,@sName1,@sName2,@DNI,@bDate,@direccion,@img,@edad,@tlf,NEWID(),@nBadges,@numParents,@groupScout)
				-- se realiza la inserción de datos en la tabla SAL_scout
			END
		ELSE 
		IF @case = 2 -- SAL_PERSONAL
		BEGIN
			DECLARE @imgs VARBINARY(max)
			DECLARE @stringsSQL NVARCHAR(max)
				SET @stringsSQL = N'SELECT @imgs = CAST(bulkcolumn AS VARBINARY(MAX)) FROM '
				SET @stringsSQL += N'OPENROWSET(BULK '''
				SET @stringsSQL += @fPerfil
				SET @stringsSQL += N''',SINGLE_BLOB) AS x'
			EXEC sp_executesql @stringsSQL,N'@imgs VARBINARY(max) OUT',@imgs OUTPUT
			-- Se modifican las variables para evitar confictos
			INSERT INTO SAL_personal([ID_personal],[nombre],[apellido1],[apellido2],[DNI],[fecha_nacimiento],[telefono],[direccion],[foto_perfil],[ID_img],[num_insignias],[anos_exp_scout])
				Values (@id,@name,@sName1,@sName2,@DNI,@bDate,@tlf,@direccion,@imgs,NEWID(),@nBadges,@yearXP)
		END
		IF @case >= 3
		BEGIN
			PRINT 'OPERATION FAILED - WRONG NUMBER'
		END
	END
GO

delete from SAL_scout WHERE ID_scout = 1000 -- sentencias de prueba
delete from SAL_personal WHERE ID_personal = 1000  -- sentencias de prueba

--scout // suponiendo que disponemos del ID de los padres del scout y a qué grupo scout pertenece
EXEC SALnewPerson 1,1000,'Saúl','Altoubah','León','12345678A','1997-03-08',123456789,'Fake Street 123',24,'C:\SAL_imgs\sal.jpg',3,0,1,1;
SELECT * FROM SAL_SCOUT WHERE ID_scout = 1000;

-- personal
EXEC SALnewPerson 2,1000,'Saúl','Altoubah','León','12345678A','1997-03-08',600000000,'C/ Falsa 123, 1ºA',0,'C:\SAL_imgs\sal.jpg',3,5,0,0;
SELECT * FROM SAL_ERPSONAL WHERE ID_personal = 1000;

-- error
EXEC SALnewPerson 3,999,'NoName','NoName','NoName','000000000Z','1999-01-01',123456789,'NoAddress',999,'C:\SAL_imgs\sal.jpg',999,999,999,999;
GO


SELECT * FROM SAL_SCOUT;
SELECT * FROM SAL_PERSONAL;
GO

-- (1 row affected)
-- (1 row affected)
-- OPERATION FAILED - WORNG NUMBER

--EXEC SALnewPerson 2,1,'Juan','Robles','Martinez','87654321A','1967-06-18',601234567,'C/ Penacho 14 3º Dcha',0,'C:\SAL_imgs\jrm.jpg',15,20,0;
--EXEC SALnewPerson 2,2,'Saúl','Altoubah','León','12345678B','1997-03-08',600000000,'Avda. MiCalle 1 1ºA',0,'C:\SAL_imgs\sal.jpg',5,3,0;
--EXEC SALnewPerson 2,3,'Lucía','García','Caamaño','24688642C','1973-09-02',612345678,'C/ Estatua 100 4º IZQA.',0,'C:\SAL_imgs\lgc.jpg',15,17,0;
--EXEC SALnewPerson 2,4,'Santiago','Descalzo','De La Torre','13579135D','1996-06-06',698765432,'Fake St. 123',0,'C:\SAL_imgs\sddt.jpg',6,4,0;
--EXEC SALnewPerson 2,5,'Alberto','Castaña','Manzana','66502374R','1986-12-28',636963636,'Avda. Pepe 7 2ºB',0,'C:\SAL_imgs\acm.jpg',12,9,0;
--EXEC SALnewPerson 2,6,'Alma','Martillo','Puertas','47445203M','1981-06-08',654254254,'C/ Jonás 12 8º DCHA',0,'C:\SAL_imgs\amp.jpg',8,11,0;
