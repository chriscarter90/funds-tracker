--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: chris; Tablespace: 
--

CREATE TABLE accounts (
    id integer NOT NULL,
    name character varying(255),
    user_id integer,
    starting_balance numeric,
    current_balance numeric
);


ALTER TABLE public.accounts OWNER TO chris;

--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: chris
--

CREATE SEQUENCE accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accounts_id_seq OWNER TO chris;

--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chris
--

ALTER SEQUENCE accounts_id_seq OWNED BY accounts.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: chris; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO chris;

--
-- Name: tags; Type: TABLE; Schema: public; Owner: chris; Tablespace: 
--

CREATE TABLE tags (
    id integer NOT NULL,
    name character varying(255),
    user_id integer
);


ALTER TABLE public.tags OWNER TO chris;

--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: chris
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tags_id_seq OWNER TO chris;

--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chris
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: chris; Tablespace: 
--

CREATE TABLE transactions (
    id integer NOT NULL,
    description character varying(255),
    amount numeric,
    account_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    transaction_date timestamp without time zone,
    tag_id integer
);


ALTER TABLE public.transactions OWNER TO chris;

--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: chris
--

CREATE SEQUENCE transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transactions_id_seq OWNER TO chris;

--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chris
--

ALTER SEQUENCE transactions_id_seq OWNED BY transactions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: chris; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    first_name character varying(255),
    last_name character varying(255)
);


ALTER TABLE public.users OWNER TO chris;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: chris
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO chris;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chris
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: chris
--

ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: chris
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: chris
--

ALTER TABLE ONLY transactions ALTER COLUMN id SET DEFAULT nextval('transactions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: chris
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: chris
--

COPY accounts (id, name, user_id, starting_balance, current_balance) FROM stdin;
2	voluptate soluta tenetur	3	5.0	\N
3	alias minima doloremque	4	9.0	\N
4	Account	1	65.0	\N
5	non cumque quia	4	9.0	9.0
6	Another Account	2	500.0	550.0
8	Tens	2	100.0	260.0
1	My Account	2	456.78	756.78
7	Load Account	2	100.0	582.069999999999997
\.


--
-- Name: accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chris
--

SELECT pg_catalog.setval('accounts_id_seq', 8, true);


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: chris
--

COPY schema_migrations (version) FROM stdin;
20140506092127
20140507082529
20140507084304
20140507143208
20140507143511
20140512140253
20140513092554
20140514145141
20140514152105
20140519133603
20140520091914
20140520092441
20140520092728
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: chris
--

COPY tags (id, name, user_id) FROM stdin;
1	Food	2
2	Water	2
3	Other Tag	1
\.


--
-- Name: tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chris
--

SELECT pg_catalog.setval('tags_id_seq', 3, true);


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: chris
--

COPY transactions (id, description, amount, account_id, created_at, updated_at, transaction_date, tag_id) FROM stdin;
99	consequatur commodi est non ne	4.2	7	2014-06-25 15:26:53.902547	2014-06-25 15:43:46.035173	2014-06-11 15:26:53.898807	\N
2	totam ut quas consequuntur qui atque est	9.0	2	2014-05-14 14:55:38.251475	2014-05-14 14:55:38.251475	\N	\N
4	assumenda est voluptas nulla porro ut possimus	15.0	3	2014-05-19 08:09:07.90309	2014-05-19 08:09:07.90309	\N	\N
3	molestiae facilis nulla rerum aliquid beatae modi	20.0	3	2014-05-14 14:55:39.560315	2014-05-19 08:47:55.507336	\N	\N
8	Something	50.0	6	2014-06-25 10:12:44.350963	2014-06-25 10:12:48.101061	2014-06-11 23:00:00	1
189	Ten	10.0	8	2014-06-27 08:23:34.433555	2014-07-02 19:23:32.746277	2014-06-13 08:23:34.42776	2
190	Ten	10.0	8	2014-06-27 08:23:34.480291	2014-07-02 19:23:32.77762	2014-06-13 08:23:34.479231	2
191	Ten	10.0	8	2014-06-27 08:23:34.493831	2014-07-02 19:23:32.830214	2014-06-13 08:23:34.492976	2
192	Ten	10.0	8	2014-06-27 08:23:34.506645	2014-07-02 19:23:32.837293	2014-06-13 08:23:34.505684	2
193	Ten	10.0	8	2014-06-27 08:23:34.564955	2014-07-02 19:23:32.855254	2014-06-13 08:23:34.564082	2
194	Ten	10.0	8	2014-06-27 08:23:34.589723	2014-07-02 19:23:32.862681	2014-06-13 08:23:34.588899	2
195	Ten	10.0	8	2014-06-27 08:23:34.602299	2014-07-02 19:23:32.881335	2014-06-13 08:23:34.601043	2
196	Ten	10.0	8	2014-06-27 08:23:34.616468	2014-07-02 19:23:32.888734	2014-06-13 08:23:34.615485	2
197	Ten	10.0	8	2014-06-27 08:23:34.645714	2014-07-02 19:23:32.906173	2014-06-13 08:23:34.644883	2
198	Ten	10.0	8	2014-06-27 08:23:34.660456	2014-07-02 19:23:32.913283	2014-06-13 08:23:34.659317	2
199	Ten	10.0	8	2014-06-27 08:23:34.674732	2014-07-02 19:23:32.932369	2014-06-13 08:23:34.673876	2
200	Ten	10.0	8	2014-06-27 08:23:34.700214	2014-07-02 19:23:32.942467	2014-06-13 08:23:34.699076	2
201	Ten	10.0	8	2014-06-27 08:23:34.71537	2014-07-02 19:23:32.957473	2014-06-13 08:23:34.714347	2
202	Ten	10.0	8	2014-06-27 08:23:34.728383	2014-07-02 19:23:32.964131	2014-06-13 08:23:34.727458	2
203	Ten	10.0	8	2014-06-27 08:23:34.754042	2014-07-02 19:23:32.982492	2014-06-12 23:00:00	2
204	Newest	10.0	8	2014-07-30 20:09:31.433748	2014-07-30 20:09:31.433748	2014-07-29 23:00:00	2
1	Beeeeeeeeeeeer.	300.0	1	\N	2014-07-31 11:59:53.671749	2014-05-16 23:00:00	1
100	voluptatem consequuntur archit	4.08	7	2014-06-25 15:26:53.92127	2014-06-25 15:43:46.069679	2014-06-11 15:26:53.920446	\N
101	possimus optio enim ipsa itaqu	6.83	7	2014-06-25 15:26:53.932464	2014-06-25 15:43:46.12162	2014-06-11 15:26:53.931704	\N
102	quae ipsum rerum dolorem volup	3.44	7	2014-06-25 15:26:53.958562	2014-06-25 15:43:46.141412	2014-06-11 15:26:53.957746	\N
103	facere molestias odit et possi	6.15	7	2014-06-25 15:26:53.970839	2014-06-25 15:43:46.154221	2014-06-11 15:26:53.969825	\N
104	aspernatur ea velit hic accusa	8.49	7	2014-06-25 15:26:53.986526	2014-06-25 15:43:46.164736	2014-06-11 15:26:53.985304	\N
105	nulla consequatur aut a laudan	8.879999999999999	7	2014-06-25 15:26:54.025415	2014-06-25 15:43:46.171252	2014-06-11 15:26:54.024603	\N
106	laudantium dolor porro ducimus	3.28	7	2014-06-25 15:26:54.037905	2014-06-25 15:43:46.190726	2014-06-11 15:26:54.036897	\N
107	explicabo architecto in placea	6.47	7	2014-06-25 15:26:54.054183	2014-06-25 15:43:46.202381	2014-06-11 15:26:54.053088	\N
108	veniam dolor at blanditiis aut	7.4	7	2014-06-25 15:26:54.095068	2014-06-25 15:43:46.211142	2014-06-11 15:26:54.094221	\N
109	et voluptas aut quasi velit et	3.74	7	2014-06-25 15:26:54.108627	2014-06-25 15:43:46.219369	2014-06-11 15:26:54.107388	\N
110	similique nostrum vel est ut n	1.19	7	2014-06-25 15:26:54.124662	2014-06-25 15:43:46.240567	2014-06-11 15:26:54.123588	\N
111	inventore tenetur omnis ducimu	9.09	7	2014-06-25 15:26:54.165577	2014-06-25 15:43:46.250638	2014-06-11 15:26:54.164659	\N
112	soluta atque velit laboriosam 	1.03	7	2014-06-25 15:26:54.18033	2014-06-25 15:43:46.260335	2014-06-11 15:26:54.179339	\N
113	velit occaecati et ipsum asper	8.359999999999999	7	2014-06-25 15:26:54.207968	2014-06-25 15:43:46.269058	2014-06-11 15:26:54.207097	\N
114	omnis velit laborum est volupt	4.140000000000001	7	2014-06-25 15:26:54.219746	2014-06-25 15:43:46.28894	2014-06-11 15:26:54.218712	\N
115	autem totam nihil sit odio con	9.369999999999999	7	2014-06-25 15:26:54.238286	2014-06-25 15:43:46.2989	2014-06-11 15:26:54.237269	\N
116	sit laborum itaque consequatur	7.78	7	2014-06-25 15:26:54.270396	2014-06-25 15:43:46.308735	2014-06-11 15:26:54.269206	\N
117	qui consequatur numquam pariat	5.28	7	2014-06-25 15:26:54.286852	2014-06-25 15:43:46.317936	2014-06-11 15:26:54.285737	\N
118	id iure vitae omnis accusantiu	6.15	7	2014-06-25 15:26:54.323675	2014-06-25 15:43:46.323921	2014-06-11 15:26:54.322787	\N
119	dolorem vel enim dolor sunt di	7.18	7	2014-06-25 15:26:54.335609	2014-06-25 15:43:46.34648	2014-06-11 15:26:54.334686	\N
120	et et exercitationem natus quo	4.08	7	2014-06-25 15:26:54.351546	2014-06-25 15:43:46.35647	2014-06-11 15:26:54.350575	\N
121	placeat id rerum quaerat et fu	5.99	7	2014-06-25 15:26:54.442104	2014-06-25 15:43:46.364803	2014-06-11 15:26:54.441246	\N
122	qui consectetur sed nesciunt o	9.710000000000001	7	2014-06-25 15:26:54.455698	2014-06-25 15:43:46.370885	2014-06-11 15:26:54.454446	\N
123	praesentium rem aut itaque et 	5.49	7	2014-06-25 15:26:54.473887	2014-06-25 15:43:46.37645	2014-06-11 15:26:54.472704	\N
124	beatae illum est nostrum cupid	3.49	7	2014-06-25 15:26:54.506818	2014-06-25 15:43:46.397359	2014-06-11 15:26:54.505563	\N
125	quam sed assumenda praesentium	7.71	7	2014-06-25 15:26:54.52426	2014-06-25 15:43:46.404713	2014-06-11 15:26:54.523109	\N
126	dolores ipsam porro iste volup	4.84	7	2014-06-25 15:26:54.554525	2014-06-25 15:43:46.41283	2014-06-11 15:26:54.553486	\N
127	reprehenderit aliquam et aut f	5.86	7	2014-06-25 15:26:54.571134	2014-06-25 15:43:46.422795	2014-06-11 15:26:54.570178	\N
128	ad et ut veritatis nobis esse 	5.98	7	2014-06-25 15:26:54.586217	2014-06-25 15:43:46.449369	2014-06-11 15:26:54.585332	\N
150	ea et ad dolorem eum iusto ut	6.2	7	2014-06-25 15:26:55.079229	2014-06-25 15:26:55.079229	2014-06-11 15:26:55.077619	\N
129	incidunt est veniam quos perfe	2.86	7	2014-06-25 15:26:54.611883	2014-06-25 15:43:46.455756	2014-06-11 15:26:54.611078	\N
130	at autem ea aut qui dignissimo	5.28	7	2014-06-25 15:26:54.625806	2014-06-25 15:43:46.464084	2014-06-11 15:26:54.624533	\N
131	dolores odit aperiam et sit ve	1.15	7	2014-06-25 15:26:54.665869	2014-06-25 15:43:46.473693	2014-06-11 15:26:54.66495	\N
132	autem excepturi itaque totam d	6.31	7	2014-06-25 15:26:54.682372	2014-06-25 15:43:46.481416	2014-06-11 15:26:54.681364	\N
133	dolor numquam impedit voluptat	2.01	7	2014-06-25 15:26:54.698245	2014-06-25 15:43:46.502365	2014-06-11 15:26:54.697346	\N
134	quidem cupiditate debitis dign	9.15	7	2014-06-25 15:26:54.728315	2014-06-25 15:43:46.509157	2014-06-11 15:26:54.727185	\N
135	maxime magnam provident occaec	2.09	7	2014-06-25 15:26:54.744357	2014-06-25 15:43:46.518344	2014-06-11 15:26:54.743304	\N
136	voluptatem inventore ea eum qu	5.71	7	2014-06-25 15:26:54.773301	2014-06-25 15:43:46.526613	2014-06-11 15:26:54.772452	\N
137	et ea nam ut a delectus nesciu	1.69	7	2014-06-25 15:26:54.78452	2014-06-25 15:43:46.534584	2014-06-11 15:26:54.783736	\N
138	quia eligendi et et quaerat ac	9.77	7	2014-06-25 15:26:54.801838	2014-06-25 15:43:46.555794	2014-06-11 15:26:54.800679	\N
139	et et omnis dignissimos a non 	8.02	7	2014-06-25 15:26:54.838908	2014-06-25 15:43:46.564138	2014-06-11 15:26:54.83785	\N
140	velit nobis voluptas dolores n	2.53	7	2014-06-25 15:26:54.856506	2014-06-25 15:43:46.57335	2014-06-11 15:26:54.8554	\N
141	in sed ab aperiam quia ipsa pe	3.91	7	2014-06-25 15:26:54.886298	2014-06-25 15:43:46.581713	2014-06-11 15:26:54.885361	\N
142	voluptas sed omnis et enim adi	5.59	7	2014-06-25 15:26:54.90467	2014-06-25 15:43:46.590552	2014-06-11 15:26:54.903539	\N
143	quisquam omnis reprehenderit s	2.64	7	2014-06-25 15:26:54.919491	2014-06-25 15:43:46.609661	2014-06-11 15:26:54.918612	\N
144	ut nobis laudantium dolorem ve	9.08	7	2014-06-25 15:26:54.952911	2014-06-25 15:43:46.619848	2014-06-11 15:26:54.951507	\N
145	quia deserunt corporis totam e	4.71	7	2014-06-25 15:26:54.968688	2014-06-25 15:43:46.62945	2014-06-11 15:26:54.967867	\N
146	laudantium esse cupiditate acc	2.65	7	2014-06-25 15:26:54.995303	2014-06-25 15:43:46.638515	2014-06-11 15:26:54.994492	\N
147	quisquam facilis perferendis i	8.809999999999999	7	2014-06-25 15:26:55.009747	2014-06-25 15:43:46.659429	2014-06-11 15:26:55.00846	\N
148	fugit aliquid sint exercitatio	3.82	7	2014-06-25 15:26:55.028587	2014-06-25 15:43:46.669398	2014-06-11 15:26:55.027163	\N
149	saepe id ratione sapiente reru	2.57	7	2014-06-25 15:26:55.060208	2014-06-25 15:43:46.677589	2014-06-11 15:26:55.058924	\N
151	dolorem commodi autem qui veli	7.76	7	2014-06-25 15:26:55.104704	2014-06-25 15:43:46.690542	2014-06-11 15:26:55.103742	\N
152	qui doloribus labore ea deseru	1.79	7	2014-06-25 15:26:55.124399	2014-06-25 15:43:46.712515	2014-06-11 15:26:55.123194	\N
153	earum consequatur quam quibusd	2.94	7	2014-06-25 15:26:55.154042	2014-06-25 15:43:46.722289	2014-06-11 15:26:55.15316	\N
154	praesentium est repellendus sa	4.43	7	2014-06-25 15:26:55.171814	2014-06-25 15:43:46.730997	2014-06-11 15:26:55.170682	\N
155	molestiae hic ex eos nesciunt 	1.27	7	2014-06-25 15:26:55.188017	2014-06-25 15:43:46.739784	2014-06-11 15:26:55.187137	\N
156	nostrum illum modi maxime qui 	3.98	7	2014-06-25 15:26:55.220124	2014-06-25 15:43:46.759518	2014-06-11 15:26:55.21889	\N
157	labore laudantium ex impedit d	7.12	7	2014-06-25 15:26:55.289646	2014-06-25 15:43:46.766112	2014-06-11 15:26:55.288226	\N
158	placeat velit eos et quae ad c	3.99	7	2014-06-25 15:26:55.306984	2014-06-25 15:43:46.771858	2014-06-11 15:26:55.306146	\N
159	suscipit consequatur quisquam 	4.76	7	2014-06-25 15:26:55.318801	2014-06-25 15:43:46.778294	2014-06-11 15:26:55.317972	\N
160	minus eius voluptatem occaecat	2.6	7	2014-06-25 15:26:55.346126	2014-06-25 15:43:46.78755	2014-06-11 15:26:55.345007	\N
161	aut pariatur sit debitis non u	5.97	7	2014-06-25 15:26:55.360832	2014-06-25 15:43:46.795972	2014-06-11 15:26:55.359371	\N
176	ad fugit rerum ipsam et ut est	2.33	7	2014-06-25 15:26:55.730189	2014-06-25 15:26:55.730189	2014-06-11 15:26:55.729027	\N
162	non harum ullam rerum quo id n	8.379999999999999	7	2014-06-25 15:26:55.378903	2014-06-25 15:43:46.825763	2014-06-11 15:26:55.377898	\N
163	ea voluptatem omnis ea exercit	1.79	7	2014-06-25 15:26:55.416261	2014-06-25 15:43:46.840866	2014-06-11 15:26:55.415218	\N
164	dolores qui quis maiores sequi	4.51	7	2014-06-25 15:26:55.43392	2014-06-25 15:43:46.854688	2014-06-11 15:26:55.433047	\N
165	dolor sit nostrum similique id	3.41	7	2014-06-25 15:26:55.465848	2014-06-25 15:43:46.879866	2014-06-11 15:26:55.464525	\N
166	iste quidem voluptas eius et q	9.789999999999999	7	2014-06-25 15:26:55.484333	2014-06-25 15:43:46.885804	2014-06-11 15:26:55.483474	\N
167	quidem labore dolorem maiores 	4.54	7	2014-06-25 15:26:55.518066	2014-06-25 15:43:46.891787	2014-06-11 15:26:55.516863	\N
168	in est qui culpa voluptas et i	2.19	7	2014-06-25 15:26:55.536181	2014-06-25 15:43:46.899511	2014-06-11 15:26:55.535333	\N
169	eos repudiandae dolores sit qu	7.41	7	2014-06-25 15:26:55.563869	2014-06-25 15:43:46.908166	2014-06-11 15:26:55.563062	\N
170	dolor quis a iste ratione sapi	8.460000000000001	7	2014-06-25 15:26:55.577869	2014-06-25 15:43:46.916127	2014-06-11 15:26:55.576477	\N
171	dicta accusantium commodi eum 	5.36	7	2014-06-25 15:26:55.595917	2014-06-25 15:43:46.947339	2014-06-11 15:26:55.595003	\N
172	ex minima ab accusamus in modi	9.25	7	2014-06-25 15:26:55.633211	2014-06-25 15:43:46.956286	2014-06-11 15:26:55.631788	\N
173	sint voluptatum odit odio fugi	9.16	7	2014-06-25 15:26:55.650924	2014-06-25 15:43:46.964565	2014-06-11 15:26:55.649523	\N
174	nisi atque rerum suscipit mole	2.28	7	2014-06-25 15:26:55.681206	2014-06-25 15:43:46.971876	2014-06-11 15:26:55.679916	\N
175	sint ipsum animi odio quisquam	9.789999999999999	7	2014-06-25 15:26:55.698879	2014-06-25 15:43:47.02869	2014-06-11 15:26:55.697914	\N
177	quas saepe sed dignissimos vol	6.28	7	2014-06-25 15:26:55.748131	2014-06-25 15:43:47.043136	2014-06-11 15:26:55.747015	\N
178	temporibus aspernatur commodi 	2.98	7	2014-06-25 15:26:55.778186	2014-06-25 15:43:47.049494	2014-06-11 15:26:55.777019	\N
179	et cupiditate in et quos esse 	2.79	7	2014-06-25 15:26:55.790761	2014-06-25 15:43:47.055019	2014-06-11 15:26:55.7897	\N
180	ipsam voluptas vero eveniet au	5.45	7	2014-06-25 15:26:55.810233	2014-06-25 15:43:47.075043	2014-06-11 15:26:55.809166	\N
181	consequatur aperiam esse in et	3.54	7	2014-06-25 15:26:55.85083	2014-06-25 15:43:47.083153	2014-06-11 15:26:55.84947	\N
182	nostrum nisi facere quas eveni	7.99	7	2014-06-25 15:26:55.868279	2014-06-25 15:43:47.092062	2014-06-11 15:26:55.867052	\N
183	fugiat praesentium aut molliti	7.24	7	2014-06-25 15:26:55.901096	2014-06-25 15:43:47.099617	2014-06-11 15:26:55.900176	\N
184	reprehenderit est impedit aspe	5.13	7	2014-06-25 15:26:55.919028	2014-06-25 15:43:47.106929	2014-06-11 15:26:55.918186	\N
185	qui quis sint doloribus sint i	5.52	7	2014-06-25 15:26:55.946645	2014-06-25 15:43:47.127189	2014-06-11 15:26:55.945803	\N
186	voluptatum sapiente fugit non 	7.37	7	2014-06-25 15:26:55.958794	2014-06-25 15:43:47.135724	2014-06-11 15:26:55.957715	\N
187	animi voluptas incidunt offici	8.780000000000001	7	2014-06-25 15:26:55.979636	2014-06-25 15:43:47.144642	2014-06-11 15:26:55.9785	\N
188	enim pariatur commodi sed anim	1.51	7	2014-06-25 15:26:56.010179	2014-06-25 15:43:47.152527	2014-06-11 15:26:56.008917	\N
\.


--
-- Name: transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chris
--

SELECT pg_catalog.setval('transactions_id_seq', 204, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: chris
--

COPY users (id, email, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip, created_at, updated_at, first_name, last_name) FROM stdin;
3	test-user1@example.com	$2a$10$A29j4.2IsVDY4ovWv3Fbe.b.Yk74vphO09bHaId2xNL06Vq/wfLnO	\N	\N	\N	0	\N	\N	\N	\N	2014-05-14 14:55:38.233317	2014-05-14 14:55:38.233317	Hermina	Yost
4	test-user2@example.com	$2a$10$nIp7qIcaU5oEN5chOsvwF.v9V9cYHgjivUZ5rFHpNKR0BDNbGm7ea	\N	\N	\N	0	\N	\N	\N	\N	2014-05-14 14:55:39.555381	2014-05-14 14:55:39.555381	Brain	Bernier
1	user@example.com	$2a$10$9J2A3I44Jw8nmVws1s9cZeoCUfRxs25C03w/BAUCrFqqpYORswvlO	\N	\N	\N	3	2014-05-25 19:08:55.827886	2014-05-25 19:08:00.108138	127.0.0.1	127.0.0.1	2014-05-14 09:26:03.186608	2014-05-25 19:08:55.828668	Example	User
2	chris@ubxd.com	$2a$10$bwkEAfqCLGFq6ip35U0uQOySm5EnND8sDJAcQ8pfn9fVnQaz/atoW	\N	\N	\N	22	2014-07-31 11:59:25.752713	2014-07-30 19:53:21.195221	127.0.0.1	127.0.0.1	2014-05-14 09:33:33.190203	2014-07-31 11:59:25.75405	Chris	Carter
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chris
--

SELECT pg_catalog.setval('users_id_seq', 4, true);


--
-- Name: accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: chris; Tablespace: 
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: chris; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: chris; Tablespace: 
--

ALTER TABLE ONLY transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: chris; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_accounts_on_user_id; Type: INDEX; Schema: public; Owner: chris; Tablespace: 
--

CREATE INDEX index_accounts_on_user_id ON accounts USING btree (user_id);


--
-- Name: index_tags_on_user_id; Type: INDEX; Schema: public; Owner: chris; Tablespace: 
--

CREATE INDEX index_tags_on_user_id ON tags USING btree (user_id);


--
-- Name: index_transactions_on_account_id; Type: INDEX; Schema: public; Owner: chris; Tablespace: 
--

CREATE INDEX index_transactions_on_account_id ON transactions USING btree (account_id);


--
-- Name: index_transactions_on_tag_id; Type: INDEX; Schema: public; Owner: chris; Tablespace: 
--

CREATE INDEX index_transactions_on_tag_id ON transactions USING btree (tag_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: chris; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: chris; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: chris; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: public; Type: ACL; Schema: -; Owner: chris
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM chris;
GRANT ALL ON SCHEMA public TO chris;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

