--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2
-- Dumped by pg_dump version 15.2

-- Started on 2023-06-06 15:23:51

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
-- TOC entry 7 (class 2615 OID 24914)
-- Name: si; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA si;


ALTER SCHEMA si OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 216 (class 1259 OID 24915)
-- Name: application; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.application (
    id_application integer NOT NULL,
    nom_application character varying,
    id_serveur integer DEFAULT 0 NOT NULL
);


ALTER TABLE si.application OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 24921)
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
-- TOC entry 3508 (class 0 OID 0)
-- Dependencies: 217
-- Name: application_id_application_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.application_id_application_seq OWNED BY si.application.id_application;


--
-- TOC entry 218 (class 1259 OID 24922)
-- Name: donnee; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.donnee (
    id_donnee integer NOT NULL,
    id_polluant integer,
    libelle_donnee character varying,
    type_donnee character varying,
    id_etat_maturite integer DEFAULT 0 NOT NULL,
    id_proprietaire_objet integer DEFAULT 0 NOT NULL,
    id_maille_geo integer DEFAULT 0 NOT NULL,
    id_maille_temps integer DEFAULT 0 NOT NULL,
    reglementaire character varying DEFAULT 'N'::character varying,
    debut_recolte date,
    id_application integer DEFAULT 0
);


ALTER TABLE si.donnee OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 24933)
-- Name: etat_maturite; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.etat_maturite (
    id_etat_maturite integer NOT NULL,
    libelle_etat_maturite character varying
);


ALTER TABLE si.etat_maturite OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 24938)
-- Name: maille_geo; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.maille_geo (
    id_maille_geo integer NOT NULL,
    libelle_maille_geo character varying
);


ALTER TABLE si.maille_geo OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 24943)
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
-- TOC entry 3509 (class 0 OID 0)
-- Dependencies: 221
-- Name: maille_geo_id_maille_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.maille_geo_id_maille_seq OWNED BY si.maille_geo.id_maille_geo;


--
-- TOC entry 222 (class 1259 OID 24944)
-- Name: maille_temps; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.maille_temps (
    id_maille_temps integer DEFAULT nextval('si.maille_geo_id_maille_seq'::regclass) NOT NULL,
    libelle_maille_temps character varying
);


ALTER TABLE si.maille_temps OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 24950)
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
-- TOC entry 224 (class 1259 OID 24956)
-- Name: proprietaire_objet; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.proprietaire_objet (
    id_proprietaire_objet integer NOT NULL,
    libelle_proprietaire_objet character varying,
    code_interne_proprietaire character varying
);


ALTER TABLE si.proprietaire_objet OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 24961)
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
     JOIN si.etat_maturite em ON ((em.id_etat_maturite = d.id_etat_maturite)))
     JOIN si.proprietaire_objet po ON ((po.id_proprietaire_objet = d.id_proprietaire_objet)))
     JOIN si.maille_geo mg ON ((mg.id_maille_geo = d.id_maille_geo)))
     JOIN si.maille_temps mt ON ((mt.id_maille_temps = d.id_maille_temps)))
     JOIN si.application a ON ((a.id_application = d.id_application)));


ALTER TABLE si.donnee_clair OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 24966)
-- Name: donnee_id_donnee_seq; Type: SEQUENCE; Schema: si; Owner: postgres
--

CREATE SEQUENCE si.donnee_id_donnee_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE si.donnee_id_donnee_seq OWNER TO postgres;

--
-- TOC entry 3510 (class 0 OID 0)
-- Dependencies: 226
-- Name: donnee_id_donnee_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.donnee_id_donnee_seq OWNED BY si.donnee.id_donnee;


--
-- TOC entry 227 (class 1259 OID 24967)
-- Name: donnee_lien; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.donnee_lien (
    id_donnee_source integer NOT NULL,
    id_donnee_cible integer NOT NULL
);


ALTER TABLE si.donnee_lien OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 24970)
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
-- TOC entry 229 (class 1259 OID 24975)
-- Name: etat_maturite_id_etat_maturite_seq; Type: SEQUENCE; Schema: si; Owner: postgres
--

CREATE SEQUENCE si.etat_maturite_id_etat_maturite_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE si.etat_maturite_id_etat_maturite_seq OWNER TO postgres;

--
-- TOC entry 3511 (class 0 OID 0)
-- Dependencies: 229
-- Name: etat_maturite_id_etat_maturite_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.etat_maturite_id_etat_maturite_seq OWNED BY si.etat_maturite.id_etat_maturite;


--
-- TOC entry 230 (class 1259 OID 24976)
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
-- TOC entry 231 (class 1259 OID 24983)
-- Name: type_media; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.type_media (
    id_type_media integer NOT NULL,
    libelle_type_media character varying
);


ALTER TABLE si.type_media OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 24988)
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
-- TOC entry 233 (class 1259 OID 24992)
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
-- TOC entry 234 (class 1259 OID 24997)
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
-- TOC entry 235 (class 1259 OID 25002)
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
-- TOC entry 3512 (class 0 OID 0)
-- Dependencies: 235
-- Name: media_id_media_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.media_id_media_seq OWNED BY si.media.id_media;


--
-- TOC entry 236 (class 1259 OID 25003)
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
-- TOC entry 237 (class 1259 OID 25008)
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
-- TOC entry 238 (class 1259 OID 25013)
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
-- TOC entry 239 (class 1259 OID 25017)
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
-- TOC entry 240 (class 1259 OID 25021)
-- Name: perimetre_emi; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.perimetre_emi (
    id_donnee integer,
    id_polluant integer,
    scope character varying
);


ALTER TABLE si.perimetre_emi OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 25026)
-- Name: polluant_id_polluant_seq; Type: SEQUENCE; Schema: si; Owner: postgres
--

CREATE SEQUENCE si.polluant_id_polluant_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE si.polluant_id_polluant_seq OWNER TO postgres;

--
-- TOC entry 3513 (class 0 OID 0)
-- Dependencies: 241
-- Name: polluant_id_polluant_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.polluant_id_polluant_seq OWNED BY si.polluant.id_polluant;


--
-- TOC entry 242 (class 1259 OID 25027)
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
-- TOC entry 3514 (class 0 OID 0)
-- Dependencies: 242
-- Name: proprietaire_objet_id_proprietaire_objet_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.proprietaire_objet_id_proprietaire_objet_seq OWNED BY si.proprietaire_objet.id_proprietaire_objet;


--
-- TOC entry 243 (class 1259 OID 25028)
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
-- TOC entry 3515 (class 0 OID 0)
-- Dependencies: 243
-- Name: publication_id_publication_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.publication_id_publication_seq OWNED BY si.publication.id_publication;


--
-- TOC entry 244 (class 1259 OID 25029)
-- Name: serveur; Type: TABLE; Schema: si; Owner: postgres
--

CREATE TABLE si.serveur (
    id_serveur integer NOT NULL,
    nom_serveur character varying
);


ALTER TABLE si.serveur OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 25034)
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
-- TOC entry 3516 (class 0 OID 0)
-- Dependencies: 245
-- Name: serveur_id_serveur_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.serveur_id_serveur_seq OWNED BY si.serveur.id_serveur;


--
-- TOC entry 246 (class 1259 OID 25035)
-- Name: type_media_id_type_media_seq; Type: SEQUENCE; Schema: si; Owner: postgres
--

CREATE SEQUENCE si.type_media_id_type_media_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE si.type_media_id_type_media_seq OWNER TO postgres;

--
-- TOC entry 3517 (class 0 OID 0)
-- Dependencies: 246
-- Name: type_media_id_type_media_seq; Type: SEQUENCE OWNED BY; Schema: si; Owner: postgres
--

ALTER SEQUENCE si.type_media_id_type_media_seq OWNED BY si.type_media.id_type_media;


--
-- TOC entry 3264 (class 2604 OID 25036)
-- Name: application id_application; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.application ALTER COLUMN id_application SET DEFAULT nextval('si.application_id_application_seq'::regclass);


--
-- TOC entry 3266 (class 2604 OID 25037)
-- Name: donnee id_donnee; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee ALTER COLUMN id_donnee SET DEFAULT nextval('si.donnee_id_donnee_seq'::regclass);


--
-- TOC entry 3273 (class 2604 OID 25038)
-- Name: etat_maturite id_etat_maturite; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.etat_maturite ALTER COLUMN id_etat_maturite SET DEFAULT nextval('si.etat_maturite_id_etat_maturite_seq'::regclass);


--
-- TOC entry 3274 (class 2604 OID 25039)
-- Name: maille_geo id_maille_geo; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.maille_geo ALTER COLUMN id_maille_geo SET DEFAULT nextval('si.maille_geo_id_maille_seq'::regclass);


--
-- TOC entry 3279 (class 2604 OID 25040)
-- Name: media id_media; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media ALTER COLUMN id_media SET DEFAULT nextval('si.media_id_media_seq'::regclass);


--
-- TOC entry 3276 (class 2604 OID 25041)
-- Name: polluant id_polluant; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.polluant ALTER COLUMN id_polluant SET DEFAULT nextval('si.polluant_id_polluant_seq'::regclass);


--
-- TOC entry 3278 (class 2604 OID 25042)
-- Name: proprietaire_objet id_proprietaire_objet; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.proprietaire_objet ALTER COLUMN id_proprietaire_objet SET DEFAULT nextval('si.proprietaire_objet_id_proprietaire_objet_seq'::regclass);


--
-- TOC entry 3283 (class 2604 OID 25043)
-- Name: publication id_publication; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.publication ALTER COLUMN id_publication SET DEFAULT nextval('si.publication_id_publication_seq'::regclass);


--
-- TOC entry 3284 (class 2604 OID 25044)
-- Name: serveur id_serveur; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.serveur ALTER COLUMN id_serveur SET DEFAULT nextval('si.serveur_id_serveur_seq'::regclass);


--
-- TOC entry 3282 (class 2604 OID 25045)
-- Name: type_media id_type_media; Type: DEFAULT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.type_media ALTER COLUMN id_type_media SET DEFAULT nextval('si.type_media_id_type_media_seq'::regclass);


--
-- TOC entry 3478 (class 0 OID 24915)
-- Dependencies: 216
-- Data for Name: application; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.application VALUES (1, 'XR', 0);
INSERT INTO si.application VALUES (2, 'Outil Prévi', 0);
INSERT INTO si.application VALUES (3, 'Outil Inventaire', 0);
INSERT INTO si.application VALUES (4, 'Signal Air', 0);
INSERT INTO si.application VALUES (0, 'Inconnu', 0);
INSERT INTO si.application VALUES (5, 'Collecteur API RNSA', 0);
INSERT INTO si.application VALUES (6, 'Saisie Micro Capteurs', 0);
INSERT INTO si.application VALUES (7, 'Appli QGis Odeur', 4);
INSERT INTO si.application VALUES (9, 'Split PMQ', 6);
INSERT INTO si.application VALUES (10, 'ArcGis Esri', 0);
INSERT INTO si.application VALUES (11, 'Appli R-Shiny + BDD microcapteurs', 6);


--
-- TOC entry 3480 (class 0 OID 24922)
-- Dependencies: 218
-- Data for Name: donnee; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.donnee VALUES (22, 5, 'Concentration XR moyenne Journaliere SO2', 'Calcul_agreg', 1, 17, 5, 13, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (51, 42, 'Max journalier de moyenne 8H', 'Stat', 1, 17, 5, 13, 'N', NULL, 0);
INSERT INTO si.donnee VALUES (58, 4, 'Nombre de Heure de dépassement 200', 'Stat', 1, 17, 5, 11, 'O', '1997-01-01', 0);
INSERT INTO si.donnee VALUES (56, 41, 'Concentration XR moyenne Mensuelle C6H6', 'Calcul_agreg', 1, 17, 5, 9, 'N', NULL, 0);
INSERT INTO si.donnee VALUES (7, 1, 'Concentration XR moyenne Journaliere O3', 'Calcul_agreg', 1, 17, 5, 13, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (33, 4, 'Concentration XR moyenne horaire NO2', 'Calcul_agreg', 1, 17, 5, 8, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (35, 4, 'Concentration XR moyenne Mensuelle NO2', 'Calcul_agreg', 1, 17, 5, 9, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (24, 5, 'Concentration XR moyenne Annuelle SO2', 'Calcul_agreg', 1, 17, 5, 11, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (37, 1, 'Concentration Modélisée Expertisée O3', 'Modelisation Expertisée', 1, 1, 14, 13, 'N', '2021-01-01', 2);
INSERT INTO si.donnee VALUES (38, 0, 'Estimation des émissions annuelles totales', 'Emission ', 1, 1, 4, 11, 'O', '2005-01-01', 3);
INSERT INTO si.donnee VALUES (39, 4, 'Maxjournalier MH NO2', 'Stat', 1, 17, 5, 11, 'O', '1997-01-01', 0);
INSERT INTO si.donnee VALUES (41, 4, 'Nombre d''heure de dépassement VL', 'Stat', 1, 0, 5, 11, 'O', '1997-01-01', 0);
INSERT INTO si.donnee VALUES (42, 0, 'Bloc Données Stations ', 'Paramétre Station', 1, 16, 5, 16, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (8, 1, 'Concentration XR moyenne Mensuelle O3', 'Calcul_agreg', 1, 17, 5, 9, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (49, 42, 'Concentration XR moyenne Mensuelle CO', 'Calcul_agreg', 1, 17, 5, 9, 'N', NULL, 0);
INSERT INTO si.donnee VALUES (11, 0, 'Indice Atmo', 'Modelisation Previ', 1, 0, 14, 13, 'O', '2021-01-01', 2);
INSERT INTO si.donnee VALUES (12, 5, 'Sous Indice Atmo SO2', 'Modelisation Previ', 1, 1, 14, 13, 'N', '2021-01-01', 2);
INSERT INTO si.donnee VALUES (13, 2, 'Sous Indice Atmo PM2.5', 'Modelisation Previ', 1, 1, 14, 13, 'N', '2021-01-01', 2);
INSERT INTO si.donnee VALUES (14, 3, 'Sous Indice Atmo PM10', 'Modelisation Previ', 1, 1, 14, 13, 'N', '2021-01-01', 2);
INSERT INTO si.donnee VALUES (15, 1, 'Sous Indice Atmo O3', 'Modelisation Previ', 1, 1, 14, 13, 'N', '2021-01-01', 2);
INSERT INTO si.donnee VALUES (63, 43, 'Max Journalier MH NOx', 'Stat', 1, 17, 0, 13, 'O', NULL, 0);
INSERT INTO si.donnee VALUES (9, 1, 'Concentration XR moyenne Annuelle O3', 'Calcul_agreg', 1, 17, 5, 11, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (40, 4, 'Nombre de jour dépassement No2 OMS2021 25', 'Stat', 1, 17, 5, 11, 'O', '1997-01-01', 0);
INSERT INTO si.donnee VALUES (6, 1, 'Concentration XR moyenne horaire O3', 'Calcul_agreg', 1, 17, 5, 8, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (23, 5, 'Concentration XR moyenne Mensuelle SO2', 'Calcul_agreg', 1, 17, 5, 9, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (26, 2, 'Concentration XR moyenne Journaliere PM2.5', 'Calcul_agreg', 1, 17, 5, 13, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (3, 2, 'Concentration XR 1/4h PM2.5', 'Mesure Auto', 1, 16, 5, 7, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (18, 38, 'Indice Pollinique RNSA Noisetier', 'Indice', 1, 0, 2, 10, 'N', '2022-06-30', 5);
INSERT INTO si.donnee VALUES (19, 39, 'Indice Pollinique RNSA Ambroisie', 'Indice', 1, 0, 2, 10, 'N', '2022-06-30', 5);
INSERT INTO si.donnee VALUES (20, 40, 'Indice Pollinique RNSA Frene', 'Indice', 1, 0, 2, 10, 'N', '2022-06-30', 5);
INSERT INTO si.donnee VALUES (28, 2, 'Concentration XR moyenne Annuelle PM2.5', 'Calcul_agreg', 1, 17, 5, 11, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (1, 4, 'Concentration XR 1/4h NO2', 'Mesure Brute Auto', 1, 17, 5, 7, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (25, 2, 'Concentration XR moyenne horaire PM2.5', 'Calcul_agreg', 1, 17, 5, 8, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (27, 2, 'Concentration XR moyenne Mensuelle PM2.5', 'Calcul_agreg', 1, 17, 5, 9, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (30, 3, 'Concentration XR moyenne Journaliere  PM10', 'Calcul_agreg', 1, 17, 5, 13, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (32, 3, 'Concentration XR moyenne Annuelle  PM10', 'Calcul_agreg', 1, 17, 5, 11, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (31, 3, 'Concentration XR moyenne Mensuelle  PM10', 'Calcul_agreg', 1, 17, 5, 9, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (29, 3, 'Concentration XR moyenne horaire PM10', 'Calcul_agreg', 1, 17, 5, 8, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (34, 4, 'Concentration XR moyenne Journaliere NO2', 'Calcul_agreg', 1, 17, 5, 13, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (36, 4, 'Concentration XR moyenne Annuelle NO2', 'Calcul_agreg', 1, 17, 5, 11, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (17, 0, 'Signalement Phenomene Atmosphérique', 'Signalement', 1, 0, 5, 16, 'N', '2022-01-01', 4);
INSERT INTO si.donnee VALUES (5, 1, 'Concentration XR 1/4h O3', 'Mesure Brute Auto', 1, 16, 5, 7, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (4, 3, 'Concentration XR 1/4h PM10', 'Mesure Brute Auto', 1, 16, 5, 7, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (61, 43, 'Concentration XR 1/4h NOx', 'Mesure Auto', 1, 17, 5, 7, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (2, 5, 'Concentration XR 1/4h SO2', 'Mesure Brute Auto', 1, 16, 5, 7, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (43, NULL, 'Donnée Meteo en Station', 'Mesure Brute Auto', 1, 16, 5, 7, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (45, 42, 'Concentration XR 1/4h CO', 'Mesure Brute Auto', 1, 16, 5, 7, 'N', NULL, 0);
INSERT INTO si.donnee VALUES (47, 42, 'Concentration XR moyenne Annuelle CO', 'Calcul_agreg', 1, 17, 5, 11, 'N', NULL, 0);
INSERT INTO si.donnee VALUES (21, 5, 'Concentration XR moyenne horaire SO2', 'Calcul_agreg', 1, 17, 5, 8, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (59, 4, 'Nombre de 3Heure de dépassement 400', 'Stat', 1, 17, 5, 11, 'O', '1997-01-01', 0);
INSERT INTO si.donnee VALUES (57, 41, 'Max Journalier  de MH C6H6', 'Stat', 1, 17, 5, 13, 'N', NULL, 0);
INSERT INTO si.donnee VALUES (62, 43, 'Concentration XR moyenne horaire NOx', 'Calcul_agreg', 1, 17, 5, 8, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (64, 43, 'Concentration XR moyenne Mensuelle NOx', 'Calcul_agreg', 1, 17, 5, 9, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (65, 43, 'Concentration XR moyenne Journaliere NOx', 'Calcul_agreg', 1, 17, 5, 13, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (66, 1, 'Max Jour de la M8H O3', 'Stat', 1, 0, 0, 13, 'N', '1997-01-01', 3);
INSERT INTO si.donnee VALUES (46, 42, 'Concentration XR moyenne Journaliere CO', 'Calcul_agreg', 1, 17, 5, 13, 'N', NULL, 0);
INSERT INTO si.donnee VALUES (52, 42, 'Nb Jour Depassement du max 8h 10Mg', 'Stat', 1, 17, 5, 11, 'N', NULL, 0);
INSERT INTO si.donnee VALUES (50, 42, 'Max Journalier  de MH CO ', 'Stat', 1, 17, 5, 13, 'N', NULL, 0);
INSERT INTO si.donnee VALUES (53, 41, 'Concentration XR moyenne Journaliere C6H6', 'Calcul_agreg', 1, 17, 5, 13, 'N', NULL, 0);
INSERT INTO si.donnee VALUES (54, 41, 'Concentration XR moyenne Annuelle C6H6', 'Calcul_agreg', 1, 17, 5, 11, 'N', NULL, 0);
INSERT INTO si.donnee VALUES (55, 41, 'Concentration XR moyenne horaire C6H6', 'Calcul_agreg', 1, 17, 5, 8, 'N', NULL, 0);
INSERT INTO si.donnee VALUES (16, 4, 'Sous Indice Atmo NO2', 'Modelisation Previ', 1, 1, 14, 13, 'O', '2021-01-01', 2);
INSERT INTO si.donnee VALUES (60, 43, 'Concentration XR moyenne Annuelle NOx', 'Calcul_agreg', 1, 17, 5, 11, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (48, 42, 'Concentration XR moyenne horaire CO', 'Calcul_agreg', 1, 17, 5, 8, 'N', NULL, 0);
INSERT INTO si.donnee VALUES (87, 46, 'Moyenne Annuelle CD Particulaire', 'Stat', 1, 17, 5, 11, 'N', NULL, 1);
INSERT INTO si.donnee VALUES (88, 47, 'Moyenne Annuelle NI Particulaire', 'Stat', 1, 17, 5, 11, 'N', NULL, 1);
INSERT INTO si.donnee VALUES (105, 53, 'Moy Horaire Humidité Relative', 'Mesure Auto', 1, 16, 5, 8, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (106, 54, 'Moy Horaire Pression Atmosphérique', 'Mesure Auto', 1, 16, 5, 8, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (107, 55, 'Moy Horaire Vitesse du vent', 'Mesure Auto', 1, 16, 5, 8, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (108, 56, 'Moy Horaire Direction du vent', 'Mesure Auto', 1, 16, 5, 8, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (109, 57, 'Moy Horaire Gradient Thérmique', 'Mesure Auto', 1, 16, 5, 8, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (103, 52, 'Moy Horaire T° Exterieur Station', 'Calcul_agreg', 1, 17, 5, 8, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (104, 0, 'Bloc Données Meteo Horaire', 'Mesure Auto', 1, 16, 5, 8, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (110, 53, 'Moy QH Humidité Relative', 'Mesure Auto', 1, 16, 5, 7, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (111, 54, 'Moy QH Pression Atmosphérique', 'Mesure Auto', 1, 16, 5, 7, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (112, 55, 'Moy QH Vitesse du vent', 'Mesure Auto', 1, 16, 5, 7, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (96, 50, 'Concentration XR moyenne Journaliere  PM1', 'Calcul_agreg', 1, 17, 5, 13, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (97, 50, 'Concentration XR moyenne Annuelle  PM1', 'Calcul_agreg', 1, 17, 5, 11, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (98, 50, 'Concentration XR moyenne Mensuelle  PM1', 'Calcul_agreg', 1, 17, 5, 9, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (99, 50, 'Concentration XR moyenne horaire PM1', 'Calcul_agreg', 1, 17, 5, 8, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (100, 50, 'Concentration XR 1/4h PM1', 'Mesure Brute Auto', 1, 16, 5, 7, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (67, 1, 'AOT40 O3 végétation (obj qualité végétation)', 'Stat', 1, 0, 0, 11, 'N', '1997-01-01', 3);
INSERT INTO si.donnee VALUES (68, 1, 'AOT40 - 5 Ans O3 végétation', 'Stat', 1, 0, 0, 11, 'N', '1997-01-01', 3);
INSERT INTO si.donnee VALUES (69, 1, 'Nb Dépassement MH 180', 'Stat', 1, 0, 0, 11, 'N', '1997-01-01', 3);
INSERT INTO si.donnee VALUES (70, 1, 'Nb Dépassement 3h 240', 'Stat', 1, 0, 0, 11, 'N', '1997-01-01', 3);
INSERT INTO si.donnee VALUES (71, 1, 'Nb Dépassement Moy8h 120', 'Stat', 1, 0, 0, 11, 'N', '1997-01-01', 3);
INSERT INTO si.donnee VALUES (73, 1, 'Pic Saisonnier 6mois OMS 60', 'Stat', 1, 0, 0, 11, 'N', '1997-01-01', 3);
INSERT INTO si.donnee VALUES (72, 1, 'Nb Jour Dépassement Moy8h 100 OMS', 'Stat', 1, 0, 0, 11, 'N', '1997-01-01', 3);
INSERT INTO si.donnee VALUES (80, 3, 'Max Journalier MH PM10', 'Stat', 1, 17, 5, 8, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (81, 3, 'Depassement Seuil MA 40 PM10 ', 'Stat', 1, 17, 5, 8, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (86, 45, 'Moyenne Annuelle AS Particulaire', 'Stat', 1, 17, 5, 11, 'N', NULL, 1);
INSERT INTO si.donnee VALUES (89, 48, 'Moyenne Annuelle PB Particulaire', 'Stat', 1, 17, 5, 11, 'N', NULL, 1);
INSERT INTO si.donnee VALUES (90, 49, 'Moyenne Annuelle BAP Particulaire', 'Stat', 1, 17, 5, 11, 'N', NULL, 1);
INSERT INTO si.donnee VALUES (10, 1, 'Max Jour de la MH O3', 'Stat', 1, 0, 0, 13, 'N', '1997-01-01', 3);
INSERT INTO si.donnee VALUES (74, 5, 'Max Journalier de la MH SO2', 'Stat', 1, 17, 5, 13, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (75, 5, 'Moyenne Hivernale de la MH SO2', 'Stat', 1, 17, 5, 11, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (76, 5, 'Nb Dépassement MJ 125', 'Stat', 1, 17, 5, 13, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (77, 5, 'Nb Dépassement MH 350', 'Stat', 1, 17, 5, 13, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (78, 5, 'Nb Dépassement 3fois MH 500', 'Stat', 1, 17, 5, 13, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (79, 5, 'Nb Jour dépassement sup 40µ OMS', 'Stat', 1, 17, 5, 11, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (82, 3, 'Nb Dep Moyenne Jour 50', 'Stat', 1, 17, 5, 13, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (83, 2, 'Depassement Seuil MA 20  PM2.5', 'Stat', 1, 17, 5, 13, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (84, 2, 'Depassement Seuil MA 25 PM2.5', 'Stat', 1, 17, 5, 13, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (85, 2, 'Max Journalier MH PM2.5', 'Stat', 1, 17, 5, 13, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (91, 45, 'XR Moyenne Demi-Horaire AS Particulaire', 'Mesure Brute Auto', 1, 17, 5, 15, 'N', NULL, 1);
INSERT INTO si.donnee VALUES (92, 46, 'XR Moyenne Demi-HoraireCD Particulaire', 'Mesure Brute Auto', 1, 17, 5, 15, 'N', NULL, 1);
INSERT INTO si.donnee VALUES (93, 47, 'XR Moyenne Demi-HoraireNI Particulaire', 'Mesure Brute Auto', 1, 17, 5, 15, 'N', NULL, 1);
INSERT INTO si.donnee VALUES (94, 48, 'XR Moyenne Demi-HorairePB Particulaire', 'Mesure Brute Auto', 1, 17, 5, 15, 'N', NULL, 1);
INSERT INTO si.donnee VALUES (95, 49, 'XR Moyenne Demi-HoraireBAP Particulaire', 'Mesure Brute Auto', 1, 17, 5, 15, 'N', NULL, 1);
INSERT INTO si.donnee VALUES (113, 56, 'Moy QH Direction du vent', 'Mesure Auto', 1, 16, 5, 7, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (114, 57, 'Moy QH Gradient Thérmique', 'Mesure Auto', 1, 16, 5, 7, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (101, 51, 'Mesure Tournée Odeur', 'Mesure Nez', 1, 1, 5, 16, 'N', '2014-01-01', 7);
INSERT INTO si.donnee VALUES (102, 52, 'Donnee Temperature QH Exterieur Station', 'Meteo Brute', 1, 17, 5, 12, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (115, 0, 'Bloc Données Meteo Quart-Horaire', 'Mesure Auto', 1, 16, 5, 7, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (119, 0, 'Adresse Postale station et code insee', 'Paramétre Station', 1, 16, 5, 16, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (122, 44, 'Concentration XR 1/4h NO', 'Mesure Auto', 1, 17, 5, 7, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (123, 44, 'Concentration XR moyenne Annuelle NO', 'Calcul_agreg', 1, 17, 5, 11, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (124, 44, 'Concentration XR moyenne Journaliere NO', 'Calcul_agreg', 1, 17, 5, 13, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (125, 44, 'Concentration XR moyenne Mensuelle NO', 'Calcul_agreg', 1, 17, 5, 9, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (128, 58, 'Secteur SNAP', 'Inventaire', 1, 4, 0, 0, 'O', NULL, 3);
INSERT INTO si.donnee VALUES (121, 0, 'Periode Mise en service', 'Paramétre Station', 1, 16, 5, 16, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (116, 0, 'Nom de la station', 'Paramétre Station', 1, 16, 5, 16, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (120, 0, 'Code Geodair de la station', 'Paramétre Station', 1, 16, 5, 16, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (117, 0, 'Localisation de la Station( X,Y, Altitude)', 'Paramétre Station', 1, 16, 5, 16, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (118, 0, 'Influence-Typologie de la station', 'Paramétre Station', 1, 16, 5, 16, 'N', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (126, 44, 'Concentration XR moyenne horaire NO', 'Calcul_agreg', 1, 17, 5, 8, 'O', '1997-01-01', 1);
INSERT INTO si.donnee VALUES (134, 61, 'Secteur du PCAET', 'Inventaire', 1, 4, 0, 0, 'O', '2010-01-01', 3);
INSERT INTO si.donnee VALUES (129, 58, 'Secteur SNAP Simplifié', 'Inventaire', 1, 4, 0, 0, 'O', '2010-01-01', 3);
INSERT INTO si.donnee VALUES (130, 60, 'Secteur Secten V1', 'Inventaire', 1, 4, 0, 0, 'O', '2010-01-01', 3);
INSERT INTO si.donnee VALUES (133, 60, 'Secteur Secten V3', 'Inventaire', 1, 4, 0, 0, 'O', '2010-01-01', 3);
INSERT INTO si.donnee VALUES (131, 60, 'Secteur Secten V2', 'Inventaire', 1, 4, 0, 0, 'O', '2010-01-01', 3);
INSERT INTO si.donnee VALUES (135, 62, 'Secteur ORECAN', 'Inventaire', 1, 4, 0, 0, 'O', '2010-01-01', 3);
INSERT INTO si.donnee VALUES (159, 77, 'Emission Annuelle CD (emi)', 'Inventaire', 1, 4, 4, 11, 'O', '2010-01-01', 3);
INSERT INTO si.donnee VALUES (160, 2, 'Emission Annuelle PM2.5', 'Inventaire', 1, 4, 4, 11, 'O', '2010-01-01', 3);
INSERT INTO si.donnee VALUES (161, 71, 'Emission Annuelle HCFC', 'Inventaire', 1, 4, 4, 11, 'O', '2010-01-01', 3);
INSERT INTO si.donnee VALUES (162, 5, 'Emission Annuelle SO2', 'Inventaire', 1, 4, 4, 11, 'O', '2010-01-01', 3);
INSERT INTO si.donnee VALUES (163, 74, 'Emission Annuelle CFC', 'Inventaire', 1, 4, 4, 11, 'O', '2010-01-01', 3);
INSERT INTO si.donnee VALUES (164, 68, 'Emission Annuelle HFC', 'Inventaire', 1, 4, 4, 11, 'O', '2010-01-01', 3);
INSERT INTO si.donnee VALUES (165, 67, 'Emission Annuelle N2O', 'Inventaire', 1, 4, 4, 11, 'O', '2010-01-01', 3);
INSERT INTO si.donnee VALUES (166, 79, 'Emission Annuelle NI (emi)', 'Inventaire', 1, 4, 4, 11, 'O', '2010-01-01', 3);
INSERT INTO si.donnee VALUES (167, 73, 'Emission Annuelle C4F8', 'Inventaire', 1, 4, 4, 11, 'O', '2010-01-01', 3);
INSERT INTO si.donnee VALUES (168, 41, 'Emission Annuelle C6H6 Benzene', 'Inventaire', 1, 4, 4, 11, 'O', '2010-01-01', 3);
INSERT INTO si.donnee VALUES (169, 42, 'Emission Annuelle CO Monoxyde Carbone', 'Inventaire', 1, 4, 4, 11, 'O', '2010-01-01', 3);
INSERT INTO si.donnee VALUES (170, 72, 'Emission Annuelle NF3', 'Inventaire', 1, 4, 4, 11, 'O', '2010-01-01', 3);
INSERT INTO si.donnee VALUES (171, 69, 'Emission Annuelle PFC', 'Inventaire', 1, 4, 4, 11, 'O', '2010-01-01', 3);
INSERT INTO si.donnee VALUES (172, 76, 'Emission Annuelle AS (emi)', 'Inventaire', 1, 4, 4, 11, 'O', '2010-01-01', 3);
INSERT INTO si.donnee VALUES (173, 64, 'Emission Annuelle NH3', 'Inventaire', 1, 4, 4, 11, 'O', '2010-01-01', 3);
INSERT INTO si.donnee VALUES (174, 78, 'Emission Annuelle HG (emi)', 'Inventaire', 1, 4, 4, 11, 'O', '2010-01-01', 3);
INSERT INTO si.donnee VALUES (175, 63, 'Emission Annuelle COVNM', 'Inventaire', 1, 4, 4, 11, 'O', '2010-01-01', 3);
INSERT INTO si.donnee VALUES (176, 3, 'Emission Annuelle PM10', 'Inventaire', 1, 4, 4, 11, 'O', '2010-01-01', 3);
INSERT INTO si.donnee VALUES (177, 70, 'Emission Annuelle SF6', 'Inventaire', 1, 4, 4, 11, 'O', '2010-01-01', 3);
INSERT INTO si.donnee VALUES (178, 65, 'Emission Annuelle CO2', 'Inventaire', 1, 4, 4, 11, 'O', '2010-01-01', 3);
INSERT INTO si.donnee VALUES (179, 75, 'Emission Annuelle BAP', 'Inventaire', 1, 4, 4, 11, 'O', '2010-01-01', 3);
INSERT INTO si.donnee VALUES (180, 43, 'Emission Annuelle NOx', 'Inventaire', 1, 4, 4, 11, 'O', '2010-01-01', 3);
INSERT INTO si.donnee VALUES (181, 80, 'Emission Annuelle PB (emi)', 'Inventaire', 1, 4, 4, 11, 'O', '2010-01-01', 3);
INSERT INTO si.donnee VALUES (182, 66, 'Emission Annuelle CH4', 'Inventaire', 1, 4, 4, 11, 'O', '2010-01-01', 3);
INSERT INTO si.donnee VALUES (183, 0, 'Données Emission Orecan', 'Inventaire', 1, 4, 4, 11, 'O', '2010-01-01', 0);
INSERT INTO si.donnee VALUES (184, 0, 'Données Emission OpenData', 'Inventaire', 1, 4, 4, 11, 'O', '2010-01-01', 0);
INSERT INTO si.donnee VALUES (185, 0, 'Données Emission Siam', 'Inventaire', 1, 4, 4, 11, 'O', '2010-01-01', 0);
INSERT INTO si.donnee VALUES (186, 0, 'Données Emission Full', 'Inventaire', 1, 4, 4, 11, 'O', '2010-01-01', 0);
INSERT INTO si.donnee VALUES (187, 43, 'Emission Annuelle Ges Total EqC02', 'Inventaire', 1, 4, 4, 11, 'O', '2010-01-01', 3);
INSERT INTO si.donnee VALUES (188, 4, 'Concentration µcapteur 1/4h NO2', 'Mesure Brute Auto', 2, 16, 5, 7, 'N', '2021-08-01', 11);


--
-- TOC entry 3488 (class 0 OID 24967)
-- Dependencies: 227
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
INSERT INTO si.donnee_lien VALUES (102, 103);
INSERT INTO si.donnee_lien VALUES (103, 104);
INSERT INTO si.donnee_lien VALUES (105, 104);
INSERT INTO si.donnee_lien VALUES (106, 104);
INSERT INTO si.donnee_lien VALUES (107, 104);
INSERT INTO si.donnee_lien VALUES (108, 104);
INSERT INTO si.donnee_lien VALUES (109, 104);
INSERT INTO si.donnee_lien VALUES (110, 115);
INSERT INTO si.donnee_lien VALUES (111, 115);
INSERT INTO si.donnee_lien VALUES (112, 115);
INSERT INTO si.donnee_lien VALUES (113, 115);
INSERT INTO si.donnee_lien VALUES (114, 115);
INSERT INTO si.donnee_lien VALUES (110, 105);
INSERT INTO si.donnee_lien VALUES (114, 109);
INSERT INTO si.donnee_lien VALUES (113, 108);
INSERT INTO si.donnee_lien VALUES (112, 107);
INSERT INTO si.donnee_lien VALUES (111, 106);
INSERT INTO si.donnee_lien VALUES (120, 42);
INSERT INTO si.donnee_lien VALUES (119, 42);
INSERT INTO si.donnee_lien VALUES (118, 42);
INSERT INTO si.donnee_lien VALUES (117, 42);
INSERT INTO si.donnee_lien VALUES (116, 42);
INSERT INTO si.donnee_lien VALUES (121, 42);
INSERT INTO si.donnee_lien VALUES (122, 123);
INSERT INTO si.donnee_lien VALUES (122, 124);
INSERT INTO si.donnee_lien VALUES (122, 125);
INSERT INTO si.donnee_lien VALUES (122, 126);
INSERT INTO si.donnee_lien VALUES (159, 184);
INSERT INTO si.donnee_lien VALUES (159, 185);
INSERT INTO si.donnee_lien VALUES (159, 186);
INSERT INTO si.donnee_lien VALUES (160, 184);
INSERT INTO si.donnee_lien VALUES (160, 185);
INSERT INTO si.donnee_lien VALUES (160, 186);
INSERT INTO si.donnee_lien VALUES (160, 183);
INSERT INTO si.donnee_lien VALUES (161, 186);
INSERT INTO si.donnee_lien VALUES (161, 183);
INSERT INTO si.donnee_lien VALUES (162, 185);
INSERT INTO si.donnee_lien VALUES (162, 184);
INSERT INTO si.donnee_lien VALUES (162, 183);
INSERT INTO si.donnee_lien VALUES (163, 186);
INSERT INTO si.donnee_lien VALUES (163, 183);
INSERT INTO si.donnee_lien VALUES (164, 186);
INSERT INTO si.donnee_lien VALUES (164, 183);
INSERT INTO si.donnee_lien VALUES (165, 185);
INSERT INTO si.donnee_lien VALUES (165, 186);
INSERT INTO si.donnee_lien VALUES (165, 183);
INSERT INTO si.donnee_lien VALUES (166, 184);
INSERT INTO si.donnee_lien VALUES (166, 185);
INSERT INTO si.donnee_lien VALUES (166, 186);
INSERT INTO si.donnee_lien VALUES (167, 186);
INSERT INTO si.donnee_lien VALUES (167, 183);
INSERT INTO si.donnee_lien VALUES (168, 184);
INSERT INTO si.donnee_lien VALUES (168, 185);
INSERT INTO si.donnee_lien VALUES (168, 186);
INSERT INTO si.donnee_lien VALUES (169, 184);
INSERT INTO si.donnee_lien VALUES (169, 186);
INSERT INTO si.donnee_lien VALUES (170, 186);
INSERT INTO si.donnee_lien VALUES (170, 183);
INSERT INTO si.donnee_lien VALUES (171, 186);
INSERT INTO si.donnee_lien VALUES (171, 183);
INSERT INTO si.donnee_lien VALUES (172, 184);
INSERT INTO si.donnee_lien VALUES (172, 185);
INSERT INTO si.donnee_lien VALUES (172, 186);
INSERT INTO si.donnee_lien VALUES (173, 184);
INSERT INTO si.donnee_lien VALUES (173, 185);
INSERT INTO si.donnee_lien VALUES (173, 186);
INSERT INTO si.donnee_lien VALUES (173, 183);
INSERT INTO si.donnee_lien VALUES (174, 186);
INSERT INTO si.donnee_lien VALUES (175, 184);
INSERT INTO si.donnee_lien VALUES (175, 185);
INSERT INTO si.donnee_lien VALUES (175, 186);
INSERT INTO si.donnee_lien VALUES (175, 183);
INSERT INTO si.donnee_lien VALUES (176, 184);
INSERT INTO si.donnee_lien VALUES (176, 185);
INSERT INTO si.donnee_lien VALUES (176, 186);
INSERT INTO si.donnee_lien VALUES (176, 183);
INSERT INTO si.donnee_lien VALUES (177, 186);
INSERT INTO si.donnee_lien VALUES (177, 183);
INSERT INTO si.donnee_lien VALUES (178, 185);
INSERT INTO si.donnee_lien VALUES (178, 186);
INSERT INTO si.donnee_lien VALUES (178, 183);
INSERT INTO si.donnee_lien VALUES (179, 184);
INSERT INTO si.donnee_lien VALUES (179, 185);
INSERT INTO si.donnee_lien VALUES (179, 186);
INSERT INTO si.donnee_lien VALUES (180, 184);
INSERT INTO si.donnee_lien VALUES (180, 185);
INSERT INTO si.donnee_lien VALUES (180, 186);
INSERT INTO si.donnee_lien VALUES (180, 183);
INSERT INTO si.donnee_lien VALUES (181, 184);
INSERT INTO si.donnee_lien VALUES (181, 185);
INSERT INTO si.donnee_lien VALUES (181, 186);
INSERT INTO si.donnee_lien VALUES (182, 185);
INSERT INTO si.donnee_lien VALUES (182, 186);
INSERT INTO si.donnee_lien VALUES (182, 183);
INSERT INTO si.donnee_lien VALUES (135, 183);
INSERT INTO si.donnee_lien VALUES (134, 183);
INSERT INTO si.donnee_lien VALUES (165, 187);
INSERT INTO si.donnee_lien VALUES (178, 187);
INSERT INTO si.donnee_lien VALUES (187, 183);
INSERT INTO si.donnee_lien VALUES (182, 187);
INSERT INTO si.donnee_lien VALUES (182, 187);


--
-- TOC entry 3481 (class 0 OID 24933)
-- Dependencies: 219
-- Data for Name: etat_maturite; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.etat_maturite VALUES (0, 'Inconnu');
INSERT INTO si.etat_maturite VALUES (2, 'A l''étude');
INSERT INTO si.etat_maturite VALUES (1, 'Service Regulier');


--
-- TOC entry 3482 (class 0 OID 24938)
-- Dependencies: 220
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
INSERT INTO si.maille_geo VALUES (17, 'Commune/Iris');


--
-- TOC entry 3484 (class 0 OID 24944)
-- Dependencies: 222
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
INSERT INTO si.maille_temps VALUES (16, 'A la demande');


--
-- TOC entry 3490 (class 0 OID 24976)
-- Dependencies: 230
-- Data for Name: media; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.media VALUES (2, 'Widget Air de ma commune / Indice', 'https://www.atmonormandie.fr/air-commune/SaintLo/50502/indice-atmo?date=2023-05-04', 6, 1, 3);
INSERT INTO si.media VALUES (3, 'Widget Air de ma commune / Pollen', NULL, 6, 1, 3);
INSERT INTO si.media VALUES (6, 'Open Data Emission Région', 'https://api.atmonormandie.fr/index.php/view/map/?repository=emissions&project=emi_normandie_dpt', 5, 1, 3);
INSERT INTO si.media VALUES (7, 'Open Data Emission Département', 'https://api.atmonormandie.fr/index.php/view/map/?repository=emissions&project=emi_normandie_dpt', 5, 1, 3);
INSERT INTO si.media VALUES (8, 'Open Data Emission Epci', 'https://api.atmonormandie.fr/index.php/view/map/?repository=emissions&project=emi_normandie_dpt', 5, 1, 3);
INSERT INTO si.media VALUES (12, 'DataViz moyenne horaire maximale', 'https://www.atmonormandie.fr/dataviz/statistiques-annuelles?polluant_id=03&departement_id=&annee=2022', 6, 1, 3);
INSERT INTO si.media VALUES (9, 'DataViz Moyennes Annuelles No2', 'https://www.atmonormandie.fr/dataviz/statistiques-annuelles?polluant_id=03&departement_id=&annee=2022', 6, 1, 3);
INSERT INTO si.media VALUES (10, 'DataViz nombre d''heure de dépassement No2', 'https://www.atmonormandie.fr/dataviz/statistiques-annuelles?polluant_id=03&departement_id=&annee=2022', 6, 1, 3);
INSERT INTO si.media VALUES (11, 'DataViz Nombre de jour de dépassement No2 OMS2021', 'https://www.atmonormandie.fr/dataviz/statistiques-annuelles?polluant_id=03&departement_id=&annee=2022', 6, 1, 3);
INSERT INTO si.media VALUES (15, 'Siam / Mesure des stations ', 'https://www.atmonormandie.fr/dataviz/mesures-aux-stations', 6, 1, 3);
INSERT INTO si.media VALUES (16, 'Carte des Signalements ', 'https://www.atmonormandie.fr/article/carte-de-signalements-en-normandie', 1, 1, 1);
INSERT INTO si.media VALUES (18, 'Rapport Tournée Odeur', NULL, 8, 1, 1);
INSERT INTO si.media VALUES (14, 'Base de Donnée Consultation Geodair', 'https://www.geodair.fr/donnees/consultation', 5, 1, 1);
INSERT INTO si.media VALUES (19, 'Fichier QH SO2 Exxon', NULL, 9, 1, 7);
INSERT INTO si.media VALUES (20, 'Fichier QH SO2 Total ', NULL, 9, 1, 7);
INSERT INTO si.media VALUES (1, 'Carte Indice Atmo Jour', NULL, 1, 1, 3);
INSERT INTO si.media VALUES (13, 'Fichier Geod''air', NULL, 9, 1, 16);
INSERT INTO si.media VALUES (17, 'Tableau Détail des Signalements ', 'Intranet ', 9, 1, 1);
INSERT INTO si.media VALUES (21, 'Fichier Température Essart ', NULL, 9, 1, 7);
INSERT INTO si.media VALUES (22, 'Bilan Mensuel Pour industriel', NULL, 3, 1, 14);
INSERT INTO si.media VALUES (23, 'Inventaire Parc GeoDair', NULL, 9, 1, 16);
INSERT INTO si.media VALUES (4, 'Flux WFS / WMS 1 an Indice Atmo', NULL, 5, 1, 3);
INSERT INTO si.media VALUES (24, 'Flux WFS / WMS Mesure Annuelle', NULL, 5, 1, 3);
INSERT INTO si.media VALUES (25, 'Flux WFS / WMS Mesure Mensuelle', NULL, 5, 1, 3);
INSERT INTO si.media VALUES (26, 'Flux WFS / WMS Mesure Journaliere', NULL, 5, 1, 3);
INSERT INTO si.media VALUES (27, 'Flux WFS / WMS Mesure Horaire', NULL, 5, 1, 3);
INSERT INTO si.media VALUES (5, 'Flux WFS / WMS 3 Jours Indice Atmo', 'https://api.atmonormandie.fr/index.php/view/map/?repository=dindice&project=historique_indice_atmo', 5, 1, 3);
INSERT INTO si.media VALUES (28, 'Applications du Site ORECAN', 'http://www.orecan.fr/acces_donnees/', 6, 1, 4);
INSERT INTO si.media VALUES (29, 'Fichiers Mesures Horaires (µ)capteurs ASE', 'http://dx.doi.org/10.17632/82dnstrd93/1', 9, 1, 1);


--
-- TOC entry 3492 (class 0 OID 24992)
-- Dependencies: 233
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
INSERT INTO si.media_donnee VALUES (15, 22, 5, 13, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 56, 5, 9, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 7, 5, 13, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 33, 5, 8, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 35, 5, 9, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 24, 5, 11, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 8, 5, 9, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 49, 5, 9, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 9, 5, 11, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 6, 5, 8, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 23, 5, 9, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 21, 5, 8, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 26, 5, 13, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 28, 5, 11, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 25, 5, 8, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 27, 5, 9, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 30, 5, 13, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 32, 5, 11, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 31, 5, 9, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 29, 5, 8, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 34, 5, 13, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 36, 5, 11, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 47, 5, 11, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 48, 5, 13, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 60, 5, 13, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 62, 5, 8, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 64, 5, 9, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 65, 5, 13, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 46, 5, 13, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 53, 5, 13, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 54, 5, 11, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 55, 5, 8, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 96, 5, 13, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 97, 5, 11, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 98, 5, 9, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 99, 5, 8, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 91, 5, 15, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 92, 5, 15, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 93, 5, 15, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 94, 5, 15, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (15, 95, 5, 15, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (16, 17, 5, 7, 'Long');
INSERT INTO si.media_donnee VALUES (17, 17, 5, 7, NULL);
INSERT INTO si.media_donnee VALUES (18, 101, 5, 16, NULL);
INSERT INTO si.media_donnee VALUES (19, 2, 5, 15, 'J');
INSERT INTO si.media_donnee VALUES (20, 2, 5, 15, 'J');
INSERT INTO si.media_donnee VALUES (21, 103, 5, 8, 'J');
INSERT INTO si.media_donnee VALUES (22, 104, 5, 8, 'Mensuel');
INSERT INTO si.media_donnee VALUES (22, 21, 5, 8, 'Mensuel');
INSERT INTO si.media_donnee VALUES (23, 42, 5, 16, 'Annuel');
INSERT INTO si.media_donnee VALUES (15, 42, 5, 16, 'Plusieurs Années');
INSERT INTO si.media_donnee VALUES (24, 42, 5, 11, 'Plusieurs Années');
INSERT INTO si.media_donnee VALUES (25, 42, 5, 9, 'Plusieurs Années');
INSERT INTO si.media_donnee VALUES (26, 42, 5, 13, 'Plusieurs Années');
INSERT INTO si.media_donnee VALUES (27, 42, 5, 8, 'Plusieurs Années');
INSERT INTO si.media_donnee VALUES (24, 32, 5, 11, '5 Ans');
INSERT INTO si.media_donnee VALUES (24, 54, 5, 11, '5 Ans');
INSERT INTO si.media_donnee VALUES (24, 47, 5, 11, '5 Ans');
INSERT INTO si.media_donnee VALUES (24, 36, 5, 11, '5 Ans');
INSERT INTO si.media_donnee VALUES (24, 9, 5, 11, '5 Ans');
INSERT INTO si.media_donnee VALUES (24, 28, 5, 11, '5 Ans');
INSERT INTO si.media_donnee VALUES (24, 24, 5, 11, '5 Ans');
INSERT INTO si.media_donnee VALUES (24, 123, 5, 11, 'Plusieurs Annees');
INSERT INTO si.media_donnee VALUES (25, 56, 5, 9, '1 an glissant');
INSERT INTO si.media_donnee VALUES (25, 35, 5, 9, '1 an glissant');
INSERT INTO si.media_donnee VALUES (25, 8, 5, 9, '1 an glissant');
INSERT INTO si.media_donnee VALUES (25, 49, 5, 9, '1 an glissant');
INSERT INTO si.media_donnee VALUES (25, 23, 5, 9, '1 an glissant');
INSERT INTO si.media_donnee VALUES (25, 27, 5, 9, '1 an glissant');
INSERT INTO si.media_donnee VALUES (25, 31, 5, 9, '1 an glissant');
INSERT INTO si.media_donnee VALUES (25, 125, 5, 9, '1 an glissant');
INSERT INTO si.media_donnee VALUES (26, 22, 5, 13, '1 an glissant');
INSERT INTO si.media_donnee VALUES (26, 7, 5, 13, '1 an glissant');
INSERT INTO si.media_donnee VALUES (26, 26, 5, 13, '1 an glissant');
INSERT INTO si.media_donnee VALUES (26, 30, 5, 13, '1 an glissant');
INSERT INTO si.media_donnee VALUES (26, 34, 5, 13, '1 an glissant');
INSERT INTO si.media_donnee VALUES (26, 46, 5, 13, '1 an glissant');
INSERT INTO si.media_donnee VALUES (28, 173, 3, 11, '10 ans');
INSERT INTO si.media_donnee VALUES (26, 53, 5, 13, '1 an glissant');
INSERT INTO si.media_donnee VALUES (26, 124, 5, 13, '1 an glissant');
INSERT INTO si.media_donnee VALUES (27, 33, 5, 8, '1 an glissant');
INSERT INTO si.media_donnee VALUES (27, 6, 5, 8, '1 an glissant');
INSERT INTO si.media_donnee VALUES (27, 21, 5, 8, '1 an glissant');
INSERT INTO si.media_donnee VALUES (27, 25, 5, 8, '1 an glissant');
INSERT INTO si.media_donnee VALUES (27, 29, 5, 8, '1 an glissant');
INSERT INTO si.media_donnee VALUES (27, 55, 5, 8, '1 an glissant');
INSERT INTO si.media_donnee VALUES (27, 48, 5, 8, '1 an glissant');
INSERT INTO si.media_donnee VALUES (27, 126, 5, 8, '1 an glissant');
INSERT INTO si.media_donnee VALUES (29, 188, 5, 8, '6mois');


--
-- TOC entry 3494 (class 0 OID 25003)
-- Dependencies: 236
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
INSERT INTO si.media_publication VALUES (15, 1, 'Region', 'public');
INSERT INTO si.media_publication VALUES (16, 1, 'Region', 'public');
INSERT INTO si.media_publication VALUES (17, 5, 'Region', 'public');
INSERT INTO si.media_publication VALUES (16, 5, 'Region', 'public');
INSERT INTO si.media_publication VALUES (18, 1, 'Region', 'public');
INSERT INTO si.media_publication VALUES (21, 6, 'Region', 'Partenaire Industriel');
INSERT INTO si.media_publication VALUES (20, 7, 'Region', 'Partenaire Industriel');
INSERT INTO si.media_publication VALUES (19, 6, 'Region', 'Partenaire Industriel');
INSERT INTO si.media_publication VALUES (22, 8, 'Region', 'Partenaire Industriel');
INSERT INTO si.media_publication VALUES (24, 2, 'Region', 'public');
INSERT INTO si.media_publication VALUES (25, 2, 'Region', 'public');
INSERT INTO si.media_publication VALUES (26, 2, 'Region', 'public');
INSERT INTO si.media_publication VALUES (27, 2, 'Region', 'public');
INSERT INTO si.media_publication VALUES (28, 9, 'Region', 'public');
INSERT INTO si.media_publication VALUES (29, 10, 'Agglo Rouen', 'public');


--
-- TOC entry 3496 (class 0 OID 25021)
-- Dependencies: 240
-- Data for Name: perimetre_emi; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.perimetre_emi VALUES (NULL, 63, 'PCAET ORECAN');
INSERT INTO si.perimetre_emi VALUES (NULL, 64, 'PCAET ORECAN');
INSERT INTO si.perimetre_emi VALUES (NULL, 65, 'PCAET ORECAN');
INSERT INTO si.perimetre_emi VALUES (NULL, 66, 'PCAET ORECAN');
INSERT INTO si.perimetre_emi VALUES (NULL, 67, 'PCAET ORECAN');
INSERT INTO si.perimetre_emi VALUES (NULL, 68, 'PCAET ORECAN');
INSERT INTO si.perimetre_emi VALUES (NULL, 69, 'PCAET ORECAN');
INSERT INTO si.perimetre_emi VALUES (NULL, 70, 'PCAET ORECAN');
INSERT INTO si.perimetre_emi VALUES (NULL, 71, 'PCAET ORECAN');
INSERT INTO si.perimetre_emi VALUES (NULL, 72, 'PCAET ORECAN');
INSERT INTO si.perimetre_emi VALUES (NULL, 73, 'PCAET ORECAN');
INSERT INTO si.perimetre_emi VALUES (NULL, 74, 'PCAET ORECAN');
INSERT INTO si.perimetre_emi VALUES (NULL, 2, 'PCAET ORECAN');
INSERT INTO si.perimetre_emi VALUES (NULL, 3, 'PCAET ORECAN');
INSERT INTO si.perimetre_emi VALUES (NULL, 43, 'PCAET ORECAN');
INSERT INTO si.perimetre_emi VALUES (NULL, 5, 'PCAET ORECAN');
INSERT INTO si.perimetre_emi VALUES (NULL, 63, 'FULL EMI');
INSERT INTO si.perimetre_emi VALUES (NULL, 64, 'FULL EMI');
INSERT INTO si.perimetre_emi VALUES (NULL, 65, 'FULL EMI');
INSERT INTO si.perimetre_emi VALUES (NULL, 66, 'FULL EMI');
INSERT INTO si.perimetre_emi VALUES (NULL, 67, 'FULL EMI');
INSERT INTO si.perimetre_emi VALUES (NULL, 68, 'FULL EMI');
INSERT INTO si.perimetre_emi VALUES (NULL, 69, 'FULL EMI');
INSERT INTO si.perimetre_emi VALUES (NULL, 70, 'FULL EMI');
INSERT INTO si.perimetre_emi VALUES (NULL, 71, 'FULL EMI');
INSERT INTO si.perimetre_emi VALUES (NULL, 72, 'FULL EMI');
INSERT INTO si.perimetre_emi VALUES (NULL, 73, 'FULL EMI');
INSERT INTO si.perimetre_emi VALUES (NULL, 74, 'FULL EMI');
INSERT INTO si.perimetre_emi VALUES (NULL, 2, 'FULL EMI');
INSERT INTO si.perimetre_emi VALUES (NULL, 3, 'FULL EMI');
INSERT INTO si.perimetre_emi VALUES (NULL, 43, 'FULL EMI');
INSERT INTO si.perimetre_emi VALUES (NULL, 42, 'FULL EMI');
INSERT INTO si.perimetre_emi VALUES (NULL, 75, 'FULL EMI');
INSERT INTO si.perimetre_emi VALUES (NULL, 76, 'FULL EMI');
INSERT INTO si.perimetre_emi VALUES (NULL, 77, 'FULL EMI');
INSERT INTO si.perimetre_emi VALUES (NULL, 78, 'FULL EMI');
INSERT INTO si.perimetre_emi VALUES (NULL, 79, 'FULL EMI');
INSERT INTO si.perimetre_emi VALUES (NULL, 80, 'FULL EMI');
INSERT INTO si.perimetre_emi VALUES (NULL, 41, 'FULL EMI');
INSERT INTO si.perimetre_emi VALUES (NULL, 63, 'SIAM');
INSERT INTO si.perimetre_emi VALUES (NULL, 64, 'SIAM');
INSERT INTO si.perimetre_emi VALUES (NULL, 65, 'SIAM');
INSERT INTO si.perimetre_emi VALUES (NULL, 66, 'SIAM');
INSERT INTO si.perimetre_emi VALUES (NULL, 67, 'SIAM');
INSERT INTO si.perimetre_emi VALUES (NULL, 2, 'SIAM');
INSERT INTO si.perimetre_emi VALUES (NULL, 3, 'SIAM');
INSERT INTO si.perimetre_emi VALUES (NULL, 43, 'SIAM');
INSERT INTO si.perimetre_emi VALUES (NULL, 75, 'SIAM');
INSERT INTO si.perimetre_emi VALUES (NULL, 76, 'SIAM');
INSERT INTO si.perimetre_emi VALUES (NULL, 77, 'SIAM');
INSERT INTO si.perimetre_emi VALUES (NULL, 79, 'SIAM');
INSERT INTO si.perimetre_emi VALUES (NULL, 80, 'SIAM');
INSERT INTO si.perimetre_emi VALUES (NULL, 41, 'SIAM');
INSERT INTO si.perimetre_emi VALUES (NULL, 63, 'OpenData');
INSERT INTO si.perimetre_emi VALUES (NULL, 64, 'OpenData');
INSERT INTO si.perimetre_emi VALUES (NULL, 2, 'OpenData');
INSERT INTO si.perimetre_emi VALUES (NULL, 3, 'OpenData');
INSERT INTO si.perimetre_emi VALUES (NULL, 43, 'OpenData');
INSERT INTO si.perimetre_emi VALUES (NULL, 5, 'OpenData');
INSERT INTO si.perimetre_emi VALUES (NULL, 75, 'OpenData');
INSERT INTO si.perimetre_emi VALUES (NULL, 76, 'OpenData');
INSERT INTO si.perimetre_emi VALUES (NULL, 77, 'OpenData');
INSERT INTO si.perimetre_emi VALUES (NULL, 79, 'OpenData');
INSERT INTO si.perimetre_emi VALUES (NULL, 80, 'OpenData');
INSERT INTO si.perimetre_emi VALUES (NULL, 41, 'OpenData');
INSERT INTO si.perimetre_emi VALUES (NULL, 42, 'OpenData');
INSERT INTO si.perimetre_emi VALUES (NULL, 5, 'SIAM');


--
-- TOC entry 3485 (class 0 OID 24950)
-- Dependencies: 223
-- Data for Name: polluant; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.polluant VALUES (0, 'Aucun/Multi', NULL, '2023-05-15');
INSERT INTO si.polluant VALUES (38, 'Pollen Noisetier', NULL, '2023-05-25');
INSERT INTO si.polluant VALUES (39, 'Pollen Ambroisie', NULL, '2023-05-25');
INSERT INTO si.polluant VALUES (40, 'Pollen  Frene', NULL, '2023-05-25');
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
INSERT INTO si.polluant VALUES (50, 'PM1', NULL, '2023-06-05');
INSERT INTO si.polluant VALUES (51, 'Odeur', NULL, '2023-06-05');
INSERT INTO si.polluant VALUES (52, 'Temperature Extérieur', '54', '2023-06-06');
INSERT INTO si.polluant VALUES (53, 'Humidité relative', '58', '2023-06-06');
INSERT INTO si.polluant VALUES (54, 'Pression Atmosphérique', '53', '2023-06-06');
INSERT INTO si.polluant VALUES (55, 'Vitesse du Vent', '51', '2023-06-06');
INSERT INTO si.polluant VALUES (56, 'Direction du Vent', '52', '2023-06-06');
INSERT INTO si.polluant VALUES (57, 'Gradient Thermique', 'GT', '2023-06-06');
INSERT INTO si.polluant VALUES (58, 'Secteur SNAP', NULL, '2023-06-06');
INSERT INTO si.polluant VALUES (60, 'Secteur Secten', NULL, '2023-06-06');
INSERT INTO si.polluant VALUES (61, 'Secteur PCAET', NULL, '2023-06-06');
INSERT INTO si.polluant VALUES (62, 'Secteur ORECAN', NULL, '2023-06-06');
INSERT INTO si.polluant VALUES (63, 'COVNM', NULL, '2023-05-15');
INSERT INTO si.polluant VALUES (64, 'NH3', NULL, '2023-05-15');
INSERT INTO si.polluant VALUES (65, 'CO2', NULL, '2023-05-15');
INSERT INTO si.polluant VALUES (66, 'CH4', NULL, '2023-05-15');
INSERT INTO si.polluant VALUES (67, 'N2O', NULL, '2023-05-15');
INSERT INTO si.polluant VALUES (68, 'HFC', NULL, '2023-05-15');
INSERT INTO si.polluant VALUES (69, 'PFC', NULL, '2023-05-15');
INSERT INTO si.polluant VALUES (70, 'SF6', NULL, '2023-05-15');
INSERT INTO si.polluant VALUES (71, 'HCFC', NULL, '2023-05-15');
INSERT INTO si.polluant VALUES (72, 'NF3', NULL, '2023-05-15');
INSERT INTO si.polluant VALUES (73, 'C4F8', NULL, '2023-05-15');
INSERT INTO si.polluant VALUES (74, 'CFC', NULL, '2023-05-15');
INSERT INTO si.polluant VALUES (75, 'BAP', NULL, '2023-06-06');
INSERT INTO si.polluant VALUES (76, 'AS (emi)', NULL, '2023-06-06');
INSERT INTO si.polluant VALUES (77, 'CD (emi)', NULL, '2023-06-06');
INSERT INTO si.polluant VALUES (78, 'HG (emi)', NULL, '2023-06-06');
INSERT INTO si.polluant VALUES (79, 'NI (emi)', NULL, '2023-06-06');
INSERT INTO si.polluant VALUES (80, 'PB (emi)', NULL, '2023-06-06');


--
-- TOC entry 3486 (class 0 OID 24956)
-- Dependencies: 224
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
INSERT INTO si.proprietaire_objet VALUES (23, 'Extérieur Total', 'EXT');
INSERT INTO si.proprietaire_objet VALUES (19, 'Exterieur GEODAIR', 'EXT');
INSERT INTO si.proprietaire_objet VALUES (20, 'Exterieur SynAirGie', 'EXT');


--
-- TOC entry 3495 (class 0 OID 25008)
-- Dependencies: 237
-- Data for Name: publication; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.publication VALUES (1, 'Site Atmo Normandie', 1, 3);
INSERT INTO si.publication VALUES (2, 'Open Data', 1, 3);
INSERT INTO si.publication VALUES (3, 'Site Geodair', 1, 19);
INSERT INTO si.publication VALUES (4, 'Site SignalAir', 1, 20);
INSERT INTO si.publication VALUES (5, 'Site Intranet Atmo Normandie', 1, 3);
INSERT INTO si.publication VALUES (6, 'FTP Atmo Normandie', 1, 7);
INSERT INTO si.publication VALUES (7, 'SFTP Total', 1, 7);
INSERT INTO si.publication VALUES (8, 'Mail Mensuel Aux industriels ', 1, 14);
INSERT INTO si.publication VALUES (9, 'Site ORECAN', 1, 4);
INSERT INTO si.publication VALUES (10, 'Site ScienceDirect / Journal Data In Brief', 2, 7);


--
-- TOC entry 3500 (class 0 OID 25029)
-- Dependencies: 244
-- Data for Name: serveur; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.serveur VALUES (1, 'Serveur XR');
INSERT INTO si.serveur VALUES (2, 'Serveur Inventaire');
INSERT INTO si.serveur VALUES (3, 'Serveur SI');
INSERT INTO si.serveur VALUES (0, 'Inconnu');
INSERT INTO si.serveur VALUES (4, 'Serveur OpenData');
INSERT INTO si.serveur VALUES (5, 'Serveur TSE');
INSERT INTO si.serveur VALUES (6, 'Serveur BDD');
INSERT INTO si.serveur VALUES (7, 'Serveur ESRI ARCGIS');


--
-- TOC entry 3491 (class 0 OID 24983)
-- Dependencies: 231
-- Data for Name: type_media; Type: TABLE DATA; Schema: si; Owner: postgres
--

INSERT INTO si.type_media VALUES (1, 'Carte Dynamique');
INSERT INTO si.type_media VALUES (2, 'Carte Statique');
INSERT INTO si.type_media VALUES (3, 'Fichier Excel');
INSERT INTO si.type_media VALUES (4, 'Flux API');
INSERT INTO si.type_media VALUES (5, 'Flux Carto');
INSERT INTO si.type_media VALUES (6, 'DataViz');
INSERT INTO si.type_media VALUES (7, 'Tableau');
INSERT INTO si.type_media VALUES (8, 'Rapport Complet');
INSERT INTO si.type_media VALUES (9, 'Fichier Ascii');


--
-- TOC entry 3518 (class 0 OID 0)
-- Dependencies: 217
-- Name: application_id_application_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.application_id_application_seq', 11, true);


--
-- TOC entry 3519 (class 0 OID 0)
-- Dependencies: 226
-- Name: donnee_id_donnee_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.donnee_id_donnee_seq', 188, true);


--
-- TOC entry 3520 (class 0 OID 0)
-- Dependencies: 229
-- Name: etat_maturite_id_etat_maturite_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.etat_maturite_id_etat_maturite_seq', 1, true);


--
-- TOC entry 3521 (class 0 OID 0)
-- Dependencies: 221
-- Name: maille_geo_id_maille_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.maille_geo_id_maille_seq', 17, true);


--
-- TOC entry 3522 (class 0 OID 0)
-- Dependencies: 235
-- Name: media_id_media_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.media_id_media_seq', 29, true);


--
-- TOC entry 3523 (class 0 OID 0)
-- Dependencies: 241
-- Name: polluant_id_polluant_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.polluant_id_polluant_seq', 80, true);


--
-- TOC entry 3524 (class 0 OID 0)
-- Dependencies: 242
-- Name: proprietaire_objet_id_proprietaire_objet_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.proprietaire_objet_id_proprietaire_objet_seq', 23, true);


--
-- TOC entry 3525 (class 0 OID 0)
-- Dependencies: 243
-- Name: publication_id_publication_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.publication_id_publication_seq', 10, true);


--
-- TOC entry 3526 (class 0 OID 0)
-- Dependencies: 245
-- Name: serveur_id_serveur_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.serveur_id_serveur_seq', 7, true);


--
-- TOC entry 3527 (class 0 OID 0)
-- Dependencies: 246
-- Name: type_media_id_type_media_seq; Type: SEQUENCE SET; Schema: si; Owner: postgres
--

SELECT pg_catalog.setval('si.type_media_id_type_media_seq', 9, true);


--
-- TOC entry 3286 (class 2606 OID 25047)
-- Name: application application_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.application
    ADD CONSTRAINT application_pk PRIMARY KEY (id_application);


--
-- TOC entry 3288 (class 2606 OID 25049)
-- Name: donnee donnee_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee
    ADD CONSTRAINT donnee_pk PRIMARY KEY (id_donnee);


--
-- TOC entry 3290 (class 2606 OID 25051)
-- Name: etat_maturite etat_maturite_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.etat_maturite
    ADD CONSTRAINT etat_maturite_pk PRIMARY KEY (id_etat_maturite);


--
-- TOC entry 3292 (class 2606 OID 25053)
-- Name: maille_geo maille_geo_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.maille_geo
    ADD CONSTRAINT maille_geo_pk PRIMARY KEY (id_maille_geo);


--
-- TOC entry 3294 (class 2606 OID 25055)
-- Name: maille_temps maille_temps_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.maille_temps
    ADD CONSTRAINT maille_temps_pk PRIMARY KEY (id_maille_temps);


--
-- TOC entry 3304 (class 2606 OID 25057)
-- Name: media_donnee media_donnee_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media_donnee
    ADD CONSTRAINT media_donnee_pk PRIMARY KEY (id_media, id_donnee);


--
-- TOC entry 3300 (class 2606 OID 25059)
-- Name: media media_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media
    ADD CONSTRAINT media_pk PRIMARY KEY (id_media);


--
-- TOC entry 3296 (class 2606 OID 25061)
-- Name: polluant polluant_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.polluant
    ADD CONSTRAINT polluant_pk PRIMARY KEY (id_polluant);


--
-- TOC entry 3298 (class 2606 OID 25063)
-- Name: proprietaire_objet proprietaire_objet_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.proprietaire_objet
    ADD CONSTRAINT proprietaire_objet_pk PRIMARY KEY (id_proprietaire_objet);


--
-- TOC entry 3306 (class 2606 OID 25065)
-- Name: publication publication_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.publication
    ADD CONSTRAINT publication_pk PRIMARY KEY (id_publication);


--
-- TOC entry 3308 (class 2606 OID 25067)
-- Name: serveur serveur_pk; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.serveur
    ADD CONSTRAINT serveur_pk PRIMARY KEY (id_serveur);


--
-- TOC entry 3302 (class 2606 OID 25069)
-- Name: type_media type_media_pkey; Type: CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.type_media
    ADD CONSTRAINT type_media_pkey PRIMARY KEY (id_type_media);


--
-- TOC entry 3310 (class 2606 OID 25070)
-- Name: donnee appli_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee
    ADD CONSTRAINT appli_fk FOREIGN KEY (id_application) REFERENCES si.application(id_application);


--
-- TOC entry 3309 (class 2606 OID 25075)
-- Name: application application_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.application
    ADD CONSTRAINT application_fk FOREIGN KEY (id_serveur) REFERENCES si.serveur(id_serveur);


--
-- TOC entry 3311 (class 2606 OID 25080)
-- Name: donnee donnee_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee
    ADD CONSTRAINT donnee_fk FOREIGN KEY (id_maille_temps) REFERENCES si.maille_temps(id_maille_temps);


--
-- TOC entry 3321 (class 2606 OID 25085)
-- Name: media_donnee donnee_fk_1; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media_donnee
    ADD CONSTRAINT donnee_fk_1 FOREIGN KEY (id_donnee) REFERENCES si.donnee(id_donnee);


--
-- TOC entry 3316 (class 2606 OID 25090)
-- Name: donnee_lien donnee_lien_fk_cible; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee_lien
    ADD CONSTRAINT donnee_lien_fk_cible FOREIGN KEY (id_donnee_cible) REFERENCES si.donnee(id_donnee);


--
-- TOC entry 3317 (class 2606 OID 25095)
-- Name: donnee_lien donnee_lien_fk_source; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee_lien
    ADD CONSTRAINT donnee_lien_fk_source FOREIGN KEY (id_donnee_source) REFERENCES si.donnee(id_donnee);


--
-- TOC entry 3312 (class 2606 OID 25100)
-- Name: donnee maille_geo_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee
    ADD CONSTRAINT maille_geo_fk FOREIGN KEY (id_maille_geo) REFERENCES si.maille_geo(id_maille_geo);


--
-- TOC entry 3322 (class 2606 OID 25105)
-- Name: media_donnee maille_geo_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media_donnee
    ADD CONSTRAINT maille_geo_fk FOREIGN KEY (id_maille_geo_diff) REFERENCES si.maille_geo(id_maille_geo);


--
-- TOC entry 3313 (class 2606 OID 25110)
-- Name: donnee maturite_donnee_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee
    ADD CONSTRAINT maturite_donnee_fk FOREIGN KEY (id_etat_maturite) REFERENCES si.etat_maturite(id_etat_maturite);


--
-- TOC entry 3327 (class 2606 OID 25115)
-- Name: publication maturite_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.publication
    ADD CONSTRAINT maturite_fk FOREIGN KEY (id_maturite) REFERENCES si.etat_maturite(id_etat_maturite);


--
-- TOC entry 3318 (class 2606 OID 25120)
-- Name: media maturite_media_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media
    ADD CONSTRAINT maturite_media_fk FOREIGN KEY (id_maturite) REFERENCES si.etat_maturite(id_etat_maturite);


--
-- TOC entry 3323 (class 2606 OID 25125)
-- Name: media_donnee media_donnee_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media_donnee
    ADD CONSTRAINT media_donnee_fk FOREIGN KEY (id_maille_tempo_diff) REFERENCES si.maille_temps(id_maille_temps);


--
-- TOC entry 3324 (class 2606 OID 25130)
-- Name: media_donnee media_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media_donnee
    ADD CONSTRAINT media_fk FOREIGN KEY (id_media) REFERENCES si.media(id_media);


--
-- TOC entry 3325 (class 2606 OID 25135)
-- Name: media_publication media_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media_publication
    ADD CONSTRAINT media_fk FOREIGN KEY (id_media) REFERENCES si.media(id_media);


--
-- TOC entry 3326 (class 2606 OID 25140)
-- Name: media_publication media_publication_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media_publication
    ADD CONSTRAINT media_publication_fk FOREIGN KEY (id_publication) REFERENCES si.publication(id_publication);


--
-- TOC entry 3329 (class 2606 OID 25145)
-- Name: perimetre_emi perimetre_emi_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.perimetre_emi
    ADD CONSTRAINT perimetre_emi_fk FOREIGN KEY (id_polluant) REFERENCES si.polluant(id_polluant);


--
-- TOC entry 3314 (class 2606 OID 25150)
-- Name: donnee polluant_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee
    ADD CONSTRAINT polluant_fk FOREIGN KEY (id_polluant) REFERENCES si.polluant(id_polluant);


--
-- TOC entry 3315 (class 2606 OID 25155)
-- Name: donnee propriaitaire_donnee_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.donnee
    ADD CONSTRAINT propriaitaire_donnee_fk FOREIGN KEY (id_proprietaire_objet) REFERENCES si.proprietaire_objet(id_proprietaire_objet);


--
-- TOC entry 3319 (class 2606 OID 25160)
-- Name: media proprietaire_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media
    ADD CONSTRAINT proprietaire_fk FOREIGN KEY (id_proprietaire_objet) REFERENCES si.proprietaire_objet(id_proprietaire_objet);


--
-- TOC entry 3328 (class 2606 OID 25165)
-- Name: publication publication_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.publication
    ADD CONSTRAINT publication_fk FOREIGN KEY (id_proprietaire_objet) REFERENCES si.proprietaire_objet(id_proprietaire_objet);


--
-- TOC entry 3320 (class 2606 OID 25170)
-- Name: media type_media_fk; Type: FK CONSTRAINT; Schema: si; Owner: postgres
--

ALTER TABLE ONLY si.media
    ADD CONSTRAINT type_media_fk FOREIGN KEY (id_type_media) REFERENCES si.type_media(id_type_media);


-- Completed on 2023-06-06 15:23:51

--
-- PostgreSQL database dump complete
--

