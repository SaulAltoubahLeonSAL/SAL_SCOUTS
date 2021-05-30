USE master
GO

USE SAL_SCOUTS
GO

DROP PROC IF EXISTS SALprofit_lossCalc
GO

CREATE OR ALTER PROC SALprofit_lossCalc
@date_1 DATE, -- fecha inicial --> YYYY-MM-DD
@date_2 DATE-- fecha final --> YYYY-MM-DD
AS
	BEGIN
		DECLARE @don DECIMAL -- total donaciones
		DECLARE @tot DECIMAL -- total totales gastos
		DECLARE @res DECIMAL -- total calculado
		DECLARE @msg NVARCHAR(max) -- mensaje

		SELECT @don = SUM(importe) FROM SAL_DONACION
			WHERE fecha_donacion BETWEEN @date_1 AND @date_2
		-- total de donaciones en el rango de fechas indicadas
		SELECT @tot = SUM(total) FROM SAL_FACTURA_MATERIAL
			WHERE fecha_compra BETWEEN @date_1 AND @date_2
		-- total de gastos en el rango de fechas indicadas

		SET @res = @don - @tot -- se calcula el resultado

		IF @res > 0
		BEGIN
			SET @msg = 'Hay un beneficio de ' 
			PRINT @msg
			PRINT @res -- beneficios
		END
		ELSE
			IF @res < 0
			BEGIN
				SET @msg = 'Hay una pérdida de ' 
				PRINT @msg
				PRINT @res -- pérdidas
			END
		ELSE
			IF @res = 0
			BEGIN
				SET @msg = 'No existe beneficio o pérdida' -- balance
				PRINT @msg
			END
	END
GO


EXEC SALprofit_lossCalc '2017-01-01','2017-12-31'
GO



-- procedimiento a seguir

DECLARE @date1 DATE
DECLARE @date2 DATE

DECLARE @don1 DECIMAL
DECLARE @tot1 DECIMAL
DECLARE @res1 DECIMAL
DECLARE @msg1 NVARCHAR (max)


SET @date1 = '2017-01-01' -- ejemplo
SET @date2 = '2017-12-31' -- ejemplo
		SELECT @don1 = SUM(importe) FROM SAL_DONACION
		WHERE fecha_donacion BETWEEN @date1 AND @date2
		-- donTOTAL 4107477769,80
		PRINT @don1

		select @tot1 = SUM(total) FROM SAL_FACTURA_MATERIAL
		WHERE fecha_pedido BETWEEN @date1 AND @date2
		-- totTOTAL 6131889,55
		PRINT @tot1

		SET @res1 = @don1 - @tot1
		print @res1
	IF @res1 > 0
		BEGIN
			SET @msg1 = 'Hay un beneficio de '
				PRINT @msg1
				PRINT @res1
		END
		ELSE
			IF @res1 < 0
			BEGIN
				SET @msg1 = 'Hay una pérdida de ' + @res1 -- pérdidas
					PRINT @msg1
					PRINT @res1
			END
		ELSE
			IF @res1 = 0
			BEGIN
				SET @msg1 = 'No existe beneficio o pérdida' -- balance
					PRINT @msg1
					PRINT @res1
			END
GO


-- resultado final

--4107477770
--6131890
--4101345880
--Hay un beneficio de 
--4101345880




-- Antiguos errores

-- resultado final --> NULL



-- 4107477769.80
-- 6131889.55
-- 4101345880.25
-- Msg 235, Level 16, State 0, Line 81
-- Cannot convert a char value to money. The char value has incorrect syntax.
