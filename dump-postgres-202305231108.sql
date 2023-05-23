--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2
-- Dumped by pg_dump version 15.2

-- Started on 2023-05-23 11:08:43

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 7 (class 2615 OID 16398)
-- Name: si; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA si;


ALTER SCHEMA si OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 16409)
-- Name: donnee; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.donnee (
    id_donnee integer NOT NULL,
    id_polluant integer,
    libelle_donnee character varying,
    type_donnee character varying,
    id_maturite integer DEFAULT 0 NOT NULL,
    id_proprietaire_objet integer DEFAULT 0 NOT NULL,
    id_maille_geo integer DEFAULT 0 NOT NULL,
    id_maille_temps integer DEFAULT 0 NOT NULL,
    reglementaire character varying DEFAULT 'N'::character varying,
    debut_recolte date,
    outil_source character varying
);


ALTER TABLE si.donnee OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16493)
-- Name: etat_maturite; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.etat_maturite (
    id_etat_maturite integer NOT NULL,
    libelle_etat_maturite character varying
);


ALTER TABLE si.etat_maturite OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16569)
-- Name: maille_geo; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.maille_geo (
    id_maille_geo integer NOT NULL,
    libelle_maille_geo character varying
);


ALTER TABLE si.maille_geo OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 16568)
-- Name: maille_geo_id_maille_seq; Type: SEQUENCE; Schema: si; Owner: postgres
--

CREATE SEQUENCE si.maille_geo_id_maille_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE si.maille_geo_id_maille_seq OWNER TO postgres;

--
-- TOC entry 3456 (class 0 OID 0)
-- Dependencies: 234
-- Name: maille_geo_id_maille_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.maille_geo_id_maille_seq OWNED BY si.maille_geo.id_maille_geo;


--
-- TOC entry 236 (class 1259 OID 16594)
-- Name: maille_temps; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.maille_temps (
    id_maille_temps integer DEFAULT nextval('si.maille_geo_id_maille_seq'::regclass) NOT NULL,
    libelle_maille_temps character varying
);


ALTER TABLE si.maille_temps OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16400)
-- Name: polluant; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.polluant (
    id_polluant integer NOT NULL,
    libelle_polluant character varying,
    code_polluant_lcsqa character varying,
    date_maj date DEFAULT now()
);


ALTER TABLE si.polluant OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16502)
-- Name: proprietaire_objet; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.proprietaire_objet (
    id_proprietaire_objet integer NOT NULL,
    libelle_proprietaire_objet character varying
);


ALTER TABLE si.proprietaire_objet OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16621)
-- Name: donnee_claire; Type: VIEW; Schema: si; Owner: postgres
--

CREATE VIEW si.donnee_claire AS
 SELECT d.id_donnee,
    d.id_polluant,
    d.libelle_donnee,
    p.libelle_polluant,
    d.type_donnee,
    em.libelle_etat_maturite,
    po.libelle_proprietaire_objet,
    mg.libelle_maille_geo,
    mt.libelle_maille_temps,
    d.reglementaire,
    d.debut_recolte,
    d.outil_source
   FROM (((((si.donnee d
     JOIN si.polluant p ON ((p.id_polluant = d.id_polluant)))
     JOIN si.etat_maturite em ON ((em.id_etat_maturite = d.id_maturite)))
     JOIN si.proprietaire_objet po ON ((po.id_proprietaire_objet = d.id_proprietaire_objet)))
     JOIN si.maille_geo mg ON ((mg.id_maille_geo = d.id_maille_geo)))
     JOIN si.maille_temps mt ON ((mt.id_maille_temps = d.id_maille_temps)));


ALTER TABLE si.donnee_claire OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16408)
-- Name: donnee_code_donnee_seq; Type: SEQUENCE; Schema: si; Owner: postgres
--

CREATE SEQUENCE si.donnee_code_donnee_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE si.donnee_code_donnee_seq OWNER TO postgres;

--
-- TOC entry 3457 (class 0 OID 0)
-- Dependencies: 218
-- Name: donnee_code_donnee_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.donnee_code_donnee_seq OWNED BY si.donnee.id_donnee;


--
-- TOC entry 226 (class 1259 OID 16479)
-- Name: donnee_lien; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.donnee_lien (
    id_donnee_source integer NOT NULL,
    id_donnee_cible integer NOT NULL
);


ALTER TABLE si.donnee_lien OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16492)
-- Name: etat_maturite_code_etat_maturite_seq; Type: SEQUENCE; Schema: si; Owner: postgres
--

CREATE SEQUENCE si.etat_maturite_code_etat_maturite_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE si.etat_maturite_code_etat_maturite_seq OWNER TO postgres;

--
-- TOC entry 3458 (class 0 OID 0)
-- Dependencies: 227
-- Name: etat_maturite_code_etat_maturite_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.etat_maturite_code_etat_maturite_seq OWNED BY si.etat_maturite.id_etat_maturite;


--
-- TOC entry 224 (class 1259 OID 16438)
-- Name: media; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.media (
    id_media integer NOT NULL,
    titre_media character varying,
    url_media character varying,
    id_type_media integer,
    id_maturite integer DEFAULT 1 NOT NULL,
    id_proprietaire_objet integer DEFAULT 1 NOT NULL
);


ALTER TABLE si.media OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16453)
-- Name: media_donnee; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.media_donnee (
    id_media integer NOT NULL,
    id_donnee integer NOT NULL,
    id_maille_geo_diff integer,
    id_maille_tempo_diff integer,
    profondeur_histo_diff character varying
);


ALTER TABLE si.media_donnee OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16437)
-- Name: media_id_media_seq; Type: SEQUENCE; Schema: si; Owner: postgres
--

CREATE SEQUENCE si.media_id_media_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE si.media_id_media_seq OWNER TO postgres;

--
-- TOC entry 3459 (class 0 OID 0)
-- Dependencies: 223
-- Name: media_id_media_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.media_id_media_seq OWNED BY si.media.id_media;


--
-- TOC entry 233 (class 1259 OID 16551)
-- Name: media_publication; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.media_publication (
    id_media integer NOT NULL,
    id_publication integer NOT NULL,
    emprise_geo character varying,
    condition_acces character varying
);


ALTER TABLE si.media_publication OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16399)
-- Name: polluant_code_polluant_seq; Type: SEQUENCE; Schema: si; Owner: postgres
--

CREATE SEQUENCE si.polluant_code_polluant_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE si.polluant_code_polluant_seq OWNER TO postgres;

--
-- TOC entry 3460 (class 0 OID 0)
-- Dependencies: 216
-- Name: polluant_code_polluant_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.polluant_code_polluant_seq OWNED BY si.polluant.id_polluant;


--
-- TOC entry 229 (class 1259 OID 16501)
-- Name: proprietaire_objet_id_proprietaire_objet_seq; Type: SEQUENCE; Schema: si; Owner: postgres
--

CREATE SEQUENCE si.proprietaire_objet_id_proprietaire_objet_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE si.proprietaire_objet_id_proprietaire_objet_seq OWNER TO postgres;

--
-- TOC entry 3461 (class 0 OID 0)
-- Dependencies: 229
-- Name: proprietaire_objet_id_proprietaire_objet_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.proprietaire_objet_id_proprietaire_objet_seq OWNED BY si.proprietaire_objet.id_proprietaire_objet;


--
-- TOC entry 232 (class 1259 OID 16515)
-- Name: publication; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.publication (
    id_publication integer NOT NULL,
    libelle_publication character varying,
    id_maturite integer,
    id_proprietaire_objet integer
);


ALTER TABLE si.publication OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16514)
-- Name: publication_id_publication_seq; Type: SEQUENCE; Schema: si; Owner: postgres
--

CREATE SEQUENCE si.publication_id_publication_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE si.publication_id_publication_seq OWNER TO postgres;

--
-- TOC entry 3462 (class 0 OID 0)
-- Dependencies: 231
-- Name: publication_id_publication_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.publication_id_publication_seq OWNED BY si.publication.id_publication;


--
-- TOC entry 222 (class 1259 OID 16429)
-- Name: type_media; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.type_media (
    id_type_media integer NOT NULL,
    libelle_type_media character varying
);


ALTER TABLE si.type_media OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16428)
-- Name: type_media_code_type_media_seq; Type: SEQUENCE; Schema: si; Owner: postgres
--

CREATE SEQUENCE si.type_media_code_type_media_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE si.type_media_code_type_media_seq OWNER TO postgres;

--
-- TOC entry 3463 (class 0 OID 0)
-- Dependencies: 221
-- Name: type_media_code_type_media_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.type_media_code_type_media_seq OWNED BY si.type_media.id_type_media;


--
-- TOC entry 3235 (class 2604 OID 16412)
-- Name: donnee id_donnee; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee ALTER COLUMN id_donnee SET DEFAULT nextval('si.donnee_code_donnee_seq'::regclass);


--
-- TOC entry 3245 (class 2604 OID 16496)
-- Name: etat_maturite id_etat_maturite; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.etat_maturite ALTER COLUMN id_etat_maturite SET DEFAULT nextval('si.etat_maturite_code_etat_maturite_seq'::regclass);


--
-- TOC entry 3248 (class 2604 OID 16572)
-- Name: maille_geo id_maille_geo; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.maille_geo ALTER COLUMN id_maille_geo SET DEFAULT nextval('si.maille_geo_id_maille_seq'::regclass);


--
-- TOC entry 3242 (class 2604 OID 16441)
-- Name: media id_media; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media ALTER COLUMN id_media SET DEFAULT nextval('si.media_id_media_seq'::regclass);


--
-- TOC entry 3233 (class 2604 OID 16403)
-- Name: polluant id_polluant; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.polluant ALTER COLUMN id_polluant SET DEFAULT nextval('si.polluant_code_polluant_seq'::regclass);


--
-- TOC entry 3246 (class 2604 OID 16505)
-- Name: proprietaire_objet id_proprietaire_objet; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.proprietaire_objet ALTER COLUMN id_proprietaire_objet SET DEFAULT nextval('si.proprietaire_objet_id_proprietaire_objet_seq'::regclass);


--
-- TOC entry 3247 (class 2604 OID 16518)
-- Name: publication id_publication; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.publication ALTER COLUMN id_publication SET DEFAULT nextval('si.publication_id_publication_seq'::regclass);


--
-- TOC entry 3241 (class 2604 OID 16432)
-- Name: type_media id_type_media; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.type_media ALTER COLUMN id_type_media SET DEFAULT nextval('si.type_media_code_type_media_seq'::regclass);


--
-- TOC entry 3434 (class 0 OID 16409)
-- Dependencies: 219
-- Data for Name: donnee; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.donnee VALUES (10, 1, 'nb jour depassement O3', 'Calcul_agreg', 1, 0, 0, 11, 'N', '1997-01-01', 'Outil Calcul reglementaire?');
INSERT INTO si.donnee VALUES (11, 0, 'Indice Atmo', 'Modelisation Previ', 1, 0, 14, 13, 'O', '2021-01-01', 'Outil Previ');
INSERT INTO si.donnee VALUES (12, 5, 'Sous Indice Atmo SO2', 'Modelisation Previ', 1, 1, 14, 13, 'N', '2021-01-01', 'Outil Previ');
INSERT INTO si.donnee VALUES (13, 2, 'Sous Indice Atmo PM2.5', 'Modelisation Previ', 1, 1, 14, 13, 'N', '2021-01-01', 'Outil Previ');
INSERT INTO si.donnee VALUES (14, 3, 'Sous Indice Atmo PM10', 'Modelisation Previ', 1, 1, 14, 13, 'N', '2021-01-01', 'Outil Previ');
INSERT INTO si.donnee VALUES (15, 1, 'Sous Indice Atmo O3', 'Modelisation Previ', 1, 1, 14, 13, 'N', '2021-01-01', 'Outil Previ');
INSERT INTO si.donnee VALUES (16, 4, 'Sous Indice Atmo NO2', 'Modelisation Previ', 1, 1, 14, 13, 'N', '2021-01-01', 'Outil Previ');
INSERT INTO si.donnee VALUES (2, 5, 'mesure 1/4h SO2', 'mesure', 1, 1, 5, 7, 'N', '1997-01-01', 'XR');
INSERT INTO si.donnee VALUES (3, 2, 'mesure 1/4h PM2.5', 'mesure', 1, 1, 5, 7, 'N', '1997-01-01', 'XR');
INSERT INTO si.donnee VALUES (4, 3, 'mesure 1/4h PM10', 'mesure', 1, 1, 5, 7, 'N', '1997-01-01', 'XR');
INSERT INTO si.donnee VALUES (5, 1, 'mesure 1/4h O3', 'mesure', 1, 1, 5, 7, 'N', '1997-01-01', 'XR');
INSERT INTO si.donnee VALUES (1, 4, 'mesure 1/4h NO2', 'mesure', 1, 1, 5, 7, 'O', '1997-01-01', 'XR');
INSERT INTO si.donnee VALUES (6, 1, 'mesure moyenne horaire O3', 'Calcul_agreg', 1, 1, 5, 8, 'O', '1997-01-01', 'XR');
INSERT INTO si.donnee VALUES (7, 1, 'mesure moyenne Journaliere O3', 'Calcul_agreg', 1, 1, 5, 13, 'O', '1997-01-01', 'XR?');
INSERT INTO si.donnee VALUES (8, 1, 'mesure moyenne Mensuelle O3', 'Calcul_agreg', 1, 1, 5, 9, 'O', '1997-01-01', 'XR?');
INSERT INTO si.donnee VALUES (9, 1, 'mesure moyenne Annuelle O3', 'Calcul_agreg', 1, 1, 5, 11, 'O', '1997-01-01', 'XR?');


--
-- TOC entry 3440 (class 0 OID 16479)
-- Dependencies: 226
-- Data for Name: donnee_lien; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.donnee_lien VALUES (5, 6);
INSERT INTO si.donnee_lien VALUES (6, 7);
INSERT INTO si.donnee_lien VALUES (6, 8);
INSERT INTO si.donnee_lien VALUES (6, 9);
INSERT INTO si.donnee_lien VALUES (12, 11);
INSERT INTO si.donnee_lien VALUES (13, 11);
INSERT INTO si.donnee_lien VALUES (14, 11);
INSERT INTO si.donnee_lien VALUES (15, 11);
INSERT INTO si.donnee_lien VALUES (16, 11);


--
-- TOC entry 3442 (class 0 OID 16493)
-- Dependencies: 228
-- Data for Name: etat_maturite; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.etat_maturite VALUES (0, 'Inconnu');
INSERT INTO si.etat_maturite VALUES (1, 'Service Regulier');
INSERT INTO si.etat_maturite VALUES (2, 'A l''étude');


--
-- TOC entry 3449 (class 0 OID 16569)
-- Dependencies: 235
-- Data for Name: maille_geo; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.maille_geo VALUES (1, 'Région');
INSERT INTO si.maille_geo VALUES (2, 'Département');
INSERT INTO si.maille_geo VALUES (3, 'EPCI');
INSERT INTO si.maille_geo VALUES (4, 'Commune');
INSERT INTO si.maille_geo VALUES (5, 'Point GPS');
INSERT INTO si.maille_geo VALUES (6, 'Sur Mesure');
INSERT INTO si.maille_geo VALUES (0, 'Inconnue');
INSERT INTO si.maille_geo VALUES (14, 'Meso Echelle 1Km');


--
-- TOC entry 3450 (class 0 OID 16594)
-- Dependencies: 236
-- Data for Name: maille_temps; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.maille_temps VALUES (0, 'Inconnu');
INSERT INTO si.maille_temps VALUES (7, 'Quart-horaire');
INSERT INTO si.maille_temps VALUES (8, 'Horaire');
INSERT INTO si.maille_temps VALUES (9, 'Mensuel');
INSERT INTO si.maille_temps VALUES (10, 'Hebdo');
INSERT INTO si.maille_temps VALUES (11, 'Annuel');
INSERT INTO si.maille_temps VALUES (12, 'Tri-Annuel');
INSERT INTO si.maille_temps VALUES (13, 'Quotidien');


--
-- TOC entry 3438 (class 0 OID 16438)
-- Dependencies: 224
-- Data for Name: media; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.media VALUES (1, 'Carte Indice Atmo Jour', NULL, 1, 0, 0);
INSERT INTO si.media VALUES (2, 'Widget Air de ma commune / Indice', 'https://www.atmonormandie.fr/air-commune/SaintLo/50502/indice-atmo?date=2023-05-04', 6, 1, 2);


--
-- TOC entry 3439 (class 0 OID 16453)
-- Dependencies: 225
-- Data for Name: media_donnee; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.media_donnee VALUES (2, 11, 4, 13, 'J');
INSERT INTO si.media_donnee VALUES (2, 12, 4, 13, 'J');
INSERT INTO si.media_donnee VALUES (2, 13, 4, 13, 'J');
INSERT INTO si.media_donnee VALUES (2, 14, 4, 13, 'J');
INSERT INTO si.media_donnee VALUES (2, 15, 4, 13, 'J');
INSERT INTO si.media_donnee VALUES (2, 16, 4, 13, 'J');


--
-- TOC entry 3447 (class 0 OID 16551)
-- Dependencies: 233
-- Data for Name: media_publication; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.media_publication VALUES (2, 1, 'Region', 'public');


--
-- TOC entry 3432 (class 0 OID 16400)
-- Dependencies: 217
-- Data for Name: polluant; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.polluant VALUES (1, 'Ozone', NULL, '2025-02-04');
INSERT INTO si.polluant VALUES (2, 'PM2.5', NULL, '2025-02-04');
INSERT INTO si.polluant VALUES (3, 'PM10', NULL, '2025-02-04');
INSERT INTO si.polluant VALUES (4, 'NO2', NULL, '2025-02-04');
INSERT INTO si.polluant VALUES (5, 'SO2', NULL, '2025-02-04');
INSERT INTO si.polluant VALUES (7, ' Ether ', ' XX ', '2023-04-27');
INSERT INTO si.polluant VALUES (8, ' MethaneCH4 ', ' CD5 ', '2023-04-27');
INSERT INTO si.polluant VALUES (0, 'Aucun/Multi', NULL, '2023-05-15');


--
-- TOC entry 3444 (class 0 OID 16502)
-- Dependencies: 230
-- Data for Name: proprietaire_objet; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.proprietaire_objet VALUES (0, 'Inconnu');
INSERT INTO si.proprietaire_objet VALUES (1, 'Laboratoire');
INSERT INTO si.proprietaire_objet VALUES (2, 'Service Communication');


--
-- TOC entry 3446 (class 0 OID 16515)
-- Dependencies: 232
-- Data for Name: publication; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.publication VALUES (1, 'Site Atmo Normandie', 1, 2);


--
-- TOC entry 3436 (class 0 OID 16429)
-- Dependencies: 222
-- Data for Name: type_media; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.type_media VALUES (1, 'Carte Dynamique');
INSERT INTO si.type_media VALUES (2, 'Carte Statique');
INSERT INTO si.type_media VALUES (3, 'Fichier Excel');
INSERT INTO si.type_media VALUES (4, 'Flux API');
INSERT INTO si.type_media VALUES (5, 'Flux Carto');
INSERT INTO si.type_media VALUES (6, 'DataViz');


--
-- TOC entry 3464 (class 0 OID 0)
-- Dependencies: 218
-- Name: donnee_code_donnee_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.donnee_code_donnee_seq', 16, true);


--
-- TOC entry 3465 (class 0 OID 0)
-- Dependencies: 227
-- Name: etat_maturite_code_etat_maturite_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.etat_maturite_code_etat_maturite_seq', 1, false);


--
-- TOC entry 3466 (class 0 OID 0)
-- Dependencies: 234
-- Name: maille_geo_id_maille_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.maille_geo_id_maille_seq', 14, true);


--
-- TOC entry 3467 (class 0 OID 0)
-- Dependencies: 223
-- Name: media_id_media_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.media_id_media_seq', 2, true);


--
-- TOC entry 3468 (class 0 OID 0)
-- Dependencies: 216
-- Name: polluant_code_polluant_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.polluant_code_polluant_seq', 37, true);


--
-- TOC entry 3469 (class 0 OID 0)
-- Dependencies: 229
-- Name: proprietaire_objet_id_proprietaire_objet_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.proprietaire_objet_id_proprietaire_objet_seq', 2, true);


--
-- TOC entry 3470 (class 0 OID 0)
-- Dependencies: 231
-- Name: publication_id_publication_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.publication_id_publication_seq', 1, true);


--
-- TOC entry 3471 (class 0 OID 0)
-- Dependencies: 221
-- Name: type_media_code_type_media_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.type_media_code_type_media_seq', 6, true);


--
-- TOC entry 3253 (class 2606 OID 16416)
-- Name: donnee donnee_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee
    ADD CONSTRAINT donnee_pk PRIMARY KEY (id_donnee);


--
-- TOC entry 3261 (class 2606 OID 16500)
-- Name: etat_maturite etat_maturite_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.etat_maturite
    ADD CONSTRAINT etat_maturite_pk PRIMARY KEY (id_etat_maturite);


--
-- TOC entry 3267 (class 2606 OID 16576)
-- Name: maille_geo maille_geo_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.maille_geo
    ADD CONSTRAINT maille_geo_pk PRIMARY KEY (id_maille_geo);


--
-- TOC entry 3269 (class 2606 OID 16601)
-- Name: maille_temps maille_temps_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.maille_temps
    ADD CONSTRAINT maille_temps_pk PRIMARY KEY (id_maille_temps);


--
-- TOC entry 3259 (class 2606 OID 16459)
-- Name: media_donnee media_donnee_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media_donnee
    ADD CONSTRAINT media_donnee_pk PRIMARY KEY (id_media, id_donnee);


--
-- TOC entry 3257 (class 2606 OID 16445)
-- Name: media media_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media
    ADD CONSTRAINT media_pk PRIMARY KEY (id_media);


--
-- TOC entry 3251 (class 2606 OID 16407)
-- Name: polluant polluant_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.polluant
    ADD CONSTRAINT polluant_pk PRIMARY KEY (id_polluant);


--
-- TOC entry 3263 (class 2606 OID 16509)
-- Name: proprietaire_objet proprietaire_objet_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.proprietaire_objet
    ADD CONSTRAINT proprietaire_objet_pk PRIMARY KEY (id_proprietaire_objet);


--
-- TOC entry 3265 (class 2606 OID 16562)
-- Name: publication publication_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.publication
    ADD CONSTRAINT publication_pk PRIMARY KEY (id_publication);


--
-- TOC entry 3255 (class 2606 OID 16436)
-- Name: type_media type_media_pkey; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.type_media
    ADD CONSTRAINT type_media_pkey PRIMARY KEY (id_type_media);


--
-- TOC entry 3270 (class 2606 OID 16616)
-- Name: donnee donnee_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee
    ADD CONSTRAINT donnee_fk FOREIGN KEY (id_maille_temps) REFERENCES si.maille_temps(id_maille_temps);


--
-- TOC entry 3278 (class 2606 OID 16465)
-- Name: media_donnee donnee_fk_1; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media_donnee
    ADD CONSTRAINT donnee_fk_1 FOREIGN KEY (id_donnee) REFERENCES si.donnee(id_donnee);


--
-- TOC entry 3282 (class 2606 OID 16487)
-- Name: donnee_lien donnee_lien_fk_cible; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee_lien
    ADD CONSTRAINT donnee_lien_fk_cible FOREIGN KEY (id_donnee_cible) REFERENCES si.donnee(id_donnee);


--
-- TOC entry 3283 (class 2606 OID 16482)
-- Name: donnee_lien donnee_lien_fk_source; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee_lien
    ADD CONSTRAINT donnee_lien_fk_source FOREIGN KEY (id_donnee_source) REFERENCES si.donnee(id_donnee);


--
-- TOC entry 3271 (class 2606 OID 16578)
-- Name: donnee maille_geo_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee
    ADD CONSTRAINT maille_geo_fk FOREIGN KEY (id_maille_geo) REFERENCES si.maille_geo(id_maille_geo);


--
-- TOC entry 3279 (class 2606 OID 16589)
-- Name: media_donnee maille_geo_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media_donnee
    ADD CONSTRAINT maille_geo_fk FOREIGN KEY (id_maille_geo_diff) REFERENCES si.maille_geo(id_maille_geo);


--
-- TOC entry 3272 (class 2606 OID 16546)
-- Name: donnee maturite_donnee_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee
    ADD CONSTRAINT maturite_donnee_fk FOREIGN KEY (id_maturite) REFERENCES si.etat_maturite(id_etat_maturite);


--
-- TOC entry 3284 (class 2606 OID 16526)
-- Name: publication maturite_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.publication
    ADD CONSTRAINT maturite_fk FOREIGN KEY (id_maturite) REFERENCES si.etat_maturite(id_etat_maturite);


--
-- TOC entry 3275 (class 2606 OID 16536)
-- Name: media maturite_media_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media
    ADD CONSTRAINT maturite_media_fk FOREIGN KEY (id_maturite) REFERENCES si.etat_maturite(id_etat_maturite);


--
-- TOC entry 3280 (class 2606 OID 16611)
-- Name: media_donnee media_donnee_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media_donnee
    ADD CONSTRAINT media_donnee_fk FOREIGN KEY (id_maille_tempo_diff) REFERENCES si.maille_temps(id_maille_temps);


--
-- TOC entry 3281 (class 2606 OID 16460)
-- Name: media_donnee media_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media_donnee
    ADD CONSTRAINT media_fk FOREIGN KEY (id_media) REFERENCES si.media(id_media);


--
-- TOC entry 3286 (class 2606 OID 16556)
-- Name: media_publication media_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media_publication
    ADD CONSTRAINT media_fk FOREIGN KEY (id_media) REFERENCES si.media(id_media);


--
-- TOC entry 3287 (class 2606 OID 16563)
-- Name: media_publication media_publication_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media_publication
    ADD CONSTRAINT media_publication_fk FOREIGN KEY (id_publication) REFERENCES si.publication(id_publication);


--
-- TOC entry 3273 (class 2606 OID 16417)
-- Name: donnee polluant_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee
    ADD CONSTRAINT polluant_fk FOREIGN KEY (id_polluant) REFERENCES si.polluant(id_polluant);


--
-- TOC entry 3274 (class 2606 OID 16541)
-- Name: donnee propriaitaire_donnee_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee
    ADD CONSTRAINT propriaitaire_donnee_fk FOREIGN KEY (id_proprietaire_objet) REFERENCES si.proprietaire_objet(id_proprietaire_objet);


--
-- TOC entry 3276 (class 2606 OID 16531)
-- Name: media proprietaire_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media
    ADD CONSTRAINT proprietaire_fk FOREIGN KEY (id_proprietaire_objet) REFERENCES si.proprietaire_objet(id_proprietaire_objet);


--
-- TOC entry 3285 (class 2606 OID 16521)
-- Name: publication publication_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.publication
    ADD CONSTRAINT publication_fk FOREIGN KEY (id_proprietaire_objet) REFERENCES si.proprietaire_objet(id_proprietaire_objet);


--
-- TOC entry 3277 (class 2606 OID 16470)
-- Name: media type_media_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media
    ADD CONSTRAINT type_media_fk FOREIGN KEY (id_type_media) REFERENCES si.type_media(id_type_media);


-- Completed on 2023-05-23 11:08:43

--
-- PostgreSQL database dump complete
--

