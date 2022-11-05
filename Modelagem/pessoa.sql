/*
Banco: pessoa

Cenário:
Modelagem de pessoas (clientes, funcionários, fornecedores, etc) para empresas, órgãos públicos ou outras instituições brasileiras.

Usando o Moedelo Relacional e Normalizado (no SGBD PostgreSQL).
*/

-- Função de validação do CPF e CNPJ:

-- *****************************************************
-- Função: f_cnpjcpf
-- Objetivo:
-- Validar o número do documento especificado
-- (CNPJ ou CPF) ou não (livre)
-- Argumentos:
-- Pessoa 
-- Jurídica(0),
-- Física(1) ou 
-- Livre(2)] (integer), 
-- Número com dígitos verificadores e sem pontuação (bpchar)
-- Retorno:
-- -1: Tipo de Documento invalido.
-- -2: Caracter inválido no numero do documento.
-- -3: Numero do Documento invalido.
--  1: OK (smallint)
-- *****************************************************
--
/*
-- Número com dígitos verificadores e sem nenhuma máscara (bpchar)

-- Válidos
SELECT f_cnpjcpf( 0, '46376021000107' );-- CNPJ
SELECT f_cnpjcpf( 1, '48533316461' ); 	-- CPF
SELECT f_cnpjcpf( 2, 'isento' );      	-- Livre 

-- Inválidos
SELECT f_cnpjcpf( 0, '46376044444107' );-- CNPJ
SELECT f_cnpjcpf( 1, '40003316461' ); 	-- CPF
SELECT f_cnpjcpf( 2, 'isento' );      	-- Livre 

Retornos possíveis:
-- -1: Tipo de Documento invalido.
-- -2: Caracter inválido no numero do documento.
-- -3: Numero do Documento invalido.
--  1: Documento Validado Corretamente - OK (smallint)
*/

create language plpgsql;

CREATE OR REPLACE FUNCTION f_cnpjcpf (integer,bpchar)
RETURNS integer
AS '
DECLARE
-- Argumentos
-- Tipo de verificacao : 0 (PJ), 1 (PF) e 2 (Livre)
   pTipo ALIAS FOR $1;
-- Numero do documento
   pNumero ALIAS FOR $2;
-- Variaveis
   i INT4; -- Contador
   iProd INT4; -- Somatório
   iMult INT4; -- Fator
   iDigito INT4; -- Digito verificador calculado
   sNumero VARCHAR(20); -- numero do docto completo
BEGIN
-- verifica Argumentos validos
   IF (pTipo < 0) OR (pTipo > 2) THEN
      RETURN -1;
   END IF;
-- se for Livre, nao eh necessario a verificacao
  IF pTipo = 2 THEN
    RETURN 1;
  END IF;
  sNumero := trim(pNumero);
  FOR i IN 1..char_length(sNumero) LOOP
    IF position(substring(sNumero, i, 1) in ''1234567890'') = 0 THEN
       RETURN -2;
    END IF;
  END LOOP;
  sNumero := '''';
-- *****************************************************
-- Verifica a validade do CNPJ
-- *****************************************************
  IF (char_length(trim(pNumero)) = 14) AND (pTipo = 0) THEN
-- primeiro digito
    sNumero := substring(pNumero from 1 for 12);
    iMult := 2;
    iProd := 0;
    FOR i IN REVERSE 12..1 LOOP
       iProd := iProd + to_number(substring(sNumero from i for 1),''9'') * iMult;
       IF iMult = 9 THEN
         iMult := 2;
       ELSE
         iMult := iMult + 1;
       END IF;
    END LOOP;
    iDigito := 11 - (iProd % 11);
    IF iDigito >= 10 THEN
       iDigito := 0;
    END IF;
    sNumero := substring(pNumero from 1 for 12) || trim(to_char(iDigito,''9'')) || ''0'';
-- segundo digito
    iMult := 2;
    iProd := 0;
    FOR i IN REVERSE 13..1 LOOP
       iProd := iProd + to_number(substring(sNumero from i for 1),''9'') * iMult;
       IF iMult = 9 THEN
         iMult := 2;
       ELSE
         iMult := iMult + 1;
       END IF;
     END LOOP;
     iDigito := 11 - (iProd % 11);
     IF iDigito >= 10 THEN
       iDigito := 0;
     END IF;
     sNumero := substring(sNumero from 1 for 13) || trim(to_char(iDigito,''9''));
  END IF;
-- *****************************************************
-- Verifica a validade do CPF
-- *****************************************************
  IF (char_length(trim(pNumero)) = 11) AND (pTipo = 1) THEN
-- primeiro digito
     iDigito := 0;
     iProd := 0;
     sNumero := substring(pNumero from 1 for 9);
     FOR i IN 1..9 LOOP
       iProd := iProd + (to_number(substring(sNumero from i for 1),''9'') * (11 - i));
     END LOOP;
     iDigito := 11 - (iProd % 11);
     IF (iDigito) >= 10 THEN
       iDigito := 0;
     END IF;
     sNumero := substring(pNumero from 1 for 9) || trim(to_char(iDigito,''9'')) || ''0'';
-- segundo digito
     iProd := 0;
     FOR i IN 1..10 LOOP
       iProd := iProd + (to_number(substring(sNumero from i for 1),''9'') * (12 - i));
     END LOOP;
     iDigito := 11 - (iProd % 11);
     IF (iDigito) >= 10 THEN
       iDigito := 0;
     END IF;
     sNumero := substring(sNumero from 1 for 10) || trim(to_char(iDigito,''9''));
  END IF;
-- faz a verificacao do digito verificador calculado
  IF pNumero = sNumero::bpchar THEN
    RETURN 1;
   ELSE
    RETURN -3;
   END IF;
END;
' LANGUAGE 'plpgsql';

-- Esta função acima é do Juliano Ignácio num dos seus artigos do iMasters:
-- http://imasters.uol.com.br/artigo/1308/stored_procedures_triggers_functions


-- Validação de inscrição estadual do Ceará, tendo como fonte o algoritmo em: http://www.sintegra.gov.br/Cad_Estados/cad_CE.html
-- No Ceará a IE tem 8 dígitos válidos mais o dígito verificador

create or replace function f_ie_ce(ie_ce text) returns text as
$$
declare
	n1 integer;
	n2 integer;	
	n3 integer;
	n4 integer;
	n5 integer;
	n6 integer;
	n7 integer;
	n8 integer;
	n9 integer;
	nt integer;
	s  integer;
	m  integer;
	dv integer;
begin
	n1 = substring(ie_ce from 1 for 1)::integer;
	n2 = substring(ie_ce from 2 for 1)::integer;
	n3 = substring(ie_ce from 3 for 1)::integer;
	n4 = substring(ie_ce from 4 for 1)::integer;
	n5 = substring(ie_ce from 5 for 1)::integer;
	n6 = substring(ie_ce from 6 for 1)::integer;
	n7 = substring(ie_ce from 7 for 1)::integer;
	n8 = substring(ie_ce from 8 for 1)::integer;
	n9 = substring(ie_ce from 9 for 1)::integer;
	s = 9*n1 + 8*n2 + 7*n3 + 6*n4 + 5*n5 + 4*n6 + 3*n7 + 2*n8;
	m = s%11;
	dv = 11 - m;
	-- raise exception 'm vale(%), dv vale(%), n6(%)',m,dv, n6; 
	if (dv>=10) then 
		dv = 0; 
	end if;
	if (dv = n9) then
		return 1;
	else
		return 0;
	end if;
end;
$$
language 'plpgsql';	

-- select ie_ce('060000014')

-- Função para gerar uma inscrição estadual (do Ceará) válida para testes

create or replace function ie_ce_gerador() returns text as
$$
declare
	ie_ce text;
	n1 integer;
	n2 integer;	
	n3 integer;
	n4 integer;
	n5 integer;
	n6 integer;
	n7 integer;
	n8 integer;
	n9 integer;
	nt integer;
	s  integer;
	m  integer;
	dv integer;
	d boolean;
begin
	d = FALSE;
	while (d = FALSE) loop
	ie_ce = floor(random()*1000000000+1)::text;

	-- if (char_length(ie_ce)<9) then continue; end if;
	
	n1 = substring(ie_ce from 1 for 1)::integer;
	n2 = substring(ie_ce from 2 for 1)::integer;
	n3 = substring(ie_ce from 3 for 1)::integer;
	n4 = substring(ie_ce from 4 for 1)::integer;
	n5 = substring(ie_ce from 5 for 1)::integer;
	n6 = substring(ie_ce from 6 for 1)::integer;
	n7 = substring(ie_ce from 7 for 1)::integer;
	n8 = substring(ie_ce from 8 for 1)::integer;
	n9 = substring(ie_ce from 9 for 1)::integer;
	
	s = 9*n1 + 8*n2 + 7*n3 + 6*n4 + 5*n5 + 4*n6 + 3*n7 + 2*n8;
	m = s%11;
	dv = 11 - m;
	-- raise exception 'm vale(%), dv vale(%), n6(%)',m,dv, n6; 	

	if (dv>=10) then 
		dv = 0; 
	end if;
	if (dv = n9) then
		d = TRUE;
		return ie_ce;
		exit;
	else
		d = FALSE;
		continue;
	end if;
	if (d = TRUE) then exit; end if;
	end loop;
return 0;	
end;
$$
language 'plpgsql';	
-- testar com select ie_ce_gerador()

-- Criação de domínios para melhorar as restrições dos tipos e agilizar criação de novas tabelas

CREATE DOMAIN dom_cnpj AS text
    CONSTRAINT chk_cnpj CHECK (f_cnpjcpf(0, VALUE) = 1) NOT NULL;

CREATE DOMAIN dom_cpf AS text
    CONSTRAINT chk_cpf CHECK (f_cnpjcpf(1, VALUE)=1 OR VALUE ~ '^informal$') NOT NULL; 
	-- Aceitar 'informal' ou 11 dígitos do CPF

CREATE DOMAIN dom_ie_ce AS text -- inscrição estadual para o Ceará, pois muda de um estado para outro
    CONSTRAINT chk_ie_ce CHECK (f_ie_ce(VALUE)=1 OR VALUE ~ '^isento$') NOT NULL;

CREATE DOMAIN dom_cep AS text
    CONSTRAINT chk_cep CHECK (VALUE ~ '^[0-9]{8}$') NOT NULL;

	-- Os abaixo devem permitir nulo

CREATE DOMAIN dom_email AS text
	CONSTRAINT chk_email CHECK (VALUE ~ '^[a-zA-Z][[:alnum:]_.-]*@[a-zA-Z][[:alnum:]_.-]*[.][a-zA-Z]+$');

CREATE DOMAIN dom_url AS text
	CONSTRAINT chk_url CHECK (VALUE ~ '^((https|http):\/\/)?(([a-z]([a-z0-9\-_]*\.)+)(aero|arpa|biz|com|coop|edu|gov|info|int|jobs|mil|museum|name|nato|net|org|pro|travel|br|[a-z]{2})(\/[a-z0-9_\-\.~]+)*(\/([a-z0-9_\-\.]*)(\?[a-z0-9+_\-\.\/%=&]*)?)?)$');

CREATE DOMAIN dom_telefone AS text
	CONSTRAINT chk_telefone CHECK (VALUE ~ '^[3-9]{1}[0-9]{7}$'); -- Válidos somente iniciados com 3 e superiores

create table tipos
(
	tipo int primary key,
	descricao varchar(50) not null
);


-- Tabelas
create table logradouros
(
	logradouro int primary key,
	descricao varchar(50) not null
);

create table bairros
(
	bairro int primary key,
	descricao varchar(50) not null
);

create table ufs
(
	uf int primary key,
	descricao varchar(2) not null
);

create table municipios
(
	municipio varchar(50) primary key,
	uf int not null,
	constraint uf_fk foreign key (uf) references ufs(uf)
);

create table ceps
(
	cep dom_cep,
	tipo int, 
	logradouro int,
	bairro int,
	municipio int,
	primary key(cep, logradouro), 
	constraint tipo_fk foreign key (tipo) references tipos(tipo),
	constraint logradouro_fk foreign key (logradouro) references logradouros(logradouro),
	constraint bairro_fk foreign key (bairro) references bairros(bairro),
	constraint municipio_fk foreign key (municipio) references municipios(municipio)
);

create table enderecos
(
	cep int not null,
	logradouro int not null,
	numero varchar(8) not null,
	primary key(cep, numero),
	constraint cep_fk foreign key (cep,logradouro) references ceps(cep,logradouro)
);

-- Lembrando que aqui ainda faltam alguns atributos para o endereço: bloco, andar, apartamento e talvez ainda outros

create table telefones
(
	telefone int not null primary key,
	ddd varchar(4) not null,
	numero dom_telefone
);

create table fisicas
(
	fisica int primary key,
	cpf dom_cpf
);

create table juridicas
(
	cnpj dom_cnpj primary key,
	inscricao_estadual dom_ie_ce,
	site dom_url
);

create table pessoas
(
	pessoa int not null primary key,	
	nome varchar(45) not null,
	cep int not null,
	tipo int not null,
	numero varchar(8) null,
	telefone int, -- Permitindo NULL, para o caso de alguém não ter telefone
	email dom_email,
	constraint telefone_fk foreign key (telefone) references telefones(telefone),
	constraint endereco_fk foreign key (cep,numero) references enderecos(cep,numero),
	constraint fisica_fk foreign key(tipo) references fisicas(fisica),
	constraint juridica_fk foreign key(tipo) references juridicas(cnpj)
);

-- Criação de índices parciais, que permitirão a criação de campos com CPF únicos, mas somente para os que existirem

create unique index idx_cpf on fisicas (cpf)
    WHERE NOT (cpf = 'informal');

create unique index idx_ie on juridicas (inscricao_estadual)
    WHERE NOT (inscricao_estadual = 'isento');

-- INSERINDO ALGUNS REGISTROS PARA TESTE

insert into fisicas values(1, '22366437803');
insert into fisicas values(2, '47720595203');
insert into fisicas values(3, '33557245640');
insert into fisicas values(4, '56484636427');
--insert into fisicas values(5, '56484636426'); -- inválido
insert into fisicas values(6, 'informal');
insert into fisicas values(7, '90807363685');
--insert into fisicas values(8, 'informal_erro');
insert into fisicas values(8, 'informal'); -- aceita repetir informal
insert into fisicas values(9, 'informal');
insert into fisicas values(10, 'informal');


