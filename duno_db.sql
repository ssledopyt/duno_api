PGDMP  +    -                |            duno    16.2    16.2 7    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16398    duno    DATABASE     x   CREATE DATABASE duno WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE duno;
                postgres    false            �           0    0    duno    DATABASE PROPERTIES     4   ALTER DATABASE duno SET application_name TO 'Duno';
                     postgres    false            �            1259    16431    game    TABLE     �   CREATE TABLE public.game (
    game_name character varying NOT NULL,
    count_players integer,
    genre character varying,
    game_id integer NOT NULL,
    game_time character varying,
    description character varying
);
    DROP TABLE public.game;
       public         heap    postgres    false            �            1259    16472    Game_column1_seq    SEQUENCE     �   CREATE SEQUENCE public."Game_column1_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public."Game_column1_seq";
       public          postgres    false    218            �           0    0    Game_column1_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public."Game_column1_seq" OWNED BY public.game.game_id;
          public          postgres    false    220            �            1259    16438    genre    TABLE     Y   CREATE TABLE public.genre (
    name character varying,
    genre_id integer NOT NULL
);
    DROP TABLE public.genre;
       public         heap    postgres    false            �            1259    16482    Genre_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Genre_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public."Genre_id_seq";
       public          postgres    false    219            �           0    0    Genre_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public."Genre_id_seq" OWNED BY public.genre.genre_id;
          public          postgres    false    221            �            1259    16419    location_of_stationary_place    TABLE     �   CREATE TABLE public.location_of_stationary_place (
    place character varying,
    geo_marker point,
    meet_id integer NOT NULL,
    name_of_club character varying NOT NULL
);
 0   DROP TABLE public.location_of_stationary_place;
       public         heap    postgres    false            �            1259    16575 (   Location_of_stationary_place_meet_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Location_of_stationary_place_meet_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 A   DROP SEQUENCE public."Location_of_stationary_place_meet_id_seq";
       public          postgres    false    217            �           0    0 (   Location_of_stationary_place_meet_id_seq    SEQUENCE OWNED BY     w   ALTER SEQUENCE public."Location_of_stationary_place_meet_id_seq" OWNED BY public.location_of_stationary_place.meet_id;
          public          postgres    false    224            �            1259    16407    meeting    TABLE     Y  CREATE TABLE public.meeting (
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
    DROP TABLE public.meeting;
       public         heap    postgres    false            �            1259    16492    Meeting_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Meeting_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public."Meeting_id_seq";
       public          postgres    false    216            �           0    0    Meeting_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public."Meeting_id_seq" OWNED BY public.meeting.meeting_id;
          public          postgres    false    222            �            1259    16399    users    TABLE     N  CREATE TABLE public.users (
    second_name character varying,
    phone character varying,
    email character varying,
    password character varying,
    created_at timestamp without time zone,
    name character varying DEFAULT 'Player'::character varying,
    user_id integer NOT NULL,
    nickname character varying NOT NULL
);
    DROP TABLE public.users;
       public         heap    postgres    false            �            1259    16501    User_id_seq    SEQUENCE     �   CREATE SEQUENCE public."User_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public."User_id_seq";
       public          postgres    false    215            �           0    0    User_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public."User_id_seq" OWNED BY public.users.user_id;
          public          postgres    false    223            �            1259    16592    likes    TABLE     �   CREATE TABLE public.likes (
    nickname character varying NOT NULL,
    meeting_id integer NOT NULL,
    id integer NOT NULL
);
    DROP TABLE public.likes;
       public         heap    postgres    false            �            1259    16656    likes_id_seq    SEQUENCE     �   CREATE SEQUENCE public.likes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.likes_id_seq;
       public          postgres    false    225            �           0    0    likes_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.likes_id_seq OWNED BY public.likes.id;
          public          postgres    false    226            7           2604    16473    game game_id    DEFAULT     n   ALTER TABLE ONLY public.game ALTER COLUMN game_id SET DEFAULT nextval('public."Game_column1_seq"'::regclass);
 ;   ALTER TABLE public.game ALTER COLUMN game_id DROP DEFAULT;
       public          postgres    false    220    218            8           2604    16483    genre genre_id    DEFAULT     l   ALTER TABLE ONLY public.genre ALTER COLUMN genre_id SET DEFAULT nextval('public."Genre_id_seq"'::regclass);
 =   ALTER TABLE public.genre ALTER COLUMN genre_id DROP DEFAULT;
       public          postgres    false    221    219            9           2604    16657    likes id    DEFAULT     d   ALTER TABLE ONLY public.likes ALTER COLUMN id SET DEFAULT nextval('public.likes_id_seq'::regclass);
 7   ALTER TABLE public.likes ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    226    225            6           2604    16576 $   location_of_stationary_place meet_id    DEFAULT     �   ALTER TABLE ONLY public.location_of_stationary_place ALTER COLUMN meet_id SET DEFAULT nextval('public."Location_of_stationary_place_meet_id_seq"'::regclass);
 S   ALTER TABLE public.location_of_stationary_place ALTER COLUMN meet_id DROP DEFAULT;
       public          postgres    false    224    217            5           2604    16493    meeting meeting_id    DEFAULT     r   ALTER TABLE ONLY public.meeting ALTER COLUMN meeting_id SET DEFAULT nextval('public."Meeting_id_seq"'::regclass);
 A   ALTER TABLE public.meeting ALTER COLUMN meeting_id DROP DEFAULT;
       public          postgres    false    222    216            4           2604    16502    users user_id    DEFAULT     j   ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public."User_id_seq"'::regclass);
 <   ALTER TABLE public.users ALTER COLUMN user_id DROP DEFAULT;
       public          postgres    false    223    215            �          0    16431    game 
   TABLE DATA           `   COPY public.game (game_name, count_players, genre, game_id, game_time, description) FROM stdin;
    public          postgres    false    218   �>       �          0    16438    genre 
   TABLE DATA           /   COPY public.genre (name, genre_id) FROM stdin;
    public          postgres    false    219   B       �          0    16592    likes 
   TABLE DATA           9   COPY public.likes (nickname, meeting_id, id) FROM stdin;
    public          postgres    false    225   �C       �          0    16419    location_of_stationary_place 
   TABLE DATA           `   COPY public.location_of_stationary_place (place, geo_marker, meet_id, name_of_club) FROM stdin;
    public          postgres    false    217   �C       �          0    16407    meeting 
   TABLE DATA           �   COPY public.meeting (title, game, body, organizer, status, meeting_id, geo_marker, count_players, genre, meeting_time) FROM stdin;
    public          postgres    false    216   �H       �          0    16399    users 
   TABLE DATA           i   COPY public.users (second_name, phone, email, password, created_at, name, user_id, nickname) FROM stdin;
    public          postgres    false    215   �R       �           0    0    Game_column1_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public."Game_column1_seq"', 4, true);
          public          postgres    false    220            �           0    0    Genre_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public."Genre_id_seq"', 26, true);
          public          postgres    false    221            �           0    0 (   Location_of_stationary_place_meet_id_seq    SEQUENCE SET     Y   SELECT pg_catalog.setval('public."Location_of_stationary_place_meet_id_seq"', 34, true);
          public          postgres    false    224            �           0    0    Meeting_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public."Meeting_id_seq"', 27, true);
          public          postgres    false    222            �           0    0    User_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public."User_id_seq"', 37, true);
          public          postgres    false    223            �           0    0    likes_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.likes_id_seq', 36, true);
          public          postgres    false    226            C           2606    16634    game game_unique 
   CONSTRAINT     P   ALTER TABLE ONLY public.game
    ADD CONSTRAINT game_unique UNIQUE (game_name);
 :   ALTER TABLE ONLY public.game DROP CONSTRAINT game_unique;
       public            postgres    false    218            E           2606    16491    genre genre_pk 
   CONSTRAINT     R   ALTER TABLE ONLY public.genre
    ADD CONSTRAINT genre_pk PRIMARY KEY (genre_id);
 8   ALTER TABLE ONLY public.genre DROP CONSTRAINT genre_pk;
       public            postgres    false    219            I           2606    16675    likes likes_unique 
   CONSTRAINT     ]   ALTER TABLE ONLY public.likes
    ADD CONSTRAINT likes_unique UNIQUE (nickname, meeting_id);
 <   ALTER TABLE ONLY public.likes DROP CONSTRAINT likes_unique;
       public            postgres    false    225    225            A           2606    16677 <   location_of_stationary_place location_of_stationary_place_pk 
   CONSTRAINT        ALTER TABLE ONLY public.location_of_stationary_place
    ADD CONSTRAINT location_of_stationary_place_pk PRIMARY KEY (meet_id);
 f   ALTER TABLE ONLY public.location_of_stationary_place DROP CONSTRAINT location_of_stationary_place_pk;
       public            postgres    false    217            ?           2606    16500    meeting meeting_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.meeting
    ADD CONSTRAINT meeting_pk PRIMARY KEY (meeting_id);
 <   ALTER TABLE ONLY public.meeting DROP CONSTRAINT meeting_pk;
       public            postgres    false    216            G           2606    16463    genre name_genre_unique 
   CONSTRAINT     R   ALTER TABLE ONLY public.genre
    ADD CONSTRAINT name_genre_unique UNIQUE (name);
 A   ALTER TABLE ONLY public.genre DROP CONSTRAINT name_genre_unique;
       public            postgres    false    219            ;           2606    16555    users nickname_unique 
   CONSTRAINT     T   ALTER TABLE ONLY public.users
    ADD CONSTRAINT nickname_unique UNIQUE (nickname);
 ?   ALTER TABLE ONLY public.users DROP CONSTRAINT nickname_unique;
       public            postgres    false    215            =           2606    16509    users user_pk 
   CONSTRAINT     P   ALTER TABLE ONLY public.users
    ADD CONSTRAINT user_pk PRIMARY KEY (user_id);
 7   ALTER TABLE ONLY public.users DROP CONSTRAINT user_pk;
       public            postgres    false    215            N           2606    16669    likes likes_meeting_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.likes
    ADD CONSTRAINT likes_meeting_fk FOREIGN KEY (meeting_id) REFERENCES public.meeting(meeting_id);
 @   ALTER TABLE ONLY public.likes DROP CONSTRAINT likes_meeting_fk;
       public          postgres    false    4671    225    216            O           2606    16602    likes likes_user_of_duno_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.likes
    ADD CONSTRAINT likes_user_of_duno_fk FOREIGN KEY (nickname) REFERENCES public.users(nickname);
 E   ALTER TABLE ONLY public.likes DROP CONSTRAINT likes_user_of_duno_fk;
       public          postgres    false    215    4667    225            J           2606    16645    meeting meeting_game_fk    FK CONSTRAINT     y   ALTER TABLE ONLY public.meeting
    ADD CONSTRAINT meeting_game_fk FOREIGN KEY (game) REFERENCES public.game(game_name);
 A   ALTER TABLE ONLY public.meeting DROP CONSTRAINT meeting_game_fk;
       public          postgres    false    4675    218    216            K           2606    16628    meeting meeting_genre_fk    FK CONSTRAINT     w   ALTER TABLE ONLY public.meeting
    ADD CONSTRAINT meeting_genre_fk FOREIGN KEY (genre) REFERENCES public.genre(name);
 B   ALTER TABLE ONLY public.meeting DROP CONSTRAINT meeting_genre_fk;
       public          postgres    false    4679    216    219            L           2606    16562    meeting meeting_user_of_duno_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.meeting
    ADD CONSTRAINT meeting_user_of_duno_fk FOREIGN KEY (organizer) REFERENCES public.users(nickname);
 I   ALTER TABLE ONLY public.meeting DROP CONSTRAINT meeting_user_of_duno_fk;
       public          postgres    false    215    216    4667            M           2606    16464    game жанр    FK CONSTRAINT     n   ALTER TABLE ONLY public.game
    ADD CONSTRAINT "жанр" FOREIGN KEY (genre) REFERENCES public.genre(name);
 9   ALTER TABLE ONLY public.game DROP CONSTRAINT "жанр";
       public          postgres    false    219    218    4679            �   j  x�uUKnA]�O�K�K$q�H\�$��X��I"���@��!��nܙ���uN«W='Ek����ի�oOO߽y���I�,�ױ�u�c7��E��avt�4�ߣ�E�2��,e
�\�.�b��A&r��<�d6t2��!JX��-�K<��!����{�ĕ\vqC\�1:��2/�e�/@d��w��;��5��xG� �J>kr+z<�t���� �X����`D��[1��Y�'L&2SJ�)��@e�׈�R+�Ḿe{��e�ރ����4[ĕ���4�o�@;��1NMl���ʥ�m�2�.�̍�+�B/Hj��6Hs�\o�h6��+���OK��7H�h�mb�U���N'ڼ���v�zg:k�h���5,�̞g��7�g�  ȎT�_Swʛ)B�G�a'�TF�E$��3��
S.���T_LPl�En���n�t�6.r�@��Q*[�]�fV�0iK��2s^AA�6��������`� u� M�԰\tz����;��R�Kf6�,�NV��f�T��i�׀�lDa����p�ܲp�_n�{Vwz����m݃-M[�eG:�\�2w��T�S�c����
�WEZr�M{��G���[��nbP�������Kk��彥��U�e�皪��@���u$�琚e�����\����j��ݞ�)��� qԭM("I�lxP��(׆rg臿�2�O7�������MZ���oBj]Z.LP&����:G?8����5�<ڛ4���.<��T7��:�N>��ު*|�o<�ͻ�[�zq����L	��'�m(u��M�a��VI�>vg\��h�q�[�(��I{"�Wkm�h��h�r4��SN      �   e  x�mQIN�@<ϼ�b��/<�v�"�Xr@H��)$X/��?�z<�@�xF�KUWc!�A%��Y<`��g�%
[���yS�e.W(�G�m%���Z�I��B�/�Y��ɉdhd���-������z��9�R�����;4��48�xl�:�*���u�Y,��!G��PK:��g@;�J;�݆�y(:p8��4�q�g���jS�G~⊌�6�{PI� �+X�ѱ�R��S��o/i}���5Zy���n��?c�y9�LԂ�$�Z����s؏��5�.)$��(�LL?�~���c�kT/Kf�U"#�Bc��bǶ2���F���<_����U��:r�x_����gתs`/ά�?^��      �      x�+I��42�46�*�9�͸b���� K,�      �   �  x��V�nE]wE/i<��z�,�@b�&KD�X�݌��26"9�!�@��d^���_ȗp�����=���{��V8��	�pz�"��0��Uǽp���b��[a�jB��f;q3�[���Ѻe���4�m�R������4����aN��2��׀��SL�瘕���{k���G�B/��!�.�yl�i��f��۔Bi�++�m#�o��䊰G���C̋���op1ƃ�/Ac�1�[�Hh��R��Z��D��]��	@�};�B�& 1	�K�b� ��p�j�V��0Z/��(W&v��X��dhg����;�*>��qwY�=`C��-�B�C��t�C"�/�YX��1h2v\.�")�� ����CRD�S�э��|B=	bzZ����0	�I�Ȫ�Z �H�Š��H���/�\��ŎsuW�)���������ݣ�D<ڄ�a���ze���	�F)F��Y��}ȱIO��Pߠ��K39�[��)��D�`?Rߣ��:�J]#�RC��E��Ex�����Bi�H���7eY���z�d��b�������	X����s�B�Xv���r���^�2�v���:�
�(L��CyT��8�$̺ty2�
��e)a+B�ʢ@��2�$%�������i�� n���)��3M�.i��S$�OQ�)b�#��QN�I	D��hʮ��U;����b߂5z%�,��������5vyx��46(;5�k��4Y������g�1�d�<P�(�#���������v��L�,+t=m
s���>Z_����xo}}��bT��IwI��Sj��lr}e�����C�4U�y=�]2� Fl{��%��.RFkG�a��"�9�DP� ��,���~���C۔�.�0�O����S�&v��W�5�z��:)�̈́\��}n&�v'��6Z�G�9c%�K'�-1����z\��Tw��M�[�ZL3�Po+�$��H�-�8X��}\�"�e�.o
,���,M�T����*�0�.�s�+R�s_TZ���*SAEUf�>[�����{޴�~�������w)��U��2*�U^<�V�����/��SYg}�дr��IU��>�&�Kt��ؤ�i��\t:fL�m�%<��EGĒ�x��R���ʥ0h6>3<BwA���nbԕOr�
�!�똝6������T����[y������      �   @
  x��X�n�]���f� E�ͷ�c �Yx��X�,�`v|X�i�X�de��l� -�-�H6	�T�B�$��[E6�8A ?د��8��s�^fݬ�ul������_��W{���g���쥱y:�N�4;�wF.";�ݵ������Ǝ����4;���;�vh�Ec�e�mlgFn��m#�Ʋ>���F�����&;5v,[Ƀ�#�$b�cϱW֓?��Y��j��@^�'6-�/�v����AX~Y��j�V�4��V�U	��^�.s���6�=Y!� ,�ՍRc��2��f�$ٷ�O���=mN�~�^�HF0LC���E��P/R	��V7��8�m�uq�Y��B]:���%����$���*Bk�B�M}y��!�'/^�v����<��ˌ%�bn��<_0������O֛�%�5����#���߀���`��M����Aԗ�ms�bo�w��.��������L���[�;�}#Y}��'�~�%"�v$�u�73gV����h"�Y���m�o�/��p<����Oy4��Ȳ�+e�, q�Ym�q��c�{KlӲ#�J
��V3�Dͼ��og@ ��eI���$;/>=x�o��.�7,�0_� ���K�azƌs6A�����6�S����C�� M�����%$�5���#m�D,j冫D���"b�'�|�T�V��QCQ\�"��$�)�eGbȥ�^�-$��k?���K�g� r��Ʒ�>8�o���._)a04�Q�t���Iq��6"qI~������� �l��z����Z�F�q��8�m��r4S�����f.��(��D��$���922�)8�#	�k"U�	�q(Z�pMc���+�2%���~�]H���;���R	�(����y-iG�1SV3�p)�KC����D���w�!�'��~;p�qo�$D�!��,��Y^S��r�\��>��g6K��@�o�vX@�F�����{gG��i��S��wfL���ܺ��!�!�+�G��&�_���.I�BY�� �Z��]�R�V[�\�Z d��yQ?���تhĀ��	����
@�t�� �EY�;�K���R�B}����/�����ܨƀ*@�
�f��Y1�m�J�/���R���XjUʏ�Z`��@�g��7M��Y��
`�#����DavvfFv��Ӝ�G[��G~ˀ#��&4���m���o�h"H��NB�h��
L��R�{�j�56�&KͿ	vw��8�z�Sq��jF���u��%�XVE�ׅOɔC/| �[��1��b��&?Pȥ`�{h�M)��t�V�!;х�:���ee�+_�
ʕ��d�"e����p?ErW�Bj+t�7{[�J�?��Xl���/8�k�K�}vd�2��]A�V����-X���1w����c�e�6����h���z`ߺ2��g9�a��4׌{!�I� ���D@����OP2R&(�+<�6n�w�2�h�x��ʖ�'3qj�C�w���9�r�e��RQ�[i���~�zZ(Ǒ�(8k%��%Af�Xm����~���D�P�8�z������X���
�B��K6�d%F&lR�nu����ߵ�}��`��&��n�j�"
��W����t+W=)����h\��Gߥ�N��t6���A@.u��_:��z9-Փ7:��촐��D�ᆊ��{=�"��,��B��b��aUk�&�\֡�Q�.g��k�T�,VQz�v�q�;O4ls��p�#��:��g7��7s/�ͣ�z[�M���q�D�l(��P-~O���C�6߬��O��"8�z%��[�VIwl�Z���ϭ��	+˹��	:p�ŝ�`�\#���+-r���5��y�2� �W
I�~�6~���Z�E�����S���(�`
"m��|=y��y�@ᆢh�����?q�'�X�>BU虂�G3��>K���%*\�<I�DE�~��ǂc�Hn�YP���=\���w~R���%u�y[
ݞ����NR/��o?
�������v%�*��	�s�<o��%!"ew��O��W���ԧY/V��˯ 	)���>H�m�s���`���!�Eo�2/���G�Z@T�+w�����9XJ��	^r��N)�=0\Np 	��c9��35
�M@�S�����
��3e	E���ѻ��ˢ�#��d�W)z�R}�͗��%a&'��y�D"�Ý���2��6[���"cčV���Q���ߕSC�Y��D4 ?S�����D��9<�j{wy0Pp���Đ=�Vg�a�hDn]sJx��R>O���Da���t$��0�5w��c��ȁS���|�,X�ɺ��<��L�F5߶��?�.��'j�J�W�w쵀d*���i{wHu"Ngֹ����7d�D��>��x42����7n���sUn]w��j��&�T�	�Eh��dϟͪ�aL�A��YM7�6O)���u����� נ�A��|}zx.�s,��p
�6�#W_?�u'��!|��!� p���z�4SAw��u=Iz>�j�b��TK��Y{GK��s�[������X���vvw0U�F(7uĭT��:K��%��ד9m�M��)s�����G����      �   d  x�e�MN�0���c� Uǉ��;NЍ��'�i�ʪ�-Be��EO�R*���ar#�Ң
$[���7�p�[\4���/|��ys8y��3~�w���zy/'8�'����v�c���}/Է��O����=���X���`�4���k|� F��C=�-q��Qu2�y���A��Rٱ�0ie�B3ݱ!K�a�j�E��G,4Aj�����
���v+��Ÿ �T�����$;����q�x�aI�������80��,�a�(ձ�F�B�m�ei��c>�~�99 ��N�N��w=p�5��)\��@cU�| ��>��.�n��]5ʇ?���R��U���Hir/&�6!���̋     