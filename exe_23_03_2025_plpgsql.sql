CREATE TABLE log_calculadora(
	id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	x NUMERIC, 
	y NUMERIC,
	operacao CHAR(1),
	resultado NUMERIC
);


-- PL/pgSQL -> Postgres Procedural Language
CREATE OR REPLACE FUNCTION calculadora(
	v_x NUMERIC, 
	v_y NUMERIC,
	v_operacao CHAR
)
RETURNS NUMERIC AS $$
DECLARE
	v_resultado NUMERIC;
BEGIN
	-- Lógica da operação
	CASE v_operacao
		WHEN '+' THEN
			v_resultado := v_x + v_y;
		WHEN '-' THEN
			v_resultado := v_x - v_y;
		WHEN '*' THEN
			v_resultado := v_x * v_y;
		WHEN '/' THEN
			IF v_y = 0 THEN
				RAISE EXCEPTION 'Divisão por zero não é permitida';
			END IF;
			v_resultado := v_x / v_y;
		ELSE
			RAISE EXCEPTION 'Operador inválido use: +; -; * ou /';
	END CASE;

	-- Inserir no log
	INSERT INTO log_calculadora(x, y, operacao, resultado)
	VALUES(v_x, v_y, v_operacao, v_resultado);

	-- Retornar resultado
	RETURN v_resultado;

END;
$$ LANGUAGE plpgsql;

SELECT calculadora(305, 3, '*');
SELECT * FROM log_calculadora;

ALTER TABLE log_calculadora
ADD data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP;


