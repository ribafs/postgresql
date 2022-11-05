CREATE TABLE uf (
  UF char(2) NOT NULL default '',
  Nome varchar(72) NOT NULL default '',
  Cep1 varchar(5) NOT NULL default '',
  Cep2 varchar(5) NOT NULL default '',
  PRIMARY KEY  (UF)
) TYPE=MyISAM;

--
-- Dumping data for table `uf`
--

INSERT INTO uf VALUES ('AC','Acre','69900','69999');
INSERT INTO uf VALUES ('AL','Alagoas','57000','57999');
INSERT INTO uf VALUES ('AM','Amazonas','69000','69299');
INSERT INTO uf VALUES ('AP','Amapá','68900','68999');
INSERT INTO uf VALUES ('BA','Bahia','40000','48999');
INSERT INTO uf VALUES ('CE','Ceará','60000','63999');
INSERT INTO uf VALUES ('DF','Distrito Federal','70000','72799');
INSERT INTO uf VALUES ('ES','Espírito Santo','29000','29999');
INSERT INTO uf VALUES ('GO','Goiás','72800','72999');
INSERT INTO uf VALUES ('MA','Maranhão','65000','65999');
INSERT INTO uf VALUES ('MG','Minas Gerais','30000','39999');
INSERT INTO uf VALUES ('MS','Mato Grosso do Sul','79000','79999');
INSERT INTO uf VALUES ('MT','Mato Grosso','78000','78899');
INSERT INTO uf VALUES ('PA','Pará','66000','68899');
INSERT INTO uf VALUES ('PB','Paraíba','58000','58999');
INSERT INTO uf VALUES ('PE','Pernambuco','50000','56999');
INSERT INTO uf VALUES ('PI','Piauí','64000','64999');
INSERT INTO uf VALUES ('PR','Paraná','80000','87999');
INSERT INTO uf VALUES ('RJ','Rio de Janeiro','20000','28999');
INSERT INTO uf VALUES ('RN','Rio Grande do Norte','59000','59999');
INSERT INTO uf VALUES ('RO','Rondônia','78900','78999');
INSERT INTO uf VALUES ('RR','Roraima','69300','69399');
INSERT INTO uf VALUES ('RS','Rio Grande do Sul','90000','99999');
INSERT INTO uf VALUES ('SC','Santa Catarina','88000','89999');
INSERT INTO uf VALUES ('SE','Sergipe','49000','49999');
INSERT INTO uf VALUES ('SP','São Paulo','01000','19999');
INSERT INTO uf VALUES ('TO','Tocantins','77000','77999');

