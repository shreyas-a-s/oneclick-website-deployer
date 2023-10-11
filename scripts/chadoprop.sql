
--
-- Name: chadoprop; Type: TABLE; Schema: chado; Owner: drupaluser
--

CREATE TABLE chado.chadoprop (
    chadoprop_id bigint NOT NULL,
    type_id bigint NOT NULL,
    value text,
    rank integer DEFAULT 0 NOT NULL
);


ALTER TABLE chado.chadoprop OWNER TO drupaluser;

--
-- Name: TABLE chadoprop; Type: COMMENT; Schema: chado; Owner: drupaluser
--

COMMENT ON TABLE chado.chadoprop IS 'This table is different from other prop tables in the database, as it is for storing information about the database itself,::text like schema version';


--
-- Name: COLUMN chadoprop.type_id; Type: COMMENT; Schema: chado; Owner: drupaluser
--

COMMENT ON COLUMN chado.chadoprop.type_id IS 'The name of the property or slot is a cvterm. The meaning of the property is defined in that cvterm.';


--
-- Name: COLUMN chadoprop.value; Type: COMMENT; Schema: chado; Owner: drupaluser
--

COMMENT ON COLUMN chado.chadoprop.value IS 'The value of the property, represented as text. Numeric values are converted to their text representation.';


--
-- Name: COLUMN chadoprop.rank; Type: COMMENT; Schema: chado; Owner: drupaluser
--

COMMENT ON COLUMN chado.chadoprop.rank IS 'Property-Value ordering. Any
cv can have multiple values for any particular property type -
these are ordered in a list using rank, counting from zero. For
properties that are single-valued rather than multi-valued, the
default 0 value should be used.';


--
-- Name: chadoprop_chadoprop_id_seq; Type: SEQUENCE; Schema: chado; Owner: drupaluser
--

CREATE SEQUENCE chado.chadoprop_chadoprop_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE chado.chadoprop_chadoprop_id_seq OWNER TO drupaluser;

--
-- Name: chadoprop_chadoprop_id_seq; Type: SEQUENCE OWNED BY; Schema: chado; Owner: drupaluser
--

ALTER SEQUENCE chado.chadoprop_chadoprop_id_seq OWNED BY chado.chadoprop.chadoprop_id;


--
-- Name: chadoprop chadoprop_id; Type: DEFAULT; Schema: chado; Owner: drupaluser
--

ALTER TABLE ONLY chado.chadoprop ALTER COLUMN chadoprop_id SET DEFAULT nextval('chado.chadoprop_chadoprop_id_seq'::regclass);


--
-- Data for Name: chadoprop; Type: TABLE DATA; Schema: chado; Owner: drupaluser
--

COPY chado.chadoprop (chadoprop_id, type_id, value, rank) FROM stdin;
1	2	1.3	0
\.


COPY chado.cv (cv_id, name, definition) FROM stdin;
1	null	\N
2	local	Locally created terms
3	Statistical Terms	Locally created terms for statistics
4	chado_properties	Terms that are used in the chadoprop table to describe the state of the database
\.

--
-- Name: chadoprop_chadoprop_id_seq; Type: SEQUENCE SET; Schema: chado; Owner: drupaluser
--

SELECT pg_catalog.setval('chado.chadoprop_chadoprop_id_seq', 1, true);


--
-- Name: chadoprop chadoprop_c1; Type: CONSTRAINT; Schema: chado; Owner: drupaluser
--

ALTER TABLE ONLY chado.chadoprop
    ADD CONSTRAINT chadoprop_c1 UNIQUE (type_id, rank);


--
-- Name: chadoprop chadoprop_pkey; Type: CONSTRAINT; Schema: chado; Owner: drupaluser
--

ALTER TABLE ONLY chado.chadoprop
    ADD CONSTRAINT chadoprop_pkey PRIMARY KEY (chadoprop_id);


--
-- Name: chadoprop chadoprop_type_id_fkey; Type: FK CONSTRAINT; Schema: chado; Owner: drupaluser
--

ALTER TABLE ONLY chado.chadoprop
    ADD CONSTRAINT chadoprop_type_id_fkey FOREIGN KEY (type_id) REFERENCES chado.cvterm(cvterm_id) DEFERRABLE INITIALLY DEFERRED;
