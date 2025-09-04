--
-- PostgreSQL database dump
--

\restrict Ncdgz54gRzHATKM5hdHR2aBL2cbKa6pjPg4wYv4bHr2fQrOyau58Zy7ye128CsI

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

-- Started on 2025-09-04 21:47:08

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
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
-- TOC entry 232 (class 1259 OID 16975)
-- Name: class_attendance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.class_attendance (
    id integer NOT NULL,
    enrollment_no character varying(50) NOT NULL,
    student_name character varying(100) NOT NULL,
    class_name character varying(50) NOT NULL,
    date date NOT NULL,
    subject character varying(100) DEFAULT 'General'::character varying,
    topic character varying(200) DEFAULT 'N/A'::character varying,
    reference_link text,
    status character varying(20) DEFAULT 'Absent'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.class_attendance OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16974)
-- Name: class_attendance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.class_attendance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.class_attendance_id_seq OWNER TO postgres;

--
-- TOC entry 4945 (class 0 OID 0)
-- Dependencies: 231
-- Name: class_attendance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.class_attendance_id_seq OWNED BY public.class_attendance.id;


--
-- TOC entry 234 (class 1259 OID 17000)
-- Name: login_students; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.login_students (
    id integer NOT NULL,
    enrollment_no character varying(50) NOT NULL,
    student_name character varying(100) NOT NULL,
    class_name character varying(50) NOT NULL,
    password text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.login_students OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16999)
-- Name: login_students_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.login_students_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.login_students_id_seq OWNER TO postgres;

--
-- TOC entry 4946 (class 0 OID 0)
-- Dependencies: 233
-- Name: login_students_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.login_students_id_seq OWNED BY public.login_students.id;


--
-- TOC entry 220 (class 1259 OID 16670)
-- Name: parents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.parents (
    id integer NOT NULL,
    full_name character varying(255) NOT NULL,
    parent_id character varying(50) NOT NULL,
    email character varying(255) NOT NULL,
    phone character varying(20),
    password text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.parents OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16669)
-- Name: parents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.parents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.parents_id_seq OWNER TO postgres;

--
-- TOC entry 4947 (class 0 OID 0)
-- Dependencies: 219
-- Name: parents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.parents_id_seq OWNED BY public.parents.id;


--
-- TOC entry 226 (class 1259 OID 16941)
-- Name: student_attendance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_attendance (
    attendance_id integer NOT NULL,
    student_id integer,
    subject character varying(50),
    lecture_date date,
    status character varying(10)
);


ALTER TABLE public.student_attendance OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16940)
-- Name: student_attendance_attendance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_attendance_attendance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.student_attendance_attendance_id_seq OWNER TO postgres;

--
-- TOC entry 4948 (class 0 OID 0)
-- Dependencies: 225
-- Name: student_attendance_attendance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_attendance_attendance_id_seq OWNED BY public.student_attendance.attendance_id;


--
-- TOC entry 230 (class 1259 OID 16963)
-- Name: student_students; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_students (
    student_id integer NOT NULL,
    enrollment_no character varying(50),
    name character varying(100)
);


ALTER TABLE public.student_students OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16962)
-- Name: student_students_student_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_students_student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.student_students_student_id_seq OWNER TO postgres;

--
-- TOC entry 4949 (class 0 OID 0)
-- Dependencies: 229
-- Name: student_students_student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_students_student_id_seq OWNED BY public.student_students.student_id;


--
-- TOC entry 228 (class 1259 OID 16953)
-- Name: student_topics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_topics (
    topic_id integer NOT NULL,
    subject character varying(50),
    topic_name character varying(200),
    reference_link text,
    lecture_date date
);


ALTER TABLE public.student_topics OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16952)
-- Name: student_topics_topic_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_topics_topic_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.student_topics_topic_id_seq OWNER TO postgres;

--
-- TOC entry 4950 (class 0 OID 0)
-- Dependencies: 227
-- Name: student_topics_topic_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_topics_topic_id_seq OWNED BY public.student_topics.topic_id;


--
-- TOC entry 222 (class 1259 OID 16684)
-- Name: students; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.students (
    student_id integer NOT NULL,
    full_name character varying(100) NOT NULL,
    enrollment_no character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    phone_number character varying(15) NOT NULL,
    class character varying(50) NOT NULL,
    password_hash text NOT NULL,
    terms_accepted boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.students OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16683)
-- Name: students_student_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.students_student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.students_student_id_seq OWNER TO postgres;

--
-- TOC entry 4951 (class 0 OID 0)
-- Dependencies: 221
-- Name: students_student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.students_student_id_seq OWNED BY public.students.student_id;


--
-- TOC entry 218 (class 1259 OID 16656)
-- Name: teachers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teachers (
    id integer NOT NULL,
    full_name character varying(255) NOT NULL,
    teacher_id character varying(50) NOT NULL,
    email character varying(255) NOT NULL,
    phone character varying(20),
    password text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.teachers OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16655)
-- Name: teachers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.teachers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.teachers_id_seq OWNER TO postgres;

--
-- TOC entry 4952 (class 0 OID 0)
-- Dependencies: 217
-- Name: teachers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.teachers_id_seq OWNED BY public.teachers.id;


--
-- TOC entry 224 (class 1259 OID 16929)
-- Name: topics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.topics (
    id integer NOT NULL,
    class_name character varying(50) NOT NULL,
    subject character varying(100) NOT NULL,
    topic_name character varying(200) NOT NULL,
    reference_link text,
    date date NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.topics OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16928)
-- Name: topics_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.topics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.topics_id_seq OWNER TO postgres;

--
-- TOC entry 4953 (class 0 OID 0)
-- Dependencies: 223
-- Name: topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.topics_id_seq OWNED BY public.topics.id;


--
-- TOC entry 4747 (class 2604 OID 16978)
-- Name: class_attendance id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_attendance ALTER COLUMN id SET DEFAULT nextval('public.class_attendance_id_seq'::regclass);


--
-- TOC entry 4752 (class 2604 OID 17003)
-- Name: login_students id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_students ALTER COLUMN id SET DEFAULT nextval('public.login_students_id_seq'::regclass);


--
-- TOC entry 4737 (class 2604 OID 16673)
-- Name: parents id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parents ALTER COLUMN id SET DEFAULT nextval('public.parents_id_seq'::regclass);


--
-- TOC entry 4744 (class 2604 OID 16944)
-- Name: student_attendance attendance_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_attendance ALTER COLUMN attendance_id SET DEFAULT nextval('public.student_attendance_attendance_id_seq'::regclass);


--
-- TOC entry 4746 (class 2604 OID 16966)
-- Name: student_students student_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_students ALTER COLUMN student_id SET DEFAULT nextval('public.student_students_student_id_seq'::regclass);


--
-- TOC entry 4745 (class 2604 OID 16956)
-- Name: student_topics topic_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_topics ALTER COLUMN topic_id SET DEFAULT nextval('public.student_topics_topic_id_seq'::regclass);


--
-- TOC entry 4739 (class 2604 OID 16687)
-- Name: students student_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students ALTER COLUMN student_id SET DEFAULT nextval('public.students_student_id_seq'::regclass);


--
-- TOC entry 4735 (class 2604 OID 16659)
-- Name: teachers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers ALTER COLUMN id SET DEFAULT nextval('public.teachers_id_seq'::regclass);


--
-- TOC entry 4742 (class 2604 OID 16932)
-- Name: topics id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.topics ALTER COLUMN id SET DEFAULT nextval('public.topics_id_seq'::regclass);


--
-- TOC entry 4787 (class 2606 OID 16988)
-- Name: class_attendance class_attendance_enrollment_no_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_attendance
    ADD CONSTRAINT class_attendance_enrollment_no_date_key UNIQUE (enrollment_no, date);


--
-- TOC entry 4789 (class 2606 OID 16986)
-- Name: class_attendance class_attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_attendance
    ADD CONSTRAINT class_attendance_pkey PRIMARY KEY (id);


--
-- TOC entry 4791 (class 2606 OID 17010)
-- Name: login_students login_students_enrollment_no_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_students
    ADD CONSTRAINT login_students_enrollment_no_key UNIQUE (enrollment_no);


--
-- TOC entry 4793 (class 2606 OID 17008)
-- Name: login_students login_students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_students
    ADD CONSTRAINT login_students_pkey PRIMARY KEY (id);


--
-- TOC entry 4761 (class 2606 OID 16682)
-- Name: parents parents_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parents
    ADD CONSTRAINT parents_email_key UNIQUE (email);


--
-- TOC entry 4763 (class 2606 OID 16680)
-- Name: parents parents_parent_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parents
    ADD CONSTRAINT parents_parent_id_key UNIQUE (parent_id);


--
-- TOC entry 4765 (class 2606 OID 16678)
-- Name: parents parents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parents
    ADD CONSTRAINT parents_pkey PRIMARY KEY (id);


--
-- TOC entry 4779 (class 2606 OID 16946)
-- Name: student_attendance student_attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_attendance
    ADD CONSTRAINT student_attendance_pkey PRIMARY KEY (attendance_id);


--
-- TOC entry 4783 (class 2606 OID 16970)
-- Name: student_students student_students_enrollment_no_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_students
    ADD CONSTRAINT student_students_enrollment_no_key UNIQUE (enrollment_no);


--
-- TOC entry 4785 (class 2606 OID 16968)
-- Name: student_students student_students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_students
    ADD CONSTRAINT student_students_pkey PRIMARY KEY (student_id);


--
-- TOC entry 4781 (class 2606 OID 16960)
-- Name: student_topics student_topics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_topics
    ADD CONSTRAINT student_topics_pkey PRIMARY KEY (topic_id);


--
-- TOC entry 4767 (class 2606 OID 16697)
-- Name: students students_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_email_key UNIQUE (email);


--
-- TOC entry 4769 (class 2606 OID 16695)
-- Name: students students_enrollment_no_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_enrollment_no_key UNIQUE (enrollment_no);


--
-- TOC entry 4771 (class 2606 OID 16699)
-- Name: students students_phone_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_phone_number_key UNIQUE (phone_number);


--
-- TOC entry 4773 (class 2606 OID 16693)
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (student_id);


--
-- TOC entry 4755 (class 2606 OID 16668)
-- Name: teachers teachers_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_email_key UNIQUE (email);


--
-- TOC entry 4757 (class 2606 OID 16664)
-- Name: teachers teachers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_pkey PRIMARY KEY (id);


--
-- TOC entry 4759 (class 2606 OID 16666)
-- Name: teachers teachers_teacher_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_teacher_id_key UNIQUE (teacher_id);


--
-- TOC entry 4775 (class 2606 OID 16939)
-- Name: topics topics_class_name_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT topics_class_name_date_key UNIQUE (class_name, date);


--
-- TOC entry 4777 (class 2606 OID 16937)
-- Name: topics topics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT topics_pkey PRIMARY KEY (id);


--
-- TOC entry 4794 (class 2606 OID 16947)
-- Name: student_attendance student_attendance_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_attendance
    ADD CONSTRAINT student_attendance_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id);


-- Completed on 2025-09-04 21:47:08

--
-- PostgreSQL database dump complete
--

\unrestrict Ncdgz54gRzHATKM5hdHR2aBL2cbKa6pjPg4wYv4bHr2fQrOyau58Zy7ye128CsI

