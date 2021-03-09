USE master
GO

USE SAL_SCOUTS
GO


DROP TABLE IF EXISTS SAL_listado_material
GO

CREATE TABLE SAL_listado_material (
	ID_listado INT PRIMARY KEY NOT NULL,
	nombre_material NVARCHAR(100) NOT NULL,
	cantidad_material INT NOT NULL,
	descripcion NVARCHAR(max) NOT NULL,
	SysStartTime datetime2 GENERATED ALWAYS AS ROW START NOT NULL,  
	SysEndTime datetime2 GENERATED ALWAYS AS ROW END NOT NULL,  
		PERIOD FOR SYSTEM_TIME (SysStartTime,SysEndTime) ) 
			with (System_Versioning = ON (History_Table = dbo.SAL_list_material_historial)
);
GO


SELECT * FROM SAL_listado_material,
SELECT * FROM SAL_list_material_historial,
GO
-- Vacías


 insert into SAL_listado_material(ID_listado, nombre_material, cantidad_material, descripcion) values
	 (1,'Lápices', 4, 'Corto plazo'),
	 (2,'Cazadoras', 24, 'Corto plazo'),
	 (3,'Lápices', 20, 'Medio plazo'),
	 (4,'Brújulas', 5, 'Indefinido'),
	 (5,'Kit Primeros Auxilios', 7, 'Largo plazo'),
	 (6,'Cuerda blanca gruesa 5m', 18, 'Indefinido'),
	 (7,'Champú de bolsillo 250ml', 25, 'Largo plazo'),
	 (8,'Lupa 2x', 13, 'Medio plazo'),
	 (9,'Champú de bolsillo 250ml', 11, 'Indefinido'),
	 (10,'Cuerda blanca gruesa 5m', 36, 'Largo plazo')
GO -- (10 rows affected)
SELECT * FROM SAL_listado_material;
SELECT * FROM SAL_list_material_historial;
GO


UPDATE SAL_listado_material
SET cantidad_material = 10
WHERE ID_listado = 1
GO
-- (1 row affected)

DELETE FROM SAL_listado_material WHERE ID_listado = 9
GO
-- (1 row affected)

SELECT * FROM SAL_listado_material;
SELECT * FROM SAL_list_material_historial;
GO

UPDATE SAL_listado_material
SET descripcion = 'Corto plazo'
WHERE nombre_material = 'Brújulas'; -- (1 row affeected)
UPDATE SAL_listado_material
SET descripcion = 'Corto plazo'
WHERE nombre_material = 'Kit Primeros Auxilios'; -- (1 row affected)
GO
SELECT * FROM SAL_listado_material;
SELECT * FROM SAL_list_material_historial;
GO

ALTER TABLE SAL_listado_material SET (SYSTEM_VERSIONING = OFF)
GO
ALTER TABLE SAL_listado_material DROP PERIOD FOR SYSTEM_TIME
GO
DROP TABLE SAL_listado_material
GO
DROP TABLE SAL_list_material_historial
GO
-- Comands completed successfully.
