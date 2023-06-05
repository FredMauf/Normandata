--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2
-- Dumped by pg_dump version 15.2

-- Started on 2023-06-05 14:49:48

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
 

--
-- TOC entry 239 (class 1259 OID 16636)
-- Name: application; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.application (
    id_application integer NOT NULL,
    nom_application character varying,
    id_serveur integer DEFAULT 0 NOT NULL
);


ALTER TABLE si.application OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 16635)
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
-- TOC entry 3502 (class 0 OID 0)
-- Dependencies: 238
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
-- TOC entry 227 (class 1259 OID 16493)
-- Name: etat_maturite; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.etat_maturite (
    id_etat_maturite integer NOT NULL,
    libelle_etat_maturite character varying
);


ALTER TABLE si.etat_maturite OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 16569)
-- Name: maille_geo; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.maille_geo (
    id_maille_geo integer NOT NULL,
    libelle_maille_geo character varying
);


ALTER TABLE si.maille_geo OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16568)
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
-- TOC entry 3503 (class 0 OID 0)
-- Dependencies: 233
-- Name: maille_geo_id_maille_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.maille_geo_id_maille_seq OWNED BY si.maille_geo.id_maille_geo;


--
-- TOC entry 235 (class 1259 OID 16594)
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
-- TOC entry 229 (class 1259 OID 16502)
-- Name: proprietaire_objet; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.proprietaire_objet (
    id_proprietaire_objet integer NOT NULL,
    libelle_proprietaire_objet character varying,
    code_interne_proprietaire character varying
);


ALTER TABLE si.proprietaire_objet OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 16651)
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
-- TOC entry 3504 (class 0 OID 0)
-- Dependencies: 218
-- Name: donnee_code_donnee_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.donnee_code_donnee_seq OWNED BY si.donnee.id_donnee;


--
-- TOC entry 225 (class 1259 OID 16479)
-- Name: donnee_lien; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.donnee_lien (
    id_donnee_source integer NOT NULL,
    id_donnee_cible integer NOT NULL
);


ALTER TABLE si.donnee_lien OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 16680)
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
-- TOC entry 226 (class 1259 OID 16492)
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
-- TOC entry 3505 (class 0 OID 0)
-- Dependencies: 226
-- Name: etat_maturite_code_etat_maturite_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.etat_maturite_code_etat_maturite_seq OWNED BY si.etat_maturite.id_etat_maturite;


--
-- TOC entry 223 (class 1259 OID 16438)
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
-- TOC entry 221 (class 1259 OID 16429)
-- Name: type_media; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.type_media (
    id_type_media integer NOT NULL,
    libelle_type_media character varying
);


ALTER TABLE si.type_media OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 16667)
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
-- TOC entry 224 (class 1259 OID 16453)
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
-- TOC entry 244 (class 1259 OID 16685)
-- Name: media_donnee_clair; Type: VIEW; Schema: si; Owner: postgres
--

CREATE VIEW si.media_donnee_clair AS
 SELECT mc.titre_media,
    dc.libelle_donnee,
    mg.libelle_maille_geo,
    mt.libelle_maille_temps,
    md.profondeur_histo_diff,
    md.id_donnee,
    md.id_media
   FROM ((((si.media_donnee md
     JOIN si.donnee_clair dc ON ((dc.id_donnee = md.id_donnee)))
     JOIN si.media_clair mc ON ((mc.id_media = md.id_media)))
     JOIN si.maille_geo mg ON ((mg.id_maille_geo = md.id_maille_geo_diff)))
     JOIN si.maille_temps mt ON ((mt.id_maille_temps = md.id_maille_tempo_diff)));


ALTER TABLE si.media_donnee_clair OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16437)
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
-- TOC entry 3506 (class 0 OID 0)
-- Dependencies: 222
-- Name: media_id_media_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.media_id_media_seq OWNED BY si.media.id_media;


--
-- TOC entry 232 (class 1259 OID 16551)
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
-- TOC entry 231 (class 1259 OID 16515)
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
-- TOC entry 242 (class 1259 OID 16676)
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
-- TOC entry 245 (class 1259 OID 24886)
-- Name: media_publication_clair; Type: VIEW; Schema: si; Owner: postgres
--

CREATE VIEW si.media_publication_clair AS
 SELECT mp.id_publication,
    mp.id_media,
    pc.libelle_publication,
    mc.titre_media,
    mp.emprise_geo,
    mp.condition_acces
   FROM ((si.media_publication mp
     JOIN si.publication_clair pc ON ((pc.id_publication = mp.id_publication)))
     JOIN si.media_clair mc ON ((mc.id_media = mp.id_media)));


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
-- TOC entry 3507 (class 0 OID 0)
-- Dependencies: 216
-- Name: polluant_code_polluant_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.polluant_code_polluant_seq OWNED BY si.polluant.id_polluant;


--
-- TOC entry 228 (class 1259 OID 16501)
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
-- TOC entry 3508 (class 0 OID 0)
-- Dependencies: 228
-- Name: proprietaire_objet_id_proprietaire_objet_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.proprietaire_objet_id_proprietaire_objet_seq OWNED BY si.proprietaire_objet.id_proprietaire_objet;


--
-- TOC entry 230 (class 1259 OID 16514)
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
-- TOC entry 3509 (class 0 OID 0)
-- Dependencies: 230
-- Name: publication_id_publication_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.publication_id_publication_seq OWNED BY si.publication.id_publication;


--
-- TOC entry 237 (class 1259 OID 16627)
-- Name: serveur; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.serveur (
    id_serveur integer NOT NULL,
    nom_serveur character varying
);


ALTER TABLE si.serveur OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 16626)
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
-- TOC entry 3510 (class 0 OID 0)
-- Dependencies: 236
-- Name: serveur_id_serveur_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.serveur_id_serveur_seq OWNED BY si.serveur.id_serveur;


--
-- TOC entry 220 (class 1259 OID 16428)
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
-- TOC entry 3511 (class 0 OID 0)
-- Dependencies: 220
-- Name: type_media_code_type_media_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.type_media_code_type_media_seq OWNED BY si.type_media.id_type_media;


--
-- TOC entry 3279 (class 2604 OID 16639)
-- Name: application id_application; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.application ALTER COLUMN id_application SET DEFAULT nextval('si.application_id_application_seq'::regclass);


--
-- TOC entry 3262 (class 2604 OID 16412)
-- Name: donnee id_donnee; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee ALTER COLUMN id_donnee SET DEFAULT nextval('si.donnee_code_donnee_seq'::regclass);


--
-- TOC entry 3273 (class 2604 OID 16496)
-- Name: etat_maturite id_etat_maturite; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.etat_maturite ALTER COLUMN id_etat_maturite SET DEFAULT nextval('si.etat_maturite_code_etat_maturite_seq'::regclass);


--
-- TOC entry 3276 (class 2604 OID 16572)
-- Name: maille_geo id_maille_geo; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.maille_geo ALTER COLUMN id_maille_geo SET DEFAULT nextval('si.maille_geo_id_maille_seq'::regclass);


--
-- TOC entry 3270 (class 2604 OID 16441)
-- Name: media id_media; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media ALTER COLUMN id_media SET DEFAULT nextval('si.media_id_media_seq'::regclass);


--
-- TOC entry 3260 (class 2604 OID 16403)
-- Name: polluant id_polluant; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.polluant ALTER COLUMN id_polluant SET DEFAULT nextval('si.polluant_code_polluant_seq'::regclass);


--
-- TOC entry 3274 (class 2604 OID 16505)
-- Name: proprietaire_objet id_proprietaire_objet; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.proprietaire_objet ALTER COLUMN id_proprietaire_objet SET DEFAULT nextval('si.proprietaire_objet_id_proprietaire_objet_seq'::regclass);


--
-- TOC entry 3275 (class 2604 OID 16518)
-- Name: publication id_publication; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.publication ALTER COLUMN id_publication SET DEFAULT nextval('si.publication_id_publication_seq'::regclass);


--
-- TOC entry 3278 (class 2604 OID 16630)
-- Name: serveur id_serveur; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.serveur ALTER COLUMN id_serveur SET DEFAULT nextval('si.serveur_id_serveur_seq'::regclass);


--
-- TOC entry 3269 (class 2604 OID 16432)
-- Name: type_media id_type_media; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.type_media ALTER COLUMN id_type_media SET DEFAULT nextval('si.type_media_code_type_media_seq'::regclass);


--
-- TOC entry 3496 (class 0 OID 16636)
-- Dependencies: 239
-- Data for Name: application; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.application VALUES (1, 'XR', 0);
INSERT INTO si.application VALUES (2, 'Outil Prévi', 0);
INSERT INTO si.application VALUES (3, 'Outil Inventaire', 0);
INSERT INTO si.application VALUES (4, 'Signal Air', 0);
INSERT INTO si.application VALUES (0, 'Inconnu', 0);
INSERT INTO si.application VALUES (5, 'Collecteur API RNSA', 0);
INSERT INTO si.application VALUES (6, 'Saisie Micro Capteurs', 0);


--
-- TOC entry 3476 (class 0 OID 16409)
-- Dependencies: 219
-- Data for Name: donnee; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.donnee VALUES (22, 5, 'Concentration XR moyenne Journaliere SO2', 'Calcul_agreg', 1, 17, 5, 13, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (50, 42, 'Max Journalier  de MH CO ', 'Calcul_agreg', 1, 17, 5, 13, 'N', NULL, 0);
INSERT INTO si.donnee VALUES (51, 42, 'Max journalier de moyenne 8H', 'Calcul_agreg', 1, 17, 5, 13, 'N', NULL, 0);
INSERT INTO si.donnee VALUES (56, 41, 'Concentration XR moyenne Mensuelle C6H6', 'Calcul_agreg', 1, 17, 5, 9, 'N', NULL, 0);
INSERT INTO si.donnee VALUES (7, 1, 'Concentration XR moyenne Journaliere O3', 'Calcul_agreg', 1, 17, 5, 13, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (33, 4, 'Concentration XR moyenne horaire NO2', 'Calcul_agreg', 1, 17, 5, 8, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (35, 4, 'Concentration XR moyenne Mensuelle NO2', 'Calcul_agreg', 1, 17, 5, 9, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (24, 5, 'Concentration XR moyenne Annuelle SO2', 'Calcul_agreg', 1, 17, 5, 11, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (37, 1, 'Concentration Modélisée Expertisée O3', 'Modelisation Expertisée', 1, 1, 14, 13, 'N', '2021-01-01', 2);
INSERT INTO si.donnee VALUES (38, 0, 'Estimation des émissions annuelles totales', 'Emission ', 1, 1, 4, 11, 'O', '2005-01-01', 3);
INSERT INTO si.donnee VALUES (58, 4, 'Nombre de Heure de dépassement 200', 'Calcul_agreg', 1, 17, 5, 11, 'O', '1997-01-01', 0);
INSERT INTO si.donnee VALUES (39, 4, 'Maxjournalier MH NO2', 'Calcul_agreg', 1, 17, 5, 11, 'O', '1997-01-01', 0);
INSERT INTO si.donnee VALUES (41, 4, 'Nombre d''heure de dépassement VL', 'Calcul_agreg', 1, 0, 5, 11, 'O', '1997-01-01', 0);
INSERT INTO si.donnee VALUES (8, 1, 'Concentration XR moyenne Mensuelle O3', 'Calcul_agreg', 1, 17, 5, 9, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (17, 0, 'Signalement Phenomene Atmosphérique', 'Signalement', 1, 0, 5, 0, 'N', '2022-01-01', 4);
INSERT INTO si.donnee VALUES (49, 42, 'Concentration XR moyenne Mensuelle CO', 'Calcul_agreg', 1, 17, 5, 9, 'N', NULL, 0);
INSERT INTO si.donnee VALUES (11, 0, 'Indice Atmo', 'Modelisation Previ', 1, 0, 14, 13, 'O', '2021-01-01', 2);
INSERT INTO si.donnee VALUES (12, 5, 'Sous Indice Atmo SO2', 'Modelisation Previ', 1, 1, 14, 13, 'N', '2021-01-01', 2);
INSERT INTO si.donnee VALUES (13, 2, 'Sous Indice Atmo PM2.5', 'Modelisation Previ', 1, 1, 14, 13, 'N', '2021-01-01', 2);
INSERT INTO si.donnee VALUES (14, 3, 'Sous Indice Atmo PM10', 'Modelisation Previ', 1, 1, 14, 13, 'N', '2021-01-01', 2);
INSERT INTO si.donnee VALUES (15, 1, 'Sous Indice Atmo O3', 'Modelisation Previ', 1, 1, 14, 13, 'N', '2021-01-01', 2);
INSERT INTO si.donnee VALUES (16, 4, 'Sous Indice Atmo NO2', 'Modelisation Previ', 1, 1, 14, 13, 'N', '2021-01-01', 2);
INSERT INTO si.donnee VALUES (9, 1, 'Concentration XR moyenne Annuelle O3', 'Calcul_agreg', 1, 17, 5, 11, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (52, 42, 'Nb Jour Depassement du max 8h 10Mg', 'Calcul_agreg', 1, 17, 5, 0, 'N', NULL, 0);
INSERT INTO si.donnee VALUES (6, 1, 'Concentration XR moyenne horaire O3', 'Calcul_agreg', 1, 17, 5, 8, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (23, 5, 'Concentration XR moyenne Mensuelle SO2', 'Calcul_agreg', 1, 17, 5, 9, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (21, 5, 'Concentration XR moyenne horaire SO2', 'Calcul_agreg', 1, 17, 5, 8, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (26, 2, 'Concentration XR moyenne Journaliere PM2.5', 'Calcul_agreg', 1, 17, 5, 13, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (53, 41, 'Concentration XR moyenne Journaliere C6H6', 'Calcul_agreg', 1, 17, 5, 0, 'N', NULL, 0);
INSERT INTO si.donnee VALUES (3, 2, 'Concentration XR 1/4h PM2.5', 'Mesure Auto', 1, 16, 5, 7, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (18, 38, 'Indice Pollinique RNSA Noisetier', 'Indice', 1, 0, 2, 10, 'N', '2022-06-30', 5);
INSERT INTO si.donnee VALUES (19, 39, 'Indice Pollinique RNSA Ambroisie', 'Indice', 1, 0, 2, 10, 'N', '2022-06-30', 5);
INSERT INTO si.donnee VALUES (20, 40, 'Indice Pollinique RNSA Frene', 'Indice', 1, 0, 2, 10, 'N', '2022-06-30', 5);
INSERT INTO si.donnee VALUES (28, 2, 'Concentration XR moyenne Annuelle PM2.5', 'Calcul_agreg', 1, 17, 5, 11, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (40, 4, 'Nombre de jour dépassement No2 OMS2021 25', 'Calcul_agreg', 1, 17, 5, 11, 'O', '1997-01-01', 0);
INSERT INTO si.donnee VALUES (25, 2, 'Concentration XR moyenne horaire PM2.5', 'Calcul_agreg', 1, 17, 5, 8, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (27, 2, 'Concentration XR moyenne Mensuelle PM2.5', 'Calcul_agreg', 1, 17, 5, 9, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (30, 3, 'Concentration XR moyenne Journaliere  PM10', 'Calcul_agreg', 1, 17, 5, 13, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (32, 3, 'Concentration XR moyenne Annuelle  PM10', 'Calcul_agreg', 1, 17, 5, 11, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (31, 3, 'Concentration XR moyenne Mensuelle  PM10', 'Calcul_agreg', 1, 17, 5, 9, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (54, 41, 'Concentration XR moyenne Annuelle C6H6', 'Calcul_agreg', 1, 17, 5, 0, 'N', NULL, 0);
INSERT INTO si.donnee VALUES (29, 3, 'Concentration XR moyenne horaire PM10', 'Calcul_agreg', 1, 17, 5, 8, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (55, 41, 'Concentration XR moyenne horaire C6H6', 'Calcul_agreg', 1, 17, 5, 0, 'N', NULL, 0);
INSERT INTO si.donnee VALUES (34, 4, 'Concentration XR moyenne Journaliere NO2', 'Calcul_agreg', 1, 17, 5, 13, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (36, 4, 'Concentration XR moyenne Annuelle NO2', 'Calcul_agreg', 1, 17, 5, 11, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (42, NULL, 'Station Atmo Position et nom', 'Paramétre Station', 1, 16, 5, 7, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (5, 1, 'Concentration XR 1/4h O3', 'Mesure Brute Auto', 1, 16, 5, 7, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (4, 3, 'Concentration XR 1/4h PM10', 'Mesure Brute Auto', 1, 16, 5, 7, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (1, 4, 'Concentration XR 1/4h NO2', 'Mesure Brute Auto', 1, 16, 5, 7, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (2, 5, 'Concentration XR 1/4h SO2', 'Mesure Brute Auto', 1, 16, 5, 7, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (43, NULL, 'Donnée Meteo en Station', 'Mesure Brute Auto', 1, 16, 5, 7, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (45, 42, 'Concentration XR 1/4h CO', 'Mesure Brute Auto', 1, 16, 5, 7, 'N', NULL, 0);
INSERT INTO si.donnee VALUES (47, 42, 'Concentration XR moyenne Annuelle CO', 'Calcul_agreg', 1, 17, 5, 11, 'N', NULL, 0);
INSERT INTO si.donnee VALUES (48, 42, 'Concentration XR moyenne horaire CO', 'Calcul_agreg', 1, 17, 5, 13, 'N', NULL, 0);
INSERT INTO si.donnee VALUES (63, 43, 'Max Journalier MH NOx', 'Calcul_agreg', 1, 17, 0, 13, 'N', NULL, 0);
INSERT INTO si.donnee VALUES (59, 4, 'Nombre de 3Heure de dépassement 400', 'Calcul_agreg', 1, 17, 5, 11, 'O', '1997-01-01', 0);
INSERT INTO si.donnee VALUES (60, 43, 'Concentration XR moyenne Journaliere NOx', 'Calcul_agreg', 1, 17, 5, 13, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (61, 43, 'Concentration XR 1/4h NOx', 'Mesure Auto', 1, 16, 5, 7, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (62, 43, 'Concentration XR moyenne horaire NOx', 'Calcul_agreg', 1, 17, 5, 8, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (64, 43, 'Concentration XR moyenne Mensuelle NOx', 'Calcul_agreg', 1, 17, 5, 9, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (65, 43, 'Concentration XR moyenne Journaliere NOx', 'Calcul_agreg', 1, 17, 5, 13, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (57, 41, 'Max Journalier  de MH C6H6', 'Calcul_agreg', 1, 17, 5, 13, 'N', NULL, 0);
INSERT INTO si.donnee VALUES (46, 42, 'Concentration XR moyenne Journaliere CO', 'Calcul_agreg', 1, 17, 5, 13, 'N', NULL, 0);
INSERT INTO si.donnee VALUES (66, 1, 'Max Jour de la M8H O3', 'Calcul_agreg', 1, 0, 0, 13, 'N', '1997-01-01', 3);
INSERT INTO si.donnee VALUES (67, 1, 'AOT40 O3 végétation (obj qualité végétation)', 'Calcul_agreg', 1, 0, 0, 11, 'N', '1997-01-01', 3);
INSERT INTO si.donnee VALUES (68, 1, 'AOT40 - 5 Ans O3 végétation', 'Calcul_agreg', 1, 0, 0, 11, 'N', '1997-01-01', 3);
INSERT INTO si.donnee VALUES (69, 1, 'Nb Dépassement MH 180', 'Calcul_agreg', 1, 0, 0, 11, 'N', '1997-01-01', 3);
INSERT INTO si.donnee VALUES (70, 1, 'Nb Dépassement 3h 240', 'Calcul_agreg', 1, 0, 0, 11, 'N', '1997-01-01', 3);
INSERT INTO si.donnee VALUES (71, 1, 'Nb Dépassement Moy8h 120', 'Calcul_agreg', 1, 0, 0, 11, 'N', '1997-01-01', 3);
INSERT INTO si.donnee VALUES (73, 1, 'Pic Saisonnier 6mois OMS 60', 'Calcul_agreg', 1, 0, 0, 11, 'N', '1997-01-01', 3);
INSERT INTO si.donnee VALUES (72, 1, 'Nb Jour Dépassement Moy8h 100 OMS', 'Calcul_agreg', 1, 0, 0, 11, 'N', '1997-01-01', 3);
INSERT INTO si.donnee VALUES (80, 3, 'Max Journalier MH PM10', 'Calcul_agreg', 1, 17, 5, 8, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (81, 3, 'Depassement Seuil MA 40 PM10 ', 'Calcul_agreg', 1, 17, 5, 8, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (86, 45, 'Moyenne Annuelle AS Particulaire', 'Calcul_agreg', 1, 17, 5, 11, 'N', NULL, 1);
INSERT INTO si.donnee VALUES (87, 46, 'Moyenne Annuelle CD Particulaire', 'Calcul_agreg', 1, 17, 5, 11, 'N', NULL, 1);
INSERT INTO si.donnee VALUES (88, 47, 'Moyenne Annuelle NI Particulaire', 'Calcul_agreg', 1, 17, 5, 11, 'N', NULL, 1);
INSERT INTO si.donnee VALUES (89, 48, 'Moyenne Annuelle PB Particulaire', 'Calcul_agreg', 1, 17, 5, 11, 'N', NULL, 1);
INSERT INTO si.donnee VALUES (90, 49, 'Moyenne Annuelle BAP Particulaire', 'Calcul_agreg', 1, 17, 5, 11, 'N', NULL, 1);
INSERT INTO si.donnee VALUES (91, 45, 'Moyenne Demi-Horaire AS Particulaire', 'Mesure Brute Auto', 1, 17, 5, 15, 'N', NULL, 1);
INSERT INTO si.donnee VALUES (92, 46, 'Moyenne Demi-HoraireCD Particulaire', 'Mesure Brute Auto', 1, 17, 5, 15, 'N', NULL, 1);
INSERT INTO si.donnee VALUES (93, 47, 'Moyenne Demi-HoraireNI Particulaire', 'Mesure Brute Auto', 1, 17, 5, 15, 'N', NULL, 1);
INSERT INTO si.donnee VALUES (94, 48, 'Moyenne Demi-HorairePB Particulaire', 'Mesure Brute Auto', 1, 17, 5, 15, 'N', NULL, 1);
INSERT INTO si.donnee VALUES (95, 49, 'Moyenne Demi-HoraireBAP Particulaire', 'Mesure Brute Auto', 1, 17, 5, 15, 'N', NULL, 1);
INSERT INTO si.donnee VALUES (10, 1, 'Max Jour de la MH O3', 'Calcul_agreg', 1, 0, 0, 13, 'N', '1997-01-01', 3);
INSERT INTO si.donnee VALUES (74, 5, 'Max Journalier de la MH SO2', 'Calcul_agreg', 1, 17, 5, 13, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (75, 5, 'Moyenne Hivernale de la MH SO2', 'Calcul_agreg', 1, 17, 5, 11, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (76, 5, 'Nb Dépassement MJ 125', 'Calcul_agreg', 1, 17, 5, 13, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (77, 5, 'Nb Dépassement MH 350', 'Calcul_agreg', 1, 17, 5, 13, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (78, 5, 'Nb Dépassement 3fois MH 500', 'Calcul_agreg', 1, 17, 5, 13, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (79, 5, 'Nb Jour dépassement sup 40µ OMS', 'Calcul_agreg', 1, 17, 5, 11, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (82, 3, 'Nb Dep Moyenne Jour 50', 'Calcul_agreg', 1, 17, 5, 13, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (83, 2, 'Depassement Seuil MA 20  PM2.5', 'Calcul_agreg', 1, 17, 5, 13, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (84, 2, 'Depassement Seuil MA 25 PM2.5', 'Calcul_agreg', 1, 17, 5, 13, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (85, 2, 'Max Journalier MH PM2.5', 'Calcul_agreg', 1, 17, 5, 13, 'O', '1997-01-01', 1);


--
-- TOC entry 3482 (class 0 OID 16479)
-- Dependencies: 225
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
INSERT INTO si.donnee_lien VALUES (1, 33);
INSERT INTO si.donnee_lien VALUES (3, 25);
INSERT INTO si.donnee_lien VALUES (4, 29);
INSERT INTO si.donnee_lien VALUES (2, 21);
INSERT INTO si.donnee_lien VALUES (33, 34);
INSERT INTO si.donnee_lien VALUES (33, 35);
INSERT INTO si.donnee_lien VALUES (33, 36);
INSERT INTO si.donnee_lien VALUES (25, 26);
INSERT INTO si.donnee_lien VALUES (25, 27);
INSERT INTO si.donnee_lien VALUES (25, 28);
INSERT INTO si.donnee_lien VALUES (21, 22);
INSERT INTO si.donnee_lien VALUES (21, 23);
INSERT INTO si.donnee_lien VALUES (21, 24);
INSERT INTO si.donnee_lien VALUES (29, 30);
INSERT INTO si.donnee_lien VALUES (29, 31);
INSERT INTO si.donnee_lien VALUES (29, 32);
INSERT INTO si.donnee_lien VALUES (37, 15);
INSERT INTO si.donnee_lien VALUES (7, 40);
INSERT INTO si.donnee_lien VALUES (33, 41);
INSERT INTO si.donnee_lien VALUES (33, 39);
INSERT INTO si.donnee_lien VALUES (34, 40);
INSERT INTO si.donnee_lien VALUES (61, 62);
INSERT INTO si.donnee_lien VALUES (62, 60);
INSERT INTO si.donnee_lien VALUES (62, 63);
INSERT INTO si.donnee_lien VALUES (62, 65);
INSERT INTO si.donnee_lien VALUES (62, 64);
INSERT INTO si.donnee_lien VALUES (62, 59);
INSERT INTO si.donnee_lien VALUES (95, 90);
INSERT INTO si.donnee_lien VALUES (55, 53);
INSERT INTO si.donnee_lien VALUES (55, 54);
INSERT INTO si.donnee_lien VALUES (55, 56);
INSERT INTO si.donnee_lien VALUES (55, 57);
INSERT INTO si.donnee_lien VALUES (45, 48);
INSERT INTO si.donnee_lien VALUES (48, 49);
INSERT INTO si.donnee_lien VALUES (48, 50);
INSERT INTO si.donnee_lien VALUES (48, 51);
INSERT INTO si.donnee_lien VALUES (48, 52);
INSERT INTO si.donnee_lien VALUES (48, 46);
INSERT INTO si.donnee_lien VALUES (48, 47);
INSERT INTO si.donnee_lien VALUES (91, 86);
INSERT INTO si.donnee_lien VALUES (92, 87);
INSERT INTO si.donnee_lien VALUES (93, 88);
INSERT INTO si.donnee_lien VALUES (94, 89);
INSERT INTO si.donnee_lien VALUES (33, 58);
INSERT INTO si.donnee_lien VALUES (6, 66);
INSERT INTO si.donnee_lien VALUES (6, 67);
INSERT INTO si.donnee_lien VALUES (6, 68);
INSERT INTO si.donnee_lien VALUES (6, 10);
INSERT INTO si.donnee_lien VALUES (6, 69);
INSERT INTO si.donnee_lien VALUES (6, 70);
INSERT INTO si.donnee_lien VALUES (6, 71);
INSERT INTO si.donnee_lien VALUES (6, 73);
INSERT INTO si.donnee_lien VALUES (25, 83);
INSERT INTO si.donnee_lien VALUES (25, 84);
INSERT INTO si.donnee_lien VALUES (25, 85);
INSERT INTO si.donnee_lien VALUES (6, 72);
INSERT INTO si.donnee_lien VALUES (29, 80);
INSERT INTO si.donnee_lien VALUES (29, 81);
INSERT INTO si.donnee_lien VALUES (29, 82);
INSERT INTO si.donnee_lien VALUES (21, 79);
INSERT INTO si.donnee_lien VALUES (21, 74);
INSERT INTO si.donnee_lien VALUES (21, 75);
INSERT INTO si.donnee_lien VALUES (21, 76);
INSERT INTO si.donnee_lien VALUES (21, 77);
INSERT INTO si.donnee_lien VALUES (21, 78);


--
-- TOC entry 3484 (class 0 OID 16493)
-- Dependencies: 227
-- Data for Name: etat_maturite; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.etat_maturite VALUES (0, 'Inconnu');
INSERT INTO si.etat_maturite VALUES (1, 'Service Regulier');
INSERT INTO si.etat_maturite VALUES (2, 'A l''étude');


--
-- TOC entry 3491 (class 0 OID 16569)
-- Dependencies: 234
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
-- TOC entry 3492 (class 0 OID 16594)
-- Dependencies: 235
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
INSERT INTO si.maille_temps VALUES (15, 'Demi-Heure');


--
-- TOC entry 3480 (class 0 OID 16438)
-- Dependencies: 223
-- Data for Name: media; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.media VALUES (2, 'Widget Air de ma commune / Indice', 'https://www.atmonormandie.fr/air-commune/SaintLo/50502/indice-atmo?date=2023-05-04', 6, 1, 3);
INSERT INTO si.media VALUES (3, 'Widget Air de ma commune / Pollen', NULL, 6, 1, 3);
INSERT INTO si.media VALUES (4, 'Flux WFS 1 an Indice Atmo', NULL, 5, 1, 3);
INSERT INTO si.media VALUES (5, 'Flux WFS 3 Jours Indice Atmo', 'https://api.atmonormandie.fr/index.php/view/map/?repository=dindice&project=historique_indice_atmo', 5, 1, 3);
INSERT INTO si.media VALUES (1, 'Carte Indice Atmo Jour', NULL, 1, 0, 3);
INSERT INTO si.media VALUES (6, 'Open Data Emission Région', 'https://api.atmonormandie.fr/index.php/view/map/?repository=emissions&project=emi_normandie_dpt', 5, 1, 3);
INSERT INTO si.media VALUES (7, 'Open Data Emission Département', 'https://api.atmonormandie.fr/index.php/view/map/?repository=emissions&project=emi_normandie_dpt', 5, 1, 3);
INSERT INTO si.media VALUES (8, 'Open Data Emission Epci', 'https://api.atmonormandie.fr/index.php/view/map/?repository=emissions&project=emi_normandie_dpt', 5, 1, 3);
INSERT INTO si.media VALUES (12, 'DataViz moyenne horaire maximale', 'https://www.atmonormandie.fr/dataviz/statistiques-annuelles?polluant_id=03&departement_id=&annee=2022', 6, 1, 3);
INSERT INTO si.media VALUES (9, 'DataViz Moyennes Annuelles No2', 'https://www.atmonormandie.fr/dataviz/statistiques-annuelles?polluant_id=03&departement_id=&annee=2022', 6, 1, 3);
INSERT INTO si.media VALUES (10, 'DataViz nombre d''heure de dépassement No2', 'https://www.atmonormandie.fr/dataviz/statistiques-annuelles?polluant_id=03&departement_id=&annee=2022', 6, 1, 3);
INSERT INTO si.media VALUES (11, 'DataViz Nombre de jour de dépassement No2 OMS2021', 'https://www.atmonormandie.fr/dataviz/statistiques-annuelles?polluant_id=03&departement_id=&annee=2022', 6, 1, 3);
INSERT INTO si.media VALUES (13, 'Fichier Geod''air', NULL, 3, 1, 16);
INSERT INTO si.media VALUES (14, 'Site Geodair', 'https://www.geodair.fr/donnees/consultation', 5, 1, 1);


--
-- TOC entry 3481 (class 0 OID 16453)
-- Dependencies: 224
-- Data for Name: media_donnee; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.media_donnee VALUES (2, 11, 4, 13, 'J');
INSERT INTO si.media_donnee VALUES (2, 12, 4, 13, 'J');
INSERT INTO si.media_donnee VALUES (2, 13, 4, 13, 'J');
INSERT INTO si.media_donnee VALUES (2, 14, 4, 13, 'J');
INSERT INTO si.media_donnee VALUES (2, 15, 4, 13, 'J');
INSERT INTO si.media_donnee VALUES (2, 16, 4, 13, 'J');
INSERT INTO si.media_donnee VALUES (3, 18, 2, 10, 'J');
INSERT INTO si.media_donnee VALUES (3, 19, 2, 10, 'J');
INSERT INTO si.media_donnee VALUES (3, 20, 2, 10, 'J');
INSERT INTO si.media_donnee VALUES (1, 11, 14, 13, 'J');
INSERT INTO si.media_donnee VALUES (4, 11, 4, 13, '3j');
INSERT INTO si.media_donnee VALUES (5, 11, 4, 13, '1 An');
INSERT INTO si.media_donnee VALUES (6, 38, 1, 11, '2005');
INSERT INTO si.media_donnee VALUES (7, 38, 2, 11, '2005');
INSERT INTO si.media_donnee VALUES (8, 38, 3, 11, '2005');
INSERT INTO si.media_donnee VALUES (10, 39, 5, 11, 'Année N-1');
INSERT INTO si.media_donnee VALUES (11, 40, 5, 11, 'Année N-1');
INSERT INTO si.media_donnee VALUES (12, 41, 5, 11, 'Année N-1');
INSERT INTO si.media_donnee VALUES (13, 1, 5, 8, 'J');
INSERT INTO si.media_donnee VALUES (13, 2, 5, 8, 'J');
INSERT INTO si.media_donnee VALUES (13, 3, 5, 8, 'J');
INSERT INTO si.media_donnee VALUES (13, 4, 5, 8, 'J');
INSERT INTO si.media_donnee VALUES (13, 5, 5, 8, 'J');
INSERT INTO si.media_donnee VALUES (13, 91, 5, 15, 'J');
INSERT INTO si.media_donnee VALUES (13, 92, 5, 15, 'J');
INSERT INTO si.media_donnee VALUES (13, 93, 5, 15, 'J');
INSERT INTO si.media_donnee VALUES (13, 94, 5, 15, 'J');
INSERT INTO si.media_donnee VALUES (13, 95, 5, 15, 'J');
INSERT INTO si.media_donnee VALUES (13, 45, 5, 8, 'J');
INSERT INTO si.media_donnee VALUES (13, 55, 5, 8, 'J');
INSERT INTO si.media_donnee VALUES (13, 61, 5, 8, 'J');
INSERT INTO si.media_donnee VALUES (14, 6, 5, 8, 'J');
INSERT INTO si.media_donnee VALUES (14, 33, 5, 8, 'J');
INSERT INTO si.media_donnee VALUES (14, 25, 5, 8, 'J');
INSERT INTO si.media_donnee VALUES (14, 29, 5, 8, 'J');
INSERT INTO si.media_donnee VALUES (14, 21, 5, 8, 'J');
INSERT INTO si.media_donnee VALUES (14, 62, 5, 8, 'J');
INSERT INTO si.media_donnee VALUES (14, 90, 5, 11, 'J');
INSERT INTO si.media_donnee VALUES (14, 53, 5, 0, 'J');
INSERT INTO si.media_donnee VALUES (14, 54, 5, 0, 'J');
INSERT INTO si.media_donnee VALUES (14, 56, 5, 9, 'J');
INSERT INTO si.media_donnee VALUES (14, 57, 5, 13, 'J');
INSERT INTO si.media_donnee VALUES (14, 48, 5, 13, 'J');
INSERT INTO si.media_donnee VALUES (14, 86, 5, 11, 'J');
INSERT INTO si.media_donnee VALUES (14, 87, 5, 11, 'J');
INSERT INTO si.media_donnee VALUES (14, 88, 5, 11, 'J');
INSERT INTO si.media_donnee VALUES (14, 89, 5, 11, 'J');
INSERT INTO si.media_donnee VALUES (14, 7, 5, 13, 'J');
INSERT INTO si.media_donnee VALUES (14, 8, 5, 9, 'J');
INSERT INTO si.media_donnee VALUES (14, 9, 5, 11, 'J');
INSERT INTO si.media_donnee VALUES (14, 34, 5, 13, 'J');
INSERT INTO si.media_donnee VALUES (14, 35, 5, 9, 'J');
INSERT INTO si.media_donnee VALUES (14, 36, 5, 11, 'J');
INSERT INTO si.media_donnee VALUES (14, 26, 5, 13, 'J');
INSERT INTO si.media_donnee VALUES (14, 27, 5, 9, 'J');
INSERT INTO si.media_donnee VALUES (14, 28, 5, 11, 'J');
INSERT INTO si.media_donnee VALUES (14, 22, 5, 13, 'J');
INSERT INTO si.media_donnee VALUES (14, 23, 5, 9, 'J');
INSERT INTO si.media_donnee VALUES (14, 24, 5, 11, 'J');
INSERT INTO si.media_donnee VALUES (14, 30, 5, 13, 'J');
INSERT INTO si.media_donnee VALUES (14, 31, 5, 9, 'J');
INSERT INTO si.media_donnee VALUES (14, 32, 5, 11, 'J');
INSERT INTO si.media_donnee VALUES (14, 41, 5, 11, 'J');
INSERT INTO si.media_donnee VALUES (14, 39, 5, 11, 'J');
INSERT INTO si.media_donnee VALUES (14, 60, 5, 13, 'J');
INSERT INTO si.media_donnee VALUES (14, 63, 5, 13, 'J');
INSERT INTO si.media_donnee VALUES (14, 65, 5, 13, 'J');
INSERT INTO si.media_donnee VALUES (14, 64, 5, 9, 'J');
INSERT INTO si.media_donnee VALUES (14, 59, 5, 11, 'J');
INSERT INTO si.media_donnee VALUES (14, 49, 5, 9, 'J');
INSERT INTO si.media_donnee VALUES (14, 50, 5, 13, 'J');
INSERT INTO si.media_donnee VALUES (14, 51, 5, 13, 'J');
INSERT INTO si.media_donnee VALUES (14, 52, 5, 0, 'J');
INSERT INTO si.media_donnee VALUES (14, 46, 5, 13, 'J');
INSERT INTO si.media_donnee VALUES (14, 47, 5, 11, 'J');
INSERT INTO si.media_donnee VALUES (14, 58, 5, 11, 'J');
INSERT INTO si.media_donnee VALUES (14, 66, 5, 13, 'J');
INSERT INTO si.media_donnee VALUES (14, 67, 5, 11, 'J');
INSERT INTO si.media_donnee VALUES (14, 68, 5, 11, 'J');
INSERT INTO si.media_donnee VALUES (14, 10, 5, 13, 'J');
INSERT INTO si.media_donnee VALUES (14, 69, 5, 11, 'J');
INSERT INTO si.media_donnee VALUES (14, 70, 5, 11, 'J');
INSERT INTO si.media_donnee VALUES (14, 71, 5, 11, 'J');
INSERT INTO si.media_donnee VALUES (14, 73, 5, 11, 'J');
INSERT INTO si.media_donnee VALUES (14, 83, 5, 13, 'J');
INSERT INTO si.media_donnee VALUES (14, 84, 5, 13, 'J');
INSERT INTO si.media_donnee VALUES (14, 85, 5, 13, 'J');
INSERT INTO si.media_donnee VALUES (14, 72, 5, 11, 'J');
INSERT INTO si.media_donnee VALUES (14, 80, 5, 8, 'J');
INSERT INTO si.media_donnee VALUES (14, 81, 5, 8, 'J');
INSERT INTO si.media_donnee VALUES (14, 82, 5, 13, 'J');
INSERT INTO si.media_donnee VALUES (14, 79, 5, 11, 'J');
INSERT INTO si.media_donnee VALUES (14, 74, 5, 13, 'J');
INSERT INTO si.media_donnee VALUES (14, 75, 5, 11, 'J');
INSERT INTO si.media_donnee VALUES (14, 76, 5, 13, 'J');
INSERT INTO si.media_donnee VALUES (14, 77, 5, 13, 'J');
INSERT INTO si.media_donnee VALUES (14, 78, 5, 13, 'J');


--
-- TOC entry 3489 (class 0 OID 16551)
-- Dependencies: 232
-- Data for Name: media_publication; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.media_publication VALUES (2, 1, 'Region', 'public');
INSERT INTO si.media_publication VALUES (3, 1, 'Region', 'public');
INSERT INTO si.media_publication VALUES (4, 2, 'Region', 'public');
INSERT INTO si.media_publication VALUES (4, 2, 'Region', 'public');
INSERT INTO si.media_publication VALUES (6, 2, 'Region', 'public');
INSERT INTO si.media_publication VALUES (7, 2, 'Region', 'public');
INSERT INTO si.media_publication VALUES (8, 2, 'Region', 'public');
INSERT INTO si.media_publication VALUES (14, 3, 'National', 'public');


--
-- TOC entry 3474 (class 0 OID 16400)
-- Dependencies: 217
-- Data for Name: polluant; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.polluant VALUES (0, 'Aucun/Multi', NULL, '2023-05-15');
INSERT INTO si.polluant VALUES (38, 'Pollen Noisetier', NULL, '2023-05-25');
INSERT INTO si.polluant VALUES (39, 'Pollen Ambroisie', NULL, '2023-05-25');
INSERT INTO si.polluant VALUES (40, 'Pollen  Frene', NULL, '2023-05-25');
INSERT INTO si.polluant VALUES (8, 'MethaneCH4 ', ' CD5 ', '2023-04-27');
INSERT INTO si.polluant VALUES (1, 'Ozone', '08', '2025-02-04');
INSERT INTO si.polluant VALUES (2, 'PM2.5', '39', '2025-02-04');
INSERT INTO si.polluant VALUES (3, 'PM10', '24', '2025-02-04');
INSERT INTO si.polluant VALUES (4, 'NO2', '03', '2025-02-04');
INSERT INTO si.polluant VALUES (5, 'SO2', '01', '2025-02-04');
INSERT INTO si.polluant VALUES (43, 'NOx', '12', '2023-04-27');
INSERT INTO si.polluant VALUES (44, 'NO', '02', '2023-04-27');
INSERT INTO si.polluant VALUES (49, 'BaP dans PM10', 'P6', '2023-04-27');
INSERT INTO si.polluant VALUES (41, 'C6H6 Benzene', 'V4', '2023-04-27');
INSERT INTO si.polluant VALUES (42, 'CO Monoxyde Carbone', '04', '2023-04-27');
INSERT INTO si.polluant VALUES (45, 'As dans PM10', '80', '2023-04-27');
INSERT INTO si.polluant VALUES (46, 'Cd dans PM10', '82', '2023-04-27');
INSERT INTO si.polluant VALUES (47, 'Ni dans PM10', '87', '2023-04-27');
INSERT INTO si.polluant VALUES (48, 'Pb dans PM10', '19', '2023-04-27');


--
-- TOC entry 3486 (class 0 OID 16502)
-- Dependencies: 229
-- Data for Name: proprietaire_objet; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.proprietaire_objet VALUES (0, 'Inconnu', NULL);
INSERT INTO si.proprietaire_objet VALUES (3, 'Communiquer pour Atmo Normandie
', 'COM');
INSERT INTO si.proprietaire_objet VALUES (4, 'Emissions', 'EMI');
INSERT INTO si.proprietaire_objet VALUES (5, 'Processus financier', 'FIN');
INSERT INTO si.proprietaire_objet VALUES (6, 'Intendance', 'INT');
INSERT INTO si.proprietaire_objet VALUES (7, 'Informatique et systèmes d''information', 'ISI');
INSERT INTO si.proprietaire_objet VALUES (8, 'Laboratoire', 'LAB');
INSERT INTO si.proprietaire_objet VALUES (9, 'Modélisation', 'MOD');
INSERT INTO si.proprietaire_objet VALUES (10, 'Pilotage', 'PIL');
INSERT INTO si.proprietaire_objet VALUES (11, 'Prévision', 'PRE');
INSERT INTO si.proprietaire_objet VALUES (12, 'Manager par les processus et l''amélioration continue', 'QUA');
INSERT INTO si.proprietaire_objet VALUES (13, 'Gestion des ressources humaines', 'RHU');
INSERT INTO si.proprietaire_objet VALUES (14, 'Conformité de la surveillance', 'SUR');
INSERT INTO si.proprietaire_objet VALUES (16, 'Processus Technique', 'TEC');
INSERT INTO si.proprietaire_objet VALUES (17, 'Validation', 'VAL');
INSERT INTO si.proprietaire_objet VALUES (18, 'Mise en oeuvre des activités et partenariats', 'VRP');
INSERT INTO si.proprietaire_objet VALUES (1, 'A DISTPACHER', NULL);
INSERT INTO si.proprietaire_objet VALUES (19, 'Exterieur GEODAIR', NULL);


--
-- TOC entry 3488 (class 0 OID 16515)
-- Dependencies: 231
-- Data for Name: publication; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.publication VALUES (1, 'Site Atmo Normandie', 1, 3);
INSERT INTO si.publication VALUES (2, 'Open Data', 1, 3);
INSERT INTO si.publication VALUES (3, 'Site Geodair', 1, 19);


--
-- TOC entry 3494 (class 0 OID 16627)
-- Dependencies: 237
-- Data for Name: serveur; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.serveur VALUES (1, 'Serveur XR');
INSERT INTO si.serveur VALUES (2, 'Serveur Inventaire');
INSERT INTO si.serveur VALUES (3, 'Serveur SI');
INSERT INTO si.serveur VALUES (0, 'Inconnu');


--
-- TOC entry 3478 (class 0 OID 16429)
-- Dependencies: 221
-- Data for Name: type_media; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.type_media VALUES (1, 'Carte Dynamique');
INSERT INTO si.type_media VALUES (2, 'Carte Statique');
INSERT INTO si.type_media VALUES (3, 'Fichier Excel');
INSERT INTO si.type_media VALUES (4, 'Flux API');
INSERT INTO si.type_media VALUES (5, 'Flux Carto');
INSERT INTO si.type_media VALUES (6, 'DataViz');


--
-- TOC entry 3512 (class 0 OID 0)
-- Dependencies: 238
-- Name: application_id_application_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.application_id_application_seq', 6, true);


--
-- TOC entry 3513 (class 0 OID 0)
-- Dependencies: 218
-- Name: donnee_code_donnee_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.donnee_code_donnee_seq', 95, true);


--
-- TOC entry 3514 (class 0 OID 0)
-- Dependencies: 226
-- Name: etat_maturite_code_etat_maturite_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.etat_maturite_code_etat_maturite_seq', 1, false);


--
-- TOC entry 3515 (class 0 OID 0)
-- Dependencies: 233
-- Name: maille_geo_id_maille_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.maille_geo_id_maille_seq', 15, true);


--
-- TOC entry 3516 (class 0 OID 0)
-- Dependencies: 222
-- Name: media_id_media_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.media_id_media_seq', 14, true);


--
-- TOC entry 3517 (class 0 OID 0)
-- Dependencies: 216
-- Name: polluant_code_polluant_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.polluant_code_polluant_seq', 49, true);


--
-- TOC entry 3518 (class 0 OID 0)
-- Dependencies: 228
-- Name: proprietaire_objet_id_proprietaire_objet_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.proprietaire_objet_id_proprietaire_objet_seq', 19, true);


--
-- TOC entry 3519 (class 0 OID 0)
-- Dependencies: 230
-- Name: publication_id_publication_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.publication_id_publication_seq', 3, true);


--
-- TOC entry 3520 (class 0 OID 0)
-- Dependencies: 236
-- Name: serveur_id_serveur_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.serveur_id_serveur_seq', 3, true);


--
-- TOC entry 3521 (class 0 OID 0)
-- Dependencies: 220
-- Name: type_media_code_type_media_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.type_media_code_type_media_seq', 6, true);


--
-- TOC entry 3304 (class 2606 OID 16643)
-- Name: application application_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.application
    ADD CONSTRAINT application_pk PRIMARY KEY (id_application);


--
-- TOC entry 3284 (class 2606 OID 16416)
-- Name: donnee donnee_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee
    ADD CONSTRAINT donnee_pk PRIMARY KEY (id_donnee);


--
-- TOC entry 3292 (class 2606 OID 16500)
-- Name: etat_maturite etat_maturite_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.etat_maturite
    ADD CONSTRAINT etat_maturite_pk PRIMARY KEY (id_etat_maturite);


--
-- TOC entry 3298 (class 2606 OID 16576)
-- Name: maille_geo maille_geo_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.maille_geo
    ADD CONSTRAINT maille_geo_pk PRIMARY KEY (id_maille_geo);


--
-- TOC entry 3300 (class 2606 OID 16601)
-- Name: maille_temps maille_temps_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.maille_temps
    ADD CONSTRAINT maille_temps_pk PRIMARY KEY (id_maille_temps);


--
-- TOC entry 3290 (class 2606 OID 16459)
-- Name: media_donnee media_donnee_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media_donnee
    ADD CONSTRAINT media_donnee_pk PRIMARY KEY (id_media, id_donnee);


--
-- TOC entry 3288 (class 2606 OID 16445)
-- Name: media media_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media
    ADD CONSTRAINT media_pk PRIMARY KEY (id_media);


--
-- TOC entry 3282 (class 2606 OID 16407)
-- Name: polluant polluant_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.polluant
    ADD CONSTRAINT polluant_pk PRIMARY KEY (id_polluant);


--
-- TOC entry 3294 (class 2606 OID 16509)
-- Name: proprietaire_objet proprietaire_objet_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.proprietaire_objet
    ADD CONSTRAINT proprietaire_objet_pk PRIMARY KEY (id_proprietaire_objet);


--
-- TOC entry 3296 (class 2606 OID 16562)
-- Name: publication publication_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.publication
    ADD CONSTRAINT publication_pk PRIMARY KEY (id_publication);


--
-- TOC entry 3302 (class 2606 OID 16634)
-- Name: serveur serveur_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.serveur
    ADD CONSTRAINT serveur_pk PRIMARY KEY (id_serveur);


--
-- TOC entry 3286 (class 2606 OID 16436)
-- Name: type_media type_media_pkey; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.type_media
    ADD CONSTRAINT type_media_pkey PRIMARY KEY (id_type_media);


--
-- TOC entry 3305 (class 2606 OID 16646)
-- Name: donnee appli_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee
    ADD CONSTRAINT appli_fk FOREIGN KEY (id_application) REFERENCES si.application(id_application);


--
-- TOC entry 3324 (class 2606 OID 16671)
-- Name: application application_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.application
    ADD CONSTRAINT application_fk FOREIGN KEY (id_serveur) REFERENCES si.serveur(id_serveur);


--
-- TOC entry 3306 (class 2606 OID 16616)
-- Name: donnee donnee_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee
    ADD CONSTRAINT donnee_fk FOREIGN KEY (id_maille_temps) REFERENCES si.maille_temps(id_maille_temps);


--
-- TOC entry 3314 (class 2606 OID 16465)
-- Name: media_donnee donnee_fk_1; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media_donnee
    ADD CONSTRAINT donnee_fk_1 FOREIGN KEY (id_donnee) REFERENCES si.donnee(id_donnee);


--
-- TOC entry 3318 (class 2606 OID 16487)
-- Name: donnee_lien donnee_lien_fk_cible; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee_lien
    ADD CONSTRAINT donnee_lien_fk_cible FOREIGN KEY (id_donnee_cible) REFERENCES si.donnee(id_donnee);


--
-- TOC entry 3319 (class 2606 OID 16482)
-- Name: donnee_lien donnee_lien_fk_source; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee_lien
    ADD CONSTRAINT donnee_lien_fk_source FOREIGN KEY (id_donnee_source) REFERENCES si.donnee(id_donnee);


--
-- TOC entry 3307 (class 2606 OID 16578)
-- Name: donnee maille_geo_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee
    ADD CONSTRAINT maille_geo_fk FOREIGN KEY (id_maille_geo) REFERENCES si.maille_geo(id_maille_geo);


--
-- TOC entry 3315 (class 2606 OID 16589)
-- Name: media_donnee maille_geo_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media_donnee
    ADD CONSTRAINT maille_geo_fk FOREIGN KEY (id_maille_geo_diff) REFERENCES si.maille_geo(id_maille_geo);


--
-- TOC entry 3308 (class 2606 OID 16546)
-- Name: donnee maturite_donnee_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee
    ADD CONSTRAINT maturite_donnee_fk FOREIGN KEY (id_maturite) REFERENCES si.etat_maturite(id_etat_maturite);


--
-- TOC entry 3320 (class 2606 OID 16526)
-- Name: publication maturite_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.publication
    ADD CONSTRAINT maturite_fk FOREIGN KEY (id_maturite) REFERENCES si.etat_maturite(id_etat_maturite);


--
-- TOC entry 3311 (class 2606 OID 16536)
-- Name: media maturite_media_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media
    ADD CONSTRAINT maturite_media_fk FOREIGN KEY (id_maturite) REFERENCES si.etat_maturite(id_etat_maturite);


--
-- TOC entry 3316 (class 2606 OID 16611)
-- Name: media_donnee media_donnee_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media_donnee
    ADD CONSTRAINT media_donnee_fk FOREIGN KEY (id_maille_tempo_diff) REFERENCES si.maille_temps(id_maille_temps);


--
-- TOC entry 3317 (class 2606 OID 16460)
-- Name: media_donnee media_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media_donnee
    ADD CONSTRAINT media_fk FOREIGN KEY (id_media) REFERENCES si.media(id_media);


--
-- TOC entry 3322 (class 2606 OID 16556)
-- Name: media_publication media_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media_publication
    ADD CONSTRAINT media_fk FOREIGN KEY (id_media) REFERENCES si.media(id_media);


--
-- TOC entry 3323 (class 2606 OID 16563)
-- Name: media_publication media_publication_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media_publication
    ADD CONSTRAINT media_publication_fk FOREIGN KEY (id_publication) REFERENCES si.publication(id_publication);


--
-- TOC entry 3309 (class 2606 OID 16417)
-- Name: donnee polluant_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee
    ADD CONSTRAINT polluant_fk FOREIGN KEY (id_polluant) REFERENCES si.polluant(id_polluant);


--
-- TOC entry 3310 (class 2606 OID 16541)
-- Name: donnee propriaitaire_donnee_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee
    ADD CONSTRAINT propriaitaire_donnee_fk FOREIGN KEY (id_proprietaire_objet) REFERENCES si.proprietaire_objet(id_proprietaire_objet);


--
-- TOC entry 3312 (class 2606 OID 16531)
-- Name: media proprietaire_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media
    ADD CONSTRAINT proprietaire_fk FOREIGN KEY (id_proprietaire_objet) REFERENCES si.proprietaire_objet(id_proprietaire_objet);


--
-- TOC entry 3321 (class 2606 OID 16521)
-- Name: publication publication_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.publication
    ADD CONSTRAINT publication_fk FOREIGN KEY (id_proprietaire_objet) REFERENCES si.proprietaire_objet(id_proprietaire_objet);


--
-- TOC entry 3313 (class 2606 OID 16470)
-- Name: media type_media_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media
    ADD CONSTRAINT type_media_fk FOREIGN KEY (id_type_media) REFERENCES si.type_media(id_type_media);


-- Completed on 2023-06-05 14:49:48

--
-- PostgreSQL database dump complete
--

