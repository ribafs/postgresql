-- Evite o uso de herança de tabelas no PostgreSQL

-------------------------------------------------------------------------------
-- LANGUAGE
-------------------------------------------------------------------------------

CREATE PROCEDURAL LANGUAGE plpgsql;

-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- TRIGGERS
-------------------------------------------------------------------------------

CREATE FUNCTION adicionarpessoa() RETURNS "trigger"
    AS $$
begin
	insert into tbPessoa (cdPessoa, tpPessoa, nmPessoa, cpf, dtNascimento)
		values (new.cdPessoa, new.tpPessoa, new.nmPessoa, new.cpf, new.dtNascimento);
	return null;
end;
$$
    LANGUAGE plpgsql;

-------------------------------------------------------------------------------

CREATE FUNCTION atualizarpessoa() RETURNS "trigger"
    AS $$
begin
	update tbPessoa set
		tpPessoa     = new.tpPessoa,
		nmPessoa     = new.nmPessoa,
		cpf          = new.cpf,
		dtNascimento = new.dtNascimento
	where cdPessoa = old.cdPessoa;
	return null;
end;
$$
    LANGUAGE plpgsql;

-------------------------------------------------------------------------------

CREATE FUNCTION removerpessoa() RETURNS "trigger"
    AS $$
begin
	delete from tbPessoa where cdPessoa = old.cdPessoa;
	return null;
end;
$$
    LANGUAGE plpgsql;

-------------------------------------------------------------------------------    
        
-------------------------------------------------------------------------------
-- SEQUENCE
-------------------------------------------------------------------------------

CREATE SEQUENCE tbpessoa_cdpessoa_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- TABLES
-------------------------------------------------------------------------------

CREATE TABLE tbpessoa (
    cdpessoa integer NOT NULL,
    nmpessoa character varying(50),
    tppessoa integer,
    cpf character varying(20),
    dtnascimento date
);

ALTER TABLE ONLY tbpessoa
    ADD CONSTRAINT pk_tbpessoa PRIMARY KEY (cdpessoa);

-------------------------------------------------------------------------------

CREATE TABLE tbaluno (
    cdpessoa integer DEFAULT nextval('tbpessoa_cdpessoa_seq'::regclass) NOT NULL,
    nmpessoa character varying(50),
    tppessoa integer DEFAULT 0,
    matricula character varying(20),
    cpf character varying(20),
    dtnascimento date
);

ALTER TABLE ONLY tbaluno
    ADD CONSTRAINT pk_tbaluno PRIMARY KEY (cdpessoa);

CREATE TRIGGER tgadicionarpessoa
    AFTER INSERT ON tbaluno
    FOR EACH ROW
    EXECUTE PROCEDURE adicionarpessoa();

CREATE TRIGGER tgatualizarpessoa
    AFTER UPDATE ON tbaluno
    FOR EACH ROW
    EXECUTE PROCEDURE atualizarpessoa();

CREATE TRIGGER tgremoverpessoa
    AFTER DELETE ON tbaluno
    FOR EACH ROW
    EXECUTE PROCEDURE removerpessoa();    

-------------------------------------------------------------------------------    

CREATE TABLE tbfuncionario (
    cdpessoa integer DEFAULT nextval('tbpessoa_cdpessoa_seq'::regclass) NOT NULL,
    nmpessoa character varying(50),
    tppessoa integer DEFAULT 1,
    cargo character varying(100),
    cdfuncionario character varying(20),
    cpf character varying(20),
    dtnascimento date
);

ALTER TABLE ONLY tbfuncionario
    ADD CONSTRAINT pk_tbfuncionario PRIMARY KEY (cdpessoa);

CREATE TRIGGER tgadicionarpessoa
    AFTER INSERT ON tbfuncionario
    FOR EACH ROW
    EXECUTE PROCEDURE adicionarpessoa();

CREATE TRIGGER tgatualizarpessoa
    AFTER UPDATE ON tbfuncionario
    FOR EACH ROW
    EXECUTE PROCEDURE atualizarpessoa();

CREATE TRIGGER tgremoverpessoa
    AFTER DELETE ON tbfuncionario
    FOR EACH ROW
    EXECUTE PROCEDURE removerpessoa();
        
-------------------------------------------------------------------------------
