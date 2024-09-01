--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

-- Started on 2024-08-31 03:01:27

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 218 (class 1259 OID 16431)
-- Name: game; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.game (
    game_name character varying NOT NULL,
    count_players integer,
    genre character varying,
    game_id integer NOT NULL,
    game_time character varying,
    description character varying
);


ALTER TABLE public.game OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16472)
-- Name: Game_column1_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Game_column1_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Game_column1_seq" OWNER TO postgres;

--
-- TOC entry 4848 (class 0 OID 0)
-- Dependencies: 220
-- Name: Game_column1_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Game_column1_seq" OWNED BY public.game.game_id;


--
-- TOC entry 219 (class 1259 OID 16438)
-- Name: genre; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.genre (
    name character varying,
    genre_id integer NOT NULL
);


ALTER TABLE public.genre OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16482)
-- Name: Genre_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Genre_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Genre_id_seq" OWNER TO postgres;

--
-- TOC entry 4849 (class 0 OID 0)
-- Dependencies: 221
-- Name: Genre_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Genre_id_seq" OWNED BY public.genre.genre_id;


--
-- TOC entry 217 (class 1259 OID 16419)
-- Name: location_of_stationary_place; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.location_of_stationary_place (
    place character varying,
    geo_marker point,
    meet_id integer NOT NULL,
    name_of_club character varying NOT NULL
);


ALTER TABLE public.location_of_stationary_place OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16575)
-- Name: Location_of_stationary_place_meet_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Location_of_stationary_place_meet_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Location_of_stationary_place_meet_id_seq" OWNER TO postgres;

--
-- TOC entry 4850 (class 0 OID 0)
-- Dependencies: 224
-- Name: Location_of_stationary_place_meet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Location_of_stationary_place_meet_id_seq" OWNED BY public.location_of_stationary_place.meet_id;


--
-- TOC entry 216 (class 1259 OID 16407)
-- Name: meeting; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.meeting (
    title character varying,
    game character varying,
    body character varying,
    organizer character varying NOT NULL,
    status boolean NOT NULL,
    meeting_id integer NOT NULL,
    geo_marker point,
    count_players integer,
    genre character varying,
    meeting_time timestamp without time zone
);


ALTER TABLE public.meeting OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16492)
-- Name: Meeting_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Meeting_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Meeting_id_seq" OWNER TO postgres;

--
-- TOC entry 4851 (class 0 OID 0)
-- Dependencies: 222
-- Name: Meeting_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Meeting_id_seq" OWNED BY public.meeting.meeting_id;


--
-- TOC entry 215 (class 1259 OID 16399)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    second_name character varying,
    phone character varying,
    email character varying,
    password character varying,
    created_at timestamp without time zone,
    name character varying DEFAULT 'Player'::character varying,
    user_id integer NOT NULL,
    nickname character varying NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16501)
-- Name: User_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."User_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."User_id_seq" OWNER TO postgres;

--
-- TOC entry 4852 (class 0 OID 0)
-- Dependencies: 223
-- Name: User_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."User_id_seq" OWNED BY public.users.user_id;


--
-- TOC entry 225 (class 1259 OID 16592)
-- Name: likes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.likes (
    nickname character varying NOT NULL,
    meeting_id integer NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.likes OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16656)
-- Name: likes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.likes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.likes_id_seq OWNER TO postgres;

--
-- TOC entry 4853 (class 0 OID 0)
-- Dependencies: 226
-- Name: likes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.likes_id_seq OWNED BY public.likes.id;


--
-- TOC entry 4663 (class 2604 OID 16473)
-- Name: game game_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game ALTER COLUMN game_id SET DEFAULT nextval('public."Game_column1_seq"'::regclass);


--
-- TOC entry 4664 (class 2604 OID 16483)
-- Name: genre genre_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genre ALTER COLUMN genre_id SET DEFAULT nextval('public."Genre_id_seq"'::regclass);


--
-- TOC entry 4665 (class 2604 OID 16657)
-- Name: likes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.likes ALTER COLUMN id SET DEFAULT nextval('public.likes_id_seq'::regclass);


--
-- TOC entry 4662 (class 2604 OID 16576)
-- Name: location_of_stationary_place meet_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_of_stationary_place ALTER COLUMN meet_id SET DEFAULT nextval('public."Location_of_stationary_place_meet_id_seq"'::regclass);


--
-- TOC entry 4661 (class 2604 OID 16493)
-- Name: meeting meeting_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meeting ALTER COLUMN meeting_id SET DEFAULT nextval('public."Meeting_id_seq"'::regclass);


--
-- TOC entry 4660 (class 2604 OID 16502)
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public."User_id_seq"'::regclass);


--
-- TOC entry 4834 (class 0 OID 16431)
-- Dependencies: 218
-- Data for Name: game; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.game (game_name, count_players, genre, game_id, game_time, description) FROM stdin;
Gloomhevan	6	Командные	2	3-4	Невероятная по масштабу, хардкорная тактическая настольная игра, которая отправит вас в кооперативное приключение по подземельям и руинам жестокого и сурового мира, где правда всегда за сильным. На выбор вам доступно семнадцать уникальных наёмников, каждый из которых обладает своей историей и мотивом отправиться в столь опасные края.
Монополия	8	Экономические	3	6	Экономическая стратегия, в которой вам предстоит обогатиться или разориться, совершая сделки по купле-продаже собственности. Игроки будут перемещать свои фишки по игровому полю и покупать участки, на которых они остановились. Цель игры – остаться последним игроком при деньгах (когда все остальные игроки обанкротились).
DnD	4	Настольные ролевые	1	2-3	Настольная ролевая игра, центральное место в которой занимает история, рассказываемая её участниками. Каждый игрок придумывает себе персонажа и отправляется в долгое и полное опасностей и сокровищ приключение. Прелесть игры в том, что конечный исход этой истории не предрешён заранее, и большая часть событий будет разворачиваться согласно действиям героев.
\.


--
-- TOC entry 4835 (class 0 OID 16438)
-- Dependencies: 219
-- Data for Name: genre; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.genre (name, genre_id) FROM stdin;
Дуэль	1
Головоломки	2
Обучающие игры	3
Бродилки	4
Азартные	5
Психологические	6
Экономические	7
Игры-рисовалки	8
Детективные	9
Вечериночные	10
Детские	11
Карточные	12
Настольные ролевые	13
Игры с миниатюрами	14
Кооперативные	15
Классические	16
Интеллектуальные	17
Книги-игры	18
Командные	19
Квесты	20
Полукооперативные	21
Приключенческие	22
Стратегические	23
Семейные	24
Хардкорные	25
Варгеймы	26
\.


--
-- TOC entry 4841 (class 0 OID 16592)
-- Dependencies: 225
-- Data for Name: likes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.likes (nickname, meeting_id, id) FROM stdin;
tah	22	34
tah	11	36
\.


--
-- TOC entry 4833 (class 0 OID 16419)
-- Dependencies: 217
-- Data for Name: location_of_stationary_place; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.location_of_stationary_place (place, geo_marker, meet_id, name_of_club) FROM stdin;
Москва, Селезнёвская ул., 11А, стр. 2	(55.781266,37.603675)	5	Единорог
Москва, Ярцевская ул., 19	(55.738596,37.411014)	8	Единорог
Москва, Театральный пр‑д, 5 	(55.760135,37.624957)	9	Единорог
Москва, ул. Братьев Фонченко, 10, корп. 1	(55.729701,37.511778)	10	Антикафе 12 Ярдов
Москва, 1-я Тверская-Ямская улица, 36с2	(55.776392,37.586191)	11	Party Hard
Москва, Большой Староданиловский переулок, 2с8	(55.708811,37.628939)	12	Party Hard
Москва, улица Фридриха Энгельса, 20с2	(55.772161,37.6826)	4	Терра
улица Большая Полянка, 19	(55.738866,37.61807)	13	Пушистая братва
Товарищеский переулок, 4с5	(55.741633,37.659877)	14	Котокафе Котики: Смена
улица Земляной Вал, 32	(55.757253,37.657056)	15	Котокафе Котофейня
Лялин переулок, 8с2	(55.760049,37.650931)	16	Time Club Гнездо
2-й Полевой переулок, 2	(55.791903,37.680959)	17	Котокафе Мурчашка
Щербаковская улица, 53к2	(55.783174,37.737598)	18	Соколиная Нора
проспект Мира, 79с2	(55.791189,37.633836)	19	Совиный дом
Новослободская улица, 36/1с1	(55.78445,37.596932)	20	GeekTime
улица Гиляровского, 17	(55.776599,37.630269)	21	Котокафе Котики и Люди
Большая Сухаревская площадь, 16/18с1	(55.771566,37.637726)	22	Wooden Door
Большая Сухаревская площадь, 14/7, подъезд 3	(55.771875,37.636665)	23	Сфера
Новая Басманная улица, 31с1	(55.770116,37.665582)	24	Котокафе Котиссимо
Милютинский переулок, 19/4с1	(55.765557,37.632116)	25	Зелёная Дверь
улица Земляной Вал, 68/18с5	(55.745255,37.65398)	26	Time Club Ковчег
Тверская улица, 12с1	(55.763278,37.607826)	27	Циферблат
улица Арбат, 6/2	(55.751631,37.59744)	28	Ежеминутка
улица Кузнецкий Мост, 19с1	(55.762067,37.626067)	29	Циферблат
Мясницкая улица, 17с2	(55.763521,37.634648)	30	CheckPoint
улица Большая Ордынка, 68	(55.731784,37.623696)	31	Квартира № 7
Валовая улица, 32/75с2	(55.730305,37.626342)	32	Белый лист
Комсомольский проспект, 41	(55.721341,37.575484)	33	Москвалогия
улица Малая Дмитровка, 29с1	(55.77166,37.603854)	34	Антикафе Рос
\.


--
-- TOC entry 4832 (class 0 OID 16407)
-- Dependencies: 216
-- Data for Name: meeting; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.meeting (title, game, body, organizer, status, meeting_id, geo_marker, count_players, genre, meeting_time) FROM stdin;
Встреча №2	Gloomhevan	В прошлый раз прошли уже довольно много. Ищем одного человека, чтобы завершить сюжет. Опыт не важен.	tuliman	t	25	(55.78445,37.596932)	4	Кооперативные	2024-07-19 14:00:00
Гроза	DnD	Новичкам будет предложен преген на выбор. Если у вас есть опыт игры по этой системе, можно сгенериться самостоятельно и до игры отправить лист персонажа мастеру. Разрешены материалы из Core rulebook и Character operation manual. Стандартные правила закупа из основной книги правил. Экзотическую расы из Инопланетного архива – по предварительному обсуждению.\r\nЗа пару дней до начала мастер создаст конфу в вк для подготовки к игре. На игре можно будет попробовать механику космического боя на звездолетах. В фокусе ваншота боевка и данжкроул, но интересным сюжетом он тоже не обделен) 	yoyo	f	22	(55.741633,37.659877)	8	Книги-игры	2024-06-27 19:20:00
В окружении	DnD	Открыт донабор в уже идущую кампанию. Ищем 5го игрока, который готов каждый понедельник с 19:00 погружаться вместе с нами в альтернативный мир скандинавской мифологии.\r\n1. Авторский мир. Альтернативный скандинавский сеттинг, где боги и сейд реальны. Временной промежуток — середина IX века.\r\n2. Упор на исследование мира и социалку. Без боевок, конечно, тоже не обходится.\r\n3. Знание скандинавской мифологии и опыт игры в D&D 5e будет большим плюсом.	kok	t	11	(55.760049,37.650931)	5	Детские	2024-07-18 18:45:00
Победа над роксикером	Монополия	Собираемся в 2 в кафе, после как-нибудь решим, со мной двое друзей ещё	kilogram	t	23	(55.765557,37.632116)	8	Вечериночные	2024-07-10 12:00:00
Бежим, бежим...	Gloomhevan	Очень давно не играл, пора нагонять упущенное	kilogram	f	13	(55.741633,37.659877)	5	Игры-рисовалки	2024-06-29 18:30:00
Klark	DnD	Хочется видеть интеренсых людей, приносите настроение!	yoyo	t	16	(55.763278,37.607826)	6	Головоломки	2024-04-24 18:50:00
Королевство Сигизмунд	DnD	Уильям Дриммайнд — известный археолог и историк — собирает отряд для археологической экспедиции к руинам Предтеч — древней цивилизации, обитавшей в мире задолго до Великого катаклизма. Цель экспедиции находится далеко на севере, практически на границе Ледяной пустоши, поэтому Уильяму требуются опытные авантюристы, готовые к любым возможным трудностям.	kok	t	24	(55.751631,37.59744)	4	Командные	2024-07-09 14:35:00
Круиз	Gloomhevan	Играли с мужем пару раз, ищем ещё пару человек	yoyo	t	9	(55.741633,37.659877)	8	Карточные	2024-06-18 13:25:00
Нарния	DnD	Будет весело!	tah	f	27	(55.791903,37.680959)	6	Кооперативные	2024-07-06 23:00:00
Гладиаторы	DnD	Небольшая деревенька каждый год проводит фестиваль «Крика Дождя». В это время в окрестностях пробуждаются многочисленные духи, что не могут обрести покой и начинают терроризировать путников и жителей деревни.\nКаждый год они нанимают группу приключенцев, чтобы те провели неделю в деревне, помогая с организацией праздника и с его защитой.\nФестиваль, сладости и фейерверки... После недавних приключений такая задача звучит почти как отпуск. Эту возможность нельзя было упускать, так что ваша группа направилась туда без особых размышлений.	tah	t	15	(55.708811,37.628939)	5	Бродилки	2024-05-14 12:00:00
Дорога в Аргейл	DnD	Вы отправляетесь сопровождать торговца антиквара Кифа в Аргейл, поскольку в последнее время в этом регионе участились пропажи людей, а также нередки нападения бандитов и диких зверей. Вам предстоит примерно 3 дня пути. Местные власти рекомендуют останавливаться на ночлег в тавернах, а не в лесу, поскольку в нем совсем не безопасно.\r\nУ вас есть предчувствие, что дорога не будет простой прогулкой, а, возможно, вам даже предстоит раскрыть секреты, которые хранит лес по пути в город.	kiki	f	14	(55.791189,37.633836)	5	Классические	2024-06-26 15:18:00
\.


--
-- TOC entry 4831 (class 0 OID 16399)
-- Dependencies: 215
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (second_name, phone, email, password, created_at, name, user_id, nickname) FROM stdin;
Ананасов	\N	\N	8328	\N	Ольга	29	kiki
Арбузов	\N	\N	263	\N	Тальтемир	30	kok
Зубов	\N	\N	grgs1	\N	Андрей	1	tah
Бутов	""	"tu@mail.com"	ac93f3a0fee5afa2d9399d5d0f257dc92bbde89b1e48452e1bfac3c5c1dc99db	\N	Олег	33	yoyo
Любов		agds@gmail.com	d4ee9f58e5860574ca98e3b4839391e7a356328d4bd6afecefc2381df5f5b41b	\N	Олег	35	kilogram
Azra		srddg@mail.com	rrr	\N	Georgii	36	tuliman
Турутин		turutin@mail.ru	password	\N	Андрей	37	aturutin
\.


--
-- TOC entry 4854 (class 0 OID 0)
-- Dependencies: 220
-- Name: Game_column1_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Game_column1_seq"', 4, true);


--
-- TOC entry 4855 (class 0 OID 0)
-- Dependencies: 221
-- Name: Genre_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Genre_id_seq"', 26, true);


--
-- TOC entry 4856 (class 0 OID 0)
-- Dependencies: 224
-- Name: Location_of_stationary_place_meet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Location_of_stationary_place_meet_id_seq"', 34, true);


--
-- TOC entry 4857 (class 0 OID 0)
-- Dependencies: 222
-- Name: Meeting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Meeting_id_seq"', 27, true);


--
-- TOC entry 4858 (class 0 OID 0)
-- Dependencies: 223
-- Name: User_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."User_id_seq"', 37, true);


--
-- TOC entry 4859 (class 0 OID 0)
-- Dependencies: 226
-- Name: likes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.likes_id_seq', 36, true);


--
-- TOC entry 4675 (class 2606 OID 16634)
-- Name: game game_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game
    ADD CONSTRAINT game_unique UNIQUE (game_name);


--
-- TOC entry 4677 (class 2606 OID 16491)
-- Name: genre genre_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genre
    ADD CONSTRAINT genre_pk PRIMARY KEY (genre_id);


--
-- TOC entry 4681 (class 2606 OID 16675)
-- Name: likes likes_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT likes_unique UNIQUE (nickname, meeting_id);


--
-- TOC entry 4673 (class 2606 OID 16677)
-- Name: location_of_stationary_place location_of_stationary_place_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_of_stationary_place
    ADD CONSTRAINT location_of_stationary_place_pk PRIMARY KEY (meet_id);


--
-- TOC entry 4671 (class 2606 OID 16500)
-- Name: meeting meeting_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meeting
    ADD CONSTRAINT meeting_pk PRIMARY KEY (meeting_id);


--
-- TOC entry 4679 (class 2606 OID 16463)
-- Name: genre name_genre_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genre
    ADD CONSTRAINT name_genre_unique UNIQUE (name);


--
-- TOC entry 4667 (class 2606 OID 16555)
-- Name: users nickname_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT nickname_unique UNIQUE (nickname);


--
-- TOC entry 4669 (class 2606 OID 16509)
-- Name: users user_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT user_pk PRIMARY KEY (user_id);


--
-- TOC entry 4686 (class 2606 OID 16669)
-- Name: likes likes_meeting_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT likes_meeting_fk FOREIGN KEY (meeting_id) REFERENCES public.meeting(meeting_id);


--
-- TOC entry 4687 (class 2606 OID 16602)
-- Name: likes likes_user_of_duno_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT likes_user_of_duno_fk FOREIGN KEY (nickname) REFERENCES public.users(nickname);


--
-- TOC entry 4682 (class 2606 OID 16645)
-- Name: meeting meeting_game_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meeting
    ADD CONSTRAINT meeting_game_fk FOREIGN KEY (game) REFERENCES public.game(game_name);


--
-- TOC entry 4683 (class 2606 OID 16628)
-- Name: meeting meeting_genre_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meeting
    ADD CONSTRAINT meeting_genre_fk FOREIGN KEY (genre) REFERENCES public.genre(name);


--
-- TOC entry 4684 (class 2606 OID 16562)
-- Name: meeting meeting_user_of_duno_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meeting
    ADD CONSTRAINT meeting_user_of_duno_fk FOREIGN KEY (organizer) REFERENCES public.users(nickname);


--
-- TOC entry 4685 (class 2606 OID 16464)
-- Name: game жанр; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game
    ADD CONSTRAINT "жанр" FOREIGN KEY (genre) REFERENCES public.genre(name);


-- Completed on 2024-08-31 03:01:27

--
-- PostgreSQL database dump complete
--

