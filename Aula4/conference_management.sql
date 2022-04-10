CREATE SCHEMA conference_management;
GO

CREATE TABLE conference_management.pessoa(
	email		VARCHAR(50) NOT NULL,
	nome		VARCHAR(50) NOT NULL,
	PRIMARY KEY(email)
);

CREATE TABLE conference_management.instituicao(
	nome		VARCHAR(50) PRIMARY KEY NOT NULL,
	endereco	VARCHAR(50) NOT NULL,
	email_de_quem_pertence_a_instituicao VARCHAR(50) NOT NULL,
	FOREIGN KEY(email_de_quem_pertence_a_instituicao) REFERENCES conference_management.pessoa(email)
);

CREATE TABLE conference_management.autor(
	email	VARCHAR(50) REFERENCES conference_management.pessoa(email) NOT NULL,
	PRIMARY KEY(email)
);

CREATE TABLE conference_management.artigo_cientifico(
	no_registo	INT PRIMARY KEY NOT NULL,
	titulo		VARCHAR(100) UNIQUE NOT NULL,
	email_de_quem_escreveu VARCHAR(50) NOT NULL,
	FOREIGN KEY(email_de_quem_escreveu) REFERENCES conference_management.autor(email)
);

CREATE TABLE conference_management.participante(
	email		VARCHAR(50) REFERENCES conference_management.pessoa(email) NOT NULL,
	Morada		VARCHAR(50) NOT NULL,
	Data_de_ins	DATE,
	PRIMARY KEY(email)
);

CREATE TABLE conference_management.estudante(
	email		VARCHAR(50) NOT NULL,
	localizacao_comprov VARCHAR(50) NOT NULL,
	FOREIGN KEY(email) REFERENCES conference_management.participante(email)
);

CREATE TABLE conference_management.nao_estudante(
	email		VARCHAR(50) NOT NULL,
	ref_transferencia VARCHAR(50) NOT NULL,
	FOREIGN KEY(email) REFERENCES conference_management.participante(email)
);