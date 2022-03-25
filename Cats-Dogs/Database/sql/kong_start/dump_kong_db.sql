--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;


--
-- Roles
--

ALTER ROLE kong WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:igGk4eQqjZifAjADb80JuA==$wyhYX38pMzdJUmqdcNsMytpmthmSUqJZdWD8sxRNcRE=:/beepJeUKmou/c7VTbU0Gimzk2i3qJ0NZJpcuOGeYo0=';


--
-- Databases
--

--
-- Database "template1" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.2
-- Dumped by pg_dump version 14.2

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

UPDATE pg_catalog.pg_database SET datistemplate = false WHERE datname = 'template1';
DROP DATABASE template1;
--
-- Name: template1; Type: DATABASE; Schema: -; Owner: kong
--

CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE template1 OWNER TO kong;

\connect template1

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
-- Name: DATABASE template1; Type: COMMENT; Schema: -; Owner: kong
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- Name: template1; Type: DATABASE PROPERTIES; Schema: -; Owner: kong
--

ALTER DATABASE template1 IS_TEMPLATE = true;


\connect template1

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
-- Name: DATABASE template1; Type: ACL; Schema: -; Owner: kong
--

REVOKE CONNECT,TEMPORARY ON DATABASE template1 FROM PUBLIC;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


--
-- PostgreSQL database dump complete
--

--
-- Database "kong" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.2
-- Dumped by pg_dump version 14.2

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
-- Name: kong; Type: DATABASE; Schema: -; Owner: kong
--


ALTER DATABASE kong OWNER TO kong;

\connect kong

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
-- Name: sync_tags(); Type: FUNCTION; Schema: public; Owner: kong
--

CREATE FUNCTION public.sync_tags() RETURNS trigger
    LANGUAGE plpgsql
    AS $$



        BEGIN



          IF (TG_OP = 'TRUNCATE') THEN



            DELETE FROM tags WHERE entity_name = TG_TABLE_NAME;



            RETURN NULL;



          ELSIF (TG_OP = 'DELETE') THEN



            DELETE FROM tags WHERE entity_id = OLD.id;



            RETURN OLD;



          ELSE







          -- Triggered by INSERT/UPDATE



          -- Do an upsert on the tags table



          -- So we don't need to migrate pre 1.1 entities



          INSERT INTO tags VALUES (NEW.id, TG_TABLE_NAME, NEW.tags)



          ON CONFLICT (entity_id) DO UPDATE



                  SET tags=EXCLUDED.tags;



          END IF;



          RETURN NEW;



        END;



      $$;


ALTER FUNCTION public.sync_tags() OWNER TO kong;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: acls; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.acls (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text),
    consumer_id uuid,
    "group" text,
    cache_key text,
    tags text[],
    ws_id uuid
);


ALTER TABLE public.acls OWNER TO kong;

--
-- Name: acme_storage; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.acme_storage (
    id uuid NOT NULL,
    key text,
    value text,
    created_at timestamp with time zone,
    ttl timestamp with time zone
);


ALTER TABLE public.acme_storage OWNER TO kong;

--
-- Name: admins; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.admins (
    id uuid NOT NULL,
    created_at timestamp without time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text),
    updated_at timestamp without time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text),
    consumer_id uuid,
    rbac_user_id uuid,
    rbac_token_enabled boolean NOT NULL,
    email text,
    status integer,
    username text,
    custom_id text,
    username_lower text
);


ALTER TABLE public.admins OWNER TO kong;

--
-- Name: application_instances; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.application_instances (
    id uuid NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    status integer,
    service_id uuid,
    application_id uuid,
    composite_id text,
    suspended boolean NOT NULL,
    ws_id uuid DEFAULT '3c4ca33f-a242-4d4e-9be7-74b1f2baa013'::uuid
);


ALTER TABLE public.application_instances OWNER TO kong;

--
-- Name: applications; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.applications (
    id uuid NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    name text,
    description text,
    redirect_uri text,
    meta text,
    developer_id uuid,
    consumer_id uuid,
    custom_id text,
    ws_id uuid DEFAULT '3c4ca33f-a242-4d4e-9be7-74b1f2baa013'::uuid
);


ALTER TABLE public.applications OWNER TO kong;

--
-- Name: audit_objects; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.audit_objects (
    id uuid NOT NULL,
    request_id character(32),
    entity_key uuid,
    dao_name text NOT NULL,
    operation character(6) NOT NULL,
    entity text,
    rbac_user_id uuid,
    signature text,
    ttl timestamp with time zone DEFAULT ((CURRENT_TIMESTAMP(0) AT TIME ZONE 'utc'::text) + '720:00:00'::interval)
);


ALTER TABLE public.audit_objects OWNER TO kong;

--
-- Name: audit_requests; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.audit_requests (
    request_id character(32) NOT NULL,
    request_timestamp timestamp without time zone DEFAULT (CURRENT_TIMESTAMP(3) AT TIME ZONE 'utc'::text),
    client_ip text NOT NULL,
    path text NOT NULL,
    method text NOT NULL,
    payload text,
    status integer NOT NULL,
    rbac_user_id uuid,
    workspace uuid,
    signature text,
    ttl timestamp with time zone DEFAULT ((CURRENT_TIMESTAMP(0) AT TIME ZONE 'utc'::text) + '720:00:00'::interval),
    removed_from_payload text
);


ALTER TABLE public.audit_requests OWNER TO kong;

--
-- Name: basicauth_credentials; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.basicauth_credentials (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text),
    consumer_id uuid,
    username text,
    password text,
    tags text[],
    ws_id uuid
);


ALTER TABLE public.basicauth_credentials OWNER TO kong;

--
-- Name: ca_certificates; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.ca_certificates (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text),
    cert text NOT NULL,
    tags text[],
    cert_digest text NOT NULL
);


ALTER TABLE public.ca_certificates OWNER TO kong;

--
-- Name: certificates; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.certificates (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text),
    cert text,
    key text,
    tags text[],
    ws_id uuid,
    cert_alt text,
    key_alt text
);


ALTER TABLE public.certificates OWNER TO kong;

--
-- Name: cluster_events; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.cluster_events (
    id uuid NOT NULL,
    node_id uuid NOT NULL,
    at timestamp with time zone NOT NULL,
    nbf timestamp with time zone,
    expire_at timestamp with time zone NOT NULL,
    channel text,
    data text
);


ALTER TABLE public.cluster_events OWNER TO kong;

--
-- Name: clustering_data_planes; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.clustering_data_planes (
    id uuid NOT NULL,
    hostname text NOT NULL,
    ip text NOT NULL,
    last_seen timestamp with time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text),
    config_hash text NOT NULL,
    ttl timestamp with time zone,
    version text,
    sync_status text DEFAULT 'unknown'::text NOT NULL
);


ALTER TABLE public.clustering_data_planes OWNER TO kong;

--
-- Name: consumer_group_consumers; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.consumer_group_consumers (
    created_at timestamp with time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text),
    consumer_group_id uuid NOT NULL,
    consumer_id uuid NOT NULL,
    cache_key text
);


ALTER TABLE public.consumer_group_consumers OWNER TO kong;

--
-- Name: consumer_group_plugins; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.consumer_group_plugins (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text),
    consumer_group_id uuid,
    name text NOT NULL,
    cache_key text,
    config jsonb NOT NULL,
    ws_id uuid DEFAULT '3c4ca33f-a242-4d4e-9be7-74b1f2baa013'::uuid
);


ALTER TABLE public.consumer_group_plugins OWNER TO kong;

--
-- Name: consumer_groups; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.consumer_groups (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text),
    name text,
    ws_id uuid DEFAULT '3c4ca33f-a242-4d4e-9be7-74b1f2baa013'::uuid
);


ALTER TABLE public.consumer_groups OWNER TO kong;

--
-- Name: consumer_reset_secrets; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.consumer_reset_secrets (
    id uuid NOT NULL,
    consumer_id uuid,
    secret text,
    status integer,
    client_addr text,
    created_at timestamp without time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'utc'::text),
    updated_at timestamp without time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'utc'::text)
);


ALTER TABLE public.consumer_reset_secrets OWNER TO kong;

--
-- Name: consumers; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.consumers (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text),
    username text,
    custom_id text,
    tags text[],
    ws_id uuid,
    username_lower text,
    type integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.consumers OWNER TO kong;

--
-- Name: credentials; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.credentials (
    id uuid NOT NULL,
    consumer_id uuid,
    consumer_type integer,
    plugin text NOT NULL,
    credential_data json,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, ('now'::text)::timestamp(0) with time zone)
);


ALTER TABLE public.credentials OWNER TO kong;

--
-- Name: degraphql_routes; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.degraphql_routes (
    id uuid NOT NULL,
    service_id uuid,
    methods text[],
    uri text,
    query text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE public.degraphql_routes OWNER TO kong;

--
-- Name: developers; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.developers (
    id uuid NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    email text,
    status integer,
    meta text,
    custom_id text,
    consumer_id uuid,
    rbac_user_id uuid,
    ws_id uuid DEFAULT '3c4ca33f-a242-4d4e-9be7-74b1f2baa013'::uuid
);


ALTER TABLE public.developers OWNER TO kong;

--
-- Name: document_objects; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.document_objects (
    id uuid NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    service_id uuid,
    path text,
    ws_id uuid DEFAULT '3c4ca33f-a242-4d4e-9be7-74b1f2baa013'::uuid
);


ALTER TABLE public.document_objects OWNER TO kong;

--
-- Name: event_hooks; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.event_hooks (
    id uuid,
    created_at timestamp without time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text),
    source text NOT NULL,
    event text,
    handler text NOT NULL,
    on_change boolean,
    snooze integer,
    config json NOT NULL
);


ALTER TABLE public.event_hooks OWNER TO kong;

--
-- Name: files; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.files (
    id uuid NOT NULL,
    path text NOT NULL,
    checksum text,
    contents text,
    created_at timestamp without time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'utc'::text),
    ws_id uuid DEFAULT '3c4ca33f-a242-4d4e-9be7-74b1f2baa013'::uuid
);


ALTER TABLE public.files OWNER TO kong;

--
-- Name: graphql_ratelimiting_advanced_cost_decoration; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.graphql_ratelimiting_advanced_cost_decoration (
    id uuid NOT NULL,
    service_id uuid,
    type_path text,
    add_arguments text[],
    add_constant double precision,
    mul_arguments text[],
    mul_constant double precision,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE public.graphql_ratelimiting_advanced_cost_decoration OWNER TO kong;

--
-- Name: group_rbac_roles; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.group_rbac_roles (
    created_at timestamp without time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text),
    group_id uuid NOT NULL,
    rbac_role_id uuid NOT NULL,
    workspace_id uuid
);


ALTER TABLE public.group_rbac_roles OWNER TO kong;

--
-- Name: groups; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.groups (
    id uuid NOT NULL,
    created_at timestamp without time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text),
    name text,
    comment text
);


ALTER TABLE public.groups OWNER TO kong;

--
-- Name: hmacauth_credentials; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.hmacauth_credentials (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text),
    consumer_id uuid,
    username text,
    secret text,
    tags text[],
    ws_id uuid
);


ALTER TABLE public.hmacauth_credentials OWNER TO kong;

--
-- Name: jwt_secrets; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.jwt_secrets (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text),
    consumer_id uuid,
    key text,
    secret text,
    algorithm text,
    rsa_public_key text,
    tags text[],
    ws_id uuid
);


ALTER TABLE public.jwt_secrets OWNER TO kong;

--
-- Name: jwt_signer_jwks; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.jwt_signer_jwks (
    id uuid NOT NULL,
    name text NOT NULL,
    keys jsonb[] NOT NULL,
    previous jsonb[],
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE public.jwt_signer_jwks OWNER TO kong;

--
-- Name: keyauth_credentials; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.keyauth_credentials (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text),
    consumer_id uuid,
    key text,
    tags text[],
    ttl timestamp with time zone,
    ws_id uuid
);


ALTER TABLE public.keyauth_credentials OWNER TO kong;

--
-- Name: keyauth_enc_credentials; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.keyauth_enc_credentials (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text),
    consumer_id uuid,
    key text,
    key_ident text,
    ws_id uuid
);


ALTER TABLE public.keyauth_enc_credentials OWNER TO kong;

--
-- Name: keyring_meta; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.keyring_meta (
    id text NOT NULL,
    state text NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.keyring_meta OWNER TO kong;

--
-- Name: legacy_files; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.legacy_files (
    id uuid NOT NULL,
    auth boolean NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    contents text,
    created_at timestamp without time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'utc'::text)
);


ALTER TABLE public.legacy_files OWNER TO kong;

--
-- Name: license_data; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.license_data (
    node_id uuid NOT NULL,
    req_cnt bigint,
    license_creation_date timestamp without time zone,
    year smallint NOT NULL,
    month smallint NOT NULL
);


ALTER TABLE public.license_data OWNER TO kong;

--
-- Name: licenses; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.licenses (
    id uuid NOT NULL,
    payload text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE public.licenses OWNER TO kong;

--
-- Name: locks; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.locks (
    key text NOT NULL,
    owner text,
    ttl timestamp with time zone
);


ALTER TABLE public.locks OWNER TO kong;

--
-- Name: login_attempts; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.login_attempts (
    consumer_id uuid NOT NULL,
    attempts json DEFAULT '{}'::json,
    ttl timestamp with time zone,
    created_at timestamp without time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text)
);


ALTER TABLE public.login_attempts OWNER TO kong;

--
-- Name: mtls_auth_credentials; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.mtls_auth_credentials (
    id uuid NOT NULL,
    created_at timestamp without time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text),
    consumer_id uuid NOT NULL,
    subject_name text NOT NULL,
    ca_certificate_id uuid,
    cache_key text,
    ws_id uuid,
    tags text[]
);


ALTER TABLE public.mtls_auth_credentials OWNER TO kong;

--
-- Name: oauth2_authorization_codes; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.oauth2_authorization_codes (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text),
    credential_id uuid,
    service_id uuid,
    code text,
    authenticated_userid text,
    scope text,
    ttl timestamp with time zone,
    challenge text,
    challenge_method text,
    ws_id uuid
);


ALTER TABLE public.oauth2_authorization_codes OWNER TO kong;

--
-- Name: oauth2_credentials; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.oauth2_credentials (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text),
    name text,
    consumer_id uuid,
    client_id text,
    client_secret text,
    redirect_uris text[],
    tags text[],
    client_type text,
    hash_secret boolean,
    ws_id uuid
);


ALTER TABLE public.oauth2_credentials OWNER TO kong;

--
-- Name: oauth2_tokens; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.oauth2_tokens (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text),
    credential_id uuid,
    service_id uuid,
    access_token text,
    refresh_token text,
    token_type text,
    expires_in integer,
    authenticated_userid text,
    scope text,
    ttl timestamp with time zone,
    ws_id uuid
);


ALTER TABLE public.oauth2_tokens OWNER TO kong;

--
-- Name: oic_issuers; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.oic_issuers (
    id uuid NOT NULL,
    issuer text,
    configuration text,
    keys text,
    secret text,
    created_at timestamp with time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text)
);


ALTER TABLE public.oic_issuers OWNER TO kong;

--
-- Name: oic_jwks; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.oic_jwks (
    id uuid NOT NULL,
    jwks jsonb
);


ALTER TABLE public.oic_jwks OWNER TO kong;

--
-- Name: parameters; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.parameters (
    key text NOT NULL,
    value text NOT NULL,
    created_at timestamp with time zone
);


ALTER TABLE public.parameters OWNER TO kong;

--
-- Name: plugins; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.plugins (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text),
    name text NOT NULL,
    consumer_id uuid,
    service_id uuid,
    route_id uuid,
    config jsonb NOT NULL,
    enabled boolean NOT NULL,
    cache_key text,
    protocols text[],
    tags text[],
    ws_id uuid
);


ALTER TABLE public.plugins OWNER TO kong;

--
-- Name: ratelimiting_metrics; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.ratelimiting_metrics (
    identifier text NOT NULL,
    period text NOT NULL,
    period_date timestamp with time zone NOT NULL,
    service_id uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    route_id uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    value integer,
    ttl timestamp with time zone
);


ALTER TABLE public.ratelimiting_metrics OWNER TO kong;

--
-- Name: rbac_role_endpoints; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.rbac_role_endpoints (
    role_id uuid NOT NULL,
    workspace text NOT NULL,
    endpoint text NOT NULL,
    actions smallint NOT NULL,
    comment text,
    created_at timestamp with time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text),
    negative boolean NOT NULL
);


ALTER TABLE public.rbac_role_endpoints OWNER TO kong;

--
-- Name: rbac_role_entities; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.rbac_role_entities (
    role_id uuid NOT NULL,
    entity_id text NOT NULL,
    entity_type text NOT NULL,
    actions smallint NOT NULL,
    negative boolean NOT NULL,
    comment text,
    created_at timestamp with time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text)
);


ALTER TABLE public.rbac_role_entities OWNER TO kong;

--
-- Name: rbac_roles; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.rbac_roles (
    id uuid NOT NULL,
    name text NOT NULL,
    comment text,
    created_at timestamp with time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text),
    is_default boolean DEFAULT false,
    ws_id uuid DEFAULT '3c4ca33f-a242-4d4e-9be7-74b1f2baa013'::uuid
);


ALTER TABLE public.rbac_roles OWNER TO kong;

--
-- Name: rbac_user_roles; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.rbac_user_roles (
    user_id uuid NOT NULL,
    role_id uuid NOT NULL
);


ALTER TABLE public.rbac_user_roles OWNER TO kong;

--
-- Name: rbac_users; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.rbac_users (
    id uuid NOT NULL,
    name text NOT NULL,
    user_token text NOT NULL,
    user_token_ident text,
    comment text,
    enabled boolean NOT NULL,
    created_at timestamp with time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text),
    ws_id uuid DEFAULT '3c4ca33f-a242-4d4e-9be7-74b1f2baa013'::uuid
);


ALTER TABLE public.rbac_users OWNER TO kong;

--
-- Name: response_ratelimiting_metrics; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.response_ratelimiting_metrics (
    identifier text NOT NULL,
    period text NOT NULL,
    period_date timestamp with time zone NOT NULL,
    service_id uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    route_id uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    value integer
);


ALTER TABLE public.response_ratelimiting_metrics OWNER TO kong;

--
-- Name: rl_counters; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.rl_counters (
    key text NOT NULL,
    namespace text NOT NULL,
    window_start integer NOT NULL,
    window_size integer NOT NULL,
    count integer
);


ALTER TABLE public.rl_counters OWNER TO kong;

--
-- Name: routes; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.routes (
    id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name text,
    service_id uuid,
    protocols text[],
    methods text[],
    hosts text[],
    paths text[],
    snis text[],
    sources jsonb[],
    destinations jsonb[],
    regex_priority bigint,
    strip_path boolean,
    preserve_host boolean,
    tags text[],
    https_redirect_status_code integer,
    headers jsonb,
    path_handling text DEFAULT 'v0'::text,
    ws_id uuid,
    request_buffering boolean,
    response_buffering boolean
);


ALTER TABLE public.routes OWNER TO kong;

--
-- Name: schema_meta; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.schema_meta (
    key text NOT NULL,
    subsystem text NOT NULL,
    last_executed text,
    executed text[],
    pending text[]
);


ALTER TABLE public.schema_meta OWNER TO kong;

--
-- Name: services; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.services (
    id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name text,
    retries bigint,
    protocol text,
    host text,
    port bigint,
    path text,
    connect_timeout bigint,
    write_timeout bigint,
    read_timeout bigint,
    tags text[],
    client_certificate_id uuid,
    tls_verify boolean,
    tls_verify_depth smallint,
    ca_certificates uuid[],
    ws_id uuid,
    enabled boolean DEFAULT true
);


ALTER TABLE public.services OWNER TO kong;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.sessions (
    id uuid NOT NULL,
    session_id text,
    expires integer,
    data text,
    created_at timestamp with time zone,
    ttl timestamp with time zone
);


ALTER TABLE public.sessions OWNER TO kong;

--
-- Name: snis; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.snis (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text),
    name text NOT NULL,
    certificate_id uuid,
    tags text[],
    ws_id uuid
);


ALTER TABLE public.snis OWNER TO kong;

--
-- Name: tags; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.tags (
    entity_id uuid NOT NULL,
    entity_name text,
    tags text[]
);


ALTER TABLE public.tags OWNER TO kong;

--
-- Name: targets; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.targets (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT (CURRENT_TIMESTAMP(3) AT TIME ZONE 'UTC'::text),
    upstream_id uuid,
    target text NOT NULL,
    weight integer NOT NULL,
    tags text[],
    ws_id uuid
);


ALTER TABLE public.targets OWNER TO kong;

--
-- Name: ttls; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.ttls (
    primary_key_value text NOT NULL,
    primary_uuid_value uuid,
    table_name text NOT NULL,
    primary_key_name text NOT NULL,
    expire_at timestamp without time zone NOT NULL
);


ALTER TABLE public.ttls OWNER TO kong;

--
-- Name: upstreams; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.upstreams (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT (CURRENT_TIMESTAMP(3) AT TIME ZONE 'UTC'::text),
    name text,
    hash_on text,
    hash_fallback text,
    hash_on_header text,
    hash_fallback_header text,
    hash_on_cookie text,
    hash_on_cookie_path text,
    slots integer NOT NULL,
    healthchecks jsonb,
    tags text[],
    algorithm text,
    host_header text,
    client_certificate_id uuid,
    ws_id uuid
);


ALTER TABLE public.upstreams OWNER TO kong;

--
-- Name: vaults; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.vaults (
    id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name text,
    protocol text,
    host text,
    port bigint,
    mount text,
    vault_token text
);


ALTER TABLE public.vaults OWNER TO kong;

--
-- Name: vaults_beta; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.vaults_beta (
    id uuid NOT NULL,
    ws_id uuid,
    prefix text,
    name text NOT NULL,
    description text,
    config jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text),
    updated_at timestamp with time zone,
    tags text[]
);


ALTER TABLE public.vaults_beta OWNER TO kong;

--
-- Name: vitals_code_classes_by_cluster; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.vitals_code_classes_by_cluster (
    code_class integer NOT NULL,
    at timestamp with time zone NOT NULL,
    duration integer NOT NULL,
    count integer
);


ALTER TABLE public.vitals_code_classes_by_cluster OWNER TO kong;

--
-- Name: vitals_code_classes_by_workspace; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.vitals_code_classes_by_workspace (
    workspace_id uuid NOT NULL,
    code_class integer NOT NULL,
    at timestamp with time zone NOT NULL,
    duration integer NOT NULL,
    count integer
);


ALTER TABLE public.vitals_code_classes_by_workspace OWNER TO kong;

--
-- Name: vitals_codes_by_consumer_route; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.vitals_codes_by_consumer_route (
    consumer_id uuid NOT NULL,
    service_id uuid,
    route_id uuid NOT NULL,
    code integer NOT NULL,
    at timestamp with time zone NOT NULL,
    duration integer NOT NULL,
    count integer
)
WITH (autovacuum_vacuum_scale_factor='0.01', autovacuum_analyze_scale_factor='0.01');


ALTER TABLE public.vitals_codes_by_consumer_route OWNER TO kong;

--
-- Name: vitals_codes_by_route; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.vitals_codes_by_route (
    service_id uuid,
    route_id uuid NOT NULL,
    code integer NOT NULL,
    at timestamp with time zone NOT NULL,
    duration integer NOT NULL,
    count integer
)
WITH (autovacuum_vacuum_scale_factor='0.01', autovacuum_analyze_scale_factor='0.01');


ALTER TABLE public.vitals_codes_by_route OWNER TO kong;

--
-- Name: vitals_locks; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.vitals_locks (
    key text NOT NULL,
    expiry timestamp with time zone
);


ALTER TABLE public.vitals_locks OWNER TO kong;

--
-- Name: vitals_node_meta; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.vitals_node_meta (
    node_id uuid NOT NULL,
    first_report timestamp without time zone,
    last_report timestamp without time zone,
    hostname text
);


ALTER TABLE public.vitals_node_meta OWNER TO kong;

--
-- Name: vitals_stats_days; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.vitals_stats_days (
    node_id uuid NOT NULL,
    at integer NOT NULL,
    l2_hit integer DEFAULT 0,
    l2_miss integer DEFAULT 0,
    plat_min integer,
    plat_max integer,
    ulat_min integer,
    ulat_max integer,
    requests integer DEFAULT 0,
    plat_count integer DEFAULT 0,
    plat_total integer DEFAULT 0,
    ulat_count integer DEFAULT 0,
    ulat_total integer DEFAULT 0
);


ALTER TABLE public.vitals_stats_days OWNER TO kong;

--
-- Name: vitals_stats_hours; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.vitals_stats_hours (
    at integer NOT NULL,
    l2_hit integer DEFAULT 0,
    l2_miss integer DEFAULT 0,
    plat_min integer,
    plat_max integer
);


ALTER TABLE public.vitals_stats_hours OWNER TO kong;

--
-- Name: vitals_stats_minutes; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.vitals_stats_minutes (
    node_id uuid NOT NULL,
    at integer NOT NULL,
    l2_hit integer DEFAULT 0,
    l2_miss integer DEFAULT 0,
    plat_min integer,
    plat_max integer,
    ulat_min integer,
    ulat_max integer,
    requests integer DEFAULT 0,
    plat_count integer DEFAULT 0,
    plat_total integer DEFAULT 0,
    ulat_count integer DEFAULT 0,
    ulat_total integer DEFAULT 0
);


ALTER TABLE public.vitals_stats_minutes OWNER TO kong;

--
-- Name: vitals_stats_seconds; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.vitals_stats_seconds (
    node_id uuid NOT NULL,
    at integer NOT NULL,
    l2_hit integer DEFAULT 0,
    l2_miss integer DEFAULT 0,
    plat_min integer,
    plat_max integer,
    ulat_min integer,
    ulat_max integer,
    requests integer DEFAULT 0,
    plat_count integer DEFAULT 0,
    plat_total integer DEFAULT 0,
    ulat_count integer DEFAULT 0,
    ulat_total integer DEFAULT 0
);


ALTER TABLE public.vitals_stats_seconds OWNER TO kong;

--
-- Name: workspace_entities; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.workspace_entities (
    workspace_id uuid NOT NULL,
    workspace_name text,
    entity_id text NOT NULL,
    entity_type text,
    unique_field_name text NOT NULL,
    unique_field_value text
);


ALTER TABLE public.workspace_entities OWNER TO kong;

--
-- Name: workspace_entity_counters; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.workspace_entity_counters (
    workspace_id uuid NOT NULL,
    entity_type text NOT NULL,
    count integer
);


ALTER TABLE public.workspace_entity_counters OWNER TO kong;

--
-- Name: workspaces; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.workspaces (
    id uuid NOT NULL,
    name text,
    comment text,
    created_at timestamp with time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text),
    meta jsonb,
    config jsonb
);


ALTER TABLE public.workspaces OWNER TO kong;

--
-- Name: ws_migrations_backup; Type: TABLE; Schema: public; Owner: kong
--

CREATE TABLE public.ws_migrations_backup (
    entity_type text,
    entity_id text,
    unique_field_name text,
    unique_field_value text,
    created_at timestamp with time zone DEFAULT (CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC'::text)
);


ALTER TABLE public.ws_migrations_backup OWNER TO kong;

--
-- Data for Name: acls; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.acls (id, created_at, consumer_id, "group", cache_key, tags, ws_id) FROM stdin;
cb351a89-426c-4e02-aa17-dbdd8807949a	2022-03-20 18:00:46+00	123e4106-913e-4670-b8f8-da3543db7a1b	dog	acls:123e4106-913e-4670-b8f8-da3543db7a1b:dog::::3c4ca33f-a242-4d4e-9be7-74b1f2baa013	\N	3c4ca33f-a242-4d4e-9be7-74b1f2baa013
98084ada-9b09-496f-8503-87c6cba19f28	2022-03-20 18:01:43+00	3707a594-dc40-44a5-ade3-109aeb5e0439	catdog	acls:3707a594-dc40-44a5-ade3-109aeb5e0439:catdog::::3c4ca33f-a242-4d4e-9be7-74b1f2baa013	\N	3c4ca33f-a242-4d4e-9be7-74b1f2baa013
4d11390e-573a-4c00-be8b-9270e506efb7	2022-03-20 18:30:56+00	e09deb31-2322-45c8-b553-0fbde3da9b62	cat	acls:e09deb31-2322-45c8-b553-0fbde3da9b62:cat::::3c4ca33f-a242-4d4e-9be7-74b1f2baa013	\N	3c4ca33f-a242-4d4e-9be7-74b1f2baa013
\.


--
-- Data for Name: acme_storage; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.acme_storage (id, key, value, created_at, ttl) FROM stdin;
\.


--
-- Data for Name: admins; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.admins (id, created_at, updated_at, consumer_id, rbac_user_id, rbac_token_enabled, email, status, username, custom_id, username_lower) FROM stdin;
\.


--
-- Data for Name: application_instances; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.application_instances (id, created_at, updated_at, status, service_id, application_id, composite_id, suspended, ws_id) FROM stdin;
\.


--
-- Data for Name: applications; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.applications (id, created_at, updated_at, name, description, redirect_uri, meta, developer_id, consumer_id, custom_id, ws_id) FROM stdin;
\.


--
-- Data for Name: audit_objects; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.audit_objects (id, request_id, entity_key, dao_name, operation, entity, rbac_user_id, signature, ttl) FROM stdin;
\.


--
-- Data for Name: audit_requests; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.audit_requests (request_id, request_timestamp, client_ip, path, method, payload, status, rbac_user_id, workspace, signature, ttl, removed_from_payload) FROM stdin;
\.


--
-- Data for Name: basicauth_credentials; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.basicauth_credentials (id, created_at, consumer_id, username, password, tags, ws_id) FROM stdin;
89006225-09be-4d04-851d-183d352df328	2022-03-20 18:00:54+00	123e4106-913e-4670-b8f8-da3543db7a1b	dog	1223adac10782227bbe51ee70ba78d6a52cf87d0	\N	3c4ca33f-a242-4d4e-9be7-74b1f2baa013
1dfc43e8-b5a7-4ac7-82bf-caaed402efc3	2022-03-20 18:01:52+00	3707a594-dc40-44a5-ade3-109aeb5e0439	catdog	fdbd7a45eb3c67e71902339b48213cdf380f7cf4	\N	3c4ca33f-a242-4d4e-9be7-74b1f2baa013
84c98a6c-0b19-4e90-8d39-af6f3bd290b8	2022-03-20 18:31:11+00	e09deb31-2322-45c8-b553-0fbde3da9b62	cat	c3393bcd74d81bdc62098def49964788b151191b	\N	3c4ca33f-a242-4d4e-9be7-74b1f2baa013
\.


--
-- Data for Name: ca_certificates; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.ca_certificates (id, created_at, cert, tags, cert_digest) FROM stdin;
\.


--
-- Data for Name: certificates; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.certificates (id, created_at, cert, key, tags, ws_id, cert_alt, key_alt) FROM stdin;
\.


--
-- Data for Name: cluster_events; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) FROM stdin;
25ad878b-6d5e-431a-8497-a3f0f5124976	d02e1099-ab29-43ca-a338-bfdcfa52d6a5	2022-03-25 18:28:56.566+00	\N	2022-03-25 19:28:56.566+00	invalidations	routes:8ebb282d-351b-4201-982f-3d5a134d001a:::::3c4ca33f-a242-4d4e-9be7-74b1f2baa013
f9b04ee0-8463-43df-a829-ee63ab29c05f	d02e1099-ab29-43ca-a338-bfdcfa52d6a5	2022-03-25 18:28:56.57+00	\N	2022-03-25 19:28:56.57+00	invalidations	router:version
5b531cec-07da-43b0-a7bf-425e868f3691	d02e1099-ab29-43ca-a338-bfdcfa52d6a5	2022-03-25 18:28:56.579+00	\N	2022-03-25 19:28:56.579+00	invalidations	mtls-auth:cert_enabled_snis
543bdd40-6313-4bfa-88b4-b29d11f34778	d02e1099-ab29-43ca-a338-bfdcfa52d6a5	2022-03-25 18:29:13.22+00	\N	2022-03-25 19:29:13.22+00	invalidations	routes:119ed191-30b9-49dc-a3f2-be17a8d69b92:::::3c4ca33f-a242-4d4e-9be7-74b1f2baa013
be67fd74-c91d-4d2c-896d-55ed207fc0e4	d02e1099-ab29-43ca-a338-bfdcfa52d6a5	2022-03-25 18:29:13.223+00	\N	2022-03-25 19:29:13.223+00	invalidations	router:version
c9cee29b-2540-4864-8f3c-6ce33541d1e6	d02e1099-ab29-43ca-a338-bfdcfa52d6a5	2022-03-25 18:29:13.226+00	\N	2022-03-25 19:29:13.226+00	invalidations	mtls-auth:cert_enabled_snis
\.


--
-- Data for Name: clustering_data_planes; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.clustering_data_planes (id, hostname, ip, last_seen, config_hash, ttl, version, sync_status) FROM stdin;
\.


--
-- Data for Name: consumer_group_consumers; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.consumer_group_consumers (created_at, consumer_group_id, consumer_id, cache_key) FROM stdin;
\.


--
-- Data for Name: consumer_group_plugins; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.consumer_group_plugins (id, created_at, consumer_group_id, name, cache_key, config, ws_id) FROM stdin;
\.


--
-- Data for Name: consumer_groups; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.consumer_groups (id, created_at, name, ws_id) FROM stdin;
\.


--
-- Data for Name: consumer_reset_secrets; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.consumer_reset_secrets (id, consumer_id, secret, status, client_addr, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: consumers; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.consumers (id, created_at, username, custom_id, tags, ws_id, username_lower, type) FROM stdin;
123e4106-913e-4670-b8f8-da3543db7a1b	2022-03-20 18:00:40+00	dog	dog	{}	3c4ca33f-a242-4d4e-9be7-74b1f2baa013	dog	0
3707a594-dc40-44a5-ade3-109aeb5e0439	2022-03-20 18:01:37+00	catdog	catdog	{}	3c4ca33f-a242-4d4e-9be7-74b1f2baa013	catdog	0
e09deb31-2322-45c8-b553-0fbde3da9b62	2022-03-20 18:30:51+00	cat	cat	{}	3c4ca33f-a242-4d4e-9be7-74b1f2baa013	cat	0
\.


--
-- Data for Name: credentials; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.credentials (id, consumer_id, consumer_type, plugin, credential_data, created_at) FROM stdin;
\.


--
-- Data for Name: degraphql_routes; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.degraphql_routes (id, service_id, methods, uri, query, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: developers; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.developers (id, created_at, updated_at, email, status, meta, custom_id, consumer_id, rbac_user_id, ws_id) FROM stdin;
\.


--
-- Data for Name: document_objects; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.document_objects (id, created_at, updated_at, service_id, path, ws_id) FROM stdin;
\.


--
-- Data for Name: event_hooks; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.event_hooks (id, created_at, source, event, handler, on_change, snooze, config) FROM stdin;
\.


--
-- Data for Name: files; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.files (id, path, checksum, contents, created_at, ws_id) FROM stdin;
\.


--
-- Data for Name: graphql_ratelimiting_advanced_cost_decoration; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.graphql_ratelimiting_advanced_cost_decoration (id, service_id, type_path, add_arguments, add_constant, mul_arguments, mul_constant, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: group_rbac_roles; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.group_rbac_roles (created_at, group_id, rbac_role_id, workspace_id) FROM stdin;
\.


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.groups (id, created_at, name, comment) FROM stdin;
\.


--
-- Data for Name: hmacauth_credentials; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.hmacauth_credentials (id, created_at, consumer_id, username, secret, tags, ws_id) FROM stdin;
\.


--
-- Data for Name: jwt_secrets; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.jwt_secrets (id, created_at, consumer_id, key, secret, algorithm, rsa_public_key, tags, ws_id) FROM stdin;
\.


--
-- Data for Name: jwt_signer_jwks; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.jwt_signer_jwks (id, name, keys, previous, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: keyauth_credentials; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.keyauth_credentials (id, created_at, consumer_id, key, tags, ttl, ws_id) FROM stdin;
\.


--
-- Data for Name: keyauth_enc_credentials; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.keyauth_enc_credentials (id, created_at, consumer_id, key, key_ident, ws_id) FROM stdin;
\.


--
-- Data for Name: keyring_meta; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.keyring_meta (id, state, created_at) FROM stdin;
\.


--
-- Data for Name: legacy_files; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.legacy_files (id, auth, name, type, contents, created_at) FROM stdin;
\.


--
-- Data for Name: license_data; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.license_data (node_id, req_cnt, license_creation_date, year, month) FROM stdin;
7b6a0209-629e-4218-9f47-10786d018330	0	2017-07-20 00:00:00	2022	3
c2d92adc-237f-48a8-95e6-af3ffe982e05	36	2017-07-20 00:00:00	2022	3
c24a725f-6960-4834-bce9-154bf68fd72d	0	2017-07-20 00:00:00	2022	3
68e9a8cd-75d3-4369-a9d7-4509eb463d9b	0	2017-07-20 00:00:00	2022	3
1a12a8ae-af2a-4b43-aa8e-e4c877e7bb62	0	2017-07-20 00:00:00	2022	3
7dcdd058-c365-492d-91e7-57943305361a	0	2017-07-20 00:00:00	2022	3
4ec5f46a-76ba-4657-abf1-c360a74903ad	0	2017-07-20 00:00:00	2022	3
b4f81e5c-23d0-4c38-8de9-543904331479	5	2017-07-20 00:00:00	2022	3
fa1c34cc-d582-4777-9d8a-14564f1e1145	1	2017-07-20 00:00:00	2022	3
30d2e218-dac5-4900-9cc7-f09dc8e1c05b	1	2017-07-20 00:00:00	2022	3
b031de2b-5e3a-481f-a982-0ce45ecf6a06	1	2017-07-20 00:00:00	2022	3
b110fabb-9295-4b82-90bb-03abff72718d	0	2017-07-20 00:00:00	2022	3
38631695-623f-44bf-906e-ccc61fafbcd7	3	2017-07-20 00:00:00	2022	3
754f270f-eb9d-4099-8422-870feb5bd116	0	2017-07-20 00:00:00	2022	3
d02e1099-ab29-43ca-a338-bfdcfa52d6a5	9	2017-07-20 00:00:00	2022	3
\.


--
-- Data for Name: licenses; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.licenses (id, payload, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: locks; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.locks (key, owner, ttl) FROM stdin;
\.


--
-- Data for Name: login_attempts; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.login_attempts (consumer_id, attempts, ttl, created_at) FROM stdin;
\.


--
-- Data for Name: mtls_auth_credentials; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.mtls_auth_credentials (id, created_at, consumer_id, subject_name, ca_certificate_id, cache_key, ws_id, tags) FROM stdin;
\.


--
-- Data for Name: oauth2_authorization_codes; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.oauth2_authorization_codes (id, created_at, credential_id, service_id, code, authenticated_userid, scope, ttl, challenge, challenge_method, ws_id) FROM stdin;
\.


--
-- Data for Name: oauth2_credentials; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.oauth2_credentials (id, created_at, name, consumer_id, client_id, client_secret, redirect_uris, tags, client_type, hash_secret, ws_id) FROM stdin;
\.


--
-- Data for Name: oauth2_tokens; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.oauth2_tokens (id, created_at, credential_id, service_id, access_token, refresh_token, token_type, expires_in, authenticated_userid, scope, ttl, ws_id) FROM stdin;
\.


--
-- Data for Name: oic_issuers; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.oic_issuers (id, issuer, configuration, keys, secret, created_at) FROM stdin;
\.


--
-- Data for Name: oic_jwks; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.oic_jwks (id, jwks) FROM stdin;
c3cfba2d-1617-453f-a416-52e6edb5f9a0	{"keys": [{"k": "H4PpCME_HTU9rX2nXgbfGBeUDYhc5JJckarY8Z6c0vo", "alg": "HS256", "kid": "5hPmVfHaiaoQxqt0AR4hA1SHB64aWDcggbKxvPJ4qGM", "kty": "oct", "use": "sig"}, {"k": "o_GGF_yJdJxWDYHJfgMLqfmZk2aSium8B_SAqNAziSiw5M52WNhU6sRN3dOa6hrm", "alg": "HS384", "kid": "i87e9UmD_DYhowoG2vdN9AXTpK4mgrq9wTY7mm_hdMw", "kty": "oct", "use": "sig"}, {"k": "XBe7BT6IKjSuZcCl9MM3GdtG_4aOkW1XZ44PUuA4vjWWMTuqkmFp74m5Q_WTpHvmWtZFvIm_WqSkioZz7ysn3A", "alg": "HS512", "kid": "vZ1zhqMj1Y6aX2cH7-zirjZ-YJ6qevDmgoEAa4aKdKw", "kty": "oct", "use": "sig"}, {"d": "bZl_uzc7-rxKh0_NK4IGANw_L8vJ_BEXzIbPivdlD8OiHyKz0qb9BzI6kA68VW11XtJfk_dKzR8U0p17QKu5Lbk2Gnh54jPelBLK1hhFJMP_AFljrxQEcZJBvHBG3hKcAQf6PHtXIcn-QwBGlf_TKsUX1_Rx9fHu2p_h25H2P1ngeuHKLcgqJ_mV31aJKUuh8wDFw5OwKN7-bsHDKcjpCLGv0OWwS-OCMljVFafC8L_E0puBKjBZLQkLwoe9zth8T-q7-wWa2wT2vO-lzipW0A6Z3q4DfJXBFnarkL-jkP4PADQyzDdqTDIk7vrsiVM48Wi9GAr0bVUSX1QtUNrAAQ", "e": "AQAB", "n": "onphCO9dOGGAWFuo4QycC1ESUoZPiqxDn3KWwa9MqliuBKkb066OZaLNJZQJ2Ga40i6Ao5J6JGCOO2djZ-eBBw4ys9TBnSBXI8WfUmLs_S5BcCia9vbwvqA3TmVhpYhxhVnA1ic2jlJGrUCidPcQ1N8fk9pBSa5-RBey4u3ZvfIHQkz4Sqsri9_1NgDwKubXfpIh05kss0iwKdjlPPvDyeQ3H8AJAyh77ukOokdz9Csrfh3s42zODiJYwM1RgFUg7fIAlrZcPY2RCp8f47lL9riHrXa3jXiyL9keyJUZn2GI5wt-0xH3TaCm99cTi7a8eewNjBXzXCn9gnZXDZsZsQ", "p": "1Yz4_ApOMaQfdFPVBDIL-5LNaFBkmQI13xBS1zd0Oe3Pekx7RYgxL7xhznfEEEQ2gd3te9hUfRbZ1FUxJnhX7IlfhaYv44i770HqVlmMPWUfMIjOgXYtB3flCszEZAagqCxTvzRNFBNpzH-DKCjYgxUbpa3LZcSiCdsGDbiFhPE", "q": "wsZ0qZuFJD8x1JcNBOWOK4SJj7NsPVvuLTWwYtMmJNvVaAhrZJg46DDjrNtQMfnghk-sBMqxREmji01iiTiYbSPzyh_cmsyKAEdrHME2A_I0Ykb8U90mEDIGaV3erMp_pnXzZkzlvd4Lk_RkESn7Bq-TQ3OCKlAKaKYyOnqP4ME", "dp": "HUmELCzNpIk5tx54LGcgtZPgj9nWshVXhgwbEGEOk5NFzSQIE_UlqcJQN5y9Su3P--eP1lhI3g7wOOqmHvyKMmp0q0Orda0e-SU1GjqVvSXNLT7V83NdoZST2PNUS9OM3QOXSLXHjGVNMTqbpjpT10Zh0EsRhhd9kZR0NBWGWkE", "dq": "H7YL3GlTnfkj9ca5-egd43vqoZjGsJ69AmNRWmWiOjIIZq2oPnKCIVuEVepG_jv-kB98lDMj9Ug_9jgdKNYsCujlkizpz9IpTa5TBBV449-VI8MG5eiFf_GFFbaQwHUfn0xo2mj-ppD2NZp-iETbd9UyFrNBp_3sE-mrF9ZIgoE", "qi": "opH3UL4hrvQJmxkg4Ntd0H_9QfLIlqwZuv3HC0CvtAkxGXhA_bdKJqKYtW2Lk9VVPojxq12SkM0dr8yeGq_cYF0WqOzSnYVE7Td_0oZfCVN-VRWidkRjZZZsolFCAMtgr-fbiynkC_UKqvk9jHJcG3Gdgxc4i9SPOCFXpwHUQWI", "alg": "RS256", "kid": "I0Kqm45HuCpewjEzc3GTFeCug4p9ZOv6wsIjZemVGbQ", "kty": "RSA", "use": "sig"}, {"d": "ibqeXWBzCAR7DchOcGR4M7BCG_ykFGFeYXuib5t0SByBuJSJxAlY5IJhRepeeSvxX20jkNiGGQEUBCJfH0XMHv9byEqTlfr8zCNnDfH9H4ScwnohrNjjDFu0lY1CUP3n_x0NwgzHaHblwsGxGKEDiForvF1OBKwjl52xZk3i6fWqGqFF441bPbucnGpp9nn0J7lqYZxCQELw-Yxoi1SWN7kj_4ZqRU_X-jFvcroKpFj8T0RyF0SgA7nCqK35RpvSYpccL82xlAwueADya4a8LD1IT1F5gfGGLU62RueeyCx8wvBA8lrv_XSmG2sdsNVRsRjPnViEc5OjF7o8YgfDoQ", "e": "AQAB", "n": "sErWySj_CY_3sQSyLhVpnR0-UKRlqcJI9nw6J7LcZ01K60G3J3_yeDQ6VyBi5VFOXsz7IAE8FNsANgfn9_wY1-7k7Hy3igkA81sy_aFY4Xv5VehkJybseLs9tcfZtkXGCUZrAOCu0qMtjWjVDCUzOIhMOy8dsb4IWT6ji_qL05cb4girSZU7clzAoIx7E1hoOatz1yDZEaBLTBsIk74Zka1v4fxT_pNcju_ire7vsoEDO1ejL7pC3fmExAtJwel8r82A4UMHcbeEEtC71Uj4SbdoTZAR1AUXbFDrHEeAPHZ26Syg1HCUlau5nf7vdoqxWjzpSQfNlfp-b7XMOZcmaw", "p": "wgXMAZOga8GX2cQAdNe-1g3y3r9KdZ9nhiPrXu4zt-GVxnJEMhO_s-LlNzUm0J9nfUESRnv41CoKHUdDcS1JDXFc3Tzbs9I1YJ5OyyVN2HDoJA4z4T3p3pWnum1BEHhv3bppNGe0HbXkPlNsah_LEy_qlmQ1N1wHYHGsVqyrnBE", "q": "6Jsldz4cxsuUUOeAau0oJmjU_H73nQ61Lnjz421EGGCzwpzSQgxLqkMG06FVXy0pOtFc63xeO6MaBDjfsh5QQtpLYtV6bzLm1DXyXGIJZUfa7bnnX3ktPv6GkqsvjB8HFCSkvBXMaEW_wQJ1J-frrem11-KtTv4GgODqdtgXxrs", "dp": "qXTUq9_a8aJA1QJZ_7LayyudnqxmBPs3OLIwhVX4N7a_0HXGWBJlkWAvIBu9DeLbSUtHAeaO-gbJlK7EGZoavrHvEI9xt8l1szAw0z5-kfZy2eLJrwUbOLtupeV8OT1nPrnr3shgSL6vXTwRaVLhU526_qUA0ZwAGVzOz1i5_XE", "dq": "X6M6ulZ9endF2iX1NQGhmnlL6S1DHf5oHF162a2Za_SGtKPKB4IKskywx97zvRhSdW6Tp_cQv7CGB-pif1fbZEFg8ZgYqRPiuKodpkJg3pW2vDvNmAG4ysfYCQH9oL05Kd0PJo5H5y-WcgNSrD-9NVp8e_EllO75OZBAlvCuhfU", "qi": "UbLTr8VeVnXX5FWV2H0Jh2R-i66wox4DyqLH9zuclzDNK9DnlRCJ7dOcuBnP_mXtX5HPK_InUI3w9ev42_kgXDLp_5u6OT8u0BIgNha54Em7T-Y3z298Fo4gayditjoIGa5HGLjw-P1xCP-uBjlh8oHSoRJnd2A8EVjK2cpJxsM", "alg": "RS384", "kid": "hhz-XS9alvFQmVsOjiaEmtXhzQMwI9odMonwu8oka5o", "kty": "RSA", "use": "sig"}, {"d": "PjBv5Kv5bFW5VUacypkzlhgslNYLzW3peZOiEeo4KfmWXlgenN4x86ZME0VqWgx0JZO5oRYJslu1QKy6T9hliAGR20SHqYlbDAJaVRBNGXSDOfjTHlNnkUuuDIQCzClNWLngH3BwaUbaUCFdvRW8y-RDw2XZawHnQKh6wBDGhrN248b3FTMj5iBvuw8GbR-qhZ_Pu5YXSYwVJPsyPPwwXfvyN_Vug-TQkPW3E-6snLJkwLA76u_NREIv5J7USCBKVfVqixy3Bi6ojt_H77nnRt18PTDwMocTjTdpIAKoetoQh7NUwfU6BfVos_oIECUobfgHu9WxyPOwn2yCRf0E2Q", "e": "AQAB", "n": "oKZvp3vAtuozaXJjbOX3zJ2u9kdobtpkInDFBo_VQgffyjjCb9AJi1Brdg45WZKjsONQeJml9HhwK-89QY5aS5cTcWxDECzt85UaXv_2FqjiVp5k247NSppMuzkBWphNrZytFpasFU3Vz4_FN2R2HhSz2jyiBjWA19tN7PGtX1e21HhNmFg4vrxB7bKtxoHMRgBfiDUDTWgYQ6H6qaIPLjg4PHfNayN-Rw6cPUz9JegaPZq9f0rKyNyH71Cet967RAz4o9I1Vusbe0dNxc64U9--U0tE5WrvfYLu1i-wy4NlpDP15E9plqtWxrEY82Y3aeuUT3AUKaWfO5-LzP1y_Q", "p": "zRwZ1dchfqjiriGFjKvDQIcOOHmHYhSA0Vl5CH7iAtjRbSTXrxnetmOrBpGfCWHSuuGBzQmuMu8LYw4DAu9ucn3_CDvuobWrAeUuK5Cfqmi51S7Q9wcqfar-NBvFPW7W2Oq76y6HPJ4HpeosIAwwzEK68_bdIBWoC-2aqBEvxts", "q": "yIJn1-rDzasrB9M2QafKZVkWYm_VN3nQGhTMtH22FcwBBFPUcZzQaSOkusR289-KRKtMk8E74drpiq_KhZLpd-opTMU3AT7o-EBifAot1VeyGWOiJfR1YSEimrn5WX6X4-j_UAUYPDI48fj3uQw1eSrwZGiqEJuia7KhuL4M-Qc", "dp": "bMmiylC4az2YPVN6SgowHWGEoV-T9ul5CZCzKVZi-a-WJJWN8EmAXqyuYWWLPKat5oEFH4Mq6cjv-THNVxk3M3KweeWPxCVe9jpgKqsihHfXWMLkAqHCX7T57xlrnBHV0mduFGcxQ21uEQoLLVRJ7YzXK96bmhDieLElfk7fUFE", "dq": "YpRis7BTliGKpW09Zqg1BQD41WrAPGciXkBNqIuJ40uKUHNapoT_nkGM8to21Y3Y8Av8OUSuyUsUuT_WZTemm3M_3OO1OGKSrcMR6IQkpphYEs1-YgS_VQKyfbnjkxF_Yeki5Ver46SZhLXwLUWIYMswp10iB8pM34BSrH6b6C8", "qi": "dEdilXnKCGhNXB29wJp3ZGkE8eXMDpv8tU6QdcwZX-njUBCPy3E7WgiS380REUgnaYG0P1-Zpnpq9SYzKZSfNG-U6cJz9l3m6rYhvAj3PuvtYqTKfzVDeNxrqwjAsW7xkeJz_R74tumcerRB89gHaXAzqgxUipbVYDZfJ4xQ0_0", "alg": "RS512", "kid": "OXgTsB6Ahbt_8NE0oPkiXbZreZpmwzHj3GnlTl_EOdM", "kty": "RSA", "use": "sig"}, {"d": "M8WLhK0mGF7YK4Dt9aLVp8M1WOUaLgZJpsk_3foFECYtNmnlTr-WTnWeBu6Kc-TXYem5Xz2xxKXDkgahuD1MQD-NGxRdsU8yjQ3rAemId_b_Uv837T4kZmk4rwYPp4HxbHQMIqyPNA_j78jB4TGvDbkcs-9XdSNAJsiwL_pRTv90AGUQK60d9FsDxixUxruVeB8f4qIyW1TwtMOR5iWKuG_nd3TNpkZB7uNwORdFNJRg3Pop8Y9_Yam_tL5TJTOMHuxlKDfg98vbiRNJp3BptnQiKhK-svZ4DqxaA4bIvebJvsCE-TSTBDUHllOxvEBnENrB300JnnniNIDSmPLxIQ", "e": "AQAB", "n": "3HcWwl1lqPxQ8pxzwAFAnfj3L4PCtIWZrzTGRDtEqy-yOniPVK7POremQEiuXd8ea3mmhjBjk-_Ex2FwVBYIJKiPXSSCG22M5UsWdAyMatldFbMy3_86mENR8ax5dKHVMLIx8qM-67l4l6YR7ktB1AWhItUsa9WjNxK2hXKhgaqtek0uuuoYlpaw_qZMzWFVI3dzk-dXPtkCfL7TNp3bhO3jicsHE7fsYnI0aa84f7AOVyUQveaMTPifuZXmkITwnoYfll1-lN_1tYBanTwCRQsYK4YiV0jXGH95cpiCnoufv3-jqZhByfqNwTXmlG6dNdVKMynGAyMgSFOZEI5Zdw", "p": "5JjJrTrbpjTi8wQezRg62krwcV2Tt-APxJZ9twqXdcAZ3VrJ5_4jqPCRjleuR774GqnLU2DrABe6ws3TC5BMdARA-w2OzN1g1RQEE1C6AqIjt77_4OFUOJq9ZVfs7DDy3GI3HOR2VnJWIot4-oqK5bkaFLFrTjqjtno2IMbtpck", "q": "9uTBm8UZoZCgrVujS5_8U1PxbxqDUBl_83MkJ9ITn7kB76Nn5vnVu2y7PJFL_SoWHE78AeaOenTmAwFJB1J7VYmpHN9au_gGAiy7rQV6j4Hv-54Lv6-OkW5ZGv4lYOvTHyjQkLjMJljwX7WzNOWw9ek46wSbSbbwtsgcFmp4pT8", "dp": "JesuMPz9aGGHb9Y0IcMuJ_2cSsHB-hNBqlNoQQ-RtieKYsxnh4MBeUmGa30h3KbR0uJtZsRB1v8YrK2ln1ptRCVcfghuso7aPB4Y2vdeE4e_swAMw8m8xbLtTb07AKbR8jqcd79x3b8TiKFoDO8kQRzmNZ6EdTKG64L0LZWx3_k", "dq": "G1D2BtkI2_JXhLa124Eo9sM73DIPw0X-_R2JK4q3tx1OFIh8z3Zm6mS-VpYw1SLZ7WnjwgYTT4Mti7mRrei3UqB3gIVJ0bBAYe83GI6Zn9UdizZSUHQJDxgpba4ezplo83KdmNWJaNjAR6af3ENpj9us-3u3_rDp8x8y1FwVWxs", "qi": "35XmH-QPaGE_JMqRQuRRcVPD4pUZwJyREGUtgqI9-bUAejc0usQrYsBujAUPe8jTOxrcBcMMdcZ2H0AKUf2k9CHHDPmEbs1WPXwdM8XLj1QEUyotfJ6gLroFlDL72VRUhWzAdvTQryrJ-1zbINmJM7ehogYD7m01Hl1SBJ-6xdg", "alg": "PS256", "kid": "prCMnLvIQ8Y8iT1usJG-0QrYVN3KDWe41GpQ5X9nSqE", "kty": "RSA", "use": "sig"}, {"d": "aVWDaRJ6GJDOGt-IJNaX5Ex0u3aEHGt-64Sxk6QP7CVhfrQlcCuZpYPLPJl4HF66Kr9_pIZ5kzsSV0mHyfnvUuHSrxBOQaFcfAIs7WBEZZZk98T56n-mdI7SL7Mkc22n0YQdDz16EtwXgqZmDXmiHHzNaCQ9__3AUoN_nAzB0tqAcZozqWS3VS-22KUDDEVwWSNqFW1xA4CjyWuTcOVf2ptZAHn-_lOIiSEmskkteji77stD3-sJSHswSXdNHDM6z2iB6rrxtWsJW_NPUzMY0V4VdJYI5-VrGIYHE6NnT6xs8FI9RD_jOKhSrQ5rzTv8Xt1BSuHzx1paekRvkSdXsQ", "e": "AQAB", "n": "ld2xBMBJ3crZzQBbFIGQHoY4zzSiO1HX24SJzunIqJSel6G4uEvFeTa9tJwEXgzrOnKOOCHpvubcTjS23V54SEFYCv-aBH_hkvxU5T8sCxBkeKfCmL4qEn3fb3Fkhgn3Vi5xSzP0SVP195L8ZHUhOsbZvbqqAiqEdiGoVPHJ2wy5lUaSvPSeN0CtwIKwkfvRLKU9pE3UAvW_UoCrTkHTr6wflQ90-8-8on9CMKxqXJJhDzyTpXjF3K04bLsyVfTcWvNFf6FTTlFyIP4QRpg1Edb3FNqO4nCEEvCwGYl0BaPAaZHuYiE3OvPjTmgVRagtmJcdGHaxuC2fnR5_2W5DCw", "p": "wvZwLswPaQBNYsegySEatQy-u9rsskn9WyCO8rZUdZeBEzoUsYOB4yOFybr8zty8H64y1lBc5EGd_FOvLZ6VUryVQDvNbLjKhAzE_QO-r-TpMp56f5SVtFnpkiHhZ1dho6uuB1Oln9wWF_6kmyT9WTEIgZ4Yt7Zg7PVX8nx2KWk", "q": "xMjqg1UlmvmWrNhfCQePXA5cp6bHyKga2NDIvXQo1GvnSseGcLRLp7UQF0nA-H-E25rxD2JJV2QGhY9o2XbXiY87bZ_VrT0bYtELYQrks7fGZflMcE6UuuSngZhL3xGpvdX_hrIyp_2HBujDkRfy14A9j1V4AqLkQevj3SrHZlM", "dp": "bTQmsD_C3fi6X_sbl61ATWs_JvBAprkE_dcl2tPASUG8ne1pi-jyhyztkop3ctN3WHN1rE_FSGFswdqKBA6Q65AQNbOJpD15yi9w45wGYnXhHWZhjTbICAZY626o1_69BTVzvEzhN8LKaVRMFU7JzfzGG_xXMggpEHF4eq22bgk", "dq": "ehdB0OwCIe3auzCffgWvv2i1udqzN159Eaov8cNhFbJA1VeHpONn0Qx4iEpdLJBJiMrP50COyman2TPJ1Kp0PcedEn3JX-t600tpqPLORGav9FLBRyiqBG6bMr-fyy21R6-_Ev36idm1beb6d0oJhATvrL9VbyVLQ08sl-rTvjs", "qi": "NE2fen7ybnTTDKNP2Rifr697bIEda59zZZGf0OJ0nPzNtFaCmrUKzZN6AN0vxIpjLjV6SLlGPllregwtHZeJjF6VR62wleBR-f-EkCDi6HVsYzJph-FjOQwO_67m-TiOO7jebGLd-deN6pFuqem_mPT4F3BkVfS1EF2d6mCtu9w", "alg": "PS384", "kid": "hZ8_LhM04LiItCw7fl-xP5rUCP6nvtJ2kUzr1iTIDGc", "kty": "RSA", "use": "sig"}, {"d": "yYIvnF1LcWAaMdGdEAzlWORcSqadzajbewWf36lJjOz6LSfC5qQdmoAKYk4Ef_nnMKvtdKm-hUCF9MyT7ehSdVoOUDMU5x97dGOx0k-WE8BAdlo3mYcftSWU2D2LduZyS6fvjhBCLtGKZUsh9al-Q7M6ep9JQ30JX_Qh_8yykAd-e3kSJ6BnktkmvD13AumcIV7AVqGBCc9H7gV-E_yZuLQhtOonaP3Cc3umxx4B7vzZYRR39CNnVJAp6WO1z24QkIQEcC61ULDgBgPdc5n4ijFgY8B4GJ3mMtdJ-4l-XQ1onafoM8CQFCaQPV4WM0OHPBbpXeQVHV1x2gVSQsW9AQ", "e": "AQAB", "n": "3kpPVO9f-UsNkIQGLX6hpfugirqm_C0p5Fc6OHzl_dbRpw1z-9vs__JeuQgn-q8zsZbD5DY9GQxzIEBLQ4YSsPLWuHM6e7A1LEjd48GJsCwS4oMJpHzdMVgTo8v_S5SFPppLbxywzfQhKEdjkW1-C2ZHtduP8UXjQR23BZZnfTGYeo9P608fw95EK52gqIXBR-vKiLlrtUDqOQcDW0ZEhXFcHlSBdH-coU4TTOjJWlzRgQk9MI7NFunwcJrjdbGHy2jovJMPfNztxel-YvPk6D7RGleGMtU5rjKOMgIlJoLiMO-SHCUW01oWNnrQR93H6_2sDeucc-WJB9q2jmM6mQ", "p": "_A2vbnOwCdSh5Zt2ldU9nUgU_nud0UVELL1-2G4uUCYo_6CecpJuMJc9Wp15BTUKvKrcrIHeg-JDQr8CeIpScfAQbpKO_212AlyOII6QdYmvRLAEgqd5pBQ0RsaFzBAz1gW7VHWgB4T2e99r6g0bK7jV4iDTC51p5pbmr4Gaw0k", "q": "4cVS4_1G23SY8lKZ8RTc2YSJUmJDg9gDw9h_YquM18Nfp3jyKvbmynHr3FxfRnkB5a_6uyHl2X-PxQQkFe6AFYJ0zPulSrnbsQL5gH5s8uOfzLfzxHswtLfdoVHxqpPMLvbHLf4t91p-pQ15w-6wiTCjaKi49grTpU4Cr4hvbNE", "dp": "gKTXeg8vtQTCkLb1ImoQpXrJxE0BcnLg5djdqccqehvP5xBqbl2QQdqfJOWkg-Tbkwm90YoDMNrFq4Zj03P9uktlh5njxDhw96mXnMRGtMbOHsebtbeWnQj22Xyvg0RtwHlycBwMzmmth_GzWWTRDlKrT1uje5UfHOK94KvMeok", "dq": "AjACRJlApYG0taxdN3vHRAhHuFehZdai-rPPUCpvW-vVsm62kfoAdHe0HFd8yNcFUK9q04NZkcjtoLAQlXHRJeQ0s4PArz-rxEROHJOdBKF1--rQXtf-udGKQTTlDY0PDmlvtp9e3KWw0nKV-nMGnN2ux6XS3Pdv44sk9YRx5_E", "qi": "WSUF-hFrzBz611WtOS3esD1EkgbBOJzdpLS_brbEqDuvwf1NqwM4jlrxTUltR4E4xAjd9_lkm59Bmsoqe0ge758krd_t-2GKHEkAe6HVuOsIlsD_ghQO_eVepktpSo1RsJfHOChP1JWqHu93ED2WEhkYWnF2BlfHR-j6lMDBnEQ", "alg": "PS512", "kid": "3RGH6XfHo8B7ZnOmw_knHBhFrVz1p7RRuie2q8moMR8", "kty": "RSA", "use": "sig"}, {"d": "Yj4KVVOBq5atsNl8gKaXbZRwUJVXxULe2amPH_bw1-M", "x": "M9t3Hcg4LhV3KDX9ptn0rxPNi0tZzuPd8LHMtWItH-c", "y": "B9vD4x49809uxOaWLQjb0QIszYv9Mplj4nJU-6UdG7U", "alg": "ES256", "crv": "P-256", "kid": "x9N-cpwG-ufXM1IofJpThHIkGuzVS70wp7qYmBGsXGc", "kty": "EC", "use": "sig"}, {"d": "oijQFgkLQGR_JA96xZfOOTDo-zBAd9BxdNdbzx6buZ8EgRIwAAtMH_Y4l-z8aGsy", "x": "2JKWeF3NOHoT5Evd_HMlDqwIUMSVrZnHxyo1M3AeoB146OJhLIcXKCPBuEyAfBtV", "y": "Vrjmcw4q3y_0C5inaUH62qYRLttxBp84DM99ytRMb5KeHJLf284TJN9T8vA0SKVt", "alg": "ES384", "crv": "P-384", "kid": "1T5EPmBAvnKB28tq6GkljXs1Ql_-EdhF4UZs2bL_Zf4", "kty": "EC", "use": "sig"}, {"d": "ADs4QISo81ak1JhQqN-YSlkRYTR3EyuaJeU47zgV1uckyr04H9fg4ZK7y-jjr3TVRD7E7RxCwVxHXVEGUdteRnkS", "x": "AR_boO9YDDOxXAaXCqe0hoFsV77mzQm2XqEy892U-TA5QgEL1RkQNuJyUEfim8fxmsdIrttCnAwAutg3izR8hXBh", "y": "AJNrHJqaG4uJiLIr1iPp3xsX8HjAKakRcv3sQdwyX0XgH8trDaFvuiADLQPDJke4AjPpcduxyW7_WmK6nPonuAR5", "alg": "ES512", "crv": "P-521", "kid": "OAFkBtH5XzK_LlxoO-2TVJc5DpH6WWbOVGEljByQsqA", "kty": "EC", "use": "sig"}, {"d": "TJ34P3FBMhm_y7DFOAsq516qP30AdJZVDlYdT5ZyA-4", "x": "HzbcYG97uQZDCaTkNVhMduCKIhDnY6_5RFIZgL5rPWQ", "alg": "EdDSA", "crv": "Ed25519", "kid": "Xboan2lSXiwfgK6Eh5wk-Jdp-49e5HAMgeUyujqewd0", "kty": "OKP", "use": "sig"}, {"d": "Qj0qHsA2bLAr7flmJB7V3WanIwIj2uz8uXQTWI-ndXvZFE0O3fMZcGitBSVeESG5Ewse2HfjyK7Q", "x": "iichk4WbmMlO2g3dffMAMkJVaX6nO3cg7ynI_9g2RUS0Ebib2Zar1fWW1XyCjNdavDU_sBjZ3uYA", "alg": "EdDSA", "crv": "Ed448", "kid": "jni1ac8gmoIwwWkeFJ5nuq7uSxquPjnNeMdUb2sVSHQ", "kty": "OKP", "use": "sig"}]}
\.


--
-- Data for Name: parameters; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.parameters (key, value, created_at) FROM stdin;
cluster_id	57039270-fb3d-4ee2-97bd-f1419f8d46aa	\N
\.


--
-- Data for Name: plugins; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.plugins (id, created_at, name, consumer_id, service_id, route_id, config, enabled, cache_key, protocols, tags, ws_id) FROM stdin;
0563cc6d-f85a-45dc-9676-5bc59efddc99	2022-03-20 17:58:21+00	basic-auth	\N	f2203024-43cb-4c0c-a1ad-c6c913ecbae7	\N	{"anonymous": null, "hide_credentials": false}	t	plugins:basic-auth::f2203024-43cb-4c0c-a1ad-c6c913ecbae7:::3c4ca33f-a242-4d4e-9be7-74b1f2baa013	{grpc,grpcs,http,https}	\N	3c4ca33f-a242-4d4e-9be7-74b1f2baa013
94b1c89c-7a20-40f3-be38-1b619a207b64	2022-03-20 17:59:43+00	acl	\N	f2203024-43cb-4c0c-a1ad-c6c913ecbae7	\N	{"deny": null, "allow": ["dog", "catdog"], "hide_groups_header": false}	t	plugins:acl::f2203024-43cb-4c0c-a1ad-c6c913ecbae7:::3c4ca33f-a242-4d4e-9be7-74b1f2baa013	{grpc,grpcs,http,https}	\N	3c4ca33f-a242-4d4e-9be7-74b1f2baa013
45490211-9c68-4a9d-b8af-d02540d967be	2022-03-20 18:27:07+00	basic-auth	\N	8345bcf4-f363-4068-ad1e-3469b46dfff2	\N	{"anonymous": null, "hide_credentials": false}	t	plugins:basic-auth::8345bcf4-f363-4068-ad1e-3469b46dfff2:::3c4ca33f-a242-4d4e-9be7-74b1f2baa013	{grpc,grpcs,http,https}	\N	3c4ca33f-a242-4d4e-9be7-74b1f2baa013
7393ae37-03ba-4cda-b693-6439eecce2f7	2022-03-20 18:32:04+00	acl	\N	8345bcf4-f363-4068-ad1e-3469b46dfff2	\N	{"deny": null, "allow": ["cat", "catdog"], "hide_groups_header": false}	t	plugins:acl::8345bcf4-f363-4068-ad1e-3469b46dfff2:::3c4ca33f-a242-4d4e-9be7-74b1f2baa013	{grpc,grpcs,http,https}	\N	3c4ca33f-a242-4d4e-9be7-74b1f2baa013
6580ac38-f3c4-4e72-8347-545ada27e9a5	2022-03-23 18:55:45+00	file-log	\N	\N	\N	{"path": "/tmp/logs/file.log", "reopen": false, "custom_fields_by_lua": null}	t	plugins:file-log:::::3c4ca33f-a242-4d4e-9be7-74b1f2baa013	{grpc,grpcs,http,https}	\N	3c4ca33f-a242-4d4e-9be7-74b1f2baa013
\.


--
-- Data for Name: ratelimiting_metrics; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.ratelimiting_metrics (identifier, period, period_date, service_id, route_id, value, ttl) FROM stdin;
\.


--
-- Data for Name: rbac_role_endpoints; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.rbac_role_endpoints (role_id, workspace, endpoint, actions, comment, created_at, negative) FROM stdin;
de251e9e-b573-456a-b55d-10934a81548d	*	*	1	\N	2022-03-20 17:52:02+00	f
e0f5acc5-33ae-4d16-b611-c53de2a52ac7	*	*	15	\N	2022-03-20 17:52:02+00	f
e0f5acc5-33ae-4d16-b611-c53de2a52ac7	*	/rbac/*	15	\N	2022-03-20 17:52:02+00	t
e0f5acc5-33ae-4d16-b611-c53de2a52ac7	*	/rbac/*/*	15	\N	2022-03-20 17:52:02+00	t
e0f5acc5-33ae-4d16-b611-c53de2a52ac7	*	/rbac/*/*/*	15	\N	2022-03-20 17:52:02+00	t
e0f5acc5-33ae-4d16-b611-c53de2a52ac7	*	/rbac/*/*/*/*	15	\N	2022-03-20 17:52:02+00	t
e0f5acc5-33ae-4d16-b611-c53de2a52ac7	*	/rbac/*/*/*/*/*	15	\N	2022-03-20 17:52:02+00	t
0c90757b-dac2-443f-a111-2b6c44501b10	*	*	15	\N	2022-03-20 17:52:02+00	f
\.


--
-- Data for Name: rbac_role_entities; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.rbac_role_entities (role_id, entity_id, entity_type, actions, negative, comment, created_at) FROM stdin;
\.


--
-- Data for Name: rbac_roles; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.rbac_roles (id, name, comment, created_at, is_default, ws_id) FROM stdin;
de251e9e-b573-456a-b55d-10934a81548d	read-only	Read access to all endpoints, across all workspaces	2022-03-20 17:52:02+00	f	3c4ca33f-a242-4d4e-9be7-74b1f2baa013
e0f5acc5-33ae-4d16-b611-c53de2a52ac7	admin	Full access to all endpoints, across all workspaces—except RBAC Admin API	2022-03-20 17:52:02+00	f	3c4ca33f-a242-4d4e-9be7-74b1f2baa013
0c90757b-dac2-443f-a111-2b6c44501b10	super-admin	Full access to all endpoints, across all workspaces	2022-03-20 17:52:02+00	f	3c4ca33f-a242-4d4e-9be7-74b1f2baa013
\.


--
-- Data for Name: rbac_user_roles; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.rbac_user_roles (user_id, role_id) FROM stdin;
\.


--
-- Data for Name: rbac_users; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.rbac_users (id, name, user_token, user_token_ident, comment, enabled, created_at, ws_id) FROM stdin;
\.


--
-- Data for Name: response_ratelimiting_metrics; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.response_ratelimiting_metrics (identifier, period, period_date, service_id, route_id, value) FROM stdin;
\.


--
-- Data for Name: rl_counters; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.rl_counters (key, namespace, window_start, window_size, count) FROM stdin;
\.


--
-- Data for Name: routes; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.routes (id, created_at, updated_at, name, service_id, protocols, methods, hosts, paths, snis, sources, destinations, regex_priority, strip_path, preserve_host, tags, https_redirect_status_code, headers, path_handling, ws_id, request_buffering, response_buffering) FROM stdin;
8ebb282d-351b-4201-982f-3d5a134d001a	2022-03-20 17:58:15+00	2022-03-25 18:28:56+00	v0-Dog	f2203024-43cb-4c0c-a1ad-c6c913ecbae7	{http}	\N	\N	{/dog/v0}	\N	\N	\N	0	t	f	\N	426	\N	v0	3c4ca33f-a242-4d4e-9be7-74b1f2baa013	t	t
119ed191-30b9-49dc-a3f2-be17a8d69b92	2022-03-20 17:55:58+00	2022-03-25 18:29:13+00	v0-Cats	8345bcf4-f363-4068-ad1e-3469b46dfff2	{http}	\N	\N	{/cat/v0}	\N	\N	\N	0	t	f	\N	426	\N	v0	3c4ca33f-a242-4d4e-9be7-74b1f2baa013	t	t
\.


--
-- Data for Name: schema_meta; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.schema_meta (key, subsystem, last_executed, executed, pending) FROM stdin;
schema_meta	hmac-auth	003_200_to_210	{000_base_hmac_auth,002_130_to_140,003_200_to_210}	{}
schema_meta	ip-restriction	001_200_to_210	{001_200_to_210}	{}
schema_meta	enterprise	013_2700_to_2800	{000_base,006_1301_to_1500,006_1301_to_1302,010_1500_to_2100,007_1500_to_1504,008_1504_to_1505,007_1500_to_2100,009_1506_to_1507,009_2100_to_2200,010_2200_to_2211,010_2200_to_2300,010_2200_to_2300_1,011_2300_to_2600,012_2600_to_2700,012_2600_to_2700_1,013_2700_to_2800}	{}
schema_meta	jwt	003_200_to_210	{000_base_jwt,002_130_to_140,003_200_to_210}	{}
schema_meta	jwt-signer	001_200_to_210	{000_base_jwt_signer,001_200_to_210}	\N
schema_meta	enterprise.acl	001_1500_to_2100	{001_1500_to_2100}	{}
schema_meta	key-auth	003_200_to_210	{000_base_key_auth,002_130_to_140,003_200_to_210}	{}
schema_meta	enterprise.basic-auth	001_1500_to_2100	{001_1500_to_2100}	{}
schema_meta	key-auth-enc	001_200_to_210	{000_base_key_auth_enc,001_200_to_210}	{}
schema_meta	core	016_270_to_280	{000_base,003_100_to_110,004_110_to_120,005_120_to_130,006_130_to_140,007_140_to_150,008_150_to_200,009_200_to_210,010_210_to_211,011_212_to_213,012_213_to_220,013_220_to_230,014_230_to_260,015_260_to_270,016_270_to_280}	{}
schema_meta	enterprise.hmac-auth	001_1500_to_2100	{001_1500_to_2100}	{}
schema_meta	mtls-auth	002_2200_to_2300	{000_base_mtls_auth,001_200_to_210,002_2200_to_2300}	{}
schema_meta	acl	004_212_to_213	{000_base_acl,002_130_to_140,003_200_to_210,004_212_to_213}	{}
schema_meta	acme	000_base_acme	{000_base_acme}	\N
schema_meta	basic-auth	003_200_to_210	{000_base_basic_auth,002_130_to_140,003_200_to_210}	{}
schema_meta	bot-detection	001_200_to_210	{001_200_to_210}	{}
schema_meta	canary	001_200_to_210	{001_200_to_210}	{}
schema_meta	degraphql	000_base	{000_base}	\N
schema_meta	graphql-rate-limiting-advanced	000_base_gql_rate_limiting	{000_base_gql_rate_limiting}	\N
schema_meta	enterprise.jwt	001_1500_to_2100	{001_1500_to_2100}	{}
schema_meta	oauth2	005_210_to_211	{000_base_oauth2,003_130_to_140,004_200_to_210,005_210_to_211}	{}
schema_meta	enterprise.key-auth	001_1500_to_2100	{001_1500_to_2100}	{}
schema_meta	openid-connect	002_200_to_210	{000_base_openid_connect,001_14_to_15,002_200_to_210}	{}
schema_meta	proxy-cache-advanced	001_035_to_050	{001_035_to_050}	{}
schema_meta	enterprise.key-auth-enc	001_1500_to_2100	{001_1500_to_2100}	{}
schema_meta	rate-limiting	004_200_to_210	{000_base_rate_limiting,003_10_to_112,004_200_to_210}	\N
schema_meta	response-ratelimiting	000_base_response_rate_limiting	{000_base_response_rate_limiting}	\N
schema_meta	session	001_add_ttl_index	{000_base_session,001_add_ttl_index}	\N
schema_meta	vault-auth	000_base_vault_auth	{000_base_vault_auth}	\N
schema_meta	enterprise.mtls-auth	002_2200_to_2300	{001_1500_to_2100,002_2200_to_2300}	{}
schema_meta	enterprise.oauth2	002_2200_to_2211	{001_1500_to_2100,002_2200_to_2211}	{}
schema_meta	enterprise.request-transformer-advanced	001_1500_to_2100	{001_1500_to_2100}	{}
schema_meta	enterprise.response-transformer-advanced	001_1500_to_2100	{001_1500_to_2100}	{}
\.


--
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.services (id, created_at, updated_at, name, retries, protocol, host, port, path, connect_timeout, write_timeout, read_timeout, tags, client_certificate_id, tls_verify, tls_verify_depth, ca_certificates, ws_id, enabled) FROM stdin;
8345bcf4-f363-4068-ad1e-3469b46dfff2	2022-03-20 17:55:25+00	2022-03-20 17:55:35+00	Cats	5	http	172.17.0.1	5050	/v0/cat	60000	60000	60000	{}	\N	\N	\N	\N	3c4ca33f-a242-4d4e-9be7-74b1f2baa013	t
f2203024-43cb-4c0c-a1ad-c6c913ecbae7	2022-03-20 17:57:26+00	2022-03-20 17:57:35+00	Dogs	5	http	172.17.0.1	5051	/v0/dog	60000	60000	60000	{}	\N	\N	\N	\N	3c4ca33f-a242-4d4e-9be7-74b1f2baa013	t
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.sessions (id, session_id, expires, data, created_at, ttl) FROM stdin;
\.


--
-- Data for Name: snis; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.snis (id, created_at, name, certificate_id, tags, ws_id) FROM stdin;
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.tags (entity_id, entity_name, tags) FROM stdin;
8345bcf4-f363-4068-ad1e-3469b46dfff2	services	{}
f2203024-43cb-4c0c-a1ad-c6c913ecbae7	services	{}
0563cc6d-f85a-45dc-9676-5bc59efddc99	plugins	\N
94b1c89c-7a20-40f3-be38-1b619a207b64	plugins	\N
123e4106-913e-4670-b8f8-da3543db7a1b	consumers	{}
cb351a89-426c-4e02-aa17-dbdd8807949a	acls	\N
89006225-09be-4d04-851d-183d352df328	basicauth_credentials	\N
3707a594-dc40-44a5-ade3-109aeb5e0439	consumers	{}
98084ada-9b09-496f-8503-87c6cba19f28	acls	\N
1dfc43e8-b5a7-4ac7-82bf-caaed402efc3	basicauth_credentials	\N
45490211-9c68-4a9d-b8af-d02540d967be	plugins	\N
e09deb31-2322-45c8-b553-0fbde3da9b62	consumers	{}
4d11390e-573a-4c00-be8b-9270e506efb7	acls	\N
84c98a6c-0b19-4e90-8d39-af6f3bd290b8	basicauth_credentials	\N
7393ae37-03ba-4cda-b693-6439eecce2f7	plugins	\N
6580ac38-f3c4-4e72-8347-545ada27e9a5	plugins	\N
8ebb282d-351b-4201-982f-3d5a134d001a	routes	\N
119ed191-30b9-49dc-a3f2-be17a8d69b92	routes	\N
\.


--
-- Data for Name: targets; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.targets (id, created_at, upstream_id, target, weight, tags, ws_id) FROM stdin;
\.


--
-- Data for Name: ttls; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.ttls (primary_key_value, primary_uuid_value, table_name, primary_key_name, expire_at) FROM stdin;
\.


--
-- Data for Name: upstreams; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.upstreams (id, created_at, name, hash_on, hash_fallback, hash_on_header, hash_fallback_header, hash_on_cookie, hash_on_cookie_path, slots, healthchecks, tags, algorithm, host_header, client_certificate_id, ws_id) FROM stdin;
\.


--
-- Data for Name: vaults; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.vaults (id, created_at, updated_at, name, protocol, host, port, mount, vault_token) FROM stdin;
\.


--
-- Data for Name: vaults_beta; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.vaults_beta (id, ws_id, prefix, name, description, config, created_at, updated_at, tags) FROM stdin;
\.


--
-- Data for Name: vitals_code_classes_by_cluster; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.vitals_code_classes_by_cluster (code_class, at, duration, count) FROM stdin;
\.


--
-- Data for Name: vitals_code_classes_by_workspace; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.vitals_code_classes_by_workspace (workspace_id, code_class, at, duration, count) FROM stdin;
\.


--
-- Data for Name: vitals_codes_by_consumer_route; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.vitals_codes_by_consumer_route (consumer_id, service_id, route_id, code, at, duration, count) FROM stdin;
\.


--
-- Data for Name: vitals_codes_by_route; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.vitals_codes_by_route (service_id, route_id, code, at, duration, count) FROM stdin;
\.


--
-- Data for Name: vitals_locks; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.vitals_locks (key, expiry) FROM stdin;
delete_status_codes	\N
\.


--
-- Data for Name: vitals_node_meta; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.vitals_node_meta (node_id, first_report, last_report, hostname) FROM stdin;
\.


--
-- Data for Name: vitals_stats_days; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.vitals_stats_days (node_id, at, l2_hit, l2_miss, plat_min, plat_max, ulat_min, ulat_max, requests, plat_count, plat_total, ulat_count, ulat_total) FROM stdin;
\.


--
-- Data for Name: vitals_stats_hours; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.vitals_stats_hours (at, l2_hit, l2_miss, plat_min, plat_max) FROM stdin;
\.


--
-- Data for Name: vitals_stats_minutes; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.vitals_stats_minutes (node_id, at, l2_hit, l2_miss, plat_min, plat_max, ulat_min, ulat_max, requests, plat_count, plat_total, ulat_count, ulat_total) FROM stdin;
\.


--
-- Data for Name: vitals_stats_seconds; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.vitals_stats_seconds (node_id, at, l2_hit, l2_miss, plat_min, plat_max, ulat_min, ulat_max, requests, plat_count, plat_total, ulat_count, ulat_total) FROM stdin;
\.


--
-- Data for Name: workspace_entities; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.workspace_entities (workspace_id, workspace_name, entity_id, entity_type, unique_field_name, unique_field_value) FROM stdin;
3c4ca33f-a242-4d4e-9be7-74b1f2baa013	default	de251e9e-b573-456a-b55d-10934a81548d	rbac_roles	id	de251e9e-b573-456a-b55d-10934a81548d
3c4ca33f-a242-4d4e-9be7-74b1f2baa013	default	de251e9e-b573-456a-b55d-10934a81548d	rbac_roles	name	default:read-only
3c4ca33f-a242-4d4e-9be7-74b1f2baa013	default	e0f5acc5-33ae-4d16-b611-c53de2a52ac7	rbac_roles	id	e0f5acc5-33ae-4d16-b611-c53de2a52ac7
3c4ca33f-a242-4d4e-9be7-74b1f2baa013	default	e0f5acc5-33ae-4d16-b611-c53de2a52ac7	rbac_roles	name	default:admin
3c4ca33f-a242-4d4e-9be7-74b1f2baa013	default	0c90757b-dac2-443f-a111-2b6c44501b10	rbac_roles	id	0c90757b-dac2-443f-a111-2b6c44501b10
3c4ca33f-a242-4d4e-9be7-74b1f2baa013	default	0c90757b-dac2-443f-a111-2b6c44501b10	rbac_roles	name	default:super-admin
\.


--
-- Data for Name: workspace_entity_counters; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.workspace_entity_counters (workspace_id, entity_type, count) FROM stdin;
3c4ca33f-a242-4d4e-9be7-74b1f2baa013	services	2
3c4ca33f-a242-4d4e-9be7-74b1f2baa013	routes	2
3c4ca33f-a242-4d4e-9be7-74b1f2baa013	consumers	3
3c4ca33f-a242-4d4e-9be7-74b1f2baa013	acls	3
3c4ca33f-a242-4d4e-9be7-74b1f2baa013	basicauth_credentials	3
3c4ca33f-a242-4d4e-9be7-74b1f2baa013	plugins	5
\.


--
-- Data for Name: workspaces; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.workspaces (id, name, comment, created_at, meta, config) FROM stdin;
3c4ca33f-a242-4d4e-9be7-74b1f2baa013	default	\N	2022-03-20 17:51:59+00	\N	\N
\.


--
-- Data for Name: ws_migrations_backup; Type: TABLE DATA; Schema: public; Owner: kong
--

COPY public.ws_migrations_backup (entity_type, entity_id, unique_field_name, unique_field_value, created_at) FROM stdin;
\.


--
-- Name: acls acls_cache_key_key; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.acls
    ADD CONSTRAINT acls_cache_key_key UNIQUE (cache_key);


--
-- Name: acls acls_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.acls
    ADD CONSTRAINT acls_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: acls acls_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.acls
    ADD CONSTRAINT acls_pkey PRIMARY KEY (id);


--
-- Name: acme_storage acme_storage_key_key; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.acme_storage
    ADD CONSTRAINT acme_storage_key_key UNIQUE (key);


--
-- Name: acme_storage acme_storage_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.acme_storage
    ADD CONSTRAINT acme_storage_pkey PRIMARY KEY (id);


--
-- Name: admins admins_custom_id_key; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_custom_id_key UNIQUE (custom_id);


--
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: admins admins_username_key; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_username_key UNIQUE (username);


--
-- Name: application_instances application_instances_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.application_instances
    ADD CONSTRAINT application_instances_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: application_instances application_instances_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.application_instances
    ADD CONSTRAINT application_instances_pkey PRIMARY KEY (id);


--
-- Name: application_instances application_instances_ws_id_composite_id_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.application_instances
    ADD CONSTRAINT application_instances_ws_id_composite_id_unique UNIQUE (ws_id, composite_id);


--
-- Name: applications applications_custom_id_key; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_custom_id_key UNIQUE (custom_id);


--
-- Name: applications applications_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: applications applications_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_pkey PRIMARY KEY (id);


--
-- Name: audit_objects audit_objects_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.audit_objects
    ADD CONSTRAINT audit_objects_pkey PRIMARY KEY (id);


--
-- Name: audit_requests audit_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.audit_requests
    ADD CONSTRAINT audit_requests_pkey PRIMARY KEY (request_id);


--
-- Name: basicauth_credentials basicauth_credentials_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.basicauth_credentials
    ADD CONSTRAINT basicauth_credentials_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: basicauth_credentials basicauth_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.basicauth_credentials
    ADD CONSTRAINT basicauth_credentials_pkey PRIMARY KEY (id);


--
-- Name: basicauth_credentials basicauth_credentials_ws_id_username_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.basicauth_credentials
    ADD CONSTRAINT basicauth_credentials_ws_id_username_unique UNIQUE (ws_id, username);


--
-- Name: ca_certificates ca_certificates_cert_digest_key; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.ca_certificates
    ADD CONSTRAINT ca_certificates_cert_digest_key UNIQUE (cert_digest);


--
-- Name: ca_certificates ca_certificates_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.ca_certificates
    ADD CONSTRAINT ca_certificates_pkey PRIMARY KEY (id);


--
-- Name: certificates certificates_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.certificates
    ADD CONSTRAINT certificates_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: certificates certificates_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.certificates
    ADD CONSTRAINT certificates_pkey PRIMARY KEY (id);


--
-- Name: cluster_events cluster_events_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.cluster_events
    ADD CONSTRAINT cluster_events_pkey PRIMARY KEY (id);


--
-- Name: clustering_data_planes clustering_data_planes_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.clustering_data_planes
    ADD CONSTRAINT clustering_data_planes_pkey PRIMARY KEY (id);


--
-- Name: consumer_group_consumers consumer_group_consumers_cache_key_key; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.consumer_group_consumers
    ADD CONSTRAINT consumer_group_consumers_cache_key_key UNIQUE (cache_key);


--
-- Name: consumer_group_consumers consumer_group_consumers_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.consumer_group_consumers
    ADD CONSTRAINT consumer_group_consumers_pkey PRIMARY KEY (consumer_group_id, consumer_id);


--
-- Name: consumer_group_plugins consumer_group_plugins_cache_key_key; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.consumer_group_plugins
    ADD CONSTRAINT consumer_group_plugins_cache_key_key UNIQUE (cache_key);


--
-- Name: consumer_group_plugins consumer_group_plugins_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.consumer_group_plugins
    ADD CONSTRAINT consumer_group_plugins_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: consumer_group_plugins consumer_group_plugins_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.consumer_group_plugins
    ADD CONSTRAINT consumer_group_plugins_pkey PRIMARY KEY (id);


--
-- Name: consumer_groups consumer_groups_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.consumer_groups
    ADD CONSTRAINT consumer_groups_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: consumer_groups consumer_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.consumer_groups
    ADD CONSTRAINT consumer_groups_pkey PRIMARY KEY (id);


--
-- Name: consumer_groups consumer_groups_ws_id_name_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.consumer_groups
    ADD CONSTRAINT consumer_groups_ws_id_name_unique UNIQUE (ws_id, name);


--
-- Name: consumer_reset_secrets consumer_reset_secrets_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.consumer_reset_secrets
    ADD CONSTRAINT consumer_reset_secrets_pkey PRIMARY KEY (id);


--
-- Name: consumers consumers_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.consumers
    ADD CONSTRAINT consumers_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: consumers consumers_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.consumers
    ADD CONSTRAINT consumers_pkey PRIMARY KEY (id);


--
-- Name: consumers consumers_ws_id_custom_id_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.consumers
    ADD CONSTRAINT consumers_ws_id_custom_id_unique UNIQUE (ws_id, custom_id);


--
-- Name: consumers consumers_ws_id_username_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.consumers
    ADD CONSTRAINT consumers_ws_id_username_unique UNIQUE (ws_id, username);


--
-- Name: credentials credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.credentials
    ADD CONSTRAINT credentials_pkey PRIMARY KEY (id);


--
-- Name: degraphql_routes degraphql_routes_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.degraphql_routes
    ADD CONSTRAINT degraphql_routes_pkey PRIMARY KEY (id);


--
-- Name: developers developers_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.developers
    ADD CONSTRAINT developers_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: developers developers_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.developers
    ADD CONSTRAINT developers_pkey PRIMARY KEY (id);


--
-- Name: developers developers_ws_id_custom_id_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.developers
    ADD CONSTRAINT developers_ws_id_custom_id_unique UNIQUE (ws_id, custom_id);


--
-- Name: developers developers_ws_id_email_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.developers
    ADD CONSTRAINT developers_ws_id_email_unique UNIQUE (ws_id, email);


--
-- Name: document_objects document_objects_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.document_objects
    ADD CONSTRAINT document_objects_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: document_objects document_objects_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.document_objects
    ADD CONSTRAINT document_objects_pkey PRIMARY KEY (id);


--
-- Name: document_objects document_objects_ws_id_path_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.document_objects
    ADD CONSTRAINT document_objects_ws_id_path_unique UNIQUE (ws_id, path);


--
-- Name: event_hooks event_hooks_id_key; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.event_hooks
    ADD CONSTRAINT event_hooks_id_key UNIQUE (id);


--
-- Name: files files_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: files files_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_pkey PRIMARY KEY (id);


--
-- Name: files files_ws_id_path_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_ws_id_path_unique UNIQUE (ws_id, path);


--
-- Name: graphql_ratelimiting_advanced_cost_decoration graphql_ratelimiting_advanced_cost_decoration_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.graphql_ratelimiting_advanced_cost_decoration
    ADD CONSTRAINT graphql_ratelimiting_advanced_cost_decoration_pkey PRIMARY KEY (id);


--
-- Name: group_rbac_roles group_rbac_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.group_rbac_roles
    ADD CONSTRAINT group_rbac_roles_pkey PRIMARY KEY (group_id, rbac_role_id);


--
-- Name: groups groups_name_key; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_name_key UNIQUE (name);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: hmacauth_credentials hmacauth_credentials_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.hmacauth_credentials
    ADD CONSTRAINT hmacauth_credentials_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: hmacauth_credentials hmacauth_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.hmacauth_credentials
    ADD CONSTRAINT hmacauth_credentials_pkey PRIMARY KEY (id);


--
-- Name: hmacauth_credentials hmacauth_credentials_ws_id_username_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.hmacauth_credentials
    ADD CONSTRAINT hmacauth_credentials_ws_id_username_unique UNIQUE (ws_id, username);


--
-- Name: jwt_secrets jwt_secrets_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.jwt_secrets
    ADD CONSTRAINT jwt_secrets_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: jwt_secrets jwt_secrets_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.jwt_secrets
    ADD CONSTRAINT jwt_secrets_pkey PRIMARY KEY (id);


--
-- Name: jwt_secrets jwt_secrets_ws_id_key_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.jwt_secrets
    ADD CONSTRAINT jwt_secrets_ws_id_key_unique UNIQUE (ws_id, key);


--
-- Name: jwt_signer_jwks jwt_signer_jwks_name_key; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.jwt_signer_jwks
    ADD CONSTRAINT jwt_signer_jwks_name_key UNIQUE (name);


--
-- Name: jwt_signer_jwks jwt_signer_jwks_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.jwt_signer_jwks
    ADD CONSTRAINT jwt_signer_jwks_pkey PRIMARY KEY (id);


--
-- Name: keyauth_credentials keyauth_credentials_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.keyauth_credentials
    ADD CONSTRAINT keyauth_credentials_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: keyauth_credentials keyauth_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.keyauth_credentials
    ADD CONSTRAINT keyauth_credentials_pkey PRIMARY KEY (id);


--
-- Name: keyauth_credentials keyauth_credentials_ws_id_key_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.keyauth_credentials
    ADD CONSTRAINT keyauth_credentials_ws_id_key_unique UNIQUE (ws_id, key);


--
-- Name: keyauth_enc_credentials keyauth_enc_credentials_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.keyauth_enc_credentials
    ADD CONSTRAINT keyauth_enc_credentials_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: keyauth_enc_credentials keyauth_enc_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.keyauth_enc_credentials
    ADD CONSTRAINT keyauth_enc_credentials_pkey PRIMARY KEY (id);


--
-- Name: keyauth_enc_credentials keyauth_enc_credentials_ws_id_key_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.keyauth_enc_credentials
    ADD CONSTRAINT keyauth_enc_credentials_ws_id_key_unique UNIQUE (ws_id, key);


--
-- Name: keyring_meta keyring_meta_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.keyring_meta
    ADD CONSTRAINT keyring_meta_pkey PRIMARY KEY (id);


--
-- Name: legacy_files legacy_files_name_key; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.legacy_files
    ADD CONSTRAINT legacy_files_name_key UNIQUE (name);


--
-- Name: legacy_files legacy_files_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.legacy_files
    ADD CONSTRAINT legacy_files_pkey PRIMARY KEY (id);


--
-- Name: licenses licenses_payload_key; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.licenses
    ADD CONSTRAINT licenses_payload_key UNIQUE (payload);


--
-- Name: licenses licenses_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.licenses
    ADD CONSTRAINT licenses_pkey PRIMARY KEY (id);


--
-- Name: locks locks_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.locks
    ADD CONSTRAINT locks_pkey PRIMARY KEY (key);


--
-- Name: login_attempts login_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.login_attempts
    ADD CONSTRAINT login_attempts_pkey PRIMARY KEY (consumer_id);


--
-- Name: mtls_auth_credentials mtls_auth_credentials_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.mtls_auth_credentials
    ADD CONSTRAINT mtls_auth_credentials_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: mtls_auth_credentials mtls_auth_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.mtls_auth_credentials
    ADD CONSTRAINT mtls_auth_credentials_pkey PRIMARY KEY (id);


--
-- Name: mtls_auth_credentials mtls_auth_credentials_ws_id_cache_key_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.mtls_auth_credentials
    ADD CONSTRAINT mtls_auth_credentials_ws_id_cache_key_unique UNIQUE (ws_id, cache_key);


--
-- Name: oauth2_authorization_codes oauth2_authorization_codes_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: oauth2_authorization_codes oauth2_authorization_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_pkey PRIMARY KEY (id);


--
-- Name: oauth2_authorization_codes oauth2_authorization_codes_ws_id_code_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_ws_id_code_unique UNIQUE (ws_id, code);


--
-- Name: oauth2_credentials oauth2_credentials_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.oauth2_credentials
    ADD CONSTRAINT oauth2_credentials_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: oauth2_credentials oauth2_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.oauth2_credentials
    ADD CONSTRAINT oauth2_credentials_pkey PRIMARY KEY (id);


--
-- Name: oauth2_credentials oauth2_credentials_ws_id_client_id_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.oauth2_credentials
    ADD CONSTRAINT oauth2_credentials_ws_id_client_id_unique UNIQUE (ws_id, client_id);


--
-- Name: oauth2_tokens oauth2_tokens_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: oauth2_tokens oauth2_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_pkey PRIMARY KEY (id);


--
-- Name: oauth2_tokens oauth2_tokens_ws_id_access_token_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_ws_id_access_token_unique UNIQUE (ws_id, access_token);


--
-- Name: oauth2_tokens oauth2_tokens_ws_id_refresh_token_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_ws_id_refresh_token_unique UNIQUE (ws_id, refresh_token);


--
-- Name: oic_issuers oic_issuers_issuer_key; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.oic_issuers
    ADD CONSTRAINT oic_issuers_issuer_key UNIQUE (issuer);


--
-- Name: oic_issuers oic_issuers_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.oic_issuers
    ADD CONSTRAINT oic_issuers_pkey PRIMARY KEY (id);


--
-- Name: oic_jwks oic_jwks_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.oic_jwks
    ADD CONSTRAINT oic_jwks_pkey PRIMARY KEY (id);


--
-- Name: parameters parameters_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (key);


--
-- Name: plugins plugins_cache_key_key; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_cache_key_key UNIQUE (cache_key);


--
-- Name: plugins plugins_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: plugins plugins_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_pkey PRIMARY KEY (id);


--
-- Name: ratelimiting_metrics ratelimiting_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.ratelimiting_metrics
    ADD CONSTRAINT ratelimiting_metrics_pkey PRIMARY KEY (identifier, period, period_date, service_id, route_id);


--
-- Name: rbac_role_endpoints rbac_role_endpoints_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.rbac_role_endpoints
    ADD CONSTRAINT rbac_role_endpoints_pkey PRIMARY KEY (role_id, workspace, endpoint);


--
-- Name: rbac_role_entities rbac_role_entities_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.rbac_role_entities
    ADD CONSTRAINT rbac_role_entities_pkey PRIMARY KEY (role_id, entity_id);


--
-- Name: rbac_roles rbac_roles_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.rbac_roles
    ADD CONSTRAINT rbac_roles_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: rbac_roles rbac_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.rbac_roles
    ADD CONSTRAINT rbac_roles_pkey PRIMARY KEY (id);


--
-- Name: rbac_roles rbac_roles_ws_id_name_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.rbac_roles
    ADD CONSTRAINT rbac_roles_ws_id_name_unique UNIQUE (ws_id, name);


--
-- Name: rbac_user_roles rbac_user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.rbac_user_roles
    ADD CONSTRAINT rbac_user_roles_pkey PRIMARY KEY (user_id, role_id);


--
-- Name: rbac_users rbac_users_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.rbac_users
    ADD CONSTRAINT rbac_users_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: rbac_users rbac_users_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.rbac_users
    ADD CONSTRAINT rbac_users_pkey PRIMARY KEY (id);


--
-- Name: rbac_users rbac_users_user_token_key; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.rbac_users
    ADD CONSTRAINT rbac_users_user_token_key UNIQUE (user_token);


--
-- Name: rbac_users rbac_users_ws_id_name_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.rbac_users
    ADD CONSTRAINT rbac_users_ws_id_name_unique UNIQUE (ws_id, name);


--
-- Name: response_ratelimiting_metrics response_ratelimiting_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.response_ratelimiting_metrics
    ADD CONSTRAINT response_ratelimiting_metrics_pkey PRIMARY KEY (identifier, period, period_date, service_id, route_id);


--
-- Name: rl_counters rl_counters_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.rl_counters
    ADD CONSTRAINT rl_counters_pkey PRIMARY KEY (key, namespace, window_start, window_size);


--
-- Name: routes routes_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: routes routes_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_pkey PRIMARY KEY (id);


--
-- Name: routes routes_ws_id_name_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_ws_id_name_unique UNIQUE (ws_id, name);


--
-- Name: schema_meta schema_meta_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.schema_meta
    ADD CONSTRAINT schema_meta_pkey PRIMARY KEY (key, subsystem);


--
-- Name: services services_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- Name: services services_ws_id_name_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_ws_id_name_unique UNIQUE (ws_id, name);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_session_id_key; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_session_id_key UNIQUE (session_id);


--
-- Name: snis snis_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.snis
    ADD CONSTRAINT snis_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: snis snis_name_key; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.snis
    ADD CONSTRAINT snis_name_key UNIQUE (name);


--
-- Name: snis snis_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.snis
    ADD CONSTRAINT snis_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (entity_id);


--
-- Name: targets targets_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.targets
    ADD CONSTRAINT targets_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: targets targets_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.targets
    ADD CONSTRAINT targets_pkey PRIMARY KEY (id);


--
-- Name: ttls ttls_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.ttls
    ADD CONSTRAINT ttls_pkey PRIMARY KEY (primary_key_value, table_name);


--
-- Name: upstreams upstreams_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.upstreams
    ADD CONSTRAINT upstreams_id_ws_id_unique UNIQUE (id, ws_id);


--
-- Name: upstreams upstreams_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.upstreams
    ADD CONSTRAINT upstreams_pkey PRIMARY KEY (id);


--
-- Name: upstreams upstreams_ws_id_name_unique; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.upstreams
    ADD CONSTRAINT upstreams_ws_id_name_unique UNIQUE (ws_id, name);


--
-- Name: vaults_beta vaults_beta_id_ws_id_key; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.vaults_beta
    ADD CONSTRAINT vaults_beta_id_ws_id_key UNIQUE (id, ws_id);


--
-- Name: vaults_beta vaults_beta_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.vaults_beta
    ADD CONSTRAINT vaults_beta_pkey PRIMARY KEY (id);


--
-- Name: vaults_beta vaults_beta_prefix_key; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.vaults_beta
    ADD CONSTRAINT vaults_beta_prefix_key UNIQUE (prefix);


--
-- Name: vaults_beta vaults_beta_prefix_ws_id_key; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.vaults_beta
    ADD CONSTRAINT vaults_beta_prefix_ws_id_key UNIQUE (prefix, ws_id);


--
-- Name: vaults vaults_name_key; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.vaults
    ADD CONSTRAINT vaults_name_key UNIQUE (name);


--
-- Name: vaults vaults_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.vaults
    ADD CONSTRAINT vaults_pkey PRIMARY KEY (id);


--
-- Name: vitals_code_classes_by_cluster vitals_code_classes_by_cluster_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.vitals_code_classes_by_cluster
    ADD CONSTRAINT vitals_code_classes_by_cluster_pkey PRIMARY KEY (code_class, duration, at);


--
-- Name: vitals_code_classes_by_workspace vitals_code_classes_by_workspace_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.vitals_code_classes_by_workspace
    ADD CONSTRAINT vitals_code_classes_by_workspace_pkey PRIMARY KEY (workspace_id, code_class, duration, at);


--
-- Name: vitals_codes_by_consumer_route vitals_codes_by_consumer_route_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.vitals_codes_by_consumer_route
    ADD CONSTRAINT vitals_codes_by_consumer_route_pkey PRIMARY KEY (consumer_id, route_id, code, duration, at);


--
-- Name: vitals_codes_by_route vitals_codes_by_route_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.vitals_codes_by_route
    ADD CONSTRAINT vitals_codes_by_route_pkey PRIMARY KEY (route_id, code, duration, at);


--
-- Name: vitals_locks vitals_locks_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.vitals_locks
    ADD CONSTRAINT vitals_locks_pkey PRIMARY KEY (key);


--
-- Name: vitals_node_meta vitals_node_meta_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.vitals_node_meta
    ADD CONSTRAINT vitals_node_meta_pkey PRIMARY KEY (node_id);


--
-- Name: vitals_stats_days vitals_stats_days_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.vitals_stats_days
    ADD CONSTRAINT vitals_stats_days_pkey PRIMARY KEY (node_id, at);


--
-- Name: vitals_stats_hours vitals_stats_hours_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.vitals_stats_hours
    ADD CONSTRAINT vitals_stats_hours_pkey PRIMARY KEY (at);


--
-- Name: vitals_stats_minutes vitals_stats_minutes_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.vitals_stats_minutes
    ADD CONSTRAINT vitals_stats_minutes_pkey PRIMARY KEY (node_id, at);


--
-- Name: vitals_stats_seconds vitals_stats_seconds_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.vitals_stats_seconds
    ADD CONSTRAINT vitals_stats_seconds_pkey PRIMARY KEY (node_id, at);


--
-- Name: workspace_entities workspace_entities_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.workspace_entities
    ADD CONSTRAINT workspace_entities_pkey PRIMARY KEY (workspace_id, entity_id, unique_field_name);


--
-- Name: workspace_entity_counters workspace_entity_counters_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.workspace_entity_counters
    ADD CONSTRAINT workspace_entity_counters_pkey PRIMARY KEY (workspace_id, entity_type);


--
-- Name: workspaces workspaces_name_key; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.workspaces
    ADD CONSTRAINT workspaces_name_key UNIQUE (name);


--
-- Name: workspaces workspaces_pkey; Type: CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.workspaces
    ADD CONSTRAINT workspaces_pkey PRIMARY KEY (id);


--
-- Name: acls_consumer_id_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX acls_consumer_id_idx ON public.acls USING btree (consumer_id);


--
-- Name: acls_group_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX acls_group_idx ON public.acls USING btree ("group");


--
-- Name: acls_tags_idex_tags_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX acls_tags_idex_tags_idx ON public.acls USING gin (tags);


--
-- Name: applications_developer_id_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX applications_developer_id_idx ON public.applications USING btree (developer_id);


--
-- Name: audit_objects_ttl_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX audit_objects_ttl_idx ON public.audit_objects USING btree (ttl);


--
-- Name: audit_requests_ttl_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX audit_requests_ttl_idx ON public.audit_requests USING btree (ttl);


--
-- Name: basicauth_consumer_id_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX basicauth_consumer_id_idx ON public.basicauth_credentials USING btree (consumer_id);


--
-- Name: basicauth_tags_idex_tags_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX basicauth_tags_idex_tags_idx ON public.basicauth_credentials USING gin (tags);


--
-- Name: certificates_tags_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX certificates_tags_idx ON public.certificates USING gin (tags);


--
-- Name: cluster_events_at_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX cluster_events_at_idx ON public.cluster_events USING btree (at);


--
-- Name: cluster_events_channel_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX cluster_events_channel_idx ON public.cluster_events USING btree (channel);


--
-- Name: cluster_events_expire_at_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX cluster_events_expire_at_idx ON public.cluster_events USING btree (expire_at);


--
-- Name: clustering_data_planes_ttl_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX clustering_data_planes_ttl_idx ON public.clustering_data_planes USING btree (ttl);


--
-- Name: consumer_group_consumers_consumer_id_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX consumer_group_consumers_consumer_id_idx ON public.consumer_group_consumers USING btree (consumer_id);


--
-- Name: consumer_group_consumers_group_id_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX consumer_group_consumers_group_id_idx ON public.consumer_group_consumers USING btree (consumer_group_id);


--
-- Name: consumer_group_plugins_group_id_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX consumer_group_plugins_group_id_idx ON public.consumer_group_plugins USING btree (consumer_group_id);


--
-- Name: consumer_group_plugins_plugin_name_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX consumer_group_plugins_plugin_name_idx ON public.consumer_group_plugins USING btree (name);


--
-- Name: consumer_groups_name_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX consumer_groups_name_idx ON public.consumer_groups USING btree (name);


--
-- Name: consumer_reset_secrets_consumer_id_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX consumer_reset_secrets_consumer_id_idx ON public.consumer_reset_secrets USING btree (consumer_id);


--
-- Name: consumers_tags_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX consumers_tags_idx ON public.consumers USING gin (tags);


--
-- Name: consumers_type_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX consumers_type_idx ON public.consumers USING btree (type);


--
-- Name: consumers_username_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX consumers_username_idx ON public.consumers USING btree (lower(username));


--
-- Name: credentials_consumer_id_plugin; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX credentials_consumer_id_plugin ON public.credentials USING btree (consumer_id, plugin);


--
-- Name: credentials_consumer_type; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX credentials_consumer_type ON public.credentials USING btree (consumer_id);


--
-- Name: degraphql_routes_fkey_service; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX degraphql_routes_fkey_service ON public.degraphql_routes USING btree (service_id);


--
-- Name: developers_rbac_user_id_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX developers_rbac_user_id_idx ON public.developers USING btree (rbac_user_id);


--
-- Name: files_path_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX files_path_idx ON public.files USING btree (path);


--
-- Name: graphql_ratelimiting_advanced_cost_decoration_fkey_service; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX graphql_ratelimiting_advanced_cost_decoration_fkey_service ON public.graphql_ratelimiting_advanced_cost_decoration USING btree (service_id);


--
-- Name: groups_name_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX groups_name_idx ON public.groups USING btree (name);


--
-- Name: hmacauth_credentials_consumer_id_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX hmacauth_credentials_consumer_id_idx ON public.hmacauth_credentials USING btree (consumer_id);


--
-- Name: hmacauth_tags_idex_tags_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX hmacauth_tags_idex_tags_idx ON public.hmacauth_credentials USING gin (tags);


--
-- Name: jwt_secrets_consumer_id_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX jwt_secrets_consumer_id_idx ON public.jwt_secrets USING btree (consumer_id);


--
-- Name: jwt_secrets_secret_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX jwt_secrets_secret_idx ON public.jwt_secrets USING btree (secret);


--
-- Name: jwtsecrets_tags_idex_tags_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX jwtsecrets_tags_idex_tags_idx ON public.jwt_secrets USING gin (tags);


--
-- Name: keyauth_credentials_consumer_id_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX keyauth_credentials_consumer_id_idx ON public.keyauth_credentials USING btree (consumer_id);


--
-- Name: keyauth_credentials_ttl_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX keyauth_credentials_ttl_idx ON public.keyauth_credentials USING btree (ttl);


--
-- Name: keyauth_enc_credentials_consum; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX keyauth_enc_credentials_consum ON public.keyauth_enc_credentials USING btree (consumer_id);


--
-- Name: keyauth_tags_idex_tags_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX keyauth_tags_idex_tags_idx ON public.keyauth_credentials USING gin (tags);


--
-- Name: legacy_files_name_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX legacy_files_name_idx ON public.legacy_files USING btree (name);


--
-- Name: license_data_key_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE UNIQUE INDEX license_data_key_idx ON public.license_data USING btree (node_id, year, month);


--
-- Name: locks_ttl_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX locks_ttl_idx ON public.locks USING btree (ttl);


--
-- Name: login_attempts_ttl_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX login_attempts_ttl_idx ON public.login_attempts USING btree (ttl);


--
-- Name: mtls_auth_common_name_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX mtls_auth_common_name_idx ON public.mtls_auth_credentials USING btree (subject_name);


--
-- Name: mtls_auth_consumer_id_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX mtls_auth_consumer_id_idx ON public.mtls_auth_credentials USING btree (consumer_id);


--
-- Name: mtls_auth_credentials_tags_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX mtls_auth_credentials_tags_idx ON public.mtls_auth_credentials USING gin (tags);


--
-- Name: oauth2_authorization_codes_authenticated_userid_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX oauth2_authorization_codes_authenticated_userid_idx ON public.oauth2_authorization_codes USING btree (authenticated_userid);


--
-- Name: oauth2_authorization_codes_ttl_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX oauth2_authorization_codes_ttl_idx ON public.oauth2_authorization_codes USING btree (ttl);


--
-- Name: oauth2_authorization_credential_id_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX oauth2_authorization_credential_id_idx ON public.oauth2_authorization_codes USING btree (credential_id);


--
-- Name: oauth2_authorization_service_id_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX oauth2_authorization_service_id_idx ON public.oauth2_authorization_codes USING btree (service_id);


--
-- Name: oauth2_credentials_consumer_id_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX oauth2_credentials_consumer_id_idx ON public.oauth2_credentials USING btree (consumer_id);


--
-- Name: oauth2_credentials_secret_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX oauth2_credentials_secret_idx ON public.oauth2_credentials USING btree (client_secret);


--
-- Name: oauth2_credentials_tags_idex_tags_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX oauth2_credentials_tags_idex_tags_idx ON public.oauth2_credentials USING gin (tags);


--
-- Name: oauth2_tokens_authenticated_userid_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX oauth2_tokens_authenticated_userid_idx ON public.oauth2_tokens USING btree (authenticated_userid);


--
-- Name: oauth2_tokens_credential_id_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX oauth2_tokens_credential_id_idx ON public.oauth2_tokens USING btree (credential_id);


--
-- Name: oauth2_tokens_service_id_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX oauth2_tokens_service_id_idx ON public.oauth2_tokens USING btree (service_id);


--
-- Name: oauth2_tokens_ttl_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX oauth2_tokens_ttl_idx ON public.oauth2_tokens USING btree (ttl);


--
-- Name: plugins_consumer_id_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX plugins_consumer_id_idx ON public.plugins USING btree (consumer_id);


--
-- Name: plugins_name_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX plugins_name_idx ON public.plugins USING btree (name);


--
-- Name: plugins_route_id_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX plugins_route_id_idx ON public.plugins USING btree (route_id);


--
-- Name: plugins_service_id_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX plugins_service_id_idx ON public.plugins USING btree (service_id);


--
-- Name: plugins_tags_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX plugins_tags_idx ON public.plugins USING gin (tags);


--
-- Name: ratelimiting_metrics_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX ratelimiting_metrics_idx ON public.ratelimiting_metrics USING btree (service_id, route_id, period_date, period);


--
-- Name: ratelimiting_metrics_ttl_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX ratelimiting_metrics_ttl_idx ON public.ratelimiting_metrics USING btree (ttl);


--
-- Name: rbac_role_default_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX rbac_role_default_idx ON public.rbac_roles USING btree (is_default);


--
-- Name: rbac_role_endpoints_role_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX rbac_role_endpoints_role_idx ON public.rbac_role_endpoints USING btree (role_id);


--
-- Name: rbac_role_entities_role_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX rbac_role_entities_role_idx ON public.rbac_role_entities USING btree (role_id);


--
-- Name: rbac_roles_name_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX rbac_roles_name_idx ON public.rbac_roles USING btree (name);


--
-- Name: rbac_token_ident_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX rbac_token_ident_idx ON public.rbac_users USING btree (user_token_ident);


--
-- Name: rbac_users_name_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX rbac_users_name_idx ON public.rbac_users USING btree (name);


--
-- Name: rbac_users_token_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX rbac_users_token_idx ON public.rbac_users USING btree (user_token);


--
-- Name: routes_service_id_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX routes_service_id_idx ON public.routes USING btree (service_id);


--
-- Name: routes_tags_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX routes_tags_idx ON public.routes USING gin (tags);


--
-- Name: services_fkey_client_certificate; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX services_fkey_client_certificate ON public.services USING btree (client_certificate_id);


--
-- Name: services_tags_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX services_tags_idx ON public.services USING gin (tags);


--
-- Name: session_sessions_expires_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX session_sessions_expires_idx ON public.sessions USING btree (expires);


--
-- Name: sessions_ttl_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX sessions_ttl_idx ON public.sessions USING btree (ttl);


--
-- Name: snis_certificate_id_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX snis_certificate_id_idx ON public.snis USING btree (certificate_id);


--
-- Name: snis_tags_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX snis_tags_idx ON public.snis USING gin (tags);


--
-- Name: sync_key_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX sync_key_idx ON public.rl_counters USING btree (namespace, window_start);


--
-- Name: tags_entity_name_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX tags_entity_name_idx ON public.tags USING btree (entity_name);


--
-- Name: tags_tags_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX tags_tags_idx ON public.tags USING gin (tags);


--
-- Name: targets_tags_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX targets_tags_idx ON public.targets USING gin (tags);


--
-- Name: targets_target_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX targets_target_idx ON public.targets USING btree (target);


--
-- Name: targets_upstream_id_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX targets_upstream_id_idx ON public.targets USING btree (upstream_id);


--
-- Name: ttls_primary_uuid_value_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX ttls_primary_uuid_value_idx ON public.ttls USING btree (primary_uuid_value);


--
-- Name: upstreams_fkey_client_certificate; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX upstreams_fkey_client_certificate ON public.upstreams USING btree (client_certificate_id);


--
-- Name: upstreams_tags_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX upstreams_tags_idx ON public.upstreams USING gin (tags);


--
-- Name: vaults_beta_tags_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX vaults_beta_tags_idx ON public.vaults_beta USING gin (tags);


--
-- Name: vcbr_svc_ts_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX vcbr_svc_ts_idx ON public.vitals_codes_by_route USING btree (service_id, duration, at);


--
-- Name: workspace_entities_composite_idx; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX workspace_entities_composite_idx ON public.workspace_entities USING btree (workspace_id, entity_type, unique_field_name);


--
-- Name: workspace_entities_idx_entity_id; Type: INDEX; Schema: public; Owner: kong
--

CREATE INDEX workspace_entities_idx_entity_id ON public.workspace_entities USING btree (entity_id);


--
-- Name: acls acls_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: kong
--

CREATE TRIGGER acls_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.acls FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- Name: basicauth_credentials basicauth_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: kong
--

CREATE TRIGGER basicauth_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.basicauth_credentials FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- Name: ca_certificates ca_certificates_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: kong
--

CREATE TRIGGER ca_certificates_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.ca_certificates FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- Name: certificates certificates_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: kong
--

CREATE TRIGGER certificates_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.certificates FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- Name: consumers consumers_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: kong
--

CREATE TRIGGER consumers_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.consumers FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- Name: hmacauth_credentials hmacauth_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: kong
--

CREATE TRIGGER hmacauth_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.hmacauth_credentials FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- Name: jwt_secrets jwtsecrets_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: kong
--

CREATE TRIGGER jwtsecrets_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.jwt_secrets FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- Name: keyauth_credentials keyauth_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: kong
--

CREATE TRIGGER keyauth_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.keyauth_credentials FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- Name: mtls_auth_credentials mtls_auth_credentials_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: kong
--

CREATE TRIGGER mtls_auth_credentials_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.mtls_auth_credentials FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- Name: oauth2_credentials oauth2_credentials_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: kong
--

CREATE TRIGGER oauth2_credentials_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.oauth2_credentials FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- Name: plugins plugins_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: kong
--

CREATE TRIGGER plugins_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.plugins FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- Name: routes routes_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: kong
--

CREATE TRIGGER routes_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.routes FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- Name: services services_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: kong
--

CREATE TRIGGER services_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.services FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- Name: snis snis_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: kong
--

CREATE TRIGGER snis_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.snis FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- Name: targets targets_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: kong
--

CREATE TRIGGER targets_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.targets FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- Name: upstreams upstreams_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: kong
--

CREATE TRIGGER upstreams_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.upstreams FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- Name: vaults_beta vaults_beta_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: kong
--

CREATE TRIGGER vaults_beta_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.vaults_beta FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- Name: acls acls_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.acls
    ADD CONSTRAINT acls_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;


--
-- Name: acls acls_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.acls
    ADD CONSTRAINT acls_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: admins admins_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_consumer_id_fkey FOREIGN KEY (consumer_id) REFERENCES public.consumers(id);


--
-- Name: admins admins_rbac_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_rbac_user_id_fkey FOREIGN KEY (rbac_user_id) REFERENCES public.rbac_users(id);


--
-- Name: application_instances application_instances_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.application_instances
    ADD CONSTRAINT application_instances_application_id_fkey FOREIGN KEY (application_id, ws_id) REFERENCES public.applications(id, ws_id);


--
-- Name: application_instances application_instances_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.application_instances
    ADD CONSTRAINT application_instances_service_id_fkey FOREIGN KEY (service_id, ws_id) REFERENCES public.services(id, ws_id);


--
-- Name: application_instances application_instances_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.application_instances
    ADD CONSTRAINT application_instances_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: applications applications_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id);


--
-- Name: applications applications_developer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_developer_id_fkey FOREIGN KEY (developer_id, ws_id) REFERENCES public.developers(id, ws_id);


--
-- Name: applications applications_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: basicauth_credentials basicauth_credentials_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.basicauth_credentials
    ADD CONSTRAINT basicauth_credentials_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;


--
-- Name: basicauth_credentials basicauth_credentials_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.basicauth_credentials
    ADD CONSTRAINT basicauth_credentials_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: certificates certificates_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.certificates
    ADD CONSTRAINT certificates_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: consumer_group_consumers consumer_group_consumers_consumer_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.consumer_group_consumers
    ADD CONSTRAINT consumer_group_consumers_consumer_group_id_fkey FOREIGN KEY (consumer_group_id) REFERENCES public.consumer_groups(id) ON DELETE CASCADE;


--
-- Name: consumer_group_consumers consumer_group_consumers_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.consumer_group_consumers
    ADD CONSTRAINT consumer_group_consumers_consumer_id_fkey FOREIGN KEY (consumer_id) REFERENCES public.consumers(id) ON DELETE CASCADE;


--
-- Name: consumer_group_plugins consumer_group_plugins_consumer_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.consumer_group_plugins
    ADD CONSTRAINT consumer_group_plugins_consumer_group_id_fkey FOREIGN KEY (consumer_group_id, ws_id) REFERENCES public.consumer_groups(id, ws_id) ON DELETE CASCADE;


--
-- Name: consumer_group_plugins consumer_group_plugins_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.consumer_group_plugins
    ADD CONSTRAINT consumer_group_plugins_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: consumer_groups consumer_groups_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.consumer_groups
    ADD CONSTRAINT consumer_groups_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: consumer_reset_secrets consumer_reset_secrets_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.consumer_reset_secrets
    ADD CONSTRAINT consumer_reset_secrets_consumer_id_fkey FOREIGN KEY (consumer_id) REFERENCES public.consumers(id) ON DELETE CASCADE;


--
-- Name: consumers consumers_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.consumers
    ADD CONSTRAINT consumers_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: credentials credentials_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.credentials
    ADD CONSTRAINT credentials_consumer_id_fkey FOREIGN KEY (consumer_id) REFERENCES public.consumers(id) ON DELETE CASCADE;


--
-- Name: degraphql_routes degraphql_routes_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.degraphql_routes
    ADD CONSTRAINT degraphql_routes_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;


--
-- Name: developers developers_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.developers
    ADD CONSTRAINT developers_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id);


--
-- Name: developers developers_rbac_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.developers
    ADD CONSTRAINT developers_rbac_user_id_fkey FOREIGN KEY (rbac_user_id, ws_id) REFERENCES public.rbac_users(id, ws_id);


--
-- Name: developers developers_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.developers
    ADD CONSTRAINT developers_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: document_objects document_objects_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.document_objects
    ADD CONSTRAINT document_objects_service_id_fkey FOREIGN KEY (service_id, ws_id) REFERENCES public.services(id, ws_id);


--
-- Name: document_objects document_objects_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.document_objects
    ADD CONSTRAINT document_objects_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: files files_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: graphql_ratelimiting_advanced_cost_decoration graphql_ratelimiting_advanced_cost_decoration_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.graphql_ratelimiting_advanced_cost_decoration
    ADD CONSTRAINT graphql_ratelimiting_advanced_cost_decoration_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;


--
-- Name: group_rbac_roles group_rbac_roles_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.group_rbac_roles
    ADD CONSTRAINT group_rbac_roles_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id) ON DELETE CASCADE;


--
-- Name: group_rbac_roles group_rbac_roles_rbac_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.group_rbac_roles
    ADD CONSTRAINT group_rbac_roles_rbac_role_id_fkey FOREIGN KEY (rbac_role_id) REFERENCES public.rbac_roles(id) ON DELETE CASCADE;


--
-- Name: group_rbac_roles group_rbac_roles_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.group_rbac_roles
    ADD CONSTRAINT group_rbac_roles_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: hmacauth_credentials hmacauth_credentials_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.hmacauth_credentials
    ADD CONSTRAINT hmacauth_credentials_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;


--
-- Name: hmacauth_credentials hmacauth_credentials_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.hmacauth_credentials
    ADD CONSTRAINT hmacauth_credentials_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: jwt_secrets jwt_secrets_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.jwt_secrets
    ADD CONSTRAINT jwt_secrets_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;


--
-- Name: jwt_secrets jwt_secrets_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.jwt_secrets
    ADD CONSTRAINT jwt_secrets_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: keyauth_credentials keyauth_credentials_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.keyauth_credentials
    ADD CONSTRAINT keyauth_credentials_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;


--
-- Name: keyauth_credentials keyauth_credentials_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.keyauth_credentials
    ADD CONSTRAINT keyauth_credentials_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: keyauth_enc_credentials keyauth_enc_credentials_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.keyauth_enc_credentials
    ADD CONSTRAINT keyauth_enc_credentials_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;


--
-- Name: keyauth_enc_credentials keyauth_enc_credentials_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.keyauth_enc_credentials
    ADD CONSTRAINT keyauth_enc_credentials_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: login_attempts login_attempts_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.login_attempts
    ADD CONSTRAINT login_attempts_consumer_id_fkey FOREIGN KEY (consumer_id) REFERENCES public.consumers(id) ON DELETE CASCADE;


--
-- Name: mtls_auth_credentials mtls_auth_credentials_ca_certificate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.mtls_auth_credentials
    ADD CONSTRAINT mtls_auth_credentials_ca_certificate_id_fkey FOREIGN KEY (ca_certificate_id) REFERENCES public.ca_certificates(id) ON DELETE CASCADE;


--
-- Name: mtls_auth_credentials mtls_auth_credentials_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.mtls_auth_credentials
    ADD CONSTRAINT mtls_auth_credentials_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;


--
-- Name: mtls_auth_credentials mtls_auth_credentials_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.mtls_auth_credentials
    ADD CONSTRAINT mtls_auth_credentials_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: oauth2_authorization_codes oauth2_authorization_codes_credential_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_credential_id_fkey FOREIGN KEY (credential_id, ws_id) REFERENCES public.oauth2_credentials(id, ws_id) ON DELETE CASCADE;


--
-- Name: oauth2_authorization_codes oauth2_authorization_codes_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_service_id_fkey FOREIGN KEY (service_id, ws_id) REFERENCES public.services(id, ws_id) ON DELETE CASCADE;


--
-- Name: oauth2_authorization_codes oauth2_authorization_codes_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: oauth2_credentials oauth2_credentials_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.oauth2_credentials
    ADD CONSTRAINT oauth2_credentials_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;


--
-- Name: oauth2_credentials oauth2_credentials_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.oauth2_credentials
    ADD CONSTRAINT oauth2_credentials_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: oauth2_tokens oauth2_tokens_credential_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_credential_id_fkey FOREIGN KEY (credential_id, ws_id) REFERENCES public.oauth2_credentials(id, ws_id) ON DELETE CASCADE;


--
-- Name: oauth2_tokens oauth2_tokens_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_service_id_fkey FOREIGN KEY (service_id, ws_id) REFERENCES public.services(id, ws_id) ON DELETE CASCADE;


--
-- Name: oauth2_tokens oauth2_tokens_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: plugins plugins_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;


--
-- Name: plugins plugins_route_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_route_id_fkey FOREIGN KEY (route_id, ws_id) REFERENCES public.routes(id, ws_id) ON DELETE CASCADE;


--
-- Name: plugins plugins_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_service_id_fkey FOREIGN KEY (service_id, ws_id) REFERENCES public.services(id, ws_id) ON DELETE CASCADE;


--
-- Name: plugins plugins_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: rbac_role_endpoints rbac_role_endpoints_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.rbac_role_endpoints
    ADD CONSTRAINT rbac_role_endpoints_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.rbac_roles(id) ON DELETE CASCADE;


--
-- Name: rbac_role_entities rbac_role_entities_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.rbac_role_entities
    ADD CONSTRAINT rbac_role_entities_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.rbac_roles(id) ON DELETE CASCADE;


--
-- Name: rbac_roles rbac_roles_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.rbac_roles
    ADD CONSTRAINT rbac_roles_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: rbac_user_roles rbac_user_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.rbac_user_roles
    ADD CONSTRAINT rbac_user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.rbac_roles(id) ON DELETE CASCADE;


--
-- Name: rbac_user_roles rbac_user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.rbac_user_roles
    ADD CONSTRAINT rbac_user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.rbac_users(id) ON DELETE CASCADE;


--
-- Name: rbac_users rbac_users_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.rbac_users
    ADD CONSTRAINT rbac_users_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: routes routes_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_service_id_fkey FOREIGN KEY (service_id, ws_id) REFERENCES public.services(id, ws_id);


--
-- Name: routes routes_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: services services_client_certificate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_client_certificate_id_fkey FOREIGN KEY (client_certificate_id, ws_id) REFERENCES public.certificates(id, ws_id);


--
-- Name: services services_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: snis snis_certificate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.snis
    ADD CONSTRAINT snis_certificate_id_fkey FOREIGN KEY (certificate_id, ws_id) REFERENCES public.certificates(id, ws_id);


--
-- Name: snis snis_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.snis
    ADD CONSTRAINT snis_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: targets targets_upstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.targets
    ADD CONSTRAINT targets_upstream_id_fkey FOREIGN KEY (upstream_id, ws_id) REFERENCES public.upstreams(id, ws_id) ON DELETE CASCADE;


--
-- Name: targets targets_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.targets
    ADD CONSTRAINT targets_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: upstreams upstreams_client_certificate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.upstreams
    ADD CONSTRAINT upstreams_client_certificate_id_fkey FOREIGN KEY (client_certificate_id) REFERENCES public.certificates(id);


--
-- Name: upstreams upstreams_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.upstreams
    ADD CONSTRAINT upstreams_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: vaults_beta vaults_beta_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.vaults_beta
    ADD CONSTRAINT vaults_beta_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- Name: workspace_entity_counters workspace_entity_counters_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kong
--

ALTER TABLE ONLY public.workspace_entity_counters
    ADD CONSTRAINT workspace_entity_counters_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.2
-- Dumped by pg_dump version 14.2

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

DROP DATABASE postgres;
--
-- Name: postgres; Type: DATABASE; Schema: -; Owner: kong
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE postgres OWNER TO kong;

\connect postgres

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
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: kong
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

