--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

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
-- Name: estado_contrato_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.estado_contrato_enum AS ENUM (
    'ACTIVO',
    'FINALIZADO',
    'CANCELADO'
);


--
-- Name: estado_unidad_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.estado_unidad_enum AS ENUM (
    'DISPONIBLE',
    'OCUPADO',
    'MANTENIMIENTO'
);


--
-- Name: rol_usuario_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.rol_usuario_enum AS ENUM (
    'ADMIN',
    'SECRETARIO'
);


--
-- Name: tipo_inmueble_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.tipo_inmueble_enum AS ENUM (
    'RESIDENCIAL',
    'COMERCIAL',
    'INDUSTRIAL',
    'ESPECIAL'
);


--
-- Name: tipo_movimiento_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.tipo_movimiento_enum AS ENUM (
    'INGRESO',
    'GASTO'
);


--
-- Name: tipo_persona_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.tipo_persona_enum AS ENUM (
    'NATURAL',
    'JURIDICA'
);


SET default_table_access_method = heap;

--
-- Name: bancos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bancos (
    id integer NOT NULL,
    nombre character varying(255) NOT NULL
);


--
-- Name: bancos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bancos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bancos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bancos_id_seq OWNED BY public.bancos.id;


--
-- Name: conceptos_recibo; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.conceptos_recibo (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    obligatorio boolean DEFAULT false,
    activo boolean DEFAULT true
);


--
-- Name: conceptos_recibo_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.conceptos_recibo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: conceptos_recibo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.conceptos_recibo_id_seq OWNED BY public.conceptos_recibo.id;


--
-- Name: configuracion_negocio; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.configuracion_negocio (
    id integer NOT NULL,
    empresa character varying(150) NOT NULL,
    ruc character varying(20) NOT NULL,
    moneda character varying(10) DEFAULT 'PEN'::character varying,
    igv_porcentaje numeric(5,2),
    ipc_anual_actual numeric(5,2),
    CONSTRAINT configuracion_negocio_igv_porcentaje_check CHECK ((igv_porcentaje >= (0)::numeric))
);


--
-- Name: configuracion_negocio_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.configuracion_negocio_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: configuracion_negocio_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.configuracion_negocio_id_seq OWNED BY public.configuracion_negocio.id;


--
-- Name: contratos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contratos (
    id integer NOT NULL,
    inquilino_id integer NOT NULL,
    unidad_id integer NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_fin date,
    dia_pago integer,
    monto_renta numeric(38,2),
    moneda character varying(10) DEFAULT 'PEN'::character varying,
    estado public.estado_contrato_enum DEFAULT 'ACTIVO'::public.estado_contrato_enum,
    CONSTRAINT chk_fechas CHECK (((fecha_fin IS NULL) OR (fecha_fin > fecha_inicio))),
    CONSTRAINT contratos_dia_pago_check CHECK (((dia_pago >= 1) AND (dia_pago <= 31))),
    CONSTRAINT contratos_monto_renta_check CHECK ((monto_renta >= (0)::numeric))
);


--
-- Name: contratos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contratos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contratos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contratos_id_seq OWNED BY public.contratos.id;


--
-- Name: cuentas_bancarias; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cuentas_bancarias (
    id integer NOT NULL,
    codigo character varying(255) NOT NULL,
    banco_id integer NOT NULL,
    numero_cuenta character varying(255) NOT NULL,
    tipo character varying(255),
    moneda character varying(255) DEFAULT 'PEN'::character varying,
    saldo_actual numeric(38,2) DEFAULT 0,
    titular character varying(255)
);


--
-- Name: cuentas_bancarias_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cuentas_bancarias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cuentas_bancarias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cuentas_bancarias_id_seq OWNED BY public.cuentas_bancarias.id;


--
-- Name: inmuebles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inmuebles (
    id integer NOT NULL,
    nombre character varying(255) NOT NULL,
    tipo character varying(255) NOT NULL,
    direccion character varying(255),
    numero character varying(255),
    codigo_postal character varying(255),
    ciudad character varying(255),
    descripcion character varying(255),
    imagen_url character varying(255),
    activo boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: inmuebles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inmuebles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inmuebles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inmuebles_id_seq OWNED BY public.inmuebles.id;


--
-- Name: inquilinos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inquilinos (
    id integer NOT NULL,
    codigo character varying(255) NOT NULL,
    tipo_persona character varying(255) NOT NULL,
    nombre_completo character varying(255) NOT NULL,
    documento_identidad character varying(255),
    telefono character varying(255),
    email character varying(255),
    foto_url text,
    activo boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: inquilinos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inquilinos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inquilinos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inquilinos_id_seq OWNED BY public.inquilinos.id;


--
-- Name: movimientos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.movimientos (
    id integer NOT NULL,
    codigo character varying(255) NOT NULL,
    fecha date NOT NULL,
    tipo character varying(255) NOT NULL,
    categoria character varying(255),
    monto double precision,
    cuenta_id integer NOT NULL,
    inmueble_id integer,
    unidad_id integer,
    recibo_id integer,
    descripcion character varying(255),
    CONSTRAINT movimientos_monto_check CHECK ((monto > ((0)::numeric)::double precision))
);


--
-- Name: movimientos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.movimientos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: movimientos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.movimientos_id_seq OWNED BY public.movimientos.id;


--
-- Name: recibo_detalle; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recibo_detalle (
    id integer NOT NULL,
    recibo_id integer NOT NULL,
    concepto_id integer NOT NULL,
    importe numeric(12,2) DEFAULT 0,
    CONSTRAINT recibo_detalle_importe_check CHECK ((importe >= (0)::numeric))
);


--
-- Name: recibo_detalle_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.recibo_detalle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recibo_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.recibo_detalle_id_seq OWNED BY public.recibo_detalle.id;


--
-- Name: recibos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recibos (
    id integer NOT NULL,
    codigo character varying(255) NOT NULL,
    contrato_id integer NOT NULL,
    fecha_emision date NOT NULL,
    anio integer NOT NULL,
    mes integer,
    estado_cobro boolean DEFAULT false,
    total numeric(38,2),
    CONSTRAINT recibos_mes_check CHECK (((mes >= 1) AND (mes <= 12))),
    CONSTRAINT recibos_total_check CHECK ((total >= (0)::numeric))
);


--
-- Name: recibos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.recibos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recibos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.recibos_id_seq OWNED BY public.recibos.id;


--
-- Name: unidades; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.unidades (
    id integer NOT NULL,
    inmueble_id integer NOT NULL,
    tipo character varying(255) NOT NULL,
    planta character varying(255),
    codigo character varying(255),
    estado character varying(255) DEFAULT 'DISPONIBLE'::public.estado_unidad_enum,
    activo boolean DEFAULT true
);


--
-- Name: unidades_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.unidades_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: unidades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.unidades_id_seq OWNED BY public.unidades.id;


--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.usuarios (
    id integer NOT NULL,
    nombre character varying(255) NOT NULL,
    apellido character varying(255),
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    rol character varying(255) NOT NULL,
    activo boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;


--
-- Name: vw_recibo_cabecera; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.vw_recibo_cabecera AS
 SELECT r.id AS recibo_id,
    r.codigo AS numero_recibo,
    r.fecha_emision,
    r.anio,
    r.mes,
    r.estado_cobro,
    r.total,
    c.id AS contrato_id,
    i.nombre_completo AS inquilino,
    i.documento_identidad,
    u.codigo AS unidad_codigo,
    u.tipo AS unidad_tipo,
    im.nombre AS inmueble,
    im.direccion
   FROM ((((public.recibos r
     JOIN public.contratos c ON ((c.id = r.contrato_id)))
     JOIN public.inquilinos i ON ((i.id = c.inquilino_id)))
     JOIN public.unidades u ON ((u.id = c.unidad_id)))
     JOIN public.inmuebles im ON ((im.id = u.inmueble_id)));


--
-- Name: bancos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bancos ALTER COLUMN id SET DEFAULT nextval('public.bancos_id_seq'::regclass);


--
-- Name: conceptos_recibo id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conceptos_recibo ALTER COLUMN id SET DEFAULT nextval('public.conceptos_recibo_id_seq'::regclass);


--
-- Name: configuracion_negocio id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.configuracion_negocio ALTER COLUMN id SET DEFAULT nextval('public.configuracion_negocio_id_seq'::regclass);


--
-- Name: contratos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contratos ALTER COLUMN id SET DEFAULT nextval('public.contratos_id_seq'::regclass);


--
-- Name: cuentas_bancarias id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cuentas_bancarias ALTER COLUMN id SET DEFAULT nextval('public.cuentas_bancarias_id_seq'::regclass);


--
-- Name: inmuebles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inmuebles ALTER COLUMN id SET DEFAULT nextval('public.inmuebles_id_seq'::regclass);


--
-- Name: inquilinos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inquilinos ALTER COLUMN id SET DEFAULT nextval('public.inquilinos_id_seq'::regclass);


--
-- Name: movimientos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.movimientos ALTER COLUMN id SET DEFAULT nextval('public.movimientos_id_seq'::regclass);


--
-- Name: recibo_detalle id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recibo_detalle ALTER COLUMN id SET DEFAULT nextval('public.recibo_detalle_id_seq'::regclass);


--
-- Name: recibos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recibos ALTER COLUMN id SET DEFAULT nextval('public.recibos_id_seq'::regclass);


--
-- Name: unidades id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unidades ALTER COLUMN id SET DEFAULT nextval('public.unidades_id_seq'::regclass);


--
-- Name: usuarios id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);


--
-- Data for Name: bancos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.bancos (id, nombre) FROM stdin;
1	BCP
2	BBVA
\.


--
-- Data for Name: conceptos_recibo; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.conceptos_recibo (id, nombre, obligatorio, activo) FROM stdin;
1	renta	t	t
2	agua	f	t
3	luz	f	t
4	mantenimiento	f	t
5	ipc_anual	f	t
6	igv	t	t
7	otros	f	t
\.


--
-- Data for Name: configuracion_negocio; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.configuracion_negocio (id, empresa, ruc, moneda, igv_porcentaje, ipc_anual_actual) FROM stdin;
1	RentAltoke Inmobiliaria	20123456789	PEN	18.00	3.50
\.


--
-- Data for Name: contratos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.contratos (id, inquilino_id, unidad_id, fecha_inicio, fecha_fin, dia_pago, monto_renta, moneda, estado) FROM stdin;
1	1	102	2025-05-01	2026-05-01	5	1200.00	PEN	ACTIVO
2	1	201	2025-06-01	2026-06-01	5	1500.00	PEN	ACTIVO
3	2	301	2024-10-15	2026-10-15	30	4500.00	PEN	ACTIVO
20	2	302	2025-01-01	2026-01-01	5	2500.00	PEN	ACTIVO
5	3	201	2025-01-10	2026-01-10	1	2800.00	PEN	FINALIZADO
6	11	202	2025-01-01	2026-01-01	5	1300.00	PEN	ACTIVO
7	7	701	2025-11-20	2026-11-20	5	3500.00	PEN	ACTIVO
8	4	301	2024-03-20	2026-03-20	15	5500.00	PEN	FINALIZADO
10	6	501	2023-12-01	2026-12-01	28	8500.00	PEN	ACTIVO
11	6	1401	2025-04-01	2027-04-01	28	9000.00	PEN	ACTIVO
12	8	802	2024-02-15	2026-02-15	20	6000.00	PEN	FINALIZADO
14	10	703	2026-04-10	2027-04-10	1	3200.00	PEN	ACTIVO
4	3	201	2025-01-10	2025-05-31	1	2800.00	PEN	FINALIZADO
100	5	402	2026-01-01	2027-01-01	5	3000.00	PEN	ACTIVO
101	8	601	2026-02-01	2027-02-01	10	4200.00	PEN	ACTIVO
102	12	802	2026-03-01	2027-03-01	15	3800.00	PEN	ACTIVO
200	5	602	2026-05-01	2027-05-01	5	2800.00	PEN	ACTIVO
201	12	801	2026-06-01	2027-06-01	10	3500.00	PEN	ACTIVO
300	3	901	2026-05-01	2027-05-01	5	4800.00	PEN	ACTIVO
301	3	902	2026-05-01	2027-05-01	5	4700.00	PEN	ACTIVO
303	9	1102	2026-06-01	2027-06-01	10	6200.00	PEN	ACTIVO
302	9	1001	2026-06-01	2027-06-01	10	6500.00	PEN	ACTIVO
13	12	1101	2026-03-01	2027-03-01	10	2000.00	PEN	ACTIVO
9	4	1202	2025-02-01	2027-02-01	15	6000.00	PEN	ACTIVO
\.


--
-- Data for Name: cuentas_bancarias; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cuentas_bancarias (id, codigo, banco_id, numero_cuenta, tipo, moneda, saldo_actual, titular) FROM stdin;
1	CTA-001	1	191-99887766-0-11	CORRIENTE	PEN	25400.50	RentAltoke Inmobiliaria
2	CTA-002	2	0011-0445-02001234	AHORROS	PEN	12150.00	RentAltoke Inmobiliaria
\.


--
-- Data for Name: inmuebles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inmuebles (id, nombre, tipo, direccion, numero, codigo_postal, ciudad, descripcion, imagen_url, activo, created_at) FROM stdin;
1	Residencial Lima Centro	RESIDENCIAL	Av. Arequipa	123	15001	Lima	Edificio moderno con departamentos familiares	/inmuebles/11.jpg	t	2026-04-22 22:37:33.724373
2	Residencial Miraflores	RESIDENCIAL	Av. Larco	456	15074	Lima	Zona exclusiva cerca al mar	/inmuebles/12.jpg	t	2026-04-22 22:37:33.724373
3	Centro Comercial Norte	COMERCIAL	Panamericana Norte	789	15100	Lima	Locales comerciales con alto flujo	/inmuebles/21.jpg	t	2026-04-22 22:37:33.724373
4	GalerÃ­a Empresarial	COMERCIAL	San Isidro	321	15046	Lima	Oficinas y locales premium	/inmuebles/22.jpg	t	2026-04-22 22:37:33.724373
5	Parque Industrial Sur	INDUSTRIAL	Villa El Salvador	555	15800	Lima	Espacios amplios para fÃ¡bricas	/inmuebles/31.jpg	t	2026-04-22 23:21:44.511887
6	Almacenes LogÃ­sticos	INDUSTRIAL	Callao	888	07001	Callao	Ideal para distribuciÃ³n	/inmuebles/32.jpg	t	2026-04-22 23:21:44.511887
7	Hospital Privado	ESPECIAL	Surco	222	15023	Lima	Infraestructura mÃ©dica completa	/inmuebles/41.jpg	t	2026-04-22 23:21:44.511887
8	Hospital San Juan de Dios	ESPECIAL	San Miguel	999	15087	Lima	Instalaciones de Salud	/inmuebles/42.jpg	t	2026-04-22 23:21:44.511887
9	Residencial Los Olivos	RESIDENCIAL	Av. Universitaria	1500	15301	Lima	Departamentos familiares en zona tranquila	/inmuebles/13.jpg	t	2026-04-22 23:21:44.511887
10	Residencial San Borja	RESIDENCIAL	Av. AviaciÃ³n	2400	15036	Lima	Edificio moderno cerca a parques	/inmuebles/14.jpg	t	2026-04-22 23:21:44.511887
11	Centro Comercial Sur	COMERCIAL	Av. PrÃ³ceres	880	15801	Lima	Locales comerciales en zona de alto trÃ¡nsito	/inmuebles/23.jpg	t	2026-04-22 23:21:44.511887
12	Centro Comercial Ventura	COMERCIAL	Av. La Marina	1800	15088	Lima	Centro comercial moderno con mÃºltiples tiendas	/inmuebles/24.jpg	t	2026-04-22 23:21:44.511887
13	Zona Industrial Ate	INDUSTRIAL	Carretera Central	450	15498	Lima	Espacios industriales para manufactura	/inmuebles/34.jpg	t	2026-04-22 23:21:44.511887
14	Complejo Industrial Norte	INDUSTRIAL	Panamericana Norte	1200	15105	Lima	Parque industrial con acceso logÃ­stico	/inmuebles/35.jpg	t	2026-04-22 23:21:44.511887
15	Parque LogÃ­stico Callao	INDUSTRIAL	Zona Portuaria	300	07001	Callao	Almacenes estratÃ©gicos para importaciÃ³n/exportaciÃ³n	/inmuebles/36.jpg	t	2026-04-22 23:21:44.511887
16	Colegio San MartÃ­n	ESPECIAL	Surco	111	15023	Lima	Infraestructura educativa moderna	/inmuebles/43.jpg	t	2026-04-22 23:21:44.511887
17	Museo Nacional	ESPECIAL	Centro HistÃ³rico	500	15001	Lima	Museo cultural con exposiciones permanentes	/inmuebles/44.jpg	t	2026-04-22 23:21:44.511887
18	Museo de Arte ContemporÃ¡neo	ESPECIAL	Barranco	250	15063	Lima	Espacio moderno de arte y cultura	/inmuebles/45.jpg	t	2026-04-22 23:21:44.511887
\.


--
-- Data for Name: inquilinos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inquilinos (id, codigo, tipo_persona, nombre_completo, documento_identidad, telefono, email, foto_url, activo, created_at) FROM stdin;
1	EXT-INQ-001	NATURAL	Carlos Alberto Ruiz	45678912	999888777	carlos.ruiz@gmail.com	\N	t	2026-04-22 22:40:53.036911
2	EXT-INQ-002	JURIDICA	CorporaciÃ³n LogÃ­stica S.A.	20556677881	01-5554433	pagos@corplogistica.com.pe	\N	t	2026-04-22 22:40:53.036911
3	EXT-INQ-003	NATURAL	Ana LucÃ­a Mendoza	70123456	912333444	ana.mendoza@outlook.com	\N	t	2026-04-22 22:40:53.036911
4	EXT-INQ-004	JURIDICA	Minimarket El Norte E.I.R.L.	20109988774	\N	\N	\N	t	2026-04-22 23:27:49.850724
5	EXT-INQ-005	NATURAL	Roberto GÃ³mez BolaÃ±os	\N	\N	\N	\N	t	2026-04-22 23:27:49.850724
6	EXT-INQ-006	JURIDICA	Constructora Delta S.A.	\N	\N	\N	\N	t	2026-04-22 23:27:49.850724
7	EXT-INQ-007	NATURAL	Mariana de la Jara	\N	\N	\N	\N	t	2026-04-22 23:27:49.850724
8	EXT-INQ-008	JURIDICA	EducaPlus PerÃº S.A.C.	\N	\N	\N	\N	t	2026-04-22 23:27:49.850724
9	EXT-INQ-009	NATURAL	Ricardo Gareca Nardi	\N	\N	\N	\N	t	2026-04-22 23:27:49.850724
10	EXT-INQ-010	NATURAL	Paolo Guerrero Gonzales	\N	\N	\N	\N	t	2026-04-22 23:27:49.850724
11	EXT-INQ-011	NATURAL	Luis Torres Vega	44556677	987654321	luis@gmail.com	\N	t	2026-04-22 23:27:49.850724
12	EXT-INQ-012	NATURAL	Andrea Paredes	77889966	912000111	andrea@gmail.com	\N	t	2026-04-22 23:27:49.850724
23	EXT-INQ-014	NATURAL	Alvarez Perez	76746830	982160450	algo@gmail.com	\N	\N	2026-06-10 10:46:23.033416
\.


--
-- Data for Name: movimientos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.movimientos (id, codigo, fecha, tipo, categoria, monto, cuenta_id, inmueble_id, unidad_id, recibo_id, descripcion) FROM stdin;
1	MOV-2026-001	2026-04-05	INGRESO	PAGO_RECIBO_MENSUAL	1200	1	1	102	\N	Cobro recibo Abril
2	MOV-2026-002	2026-04-06	GASTO	REPARACION	350	1	2	202	\N	ReparaciÃ³n ascensor
3	MOV-2026-003	2026-04-07	GASTO	PERSONAL	1500	2	2	201	\N	Pago limpieza
254	MOV-2026-200	2026-04-02	INGRESO	ALQUILER	1200	1	1	102	\N	Pago alquiler - Residencial Lima Centro
255	MOV-2026-201	2026-04-10	GASTO	MANTENIMIENTO	300	1	1	102	\N	ReparaciÃ³n ducha
256	MOV-2026-202	2026-04-18	GASTO	SERVICIOS	150	2	1	102	\N	Pago agua
257	MOV-2026-203	2026-04-05	INGRESO	ALQUILER	2500	1	2	201	\N	Pago alquiler dÃºplex - Miraflores
258	MOV-2026-204	2026-04-12	GASTO	REPARACION	400	2	2	201	\N	Arreglo cocina
259	MOV-2026-205	2026-04-20	GASTO	SERVICIOS	220	1	2	201	\N	Pago luz
260	MOV-2026-206	2026-04-03	INGRESO	ALQUILER	5000	1	3	301	\N	Alquiler local ancla
261	MOV-2026-207	2026-04-11	GASTO	SEGURIDAD	800	2	3	301	\N	Servicio vigilancia
262	MOV-2026-208	2026-04-19	GASTO	LIMPIEZA	300	1	3	301	\N	Limpieza local
10	MOV-2026-010	2026-04-15	INGRESO	ALQUILER	3000	1	14	1401	\N	Pago alquiler oficina
11	MOV-2026-011	2026-04-18	INGRESO	ALQUILER	1800	2	8	802	\N	Pago alquiler consultorio
12	MOV-2026-012	2026-04-20	GASTO	MANTENIMIENTO	900	1	11	1101	\N	ReparaciÃ³n tuberÃ­as
13	MOV-2026-013	2026-04-22	GASTO	SERVICIOS	600	2	7	703	\N	Pago electricidad edificio
263	MOV-2026-209	2026-04-04	INGRESO	ALQUILER	1800	1	3	302	\N	Alquiler mÃ³dulo
264	MOV-2026-210	2026-04-14	GASTO	MANTENIMIENTO	450	2	3	302	\N	ReparaciÃ³n stand
265	MOV-2026-211	2026-04-22	GASTO	SERVICIOS	200	1	3	302	\N	Pago electricidad
266	MOV-2026-212	2026-04-02	INGRESO	ALQUILER	1300	1	9	901	\N	Alquiler departamento
267	MOV-2026-213	2026-04-09	GASTO	MANTENIMIENTO	200	1	9	901	\N	Pintura paredes
268	MOV-2026-214	2026-04-17	GASTO	SERVICIOS	120	2	9	901	\N	Pago agua
269	MOV-2026-215	2026-04-06	INGRESO	ALQUILER	1400	1	9	902	\N	Alquiler departamento
270	MOV-2026-216	2026-04-15	GASTO	REPARACION	350	2	9	902	\N	ReparaciÃ³n baÃ±o
271	MOV-2026-217	2026-04-23	GASTO	SERVICIOS	130	1	9	902	\N	Pago luz
272	MOV-2026-218	2026-04-01	INGRESO	ALQUILER	2200	1	12	1202	\N	Alquiler restaurante
273	MOV-2026-219	2026-04-10	GASTO	LIMPIEZA	250	2	12	1202	\N	Limpieza local
274	MOV-2026-220	2026-04-21	GASTO	SERVICIOS	400	1	12	1202	\N	Pago agua y luz
275	MOV-2026-221	2026-04-03	INGRESO	ALQUILER	900	1	4	402	\N	Alquiler consultorio
276	MOV-2026-222	2026-04-13	GASTO	SERVICIOS	180	2	4	402	\N	Pago electricidad
277	MOV-2026-223	2026-04-20	GASTO	MANTENIMIENTO	220	1	4	402	\N	ReparaciÃ³n aire
278	MOV-2026-224	2026-04-05	INGRESO	ALQUILER	3000	1	6	602	\N	Alquiler depÃ³sito
279	MOV-2026-225	2026-04-14	GASTO	LOGISTICA	600	2	6	602	\N	Transporte mercancÃ­a
280	MOV-2026-226	2026-04-25	GASTO	MANTENIMIENTO	500	1	6	602	\N	RevisiÃ³n estructura
281	MOV-2026-227	2026-04-02	INGRESO	ALQUILER	4500	1	14	1401	\N	Alquiler depÃ³sito industrial
282	MOV-2026-228	2026-04-11	GASTO	MAQUINARIA	1200	2	14	1401	\N	Mantenimiento maquinaria
283	MOV-2026-229	2026-04-19	GASTO	LOGISTICA	700	1	14	1401	\N	Transporte insumos
284	MOV-2026-230	2026-04-06	INGRESO	ALQUILER	3800	1	5	501	\N	Alquiler nave industrial
285	MOV-2026-231	2026-04-15	GASTO	MANTENIMIENTO	900	2	5	501	\N	ReparaciÃ³n techado
286	MOV-2026-232	2026-04-24	GASTO	MAQUINARIA	650	1	5	501	\N	RevisiÃ³n equipos
287	MOV-2026-233	2026-04-04	INGRESO	ALQUILER	5000	1	7	701	\N	Uso quirÃ³fano
288	MOV-2026-234	2026-04-12	GASTO	INSUMOS	800	2	7	701	\N	Compra insumos mÃ©dicos
289	MOV-2026-235	2026-04-21	GASTO	SERVICIOS	300	1	7	701	\N	Pago electricidad
290	MOV-2026-236	2026-04-03	INGRESO	ALQUILER	2600	1	6	601	\N	Alquiler almacÃ©n
291	MOV-2026-237	2026-04-14	GASTO	LOGISTICA	400	2	6	601	\N	Transporte materiales
292	MOV-2026-238	2026-04-23	GASTO	MANTENIMIENTO	350	1	6	601	\N	RevisiÃ³n cÃ¡maras
293	MOV-2026-239	2026-04-02	INGRESO	ALQUILER	1500	1	10	1001	\N	Alquiler departamento
294	MOV-2026-240	2026-04-11	GASTO	SERVICIOS	200	2	10	1001	\N	Pago luz
295	MOV-2026-241	2026-04-20	GASTO	MANTENIMIENTO	250	1	10	1001	\N	ReparaciÃ³n cocina
296	MOV-2026-242	2026-04-05	INGRESO	ALQUILER	2100	1	11	1102	\N	Alquiler mÃ³dulo
297	MOV-2026-243	2026-04-16	GASTO	LIMPIEZA	300	2	11	1102	\N	Limpieza local
298	MOV-2026-244	2026-04-25	GASTO	SERVICIOS	280	1	11	1102	\N	Pago agua
299	MOV-2026-245	2026-04-06	INGRESO	ALQUILER	1800	1	7	703	\N	Uso Ã¡rea emergencias
300	MOV-2026-246	2026-04-13	GASTO	INSUMOS	400	2	7	703	\N	Material mÃ©dico
301	MOV-2026-247	2026-04-22	GASTO	SERVICIOS	220	1	7	703	\N	Pago electricidad
302	MOV-2026-248	2026-04-04	INGRESO	ALQUILER	1400	1	2	202	\N	Alquiler departamento
303	MOV-2026-249	2026-04-12	GASTO	MANTENIMIENTO	300	2	2	202	\N	ReparaciÃ³n baÃ±o
304	MOV-2026-250	2026-04-21	GASTO	SERVICIOS	180	1	2	202	\N	Pago agua
305	MOV-2026-251	2026-04-03	INGRESO	ALQUILER	3200	1	8	801	\N	Uso sala de partos
306	MOV-2026-252	2026-04-12	GASTO	INSUMOS	700	2	8	801	\N	Material mÃ©dico
307	MOV-2026-253	2026-04-20	GASTO	SERVICIOS	300	1	8	801	\N	Pago electricidad
308	MOV-2026-254	2026-04-05	INGRESO	ALQUILER	2800	1	8	802	\N	Uso laboratorio
309	MOV-2026-255	2026-04-14	GASTO	INSUMOS	600	2	8	802	\N	Reactivos
310	MOV-2026-256	2026-04-23	GASTO	MANTENIMIENTO	350	1	8	802	\N	RevisiÃ³n equipos
311	MOV-2026-257	2026-04-06	INGRESO	ALQUILER	2600	1	11	1101	\N	Alquiler local
312	MOV-2026-258	2026-04-15	GASTO	LIMPIEZA	320	2	11	1101	\N	Limpieza local
313	MOV-2026-259	2026-04-24	GASTO	SERVICIOS	290	1	11	1101	\N	Pago agua/luz
\.


--
-- Data for Name: recibo_detalle; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.recibo_detalle (id, recibo_id, concepto_id, importe) FROM stdin;
1	1	1	1200.00
2	1	2	45.50
3	1	3	80.20
4	1	6	234.00
5	2	1	4500.00
6	2	3	320.00
7	2	6	810.00
8	3	1	2800.00
9	3	2	60.00
10	3	3	110.00
11	3	6	504.00
27	37	1	1020.00
28	37	6	183.60
29	37	2	20.00
30	38	1	1275.00
31	38	6	229.50
32	38	2	20.00
33	39	1	3825.00
34	39	6	688.50
35	39	2	20.00
36	40	1	2975.00
37	40	6	535.50
38	40	2	20.00
39	41	1	7225.00
40	41	6	1300.50
41	41	2	20.00
42	42	1	7650.00
43	42	6	1377.00
44	42	2	20.00
45	43	1	2720.00
46	43	6	489.60
47	43	2	20.00
48	44	1	2550.00
49	44	6	459.00
50	44	2	20.00
51	45	1	3570.00
52	45	6	642.60
53	45	2	20.00
54	46	1	3230.00
55	46	6	581.40
56	46	2	20.00
57	47	1	2380.00
58	47	6	428.40
59	47	2	20.00
60	48	1	4080.00
61	48	6	734.40
62	48	2	20.00
63	49	1	3995.00
64	49	6	719.10
65	49	2	20.00
66	50	1	1700.00
67	50	6	306.00
68	50	2	20.00
69	51	1	5100.00
70	51	6	918.00
71	51	2	20.00
72	52	1	1750.00
73	52	2	125.00
74	52	3	125.00
75	52	4	125.00
76	52	5	125.00
77	52	6	315.00
78	53	1	910.00
79	53	2	65.00
80	53	3	65.00
81	53	4	65.00
82	53	5	65.00
83	53	6	163.80
84	54	1	2450.00
85	54	2	175.00
86	54	3	175.00
87	54	4	175.00
88	54	5	175.00
89	54	6	441.00
90	55	1	4340.00
91	55	2	310.00
92	55	3	310.00
93	55	4	310.00
94	55	5	310.00
95	55	6	781.20
96	56	1	4550.00
97	56	2	325.00
98	56	3	325.00
99	56	4	325.00
100	56	5	325.00
101	56	6	819.00
102	10	3	136.86
103	10	4	178.45
104	10	5	57.31
105	10	7	54.79
106	11	3	91.17
107	11	4	146.03
108	11	5	65.66
109	11	7	22.99
110	12	3	107.83
111	12	4	197.70
112	12	5	85.34
113	12	7	57.39
114	20	3	113.50
115	20	4	171.13
116	20	5	72.15
117	20	7	30.29
118	37	3	98.49
119	37	4	187.13
120	37	5	59.05
121	37	7	38.25
122	39	3	128.18
123	39	4	183.19
124	39	5	92.99
125	39	7	29.32
126	42	3	114.54
127	42	4	147.78
128	42	5	65.23
129	42	7	59.73
130	43	3	101.53
131	43	4	112.94
132	43	5	80.27
133	43	7	39.19
134	45	3	114.86
135	45	4	153.54
136	45	5	85.96
137	45	7	54.56
138	46	3	126.85
139	46	4	198.39
140	46	5	61.28
141	46	7	58.18
142	48	3	133.37
143	48	4	129.14
144	48	5	84.12
145	48	7	25.77
146	50	3	131.85
147	50	4	107.38
148	50	5	78.40
149	50	7	35.92
\.


--
-- Data for Name: recibos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.recibos (id, codigo, contrato_id, fecha_emision, anio, mes, estado_cobro, total) FROM stdin;
11	REC-2026-02-011	1	2026-02-01	2026	2	f	325.85
20	REC-2026-01-020	20	2026-01-01	2026	1	f	387.07
10	REC-2026-03-010	1	2026-03-01	2026	3	f	427.41
12	REC-2026-04-012	2	2026-04-01	2026	4	f	448.26
39	REC-2026-05-003	3	2026-05-30	2026	5	f	4967.18
42	REC-2026-05-011	11	2026-05-28	2026	5	f	9434.28
50	REC-2026-05-013	13	2026-05-10	2026	5	f	2379.55
46	REC-2026-05-102	102	2026-05-15	2026	5	f	4276.10
43	REC-2026-05-014	14	2026-05-01	2026	5	f	3563.53
37	REC-2026-05-001	1	2026-05-05	2026	5	f	1606.52
45	REC-2026-05-101	101	2026-05-10	2026	5	f	4641.52
48	REC-2026-05-300	300	2026-05-05	2026	5	f	5206.80
1	REC-2026-04-001	1	2026-04-01	2026	4	t	1559.70
2	REC-2026-04-002	3	2026-04-01	2026	4	t	5630.00
3	REC-2026-04-003	4	2026-04-01	2026	4	f	3474.00
38	REC-2026-05-002	2	2026-05-05	2026	5	f	1524.50
40	REC-2026-05-007	7	2026-05-05	2026	5	f	3530.50
41	REC-2026-05-010	10	2026-05-28	2026	5	f	8545.50
44	REC-2026-05-100	100	2026-05-05	2026	5	f	3029.00
47	REC-2026-05-200	200	2026-05-05	2026	5	f	2828.40
49	REC-2026-05-301	301	2026-05-05	2026	5	f	4734.10
51	REC-2026-05-009	9	2026-05-15	2026	5	f	6038.00
52	REC-2026-05-0020	20	2026-05-05	2026	5	f	2565.00
53	REC-2026-05-0006	6	2026-05-05	2026	5	f	1333.80
54	REC-2026-05-0201	201	2026-05-10	2026	5	f	3591.00
55	REC-2026-05-0303	303	2026-05-10	2026	5	f	6361.20
56	REC-2026-05-0302	302	2026-05-10	2026	5	f	6669.00
\.


--
-- Data for Name: unidades; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.unidades (id, inmueble_id, tipo, planta, codigo, estado, activo) FROM stdin;
502	5	Taller	1	T-12	MANTENIMIENTO	t
803	8	Sala de Emergencias	1	C	MANTENIMIENTO	t
1002	10	Penthouse	8	A	MANTENIMIENTO	t
1402	14	Taller	1	T-02	MANTENIMIENTO	t
1802	18	Sala VIP	2	VIP	MANTENIMIENTO	t
102	1	Departamento	1	102	OCUPADO	t
201	2	Duplex	4	401	OCUPADO	t
301	3	Local Ancla	1	L-01	OCUPADO	t
402	4	Consultorio	2	210	OCUPADO	t
501	5	Nave Industrial	1	N-01	OCUPADO	t
601	6	AlmacÃ©n FrÃ­o	1	A-01	OCUPADO	t
602	6	DepÃ³sito Aduanero	1	D-05	OCUPADO	t
701	7	QuirÃ³fano	3	Q-1	OCUPADO	t
703	7	Emergencias	1	E-01	OCUPADO	t
801	8	Sala de Partos	1	A	OCUPADO	t
802	8	Laboratorio	2	B	OCUPADO	t
901	9	Departamento	1	101	OCUPADO	t
902	9	Departamento	2	201	OCUPADO	t
1001	10	Departamento	3	301	OCUPADO	t
1102	11	MÃ³dulo	1	M-02	OCUPADO	t
1202	12	Restaurante	2	R-05	OCUPADO	t
1401	14	DepÃ³sito	1	D-01	OCUPADO	t
202	2	Departamento	2	205	OCUPADO	t
302	3	MÃ³dulo	1	M-05	OCUPADO	t
1101	11	Local	1	L-01	OCUPADO	t
101	1	Departamento	1	101	DISPONIBLE	t
401	4	Oficina	5	502	DISPONIBLE	t
702	7	HabitaciÃ³n VIP	4	405	DISPONIBLE	t
1201	12	Tienda	1	T-01	DISPONIBLE	t
1301	13	Nave Industrial	1	N-01	DISPONIBLE	t
1502	15	DepÃ³sito	1	D-02	DISPONIBLE	t
1601	16	Aula	1	A	DISPONIBLE	t
1702	17	Auditorio	2	B	DISPONIBLE	t
39	1	Departamento	2	201	DISPONIBLE	t
41	9	Departamento	3	302	DISPONIBLE	t
44	3	Restaurante	2	R-20	DISPONIBLE	t
46	11	Local Comercial	1	LC-15	DISPONIBLE	t
49	6	AlmacÃ©n	1	AL-10	DISPONIBLE	t
51	14	Taller	1	TL-07	DISPONIBLE	t
54	7	QuirÃ³fano	3	Q-02	DISPONIBLE	t
56	16	Aula	1	A-02	DISPONIBLE	t
58	18	GalerÃ­a	2	G-02	DISPONIBLE	t
1302	13	AlmacÃ©n	1	A-02	DISPONIBLE	t
1501	15	AlmacÃ©n	1	A-01	DISPONIBLE	t
1602	16	Laboratorio	2	B	DISPONIBLE	t
1701	17	Sala ExposiciÃ³n	1	A	DISPONIBLE	t
1801	18	GalerÃ­a	1	G-01	DISPONIBLE	t
40	2	Penthouse	8	PH-01	DISPONIBLE	t
42	10	Duplex	5	D-501	DISPONIBLE	t
43	3	Tienda	1	T-10	DISPONIBLE	t
45	4	Oficina	6	OF-601	DISPONIBLE	t
47	12	Tienda	2	T-25	DISPONIBLE	t
48	5	Nave Industrial	1	NI-02	DISPONIBLE	t
50	13	DepÃ³sito	1	DP-03	DISPONIBLE	t
52	15	AlmacÃ©n LogÃ­stico	1	AL-20	DISPONIBLE	t
53	7	Consultorio	2	C-201	DISPONIBLE	t
55	8	Laboratorio	1	LAB-01	DISPONIBLE	t
57	17	Sala ExposiciÃ³n	1	SE-02	DISPONIBLE	t
\.


--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.usuarios (id, nombre, apellido, email, password_hash, rol, activo, created_at) FROM stdin;
1	Alexander	Acosta	alexander@rentaltoque.com	12345678	SECRETARIO	t	2026-04-22 22:54:00.902015
2	Kevin	Balbuena	balbu@rentaltoque.com	labububu	SECRETARIO	t	2026-04-22 22:54:00.902015
3	Jamir	Rojas	rojito@rentaltoque.com	jamonada	SECRETARIO	t	2026-04-22 22:54:00.902015
\.


--
-- Name: bancos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.bancos_id_seq', 1, false);


--
-- Name: conceptos_recibo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.conceptos_recibo_id_seq', 1, false);


--
-- Name: configuracion_negocio_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.configuracion_negocio_id_seq', 1, false);


--
-- Name: contratos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.contratos_id_seq', 1, false);


--
-- Name: cuentas_bancarias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.cuentas_bancarias_id_seq', 1, false);


--
-- Name: inmuebles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inmuebles_id_seq', 1, true);


--
-- Name: inquilinos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inquilinos_id_seq', 23, true);


--
-- Name: movimientos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.movimientos_id_seq', 313, true);


--
-- Name: recibo_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.recibo_detalle_id_seq', 150, true);


--
-- Name: recibos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.recibos_id_seq', 56, true);


--
-- Name: unidades_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.unidades_id_seq', 1, false);


--
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.usuarios_id_seq', 1, false);


--
-- Name: bancos bancos_nombre_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bancos
    ADD CONSTRAINT bancos_nombre_key UNIQUE (nombre);


--
-- Name: bancos bancos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bancos
    ADD CONSTRAINT bancos_pkey PRIMARY KEY (id);


--
-- Name: conceptos_recibo conceptos_recibo_nombre_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conceptos_recibo
    ADD CONSTRAINT conceptos_recibo_nombre_key UNIQUE (nombre);


--
-- Name: conceptos_recibo conceptos_recibo_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conceptos_recibo
    ADD CONSTRAINT conceptos_recibo_pkey PRIMARY KEY (id);


--
-- Name: configuracion_negocio configuracion_negocio_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.configuracion_negocio
    ADD CONSTRAINT configuracion_negocio_pkey PRIMARY KEY (id);


--
-- Name: configuracion_negocio configuracion_negocio_ruc_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.configuracion_negocio
    ADD CONSTRAINT configuracion_negocio_ruc_key UNIQUE (ruc);


--
-- Name: contratos contratos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contratos
    ADD CONSTRAINT contratos_pkey PRIMARY KEY (id);


--
-- Name: cuentas_bancarias cuentas_bancarias_codigo_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cuentas_bancarias
    ADD CONSTRAINT cuentas_bancarias_codigo_key UNIQUE (codigo);


--
-- Name: cuentas_bancarias cuentas_bancarias_numero_cuenta_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cuentas_bancarias
    ADD CONSTRAINT cuentas_bancarias_numero_cuenta_key UNIQUE (numero_cuenta);


--
-- Name: cuentas_bancarias cuentas_bancarias_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cuentas_bancarias
    ADD CONSTRAINT cuentas_bancarias_pkey PRIMARY KEY (id);


--
-- Name: inmuebles inmuebles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inmuebles
    ADD CONSTRAINT inmuebles_pkey PRIMARY KEY (id);


--
-- Name: inquilinos inquilinos_codigo_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inquilinos
    ADD CONSTRAINT inquilinos_codigo_key UNIQUE (codigo);


--
-- Name: inquilinos inquilinos_documento_identidad_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inquilinos
    ADD CONSTRAINT inquilinos_documento_identidad_key UNIQUE (documento_identidad);


--
-- Name: inquilinos inquilinos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inquilinos
    ADD CONSTRAINT inquilinos_pkey PRIMARY KEY (id);


--
-- Name: movimientos movimientos_codigo_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.movimientos
    ADD CONSTRAINT movimientos_codigo_key UNIQUE (codigo);


--
-- Name: movimientos movimientos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.movimientos
    ADD CONSTRAINT movimientos_pkey PRIMARY KEY (id);


--
-- Name: recibo_detalle recibo_detalle_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recibo_detalle
    ADD CONSTRAINT recibo_detalle_pkey PRIMARY KEY (id);


--
-- Name: recibos recibos_codigo_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recibos
    ADD CONSTRAINT recibos_codigo_key UNIQUE (codigo);


--
-- Name: recibos recibos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recibos
    ADD CONSTRAINT recibos_pkey PRIMARY KEY (id);


--
-- Name: unidades unidades_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unidades
    ADD CONSTRAINT unidades_pkey PRIMARY KEY (id);


--
-- Name: recibo_detalle unique_concepto_por_recibo; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recibo_detalle
    ADD CONSTRAINT unique_concepto_por_recibo UNIQUE (recibo_id, concepto_id);


--
-- Name: recibos unique_recibo_mes; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recibos
    ADD CONSTRAINT unique_recibo_mes UNIQUE (contrato_id, anio, mes);


--
-- Name: unidades unique_unidad_por_inmueble; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unidades
    ADD CONSTRAINT unique_unidad_por_inmueble UNIQUE (inmueble_id, codigo);


--
-- Name: usuarios usuarios_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_email_key UNIQUE (email);


--
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- Name: idx_contratos_inquilino; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_contratos_inquilino ON public.contratos USING btree (inquilino_id);


--
-- Name: idx_contratos_unidad; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_contratos_unidad ON public.contratos USING btree (unidad_id);


--
-- Name: idx_movimientos_cuenta; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_movimientos_cuenta ON public.movimientos USING btree (cuenta_id);


--
-- Name: idx_recibos_contrato; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_recibos_contrato ON public.recibos USING btree (contrato_id);


--
-- Name: idx_unidades_inmueble; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_unidades_inmueble ON public.unidades USING btree (inmueble_id);


--
-- Name: unica_unidad_activa; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unica_unidad_activa ON public.contratos USING btree (unidad_id) WHERE (estado = 'ACTIVO'::public.estado_contrato_enum);


--
-- Name: contratos fk_contrato_inquilino; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contratos
    ADD CONSTRAINT fk_contrato_inquilino FOREIGN KEY (inquilino_id) REFERENCES public.inquilinos(id);


--
-- Name: contratos fk_contrato_unidad; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contratos
    ADD CONSTRAINT fk_contrato_unidad FOREIGN KEY (unidad_id) REFERENCES public.unidades(id);


--
-- Name: cuentas_bancarias fk_cuenta_banco; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cuentas_bancarias
    ADD CONSTRAINT fk_cuenta_banco FOREIGN KEY (banco_id) REFERENCES public.bancos(id);


--
-- Name: recibo_detalle fk_detalle_concepto; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recibo_detalle
    ADD CONSTRAINT fk_detalle_concepto FOREIGN KEY (concepto_id) REFERENCES public.conceptos_recibo(id);


--
-- Name: recibo_detalle fk_detalle_recibo; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recibo_detalle
    ADD CONSTRAINT fk_detalle_recibo FOREIGN KEY (recibo_id) REFERENCES public.recibos(id) ON DELETE CASCADE;


--
-- Name: movimientos fk_mov_cuenta; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.movimientos
    ADD CONSTRAINT fk_mov_cuenta FOREIGN KEY (cuenta_id) REFERENCES public.cuentas_bancarias(id);


--
-- Name: movimientos fk_mov_inmueble; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.movimientos
    ADD CONSTRAINT fk_mov_inmueble FOREIGN KEY (inmueble_id) REFERENCES public.inmuebles(id);


--
-- Name: movimientos fk_mov_recibo; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.movimientos
    ADD CONSTRAINT fk_mov_recibo FOREIGN KEY (recibo_id) REFERENCES public.recibos(id);


--
-- Name: movimientos fk_mov_unidad; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.movimientos
    ADD CONSTRAINT fk_mov_unidad FOREIGN KEY (unidad_id) REFERENCES public.unidades(id);


--
-- Name: recibos fk_recibo_contrato; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recibos
    ADD CONSTRAINT fk_recibo_contrato FOREIGN KEY (contrato_id) REFERENCES public.contratos(id);


--
-- Name: unidades fk_unidad_inmueble; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unidades
    ADD CONSTRAINT fk_unidad_inmueble FOREIGN KEY (inmueble_id) REFERENCES public.inmuebles(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

