CREATE TABLE estado (
	estado_id char(2),
	estado_nome varchar(300),
	PRIMARY KEY(estado_id)
);

CREATE TABLE mesreferencia (
	mesreferencia_anomes char(6),
	mesreferencia_aberto boolean default 't',
	mesreferencia_nome varchar(15),
	PRIMARY KEY(mesreferencia_anomes)
);

CREATE TABLE cargo (
    cargo_id serial,
    cargo_nome character varying(300)
    PRIMARY KEY(cargo_id)   
);

CREATE TABLE setor (
	setor_id serial,
	setor_nome varchar(300),
	PRIMARY KEY(setor_id)
);

CREATE TABLE categoriaassociado (
	categoriaassociado_id serial,
	categoriaassociado_nome varchar(300),
	PRIMARY KEY(categoriaassociado_id)
);


CREATE TABLE associacao (
	associacao_id serial,
	associacao_nome varchar(300),
	associacao_sigla varchar(50),
	PRIMARY KEY(associacao_id)
);


CREATE TABLE tipolancamento (
	tipolancamento_id serial,
	tipolancamento_nome varchar(300),
	PRIMARY KEY(tipolancamento_id)
);


CREATE TABLE tipoconvenio (
	tipoconvenio_id serial,
	tipoconvenio_nome varchar(300),
	PRIMARY KEY(tipoconvenio_id)
);


CREATE TABLE faixamensalidade (
	faixamensalidade_id serial,
	faixamensalidade_nome varchar(300),
	faixamensalidade_valorref numeric(12,4),
	PRIMARY KEY(faixamensalidade_id)
);


CREATE TABLE tiporequisicao (
	tiporequisicao_id serial,
	tiporequisicao_nome varchar(300),
	PRIMARY KEY(tiporequisicao_id)
);


CREATE TABLE cidade (
	cidade_id serial,
	cidade_nome varchar(300),
	FK_estado_id char(2) REFERENCES estado,
	PRIMARY KEY(cidade_id)
);


CREATE TABLE bairro (
	bairro_id serial,
	bairro_nome varchar(300),
	FK_cidade_id integer REFERENCES cidade,
	PRIMARY KEY(bairro_id)
);


CREATE TABLE rua (
	rua_id serial,
	rua_nome varchar(300),
	FK_bairro_id integer REFERENCES bairro,
	PRIMARY KEY(rua_id)
);


CREATE TABLE endereco (
	endereco_id serial,
	endereco_numero integer,
	endereco_complemento varchar(50),
	endereco_referencia varchar(200),
	endereco_cep char(8),
	FK_rua_id integer REFERENCES rua,
	PRIMARY KEY(endereco_id)
);


CREATE TABLE quadroassociativo (
	quadroassociativo_id serial,
	quadroassociativo_admissao date,
	quadroassociativo_desligamento date,
	quadroassociativo_comentario_adm varchar(300),
	quadroassociativo_comentario_des varchar(300),
	FK_associacao_id integer REFERENCES associacao,
	FK_associado_id integer REFERENCES associado,
	PRIMARY KEY(quadroassociativo_id)
);


CREATE TABLE associado (
	associado_id serial,
	associado_nome varchar(300),
	associado_matricula char(4),
	associado_desligado boolean,
	associado_cpf varchar(15),
	FK_categoriaassociado_id integer REFERENCES categoriaassociado,
	FK_faixamensalidade_id integer REFERENCES faixamensalidade,
	FK_endereco_id integer REFERENCES endereco,
	FK_setor_id integer REFERENCES setor,
        FK_cargo_id integer REFERENCES cargo,
	PRIMARY KEY(associado_id)
);


CREATE TABLE convenio (
	convenio_id serial,
	convenio_nome varchar(300),
	FK_endereco_id integer REFERENCES endereco,
	FK_tipoconvenio_id integer REFERENCES tipoconvenio,
	PRIMARY KEY(convenio_id)
);

CREATE TABLE banco (
	banco_id serial,
	banco_nome varchar(300),
	banco_numero integer,
	PRIMARY KEY(banco_id)
);


CREATE TABLE bancoagencia (
	bancoagencia_id serial,
	bancoagencia_nome varchar(300),
	FK_endereco_id integer REFERENCES endereco,
	FK_banco_id integer REFERENCES banco,
	PRIMARY KEY(bancoagencia_id)
);


CREATE TABLE cheque (
	cheque_id serial,
	cheque_nominal varchar(300),
	cheque_valor numeric(12,4),
	cheque_data date,
	cheque_verso text,
	FK_cidade_id integer REFERENCES cidade,
	FK_convenio_id integer REFERENCES convenio,
	PRIMARY KEY(cheque_id)
);

CREATE TABLE emprestimo (
	emprestimo_id serial,
	emprestimo_anomes char(6),
	emprestimo_nrvezes integer,
	emprestimo_descricao varchar(100),
	emprestimo_vlrtotal numeric(12,4),
	emprestimo_vlrprestacao numeric(12,4),
	FK_associado_id integer REFERENCES associado,
	PRIMARY KEY(emprestimo_id)
);


CREATE TABLE requisicao (
	requisicao_id serial,
	requisicao_anomes char(6),
	FK_associado_id integer REFERENCES associado,
	requisicao_descricao varchar(100),
	requisicao_data date,
	requisicao_validade date,
	requisicao_valortotal numeric(12,4),
	requisicao_valorprestacao numeric(12,4),
	requisicao_nrvezes integer,
	FK_convenio_id integer REFERENCES convenio,
	FK_tiporequisicao_id integer REFERENCES tiporequisicao,
	PRIMARY KEY(requisicao_id)
);

CREATE TABLE lancamento (
	lancamento_id serial,
	lancamento_anomes char(6),
	lancamento_nome varchar(100),
	lancamento_valordevido numeric(12,4),
	lancamento_valordescontado numeric(12,4),
	lancamento_estorno numeric(12,4),
        lancamento_codfolha integer,
        lancamento_codsca integer,
	FK_associado_id integer REFERENCES associado,
	FK_faixamensalidade_id integer REFERENCES faixamensalidade,
	FK_emprestimo_id integer REFERENCES emprestimo,
	FK_tipolancamento_id integer REFERENCES tipolancamento,
	FK_requisicao_id integer REFERENCES requisicao,
	PRIMARY KEY(lancamento_id)
);



CREATE TABLE mensalidade (
	mensalidade_anomes char(6),
	FK_associado_id integer REFERENCES associado,
	FK_faixamensalidade_id integer REFERENCES faixamensalidade,
	PRIMARY KEY(mensalidade_anomes,FK_associado_id)
);


CREATE TABLE sede (
	sede_id serial,
	sede_nome varchar(300),
	sede_apelido varchar(50),
	FK_endereco_id integer REFERENCES endereco,
	FK_associacao_id integer REFERENCES associacao,
	PRIMARY KEY(sede_id)
);


CREATE TABLE consignavel (
	consignavel_anomes char(6),
	FK_associado_id integer REFERENCES associado,
	consignavel_valordisponivel numeric(12,2),
	consignavel_valorutilizado numeric(12,2),
        CHECK (consignavel_valordisponivel >= consignavel_valorutilizado)
	PRIMARY KEY(consignavel_anomes,FK_associado_id)
);
