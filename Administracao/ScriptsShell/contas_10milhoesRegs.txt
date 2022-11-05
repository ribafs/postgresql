--
-- PostgreSQL database dump
--
--
-- Name: accounts; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE accounts (
    aid integer NOT NULL,
    bid integer,
    abalance integer,
    filler character(84)
);


ALTER TABLE public.accounts OWNER TO postgres;

--
-- Name: accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (aid);


--
-- PostgreSQL database dump complete
--

