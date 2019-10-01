--
-- PostgreSQL database dump
--

-- Dumped from database version 11.2
-- Dumped by pg_dump version 11.2

-- Started on 2019-10-01 16:39:59 CST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- TOC entry 2646 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 215 (class 1259 OID 19756)
-- Name: pp_notify_tpl; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pp_notify_tpl (
    id integer NOT NULL,
    type character varying(20),
    tpl_name character varying(20),
    tpl_type smallint NOT NULL,
    title character varying(64) DEFAULT NULL::character varying,
    content text,
    status smallint DEFAULT '1'::smallint NOT NULL,
    create_time integer DEFAULT 0 NOT NULL,
    create_id integer DEFAULT 0 NOT NULL,
    update_time integer DEFAULT 0 NOT NULL,
    update_id integer DEFAULT 0 NOT NULL
);


--
-- TOC entry 2647 (class 0 OID 0)
-- Dependencies: 215
-- Name: TABLE pp_notify_tpl; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.pp_notify_tpl IS '通知模板';


--
-- TOC entry 2648 (class 0 OID 0)
-- Dependencies: 215
-- Name: COLUMN pp_notify_tpl.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_notify_tpl.id IS '模板id';


--
-- TOC entry 2649 (class 0 OID 0)
-- Dependencies: 215
-- Name: COLUMN pp_notify_tpl.tpl_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_notify_tpl.tpl_name IS '模板名称';


--
-- TOC entry 2650 (class 0 OID 0)
-- Dependencies: 215
-- Name: COLUMN pp_notify_tpl.tpl_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_notify_tpl.tpl_type IS '模板类型 0:邮件;1:信息;2:钉钉;3:微信;';


--
-- TOC entry 2651 (class 0 OID 0)
-- Dependencies: 215
-- Name: COLUMN pp_notify_tpl.title; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_notify_tpl.title IS '标题';


--
-- TOC entry 2652 (class 0 OID 0)
-- Dependencies: 215
-- Name: COLUMN pp_notify_tpl.content; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_notify_tpl.content IS '模板内容';


--
-- TOC entry 2653 (class 0 OID 0)
-- Dependencies: 215
-- Name: COLUMN pp_notify_tpl.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_notify_tpl.status IS '状态 0:禁用;1:启用;';


--
-- TOC entry 2654 (class 0 OID 0)
-- Dependencies: 215
-- Name: COLUMN pp_notify_tpl.create_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_notify_tpl.create_time IS '创建时间';


--
-- TOC entry 2655 (class 0 OID 0)
-- Dependencies: 215
-- Name: COLUMN pp_notify_tpl.create_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_notify_tpl.create_id IS '创建者ID';


--
-- TOC entry 2656 (class 0 OID 0)
-- Dependencies: 215
-- Name: COLUMN pp_notify_tpl.update_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_notify_tpl.update_time IS '最后一次编辑时间';


--
-- TOC entry 2657 (class 0 OID 0)
-- Dependencies: 215
-- Name: COLUMN pp_notify_tpl.update_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_notify_tpl.update_id IS '最后一次编辑者ID';


--
-- TOC entry 214 (class 1259 OID 19754)
-- Name: pp_notify_tpl_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pp_notify_tpl_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2658 (class 0 OID 0)
-- Dependencies: 214
-- Name: pp_notify_tpl_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pp_notify_tpl_id_seq OWNED BY public.pp_notify_tpl.id;


--
-- TOC entry 197 (class 1259 OID 19563)
-- Name: pp_task; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pp_task (
    id integer NOT NULL,
    group_id integer DEFAULT 0 NOT NULL,
    server_ids character varying(200) DEFAULT 0 NOT NULL,
    task_name character varying(50) DEFAULT ''::character varying NOT NULL,
    description character varying(200) DEFAULT ''::character varying NOT NULL,
    cron_spec character varying(100) DEFAULT ''::character varying NOT NULL,
    concurrent smallint DEFAULT '0'::smallint NOT NULL,
    command text NOT NULL,
    timeout smallint DEFAULT '0'::smallint NOT NULL,
    execute_times integer DEFAULT 0 NOT NULL,
    prev_time integer DEFAULT 0 NOT NULL,
    is_notify smallint DEFAULT '0'::smallint NOT NULL,
    notify_type smallint DEFAULT '0'::smallint NOT NULL,
    notify_user_ids character varying(200) DEFAULT '0'::character varying NOT NULL,
    status smallint DEFAULT '2'::smallint NOT NULL,
    create_time integer DEFAULT 0 NOT NULL,
    create_id integer DEFAULT 0 NOT NULL,
    update_time integer DEFAULT 0 NOT NULL,
    update_id integer DEFAULT 0 NOT NULL,
    notify_tpl_id integer DEFAULT 0 NOT NULL,
    server_type smallint DEFAULT '1'::smallint NOT NULL
);


--
-- TOC entry 2659 (class 0 OID 0)
-- Dependencies: 197
-- Name: COLUMN pp_task.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task.id IS '分组ID';


--
-- TOC entry 2660 (class 0 OID 0)
-- Dependencies: 197
-- Name: COLUMN pp_task.group_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task.group_id IS '分组ID';


--
-- TOC entry 2661 (class 0 OID 0)
-- Dependencies: 197
-- Name: COLUMN pp_task.server_ids; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task.server_ids IS '服务器id字符串，英文都好隔开';


--
-- TOC entry 2662 (class 0 OID 0)
-- Dependencies: 197
-- Name: COLUMN pp_task.task_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task.task_name IS '任务名称';


--
-- TOC entry 2663 (class 0 OID 0)
-- Dependencies: 197
-- Name: COLUMN pp_task.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task.description IS '任务描述';


--
-- TOC entry 2664 (class 0 OID 0)
-- Dependencies: 197
-- Name: COLUMN pp_task.cron_spec; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task.cron_spec IS '时间表达式';


--
-- TOC entry 2665 (class 0 OID 0)
-- Dependencies: 197
-- Name: COLUMN pp_task.concurrent; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task.concurrent IS '是否只允许一个实例';


--
-- TOC entry 2666 (class 0 OID 0)
-- Dependencies: 197
-- Name: COLUMN pp_task.command; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task.command IS '命令详情';


--
-- TOC entry 2667 (class 0 OID 0)
-- Dependencies: 197
-- Name: COLUMN pp_task.timeout; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task.timeout IS '超时设置 s';


--
-- TOC entry 2668 (class 0 OID 0)
-- Dependencies: 197
-- Name: COLUMN pp_task.execute_times; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task.execute_times IS '累计执行次数';


--
-- TOC entry 2669 (class 0 OID 0)
-- Dependencies: 197
-- Name: COLUMN pp_task.prev_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task.prev_time IS '上次执行时间';


--
-- TOC entry 2670 (class 0 OID 0)
-- Dependencies: 197
-- Name: COLUMN pp_task.is_notify; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task.is_notify IS '0-不通知，1-通知';


--
-- TOC entry 2671 (class 0 OID 0)
-- Dependencies: 197
-- Name: COLUMN pp_task.notify_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task.notify_type IS '0-邮件通知，1-信息通知，2-钉钉通知，3-微信通知';


--
-- TOC entry 2672 (class 0 OID 0)
-- Dependencies: 197
-- Name: COLUMN pp_task.notify_user_ids; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task.notify_user_ids IS '通知用户ID字符串，1,2,3';


--
-- TOC entry 2673 (class 0 OID 0)
-- Dependencies: 197
-- Name: COLUMN pp_task.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task.status IS '-1删除，0停用 1启用 2审核中,3不通过';


--
-- TOC entry 2674 (class 0 OID 0)
-- Dependencies: 197
-- Name: COLUMN pp_task.create_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task.create_time IS '创建时间';


--
-- TOC entry 2675 (class 0 OID 0)
-- Dependencies: 197
-- Name: COLUMN pp_task.create_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task.create_id IS '创建者ID';


--
-- TOC entry 2676 (class 0 OID 0)
-- Dependencies: 197
-- Name: COLUMN pp_task.update_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task.update_time IS '最后一次编辑时间';


--
-- TOC entry 2677 (class 0 OID 0)
-- Dependencies: 197
-- Name: COLUMN pp_task.update_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task.update_id IS '最后一次编辑者ID';


--
-- TOC entry 2678 (class 0 OID 0)
-- Dependencies: 197
-- Name: COLUMN pp_task.notify_tpl_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task.notify_tpl_id IS '通知模板id';


--
-- TOC entry 2679 (class 0 OID 0)
-- Dependencies: 197
-- Name: COLUMN pp_task.server_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task.server_type IS '执行策略：0-同时执行，1-轮询执行';


--
-- TOC entry 199 (class 1259 OID 19591)
-- Name: pp_task_ban; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pp_task_ban (
    id integer NOT NULL,
    code character varying(64) DEFAULT '0'::character varying NOT NULL,
    create_time integer DEFAULT 0 NOT NULL,
    update_time integer DEFAULT 0 NOT NULL,
    status smallint DEFAULT '0'::smallint NOT NULL
);


--
-- TOC entry 2680 (class 0 OID 0)
-- Dependencies: 199
-- Name: TABLE pp_task_ban; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.pp_task_ban IS '权限和角色关系表';


--
-- TOC entry 2681 (class 0 OID 0)
-- Dependencies: 199
-- Name: COLUMN pp_task_ban.code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_ban.code IS '命令';


--
-- TOC entry 2682 (class 0 OID 0)
-- Dependencies: 199
-- Name: COLUMN pp_task_ban.create_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_ban.create_time IS '创建时间';


--
-- TOC entry 2683 (class 0 OID 0)
-- Dependencies: 199
-- Name: COLUMN pp_task_ban.update_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_ban.update_time IS '更新时间';


--
-- TOC entry 2684 (class 0 OID 0)
-- Dependencies: 199
-- Name: COLUMN pp_task_ban.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_ban.status IS '0-正常，1-删除';


--
-- TOC entry 198 (class 1259 OID 19589)
-- Name: pp_task_ban_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pp_task_ban_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2685 (class 0 OID 0)
-- Dependencies: 198
-- Name: pp_task_ban_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pp_task_ban_id_seq OWNED BY public.pp_task_ban.id;


--
-- TOC entry 201 (class 1259 OID 19603)
-- Name: pp_task_group; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pp_task_group (
    id integer NOT NULL,
    group_name character varying(50) DEFAULT ''::character varying NOT NULL,
    description character varying(255) DEFAULT ''::character varying NOT NULL,
    create_id integer DEFAULT 0 NOT NULL,
    create_time integer DEFAULT 0 NOT NULL,
    update_id integer DEFAULT 0 NOT NULL,
    update_time integer DEFAULT 0 NOT NULL,
    status smallint DEFAULT '0'::smallint NOT NULL
);


--
-- TOC entry 2686 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN pp_task_group.group_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_group.group_name IS '组名';


--
-- TOC entry 2687 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN pp_task_group.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_group.description IS '说明';


--
-- TOC entry 2688 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN pp_task_group.create_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_group.create_id IS '用户ID';


--
-- TOC entry 2689 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN pp_task_group.create_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_group.create_time IS '创建时间';


--
-- TOC entry 2690 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN pp_task_group.update_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_group.update_id IS '修改者Id';


--
-- TOC entry 2691 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN pp_task_group.update_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_group.update_time IS '更新时间';


--
-- TOC entry 2692 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN pp_task_group.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_group.status IS '状态：1-正常，0-删除';


--
-- TOC entry 200 (class 1259 OID 19601)
-- Name: pp_task_group_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pp_task_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2693 (class 0 OID 0)
-- Dependencies: 200
-- Name: pp_task_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pp_task_group_id_seq OWNED BY public.pp_task_group.id;


--
-- TOC entry 196 (class 1259 OID 19561)
-- Name: pp_task_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pp_task_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2694 (class 0 OID 0)
-- Dependencies: 196
-- Name: pp_task_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pp_task_id_seq OWNED BY public.pp_task.id;


--
-- TOC entry 203 (class 1259 OID 19618)
-- Name: pp_task_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pp_task_log (
    id integer NOT NULL,
    task_id integer DEFAULT 0 NOT NULL,
    output text NOT NULL,
    error text NOT NULL,
    status smallint NOT NULL,
    process_time integer DEFAULT 0 NOT NULL,
    create_time integer DEFAULT 0 NOT NULL,
    server_id integer DEFAULT '-1'::integer NOT NULL,
    server_name character varying(60) DEFAULT '\"\"'::character varying NOT NULL
);


--
-- TOC entry 2695 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN pp_task_log.task_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_log.task_id IS '任务ID';


--
-- TOC entry 2696 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN pp_task_log.output; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_log.output IS '任务输出';


--
-- TOC entry 2697 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN pp_task_log.error; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_log.error IS '错误信息';


--
-- TOC entry 2698 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN pp_task_log.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_log.status IS '状态';


--
-- TOC entry 2699 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN pp_task_log.process_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_log.process_time IS '消耗时间/毫秒';


--
-- TOC entry 2700 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN pp_task_log.create_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_log.create_time IS '创建时间';


--
-- TOC entry 2701 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN pp_task_log.server_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_log.server_id IS '服务器ID，-1，异常';


--
-- TOC entry 2702 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN pp_task_log.server_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_log.server_name IS '服务器名称';


--
-- TOC entry 202 (class 1259 OID 19616)
-- Name: pp_task_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pp_task_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2703 (class 0 OID 0)
-- Dependencies: 202
-- Name: pp_task_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pp_task_log_id_seq OWNED BY public.pp_task_log.id;


--
-- TOC entry 205 (class 1259 OID 19633)
-- Name: pp_task_server; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pp_task_server (
    id integer NOT NULL,
    group_id integer NOT NULL,
    server_name character varying(64) DEFAULT '0'::character varying NOT NULL,
    server_account character varying(32) DEFAULT 'root'::character varying NOT NULL,
    server_outer_ip character varying(20) DEFAULT '0'::character varying NOT NULL,
    server_ip character varying(20) DEFAULT '0'::character varying NOT NULL,
    port integer DEFAULT 22 NOT NULL,
    password character varying(64) DEFAULT '0'::character varying NOT NULL,
    private_key_src character varying(128) DEFAULT '0'::character varying NOT NULL,
    public_key_src character varying(128) DEFAULT '0'::character varying NOT NULL,
    type smallint DEFAULT '0'::smallint NOT NULL,
    detail character varying(255) DEFAULT '0'::character varying NOT NULL,
    create_time integer DEFAULT 0 NOT NULL,
    update_time integer DEFAULT 0 NOT NULL,
    status smallint DEFAULT '0'::smallint NOT NULL,
    connection_type smallint DEFAULT '0'::smallint NOT NULL
);


--
-- TOC entry 2704 (class 0 OID 0)
-- Dependencies: 205
-- Name: TABLE pp_task_server; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.pp_task_server IS '服务器列表';


--
-- TOC entry 2705 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN pp_task_server.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_server.id IS '自增ID';


--
-- TOC entry 2706 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN pp_task_server.server_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_server.server_name IS '服务器名称';


--
-- TOC entry 2707 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN pp_task_server.server_account; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_server.server_account IS '账户名称';


--
-- TOC entry 2708 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN pp_task_server.server_outer_ip; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_server.server_outer_ip IS '外网IP';


--
-- TOC entry 2709 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN pp_task_server.server_ip; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_server.server_ip IS '服务器内网IP';


--
-- TOC entry 2710 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN pp_task_server.port; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_server.port IS '服务器端口';


--
-- TOC entry 2711 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN pp_task_server.password; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_server.password IS '服务器密码';


--
-- TOC entry 2712 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN pp_task_server.private_key_src; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_server.private_key_src IS '私钥文件地址';


--
-- TOC entry 2713 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN pp_task_server.public_key_src; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_server.public_key_src IS '公钥地址';


--
-- TOC entry 2714 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN pp_task_server.type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_server.type IS '登录类型：0-密码登录，1-私钥登录';


--
-- TOC entry 2715 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN pp_task_server.detail; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_server.detail IS '备注';


--
-- TOC entry 2716 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN pp_task_server.create_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_server.create_time IS '创建时间';


--
-- TOC entry 2717 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN pp_task_server.update_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_server.update_time IS '更新时间';


--
-- TOC entry 2718 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN pp_task_server.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_server.status IS '状态：0-正常，1-删除';


--
-- TOC entry 2719 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN pp_task_server.connection_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_server.connection_type IS '连接类型 0:SSH;1:Telnet;';


--
-- TOC entry 207 (class 1259 OID 19657)
-- Name: pp_task_server_group; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pp_task_server_group (
    id integer NOT NULL,
    group_name character varying(50) DEFAULT '0'::character varying NOT NULL,
    description character varying(255) DEFAULT ''::character varying NOT NULL,
    status smallint DEFAULT '1'::smallint NOT NULL,
    create_time integer DEFAULT 0 NOT NULL,
    update_time integer DEFAULT 0 NOT NULL,
    create_id integer DEFAULT 0 NOT NULL,
    update_id integer DEFAULT 0 NOT NULL
);


--
-- TOC entry 2720 (class 0 OID 0)
-- Dependencies: 207
-- Name: COLUMN pp_task_server_group.group_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_server_group.group_name IS '组名';


--
-- TOC entry 2721 (class 0 OID 0)
-- Dependencies: 207
-- Name: COLUMN pp_task_server_group.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_server_group.description IS '说明';


--
-- TOC entry 2722 (class 0 OID 0)
-- Dependencies: 207
-- Name: COLUMN pp_task_server_group.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_server_group.status IS '1-正常，0-删除';


--
-- TOC entry 2723 (class 0 OID 0)
-- Dependencies: 207
-- Name: COLUMN pp_task_server_group.create_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_server_group.create_time IS '创建时间';


--
-- TOC entry 2724 (class 0 OID 0)
-- Dependencies: 207
-- Name: COLUMN pp_task_server_group.update_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_server_group.update_time IS '更新时间';


--
-- TOC entry 2725 (class 0 OID 0)
-- Dependencies: 207
-- Name: COLUMN pp_task_server_group.create_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_server_group.create_id IS '用户ID';


--
-- TOC entry 2726 (class 0 OID 0)
-- Dependencies: 207
-- Name: COLUMN pp_task_server_group.update_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_task_server_group.update_id IS '更新id';


--
-- TOC entry 206 (class 1259 OID 19655)
-- Name: pp_task_server_group_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pp_task_server_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2727 (class 0 OID 0)
-- Dependencies: 206
-- Name: pp_task_server_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pp_task_server_group_id_seq OWNED BY public.pp_task_server_group.id;


--
-- TOC entry 204 (class 1259 OID 19631)
-- Name: pp_task_server_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pp_task_server_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2728 (class 0 OID 0)
-- Dependencies: 204
-- Name: pp_task_server_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pp_task_server_id_seq OWNED BY public.pp_task_server.id;


--
-- TOC entry 209 (class 1259 OID 19672)
-- Name: pp_uc_admin; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pp_uc_admin (
    id integer NOT NULL,
    login_name character varying(20) DEFAULT ''::character varying NOT NULL,
    real_name character varying(32) DEFAULT '0'::character varying NOT NULL,
    password character(32) DEFAULT ''::bpchar NOT NULL,
    role_ids character varying(255) DEFAULT '0'::character varying NOT NULL,
    phone character varying(20) DEFAULT '0'::character varying NOT NULL,
    email character varying(50) DEFAULT ''::character varying NOT NULL,
    salt character(10) DEFAULT ''::bpchar NOT NULL,
    last_login integer DEFAULT 0 NOT NULL,
    last_ip character(15) DEFAULT ''::bpchar NOT NULL,
    status smallint DEFAULT '0'::smallint NOT NULL,
    create_id integer DEFAULT 0 NOT NULL,
    update_id integer DEFAULT 0 NOT NULL,
    create_time integer DEFAULT 0 NOT NULL,
    update_time integer DEFAULT 0 NOT NULL,
    dingtalk character varying(64),
    wechat character varying(64)
);


--
-- TOC entry 2729 (class 0 OID 0)
-- Dependencies: 209
-- Name: TABLE pp_uc_admin; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.pp_uc_admin IS '管理员表';


--
-- TOC entry 2730 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN pp_uc_admin.login_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_admin.login_name IS '用户名';


--
-- TOC entry 2731 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN pp_uc_admin.real_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_admin.real_name IS '真实姓名';


--
-- TOC entry 2732 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN pp_uc_admin.password; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_admin.password IS '密码';


--
-- TOC entry 2733 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN pp_uc_admin.role_ids; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_admin.role_ids IS '角色id字符串，如：2,3,4';


--
-- TOC entry 2734 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN pp_uc_admin.phone; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_admin.phone IS '手机号码';


--
-- TOC entry 2735 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN pp_uc_admin.email; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_admin.email IS '邮箱';


--
-- TOC entry 2736 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN pp_uc_admin.salt; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_admin.salt IS '密码盐';


--
-- TOC entry 2737 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN pp_uc_admin.last_login; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_admin.last_login IS '最后登录时间';


--
-- TOC entry 2738 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN pp_uc_admin.last_ip; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_admin.last_ip IS '最后登录IP';


--
-- TOC entry 2739 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN pp_uc_admin.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_admin.status IS '状态，1-正常 0禁用';


--
-- TOC entry 2740 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN pp_uc_admin.create_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_admin.create_id IS '创建者ID';


--
-- TOC entry 2741 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN pp_uc_admin.update_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_admin.update_id IS '修改者ID';


--
-- TOC entry 2742 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN pp_uc_admin.create_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_admin.create_time IS '创建时间';


--
-- TOC entry 2743 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN pp_uc_admin.update_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_admin.update_time IS '修改时间';


--
-- TOC entry 2744 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN pp_uc_admin.dingtalk; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_admin.dingtalk IS '钉钉';


--
-- TOC entry 2745 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN pp_uc_admin.wechat; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_admin.wechat IS '微信';


--
-- TOC entry 208 (class 1259 OID 19670)
-- Name: pp_uc_admin_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pp_uc_admin_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2746 (class 0 OID 0)
-- Dependencies: 208
-- Name: pp_uc_admin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pp_uc_admin_id_seq OWNED BY public.pp_uc_admin.id;


--
-- TOC entry 211 (class 1259 OID 19694)
-- Name: pp_uc_auth; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pp_uc_auth (
    id integer NOT NULL,
    pid integer DEFAULT 0 NOT NULL,
    auth_name character varying(64) DEFAULT '0'::character varying NOT NULL,
    auth_url character varying(255) DEFAULT '0'::character varying NOT NULL,
    sort smallint DEFAULT '999'::smallint NOT NULL,
    icon character varying(255) NOT NULL,
    is_show smallint DEFAULT '0'::smallint NOT NULL,
    user_id integer DEFAULT 0 NOT NULL,
    create_id integer DEFAULT 0 NOT NULL,
    update_id integer DEFAULT 0 NOT NULL,
    status smallint DEFAULT '1'::smallint NOT NULL,
    create_time integer DEFAULT 0 NOT NULL,
    update_time integer DEFAULT 0 NOT NULL
);


--
-- TOC entry 2747 (class 0 OID 0)
-- Dependencies: 211
-- Name: TABLE pp_uc_auth; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.pp_uc_auth IS '权限因子';


--
-- TOC entry 2748 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN pp_uc_auth.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_auth.id IS '自增ID';


--
-- TOC entry 2749 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN pp_uc_auth.pid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_auth.pid IS '上级ID，0为顶级';


--
-- TOC entry 2750 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN pp_uc_auth.auth_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_auth.auth_name IS '权限名称';


--
-- TOC entry 2751 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN pp_uc_auth.auth_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_auth.auth_url IS 'URL地址';


--
-- TOC entry 2752 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN pp_uc_auth.sort; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_auth.sort IS '排序，越小越前';


--
-- TOC entry 2753 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN pp_uc_auth.is_show; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_auth.is_show IS '是否显示，0-隐藏，1-显示';


--
-- TOC entry 2754 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN pp_uc_auth.user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_auth.user_id IS '操作者ID';


--
-- TOC entry 2755 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN pp_uc_auth.create_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_auth.create_id IS '创建者ID';


--
-- TOC entry 2756 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN pp_uc_auth.update_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_auth.update_id IS '修改者ID';


--
-- TOC entry 2757 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN pp_uc_auth.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_auth.status IS '状态，1-正常，0-删除';


--
-- TOC entry 2758 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN pp_uc_auth.create_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_auth.create_time IS '创建时间';


--
-- TOC entry 2759 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN pp_uc_auth.update_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_auth.update_time IS '更新时间';


--
-- TOC entry 210 (class 1259 OID 19692)
-- Name: pp_uc_auth_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pp_uc_auth_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2760 (class 0 OID 0)
-- Dependencies: 210
-- Name: pp_uc_auth_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pp_uc_auth_id_seq OWNED BY public.pp_uc_auth.id;


--
-- TOC entry 213 (class 1259 OID 19718)
-- Name: pp_uc_role; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pp_uc_role (
    id integer NOT NULL,
    role_name character varying(32) DEFAULT '0'::character varying NOT NULL,
    detail character varying(255) DEFAULT '0'::character varying NOT NULL,
    server_group_ids character varying(255) DEFAULT '0'::character varying NOT NULL,
    task_group_ids character varying(255) DEFAULT '0'::character varying NOT NULL,
    create_id integer DEFAULT 0 NOT NULL,
    update_id integer DEFAULT 0 NOT NULL,
    status smallint DEFAULT '1'::smallint NOT NULL,
    create_time integer DEFAULT 0 NOT NULL,
    update_time integer DEFAULT 0 NOT NULL
);


--
-- TOC entry 2761 (class 0 OID 0)
-- Dependencies: 213
-- Name: TABLE pp_uc_role; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.pp_uc_role IS '角色表';


--
-- TOC entry 2762 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN pp_uc_role.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_role.id IS '主键ID';


--
-- TOC entry 2763 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN pp_uc_role.role_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_role.role_name IS '角色名称';


--
-- TOC entry 2764 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN pp_uc_role.detail; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_role.detail IS '备注';


--
-- TOC entry 2765 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN pp_uc_role.server_group_ids; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_role.server_group_ids IS '服务器分组权限ids,1,2,3';


--
-- TOC entry 2766 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN pp_uc_role.task_group_ids; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_role.task_group_ids IS '任务分组权限ids ,1,2,32';


--
-- TOC entry 2767 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN pp_uc_role.create_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_role.create_id IS '创建者ID';


--
-- TOC entry 2768 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN pp_uc_role.update_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_role.update_id IS '修改者ID';


--
-- TOC entry 2769 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN pp_uc_role.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_role.status IS '状态1-正常，0-删除';


--
-- TOC entry 2770 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN pp_uc_role.create_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_role.create_time IS '添加时间';


--
-- TOC entry 2771 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN pp_uc_role.update_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_role.update_time IS '修改时间';


--
-- TOC entry 216 (class 1259 OID 19792)
-- Name: pp_uc_role_auth; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pp_uc_role_auth (
    role_id integer DEFAULT 0 NOT NULL,
    auth_id integer DEFAULT 0 NOT NULL
);


--
-- TOC entry 2772 (class 0 OID 0)
-- Dependencies: 216
-- Name: TABLE pp_uc_role_auth; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.pp_uc_role_auth IS '权限和角色关系表';


--
-- TOC entry 2773 (class 0 OID 0)
-- Dependencies: 216
-- Name: COLUMN pp_uc_role_auth.role_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_role_auth.role_id IS '角色ID';


--
-- TOC entry 2774 (class 0 OID 0)
-- Dependencies: 216
-- Name: COLUMN pp_uc_role_auth.auth_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pp_uc_role_auth.auth_id IS '权限ID';


--
-- TOC entry 212 (class 1259 OID 19716)
-- Name: pp_uc_role_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pp_uc_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2775 (class 0 OID 0)
-- Dependencies: 212
-- Name: pp_uc_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pp_uc_role_id_seq OWNED BY public.pp_uc_role.id;


--
-- TOC entry 2468 (class 2604 OID 19759)
-- Name: pp_notify_tpl id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pp_notify_tpl ALTER COLUMN id SET DEFAULT nextval('public.pp_notify_tpl_id_seq'::regclass);


--
-- TOC entry 2369 (class 2604 OID 19566)
-- Name: pp_task id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pp_task ALTER COLUMN id SET DEFAULT nextval('public.pp_task_id_seq'::regclass);


--
-- TOC entry 2389 (class 2604 OID 19594)
-- Name: pp_task_ban id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pp_task_ban ALTER COLUMN id SET DEFAULT nextval('public.pp_task_ban_id_seq'::regclass);


--
-- TOC entry 2394 (class 2604 OID 19606)
-- Name: pp_task_group id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pp_task_group ALTER COLUMN id SET DEFAULT nextval('public.pp_task_group_id_seq'::regclass);


--
-- TOC entry 2402 (class 2604 OID 19621)
-- Name: pp_task_log id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pp_task_log ALTER COLUMN id SET DEFAULT nextval('public.pp_task_log_id_seq'::regclass);


--
-- TOC entry 2408 (class 2604 OID 19636)
-- Name: pp_task_server id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pp_task_server ALTER COLUMN id SET DEFAULT nextval('public.pp_task_server_id_seq'::regclass);


--
-- TOC entry 2423 (class 2604 OID 19660)
-- Name: pp_task_server_group id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pp_task_server_group ALTER COLUMN id SET DEFAULT nextval('public.pp_task_server_group_id_seq'::regclass);


--
-- TOC entry 2431 (class 2604 OID 19675)
-- Name: pp_uc_admin id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pp_uc_admin ALTER COLUMN id SET DEFAULT nextval('public.pp_uc_admin_id_seq'::regclass);


--
-- TOC entry 2446 (class 2604 OID 19697)
-- Name: pp_uc_auth id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pp_uc_auth ALTER COLUMN id SET DEFAULT nextval('public.pp_uc_auth_id_seq'::regclass);


--
-- TOC entry 2458 (class 2604 OID 19721)
-- Name: pp_uc_role id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pp_uc_role ALTER COLUMN id SET DEFAULT nextval('public.pp_uc_role_id_seq'::regclass);


--
-- TOC entry 2639 (class 0 OID 19756)
-- Dependencies: 215
-- Data for Name: pp_notify_tpl; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.pp_notify_tpl VALUES (1, 'system', '默认邮箱通知模板', 0, '定时任务异常：{{TaskName}}', 'Hello,定时任务出问题了：\r\n<p style=\"font-size:16px;\">任务执行详情：</p>\r\n<p style=\"display:block; padding:10px; background:#efefef;border:1px solid #e4e4e4\">\r\n任务 ID：{{TaskId}}<br/>\r\n任务名称：{{TaskName}}<br/>\r\n执行命令：{{ExecuteCommand}}<br/>\r\n执行时间：{{ExecuteTime}}<br/>\r\n执行耗时：{{ProcessTime}}秒<br/>\r\n执行状态：{{ExecuteStatus}}\r\n</p>\r\n<p style=\"font-size:16px;\">任务执行输出</p>\r\n<p style=\"display:block; padding:10px; background:#efefef;border:1px solid #e4e4e4\">\r\n{{TaskOutput}}\r\n</p>\r\n<p style=\"font-size:16px;\">错误输出</p>\r\n<p style=\"display:block; padding:10px; background:#efefef;border:1px solid #e4e4e4\">\r\n{{ErrorOutput}}\r\n</p>', 1, 1550255030, 1, 1553282382, 1);
INSERT INTO public.pp_notify_tpl VALUES (2, 'system', '默认短信通知模板', 1, '', '{\r\n    \"task_id\": \"{{TaskId}}\",\r\n    \"task_name\": \"{{TaskName}}\",\r\n    \"execute_command\": \"{{ExecuteCommand}}\",\r\n    \"execute_status\": \"{{ExecuteStatus}}\"\r\n}', 1, 1550255030, 1, 1550338215, 1);
INSERT INTO public.pp_notify_tpl VALUES (3, 'system', '默认钉钉通知模板', 2, '', '{\r\n    \"msgtype\": \"text\",\r\n    \"text\": {\r\n        \"content\": \"任务执行异常详情：\\n任务 ID：{{TaskId}}\\n任务名称：{{TaskName}}\\n执行命令：{{ExecuteCommand}}\\n执行时间：{{ExecuteTime}}\\n执行耗时：{{ProcessTime}}秒\\n执行状态：{{ExecuteStatus}}\\n任务执行输出：\\n{{TaskOutput}}\\n错误输出：\\n{{ErrorOutput}}\"\r\n    }\r\n}', 1, 1550255030, 1, 1553282245, 1);
INSERT INTO public.pp_notify_tpl VALUES (4, 'system', '默认微信通知模板', 3, '', '{\r\n    \"task_id\": \"{{TaskId}}\",\r\n    \"task_name\": \"{{TaskName}}\",\r\n    \"execute_command\": \"{{ExecuteCommand}}\",\r\n    \"execute_status\": \"{{ExecuteStatus}}\"\r\n}', 1, 1550347183, 1, 1550347201, 1);


--
-- TOC entry 2621 (class 0 OID 19563)
-- Dependencies: 197
-- Data for Name: pp_task; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.pp_task VALUES (1, 3, '2', '打印服务器内存', '2秒钟一次', '*/2 * * * *', 0, 'free -G', 0, 334, 1531645982, 0, 0, '0', 0, 1497855526, 0, 1531644960, 1, 0, 1);
INSERT INTO public.pp_task VALUES (2, 2, '1', '外部测试服务器', '8秒钟一次', '*/8 * * * * *', 0, 'echo \"hello world \\n\" >> /tmp/ppgo.log&& echo \"Hello world\"', 0, 151, 1531462016, 0, 0, '0', 2, 1502876155, 0, 1531645495, 1, 0, 1);
INSERT INTO public.pp_task VALUES (3, 1, '1', '审核不通过的任务测试', '2s执行一次', '*/2 *  *  *  *', 0, '/webroot/server/php/bin/php /webroot/www/default/test2.php', 0, 26, 1531275962, 0, 0, '0', 2, 1502936077, 0, 1531644281, 1, 0, 1);
INSERT INTO public.pp_task VALUES (4, 2, '0', '输出错误', '5秒执行一次', '*/5 * * * *', 0, 'tthh', 0, 72, 1531722855, 0, 0, '0', 0, 1502945973, 0, 1531645619, 1, 0, 1);
INSERT INTO public.pp_task VALUES (5, 1, '0', '密码验证任务112', '5秒执行一次', '*/5 * * * *', 0, '/webroot/server/php/bin/php /webroot/www/default/test2.php', 0, 29, 1531468808, 0, 0, '0', 3, 1503991581, 0, 1531723027, 1, 0, 1);
INSERT INTO public.pp_task VALUES (6, 1, '0', '打印并输出', '10秒一次，打印 hello ppgo_job', '*/10 * * * *', 0, 'echo \"hello ppgo_job\\n\" >> /tmp/test_ppgo.log', 0, 162, 1531722930, 0, 0, '0', 0, 1530599445, 1, 1531644960, 1, 0, 1);
INSERT INTO public.pp_task VALUES (7, 3, '1', '打印ppgo', '5秒一次', '*/5 * * * * *', 0, 'echo \"hello ppgo\\n\" >> /tmp/ppgo.log&&echo \"yes\\n\"', 0, 108, 1531645980, 0, 0, '0', 0, 1530761019, 1, 1531645347, 1, 0, 1);
INSERT INTO public.pp_task VALUES (8, 3, '3', '查看网络情况', '5秒一次', '*/5 * * * * *', 0, 'ifconfig', 0, 59, 1531645980, 0, 0, '0', 0, 1531468119, 1, 1531645083, 1, 0, 1);
INSERT INTO public.pp_task VALUES (9, 1, '0', '查看磁盘情况-短信', '5秒一次', '*/5 * * * * *', 0, 'df -h', 0, 46, 1531722935, 1, 1, '5,3,2', 0, 1531468712, 1, 1533702062, 1, 0, 1);
INSERT INTO public.pp_task VALUES (10, 1, '0', '测试通知通知的任务', '用于测试通知邮件的任务', '0 */5 * * *', 0, 'sleep 1s & lsss', 1, 22, 1533783831, 1, 0, '2', 0, 1533697794, 1, 1533781696, 1, 0, 1);


--
-- TOC entry 2623 (class 0 OID 19591)
-- Dependencies: 199
-- Data for Name: pp_task_ban; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.pp_task_ban VALUES (1, 'rm -rf', 1528639322, 1528639692, 0);
INSERT INTO public.pp_task_ban VALUES (2, 'dd if=/dev/random of=/dev/sda', 1528639322, 1528639588, 0);
INSERT INTO public.pp_task_ban VALUES (3, 'mkfs.ext3 /dev/sda', 1528639445, 0, 0);


--
-- TOC entry 2625 (class 0 OID 19603)
-- Dependencies: 201
-- Data for Name: pp_task_group; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.pp_task_group VALUES (1, '任务分组甲', '任务分组甲', 1, 1531643000, 1, 1531643000, 1);
INSERT INTO public.pp_task_group VALUES (2, '任务分组乙', '任务分组乙', 1, 1531643030, 1, 1531643030, 1);
INSERT INTO public.pp_task_group VALUES (3, '任务分组丙', '任务分组丙', 1, 1531643070, 1, 1531643070, 1);


--
-- TOC entry 2627 (class 0 OID 19618)
-- Dependencies: 203
-- Data for Name: pp_task_log; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.pp_task_log VALUES (1, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:19815 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:9732 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:28901272 (27.5 MiB)  TX bytes:606185 (591.9 KiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 365, 1531645278, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (2, 7, 'yes\\n\n', '', 0, 436, 1531645325, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (3, 7, 'yes\\n\n', '', 0, 319, 1531645375, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (4, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 21, 1531645573, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (5, 1, '', 'Process exited with status 1:', -1, 293, 1531645698, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (6, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 11, 1531645700, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (7, 6, '', '', 0, 14, 1531645700, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (8, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663541 41176073   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 18, 1531645700, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (9, 7, 'yes\\n\n', '', 0, 448, 1531645700, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (10, 1, '', 'Process exited with status 1:', -1, 596, 1531645700, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (11, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:19911 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:9799 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:28912798 (27.5 MiB)  TX bytes:619389 (604.8 KiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 632, 1531645700, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (12, 1, '', 'Process exited with status 1:', -1, 252, 1531645702, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (13, 1, '', 'Process exited with status 1:', -1, 312, 1531645704, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (14, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 13, 1531645705, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (15, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663541 41176073   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 15, 1531645705, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (16, 7, 'yes\\n\n', '', 0, 423, 1531645705, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (17, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:19999 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:9861 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:28923348 (27.5 MiB)  TX bytes:631959 (617.1 KiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 454, 1531645705, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (18, 1, '', 'Process exited with status 1:', -1, 318, 1531645706, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (19, 1, '', 'Process exited with status 1:', -1, 310, 1531645708, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (20, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663541 41176073   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 11, 1531645710, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (21, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 12, 1531645710, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (22, 6, '', '', 0, 12, 1531645710, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (23, 7, 'yes\\n\n', '', 0, 356, 1531645710, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (24, 1, '', 'Process exited with status 1:', -1, 394, 1531645710, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (25, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:20115 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:9946 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:28937354 (27.5 MiB)  TX bytes:648771 (633.5 KiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 432, 1531645710, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (26, 1, '', 'Process exited with status 1:', -1, 452, 1531645712, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (27, 1, '', 'Process exited with status 1:', -1, 339, 1531645714, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (28, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 8, 1531645715, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (29, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663549 41176065   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 12, 1531645715, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (30, 7, 'yes\\n\n', '', 0, 327, 1531645715, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (60, 1, '', 'Process exited with status 1:', -1, 248, 1531645736, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (61, 1, '', 'Process exited with status 1:', -1, 247, 1531645738, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (62, 6, '', '', 0, 9, 1531645740, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (63, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663546 41176068   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 15, 1531645740, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (64, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 11, 1531645740, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (65, 7, 'yes\\n\n', '', 0, 421, 1531645740, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (95, 7, 'yes\\n\n', '', 0, 522, 1531645760, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (31, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:20203 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:10010 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:28947904 (27.6 MiB)  TX bytes:661461 (645.9 KiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 360, 1531645715, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (32, 1, '', 'Process exited with status 1:', -1, 236, 1531645716, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (33, 1, '', 'Process exited with status 1:', -1, 233, 1531645718, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (34, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663554 41176060   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 13, 1531645720, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (35, 6, '', '', 0, 15, 1531645720, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (36, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 18, 1531645720, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (37, 7, 'yes\\n\n', '', 0, 333, 1531645720, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (38, 1, '', 'Process exited with status 1:', -1, 434, 1531645720, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (39, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:20318 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:10094 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:28961908 (27.6 MiB)  TX bytes:678299 (662.4 KiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 443, 1531645720, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (40, 1, '', 'Process exited with status 1:', -1, 234, 1531645722, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (41, 1, '', 'Process exited with status 1:', -1, 237, 1531645724, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (42, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 9, 1531645725, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (43, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663546 41176068   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 14, 1531645725, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (44, 7, 'yes\\n\n', '', 0, 372, 1531645725, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (45, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:20405 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:10155 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:28972456 (27.6 MiB)  TX bytes:690883 (674.6 KiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 454, 1531645725, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (46, 1, '', 'Process exited with status 1:', -1, 227, 1531645726, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (47, 1, '', 'Process exited with status 1:', -1, 304, 1531645728, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (48, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663546 41176068   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 11, 1531645730, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (49, 6, '', '', 0, 11, 1531645730, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (50, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 15, 1531645730, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (51, 7, 'yes\\n\n', '', 0, 358, 1531645730, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (52, 1, '', 'Process exited with status 1:', -1, 398, 1531645730, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (53, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:20522 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:10239 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:28986522 (27.6 MiB)  TX bytes:707657 (691.0 KiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 424, 1531645730, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (54, 1, '', 'Process exited with status 1:', -1, 258, 1531645732, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (55, 1, '', 'Process exited with status 1:', -1, 345, 1531645734, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (56, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663546 41176068   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 10, 1531645735, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (57, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 11, 1531645735, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (58, 7, 'yes\\n\n', '', 0, 359, 1531645735, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (59, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:20610 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:10302 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:28997130 (27.6 MiB)  TX bytes:720355 (703.4 KiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 379, 1531645735, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (66, 1, '', 'Process exited with status 1:', -1, 502, 1531645740, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (67, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:20726 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:10384 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29011194 (27.6 MiB)  TX bytes:737067 (719.7 KiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 525, 1531645740, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (68, 1, '', 'Process exited with status 1:', -1, 218, 1531645742, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (69, 1, '', 'Process exited with status 1:', -1, 255, 1531645744, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (70, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 8, 1531645745, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (71, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663546 41176068   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 12, 1531645745, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (72, 7, 'yes\\n\n', '', 0, 331, 1531645745, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (73, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:20813 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:10442 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29021684 (27.6 MiB)  TX bytes:749413 (731.8 KiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 396, 1531645745, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (74, 1, '', 'Process exited with status 1:', -1, 313, 1531645746, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (75, 1, '', 'Process exited with status 1:', -1, 297, 1531645748, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (76, 6, '', '', 0, 13, 1531645750, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (77, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 12, 1531645750, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (78, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663549 41176065   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 10, 1531645750, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (79, 7, 'yes\\n\n', '', 0, 323, 1531645750, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (80, 1, '', 'Process exited with status 1:', -1, 368, 1531645750, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (81, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:20929 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:10526 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29035690 (27.6 MiB)  TX bytes:766245 (748.2 KiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 398, 1531645750, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (82, 1, '', 'Process exited with status 1:', -1, 247, 1531645752, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (83, 1, '', 'Process exited with status 1:', -1, 231, 1531645754, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (84, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 8, 1531645755, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (85, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663554 41176060   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 13, 1531645755, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (86, 7, 'yes\\n\n', '', 0, 343, 1531645755, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (87, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:21018 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:10588 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29046358 (27.7 MiB)  TX bytes:778889 (760.6 KiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 365, 1531645755, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (88, 1, '', 'Process exited with status 1:', -1, 245, 1531645756, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (89, 1, '', 'Process exited with status 1:', -1, 239, 1531645758, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (90, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 10, 1531645760, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (91, 6, '', '', 0, 13, 1531645760, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (92, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663567 41176047   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 19, 1531645760, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (93, 1, '', 'Process exited with status 1:', -1, 428, 1531645760, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (94, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:21135 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:10671 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29060424 (27.7 MiB)  TX bytes:795603 (776.9 KiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 466, 1531645760, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (96, 1, '', 'Process exited with status 1:', -1, 348, 1531645762, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (97, 1, '', 'Process exited with status 1:', -1, 238, 1531645764, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (98, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 10, 1531645765, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (99, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663567 41176047   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 13, 1531645765, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (100, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:21224 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:10735 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29070976 (27.7 MiB)  TX bytes:808361 (789.4 KiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 323, 1531645765, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (101, 7, 'yes\\n\n', '', 0, 367, 1531645765, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (102, 1, '', 'Process exited with status 1:', -1, 244, 1531645766, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (103, 1, '', 'Process exited with status 1:', -1, 265, 1531645768, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (104, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 10, 1531645770, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (105, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663575 41176039   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 11, 1531645770, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (106, 6, '', '', 0, 18, 1531645770, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (107, 7, 'yes\\n\n', '', 0, 397, 1531645770, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (108, 1, '', 'Process exited with status 1:', -1, 439, 1531645770, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (109, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:21339 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:10818 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29084922 (27.7 MiB)  TX bytes:825069 (805.7 KiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 452, 1531645770, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (110, 1, '', 'Process exited with status 1:', -1, 236, 1531645772, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (111, 1, '', 'Process exited with status 1:', -1, 253, 1531645774, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (112, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 10, 1531645775, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (113, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663575 41176039   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 14, 1531645775, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (114, 7, 'yes\\n\n', '', 0, 337, 1531645775, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (115, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:21426 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:10879 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29095470 (27.7 MiB)  TX bytes:837653 (818.0 KiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 392, 1531645775, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (116, 1, '', 'Process exited with status 1:', -1, 278, 1531645776, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (117, 1, '', 'Process exited with status 1:', -1, 259, 1531645778, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (118, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663575 41176039   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 12, 1531645780, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (119, 6, '', '', 0, 15, 1531645780, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (120, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 20, 1531645780, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (121, 7, 'yes\\n\n', '', 0, 486, 1531645780, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (122, 1, '', 'Process exited with status 1:', -1, 511, 1531645780, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (123, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:21542 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:10966 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29109534 (27.7 MiB)  TX bytes:854659 (834.6 KiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 531, 1531645780, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (124, 1, '', 'Process exited with status 1:', -1, 441, 1531645782, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (125, 1, '', 'Process exited with status 1:', -1, 268, 1531645784, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (126, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 8, 1531645785, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (127, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663575 41176039   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 13, 1531645785, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (128, 7, 'yes\\n\n', '', 0, 403, 1531645785, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (220, 1, '', 'Process exited with status 1:', -1, 363, 1531645852, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (221, 1, '', 'Process exited with status 1:', -1, 305, 1531645854, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (129, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:21629 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:11030 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29120024 (27.7 MiB)  TX bytes:867359 (847.0 KiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 483, 1531645785, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (130, 1, '', 'Process exited with status 1:', -1, 233, 1531645786, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (131, 1, '', 'Process exited with status 1:', -1, 283, 1531645788, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (132, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 11, 1531645790, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (133, 6, '', '', 0, 12, 1531645790, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (134, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663577 41176037   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 15, 1531645790, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (135, 7, 'yes\\n\n', '', 0, 488, 1531645790, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (136, 1, '', 'Process exited with status 1:', -1, 498, 1531645790, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (137, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:21747 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:11116 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29134208 (27.7 MiB)  TX bytes:884299 (863.5 KiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 520, 1531645790, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (138, 1, '', 'Process exited with status 1:', -1, 266, 1531645792, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (139, 1, '', 'Process exited with status 1:', -1, 252, 1531645794, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (140, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663580 41176034   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 10, 1531645795, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (141, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 11, 1531645795, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (142, 7, 'yes\\n\n', '', 0, 334, 1531645795, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (143, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:21836 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:11179 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29144876 (27.7 MiB)  TX bytes:896997 (875.9 KiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 355, 1531645795, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (144, 1, '', 'Process exited with status 1:', -1, 231, 1531645796, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (145, 1, '', 'Process exited with status 1:', -1, 271, 1531645798, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (146, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663580 41176034   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 16, 1531645800, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (147, 6, '', '', 0, 23, 1531645800, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (148, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 25, 1531645800, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (149, 7, 'yes\\n\n', '', 0, 348, 1531645800, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (150, 1, '', 'Process exited with status 1:', -1, 404, 1531645800, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (151, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:21949 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:11258 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29158528 (27.8 MiB)  TX bytes:913355 (891.9 KiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 430, 1531645800, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (152, 1, '', 'Process exited with status 1:', -1, 290, 1531645802, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (153, 1, '', 'Process exited with status 1:', -1, 232, 1531645804, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (154, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 10, 1531645805, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (155, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663580 41176034   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 12, 1531645805, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (156, 7, 'yes\\n\n', '', 0, 346, 1531645805, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (157, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:22039 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:11321 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29169256 (27.8 MiB)  TX bytes:926059 (904.3 KiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 393, 1531645805, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (158, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663583 41176031   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 11, 1531645810, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (159, 6, '', '', 0, 15, 1531645810, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (160, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 19, 1531645810, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (161, 7, 'yes\\n\n', '', 0, 395, 1531645810, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (162, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:22080 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:11352 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29174734 (27.8 MiB)  TX bytes:932881 (911.0 KiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 405, 1531645810, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (163, 1, '', 'Process exited with status 1:', -1, 5284, 1531645806, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (164, 1, '', 'Process exited with status 1:', -1, 254, 1531645812, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (165, 1, '', 'Process exited with status 1:', -1, 254, 1531645814, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (166, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 14, 1531645815, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (167, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663587 41176027   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 14, 1531645815, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (168, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:22185 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:11427 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29186838 (27.8 MiB)  TX bytes:947354 (925.1 KiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 321, 1531645815, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (169, 7, 'yes\\n\n', '', 0, 341, 1531645815, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (170, 1, '', 'Process exited with status 1:', -1, 235, 1531645816, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (171, 1, '', 'Process exited with status 1:', -1, 237, 1531645818, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (172, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663587 41176027   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 13, 1531645820, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (173, 6, '', '', 0, 16, 1531645820, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (174, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 16, 1531645820, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (175, 7, 'yes\\n\n', '', 0, 405, 1531645820, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (176, 1, '', 'Process exited with status 1:', -1, 470, 1531645820, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (177, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:22301 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:11511 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29200844 (27.8 MiB)  TX bytes:964180 (941.5 KiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 511, 1531645820, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (178, 1, '', 'Process exited with status 1:', -1, 336, 1531645822, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (179, 1, '', 'Process exited with status 1:', -1, 275, 1531645824, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (180, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 11, 1531645825, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (181, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663589 41176025   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 14, 1531645825, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (182, 7, 'yes\\n\n', '', 0, 362, 1531645825, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (183, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:22390 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:11574 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29211592 (27.8 MiB)  TX bytes:976986 (954.0 KiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 412, 1531645825, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (184, 1, '', 'Process exited with status 1:', -1, 325, 1531645826, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (185, 1, '', 'Process exited with status 1:', -1, 380, 1531645828, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (186, 6, '', '', 0, 12, 1531645830, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (187, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 10, 1531645830, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (188, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663589 41176025   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 20, 1531645830, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (189, 7, 'yes\\n\n', '', 0, 363, 1531645830, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (190, 1, '', 'Process exited with status 1:', -1, 404, 1531645830, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (222, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 11, 1531645855, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (191, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:22506 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:11657 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29225482 (27.8 MiB)  TX bytes:993642 (970.3 KiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 430, 1531645830, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (192, 1, '', 'Process exited with status 1:', -1, 263, 1531645832, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (193, 1, '', 'Process exited with status 1:', -1, 239, 1531645834, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (194, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 9, 1531645835, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (195, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663589 41176025   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 12, 1531645835, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (196, 7, 'yes\\n\n', '', 0, 335, 1531645835, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (197, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:22594 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:11720 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29236090 (27.8 MiB)  TX bytes:1006340 (982.7 KiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 360, 1531645835, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (198, 1, '', 'Process exited with status 1:', -1, 320, 1531645836, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (199, 1, '', 'Process exited with status 1:', -1, 271, 1531645838, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (200, 6, '', '', 0, 22, 1531645840, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (201, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663601 41176013   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 24, 1531645840, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (202, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 28, 1531645840, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (203, 7, 'yes\\n\n', '', 0, 487, 1531645840, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (204, 1, '', 'Process exited with status 1:', -1, 565, 1531645840, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (205, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:22711 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:11805 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29250156 (27.8 MiB)  TX bytes:1023168 (999.1 KiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 598, 1531645840, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (206, 1, '', 'Process exited with status 1:', -1, 229, 1531645842, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (207, 1, '', 'Process exited with status 1:', -1, 239, 1531645844, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (208, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 17, 1531645845, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (209, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663603 41176011   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 26, 1531645845, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (210, 7, 'yes\\n\n', '', 0, 528, 1531645845, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (211, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:22796 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:11865 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29260526 (27.9 MiB)  TX bytes:1035640 (1011.3 KiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 604, 1531645845, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (212, 1, '', 'Process exited with status 1:', -1, 287, 1531645846, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (213, 1, '', 'Process exited with status 1:', -1, 416, 1531645848, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (214, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 14, 1531645850, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (215, 6, '', '', 0, 17, 1531645850, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (216, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663603 41176011   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 19, 1531645850, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (217, 7, 'yes\\n\n', '', 0, 352, 1531645850, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (218, 1, '', 'Process exited with status 1:', -1, 464, 1531645850, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (219, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:22904 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:11945 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29273836 (27.9 MiB)  TX bytes:1051376 (1.0 MiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 477, 1531645850, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (223, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663596 41176018   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      642        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 13, 1531645855, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (224, 7, 'yes\\n\n', '', 0, 357, 1531645855, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (225, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:23001 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12013 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29285142 (27.9 MiB)  TX bytes:1065162 (1.0 MiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 415, 1531645855, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (226, 1, '', 'Process exited with status 1:', -1, 237, 1531645856, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (227, 1, '', 'Process exited with status 1:', -1, 350, 1531645858, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (228, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 21, 1531645860, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (229, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663600 41176014   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      641        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 24, 1531645860, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (230, 6, '', '', 0, 31, 1531645860, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (231, 7, 'yes\\n\n', '', 0, 462, 1531645860, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (232, 1, '', 'Process exited with status 1:', -1, 552, 1531645860, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (233, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:23116 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12095 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29299088 (27.9 MiB)  TX bytes:1081858 (1.0 MiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 569, 1531645860, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (234, 1, '', 'Process exited with status 1:', -1, 367, 1531645862, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (235, 1, '', 'Process exited with status 1:', -1, 356, 1531645864, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (236, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 9, 1531645865, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (237, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663607 41176007   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      641        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 12, 1531645865, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (238, 7, 'yes\\n\n', '', 0, 443, 1531645865, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (239, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:23203 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12159 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29309520 (27.9 MiB)  TX bytes:1094490 (1.0 MiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 475, 1531645865, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (240, 1, '', 'Process exited with status 1:', -1, 280, 1531645866, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (241, 1, '', 'Process exited with status 1:', -1, 261, 1531645868, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (242, 6, '', '', 0, 10, 1531645870, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (243, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663611 41176003   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      641        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 14, 1531645870, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (244, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 16, 1531645870, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (245, 7, 'yes\\n\n', '', 0, 319, 1531645870, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (246, 1, '', 'Process exited with status 1:', -1, 425, 1531645870, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (247, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:23320 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12243 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29323644 (27.9 MiB)  TX bytes:1111300 (1.0 MiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 449, 1531645870, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (248, 1, '', 'Process exited with status 1:', -1, 242, 1531645872, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (249, 1, '', 'Process exited with status 1:', -1, 239, 1531645874, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (250, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663604 41176010   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      641        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 11, 1531645875, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (251, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 12, 1531645875, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (310, 1, '', 'Process exited with status 1:', -1, 242, 1531645916, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (311, 1, '', 'Process exited with status 1:', -1, 338, 1531645918, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (312, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 13, 1531645920, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (313, 7, 'yes\\n\n', '', 0, 506, 1531645920, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (314, 1, '', 'Process exited with status 1:', -1, 564, 1531645920, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (252, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:23406 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12305 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29334016 (27.9 MiB)  TX bytes:1123870 (1.0 MiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 359, 1531645875, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (253, 7, 'yes\\n\n', '', 0, 365, 1531645875, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (254, 1, '', 'Process exited with status 1:', -1, 240, 1531645876, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (255, 1, '', 'Process exited with status 1:', -1, 248, 1531645878, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (256, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 11, 1531645880, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (257, 6, '', '', 0, 15, 1531645880, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (258, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663610 41176004   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      641        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 15, 1531645880, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (259, 7, 'yes\\n\n', '', 0, 385, 1531645880, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (260, 1, '', 'Process exited with status 1:', -1, 440, 1531645880, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (261, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:23521 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12387 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29347904 (27.9 MiB)  TX bytes:1140560 (1.0 MiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 461, 1531645880, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (262, 1, '', 'Process exited with status 1:', -1, 350, 1531645882, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (263, 1, '', 'Process exited with status 1:', -1, 345, 1531645884, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (264, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 12, 1531645885, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (265, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663613 41176001   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      641        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 15, 1531645885, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (266, 7, 'yes\\n\n', '', 0, 534, 1531645885, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (267, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:23609 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12451 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29358454 (27.9 MiB)  TX bytes:1153302 (1.0 MiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 624, 1531645885, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (268, 1, '', 'Process exited with status 1:', -1, 418, 1531645886, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (269, 1, '', 'Process exited with status 1:', -1, 292, 1531645888, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (270, 6, '', '', 0, 20, 1531645890, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (271, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 25, 1531645890, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (272, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663496 41176118   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      641        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 29, 1531645890, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (273, 7, 'yes\\n\n', '', 0, 475, 1531645890, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (274, 1, '', 'Process exited with status 1:', -1, 596, 1531645890, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (275, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:23727 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12538 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29372522 (28.0 MiB)  TX bytes:1170234 (1.1 MiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 642, 1531645890, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (276, 1, '', 'Process exited with status 1:', -1, 302, 1531645892, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (277, 1, '', 'Process exited with status 1:', -1, 302, 1531645894, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (278, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663569 41176045   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      641        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 10, 1531645895, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (279, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 11, 1531645895, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (280, 7, 'yes\\n\n', '', 0, 408, 1531645895, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (281, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:23814 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12599 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29383070 (28.0 MiB)  TX bytes:1182802 (1.1 MiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 429, 1531645895, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (282, 1, '', 'Process exited with status 1:', -1, 263, 1531645896, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (283, 1, '', 'Process exited with status 1:', -1, 333, 1531645898, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (284, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663573 41176041   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      641        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 10, 1531645898, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (285, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663573 41176041   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      641        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 13, 1531645900, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (286, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 16, 1531645900, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (287, 6, '', '', 0, 19, 1531645900, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (288, 7, 'yes\\n\n', '', 0, 371, 1531645900, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (289, 1, '', 'Process exited with status 1:', -1, 454, 1531645900, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (290, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:23933 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12686 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29397256 (28.0 MiB)  TX bytes:1199746 (1.1 MiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 472, 1531645900, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (291, 1, '', 'Process exited with status 1:', -1, 425, 1531645902, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (292, 1, '', 'Process exited with status 1:', -1, 355, 1531645904, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (293, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663578 41176036   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      641        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 22, 1531645905, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (294, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 21, 1531645905, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (295, 7, 'yes\\n\n', '', 0, 415, 1531645905, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (296, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:24021 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12750 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29407864 (28.0 MiB)  TX bytes:1212494 (1.1 MiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 466, 1531645905, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (297, 1, '', 'Process exited with status 1:', -1, 229, 1531645906, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (298, 1, '', 'Process exited with status 1:', -1, 281, 1531645908, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (299, 6, '', '', 0, 12, 1531645910, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (300, 9, 'Filesystem      Size   Used  Avail Capacity  iused    ifree %iused  Mounted on\n/dev/disk1     465Gi  307Gi  157Gi    67% 80663581 41176033   66%   /\ndevfs          185Ki  185Ki    0Bi   100%      641        0  100%   /dev\nmap -hosts       0Bi    0Bi    0Bi   100%        0        0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%        0        0  100%   /home\n', '', 0, 15, 1531645910, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (301, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 14, 1531645910, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (302, 7, 'yes\\n\n', '', 0, 410, 1531645910, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (303, 1, '', 'Process exited with status 1:', -1, 475, 1531645910, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (304, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:24134 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12830 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29421632 (28.0 MiB)  TX bytes:1229012 (1.1 MiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 491, 1531645910, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (305, 1, '', 'Process exited with status 1:', -1, 354, 1531645912, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (306, 1, '', 'Process exited with status 1:', -1, 306, 1531645914, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (307, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 7, 1531645915, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (308, 7, 'yes\\n\n', '', 0, 336, 1531645915, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (309, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:24217 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12890 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29431708 (28.0 MiB)  TX bytes:1241404 (1.1 MiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 433, 1531645915, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (315, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:24335 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12975 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29445892 (28.0 MiB)  TX bytes:1258268 (1.1 MiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 596, 1531645920, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (316, 1, '', 'Process exited with status 1:', -1, 307, 1531645922, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (317, 1, '', 'Process exited with status 1:', -1, 353, 1531645924, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (318, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 7, 1531645925, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (319, 7, 'yes\\n\n', '', 0, 443, 1531645925, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (320, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:24425 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:13039 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29456620 (28.0 MiB)  TX bytes:1271016 (1.2 MiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 502, 1531645925, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (321, 1, '', 'Process exited with status 1:', -1, 247, 1531645926, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (322, 1, '', 'Process exited with status 1:', -1, 282, 1531645928, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (323, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 7, 1531645930, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (324, 7, 'yes\\n\n', '', 0, 325, 1531645930, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (325, 1, '', 'Process exited with status 1:', -1, 414, 1531645930, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (326, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:24542 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:13124 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29470744 (28.1 MiB)  TX bytes:1287886 (1.2 MiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 437, 1531645930, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (327, 1, '', 'Process exited with status 1:', -1, 282, 1531645932, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (328, 1, '', 'Process exited with status 1:', -1, 346, 1531645934, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (329, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 7, 1531645935, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (330, 7, 'yes\\n\n', '', 0, 406, 1531645935, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (331, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:24631 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:13188 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29481412 (28.1 MiB)  TX bytes:1300622 (1.2 MiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 431, 1531645935, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (332, 1, '', 'Process exited with status 1:', -1, 254, 1531645936, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (333, 1, '', 'Process exited with status 1:', -1, 242, 1531645938, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (334, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 7, 1531645940, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (335, 7, 'yes\\n\n', '', 0, 343, 1531645940, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (336, 1, '', 'Process exited with status 1:', -1, 432, 1531645940, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (337, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:24743 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:13268 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29495120 (28.1 MiB)  TX bytes:1317088 (1.2 MiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 449, 1531645940, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (338, 1, '', 'Process exited with status 1:', -1, 242, 1531645942, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (339, 1, '', 'Process exited with status 1:', -1, 282, 1531645944, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (340, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 7, 1531645945, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (341, 7, 'yes\\n\n', '', 0, 445, 1531645945, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (342, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:24829 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:13328 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29505550 (28.1 MiB)  TX bytes:1329538 (1.2 MiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 509, 1531645945, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (343, 1, '', 'Process exited with status 1:', -1, 325, 1531645946, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (344, 1, '', 'Process exited with status 1:', -1, 267, 1531645948, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (345, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 11, 1531645950, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (346, 7, 'yes\\n\n', '', 0, 498, 1531645950, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (347, 1, '', 'Process exited with status 1:', -1, 542, 1531645950, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (348, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:24948 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:13413 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29519794 (28.1 MiB)  TX bytes:1346402 (1.2 MiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 564, 1531645950, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (349, 1, '', 'Process exited with status 1:', -1, 295, 1531645952, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (350, 1, '', 'Process exited with status 1:', -1, 282, 1531645954, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (351, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 8, 1531645955, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (352, 7, 'yes\\n\n', '', 0, 396, 1531645955, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (353, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:25037 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:13476 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29530462 (28.1 MiB)  TX bytes:1359078 (1.2 MiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 451, 1531645955, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (354, 1, '', 'Process exited with status 1:', -1, 285, 1531645956, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (355, 1, '', 'Process exited with status 1:', -1, 362, 1531645958, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (356, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 7, 1531645960, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (357, 7, 'yes\\n\n', '', 0, 318, 1531645960, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (358, 1, '', 'Process exited with status 1:', -1, 396, 1531645960, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (359, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:25153 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:13559 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29544526 (28.1 MiB)  TX bytes:1375828 (1.3 MiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 410, 1531645960, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (360, 1, '', 'Process exited with status 1:', -1, 337, 1531645962, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (361, 1, '', 'Process exited with status 1:', -1, 465, 1531645964, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (362, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 8, 1531645965, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (363, 7, 'yes\\n\n', '', 0, 368, 1531645965, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (364, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:25242 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:13622 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29555194 (28.1 MiB)  TX bytes:1388510 (1.3 MiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 461, 1531645965, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (365, 1, '', 'Process exited with status 1:', -1, 291, 1531645966, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (366, 1, '', 'Process exited with status 1:', -1, 340, 1531645968, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (367, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 7, 1531645970, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (368, 7, 'yes\\n\n', '', 0, 438, 1531645970, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (369, 1, '', 'Process exited with status 1:', -1, 493, 1531645970, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (370, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:25359 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:13709 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29569202 (28.1 MiB)  TX bytes:1405494 (1.3 MiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 507, 1531645970, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (371, 1, '', 'Process exited with status 1:', -1, 316, 1531645972, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (372, 1, '', 'Process exited with status 1:', -1, 273, 1531645974, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (373, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 8, 1531645975, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (374, 7, 'yes\\n\n', '', 0, 558, 1531645975, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (375, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:25441 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:13767 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29579276 (28.2 MiB)  TX bytes:1417766 (1.3 MiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 618, 1531645975, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (376, 1, '', 'Process exited with status 1:', -1, 342, 1531645976, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (377, 1, '', 'Process exited with status 1:', -1, 422, 1531645978, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (378, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 15, 1531645980, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (379, 7, 'yes\\n\n', '', 0, 489, 1531645980, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (380, 1, '', 'Process exited with status 1:', -1, 544, 1531645980, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (381, 8, 'eth1      Link encap:Ethernet  HWaddr 00:0C:29:CB:2C:63  \n          inet addr:172.16.210.153  Bcast:172.16.210.255  Mask:255.255.255.0\n          inet6 addr: fe80::20c:29ff:fecb:2c63/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:25559 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:13853 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:1000 \n          RX bytes:29593402 (28.2 MiB)  TX bytes:1434638 (1.3 MiB)\n\nlo        Link encap:Local Loopback  \n          inet addr:127.0.0.1  Mask:255.0.0.0\n          inet6 addr: ::1/128 Scope:Host\n          UP LOOPBACK RUNNING  MTU:65536  Metric:1\n          RX packets:12 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:624 (624.0 b)  TX bytes:624 (624.0 b)\n\n', '', 0, 586, 1531645980, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (382, 1, '', 'Process exited with status 1:', -1, 343, 1531645982, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (383, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 72, 1531722850, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (384, 4, '', 'exit status 127:sh: tthh: command not found\n', -1, 8, 1531722855, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (385, 6, '', '', 0, 21, 1531722930, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (386, 9, 'Filesystem      Size   Used  Avail Capacity iused               ifree %iused  Mounted on\n/dev/disk1s1   233Gi   44Gi  183Gi    20%  827232 9223372036853948575    0%   /\ndevfs          185Ki  185Ki    0Bi   100%     640                   0  100%   /dev\n/dev/disk1s4   233Gi  5.0Gi  183Gi     3%       4 9223372036854775803    0%   /private/var/vm\nmap -hosts       0Bi    0Bi    0Bi   100%       0                   0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%       0                   0  100%   /home\n', '', 0, 31, 1531722930, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (387, 9, 'Filesystem      Size   Used  Avail Capacity iused               ifree %iused  Mounted on\n/dev/disk1s1   233Gi   44Gi  183Gi    20%  827232 9223372036853948575    0%   /\ndevfs          185Ki  185Ki    0Bi   100%     640                   0  100%   /dev\n/dev/disk1s4   233Gi  5.0Gi  183Gi     3%       4 9223372036854775803    0%   /private/var/vm\nmap -hosts       0Bi    0Bi    0Bi   100%       0                   0  100%   /net\nmap auto_home    0Bi    0Bi    0Bi   100%       0                   0  100%   /home\n', '', 0, 13, 1531722935, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (388, 10, '', 'exit status 127:sh: ls-s: command not found\n', -1, 39, 1533777088, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (389, 10, '', 'exit status 127:sh: ls-s: command not found\n', -1, 25, 1533777370, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (390, 10, '', 'exit status 127:sh: ls-s: command not found\n', -1, 36, 1533777450, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (391, 10, '', 'exit status 127:sh: ls-s: command not found\n', -1, 22, 1533777561, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (392, 10, '', 'exit status 127:sh: ls-s: command not found\n', -1, 23, 1533777649, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (393, 10, '', 'exit status 127:sh: ls-s: command not found\n', -1, 21, 1533777745, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (394, 10, '', 'exit status 127:sh: ls-s: command not found\n', -1, 21, 1533777807, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (395, 10, '', 'exit status 127:sh: ls-s: command not found\n', -1, 19, 1533777859, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (396, 10, '', 'exit status 127:sh: ls-s: command not found\n', -1, 28, 1533778322, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (397, 10, '', 'exit status 127:sh: ls-s: command not found\n', -1, 38, 1533779412, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (398, 10, '', 'exit status 127:sh: ls-s: command not found\n', -1, 21, 1533779580, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (399, 10, '', 'exit status 127:sh: ls-s: command not found\n', -1, 51, 1533780177, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (400, 10, '', 'exit status 127:sh: ls-s: command not found\n', -1, 25, 1533780374, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (401, 10, '', 'exit status 127:sh: ls-s: command not found\n', -1, 27, 1533780731, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (402, 10, '', 'exit status 127:sh: ls-s: command not found\n', -1, 31, 1533781149, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (403, 10, '', 'exit status 127:sh: ls-s: command not found\n', -1, 33, 1533781493, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (404, 10, '', '任务执行超过 1 秒\n----------------------\nsh: lsss: command not found\n\n', -2, 1017, 1533781700, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (405, 10, '', '任务执行超过 1 秒\n----------------------\nsh: lsss: command not found\n\n', -2, 1010, 1533782997, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (406, 10, '', '任务执行超过 1 秒\n----------------------\nsh: lsss: command not found\n\n', -2, 1009, 1533783102, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (407, 10, '', '任务执行超过 1 秒\n----------------------\nsh: lsss: command not found\n\n', -2, 1010, 1533783421, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (408, 10, '', '任务执行超过 1 秒\n----------------------\nsh: lsss: command not found\n\n', -2, 1008, 1533783662, -1, '\"\"');
INSERT INTO public.pp_task_log VALUES (409, 10, '', '任务执行超过 1 秒\n----------------------\nsh: lsss: command not found\n\n', -2, 1012, 1533783831, -1, '\"\"');


--
-- TOC entry 2629 (class 0 OID 19633)
-- Dependencies: 205
-- Data for Name: pp_task_server; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.pp_task_server VALUES (1, 2, '密钥验证服务器', 'root', '0', '172.16.210.168', 22, '', '/Users/haodaquan/.ssh/my_service', '/Users/haodaquan/.ssh/my_service.pub', 1, '远程服务器示例', 1531642563, 1531642563, 0, 0);
INSERT INTO public.pp_task_server VALUES (2, 1, '密码验证服务器', 'root', '0', '172.16.210.153', 22, 'haodaquan2008', '', '', 0, '这是密码验证服务器', 1502945869, 1531618335, 0, 0);
INSERT INTO public.pp_task_server VALUES (3, 3, '测试服务器', 'root', '0', '172.16.210.153', 22, 'haodaquan2008', '', '', 0, '测试服务器', 1531641591, 1531641591, 0, 0);


--
-- TOC entry 2631 (class 0 OID 19657)
-- Dependencies: 207
-- Data for Name: pp_task_server_group; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.pp_task_server_group VALUES (1, '资源A组', '服务器A组', 1, 1531617485, 1531617485, 1, 1);
INSERT INTO public.pp_task_server_group VALUES (2, '资源B组', '服务器B组', 1, 1531617507, 1531617507, 1, 1);
INSERT INTO public.pp_task_server_group VALUES (3, '资源C组', '资源C组', 1, 1531617530, 1531617530, 1, 1);


--
-- TOC entry 2633 (class 0 OID 19672)
-- Dependencies: 209
-- Data for Name: pp_uc_admin; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.pp_uc_admin VALUES (2, 'test_1', 'pipi', 'b937149452da9f7a36f304dc00149edc', '1', '13811551087', 'haodaquan2008@163.com', '1Uep      ', 1531645875, '[              ', 1, 1, 1, 1528459479, 1533703722, NULL, NULL);
INSERT INTO public.pp_uc_admin VALUES (3, 'test_ppgo2', 'ppgo2', '5fc38807c6740436407bf80015a7cf06', '2', '13811889999', '333@123.com', 'Qph1      ', 0, '               ', 1, 1, 1, 1531645748, 1531645748, NULL, NULL);
INSERT INTO public.pp_uc_admin VALUES (4, 'test_ppgo3', 'ppgo3', '548a12147d443ea5a99a65ad4dd1ed30', '3', '13999990000', '222@123.com', '9Xta      ', 1531645939, '[              ', 1, 1, 1, 1531645785, 1531645785, NULL, NULL);
INSERT INTO public.pp_uc_admin VALUES (5, 'test_ppgo4', 'ppgo4', '3225f516ea8a1c27d695084e0b67b651', '2,1', '13777777999', '44@qq.com', '7QmD      ', 1531705759, '[              ', 1, 1, 1, 1531645832, 1531645832, NULL, NULL);
INSERT INTO public.pp_uc_admin VALUES (1, 'admin', '超级管理员', 'abfcf6dcedfb4b5b1505d41a8b4c77e8', '0', '13811551087', 'haodaquan2008@163.com', 'aYk4Q1P83v', 1569914032, '[              ', 1, 0, 1, 0, 1528462051, '', '');


--
-- TOC entry 2635 (class 0 OID 19694)
-- Dependencies: 211
-- Data for Name: pp_uc_auth; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.pp_uc_auth VALUES (1, 0, '所有权限', '/', 1, '', 0, 1, 1, 1, 1, 1505620970, 1505620970);
INSERT INTO public.pp_uc_auth VALUES (2, 1, '权限管理', '/', 999, 'fa-id-card', 1, 1, 0, 1, 1, 0, 1505622360);
INSERT INTO public.pp_uc_auth VALUES (3, 2, '用户管理', '/admin/list', 1, 'fa-user-o', 1, 0, 0, 0, 1, 0, 1528385411);
INSERT INTO public.pp_uc_auth VALUES (4, 2, '角色管理', '/role/list', 2, 'fa-user-circle-o', 1, 1, 0, 1, 1, 0, 1505621852);
INSERT INTO public.pp_uc_auth VALUES (5, 3, '新增', '/admin/add', 1, '', 0, 1, 0, 1, 1, 0, 1505621685);
INSERT INTO public.pp_uc_auth VALUES (6, 3, '修改', '/admin/edit', 2, '', 0, 1, 0, 1, 1, 0, 1505621697);
INSERT INTO public.pp_uc_auth VALUES (7, 3, '删除', '/admin/ajaxdel', 3, '', 0, 1, 1, 1, 1, 1505621756, 1505621756);
INSERT INTO public.pp_uc_auth VALUES (8, 4, '新增', '/role/add', 1, '', 1, 1, 0, 1, 1, 0, 1505698716);
INSERT INTO public.pp_uc_auth VALUES (9, 4, '修改', '/role/edit', 2, '', 0, 1, 1, 1, 1, 1505621912, 1505621912);
INSERT INTO public.pp_uc_auth VALUES (10, 4, '删除', '/role/ajaxdel', 3, '', 0, 1, 1, 1, 1, 1505621951, 1505621951);
INSERT INTO public.pp_uc_auth VALUES (11, 2, '权限因子', '/auth/list', 3, 'fa-list', 1, 1, 1, 1, 1, 1505621986, 1505621986);
INSERT INTO public.pp_uc_auth VALUES (12, 11, '新增', '/auth/add', 1, '', 0, 1, 1, 1, 1, 1505622009, 1505622009);
INSERT INTO public.pp_uc_auth VALUES (13, 11, '修改', '/auth/edit', 2, '', 0, 1, 1, 1, 1, 1505622047, 1505622047);
INSERT INTO public.pp_uc_auth VALUES (14, 11, '删除', '/auth/ajaxdel', 3, '', 0, 1, 1, 1, 1, 1505622111, 1505622111);
INSERT INTO public.pp_uc_auth VALUES (15, 1, '个人中心', 'profile/edit', 1001, 'fa-user-circle-o', 1, 1, 0, 1, 1, 0, 1506001114);
INSERT INTO public.pp_uc_auth VALUES (16, 15, '资料修改', '/user/edit', 1, 'fa-edit', 1, 0, 0, 0, 1, 1528385551, 1528385551);
INSERT INTO public.pp_uc_auth VALUES (17, 1, '基本设置', '/', 2, 'fa-cogs', 1, 1, 0, 1, 1, 0, 1528464467);
INSERT INTO public.pp_uc_auth VALUES (18, 17, '资源分组', '/servergroup/list', 2, 'fa-cubes', 1, 1, 0, 1, 1, 0, 1528466663);
INSERT INTO public.pp_uc_auth VALUES (19, 17, '资源管理', '/server/list', 1, 'fa-cube', 1, 1, 0, 1, 1, 0, 1528464498);
INSERT INTO public.pp_uc_auth VALUES (20, 17, '禁用命令', '/ban/list', 3, 'fa-exclamation-triangle', 1, 1, 0, 1, 1, 0, 1528464656);
INSERT INTO public.pp_uc_auth VALUES (21, 18, '新增', '/servergroup/add', 1, '', 0, 1, 0, 1, 1, 0, 1528466669);
INSERT INTO public.pp_uc_auth VALUES (22, 18, '修改', '/servergroup/edit', 2, '', 0, 1, 0, 1, 1, 0, 1528466675);
INSERT INTO public.pp_uc_auth VALUES (23, 18, '删除', '/servergroup/ajaxdel', 3, '', 0, 1, 0, 1, 1, 0, 1528466684);
INSERT INTO public.pp_uc_auth VALUES (24, 19, '新增', '/server/add', 1, '', 0, 1, 1, 1, 1, 1528464882, 1528464882);
INSERT INTO public.pp_uc_auth VALUES (25, 19, '修改', '/server/edit', 2, '', 0, 1, 1, 1, 1, 1528464904, 1528464904);
INSERT INTO public.pp_uc_auth VALUES (26, 19, '删除', '/server/ajaxdel', 3, '', 0, 1, 1, 1, 1, 1528464937, 1528464937);
INSERT INTO public.pp_uc_auth VALUES (27, 20, '新增', '/ban/add', 1, '', 0, 1, 1, 1, 1, 1528464977, 1528464977);
INSERT INTO public.pp_uc_auth VALUES (28, 20, '修改', '/ban/edit', 2, '', 0, 1, 1, 1, 1, 1528465005, 1528465005);
INSERT INTO public.pp_uc_auth VALUES (29, 20, '删除', '/ban/ajaxdel', 3, '', 0, 1, 1, 1, 1, 1528465036, 1528465036);
INSERT INTO public.pp_uc_auth VALUES (30, 1, '任务管理', '/job/list', 1, 'fa-tasks', 1, 1, 1, 1, 1, 1528639988, 1528639988);
INSERT INTO public.pp_uc_auth VALUES (31, 30, '任务列表', '/task/list', 1, 'fa-object-ungroup', 1, 1, 0, 1, 1, 0, 1531212830);
INSERT INTO public.pp_uc_auth VALUES (32, 30, '任务分组', '/group/list', 3, 'fa-object-group', 1, 1, 0, 1, 1, 0, 1531212219);
INSERT INTO public.pp_uc_auth VALUES (33, 32, '新增', '/group/add', 1, '', 0, 1, 1, 1, 1, 1528640546, 1528640546);
INSERT INTO public.pp_uc_auth VALUES (34, 32, '编辑', '/group/edit', 2, '', 0, 1, 1, 1, 1, 1528640572, 1528640572);
INSERT INTO public.pp_uc_auth VALUES (35, 32, '删除', '/group/ajaxdel', 3, '', 0, 1, 1, 1, 1, 1528640604, 1528640604);
INSERT INTO public.pp_uc_auth VALUES (36, 31, '新增', '/task/add', 1, '', 0, 1, 1, 1, 1, 1528728220, 1528728220);
INSERT INTO public.pp_uc_auth VALUES (37, 31, '编辑', '/task/edit', 2, '', 0, 1, 1, 1, 1, 1528728251, 1528728251);
INSERT INTO public.pp_uc_auth VALUES (38, 42, '删除', '/task/ajaxdel', 3, '', 0, 1, 0, 1, 1, 0, 1531279999);
INSERT INTO public.pp_uc_auth VALUES (39, 31, '查看', '/task/detail', 3, '', 0, 1, 0, 1, 1, 0, 1531279407);
INSERT INTO public.pp_uc_auth VALUES (40, 42, '审核通过', '/task/ajaxaudit', 5, '', 0, 1, 0, 1, 1, 0, 1531466535);
INSERT INTO public.pp_uc_auth VALUES (41, 31, '复制', '/task/copy', 5, '', 0, 1, 0, 1, 1, 0, 1531286150);
INSERT INTO public.pp_uc_auth VALUES (42, 30, '任务审核', '/task/auditlist', 2, 'fa-gavel', 1, 1, 0, 1, 1, 0, 1531212806);
INSERT INTO public.pp_uc_auth VALUES (43, 42, '批量审核通过', '/task/ajaxbatchaudit', 1, '', 0, 1, 0, 1, 1, 0, 1531466506);
INSERT INTO public.pp_uc_auth VALUES (44, 42, '批量审核不通过', '/task/ajaxbatchnopass', 2, '', 0, 1, 0, 1, 1, 0, 1531466513);
INSERT INTO public.pp_uc_auth VALUES (45, 31, '测试执行', '/task/ajaxrun', 4, '', 0, 1, 0, 1, 1, 0, 1531446085);
INSERT INTO public.pp_uc_auth VALUES (46, 31, '批量暂停', '/task/ajaxbatchpause', 9, '', 0, 1, 0, 1, 1, 0, 1531466394);
INSERT INTO public.pp_uc_auth VALUES (47, 31, '批量开启', '/task/ajaxbatchstart', 6, '', 0, 1, 0, 1, 1, 0, 1531466385);
INSERT INTO public.pp_uc_auth VALUES (48, 31, '开启', '/task/ajaxstart', 7, '', 0, 1, 0, 1, 1, 0, 1531466404);
INSERT INTO public.pp_uc_auth VALUES (49, 31, '暂停', '/task/ajaxpause', 8, '', 0, 1, 0, 1, 1, 0, 1531466411);
INSERT INTO public.pp_uc_auth VALUES (50, 42, '审核不通过', '/task/ajaxnopass', 6, '', 0, 1, 0, 1, 1, 0, 1531466546);
INSERT INTO public.pp_uc_auth VALUES (51, 42, '批量删除', '/task/ajaxbatchdel', 4, '', 0, 1, 0, 1, 1, 0, 1531466528);
INSERT INTO public.pp_uc_auth VALUES (52, 19, '复制', '/server/copy', 3, '', 0, 1, 1, 1, 1, 1531383393, 1531383393);
INSERT INTO public.pp_uc_auth VALUES (53, 19, '测试', '/server/ajaxtestserver', 5, '', 0, 1, 0, 1, 1, 0, 1531466851);
INSERT INTO public.pp_uc_auth VALUES (54, 1, '日志管理', '/tasklog/list', 10, 'fa-file-text-o', 0, 1, 1, 1, 1, 1531389296, 1531389296);
INSERT INTO public.pp_uc_auth VALUES (55, 54, '详情', '/tasklog/detail', 1, '', 0, 1, 1, 1, 1, 1531389347, 1531389347);
INSERT INTO public.pp_uc_auth VALUES (56, 54, '删除', '/tasklog/ajaxdel', 2, '', 0, 1, 0, 1, 1, 0, 1531466707);
INSERT INTO public.pp_uc_auth VALUES (57, 17, '提醒设置', '/remind/list', 4, 'fa-bell-o', 1, 1, 1, 1, 0, 1533607960, 1533607960);
INSERT INTO public.pp_uc_auth VALUES (58, 57, '新增', '/remind/add', 1, '', 0, 1, 1, 1, 1, 1533608257, 1533608257);
INSERT INTO public.pp_uc_auth VALUES (59, 57, '编辑', '/remind/edit', 2, '', 0, 1, 1, 1, 1, 1533608298, 1533608298);
INSERT INTO public.pp_uc_auth VALUES (60, 57, '删除', '/remind/ajaxdel', 3, '', 0, 1, 1, 1, 1, 1533608395, 1533608395);
INSERT INTO public.pp_uc_auth VALUES (61, 17, '通知模板', '/notifytpl/list', 5, 'fa-file-o', 1, 1, 0, 1, 1, 0, 1550237874);
INSERT INTO public.pp_uc_auth VALUES (62, 61, '新增', '/notifytpl/add', 1, '', 0, 1, 0, 1, 1, 0, 1550237919);
INSERT INTO public.pp_uc_auth VALUES (63, 61, '编辑', '/notifytpl/edit', 2, '', 0, 1, 1, 1, 1, 1550237957, 1550237957);
INSERT INTO public.pp_uc_auth VALUES (64, 61, '删除', '/notifytpl/ajaxdel', 3, '', 0, 1, 1, 1, 1, 1550237987, 1550237987);
INSERT INTO public.pp_uc_auth VALUES (65, 31, '通知类型', '/task/ajaxnotifytype', 10, '', 0, 1, 1, 1, 1, 1550258380, 1550258380);


--
-- TOC entry 2637 (class 0 OID 19718)
-- Dependencies: 213
-- Data for Name: pp_uc_role; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.pp_uc_role VALUES (1, '普通管理员', '可以运行和关闭任务', '10,1', '4,1', 0, 1, 1, 1531705962, 1531705962);
INSERT INTO public.pp_uc_role VALUES (2, '高级管理员', '可以批量操作任务，创建任务，创建任务分组，审核任务等', ',10,1,2', '4,6,1,2', 0, 1, 1, 1533607237, 1533607237);
INSERT INTO public.pp_uc_role VALUES (3, '资深管理员', '系统配置，任务管理等', '1,2,3', '2,1,3', 0, 1, 1, 1531644877, 1531644877);


--
-- TOC entry 2640 (class 0 OID 19792)
-- Dependencies: 216
-- Data for Name: pp_uc_role_auth; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.pp_uc_role_auth VALUES (1, 1);
INSERT INTO public.pp_uc_role_auth VALUES (1, 15);
INSERT INTO public.pp_uc_role_auth VALUES (1, 16);
INSERT INTO public.pp_uc_role_auth VALUES (1, 30);
INSERT INTO public.pp_uc_role_auth VALUES (1, 31);
INSERT INTO public.pp_uc_role_auth VALUES (1, 36);
INSERT INTO public.pp_uc_role_auth VALUES (1, 37);
INSERT INTO public.pp_uc_role_auth VALUES (1, 39);
INSERT INTO public.pp_uc_role_auth VALUES (1, 41);
INSERT INTO public.pp_uc_role_auth VALUES (1, 46);
INSERT INTO public.pp_uc_role_auth VALUES (1, 47);
INSERT INTO public.pp_uc_role_auth VALUES (1, 48);
INSERT INTO public.pp_uc_role_auth VALUES (1, 49);
INSERT INTO public.pp_uc_role_auth VALUES (1, 54);
INSERT INTO public.pp_uc_role_auth VALUES (1, 55);
INSERT INTO public.pp_uc_role_auth VALUES (1, 56);
INSERT INTO public.pp_uc_role_auth VALUES (2, 0);
INSERT INTO public.pp_uc_role_auth VALUES (2, 17);
INSERT INTO public.pp_uc_role_auth VALUES (2, 18);
INSERT INTO public.pp_uc_role_auth VALUES (2, 19);
INSERT INTO public.pp_uc_role_auth VALUES (2, 20);
INSERT INTO public.pp_uc_role_auth VALUES (2, 21);
INSERT INTO public.pp_uc_role_auth VALUES (2, 22);
INSERT INTO public.pp_uc_role_auth VALUES (2, 23);
INSERT INTO public.pp_uc_role_auth VALUES (2, 24);
INSERT INTO public.pp_uc_role_auth VALUES (2, 25);
INSERT INTO public.pp_uc_role_auth VALUES (2, 26);
INSERT INTO public.pp_uc_role_auth VALUES (2, 27);
INSERT INTO public.pp_uc_role_auth VALUES (2, 28);
INSERT INTO public.pp_uc_role_auth VALUES (2, 29);
INSERT INTO public.pp_uc_role_auth VALUES (2, 32);
INSERT INTO public.pp_uc_role_auth VALUES (2, 33);
INSERT INTO public.pp_uc_role_auth VALUES (2, 34);
INSERT INTO public.pp_uc_role_auth VALUES (2, 35);
INSERT INTO public.pp_uc_role_auth VALUES (2, 38);
INSERT INTO public.pp_uc_role_auth VALUES (2, 40);
INSERT INTO public.pp_uc_role_auth VALUES (2, 42);
INSERT INTO public.pp_uc_role_auth VALUES (2, 43);
INSERT INTO public.pp_uc_role_auth VALUES (2, 44);
INSERT INTO public.pp_uc_role_auth VALUES (2, 45);
INSERT INTO public.pp_uc_role_auth VALUES (2, 50);
INSERT INTO public.pp_uc_role_auth VALUES (2, 51);
INSERT INTO public.pp_uc_role_auth VALUES (2, 52);
INSERT INTO public.pp_uc_role_auth VALUES (2, 53);


--
-- TOC entry 2776 (class 0 OID 0)
-- Dependencies: 214
-- Name: pp_notify_tpl_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pp_notify_tpl_id_seq', 1, false);


--
-- TOC entry 2777 (class 0 OID 0)
-- Dependencies: 198
-- Name: pp_task_ban_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pp_task_ban_id_seq', 1, false);


--
-- TOC entry 2778 (class 0 OID 0)
-- Dependencies: 200
-- Name: pp_task_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pp_task_group_id_seq', 1, false);


--
-- TOC entry 2779 (class 0 OID 0)
-- Dependencies: 196
-- Name: pp_task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pp_task_id_seq', 1, false);


--
-- TOC entry 2780 (class 0 OID 0)
-- Dependencies: 202
-- Name: pp_task_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pp_task_log_id_seq', 1, false);


--
-- TOC entry 2781 (class 0 OID 0)
-- Dependencies: 206
-- Name: pp_task_server_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pp_task_server_group_id_seq', 1, false);


--
-- TOC entry 2782 (class 0 OID 0)
-- Dependencies: 204
-- Name: pp_task_server_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pp_task_server_id_seq', 1, false);


--
-- TOC entry 2783 (class 0 OID 0)
-- Dependencies: 208
-- Name: pp_uc_admin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pp_uc_admin_id_seq', 1, false);


--
-- TOC entry 2784 (class 0 OID 0)
-- Dependencies: 210
-- Name: pp_uc_auth_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pp_uc_auth_id_seq', 1, false);


--
-- TOC entry 2785 (class 0 OID 0)
-- Dependencies: 212
-- Name: pp_uc_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pp_uc_role_id_seq', 1, false);


--
-- TOC entry 2496 (class 2606 OID 19770)
-- Name: pp_notify_tpl pp_notify_tpl_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pp_notify_tpl
    ADD CONSTRAINT pp_notify_tpl_pkey PRIMARY KEY (id);


--
-- TOC entry 2480 (class 2606 OID 19600)
-- Name: pp_task_ban pp_task_ban_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pp_task_ban
    ADD CONSTRAINT pp_task_ban_pkey PRIMARY KEY (id);


--
-- TOC entry 2482 (class 2606 OID 19615)
-- Name: pp_task_group pp_task_group_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pp_task_group
    ADD CONSTRAINT pp_task_group_pkey PRIMARY KEY (id);


--
-- TOC entry 2484 (class 2606 OID 19629)
-- Name: pp_task_log pp_task_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pp_task_log
    ADD CONSTRAINT pp_task_log_pkey PRIMARY KEY (id);


--
-- TOC entry 2478 (class 2606 OID 19588)
-- Name: pp_task pp_task_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pp_task
    ADD CONSTRAINT pp_task_pkey PRIMARY KEY (id);


--
-- TOC entry 2488 (class 2606 OID 19669)
-- Name: pp_task_server_group pp_task_server_group_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pp_task_server_group
    ADD CONSTRAINT pp_task_server_group_pkey PRIMARY KEY (id);


--
-- TOC entry 2486 (class 2606 OID 19654)
-- Name: pp_task_server pp_task_server_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pp_task_server
    ADD CONSTRAINT pp_task_server_pkey PRIMARY KEY (id);


--
-- TOC entry 2490 (class 2606 OID 19691)
-- Name: pp_uc_admin pp_uc_admin_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pp_uc_admin
    ADD CONSTRAINT pp_uc_admin_pkey PRIMARY KEY (id);


--
-- TOC entry 2492 (class 2606 OID 19713)
-- Name: pp_uc_auth pp_uc_auth_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pp_uc_auth
    ADD CONSTRAINT pp_uc_auth_pkey PRIMARY KEY (id);


--
-- TOC entry 2498 (class 2606 OID 19798)
-- Name: pp_uc_role_auth pp_uc_role_auth_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pp_uc_role_auth
    ADD CONSTRAINT pp_uc_role_auth_pkey PRIMARY KEY (role_id, auth_id);


--
-- TOC entry 2494 (class 2606 OID 19735)
-- Name: pp_uc_role pp_uc_role_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pp_uc_role
    ADD CONSTRAINT pp_uc_role_pkey PRIMARY KEY (id);


-- Completed on 2019-10-01 16:39:59 CST

--
-- PostgreSQL database dump complete
--

