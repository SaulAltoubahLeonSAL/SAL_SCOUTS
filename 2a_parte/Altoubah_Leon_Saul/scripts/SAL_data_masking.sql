USE SAL_SCOUTS
go

CREATE OR ALTER PROC ShowMaskingStatus
AS
	BEGIN
		SET NOCOUNT ON 
		SELECT c.name, tbl.name as table_name, c.is_masked, c.masking_function  
		FROM sys.masked_columns AS c  
		JOIN sys.tables AS tbl   
			ON c.[object_id] = tbl.[object_id]  
		WHERE is_masked = 1;
	END
GO

EXEC ShowMaskingStatus;
GO

-- name	table_name	is_masked	masking_function
-- VACÍO

-- SAL_DONACION

SELECT top 5 nombre_donante,importe FROM SAL_DONACION
GO

-- nombre_donante		importe
-- Ulla Sampson			364557,55
-- Holmes Hopkins		725784,49
-- Fletcher Johnson		749478,39
-- Iona Holder			338829,02
-- Mechelle Hernandez	306672,87

ALTER TABLE SAL_DONACION
	ALTER COLUMN nombre_donante
		ADD MASKED WITH (FUNCTION = 'default()');
ALTER TABLE SAL_DONACION
	ALTER COLUMN importe
		ADD MASKED WITH (FUNCTION = 'random(-999999999,999999999)');
GO

EXEC ShowMaskingStatus;
GO

-- name				table_name		is_masked	masking_function
-- nombre_donante	SAL_DONACION	1			default()
-- importe			SAL_DONACION	1			random(-1e+009, 1e+009)


-- SAL_ENTIDAD

SELECT top 5 CIF,nombre_entidad,direccion,pais,telefono from SAL_ENTIDAD
GO

-- CIF		nombre_entidad								direccion				pais			telefono
-- U5194934	Nibh Corp.									1492 Integer Street		Romania			546488754
-- B6431137	Pede Praesent Limited						3372 Tincidunt Rd.		Pakistan		812831802
-- B9556348	Interdum Feugiat Inc.						Ap #436-7321 Tellus Av.	Switzerland		874622896
-- D4427584	Pellentesque Tincidunt Tempus Associates	7749 Rhoncus Rd.		Bouvet Island	161824135
-- P9787672	Pellentesque Eget Dictum LLP				112-6972 Pharetra Rd.	Montserrat		556314139

ALTER TABLE SAL_ENTIDAD
	ALTER COLUMN CIF
		ADD MASKED WITH (FUNCTION = 'default()');
ALTER TABLE SAL_ENTIDAD
	ALTER COLUMN nombre_entidad
		ADD MASKED WITH (FUNCTION = 'default()');
ALTER TABLE SAL_ENTIDAD
	ALTER COLUMN direccion
		ADD MASKED WITH (FUNCTION = 'default()');
ALTER TABLE SAL_ENTIDAD
	ALTER COLUMN pais
		ADD MASKED WITH (FUNCTION = 'default()');
ALTER TABLE SAL_ENTIDAD
	ALTER COLUMN telefono
		ADD MASKED WITH (FUNCTION = 'default()');
GO

EXEC ShowMaskingStatus;
GO

-- name				table_name		is_masked	masking_function
-- nombre_donante	SAL_DONACION	1			default()
-- importe			SAL_DONACION	1			random(-1e+009, 1e+009)
-- CIF				SAL_ENTIDAD		1			default()
-- nombre_entidad	SAL_ENTIDAD		1			default()
-- direccion		SAL_ENTIDAD		1			default()
-- pais				SAL_ENTIDAD		1			default()
-- telefono			SAL_ENTIDAD		1			default()


-- SAL_FACTURA_MATERIAL

SELECT top 5 producto,cod_producto,num_lote,cantidad,precio,subtotal,total from SAL_FACTURA_MATERIAL
GO

-- producto		cod_producto	num_lote		cantidad	precio	subtotal	total
-- Ziplock		83054			HTS95ELP5DG		29			190,83	5534,07		5534,07
-- Ziplock		43417			JFP74IIF8TP		12			177,08	2124,96		2124,96
-- Ice_chest	45414			AOY36LYE7JS		42			70,30	2952,60		2952,60
-- Can_opener	64114			KVI87HBP3MK		33			178,76	5899,08		5899,08
-- bed			40866			RHX43NRG6MJ		49			126,94	6220,06		6220,06

ALTER TABLE SAL_FACTURA_MATERIAL
	ALTER COLUMN producto
		ADD MASKED WITH (FUNCTION = 'default()');
ALTER TABLE SAL_FACTURA_MATERIAL
	ALTER COLUMN cod_producto
		ADD MASKED WITH (FUNCTION = 'default()');
ALTER TABLE SAL_FACTURA_MATERIAL
	ALTER COLUMN num_lote
		ADD MASKED WITH (FUNCTION = 'default()');
ALTER TABLE SAL_FACTURA_MATERIAL
	ALTER COLUMN cantidad
		ADD MASKED WITH (FUNCTION = 'random(-9999,9999)');
ALTER TABLE SAL_FACTURA_MATERIAL
	ALTER COLUMN precio
		ADD MASKED WITH (FUNCTION = 'random(-9999,9999)');
ALTER TABLE SAL_FACTURA_MATERIAL
	ALTER COLUMN subtotal
		ADD MASKED WITH (FUNCTION = 'random(-9999,9999)');
ALTER TABLE SAL_FACTURA_MATERIAL
	ALTER COLUMN total
		ADD MASKED WITH (FUNCTION = 'random(-9999,9999)');
GO


EXEC ShowMaskingStatus;
GO

-- name				table_name				is_masked	masking_function
-- nombre_donante	SAL_DONACION			1			default()
-- importe			SAL_DONACION			1			random(-1e+009, 1e+009)
-- CIF				SAL_ENTIDAD				1			default()
-- nombre_entidad	SAL_ENTIDAD				1			default()
-- direccion		SAL_ENTIDAD				1			default()
-- pais				SAL_ENTIDAD				1			default()
-- telefono			SAL_ENTIDAD				1			default()
-- producto			SAL_FACTURA_MATERIAL	1			default()
-- cod_producto		SAL_FACTURA_MATERIAL	1			default()
-- num_lote			SAL_FACTURA_MATERIAL	1			default()
-- cantidad			SAL_FACTURA_MATERIAL	1			random(-9999, 9999)
-- precio			SAL_FACTURA_MATERIAL	1			random(-9999, 9999)
-- subtotal			SAL_FACTURA_MATERIAL	1			random(-9999, 9999)
-- total			SAL_FACTURA_MATERIAL	1			random(-9999, 9999)


-- SAL_PERSONAL

SELECT nombre,apellido1,apellido2,DNI,fecha_nacimiento,telefono,direccion FROM SAL_PERSONAL
GO

-- nombre		apellido1	apellido2		DNI			fecha_nacimiento	telefono	direccion
-- Juan			Robles		Martinez		87654321A	1967-06-18			601234567	C/ Penacho 14 3º Dcha
-- Saúl			Altoubah	León			12345678B	1997-03-08			600000000	Avda. MiCalle 1 1ºA
-- Lucía		García		Caamaño			24688642C	1973-09-02			612345678	C/ Estatua 100 4º IZQA.
-- Santiago		Descalzo	De La Torre		13579135D	1996-06-06			698765432	Fake St. 123
-- Alberto		Castaña		Manzana			66502374R	1986-12-28			636963636	Avda. Pepe 7 2ºB
-- Alma			Martillo	Puertas			47445203M	1981-06-08			654254254	C/ Jonás 12 8º DCHA

ALTER TABLE SAL_PERSONAL
	ALTER COLUMN nombre
		ADD MASKED WITH (FUNCTION = 'partial(1,"**********",0)');
ALTER TABLE SAL_PERSONAL
	ALTER COLUMN apellido1
		ADD MASKED WITH (FUNCTION = 'partial(1,"**********",0)');
ALTER TABLE SAL_PERSONAL
	ALTER COLUMN apellido2
		ADD MASKED WITH (FUNCTION = 'partial(1,"**********",0)');
ALTER TABLE SAL_PERSONAL
	ALTER COLUMN DNI
		ADD MASKED WITH (FUNCTION = 'partial(1,"**********",0)');
ALTER TABLE SAL_PERSONAL
	ALTER COLUMN fecha_nacimiento
		ADD MASKED WITH (FUNCTION = 'default()');
ALTER TABLE SAL_PERSONAL
	ALTER COLUMN telefono
		ADD MASKED WITH (FUNCTION = 'default()');
ALTER TABLE SAL_PERSONAL
	ALTER COLUMN direccion
		ADD MASKED WITH (FUNCTION = 'partial(1,"**********",0)');
GO

EXEC ShowMaskingStatus;
GO

-- name				table_name				is_masked	maksing_function
-- nombre_donante	SAL_DONACION			1			default()
-- importe			SAL_DONACION			1			random(-1e+009, 1e+009)
-- CIF				SAL_ENTIDAD				1			default()
-- nombre_entidad	SAL_ENTIDAD				1			default()
-- direccion		SAL_ENTIDAD				1			default()
-- pais				SAL_ENTIDAD				1			default()
-- telefono			SAL_ENTIDAD				1			default()
-- producto			SAL_FACTURA_MATERIAL	1			default()
-- cod_producto		SAL_FACTURA_MATERIAL	1			default()
-- num_lote			SAL_FACTURA_MATERIAL	1			default()
-- cantidad			SAL_FACTURA_MATERIAL	1			random(-9999, 9999)
-- precio			SAL_FACTURA_MATERIAL	1			random(-9999, 9999)
-- subtotal			SAL_FACTURA_MATERIAL	1			random(-9999, 9999)
-- total			SAL_FACTURA_MATERIAL	1			random(-9999, 9999)
-- nombre			SAL_PERSONAL			1			partial(1, "**********", 0)
-- apellido1		SAL_PERSONAL			1			partial(1, "**********", 0)
-- apellido2		SAL_PERSONAL			1			partial(1, "**********", 0)
-- DNI				SAL_PERSONAL			1			partial(1, "**********", 0)
-- fecha_nacimiento	SAL_PERSONAL			1			default()
-- telefono			SAL_PERSONAL			1			default()
-- direccion		SAL_PERSONAL			1			partial(1, "**********", 0)


-- SAL_SCOUT

SELECT top 5 nombre,apellido1,apellido2,DNI,fecha_nacimiento,direccion,telefono,edad FROM SAL_SCOUT
GO

-- nombre	apellido1	apellido2	DNI			fecha_nacimiento	direccion						telefono	edad
-- Yeo		Mccarthy	Holland		85179121E	2005-07-02			Ap #939-4170 In Road			244528785	15
-- Phillip	Banks		Manning		18644331L	1997-04-15			P.O. Box 714, 8603 Dolor Street	587837181	23
-- Jael		Joyce		Lott		51768952W	2003-02-16			6081 Diam. Ave					956884469	17
-- Meredith	Cohen		Ball		56435386H	2000-07-12			P.O. Box 698, 6047 Lacus St.	873854814	20
-- Stone	Mccoy		Hall		19386398S	2014-07-21			Ap #650-5440 Dui, Street		997139111	6

ALTER TABLE SAL_SCOUT
	ALTER COLUMN nombre
		ADD MASKED WITH (FUNCTION = 'partial(1,"**********",0)');
ALTER TABLE SAL_SCOUT
	ALTER COLUMN apellido1
		ADD MASKED WITH (FUNCTION = 'partial(1,"**********",0)');
ALTER TABLE SAL_SCOUT
	ALTER COLUMN apellido2
		ADD MASKED WITH (FUNCTION = 'partial(1,"**********",0)');
ALTER TABLE SAL_SCOUT
	ALTER COLUMN DNI
		ADD MASKED WITH (FUNCTION = 'partial(1,"**********",0)');
ALTER TABLE SAL_SCOUT
	ALTER COLUMN fecha_nacimiento
		ADD MASKED WITH (FUNCTION = 'default()');
ALTER TABLE SAL_SCOUT
	ALTER COLUMN direccion
		ADD MASKED WITH (FUNCTION = 'default()');
ALTER TABLE SAL_SCOUT
	ALTER COLUMN telefono
		ADD MASKED WITH (FUNCTION = 'default()');
ALTER TABLE SAL_SCOUT
	ALTER COLUMN edad
		ADD MASKED WITH (FUNCTION = 'default()');
GO

EXEC ShowMaskingStatus;
GO

-- name				table_name				is_masked	masking_function
-- nombre_donante	SAL_DONACION			1			default()
-- importe			SAL_DONACION			1			random(-1e+009, 1e+009)
-- CIF				SAL_ENTIDAD				1			default()
-- nombre_entidad	SAL_ENTIDAD				1			default()
-- direccion		SAL_ENTIDAD				1			default()
-- pais				SAL_ENTIDAD				1			default()
-- telefono			SAL_ENTIDAD				1			default()
-- producto			SAL_FACTURA_MATERIAL	1			default()
-- cod_producto		SAL_FACTURA_MATERIAL	1			default()
-- num_lote			SAL_FACTURA_MATERIAL	1			default()
-- cantidad			SAL_FACTURA_MATERIAL	1			random(-9999, 9999)
-- precio			SAL_FACTURA_MATERIAL	1			random(-9999, 9999)
-- subtotal			SAL_FACTURA_MATERIAL	1			random(-9999, 9999)
-- total			SAL_FACTURA_MATERIAL	1			random(-9999, 9999)
-- nombre			SAL_PERSONAL			1			partial(1, "**********", 0)
-- apellido1		SAL_PERSONAL			1			partial(1, "**********", 0)
-- apellido2		SAL_PERSONAL			1			partial(1, "**********", 0)
-- DNI				SAL_PERSONAL			1			partial(1, "**********", 0)
-- fecha_nacimiento	SAL_PERSONAL			1			default()
-- telefono			SAL_PERSONAL			1			default()
-- direccion		SAL_PERSONAL			1			partial(1, "**********", 0)
-- nombre			SAL_SCOUT				1			partial(1, "**********", 0)
-- apellido1		SAL_SCOUT				1			partial(1, "**********", 0)
-- apellido2		SAL_SCOUT				1			partial(1, "**********", 0)
-- DNI				SAL_SCOUT				1			partial(1, "**********", 0)
-- fecha_nacimiento	SAL_SCOUT				1			default()
-- direccion		SAL_SCOUT				1			default()
-- telefono			SAL_SCOUT				1			default()
-- edad				SAL_SCOUT				1			default()


GRANT UNMASK TO Presidente;
GO

CREATE USER NoMask WITHOUT LOGIN;
GO

REVOKE UNMASK TO Presidente;
GO

GRANT UNMASK TO NoMask;
GO

GRANT SELECT ON SCHEMA::[dbo] TO NoMask
GO

GRANT SELECT ON SCHEMA::[SCOUTS] TO NoMask
GO