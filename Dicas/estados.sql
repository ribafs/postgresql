--
-- PostgreSQL database dump
-- GERADO POR GIANCARLO RUBIO / giancarlo.rubio@pucpr.br

SET client_encoding = 'SQL_ASCII';
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 1376 (class 0 OID 0)
-- Name: DUMP TIMESTAMP; Type: DUMP TIMESTAMP; Schema: -; Owner: 
--

-- Started on 2005-05-03 10:47:59 Hora oficial do Brasil


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = true;

--
-- TOC entry 1135 (class 1259 OID 47024)
-- Dependencies: 1372 4
-- Name: estados; Type: TABLE; Schema: public; Owner: piramide; Tablespace: 
--

CREATE TABLE estados (
    id_estado serial NOT NULL,
    abrev_estado character(2) NOT NULL,
    nome_estado character(25) NOT NULL
);


ALTER TABLE public.estados OWNER TO piramide;

--
-- TOC entry 1379 (class 0 OID 0)
-- Dependencies: 1134
-- Name: estados_id_estado_seq; Type: SEQUENCE SET; Schema: public; Owner: piramide
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('estados', 'id_estado'), 27, true);


--
-- TOC entry 1375 (class 0 OID 47024)
-- Dependencies: 1135
-- Data for Name: estados; Type: TABLE DATA; Schema: public; Owner: piramide
--

COPY estados (id_estado, abrev_estado, nome_estado) FROM stdin;
1	AC	Acre                     
2	AL	Alagoas                  
3	AM	Amazônia                 
4	AP	Amapá                    
5	BA	Bahia                    
6	CE	Ceará                    
7	DF	Distrito Federal         
8	ES	Espírito Santo           
9	GO	Goiás                    
10	MA	Maranhão                 
11	MG	Minas-Gerais             
12	MS	Mato Grosso do Sul       
13	MT	Mato Grosso              
14	PA	Pará                     
15	PB	Paraiba                  
16	PE	Pernanbuco               
17	PI	Piauí                    
18	PR	Paraná                   
19	RJ	Rio de Janeiro           
20	RN	Rio Grande do Norte      
21	RO	Rondonia                 
22	RR	Roraima                  
23	RS	Rio Grande do Sul        
24	SC	Santa Catarina           
25	SE	Sergipe                  
26	SP	São Paulo                
27	TO	Tocantins                
\.


--
-- TOC entry 1374 (class 16386 OID 47028)
-- Dependencies: 1135 1135
-- Name: estados_pkey; Type: CONSTRAINT; Schema: public; Owner: piramide; Tablespace: 
--

ALTER TABLE ONLY estados
    ADD CONSTRAINT estados_pkey PRIMARY KEY (id_estado);


ALTER INDEX public.estados_pkey OWNER TO piramide;

--
-- TOC entry 1380 (class 0 OID 0)
-- Name: DUMP TIMESTAMP; Type: DUMP TIMESTAMP; Schema: -; Owner: 
--

-- Completed on 2005-05-03 10:47:59 Hora oficial do Brasil


--
-- PostgreSQL database dump complete
--

