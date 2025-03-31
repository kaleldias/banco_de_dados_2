/*
	Avaliação Banco de Dados II [M1]
	Professor: Maurício Pasetto
*/

-- Questão 1:
CREATE DATABASE maternidade;
CREATE SCHEMA IF NOT EXISTS maternidade;

SET search_path TO maternidade;

CREATE TABLE cidade(
	id SERIAL PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	uf CHAR(2) NOT NULL
);

CREATE TABLE mae(
	id SERIAL PRIMARY KEY,
	id_cidade INT NOT NULL,
	nome VARCHAR(100) NOT NULL,
	celular VARCHAR(15),
	CONSTRAINT fk_id_cidade FOREIGN KEY (id_cidade) REFERENCES cidade(id)
);


CREATE TABLE medico(
	id SERIAL PRIMARY KEY,
	id_cidade INT NOT NULL,
	crm VARCHAR(10),
	nome VARCHAR(100) NOT NULL,
	celular VARCHAR(15) NOT NULL,
	salario DECIMAL(10,2),
	status SMALLINT,
	CONSTRAINT fk_id_cidade FOREIGN KEY (id_cidade) REFERENCES cidade(id)
);

CREATE TABLE nascimento(
	id SERIAL PRIMARY KEY,
	id_mae INT NOT NULL,
	id_medico INT NOT NULL,
	nome VARCHAR(100) NOT NULL,
	data_nascimento DATE NOT NULL,
	peso DECIMAL(5,3) NOT NULL,
	altura SMALLINT,
	CONSTRAINT fk_id_mae FOREIGN KEY (id_mae) REFERENCES mae(id),
	CONSTRAINT fk_id_medico FOREIGN KEY (id_medico) REFERENCES medico(id)
);

CREATE TABLE agendamento(
	id serial PRIMARY KEY,
	id_nascimento INT NOT NULL,
	inicio TIMESTAMP,
	fim TIMESTAMP,
	CONSTRAINT fk_id_nascimento FOREIGN KEY (id_nascimento) REFERENCES nascimento(id)
);



-- Questão 2:

-- Inserções na tabela cidae
INSERT INTO cidade(nome, uf)
VALUES
	('Balneário Camboriú', 'SC'),
	('Florianópolis', 'SC'),
	('Curitiba', 'PR'),
	('Porto Alegre', 'RS'),
	('São Paulo', 'SP');

-- Inserções na tabela mae
INSERT INTO mae (id_cidade, nome, celular) VALUES
(1, 'Maria da Silva', '(48) 99999-1111'),
(2, 'Joana Pereira', '(47) 98888-2222'),
(3, 'Ana Souza', '(41) 97777-3333'),
(4, 'Carla Dias', '(51) 96666-4444'),
(5, 'Fernanda Costa', '(11) 95555-5555');

-- Inserções na tabela medico
INSERT INTO medico (id_cidade, crm, nome, celular, salario, status) VALUES
(1, '12345-SC', 'Dr. Pedro Almeida', '(48) 99999-6666', 12000.00, 1),
(2, '23456-SC', 'Dra. Luana Ribeiro', '(47) 98888-7777', 10500.00, 1),
(3, '34567-PR', 'Dr. Marcos Lima', '(41) 97777-8888', 11300.00, 0),
(4, '45678-RS', 'Dra. Camila Torres', '(51) 96666-9999', 9800.00, 1),
(5, '56789-SP', 'Dr. Rafael Moreira', '(11) 95555-0000', 13200.00, 1);

-- Inserções na tabela nascimento
INSERT INTO nascimento (id_mae, id_medico, nome, data_nascimento, peso, altura) VALUES
(1, 1, 'Lucas Silva', '2023-08-15', 3.215, 49),
(2, 2, 'Beatriz Pereira', '2024-01-10', 2.980, 47),
(3, 3, 'Felipe Souza', '2022-11-03', 3.120, 48),
(4, 4, 'Julia Dias', '2023-03-21', 3.050, 50),
(5, 5, 'Rafael Costa', '2023-07-28', 3.410, 50);

-- Inserções na tabela agendamento
INSERT INTO agendamento (id_nascimento, inicio, fim) VALUES
(1, '2025-04-01 08:00:00', '2025-04-01 09:00:00'),
(2, '2025-04-01 09:30:00', '2025-04-01 10:30:00'),
(3, '2025-04-01 11:00:00', '2025-04-01 12:00:00'),
(4, '2025-04-02 08:00:00', '2025-04-02 09:00:00'),
(5, '2025-04-02 09:30:00', '2025-04-02 10:30:00');


-- Questão 3.1

CREATE OR REPLACE PROCEDURE relatorio_nascimentos(
	p_mes INT,
	p_ano INT
)
LANGUAGE SQL
AS $$
	DROP TABLE IF EXISTS relatorio_temp;
	CREATE TEMP TABLE relatorio_temp AS
	SELECT
		m.nome,
		COUNT(n.id) AS total_nascimentos
	FROM medico AS m
	JOIN nascimento AS n
		ON m.id = n.id_medico
	WHERE 
		EXTRACT(MONTH FROM n.data_nascimento) = p_mes
		AND 
		EXTRACT(YEAR FROM n.data_nascimento) = p_ano
	GROUP BY 
		m.nome
	ORDER BY
		total_nascimentos DESC,
		m.nome ASC
$$;

CALL relatorio_nascimentos(8, 2023);
SELECT * from relatorio_temp;


-- Questão 3.2

CREATE OR REPLACE PROCEDURE inserir_registro_nascimento(
	p_nome VARCHAR,
	p_data_nascimento DATE,
	p_peso DECIMAL,
	p_altura INT,
	p_id_mae INT,
	p_crm_medico VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
	v_id_medico INT;
BEGIN
	IF NOT EXISTS (SELECT 1 FROM mae WHERE id = p_id_mae) THEN
		RAISE EXCEPTION 'Erro: Mãe com ID % não encontrada.', p_id_mae;
	END IF;

	SELECT id INTO v_id_medico
	FROM medico
	WHERE crm = p_crm_medico AND status = 1;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'Erro: Médico com CRM % não encontrado ou está inativo.', p_crm_medico;
	END IF;

	
	INSERT INTO nascimento (nome, data_nascimento, peso, altura, id_mae, id_medico)
	VALUES (p_nome, p_data_nascimento, p_peso, p_altura, p_id_mae, v_id_medico);

	RAISE NOTICE 'Nascimento registrado com sucesso.';
END
$$;


CALL inserir_registro_nascimento('Jonas Sauro', '1998-05-28', 3.75, 65, 0, '12345-SC');

SELECT * FROM medico;
