--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2
-- Dumped by pg_dump version 15.2

-- Started on 2023-05-24 17:47:21

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
-- TOC entry 240 (class 1259 OID 16636)
-- Name: application; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.application (
    id_application integer NOT NULL,
    nom_application character varying,
    id_serveur integer DEFAULT 0 NOT NULL
);


ALTER TABLE si.application OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 16635)
-- Name: application_id_application_seq; Type: SEQUENCE; Schema: si; Owner: postgres
--

CREATE SEQUENCE si.application_id_application_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE si.application_id_application_seq OWNER TO postgres;

--
-- TOC entry 3505 (class 0 OID 0)
-- Dependencies: 239
-- Name: application_id_application_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.application_id_application_seq OWNED BY si.application.id_application;


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
    id_application integer DEFAULT 0
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
-- TOC entry 3506 (class 0 OID 0)
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
-- TOC entry 241 (class 1259 OID 16651)
-- Name: donnee_clair; Type: VIEW; Schema: si; Owner: postgres
--

CREATE VIEW si.donnee_clair AS
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
    a.nom_application
   FROM ((((((si.donnee d
     JOIN si.polluant p ON ((p.id_polluant = d.id_polluant)))
     JOIN si.etat_maturite em ON ((em.id_etat_maturite = d.id_maturite)))
     JOIN si.proprietaire_objet po ON ((po.id_proprietaire_objet = d.id_proprietaire_objet)))
     JOIN si.maille_geo mg ON ((mg.id_maille_geo = d.id_maille_geo)))
     JOIN si.maille_temps mt ON ((mt.id_maille_temps = d.id_maille_temps)))
     JOIN si.application a ON ((a.id_application = d.id_application)));


ALTER TABLE si.donnee_clair OWNER TO postgres;

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
-- TOC entry 3507 (class 0 OID 0)
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
-- TOC entry 244 (class 1259 OID 16680)
-- Name: donnee_lien_clair; Type: VIEW; Schema: si; Owner: postgres
--

CREATE VIEW si.donnee_lien_clair AS
 SELECT dc2.libelle_donnee AS donnee_source,
    dc2.type_donnee AS type_source,
    dc.libelle_donnee AS donnee_cible,
    dc.type_donnee AS type_cible,
    dl.id_donnee_source,
    dl.id_donnee_cible
   FROM ((si.donnee_clair dc
     JOIN si.donnee_lien dl ON ((dc.id_donnee = dl.id_donnee_cible)))
     JOIN si.donnee_clair dc2 ON ((dc2.id_donnee = dl.id_donnee_source)));


ALTER TABLE si.donnee_lien_clair OWNER TO postgres;

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
-- TOC entry 3508 (class 0 OID 0)
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
-- TOC entry 222 (class 1259 OID 16429)
-- Name: type_media; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.type_media (
    id_type_media integer NOT NULL,
    libelle_type_media character varying
);


ALTER TABLE si.type_media OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 16667)
-- Name: media_clair; Type: VIEW; Schema: si; Owner: postgres
--

CREATE VIEW si.media_clair AS
 SELECT m.id_media,
    m.titre_media,
    m.url_media,
    tm.libelle_type_media,
    em.libelle_etat_maturite,
    po.libelle_proprietaire_objet
   FROM (((si.media m
     JOIN si.type_media tm ON ((tm.id_type_media = m.id_type_media)))
     JOIN si.etat_maturite em ON ((em.id_etat_maturite = m.id_maturite)))
     JOIN si.proprietaire_objet po ON ((po.id_proprietaire_objet = m.id_proprietaire_objet)));


ALTER TABLE si.media_clair OWNER TO postgres;

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
-- TOC entry 245 (class 1259 OID 16685)
-- Name: media_donnee_clair; Type: VIEW; Schema: si; Owner: postgres
--

CREATE VIEW si.media_donnee_clair AS
 SELECT mc.titre_media,
    dc.libelle_donnee,
    mg.libelle_maille_geo,
    mt.libelle_maille_temps,
    md.profondeur_histo_diff
   FROM ((((si.media_donnee md
     JOIN si.donnee_clair dc ON ((dc.id_donnee = md.id_donnee)))
     JOIN si.media_clair mc ON ((mc.id_media = md.id_media)))
     JOIN si.maille_geo mg ON ((mg.id_maille_geo = md.id_maille_geo_diff)))
     JOIN si.maille_temps mt ON ((mt.id_maille_temps = md.id_maille_tempo_diff)));


ALTER TABLE si.media_donnee_clair OWNER TO postgres;

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
-- TOC entry 3509 (class 0 OID 0)
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
-- TOC entry 243 (class 1259 OID 16676)
-- Name: publication_clair; Type: VIEW; Schema: si; Owner: postgres
--

CREATE VIEW si.publication_clair AS
 SELECT p.id_publication,
    p.libelle_publication,
    em.libelle_etat_maturite,
    po.libelle_proprietaire_objet
   FROM ((si.publication p
     JOIN si.etat_maturite em ON ((em.id_etat_maturite = p.id_maturite)))
     JOIN si.proprietaire_objet po ON ((po.id_proprietaire_objet = p.id_proprietaire_objet)));


ALTER TABLE si.publication_clair OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 16690)
-- Name: media_publication_clair; Type: VIEW; Schema: si; Owner: postgres
--

CREATE VIEW si.media_publication_clair AS
 SELECT pc.libelle_publication,
    mc.titre_media,
    mp.emprise_geo,
    mp.condition_acces
   FROM ((si.media_publication mp
     JOIN si.publication_clair pc ON ((pc.id_publication = mp.id_publication)))
     JOIN si.media_clair mc ON ((mc.id_media = mp.id_publication)));


ALTER TABLE si.media_publication_clair OWNER TO postgres;

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
-- TOC entry 3510 (class 0 OID 0)
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
-- TOC entry 3511 (class 0 OID 0)
-- Dependencies: 229
-- Name: proprietaire_objet_id_proprietaire_objet_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.proprietaire_objet_id_proprietaire_objet_seq OWNED BY si.proprietaire_objet.id_proprietaire_objet;


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
-- TOC entry 3512 (class 0 OID 0)
-- Dependencies: 231
-- Name: publication_id_publication_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.publication_id_publication_seq OWNED BY si.publication.id_publication;


--
-- TOC entry 238 (class 1259 OID 16627)
-- Name: serveur; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.serveur (
    id_serveur integer NOT NULL,
    nom_serveur character varying
);


ALTER TABLE si.serveur OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16626)
-- Name: serveur_id_serveur_seq; Type: SEQUENCE; Schema: si; Owner: postgres
--

CREATE SEQUENCE si.serveur_id_serveur_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE si.serveur_id_serveur_seq OWNER TO postgres;

--
-- TOC entry 3513 (class 0 OID 0)
-- Dependencies: 237
-- Name: serveur_id_serveur_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.serveur_id_serveur_seq OWNED BY si.serveur.id_serveur;


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
-- TOC entry 3514 (class 0 OID 0)
-- Dependencies: 221
-- Name: type_media_code_type_media_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.type_media_code_type_media_seq OWNED BY si.type_media.id_type_media;


--
-- TOC entry 3282 (class 2604 OID 16639)
-- Name: application id_application; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.application ALTER COLUMN id_application SET DEFAULT nextval('si.application_id_application_seq'::regclass);


--
-- TOC entry 3265 (class 2604 OID 16412)
-- Name: donnee id_donnee; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee ALTER COLUMN id_donnee SET DEFAULT nextval('si.donnee_code_donnee_seq'::regclass);


--
-- TOC entry 3276 (class 2604 OID 16496)
-- Name: etat_maturite id_etat_maturite; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.etat_maturite ALTER COLUMN id_etat_maturite SET DEFAULT nextval('si.etat_maturite_code_etat_maturite_seq'::regclass);


--
-- TOC entry 3279 (class 2604 OID 16572)
-- Name: maille_geo id_maille_geo; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.maille_geo ALTER COLUMN id_maille_geo SET DEFAULT nextval('si.maille_geo_id_maille_seq'::regclass);


--
-- TOC entry 3273 (class 2604 OID 16441)
-- Name: media id_media; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media ALTER COLUMN id_media SET DEFAULT nextval('si.media_id_media_seq'::regclass);


--
-- TOC entry 3263 (class 2604 OID 16403)
-- Name: polluant id_polluant; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.polluant ALTER COLUMN id_polluant SET DEFAULT nextval('si.polluant_code_polluant_seq'::regclass);


--
-- TOC entry 3277 (class 2604 OID 16505)
-- Name: proprietaire_objet id_proprietaire_objet; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.proprietaire_objet ALTER COLUMN id_proprietaire_objet SET DEFAULT nextval('si.proprietaire_objet_id_proprietaire_objet_seq'::regclass);


--
-- TOC entry 3278 (class 2604 OID 16518)
-- Name: publication id_publication; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.publication ALTER COLUMN id_publication SET DEFAULT nextval('si.publication_id_publication_seq'::regclass);


--
-- TOC entry 3281 (class 2604 OID 16630)
-- Name: serveur id_serveur; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.serveur ALTER COLUMN id_serveur SET DEFAULT nextval('si.serveur_id_serveur_seq'::regclass);


--
-- TOC entry 3272 (class 2604 OID 16432)
-- Name: type_media id_type_media; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.type_media ALTER COLUMN id_type_media SET DEFAULT nextval('si.type_media_code_type_media_seq'::regclass);


--
-- TOC entry 3499 (class 0 OID 16636)
-- Dependencies: 240
-- Data for Name: application; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.application VALUES (1, 'XR', 0);
INSERT INTO si.application VALUES (2, 'Outil Prévi', 0);
INSERT INTO si.application VALUES (3, 'Outil Inventaire', 0);
INSERT INTO si.application VALUES (4, 'Signal Air', 0);
INSERT INTO si.application VALUES (0, 'Inconnu', 0);


--
-- TOC entry 3479 (class 0 OID 16409)
-- Dependencies: 219
-- Data for Name: donnee; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.donnee VALUES (17, 0, 'Signalement Phenomene Atmosphérique', 'Signalement', 1, 0, 5, 0, 'N', '2022-01-01', 4);
INSERT INTO si.donnee VALUES (10, 1, 'nb jour depassement O3', 'Calcul_agreg', 1, 0, 0, 11, 'N', '1997-01-01', 3);
INSERT INTO si.donnee VALUES (11, 0, 'Indice Atmo', 'Modelisation Previ', 1, 0, 14, 13, 'O', '2021-01-01', 2);
INSERT INTO si.donnee VALUES (12, 5, 'Sous Indice Atmo SO2', 'Modelisation Previ', 1, 1, 14, 13, 'N', '2021-01-01', 2);
INSERT INTO si.donnee VALUES (13, 2, 'Sous Indice Atmo PM2.5', 'Modelisation Previ', 1, 1, 14, 13, 'N', '2021-01-01', 2);
INSERT INTO si.donnee VALUES (14, 3, 'Sous Indice Atmo PM10', 'Modelisation Previ', 1, 1, 14, 13, 'N', '2021-01-01', 2);
INSERT INTO si.donnee VALUES (15, 1, 'Sous Indice Atmo O3', 'Modelisation Previ', 1, 1, 14, 13, 'N', '2021-01-01', 2);
INSERT INTO si.donnee VALUES (16, 4, 'Sous Indice Atmo NO2', 'Modelisation Previ', 1, 1, 14, 13, 'N', '2021-01-01', 2);
INSERT INTO si.donnee VALUES (2, 5, 'mesure 1/4h SO2', 'mesure', 1, 1, 5, 7, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (3, 2, 'mesure 1/4h PM2.5', 'mesure', 1, 1, 5, 7, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (4, 3, 'mesure 1/4h PM10', 'mesure', 1, 1, 5, 7, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (5, 1, 'mesure 1/4h O3', 'mesure', 1, 1, 5, 7, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (1, 4, 'mesure 1/4h NO2', 'mesure', 1, 1, 5, 7, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (6, 1, 'mesure moyenne horaire O3', 'Calcul_agreg', 1, 1, 5, 8, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (7, 1, 'mesure moyenne Journaliere O3', 'Calcul_agreg', 1, 1, 5, 13, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (8, 1, 'mesure moyenne Mensuelle O3', 'Calcul_agreg', 1, 1, 5, 9, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (9, 1, 'mesure moyenne Annuelle O3', 'Calcul_agreg', 1, 1, 5, 11, 'O', '1997-01-01', 1);


--
-- TOC entry 3485 (class 0 OID 16479)
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
-- TOC entry 3487 (class 0 OID 16493)
-- Dependencies: 228
-- Data for Name: etat_maturite; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.etat_maturite VALUES (0, 'Inconnu');
INSERT INTO si.etat_maturite VALUES (1, 'Service Regulier');
INSERT INTO si.etat_maturite VALUES (2, 'A l''étude');


--
-- TOC entry 3494 (class 0 OID 16569)
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
-- TOC entry 3495 (class 0 OID 16594)
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
-- TOC entry 3483 (class 0 OID 16438)
-- Dependencies: 224
-- Data for Name: media; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.media VALUES (1, 'Carte Indice Atmo Jour', NULL, 1, 0, 0);
INSERT INTO si.media VALUES (2, 'Widget Air de ma commune / Indice', 'https://www.atmonormandie.fr/air-commune/SaintLo/50502/indice-atmo?date=2023-05-04', 6, 1, 2);


--
-- TOC entry 3484 (class 0 OID 16453)
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
-- TOC entry 3492 (class 0 OID 16551)
-- Dependencies: 233
-- Data for Name: media_publication; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.media_publication VALUES (2, 1, 'Region', 'public');


--
-- TOC entry 3477 (class 0 OID 16400)
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
-- TOC entry 3489 (class 0 OID 16502)
-- Dependencies: 230
-- Data for Name: proprietaire_objet; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.proprietaire_objet VALUES (0, 'Inconnu');
INSERT INTO si.proprietaire_objet VALUES (1, 'Laboratoire');
INSERT INTO si.proprietaire_objet VALUES (2, 'Service Communication');


--
-- TOC entry 3491 (class 0 OID 16515)
-- Dependencies: 232
-- Data for Name: publication; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.publication VALUES (1, 'Site Atmo Normandie', 1, 2);


--
-- TOC entry 3497 (class 0 OID 16627)
-- Dependencies: 238
-- Data for Name: serveur; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.serveur VALUES (1, 'Serveur XR');
INSERT INTO si.serveur VALUES (2, 'Serveur Inventaire');
INSERT INTO si.serveur VALUES (3, 'Serveur SI');
INSERT INTO si.serveur VALUES (0, 'Inconnu');


--
-- TOC entry 3481 (class 0 OID 16429)
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
-- TOC entry 3515 (class 0 OID 0)
-- Dependencies: 239
-- Name: application_id_application_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.application_id_application_seq', 4, true);


--
-- TOC entry 3516 (class 0 OID 0)
-- Dependencies: 218
-- Name: donnee_code_donnee_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.donnee_code_donnee_seq', 17, true);


--
-- TOC entry 3517 (class 0 OID 0)
-- Dependencies: 227
-- Name: etat_maturite_code_etat_maturite_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.etat_maturite_code_etat_maturite_seq', 1, false);


--
-- TOC entry 3518 (class 0 OID 0)
-- Dependencies: 234
-- Name: maille_geo_id_maille_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.maille_geo_id_maille_seq', 14, true);


--
-- TOC entry 3519 (class 0 OID 0)
-- Dependencies: 223
-- Name: media_id_media_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.media_id_media_seq', 2, true);


--
-- TOC entry 3520 (class 0 OID 0)
-- Dependencies: 216
-- Name: polluant_code_polluant_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.polluant_code_polluant_seq', 37, true);


--
-- TOC entry 3521 (class 0 OID 0)
-- Dependencies: 229
-- Name: proprietaire_objet_id_proprietaire_objet_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.proprietaire_objet_id_proprietaire_objet_seq', 2, true);


--
-- TOC entry 3522 (class 0 OID 0)
-- Dependencies: 231
-- Name: publication_id_publication_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.publication_id_publication_seq', 1, true);


--
-- TOC entry 3523 (class 0 OID 0)
-- Dependencies: 237
-- Name: serveur_id_serveur_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.serveur_id_serveur_seq', 3, true);


--
-- TOC entry 3524 (class 0 OID 0)
-- Dependencies: 221
-- Name: type_media_code_type_media_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.type_media_code_type_media_seq', 6, true);


--
-- TOC entry 3307 (class 2606 OID 16643)
-- Name: application application_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.application
    ADD CONSTRAINT application_pk PRIMARY KEY (id_application);


--
-- TOC entry 3287 (class 2606 OID 16416)
-- Name: donnee donnee_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee
    ADD CONSTRAINT donnee_pk PRIMARY KEY (id_donnee);


--
-- TOC entry 3295 (class 2606 OID 16500)
-- Name: etat_maturite etat_maturite_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.etat_maturite
    ADD CONSTRAINT etat_maturite_pk PRIMARY KEY (id_etat_maturite);


--
-- TOC entry 3301 (class 2606 OID 16576)
-- Name: maille_geo maille_geo_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.maille_geo
    ADD CONSTRAINT maille_geo_pk PRIMARY KEY (id_maille_geo);


--
-- TOC entry 3303 (class 2606 OID 16601)
-- Name: maille_temps maille_temps_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.maille_temps
    ADD CONSTRAINT maille_temps_pk PRIMARY KEY (id_maille_temps);


--
-- TOC entry 3293 (class 2606 OID 16459)
-- Name: media_donnee media_donnee_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media_donnee
    ADD CONSTRAINT media_donnee_pk PRIMARY KEY (id_media, id_donnee);


--
-- TOC entry 3291 (class 2606 OID 16445)
-- Name: media media_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media
    ADD CONSTRAINT media_pk PRIMARY KEY (id_media);


--
-- TOC entry 3285 (class 2606 OID 16407)
-- Name: polluant polluant_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.polluant
    ADD CONSTRAINT polluant_pk PRIMARY KEY (id_polluant);


--
-- TOC entry 3297 (class 2606 OID 16509)
-- Name: proprietaire_objet proprietaire_objet_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.proprietaire_objet
    ADD CONSTRAINT proprietaire_objet_pk PRIMARY KEY (id_proprietaire_objet);


--
-- TOC entry 3299 (class 2606 OID 16562)
-- Name: publication publication_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.publication
    ADD CONSTRAINT publication_pk PRIMARY KEY (id_publication);


--
-- TOC entry 3305 (class 2606 OID 16634)
-- Name: serveur serveur_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.serveur
    ADD CONSTRAINT serveur_pk PRIMARY KEY (id_serveur);


--
-- TOC entry 3289 (class 2606 OID 16436)
-- Name: type_media type_media_pkey; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.type_media
    ADD CONSTRAINT type_media_pkey PRIMARY KEY (id_type_media);


--
-- TOC entry 3308 (class 2606 OID 16646)
-- Name: donnee appli_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee
    ADD CONSTRAINT appli_fk FOREIGN KEY (id_application) REFERENCES si.application(id_application);


--
-- TOC entry 3327 (class 2606 OID 16671)
-- Name: application application_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.application
    ADD CONSTRAINT application_fk FOREIGN KEY (id_serveur) REFERENCES si.serveur(id_serveur);


--
-- TOC entry 3309 (class 2606 OID 16616)
-- Name: donnee donnee_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee
    ADD CONSTRAINT donnee_fk FOREIGN KEY (id_maille_temps) REFERENCES si.maille_temps(id_maille_temps);


--
-- TOC entry 3317 (class 2606 OID 16465)
-- Name: media_donnee donnee_fk_1; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media_donnee
    ADD CONSTRAINT donnee_fk_1 FOREIGN KEY (id_donnee) REFERENCES si.donnee(id_donnee);


--
-- TOC entry 3321 (class 2606 OID 16487)
-- Name: donnee_lien donnee_lien_fk_cible; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee_lien
    ADD CONSTRAINT donnee_lien_fk_cible FOREIGN KEY (id_donnee_cible) REFERENCES si.donnee(id_donnee);


--
-- TOC entry 3322 (class 2606 OID 16482)
-- Name: donnee_lien donnee_lien_fk_source; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee_lien
    ADD CONSTRAINT donnee_lien_fk_source FOREIGN KEY (id_donnee_source) REFERENCES si.donnee(id_donnee);


--
-- TOC entry 3310 (class 2606 OID 16578)
-- Name: donnee maille_geo_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee
    ADD CONSTRAINT maille_geo_fk FOREIGN KEY (id_maille_geo) REFERENCES si.maille_geo(id_maille_geo);


--
-- TOC entry 3318 (class 2606 OID 16589)
-- Name: media_donnee maille_geo_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media_donnee
    ADD CONSTRAINT maille_geo_fk FOREIGN KEY (id_maille_geo_diff) REFERENCES si.maille_geo(id_maille_geo);


--
-- TOC entry 3311 (class 2606 OID 16546)
-- Name: donnee maturite_donnee_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee
    ADD CONSTRAINT maturite_donnee_fk FOREIGN KEY (id_maturite) REFERENCES si.etat_maturite(id_etat_maturite);


--
-- TOC entry 3323 (class 2606 OID 16526)
-- Name: publication maturite_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.publication
    ADD CONSTRAINT maturite_fk FOREIGN KEY (id_maturite) REFERENCES si.etat_maturite(id_etat_maturite);


--
-- TOC entry 3314 (class 2606 OID 16536)
-- Name: media maturite_media_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media
    ADD CONSTRAINT maturite_media_fk FOREIGN KEY (id_maturite) REFERENCES si.etat_maturite(id_etat_maturite);


--
-- TOC entry 3319 (class 2606 OID 16611)
-- Name: media_donnee media_donnee_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media_donnee
    ADD CONSTRAINT media_donnee_fk FOREIGN KEY (id_maille_tempo_diff) REFERENCES si.maille_temps(id_maille_temps);


--
-- TOC entry 3320 (class 2606 OID 16460)
-- Name: media_donnee media_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media_donnee
    ADD CONSTRAINT media_fk FOREIGN KEY (id_media) REFERENCES si.media(id_media);


--
-- TOC entry 3325 (class 2606 OID 16556)
-- Name: media_publication media_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media_publication
    ADD CONSTRAINT media_fk FOREIGN KEY (id_media) REFERENCES si.media(id_media);


--
-- TOC entry 3326 (class 2606 OID 16563)
-- Name: media_publication media_publication_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media_publication
    ADD CONSTRAINT media_publication_fk FOREIGN KEY (id_publication) REFERENCES si.publication(id_publication);


--
-- TOC entry 3312 (class 2606 OID 16417)
-- Name: donnee polluant_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee
    ADD CONSTRAINT polluant_fk FOREIGN KEY (id_polluant) REFERENCES si.polluant(id_polluant);


--
-- TOC entry 3313 (class 2606 OID 16541)
-- Name: donnee propriaitaire_donnee_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee
    ADD CONSTRAINT propriaitaire_donnee_fk FOREIGN KEY (id_proprietaire_objet) REFERENCES si.proprietaire_objet(id_proprietaire_objet);


--
-- TOC entry 3315 (class 2606 OID 16531)
-- Name: media proprietaire_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media
    ADD CONSTRAINT proprietaire_fk FOREIGN KEY (id_proprietaire_objet) REFERENCES si.proprietaire_objet(id_proprietaire_objet);


--
-- TOC entry 3324 (class 2606 OID 16521)
-- Name: publication publication_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.publication
    ADD CONSTRAINT publication_fk FOREIGN KEY (id_proprietaire_objet) REFERENCES si.proprietaire_objet(id_proprietaire_objet);


--
-- TOC entry 3316 (class 2606 OID 16470)
-- Name: media type_media_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media
    ADD CONSTRAINT type_media_fk FOREIGN KEY (id_type_media) REFERENCES si.type_media(id_type_media);


-- Completed on 2023-05-24 17:47:21

--
-- PostgreSQL database dump complete
--

