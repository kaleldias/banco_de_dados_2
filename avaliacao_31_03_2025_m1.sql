/*
	Avaliação Banco de Dados II [M1]
	Professor: Maurício Pasetto
*/

-- Questão 1:
CREATE DATABASE maternidade;
CREATE SCHEMA IF NOT EXISTS maternidade;

SET search_path TO maternidade;

CREATE TABLE mae(
	id SERIAL PRIMARY KEY,
	id_cidade INT NOT NULL,
	nome VARCHAR(100) NOT NULL,
	celular VARCHAR(15),
	CONSTRAINT fk_id_cidade FOREIGN KEY (id_cidade) REFERENCES cidade(id)
);

CREATE TABLE cidade(
	id SERIAL PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	uf CHAR(2) NOT NULL
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
