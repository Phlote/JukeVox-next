--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1
-- Dumped by pg_dump version 15.2 (Debian 15.2-1.pgdg110+1)

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
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: pgsodium; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA pgsodium;


ALTER SCHEMA pgsodium OWNER TO postgres;

--
-- Name: pgsodium; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgsodium WITH SCHEMA pgsodium;


--
-- Name: EXTENSION pgsodium; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgsodium IS 'Pgsodium is a modern cryptography library for Postgres.';


--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: pgjwt; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgjwt WITH SCHEMA extensions;


--
-- Name: EXTENSION pgjwt; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgjwt IS 'JSON Web Token API for Postgresql';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  	coalesce(
		nullif(current_setting('request.jwt.claim.email', true), ''),
		(nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
	)::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  	coalesce(
		nullif(current_setting('request.jwt.claim.role', true), ''),
		(nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
	)::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  	coalesce(
		nullif(current_setting('request.jwt.claim.sub', true), ''),
		(nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
	)::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: postgres
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  schema_is_cron bool;
BEGIN
  schema_is_cron = (
    SELECT n.nspname = 'cron'
    FROM pg_event_trigger_ddl_commands() AS ev
    LEFT JOIN pg_catalog.pg_namespace AS n
      ON ev.objid = n.oid
  );
  IF schema_is_cron
  THEN
    grant usage on schema cron to postgres with grant option;
    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;
    grant all privileges on all tables in schema cron to postgres with grant option; 
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO postgres;

--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: postgres
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;
    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
    ALTER function net.http_collect_response(request_id bigint, async boolean) SECURITY DEFINER;
    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
    ALTER function net.http_collect_response(request_id bigint, async boolean) SET search_path = net;
    REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
    REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
    REVOKE ALL ON FUNCTION net.http_collect_response(request_id bigint, async boolean) FROM PUBLIC;
    GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    GRANT EXECUTE ON FUNCTION net.http_collect_response(request_id bigint, async boolean) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO postgres;

--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );
    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);
                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;
    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: postgres
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RAISE WARNING 'PgBouncer auth request: %', p_usename;
    RETURN QUERY
    SELECT usename::TEXT, passwd::TEXT FROM pg_catalog.pg_shadow
    WHERE usename = p_usename;
END;
$$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO postgres;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
	select string_to_array(name, '/') into _parts;
	select _parts[array_length(_parts,1)] into _filename;
	-- @todo return the last part instead of 2
	return split_part(_filename, '.', 2);
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[1:array_length(_parts,1)-1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
  v_order_by text;
  v_sort_order text;
begin
  case
    when sortcolumn = 'name' then
      v_order_by = 'name';
    when sortcolumn = 'updated_at' then
      v_order_by = 'updated_at';
    when sortcolumn = 'created_at' then
      v_order_by = 'created_at';
    when sortcolumn = 'last_accessed_at' then
      v_order_by = 'last_accessed_at';
    else
      v_order_by = 'name';
  end case;
  case
    when sortorder = 'asc' then
      v_sort_order = 'asc';
    when sortorder = 'desc' then
      v_sort_order = 'desc';
    else
      v_sort_order = 'asc';
  end case;
  v_order_by = v_order_by || ' ' || v_sort_order;
  return query execute
    'with folders as (
       select path_tokens[$1] as folder
       from storage.objects
         where objects.name ilike $2 || $3 || ''%''
           and bucket_id = $4
           and array_length(regexp_split_to_array(objects.name, ''/''), 1) <> $1
       group by folder
       order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(regexp_split_to_array(objects.name, ''/''), 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    from_ip_address inet,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone character varying(15) DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change character varying(15) DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: Artist_Submission_Table; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public."Artist_Submission_Table" (
    "submissionID" uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    "submissionTime" timestamp with time zone DEFAULT now(),
    "mediaURI" text NOT NULL,
    "mediaTitle" text NOT NULL,
    tags text[],
    "noOfCosigns" smallint DEFAULT '0'::smallint,
    cosigns text[],
    "collaboratorWalletAddresses" text[],
    "playlistIDs" uuid[],
    "submitterWallet" text NOT NULL,
    "marketplaceItemID" uuid,
    "mediaFormat" text,
    "artistName" text,
    username text,
    "isArtist" boolean DEFAULT true NOT NULL,
    "hotdropAddress" text DEFAULT ''::text NOT NULL,
    "transactionHash" text
);


ALTER TABLE public."Artist_Submission_Table" OWNER TO supabase_admin;

--
-- Name: Comments_Table; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public."Comments_Table" (
    "commentID" uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now(),
    slug text,
    "updatedAt" timestamp with time zone DEFAULT now(),
    content text NOT NULL,
    "isPublished" boolean DEFAULT true,
    "isPinned" boolean DEFAULT false,
    "isDeleted" boolean DEFAULT false,
    "parentCommentID" uuid,
    "authorWallet" text NOT NULL,
    "submissionID_artist" uuid,
    "submissionID_curator" uuid
);


ALTER TABLE public."Comments_Table" OWNER TO supabase_admin;

--
-- Name: Curator_Submission_Table; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public."Curator_Submission_Table" (
    "submissionID" uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    "submissionTime" timestamp with time zone DEFAULT now(),
    "mediaURI" text NOT NULL,
    "mediaTitle" text NOT NULL,
    tags text[],
    "noOfCosigns" smallint DEFAULT '0'::smallint,
    "playlistIDs" uuid[],
    "submitterWallet" text NOT NULL,
    "marketplaceItemID" uuid,
    "artistName" text,
    "mediaType" text,
    username text,
    cosigns text[],
    "isArtist" boolean DEFAULT false NOT NULL,
    "hotdropAddress" text DEFAULT '0xb3727e8fa83e7a913a8c13bad9c2b70f83279782'::text NOT NULL,
    "transactionHash" text
);


ALTER TABLE public."Curator_Submission_Table" OWNER TO supabase_admin;

--
-- Name: COLUMN "Curator_Submission_Table"."mediaType"; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public."Curator_Submission_Table"."mediaType" IS 'This will be replaced by the curator/artist separation.';


--
-- Name: COLUMN "Curator_Submission_Table".username; Type: COMMENT; Schema: public; Owner: supabase_admin
--

COMMENT ON COLUMN public."Curator_Submission_Table".username IS 'Use wallet foreign key instead to find username from user table.';


--
-- Name: Marketplace_Items_Table; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public."Marketplace_Items_Table" (
    "itemID" uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    "itemAddress" text,
    "itemLink" text,
    "itemName" text,
    "itemCreatedAt" timestamp with time zone DEFAULT now()
);


ALTER TABLE public."Marketplace_Items_Table" OWNER TO supabase_admin;

--
-- Name: Playlists_Table; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public."Playlists_Table" (
    "playlistID" uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now(),
    "followerCount" integer[],
    "playlistLink" text[],
    genres text[],
    "playlistName" text NOT NULL,
    "submissionIDs" text[]
);


ALTER TABLE public."Playlists_Table" OWNER TO supabase_admin;

--
-- Name: Users_Table; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public."Users_Table" (
    "createdAt" timestamp with time zone DEFAULT now(),
    "curatorSubmissionIDs" text[],
    "artistSubmissionIDs" text[],
    username text,
    city text,
    twitter text,
    "profilePic" text DEFAULT 'https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png'::text,
    "updateTime" timestamp with time zone DEFAULT now(),
    email text,
    wallet text NOT NULL
);


ALTER TABLE public."Users_Table" OWNER TO supabase_admin;

--
-- Name: comments; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.comments (
    "submissionID" bigint NOT NULL,
    slug text NOT NULL,
    threadid bigint NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now(),
    title text,
    content text,
    "isPublished" boolean DEFAULT false NOT NULL,
    "authorId" text NOT NULL,
    "parentId" bigint,
    live boolean DEFAULT true,
    "isPinned" boolean DEFAULT false NOT NULL,
    "isDeleted" boolean DEFAULT false NOT NULL,
    "isApproved" boolean DEFAULT true NOT NULL
);


ALTER TABLE public.comments OWNER TO supabase_admin;

--
-- Name: comments_submissionID_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

CREATE SEQUENCE public."comments_submissionID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."comments_submissionID_seq" OWNER TO supabase_admin;

--
-- Name: comments_submissionID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: supabase_admin
--

ALTER SEQUENCE public."comments_submissionID_seq" OWNED BY public.comments."submissionID";


--
-- Name: submissions; Type: VIEW; Schema: public; Owner: supabase_admin
--

CREATE VIEW public.submissions AS
 SELECT "Artist_Submission_Table"."submissionID",
    "Artist_Submission_Table"."mediaURI",
    "Artist_Submission_Table"."submitterWallet",
    "Artist_Submission_Table"."noOfCosigns",
    "Artist_Submission_Table"."marketplaceItemID",
    "Artist_Submission_Table"."artistName",
    "Artist_Submission_Table"."mediaTitle",
    "Artist_Submission_Table".username,
    "Artist_Submission_Table"."submissionTime",
    "Artist_Submission_Table".cosigns,
    "Artist_Submission_Table"."isArtist",
    "Artist_Submission_Table"."hotdropAddress"
   FROM public."Artist_Submission_Table"
UNION ALL
 SELECT "Curator_Submission_Table"."submissionID",
    "Curator_Submission_Table"."mediaURI",
    "Curator_Submission_Table"."submitterWallet",
    "Curator_Submission_Table"."noOfCosigns",
    "Curator_Submission_Table"."marketplaceItemID",
    "Curator_Submission_Table"."artistName",
    "Curator_Submission_Table"."mediaTitle",
    "Curator_Submission_Table".username,
    "Curator_Submission_Table"."submissionTime",
    "Curator_Submission_Table".cosigns,
    "Curator_Submission_Table"."isArtist",
    "Curator_Submission_Table"."hotdropAddress"
   FROM public."Curator_Submission_Table";


ALTER TABLE public.submissions OWNER TO supabase_admin;

--
-- Name: users_table_duplicate; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.users_table_duplicate (
    "createdAt" timestamp with time zone DEFAULT now(),
    "curatorSubmissionIDs" text[],
    "artistSubmissionIDs" text[],
    username text,
    city text,
    twitter text,
    "profilePic" text DEFAULT 'https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png'::text,
    "updateTime" timestamp with time zone DEFAULT now(),
    email text,
    wallet text NOT NULL
);


ALTER TABLE public.users_table_duplicate OWNER TO supabase_admin;

--
-- Name: votes; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.votes (
    "commentId" bigint NOT NULL,
    "userId" text NOT NULL,
    value integer NOT NULL,
    CONSTRAINT vote_quantity CHECK (((value <= 1) AND (value >= '-1'::integer)))
);


ALTER TABLE public.votes OWNER TO supabase_admin;

--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Name: comments submissionID; Type: DEFAULT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.comments ALTER COLUMN "submissionID" SET DEFAULT nextval('public."comments_submissionID_seq"'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, from_ip_address, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after) FROM stdin;
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user) FROM stdin;
\.


--
-- Data for Name: key; Type: TABLE DATA; Schema: pgsodium; Owner: postgres
--

COPY pgsodium.key (id, status, created, expires, key_type, key_id, key_context, comment, user_data) FROM stdin;
9adc6341-6c25-40e4-9ff7-621094806bbc	default	2022-10-23 19:11:23.455492	\N	\N	1	\\x7067736f6469756d	This is the default key used for vault.secrets	\N
\.


--
-- Data for Name: Artist_Submission_Table; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

COPY public."Artist_Submission_Table" ("submissionID", "submissionTime", "mediaURI", "mediaTitle", tags, "noOfCosigns", cosigns, "collaboratorWalletAddresses", "playlistIDs", "submitterWallet", "marketplaceItemID", "mediaFormat", "artistName", username, "isArtist", "hotdropAddress", "transactionHash") FROM stdin;
432c8f4c-753a-4038-88c1-fb65ad64febc	2022-09-09 15:46:39.321491+00	https://ipfs.moralis.io:2053/ipfs/QmZW64E7TLpnjMgkSHNXhC2pJvQTg6JavqdvxDDkwXAsvq	See You Again	{pop,rnb,nyc}	2	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	\N	\N	0x892dc20b79287052FB4E21E131ff867c9ee003A7	\N	audio/mpeg	Carter Brown	\N	t		\N
5dc796ff-9b20-47d1-a4b3-2b523737d106	2022-09-04 23:19:33.777506+00	https://ipfs.moralis.io:2053/ipfs/QmQ2t2ofNr2XohVfFmffhS9tyLBfMxkaNAvPRqoiY2UHQc	Calm Down	\N	3	{0xb60D2E146903852A94271B9A71CF45aa94277eB5,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	\N	\N	0xeD22Bb0106c24C7f6b4d8AAe33639e1467061F64	\N	audio/mpeg	Black Dave	\N	t		\N
bbeb4f10-905b-4e86-91f7-17efec438841	2022-09-06 15:40:24.847011+00	https://ipfs.moralis.io:2053/ipfs/QmQk7rveggPGAw8XmKihQ87Zz2fvyocwtViVBFWfDV2Hnf	FIRE & RAIN FREESTYLE PROD. MYLEZ DANIELZ	{MARYLAND,DMV,INDEPENDENT,BALTIMORE,RAP,FREESTYLE,"SELF PRODUCED","SELF ENGINEERED"}	0	\N	\N	\N	0x1502F98D90cc10b11B994566dFC44EC84035eCE8	\N	audio/mpeg	BVLL	\N	t		\N
1210ec33-8f86-4e12-a345-c8d58bd89679	2022-09-06 15:42:34.170809+00	https://ipfs.moralis.io:2053/ipfs/QmYHc1ftbWHazeovAjJ4nBPAieDN9stsTuLngFiRCbPJEP	ALIV3 ++ 	{MARYLAND,DMV,BALTIMORE,"SELF PRODUCED","SELF ENGINEERED",RAP}	0	\N	\N	\N	0x1502F98D90cc10b11B994566dFC44EC84035eCE8	\N	audio/mpeg	BVLL	\N	t		\N
440daf5d-329d-4082-8f33-8f04867bb37c	2022-07-22 14:33:16.048574+00	https://ipfs.moralis.io:2053/ipfs/QmcWB6Pphb22ev9qQMzDnAQod7F9XKaf6fp2JoAuHp7xuD	Bensound Dubstep	\N	0	\N	\N	\N	0x1ce9200E1547F8bfb3EFa961FF0b8F88356Ccae2	\N	audio/mpeg	Unlicensed	\N	t		\N
e2555735-0782-49f5-b7b6-be70b1591aff	2022-09-13 03:10:33.442627+00	https://ipfs.moralis.io:2053/ipfs/QmQ99cPqXngmDezQ6pF6TQBiqMVrg4gQCt1KT8oEab3qwi	Zima Blue Phlote Set 9.7.22	\N	4	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x52fA05393a003d234eFBA136E68DA835aeB64a26}	\N	\N	0xA23a740E0086B52d73ecDBb53423cCb53E0686D0	\N	audio/mpeg	ZIMA BLUE	\N	t		\N
8f400d7a-9e54-432b-995d-9639e9487e35	2022-07-27 19:23:51.012634+00	https://ipfs.moralis.io:2053/ipfs/QmR4ffrSkhbLFxHBPqZGNTDnBNtRbEnDDh7SJvLRzh8yMz	BLUE COLLAR AI VOICEMAIL	{"Experimental Audio","Radio Theater"}	1	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	\N	\N	0x0C1fd979293d12051BDd551131673D7b63119db8	\N	audio/mpeg	FRANK LEONE	\N	t		\N
cd6e5d00-8bf0-477d-bdd0-91e07beb69b7	2022-08-31 18:04:40.09373+00	https://ipfs.moralis.io:2053/ipfs/Qmaqyd1ypRsZu5SPWUMBgGQDKFx8M7JGxGGhd9yJYHbnyx	BREATHLESS	\N	3	{0x5ab45FB874701d910140e58EA62518566709c408,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	\N	\N	0x675F0278e3b5e853e6767b87c4519Afb4CC1d3a2	\N	audio/mpeg	KILROY	\N	t		\N
a8fa1830-4e92-4bcd-a492-955280ad4b91	2022-08-04 18:41:38.7264+00	https://ipfs.moralis.io:2053/ipfs/QmdGXdFXgf8gfjbsGTicMbYuQa2UpiDVBYWuvbjF4t7MiH	Locked in (24hrzzz)	{smokkestaxkk}	1	{0x5ab45FB874701d910140e58EA62518566709c408}	\N	\N	0x8b21E57F4cdB99c088AdCA33A4Eefba0d8713e93	\N	audio/wav	THRILLABXXNDS	\N	t		\N
02b6f351-800c-4fe7-af21-c93bdfda7c33	2022-08-04 18:36:59.311054+00	https://ipfs.moralis.io:2053/ipfs/QmaxPoUfEvN5EaaF1pKHHMxdAqozeBgDBcxefx74myzV1J	GLASS BEACH	{"alt indie"}	2	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x5ab45FB874701d910140e58EA62518566709c408}	\N	\N	0x8b21E57F4cdB99c088AdCA33A4Eefba0d8713e93	\N	audio/wav	THRILLABXXNDS	\N	t		\N
ece2ba1a-66f7-4e43-8dd1-a2a970e71ddb	2022-08-06 04:46:47.045679+00	https://ipfs.moralis.io:2053/ipfs/QmTPFFJyuhUgJBdE41cugLs7shn7xgWHZkLGAbnZnAekWb	Playa Shit	{Instrumental,"Chill Hop","Future Funk",Smooth,Vibes,Producer,Beats,Piano,Jazzy,Chill,Lofi}	0	\N	\N	\N	0x0dC4d7A2C908023E3fBa150e386FE2aEDa6f4172	\N	audio/mpeg	AJxOTB	\N	t		\N
655384eb-9ac0-4c56-b030-1b13b0461cc2	2022-09-09 15:44:04.258347+00	https://ipfs.moralis.io:2053/ipfs/QmcfruKt4QczwZTSE9qhJybtkJmr84f3dKQWFFfDiSjLuY	I'm Not Suburban	{#pop,rnb,nyc}	2	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	\N	\N	0x892dc20b79287052FB4E21E131ff867c9ee003A7	\N	audio/mpeg	Carter Brown	\N	t		\N
e9262f7a-e8e4-4626-871f-3dde7a8f9188	2022-08-10 08:16:35.713524+00	https://ipfs.moralis.io:2053/ipfs/Qmbvziq76HqeXQxmxcWSWrrbVvRWXjhwZKXNEBxgBqSeo9	Earned It // Chief Keef (NTRL Blend)	\N	1	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	\N	\N	0x579a79a9a199Ebd8a793BbB1F33fa709Ad38fadE	\N	audio/mpeg	NTRL	\N	t		\N
69e0f3a9-9e5e-4385-954a-ea1d34543274	2022-08-10 08:08:14.126642+00	https://ipfs.moralis.io:2053/ipfs/QmdpxLDud43BvCN3CNSLUvWnEexsa2SRC5Bf85iNnmUgwX	Ethereal Vs. Mall Grab (NTRL Blend)	\N	1	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	\N	\N	0x579a79a9a199Ebd8a793BbB1F33fa709Ad38fadE	\N	audio/mpeg	NTRL	\N	t		\N
8f080af7-8c2c-4fd1-81f7-9c4fd99432df	2022-08-10 08:13:38.979171+00	https://ipfs.moralis.io:2053/ipfs/QmS3ANTk95R5B2fD47JJ2BSMJ26QSx9MK1sBwUo4tjDNMc	PlayBoiCarti Vs. Cubox (NTRL Blend)	\N	1	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	\N	\N	0x579a79a9a199Ebd8a793BbB1F33fa709Ad38fadE	\N	audio/mpeg	NTRL	\N	t		\N
69219099-2930-47c0-b888-7fb0ec0cdc0d	2022-08-05 01:10:57.916436+00	https://ipfs.moralis.io:2053/ipfs/Qmaho6DDqZfg9VN2NhxssVNHp2YuG3m13fKqmDyT4sppUy	zela kyle	{"hyper pop","phlote live vote"}	0	\N	\N	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	audio/wav	Melody Architect	\N	t		\N
185c6602-4396-4ced-8953-0b50e705c092	2022-08-05 01:13:12.221765+00	https://ipfs.moralis.io:2053/ipfs/QmXTgd9eobsKivntcTmXVsuJj3gBmgLjU8fXoMbvQgNbw6	Waiting	{"hyper pop","phlote live vote"}	0	\N	\N	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	audio/mpeg	D .Renzo	\N	t		\N
57f6ccc7-4c8f-45f9-b0a1-ebe7ede4cfc9	2022-08-05 01:16:33.363667+00	https://ipfs.moralis.io:2053/ipfs/QmQrmBZ12EWJmHkpojDecXs4cB28gi7UJnyw7qKMyS7rMe	The Other B	{rnb,"phlote live vote"}	0	\N	\N	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	audio/mpeg	MJ	\N	t		\N
c025e2a4-ff86-4327-9e64-f3750c8d8956	2022-08-05 01:18:23.497645+00	https://ipfs.moralis.io:2053/ipfs/QmYJC1DJStZMp8dusJfLPwu59RmP54aSLTESsMGxprxhKj	Murdered Fashion	{drill}	0	\N	\N	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	audio/mpeg	Tanaka	\N	t		\N
e3383461-bd0a-49ce-9419-aad4af72ea21	2022-08-05 00:51:57.342497+00	https://ipfs.moralis.io:2053/ipfs/QmcTYqkNjk3Z74ppdapx42cyVwHNVzTadDWenc8aXjBjo9	BDNJ	{rap,dance,"dance track","phlote live vote"}	0	\N	\N	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	audio/mpeg	Yung Attila	\N	t		\N
75b0a859-0c56-4e49-83d0-64ab66980fbd	2022-08-05 01:28:47.254361+00	https://ipfs.moralis.io:2053/ipfs/QmQXV846cRGuKtweexHNTPQLVgtWThoAwf2atk9eVZMASx	FNN	{"hip hop","club music","phlote live vote"}	0	\N	\N	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	audio/mpeg	Bonita	\N	t		\N
b238e11d-9bf9-4ab8-b27f-acc5401b0b5d	2022-08-05 01:40:07.131716+00	https://ipfs.moralis.io:2053/ipfs/Qmf7dDzcsfTuMdKYqX3Tz4ur9j2vpG4JBYp2yGtU2w43hK	Sneaky Link	{drill,"phlote live vote"}	1	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	\N	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	audio/wav	Kenja	\N	t		\N
f643f3c9-1b09-4240-a4cf-eb4dea8036b7	2022-08-05 01:22:05.498254+00	https://ipfs.moralis.io:2053/ipfs/QmYDtuhrTaXckiZWajUPepinyPSXtkYY5AEzTTSeGbLqY6	Why you talking mad shit	{rap,dembo,dembow,"phlote live vote"}	2	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	\N	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	audio/mpeg	Money Kennedy	\N	t		\N
052d0da0-65d5-4061-8cf6-100f79037cc8	2022-08-15 23:30:37.869121+00	https://ipfs.moralis.io:2053/ipfs/QmdBkujtEBP1BW4wK7gvt8ka1aRx8fkStmB8Q1C7yQQTLE	Gwei	{rap,drill,crypto,bass}	1	{0x5ab45FB874701d910140e58EA62518566709c408}	\N	\N	0x481682C6183bBAAf0b8B8136875dFa24BF508826	\N	audio/mpeg	NateKodi	\N	t		\N
0d705b7d-e5ba-4aa3-8284-f0ddddd424f2	2022-09-09 15:48:07.733196+00	https://ipfs.moralis.io:2053/ipfs/QmaVnA5owvW3zPJAE9ByA97miKwRZoe3h8VwZMkp4r34Re	Energy	{pop,rnb,nyc}	3	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	\N	\N	0x892dc20b79287052FB4E21E131ff867c9ee003A7	\N	audio/mpeg	Carter Brown	\N	t		\N
e220a9ce-0eed-4e2b-8fe4-73e928d3e3fe	2022-09-18 21:25:32.703277+00	https://ipfs.moralis.io:2053/ipfs/QmdFDpxXTwDbtzrjV9sABpCAVnwmUKuoWwmJaVrNFxUsnx	Foreign Romance 	\N	0	\N	\N	\N	0x579a79a9a199Ebd8a793BbB1F33fa709Ad38fadE	\N	audio/mpeg	Natural 	\N	t		\N
3a82d0c2-2f54-44d4-aed6-f5a1a306220f	2022-09-18 17:26:12.919385+00	https://ipfs.moralis.io:2053/ipfs/QmT1NfH2XzkxoeZSEhpBEPRx5nxDyS9rZrs336DHufY4zP	???? NTRL Blend 	\N	3	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x52fA05393a003d234eFBA136E68DA835aeB64a26}	\N	\N	0x579a79a9a199Ebd8a793BbB1F33fa709Ad38fadE	\N	audio/mpeg	NTRL	\N	t		\N
ddfa527d-e2ac-48a2-9dac-059a3404b6a3	2022-08-16 19:53:07.971951+00	https://ipfs.moralis.io:2053/ipfs/QmUkhR5ZTZHMPhEv9LCPaW9Yx7Le35Qo61nFkTZMH5v5sc	GMFU	{ForteBowie,"Hip Hop"}	5	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x52fA05393a003d234eFBA136E68DA835aeB64a26,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	\N	\N	0xcf3571AcCFCcFa1710984E6EDD659Fc9A906DC8C	\N	audio/wav	ForteBowie	\N	t		\N
4634b46a-0290-450d-96b2-280bccd4c3ba	2022-09-18 17:34:09.159519+00	https://ipfs.moralis.io:2053/ipfs/QmYiuXEc7acSBgMmM6BtVtEW8Sf1o8tyNvy1umrQfZY2fy	VHS Beats 	\N	3	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x52fA05393a003d234eFBA136E68DA835aeB64a26}	\N	\N	0x579a79a9a199Ebd8a793BbB1F33fa709Ad38fadE	\N	audio/mpeg	NTRL	\N	t		\N
11f7086a-2cb1-4df9-80ec-7a6529b3207f	2022-11-03 23:36:13.993981+00	https://ipfs.moralis.io:2053/ipfs/QmPGtwBPLN1BS5VfA6232xXk78Ze1Do4yQXSJptbmqqXCF	In the Beginning	\N	2	{0x0bbac2bd3134a318deb31137d87d42bf54325cb7,0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47}	\N	\N	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	audio/mpeg	SAULT	\N	t		\N
7b95efe0-b556-4b77-be53-38ec29fc79b0	2022-12-16 01:49:42.616003+00	https://ipfs.moralis.io:2053/ipfs/QmbG9aEsCAjpipeSK1pkKkdjMVjR7YJfy8CUDhJnnwzNFZ	So Icy Mix	\N	0	\N	\N	\N	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	audio/mpeg	La Natural	\N	t	0x372d6047613787186a9b8F2E67b9d30d0c6B6749	\N
21f6a140-6765-4f07-b4b7-04d7f4a44b22	2022-12-18 17:10:29.854372+00	https://ipfs.moralis.io:2053/ipfs/QmRGmg9x4Lgspt2Rqwa6hKaJigvvvNCYYjQaopesuJRwWE	BS Demo	\N	1	{0x0bbac2bd3134a318deb31137d87d42bf54325cb7}	\N	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	audio/mpeg	Danny	\N	t	0xeC9e69a00f3c11b5C02a450A846ABA4c8f1BE438	\N
1f0dc7d1-17da-49f3-af04-ac4bb6940499	2022-12-29 01:49:25.412981+00	https://ipfs.moralis.io:2053/ipfs/QmbG9aEsCAjpipeSK1pkKkdjMVjR7YJfy8CUDhJnnwzNFZ	Yesy	\N	0	\N	\N	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	audio/mpeg	Test	\N	t	0xE6b4F87dBb47cE1C32BAa3c19DFEAFE07915BF4F	\N
12ce44da-cf08-4edf-9439-8c90b1423544	2023-01-09 21:13:35.032466+00	https://ipfs.moralis.io:2053/ipfs/QmeFKWpYzqdxfkvbJmPxA9wPaZPMbKAmtu92Qyi1Hv9Jma	test	\N	0	\N	\N	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0xa52b442bfeca885d7de4f74971337f6cf4e86f3b	\N	audio/mpeg	abc	\N	t	0x80Ecd5742faDF795e4721b0e2783D5Ad1504eCC9	\N
ce9997ff-46f8-4231-b528-1591435d15d2	2023-01-12 18:58:18.340262+00	https://ipfs.moralis.io:2053/ipfs/QmcZuFX8t6b9s6XW5J6mGE5zq7ihEnMszJbDsdZPPPn4ei	testing	\N	1	{0x56cef7b74cc7121bb88c6d9b469819b5d32c9b22}	\N	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0xb60d2e146903852a94271b9a71cf45aa94277eb5	\N	audio/mpeg	testing	\N	t	0x537e934A8Aa82D57678169ec39F50A80B564bb7b	\N
f699b0a9-8abe-497e-9c03-420e7ce5d855	2023-02-09 01:29:23.131988+00	https://ipfs.moralis.io:2053/ipfs/QmNrbuG6UL4Cc2VpaxZZyVmbnFLiPrE36EyUHgptXbwSuS	test	\N	2	{0xc68fdd7fedf3e45efbc97096bdbaeea92540b3a4,0xb60d2e146903852a94271b9a71cf45aa94277eb5}	\N	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0xd2f8af18dcd90a87bc8a5daaa931430b12a1613c	\N	audio/mpeg	test	\N	t	0xF7b57Cf625351Bdb9d6b5abdf934B754937ECc96	\N
1247a122-4cae-48ab-a69d-513d7191e6c6	2023-01-16 06:58:12.982693+00	https://ipfs.moralis.io:2053/ipfs/QmPGCQbetutKBNix9ZaQ1xoF4HaNaaNBvKK67h5b8uv91o	Test	\N	5	{0x56cef7b74cc7121bb88c6d9b469819b5d32c9b22,0xa67d77830a1274948e38e0c9a646d96f16bf492d,0x71947e53f4d4d4f1eef64dd360ef60a725e5373c,0xb60d2e146903852a94271b9a71cf45aa94277eb5,0xc68fdd7fedf3e45efbc97096bdbaeea92540b3a4}	\N	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x883a368a32e8763427aa86ffa85ed9f24d654085	\N	audio/mpeg	artistTest	\N	t	0xac10726EA5629a76f0BFa2E00FeDBf22D19ECdCe	\N
e24eac33-8dac-45ae-9663-4e369743da9a	2022-08-23 23:58:03.669636+00	https://ipfs.moralis.io:2053/ipfs/QmWK3MawHS9VtJ9SPYtyk6NwDqv6t2vVAWScuwsMrQyYXK	PHLOTE Set @ The Pocket (8/17/22)	{RVOL,"DJ SET","Reggie Volume",BNCE,Remixes}	5	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xfFba44c15Fe2768bC2234078dfac8c5A651A56e9,0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	\N	\N	0x6EAa694F9B5Df42961FBAea1563bf6EE658Cb681	\N	audio/mpeg	Reggie Volume	\N	t		\N
026c4c8d-1ce9-4919-bbae-b26c9dc9c5ab	2022-09-18 17:31:44.173557+00	https://ipfs.moralis.io:2053/ipfs/QmVKpP7DBjJykK3HdqMGX5TRbNBQVGfy3TteVpHc73VLPa	It Gets Better 	\N	5	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x52fA05393a003d234eFBA136E68DA835aeB64a26,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xa52B442bfeca885d7DE4F74971337f6Cf4E86f3B}	\N	\N	0x579a79a9a199Ebd8a793BbB1F33fa709Ad38fadE	\N	audio/mpeg	NTRL	\N	t		\N
53f0d19a-8306-4778-90e2-5ff029b14a00	2023-01-18 00:56:07.843636+00	https://ipfs.moralis.io:2053/ipfs/QmczVQkxf9trpepYE5po4zAx7UP6TTs1x8Gzxpm7w5RAmc	sds	\N	3	{0x56cef7b74cc7121bb88c6d9b469819b5d32c9b22,0xa52b442bfeca885d7de4f74971337f6cf4e86f3b,0x31e5fbadb610954cb6e486c746d49883546413ed}	\N	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0xb60d2e146903852a94271b9a71cf45aa94277eb5	\N	audio/mpeg	testing	\N	t	0x6d78b9387Ae2ce33310d0EeD5aEbb692d4d171cc	\N
\.


--
-- Data for Name: Comments_Table; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

COPY public."Comments_Table" ("commentID", "createdAt", slug, "updatedAt", content, "isPublished", "isPinned", "isDeleted", "parentCommentID", "authorWallet", "submissionID_artist", "submissionID_curator") FROM stdin;
\.


--
-- Data for Name: Curator_Submission_Table; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

COPY public."Curator_Submission_Table" ("submissionID", "submissionTime", "mediaURI", "mediaTitle", tags, "noOfCosigns", "playlistIDs", "submitterWallet", "marketplaceItemID", "artistName", "mediaType", username, cosigns, "isArtist", "hotdropAddress", "transactionHash") FROM stdin;
5ce7cc10-f4b6-4714-ab83-428b9af4ce1c	2022-11-22 13:52:03.150888+00	https://youtu.be/mKweYfxlujg	PASSENGER	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	papa mbye	\N	\N	\N	f	0xb26dD361Fb5cdE2181C7E839754AE3449e90eD58	\N
fce2954e-4de1-4036-a5fc-e18a1c8a3fe3	2022-11-22 13:52:47.78604+00	https://youtu.be/FCIEiG5NYJM	In My Head	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Take Van	\N	\N	\N	f	0x3aFbeDaDa97e589b3986bAe85f2975A189F8d994	\N
5fecef06-5f18-41ab-9b14-52981910c8db	2022-11-22 13:54:37.084156+00	https://youtu.be/gleA89FZHyo	Heartbreak Anonymous	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	WIL$ON	\N	\N	\N	f	0x63A9aee97280Ed7837d7C0ee67Ca490F5025d459	\N
5c762491-358d-4dff-827b-a72efbd7e36f	2022-11-22 14:23:55.47087+00	https://youtu.be/SWXCABmaJ4k	Feel Good	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Raury	\N	\N	\N	f	0x43da802D7bbc70a0a1AdE6C321F4e46Fb46E5464	\N
0fba4fd3-3acb-4c23-b41f-70cbaad63f96	2022-11-22 15:05:07.847345+00	https://youtu.be/xzksOwHDkUQ	Always	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Babygirl	\N	\N	\N	f	0x1d40E89997E559D68C57c046B9c1AaaE7D78bCe7	\N
df1e9c9a-34ed-48da-bc0a-ea8d89e3f68f	2022-11-22 15:07:15.577603+00	https://mrtwinsister.bandcamp.com/track/resort	Resort	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Mr Twin Sister	\N	\N	\N	f	0x34FA01C9BcB0eC968Ac633eEa5fa5AB5E2a8D034	\N
aca69f9a-8e36-4211-88f2-a0f713dd9791	2022-11-22 15:15:25.275243+00	https://soundcloud.com/wolfacejoeyy/nobodyelse	nobodyelse	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Wolfacejoeyy	\N	\N	\N	f	0x7FdDFb732B892Eb5A78a496E491dddF184BC51f1	\N
c391f042-27fe-421a-8e01-77b78cddf949	2022-11-23 17:13:51.318597+00	https://open.spotify.com/track/4cv3b6SvOTlX8LOLSOxugC?si=c98593cc8dfe40b2	Torneträsket	\N	0	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	Cleo, Ayla, Academics	\N	\N	\N	f	0xEa231647a9C7b9c863225e9d48f49c40301e4623	\N
e3509295-1486-48f2-a4db-2623b5fa52a2	2022-04-18 13:40:10.099868+00	https://t.co/LzZkbfMjmQ	Homage 94	{🏴‍☠️,💎}	1	\N	0xb53B1DF71705aa51efe96FaB14c6B11763c9768F	\N	Rafaël Rozendaal	\N	Jelly	{0x7d1f0b6556f19132e545717C6422e8AB004A5B7c}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a5e995e7-b144-44df-bc70-37a4b979fb28	2022-11-23 17:15:11.973435+00	https://open.spotify.com/track/0EYOSPQ3YWyFG3t5mtOioS?si=7d7832b5e1e14889	Wet Paint	\N	0	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	Deki Alem	\N	\N	\N	f	0x82699B1EccFfd0f158C1624937c59b34340eC18d	\N
5d510c83-cd90-4fe4-b4c7-b47acd8d8b1a	2022-11-23 17:39:51.699531+00	https://open.spotify.com/track/4QJM3BLWqODFafi26DqHiv?si=fde4a7126a64418e	Shine	\N	0	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	Amal 	\N	\N	\N	f	0x670F9A6C15Df8A5D31afEda625E0E6f2c2c25D0A	\N
d357d8ce-8f28-440e-945a-9cd886739008	2022-11-23 17:42:57.883802+00	https://open.spotify.com/track/54GAdNUIyrkume7NLjPLeP?si=ddeb117df98343cd	Different Places	\N	0	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	Fifty Grand, optic core	\N	\N	\N	f	0x06a27B76C5D96c3f00a9c9B6BED1902F78a95978	\N
dc4dd252-7e46-4d12-ac6e-e0764f433b06	2022-11-23 20:47:41.248568+00	https://soundcloud.com/brainchildnc/nuclearcurrent-by-mozes?si=b104ccb09fb543e1b1cc856a5d2cf1e2&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	Nuclear/Current	\N	0	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	Mozes	\N	\N	\N	f	0x63Cc6dc6CA07eB95ef3728220C59e20DC5324B2d	\N
80da6cbd-d669-4fa3-9d73-2240c6d3b552	2022-11-25 01:49:47.150659+00	https://open.spotify.com/track/7prx9AfJPjvOMPhmuzgXKI?si=16276f6e1fc844fc	Tombola 94	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	Dina Ögon	\N	\N	\N	f	0xEB98071053450b41abF4bBFFe08F2feAC44dCE1f	\N
82019d9a-94b6-49f6-a334-3dece4bae0c9	2022-11-25 20:20:59.411802+00	https://youtu.be/dkF6_B7BOuU	Enfield, Always	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Loraine James	\N	\N	\N	f	0x8d8F5E31A8131b8B2D5808412fb6A4AFE384FcCD	\N
74bc3268-68fc-4dc3-bb16-2b91daeafa1c	2022-11-18 01:04:08.393604+00	https://www.youtube.com/watch?v=toBTPGfurLc	Rich Spirit	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Kendrick Lamar	\N	\N	\N	f	0x931269760cB085a27a1a0052099A165205a39040	\N
2cf6c37c-0b8b-46e7-b2a4-58f999f44106	2022-11-20 16:24:30.117688+00	https://soundcloud.com/notnedaj?ref=clipboard&p=i&c=1&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	12 Stout Street (NEDAJ BOOTLEG)	\N	0	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	Nedaj	\N	\N	\N	f	0xD644C70742F94B241b5b7972D29F764Fde127C92	\N
b6ed04ee-2b01-425f-9308-9d82ca20cf2f	2022-11-22 13:47:11.375084+00	https://youtu.be/LIGe-jkvpuY	#FREEMIR	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Ghais Guevera	\N	\N	\N	f	0xA6eAB1D7cb59E24E19E2024639C41c067DF7A324	\N
45bdc8a6-fe32-4fd9-ba67-85956699a708	2022-11-22 13:48:57.174638+00	https://youtu.be/AMTWsIst-KY	7 Hours	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Wakai	\N	\N	\N	f	0x422506eC69D31F16547Ea46E594dBe14200B03a1	\N
b1f33df5-7279-4635-afa5-bc48de892962	2022-11-22 14:27:57.308603+00	https://youtu.be/J4sP9OA5KP0	Modele V	\N	0	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Rose Noir	\N	\N	\N	f	0x520c2312975d2D465c7e151B983d666b7Ed7AfA7	\N
e0c0659f-e3ee-4483-873f-5e18f0bb66b4	2022-11-22 14:38:30.981587+00	https://youtu.be/lhJpOjqho8s	Happy Ending	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Kelela 	\N	\N	\N	f	0x2B29BDF61411A77f141858f9B1Dded70eE8A8920	\N
cf349fc5-65c0-4c90-9d91-38adcafbdd3c	2022-11-22 14:58:49.283402+00	https://youtu.be/UblEdT-hW78	Do You miss me?	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Pink Pantheress	\N	\N	\N	f	0x101aF19cD3051F57aba1187C133Cf2CDDecA3F11	\N
8a2d4879-7d5f-4bb1-8e3a-8d2be5612e7b	2022-08-16 19:12:13.642017+00	https://open.spotify.com/track/7bp3zmEvpHLa0h32nhDUkB?si=d4kmr0gWQKevxRqR7pzVYA	L'enfer	\N	0	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Stromae	\N	discoveringEs	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8f86976f-0423-4a77-9ac7-aec4159b685e	2022-11-28 16:28:34.915823+00	https://youtu.be/91EoZsQeEn8\\	One More	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Wiki, MIKE, The Alchemist	\N	\N	\N	f	0xB2ff537A0dEfb8DB57F57a07C6D3D03B2b3BF2F7	\N
f3989a0e-1487-40e3-8a8b-ace9fa36537e	2022-11-29 20:52:45.501741+00	https://youtu.be/uI29qCR9PGk	Heroes & Villians	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Metro Boomin, Morgan Freeman, Lakeith Stanfield, Young Thug, Gunna, 21 Savage, Gibson Hazard	\N	\N	\N	f	0x23c4A238f300f8A0d12c3D5b6ec0d04d25Ef51a9	\N
ee30af58-07c9-4c7d-b0a6-467b226f69d2	2022-11-27 01:50:05.880145+00	https://open.spotify.com/album/4I4xtHaIFOzhZfp1NIHkY6?si=vtg11afETiOnnAaYHpNgWw	All Things Must Pass	\N	0	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	George Harrison	\N	\N	\N	f	0x6913787e64076D711236F8A74Ae356144922310E	\N
006a283e-4e61-4fe3-b568-ef614e30b276	2022-11-27 01:51:48.486235+00	https://youtu.be/uy89tcv_RHM	Symphony No. 4 ' Strange Time'	\N	0	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	Quinn Mason	\N	\N	\N	f	0x66dd1bDf0532B4f5D857a2A761223a0186A868bb	\N
39ed3380-70d6-478f-a2b6-31ca6b856d1f	2022-11-30 18:16:05.633441+00	https://internationalchrome.bandcamp.com/album/rea-4	ÁREA 4	\N	0	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	JLZ	\N	\N	\N	f	0xa1f9FF2b8f2E40FDF3C98385188d737F2B500081	\N
e3c586af-df9d-496f-9dc0-c13f9bd2d192	2022-04-22 20:49:34.502191+00	https://www.youtube.com/watch?v=USC7zd0SCwo	Utilize Me	{"Tunji Ige","Noah Breakfast",Philly,"Utilize Me","Sunday Driving Music"}	3	\N	0xfb3197Bd5b7F2E39c1e89B7619A697827eD2deff	\N	Tunji Ige	\N	\N	{0x1d14d9e297DfbcE003f5A8EbcF8cBa7fAEe70B91,0xc2469e9D964F25c58755380727a1C98782a219ac,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0844e12c-0147-4888-9d96-3cdfb8f31662	2022-05-01 23:43:38.486623+00	https://fallenioke.bandcamp.com/track/leywole	 Leywole	{"starts jumpin around 1:50 mins in."}	0	\N	0x7BD69d24a9B2f2ba32A0061309D767C4235e87Df	\N	Falle Nioke & Ghost Culture	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ccdbf55b-b389-4feb-80d9-29ba5a8862db	2022-09-13 21:02:51.9434+00	https://www.youtube.com/watch?v=kk9AO5JInto	Shake Dat A$$	\N	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Baha Banks	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e8d2de7c-c84a-48db-b40a-33eba7b90cbe	2022-09-05 18:06:13.23704+00	https://youtu.be/7z6jPC-qzdM	1st Round Pick	{snowfall,"the wood",dope}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	De'Aundre Bonds	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
50eb1aed-b0ee-471f-9fb1-642deedfe4fa	2022-04-01 00:25:28.652696+00	https://soundcloud.com/aquagie/doomsday-jive	DoomsDay Jive	{ODENZ}	0	\N	0x67A276b6768978C9E41Af5418E09Efc8a12a28dE	\N	Aquagie	\N	ODENZ	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0d3afd39-853d-4b67-b668-f1f89b4c5e70	2022-10-22 00:51:28.97694+00	https://www.youtube.com/watch?v=eNPg4ZTDjTg	Rage	{comeback}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Lil Skies	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1d63d45e-5253-4a54-b734-e58fe4ac323b	2022-09-06 16:10:49.150084+00	https://ipfs.moralis.io:2053/ipfs/QmYHc1ftbWHazeovAjJ4nBPAieDN9stsTuLngFiRCbPJEP	TRUST NOBODY	{MARYLAND,"MAD DELTA","KING LYRIKZ",DMV,RAP,"HIP HOP",BALTIMORE,"EAST COAST"}	0	\N	0x1502F98D90cc10b11B994566dFC44EC84035eCE8	\N	KING LYRIKZ	\N	Horace.eth	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b9aff569-1e7f-4d5b-aa3c-e0b44a523bcf	2022-08-27 01:05:58.549295+00	https://www.youtube.com/watch?v=Z05ncC9C8i4&list=PLvwgS-uCoxIhfSUjXaAMgWjGxptYUpJJJ&index=136	PRADA GLOVES	{EYEDRESS,PRADAGLOVES,TEXTINSHORTYINTHETUB,REVRUN}	3	\N	0x8d5fb8Aca8294FC9A701408494288D2d7de42F7E	\N	YL // EYEDRESS	\N	\N	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
faec8d0f-e93f-4cf8-8c46-9e134162af2d	2022-09-01 14:17:59.338373+00	https://www.youtube.com/watch?v=YZUZ8LgkVCA	For Her	\N	1	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	Juice Menace x Cymru	\N	athenayasaman	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
db3ddf50-3ed9-4632-ac98-ce3a4a971c1a	2022-08-25 03:49:00.747282+00	https://www.youtube.com/watch?v=nsvnKuD4lBk	BAGGY	{snap,texas}	1	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Tisakorean	\N	future modern	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
95faf5d4-b125-4b46-af39-4ed725fd92c0	2022-09-14 02:51:11.772246+00	https://open.spotify.com/track/4kuGKeXfiAZjNYHSWrLgGz?si=kaMhI1FYSPu-KBiLJKZQoQ	Love U	{Jazz,R&B}	0	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	SALOMEA	\N	discoveringEs	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
fcc28b07-346f-4853-9856-df7cf7d3619b	2022-03-30 02:01:11+00	https://audiomack.com/song/swaderaps/17700528?key=phlote	Neon Eon	{}	0	\N	0xCd930261704f384DC53F8691f0cBF961355293f8	\N	Southpaw Swade	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
324b5969-a2da-4e2f-93a9-892291690479	2022-04-17 13:44:37.679861+00	https://youtu.be/_KUKKyQp4qc	Fresh Off the Planes	{🔦,"Pierre Bourne"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	J Billz	\N	hallway	{0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
fd0b3156-2547-4db7-9649-372dda92137b	2022-05-01 20:29:11.623611+00	https://opensea.io/assets/0x495f947276749ce646f68ac8c248420045cb7b5e/44700177556079130579027571864789921161109844202338692374214745856868708515850	Seasons	\N	0	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Pat Dimitri	\N	Trish	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
cc8a90e6-89a7-4743-a8a5-f6d8d586cf06	2022-03-30 19:53:05+00	https://drive.google.com/file/d/1cR6hgsFqH-B4gO9kMEh9iVDnOZSxFY4y/view?usp=sharing	At It	{}	0	\N	0x0E0624A2E88E0Dc9B56f9c9Ce2D6907eDd2B8FdF	\N	Ricky Felix	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a420d0a5-6c7a-42c1-b075-df965ebb0ac9	2022-04-15 10:19:29.100821+00	https://soundcloud.com/chicken_oriental/bo-burnham-jeffrey-bezos-chicken-oriental-remix	Jeffrey Bezos (Chicken Oriental Remix)	\N	0	\N	0xE73edd9414b9Eb0E169283105CB1F0916823364F	\N	Chicken Oriental	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
53ccace1-232a-44f9-baf8-fb4c18e1c555	2022-09-06 16:13:12.34671+00	https://ipfs.moralis.io:2053/ipfs/QmYHc1ftbWHazeovAjJ4nBPAieDN9stsTuLngFiRCbPJEP	BREAKOUT	{"MAD DELTA",DUCKIE,"IT'S BMB",BVLL,"PROD. GUSTOMANE",MARYLAND,"EAST COAST"}	0	\N	0x1502F98D90cc10b11B994566dFC44EC84035eCE8	\N	BVLL, DUCKIE & IT'S BMB PROD. GUSTOMANE	\N	Horace.eth	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
69a04a2e-b8de-4986-8191-3540c08cc226	2022-08-30 14:53:08.720746+00	https://youtu.be/Ts0ERquzY98	Foul	\N	3	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Van Buren Records	\N	hallway	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f149abc7-3e72-46b4-8f9a-ba44507fa9aa	2022-08-28 14:17:11.15124+00	https://open.spotify.com/track/7scdPpuTSDF8cdU8TLofW3?si=733d2d5062bc4b1e	Criminal	{Strandz,Makintsmind,"Fully Lidge",UK}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Strandz	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d3ce763f-fe95-4ada-9c92-9c6e3b282c82	2022-04-09 20:51:33.319541+00	https://zora.co/collections/0xF538e318B305280B681612e5347A242F90214Be8	URUZ	{FELTZINE,Zora,URUZ,VisualArt}	1	\N	0xb077473009E7e013B0Fa68af63E96773E0A5D6A4	\N	Mark Sabb for FELT ZINE	\N	singnastydos	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
99f9fb90-5cc5-4d02-9d23-c4097dc4a371	2022-08-16 19:15:51.317429+00	https://youtu.be/yF-NC3eRsqc	Munch (Feelin' U)	{Bronx,"Ice Spice","Hip Hop"}	2	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Ice Spice	\N	discoveringEs	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
283360a6-5d4d-491b-9fb5-8eda4db8a44b	2022-04-16 11:15:34.385844+00	https://tekdotlun.bandcamp.com/album/ridin-round-2	Ridin Round 2	{🔦,album,Baltimore}	1	\N	0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47	\N	Tek.Lun	\N	Lil Josh	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
bad6936d-8956-4faa-9bc9-9a0f610b3326	2022-10-22 01:01:57.063231+00	https://www.youtube.com/watch?v=-CqRaupPmB0	CEO	{toronto}	3	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Killy	\N	future modern	{0xa52B442bfeca885d7DE4F74971337f6Cf4E86f3B,0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47,0x0bbac2bd3134a318deb31137d87d42bf54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8bec5a9c-239e-4220-a257-99345a6f5b89	2022-09-12 15:49:49.695025+00	https://www.youtube.com/watch?v=DmeUuoxyt_E	Rockstar	\N	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Nickelback	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
407cf680-f58c-45d0-a2a4-dcaf8e58caf4	2022-09-05 18:34:13.053912+00	https://soundcloud.com/dwn2evrth/moonrock-1	DWN2EARTH	\N	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	MOONROCK	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
9234a728-a5e4-46ae-81d5-f3c3191db766	2022-09-01 14:19:18.749396+00	https://www.youtube.com/watch?v=t3eyWxWg50k	Mount Olympus	\N	3	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	femdot. & SABA	\N	athenayasaman	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f87ea3c6-4522-488f-83c7-1cf837c2950c	2022-03-15 00:44:08+00	https://www.youtube.com/watch?v=BVnspZemoRQ	Wait	{ODENZ,"TG CRIPPY"}	1	\N	0x67A276b6768978C9E41Af5418E09Efc8a12a28dE	\N	TG CRIPPY	\N	ODENZ	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
42e8ebba-8ac9-4cf4-8206-1134935973fa	2022-08-11 20:49:03.480125+00	https://audiomack.com/burrlin_/song/cryptic	Cryptic	{ONWARDANDUPWARD,HOTTESTWAYTORAPBOUTCRYPTO,PREVWONONPHLOTEVOTETWITTERTUESDAY}	2	\N	0x8d5fb8Aca8294FC9A701408494288D2d7de42F7E	\N	BurrLin	\N	\N	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
aef57b97-4325-4328-91f9-a8f5ba2fc3a1	2022-08-18 15:47:01.085681+00	https://www.youtube.com/watch?v=fjN4va_feOM	Hearing Voices	\N	3	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	Contour	\N	athenayasaman	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c34a0926-da88-4a9e-b906-8803c873982e	2022-03-31 23:15:37.161425+00	https://soundcloud.com/lifeofthom/sets/phlote?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	BEATS 4 PHLOTE	\N	1	\N	0x6c5A162A3158ab52Bc10414BaE9766A1bac599dF	\N	LIFEOFTHOM	\N	\N	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
9400d6d7-4089-40e5-9d59-5f5b0990cc98	2022-04-01 22:34:24.134747+00	https://drive.google.com/file/d/1p5lRNjDmczPsYpIUWJwTUO2SGFzkC8jR/view?usp=sharing	ACTLIKEUKNOW	{FLIP,SOULECTION,VIBE,GOSPEL,SOUL}	0	\N	0x24e48db6d94f5dF5524Ae428a2f12F0f2b3Ad48c	\N	BIG COZY	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a19dafe6-95f3-4eeb-919a-49d2f5c8bc3a	2022-04-02 21:11:31.393211+00	https://audiomack.com/song/swaderaps/17755919?key=first	Ragnarok	\N	0	\N	0xCd930261704f384DC53F8691f0cBF961355293f8	\N	Southpaw Swade	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0f5fccea-96d6-4539-a1fd-296681096562	2022-04-08 16:57:41.31132+00	https://music.apple.com/us/album/free-spirit/1523264285?i=1523264527	Free Spirit	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	King Kavon	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
dcdc20b1-1206-4869-804a-ffbdf9713547	2022-04-23 23:13:06.1626+00	https://youtu.be/VJ8wK8Z-g4o	Faze	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	IMVN	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d496b642-2259-48bf-a7d5-78ebfad703ed	2022-09-09 19:05:06.098247+00	https://youtu.be/RhurWuExlHQ	Good Luv'n	{Makintsmind,"RnB Gems"}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	BJ The Chicago Kid 	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
660f52ef-31a4-464e-a739-e0df677cd676	2022-04-01 15:51:36.546504+00	https://www.youtube.com/watch?v=XVMUafRHfqE	The Money ($$$)	{"theodore grams",philly,philadelphia,"trap music","the money",$$$,phraternity,"the waas foundation",phrat,"major heist",dogtown,badlandz,dth,pos,pmg,fhn,gmb}	1	\N	0xfb3197Bd5b7F2E39c1e89B7619A697827eD2deff	\N	Theodore Grams	\N	\N	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
25ce6bd4-bc3a-484e-a31f-8e9e73293fa8	2022-08-16 19:21:16.581216+00	https://open.spotify.com/track/0n6UWYseeIt9AAEgG4gZbA?si=uXV0mCaRTxGq9INwBkx30A	Birkin ft. J305 & Maine Bands	{"Marley Woo","Hip Hop"}	0	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Marley Woo	\N	discoveringEs	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8321d7e8-8394-45bc-ae18-81ee5e568362	2022-05-02 19:32:44.864672+00	https://youtu.be/kkoSOeel9yE	Top Down	\N	3	\N	0x00daEbab128f5CFc805D75324c20c6fEaf6B26b2	\N	Jayson Cash	\N	Sirjwheeler	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d034dfa2-51a9-491c-984c-9566636b088e	2022-08-24 14:01:45.082952+00	https://twitter.com/natenumbereight/status/1561605542979706881?s=21&t=jRufc1lIV4gg-O5LlUnfCw	RacistRobotDiss.MP4	{freestyle}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	NateNumberEight	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
91bce08b-a5b6-4bef-bbab-817b81f2cb49	2022-10-22 20:24:11.222025+00	https://www.youtube.com/watch?v=py8OTOhyjXk	Jesus Shuttlesworth	{giannis}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	BabyTron	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
102dfcba-d566-4164-b4a5-a2eee5c1431c	2022-04-01 16:42:14.035126+00	https://www.youtube.com/watch?v=467CXPjXEV8	Expand	{"Herb Sims","Harry Fraud","Surf School","Srf Schl",Sharks,Wavy,"Free Max B"}	1	\N	0xfb3197Bd5b7F2E39c1e89B7619A697827eD2deff	\N	Herb Sims	\N	\N	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e5a4942f-45a7-4db0-b0f0-b2733b512708	2022-05-02 16:18:35.719145+00	https://opensea.io/assets/0x3a1058358dce3d313f94503f362814da0fe24a2b/1	DISTINCT RENDERED MOMENT	{immersive,gaming,snapshot,generative}	5	\N	0xD3055381ce349b4cB7116A0b3FAb762c3f16FA45	\N	cici	\N	\N	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x67A276b6768978C9E41Af5418E09Efc8a12a28dE,0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01,0xAc801951867c4fE73bEeAe4961A6557FfdC83bfF}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e1c8d2d4-b90f-4526-b33a-b4337131bb54	2022-05-07 00:52:53.57018+00	https://www.mintsongs.com/songs/7460	Wave (WOFTW)	{"Stay Hydrated Playa",StayHydratedPlaya,WooWednesday,"GRAND WOO",VibeWitMeLike,WatchOutForTheWave}	0	\N	0x0c4076f4A49236adE7D21ede9e551C229FCf492d	\N	GRAND WOO	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
800a83b5-81f7-413d-9d90-e3b50183f6a8	2022-11-09 00:57:34.439472+00	https://www.youtube.com/watch?v=24FeICza44U	OBSESSED WITH YOU	{CENTRALCEE,BLOAK,LALEAKERS,PISSED,ENDS,TOPBOY,GOODFOOD,HITYOUINTHEHEARTSTRINGS,MRLONELYVOICE,IMDIFFERENT,STANDARDSHIGH}	0	\N	0x8d5fb8aca8294fc9a701408494288d2d7de42f7e	\N	CENTRAL CEE	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0ac5672c-a883-48e5-bb7c-9b9dfa214c66	2022-05-02 00:36:29.682884+00	https://open.spotify.com/track/18oCxryQugk5Gz9Y24ijha?si=f74672dd8e58423c	Picasso	\N	2	\N	0x67A276b6768978C9E41Af5418E09Efc8a12a28dE	\N	Tanna Leone	\N	\N	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a4df2a1c-69c1-4c38-a4a8-b301bef82130	2022-09-06 20:40:37.690644+00	https://www.youtube.com/watch?v=zprtmXMhoOk	I feel Fantastic	\N	1	\N	0x20805EE724EA3CAAbA5D9F2fd95E18ae756802E0	\N	Riovas	\N	hbkj0sh	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
fa6a2f16-191d-4d2f-9c76-edc3ae2f9956	2022-04-04 21:39:09.075662+00	https://audiomack.com/song/swaderaps/23goat?key=tiebreaker	23 (Beat 1)	\N	0	\N	0xCd930261704f384DC53F8691f0cBF961355293f8	\N	Southpaw Swade	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
92f66638-afe2-483b-ad45-537e0bd9b19c	2022-04-04 21:41:29.839121+00	https://audiomack.com/song/swaderaps/17782547?key=tiebreak	Seen it all (tie breaker)	\N	0	\N	0xCd930261704f384DC53F8691f0cBF961355293f8	\N	Southpaw Swade	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0cb1fa22-7612-4106-a930-0fc160c53a4f	2022-04-05 21:08:18.144027+00	https://soundcloud.com/squired/burn	Burn	{Trap,"Future Bass",Electronic}	0	\N	0x41DA01eBfeAF7091780BaB72A91D4aCa85a6DDe7	\N	Squired	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8ddd27c2-3a46-4b2f-a9b1-25c2311ced0a	2022-04-18 08:13:54.347822+00	https://zora.co/collections/zora/10121	Envy	\N	0	\N	0xab5c2Cf4097928Add69b5F5C1B78B031966da696	\N	Rasstutu	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
80d6cb65-cd5a-4226-ba8c-ad0204ef0608	2022-04-23 23:14:28.060973+00	https://youtu.be/iWnBaZNCJUg	Makavelli	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Kolo	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
06305cd0-5255-40e2-be6d-79a740bc2a37	2022-04-27 19:05:18.246662+00	https://pvinerecords.bandcamp.com/album/budasport	BudaSport	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Jansport J, Budamonk	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c9e53453-1b05-4547-ae9a-1b5156e7128e	2022-04-29 18:38:24.836682+00	https://youtu.be/YqsWJjUUDaY	650	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	OMB Peezy	\N	hallway	{0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
95d75616-b077-44fd-b823-302d3738e8ee	2022-04-30 20:37:23.535454+00	https://unexplainedaerialphenomenon.bandcamp.com/album/casual-abductions	Casual Abductions	{"POW Recordings",🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Unexplained Aerial Phenomenan	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
057ca99c-6a34-4cd2-897e-2e335ea0599d	2022-04-15 14:29:44.204961+00	https://soundcloud.com/hokagesimon/albuterol-v2?in=aj-washington-528604433/sets/phlote-tcr-1&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	Albuterol	\N	0	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Hokage Simon	\N	Ghostflow	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
038b5405-ede5-4e92-bb82-6627e6676318	2022-04-15 14:31:34.415826+00	https://soundcloud.com/comfychinz/chalet	Chalet (prod. F1)	{🏴‍☠️}	0	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Chinz	\N	Ghostflow	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b2cf2203-fa16-4c53-934a-e40fbc4615c0	2022-05-01 08:36:33.583905+00	https://beta.catalog.works/blackdave/middlemen-feat-monday-rome-fortune-	Middlemen	\N	2	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Black Dave  (feat. Monday! & Rome Fortune)	\N	Trish	{0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a653ae24-6af5-44e6-9583-9a62bb0fe27b	2022-04-23 08:33:27.019153+00	https://beta.catalog.works/digital/first-mint	FiRST MiNT	\N	0	\N	0x9bc9A0eb9FAFe9014ddC6Ab1A3Cd661F585a5641	\N	DiGiTAL	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4b4bf799-3bc6-424a-b3fd-9d43e2549035	2022-04-11 22:44:56.64808+00	https://beta.catalog.works/tracks/9d88165b-8178-4d78-a329-e2b2f6c626cc	Reflejo	\N	1	\N	0x0e35B828026F010A291C1DC0939427b2963D8d5a	\N	Kasbeel	\N	\N	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
427fa9ee-029b-44b2-b59d-f0dc1d141b99	2022-04-13 00:11:03.590076+00	https://youtu.be/p7wXSpGTPXs	Orca Waters	\N	2	\N	0x42ACfC0Da38899168Dd4F9A66a5c8228cbbeFEB1	\N	Noa James	\N	OrcaMane	{0x2d9c9c342E892191B6c0DEFC0C85b1f00E2763a7,0x5ab45FB874701d910140e58EA62518566709c408}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
95cb5a26-69e7-48a9-80db-bf5a4841975b	2022-04-11 22:47:38.0009+00	https://glass.xyz/v/I6nn8lNZjPOLhu2Np9dtaKoYOgSZQn-tkcNLrtQyrWY=	Yo Soy Dios	\N	1	\N	0x0e35B828026F010A291C1DC0939427b2963D8d5a	\N	Kasbeel	\N	\N	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3713196f-4b5c-450b-b927-14ea6ea0f415	2022-08-16 19:31:41.755024+00	https://soundcloud.com/jonreyessound/kehlani-everything-jon-reyes-findaway-blend?si=b3ef3d3e9935436685a1cc10bf32f739&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	Everything (Jon Reyes Findaway Blend)	{Kehlani,"Jon Reyes",Production}	1	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Kehlani, Jon Reyes	\N	discoveringEs	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
27ee960f-8d63-4d61-a357-b0e234d8bec1	2022-05-05 21:39:48.331117+00	https://soundcloud.com/whytri/pitch-perf-ft-og-maco	PITCH PERF FT OG MACO	\N	3	\N	0x5013f00ECe420E380Cb276c0Bdc9ab96063FFB85	\N	WHYTRI	\N	\N	{0x67A276b6768978C9E41Af5418E09Efc8a12a28dE,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
87342cce-b1d9-44a7-9e80-a552ad21a893	2022-04-23 08:35:08.270647+00	https://beta.catalog.works/willjuergens/i-need-a-job	I NEED A JOB	\N	0	\N	0x9bc9A0eb9FAFe9014ddC6Ab1A3Cd661F585a5641	\N	Will Juergens	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d4271f7a-8bc3-43ea-ae7e-3f159e0961b7	2022-04-19 02:14:19.960568+00	https://soundcloud.com/championxiii/swipe?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	SWIPE	\N	2	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	Championxiii	\N	lifeofclaude	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6a1bd03c-c349-4c75-8162-1d0a1fb2ac34	2022-05-07 19:38:28.067931+00	https://soundcloud.com/mrchowincali/hott-headzz-hmmm-x-cocomelon	Hmmm	{"tik tok",remix,"children's show theme song sample"}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Hott Headzz	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
5b20d560-13c8-45bd-82d8-4992b1111d1c	2022-03-22 23:43:53+00	https://open.spotify.com/track/6RIaV8JuEfDxDrAJepGpmX?si=ebaaa8bc9ec24979	DripSkylark	{🏴‍☠️}	1	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	ThatsHymn	\N	Ghostflow	{0x67A276b6768978C9E41Af5418E09Efc8a12a28dE}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
5f0bc128-6c0a-469f-a1d9-79e086c64a82	2022-04-17 00:18:53.933958+00	https://youtu.be/lz7hsXgHmzg	Protein	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Jeshi,Obongjayar	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e602a0b0-d613-4283-8c52-92c81bb707e2	2022-04-30 21:03:40.576699+00	https://youtu.be/h18A6rM2SAk	Ballad of a Straw Man	{🔦,Country}	2	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Los Colognes	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
fd48ff52-fbf8-4b25-ad0e-d23785a59ef3	2022-04-23 22:42:51.535986+00	https://kellymoonstone.bandcamp.com/track/just-another-day-ft-mavi-prod-ovrkast	Just Another Day	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Kelly Moonstone, Mavi	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
5e24cb2f-c88a-4b8f-862e-813aa3b37587	2022-04-23 23:19:43.525499+00	https://youtu.be/UsJ4MV98YLA	Dandelions	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Mwanje	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b6e599e5-7732-4ad4-828d-ee160ec312df	2022-03-25 02:47:17+00	https://beta.catalog.works/twerlbeats/with-me	With Me	{🏴‍☠️,"Electronic Music",Cool}	1	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Twerl	\N	Ghostflow	{0xb077473009E7e013B0Fa68af63E96773E0A5D6A4}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
fc25c50c-a57b-4873-afde-f68466ddcba0	2022-05-02 22:34:41.624866+00	https://www.youtube.com/watch?v=FyodeHtVvkA	Queen's Speech Ep.4	\N	1	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Lady Leshurr 	\N	Trish	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1c85e5c0-bfd0-4809-8889-9f6cdac60f2d	2022-05-02 22:32:28.044644+00	https://youtu.be/yiQ7S38nKog	11977	\N	3	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Ana Tijoux	\N	Trish	{0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f004d31f-2791-4809-af8d-09775418aec1	2022-10-23 02:41:16.555579+00	https://www.youtube.com/watch?v=nYmd5TRBKlI	I Dont Text Back ft. Yeat	{"ma i got a family"}	3	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	NBA Youngboy	\N	future modern	{0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47,0x0bbac2bd3134a318deb31137d87d42bf54325cb7,0xf75779719f72f480e57b1ab06a729af2d051b1cd}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
69e0a860-c049-4438-886f-71a0ee59f882	2022-10-23 02:42:47.698014+00	https://www.youtube.com/watch?v=ciiodtemqw8	Ruth's Chris freestyle	\N	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Remble & Drakeo the Ruler	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0eb4b3ba-19d6-41c3-9107-c13f1301dd03	2022-04-06 13:53:22.95522+00	https://opensea.io/assets/0x495f947276749ce646f68ac8c248420045cb7b5e/84549849779218619917561934107115343944433194372086458083457436785950637162497/	Receiver	{"VIsual Art",🏴‍☠️}	0	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Florian Adolph	\N	Ghostflow	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
13b733fd-86e2-4b52-80a2-05ca4049d237	2022-04-16 11:26:44.102167+00	https://beta.catalog.works/afta1/opaline	Opaline 	\N	1	\N	0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47	\N	Afta 1	\N	Lil Josh	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b7d7831b-0126-457d-ab41-146aa340e04c	2022-05-04 03:01:32.69974+00	https://objkt.com/asset/KT1G3EJXcdeWP752cTbN6PJPyJau1TCbUXT6/5	Beatboy 005	{Beat,Production,Synth,Chillwave,Spacefunk,madkapp,Tezos,objkt}	0	\N	0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74	\N	madkapp	\N	singnasty	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
446e64e3-5cad-43b6-a7cf-e3c5c4cd8e68	2022-05-05 21:41:27.846619+00	https://soundcloud.com/whytri/spirit-cook-ultimate-ft-cult-prod-cult-kai?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	SPIRIT COOK ULT!	\N	0	\N	0x5013f00ECe420E380Cb276c0Bdc9ab96063FFB85	\N	WHYTRI	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
5bc3f71e-7ad7-4e89-9b02-937c860dac8a	2022-03-22 19:21:27+00	https://beta.catalog.works/glasstempo/here-since	Here Since	{}	2	\N	0x7d1f0b6556f19132e545717C6422e8AB004A5B7c	\N	Glasstempo	\N	Anderjaska2.1	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
009abe63-133a-47a4-a624-18ba8d215697	2022-10-31 17:38:07.848956+00	https://www.youtube.com/watch?v=bVv_rz1FYvY	Somebody	{🏴‍☠️}	3	\N	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	Cosima	\N	\N	{0xa52b442bfeca885d7de4f74971337f6cf4e86f3b,0x0bbac2bd3134a318deb31137d87d42bf54325cb7,0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d0da5115-7c26-4cf4-9a6c-1997799968b5	2022-05-04 15:59:22.909103+00	https://www.youtube.com/watch?v=oNt817cvqkg	GOD COMPLEX	{Rap,Hip-Hop,MusicVideo,DMV,DC,Chop,ChrisAllen}	3	\N	0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74	\N	Chris Allen	\N	singnasty	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
678f7ae4-4862-48c5-8b26-68b1ac99c15d	2022-11-09 01:05:56.889644+00	https://www.youtube.com/watch?v=BGmnVEtD4BQ	 EVERYWHEREIGO (PROD. GAWD)	{🏴‍☠️}	0	\N	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	BABYXSOSA	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
00285538-e69b-42c6-823b-8cbd3379cb53	2022-04-01 23:02:56.221387+00	https://audiomack.com/song/swaderaps/17733201?key=round2	S on Chest	\N	1	\N	0xCd930261704f384DC53F8691f0cBF961355293f8	\N	Southpaw Swade	\N	\N	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
880583ac-0c0a-4ead-9c69-28b5b4ed64e2	2022-04-15 14:27:57.344436+00	https://soundcloud.com/user-645014960/how-does-it-feel?in=aj-washington-528604433/sets/phlote-tcr-1&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	How Does It Feel	{🏴‍☠️}	1	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Vague Detail	\N	Ghostflow	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
77093936-be31-43cf-a275-ecabc90c0603	2022-05-05 07:41:02.860195+00	https://open.spotify.com/track/5U5TRUkP8P2di7yZ8pVSPf?si=ca1673acdd1c44c2	The Answer	\N	0	\N	0xdCA9184F72BCC0838fbCBae7A46a86D9d4A52b63	\N	UNKLE	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
913120bc-14f6-4228-962e-48fe20a61d77	2022-04-02 21:12:33.73154+00	https://audiomack.com/song/swaderaps/17755922?key=tiebreaker	Tie breaker	\N	1	\N	0xCd930261704f384DC53F8691f0cBF961355293f8	\N	Southpaw Swade	\N	\N	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7833fa5d-979f-4d30-85f8-aab8f5c31ee7	2022-04-02 21:13:54.353946+00	https://audiomack.com/song/swaderaps/17733201?key=round2	S on chest (second beat)	\N	1	\N	0xCd930261704f384DC53F8691f0cBF961355293f8	\N	Southpaw Swade	\N	\N	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
70dcdea3-b75c-4f9d-b2bd-8d9a309da80d	2022-04-04 21:34:54.570433+00	https://audiomack.com/song/swaderaps/17782504?key=phlotefinal	Benediction (Beat 2)	\N	1	\N	0xCd930261704f384DC53F8691f0cBF961355293f8	\N	Southpaw Swade	\N	\N	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
95fa934a-e861-46b5-9672-083897db39f9	2022-04-04 21:36:43.461778+00	https://audiomack.com/song/swaderaps/17782504?key=benediction	Benediction (Use this one)	\N	1	\N	0xCd930261704f384DC53F8691f0cBF961355293f8	\N	Southpaw Swade	\N	\N	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
9cdaf2a3-d46b-4668-9a20-cb8b5460c784	2022-05-08 19:23:15.026002+00	https://soundcloud.com/bladee1000/drama-feat-charli-xcx	Drama ft. Charli XCX	{draingang,emo}	1	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Bladee	\N	future modern	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0a6cb393-dbf3-4d3e-bc36-ae03e176ef20	2022-05-02 18:13:05.117762+00	https://soundcloud.com/omarapollo/tamagotchi	Tamagotchi	{"latin trap",latin,latinx,"latin rap","latin r&b","south america","latin funk"}	1	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	omar apollo	\N	lifeofclaude	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
5407db2c-3784-4b87-9df2-6565a49ca3cc	2022-05-05 06:45:57.288871+00	https://open.spotify.com/album/3bAcBKKlhb20HD1wHSUTn6	It is What It Is	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	NOVA	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
754d65a7-4a2e-4bc9-994a-eb688290f440	2022-04-23 22:45:34.530685+00	https://soundcloud.com/user-53290812/ghost-phone-006-soundcloud	Ghost Phone 06	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Ghost Phone	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
5f874e73-ca0f-47f0-a469-7de6cfc0ea88	2022-04-23 08:35:57.339029+00	https://beta.catalog.works/maiworld/pi	Pi	\N	1	\N	0x9bc9A0eb9FAFe9014ddC6Ab1A3Cd661F585a5641	\N	MAi	\N	\N	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
44f94960-d1f1-4b9a-a6a8-db06e3d825eb	2022-08-17 17:11:25.078942+00	https://www.youtube.com/watch?v=LwIhpG-ccfo	They Don't Wanna Know	\N	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Nnamdi x Morimoto x Rich Jones x JD	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
77b2af8f-0d97-465e-95a8-0d8778cb9c21	2022-05-02 19:35:29.241447+00	https://youtu.be/1nLnR8yK_BA	Mopstick	\N	3	\N	0x00daEbab128f5CFc805D75324c20c6fEaf6B26b2	\N	French Montana ft. Kodak Black	\N	Sirjwheeler	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7da6cb25-ed78-41d8-89c3-86c91b00b0f3	2022-05-02 19:27:18.615353+00	https://music.apple.com/us/album/sleepy-soldier/1619517495	Sleepy Soldier	\N	3	\N	0x00daEbab128f5CFc805D75324c20c6fEaf6B26b2	\N	Tanna Leone	\N	Sirjwheeler	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2f4dd206-1a36-4fea-9ccc-740bab987412	2022-05-05 21:42:33.611686+00	https://www.youtube.com/watch?v=1Sgc_BQY8vg	A HERO'S REVENGE!	\N	0	\N	0x5013f00ECe420E380Cb276c0Bdc9ab96063FFB85	\N	WHYTRI	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
35520cee-8f99-45e2-baa9-38ca0cc7dceb	2022-10-26 19:40:15.558427+00	https://youtu.be/qWUNVC8YKxw	Secret	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Loota, Brodinski, Modulaw	\N	hallway	{0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
dfea84a5-38ee-4c5d-bc31-23366b87b427	2022-10-23 02:46:08.817803+00	https://soundcloud.com/cousinstizz/vendetta	Vendetta	{boston}	3	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Cousin Stizz	\N	future modern	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0xef58304e292fbaeacfdec25b67b3438031fde313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f6c9ab6e-bfa2-4acb-a21b-92a965619a47	2022-04-29 18:45:11.753642+00	https://www.mach-hommy.com/listen	Dump Gawd	{🔦}	3	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Mach-Hommy	\N	hallway	{0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b8315840-cbfc-47d8-9bea-d6bf1d7975d1	2022-11-09 00:59:28.983678+00	https://www.youtube.com/watch?v=ENqz_KHdnx0	ENVIE	{MAGICWAND,AFRIKANFOLKMUSICFROMOUTTHEDIASPORA,MEGATRON,SADHU,COÑO,PURO,BEASTLIKELEVIATHAN,ALDIVINO,OYEMIJO,CUARENTA,BLANQUITO,EROSE2THEOCCASION}	3	\N	0x8d5fb8aca8294fc9a701408494288d2d7de42f7e	\N	ESTEE NACK	\N	\N	{0xef58304e292fbaeacfdec25b67b3438031fde313,0x0bbac2bd3134a318deb31137d87d42bf54325cb7,0xf75779719f72f480e57b1ab06a729af2d051b1cd}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
09e25a93-1b58-4e6b-aeef-a81cd514f9f2	2022-04-23 15:51:17.943871+00	https://soundcloud.com/tuki-carter/daytrip?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	Daytrip	\N	1	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	Tuki Carter	\N	lifeofclaude	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ccd8a7a5-2b58-4f02-a62a-f09918792aae	2022-05-04 16:38:06.43904+00	https://beta.catalog.works/marcy/dip-like-crypto-mfk-nftmix-	Dip Like Crypto (MFK NFTmix)	{goth,experimental,"sound art","crypto rap",memetic}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Marcy Mane	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
981e0d58-50a7-4158-b90a-2211f3d56c00	2022-05-09 15:27:18.033623+00	https://www.youtube.com/watch?v=5V0DJDVhh4s	I Wanna	{"uk drill",cgm,"west london"}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Rack5	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
eb31b108-da25-4eb1-8836-e7bc5e123b5f	2022-05-02 18:15:40.669482+00	https://soundcloud.com/skinny/i-dont-give-a	I Don't Give A... feat. Woopty Woop (Remix)	{trap,"head knocker",rage,"middle eastern trap","arabic trap","go off","dance like no one is watching",headbanger,"head banger",rap}	0	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	$kinny	\N	lifeofclaude	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
00c84f3b-41db-49b1-881b-8c0c00590329	2022-05-11 19:06:08.578569+00	https://www.youtube.com/watch?v=4CBbxH-Vm_s	Soul Brother 🔥🔥🔥	{🏴‍☠️,"hot fire"}	2	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Dalton	\N	Ghostflow	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d41705ee-cdf3-46b1-b48d-deedd87fbf8e	2022-04-28 23:29:16.161534+00	https://www.youtube.com/watch?v=CyZEOmrsxZE	Pull Up (ft ThaHomey)	\N	3	\N	0x8C62dD796e13aD389aD0bfDA44BB231D317Ef6C6	\N	Sadandsolo	\N	Mighty33	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ec17fb4e-067d-4122-aa83-9853108e2164	2022-04-27 19:07:58.91234+00	https://soundcloud.com/sammhenshaw/sets/untidy-soul-1	Untidy Soul	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Sam Henshaw	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
32f25c37-b0d4-49c0-a272-da6ba867c44b	2022-04-23 23:24:53.021323+00	https://youtu.be/0LNBEfJJ8L8	Flares	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Renao	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c7721624-d864-4fbf-b71a-0b55e27c2555	2022-04-19 17:01:34.670898+00	https://soundcloud.com/36birds/boy-2	Boy	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	36BIRDS!	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2d651ec0-1213-4c4b-8949-ebc0dc807acc	2022-04-30 18:45:00.649615+00	https://youtu.be/mzqWUeMOB-I	Shopping Spree	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Vintage Lee	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b9464d5a-e1ef-4f2e-82df-f2ed44ba884f	2022-05-01 06:06:02.622643+00	https://open.spotify.com/track/0ItD5cgfl9jvzVTOlehFxd?si=fea70198692844b4	Record Collection	\N	0	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Kaiser Chiefs	\N	Trish	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
5ef9647a-7df2-4ea1-b8a6-0b3c0e862514	2022-05-03 01:27:02.199759+00	https://www.youtube.com/watch?app=desktop&v=8UPJ1XQGDEM&t=769s	at Prom Kultury, Warsaw	{"experimental jazz"}	1	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Sunjae Lee	\N	Trish	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e8de227d-4916-4ded-b5cf-d2f65190f85a	2022-04-30 13:17:17.822987+00	https://www.mintsongs.com/songs/4003	Intuition	\N	1	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Jazii	\N	Trish	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7ba80bdf-2995-449a-8064-0b031408775a	2022-05-04 18:11:27.027057+00	https://www.youtube.com/watch?v=CX1zR_9L3oU	Write A Book	{"OT7 quanny",Philly,"North Philly","Philadelphia Sound"}	0	\N	0xfb3197Bd5b7F2E39c1e89B7619A697827eD2deff	\N	OT7 Quanny	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
af455101-fb45-4baf-bb37-b74b1fec53c4	2022-03-03 19:11:47+00	https://opensea.io/assets/0x495f947276749ce646f68ac8c248420045cb7b5e/99622953244818026254113051866109607344065368007310529797675903761884014182430	HOOD MOVIES Vol1 - Boyz N The Hood "THINK" 7/10 SE	{}	2	\N	0x1ce9200E1547F8bfb3EFa961FF0b8F88356Ccae2	\N	Tomall	\N	UncleMikey3.0	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0181fb39-3e31-45eb-b5ae-06c9dd86ebbc	2022-05-05 07:42:27.955771+00	https://open.spotify.com/track/6p8Q7wi1ke7v3ospD1YAVO?si=5e951cace8074d20	Be Together	\N	1	\N	0xdCA9184F72BCC0838fbCBae7A46a86D9d4A52b63	\N	BCBC	\N	\N	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
fcbfc068-f94a-481a-ba77-0ab40931603a	2022-05-01 06:28:15.433436+00	https://opensea.io/collection/white-cat-3	White Cat	{humor,illustration}	0	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Simple Cat	\N	Trish	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
95040b86-9678-462a-a0d6-26c31069e1f9	2022-10-19 17:47:24.527833+00	https://youtu.be/_IuAIp46xC4	Father Time (Live on SNL)	{Live}	3	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Kendrick Lamar, Sampha	\N	hallway	{0x52fA05393a003d234eFBA136E68DA835aeB64a26,0x371107cc397A1fd11FD5A7aC8421a3E43F886444,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c53c9f46-d942-4dc1-80fc-b51bbef4d8de	2022-10-07 13:10:22.093037+00	https://open.spotify.com/track/6mM8gri8d2abYYomjOV4ut?si=1692ae8fff064fe9	Stop Breathing	\N	3	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Roddy Rich	\N	MakintsMind	{0x52fA05393a003d234eFBA136E68DA835aeB64a26,0x0bbac2bd3134a318deb31137d87d42bf54325cb7,0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f0ee1633-e5b7-4419-9386-7bdd66dabae4	2022-03-30 01:59:41+00	https://audiomack.com/song/swaderaps/17700507?key=phlote	Fences	{}	1	\N	0xCd930261704f384DC53F8691f0cBF961355293f8	\N	Southpaw Swade	\N	\N	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2de28258-1658-47ea-b2c5-cf0bbf1ce6b5	2022-04-01 22:11:11.129232+00	https://drive.google.com/file/d/1cCLpRH5wfm4uaZUuvFzbwhSzh-em4LRu/view?usp=sharing	Maldives	\N	1	\N	0x0E0624A2E88E0Dc9B56f9c9Ce2D6907eDd2B8FdF	\N	Ricky Felix	\N	\N	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a69656ad-8b6f-4984-8087-a808efb231f5	2022-04-01 22:11:50.865369+00	https://drive.google.com/file/d/1FYRYGzjsAlsMZd43ERLrO0n5tAxePYqv/view?usp=sharing	In Line	\N	1	\N	0x0E0624A2E88E0Dc9B56f9c9Ce2D6907eDd2B8FdF	\N	Ricky Felix	\N	\N	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
37265b6d-9a6e-4a25-ba9c-441c81c9e317	2022-04-01 22:16:38.16802+00	https://audiomack.com/swaderaps/song/me-lord	Me Lord	\N	1	\N	0xCd930261704f384DC53F8691f0cBF961355293f8	\N	Southpaw Swade	\N	\N	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
88fb3f4c-aa53-431d-b978-460d5dccf91c	2022-04-01 22:35:32.039296+00	https://audiomack.com/swaderaps/song/17700528	Neon Eon	\N	1	\N	0xCd930261704f384DC53F8691f0cBF961355293f8	\N	Southpaw Swade	\N	\N	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
92d5f531-a133-45ec-8320-282b5db4add4	2022-04-05 23:45:36.343073+00	https://open.spotify.com/track/2NlFb4Y60ww5xGvDoezSdo	Writing in the Room	{rap,hiphop,london,uk}	2	\N	0xC5F904512E22dA5C5fd86499449fE9bA85205233	\N	𝘙𝘌𝘝𝘌𝘈𝘓	\N	\N	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d75c5b03-eeb6-438d-8ca4-e60901d85795	2022-04-12 18:04:33.980887+00	https://www.youtube.com/watch?v=hAF_sLpNTqo	soft plans v1	{psychedelic,tijuana,mexican}	1	\N	0x2d9c9c342E892191B6c0DEFC0C85b1f00E2763a7	\N	alan lili	\N	\N	{0x0c4076f4A49236adE7D21ede9e551C229FCf492d}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
18d62db2-dfb2-436d-ab81-2199f05656d4	2022-04-12 18:07:03.874606+00	https://soundcloud.com/tulengua/almarea-tulengua-unreleased/s-ppLNnw1QL6R?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	almarea	{tijuana,mexico,"hip hop","dr. dre","latin pop"}	1	\N	0x2d9c9c342E892191B6c0DEFC0C85b1f00E2763a7	\N	tulengua	\N	\N	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
82c3313c-2e41-4631-8d73-91fc523cb122	2022-04-28 23:30:38.397386+00	https://geniuscorp.fr/mighty33	Discography	\N	0	\N	0x8C62dD796e13aD389aD0bfDA44BB231D317Ef6C6	\N	Mighty33	\N	Mighty33	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
568081d5-a2c1-4736-bcf3-bdd5b0caefa0	2022-05-02 18:18:36.582788+00	https://soundcloud.com/almondmilkhunni/grapefruit-remix-feat-dounia	Grapefruit (Remix) Feat. Dounia	{r&b,baddie,"almond milk hunni","she valid","dance music",twerk,"twerk music","easy listen","underground pop","underground r&b",rnb}	1	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	Almondmilkhunni	\N	lifeofclaude	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7682d41e-8d1c-41b5-b6fe-acb00f228cef	2022-05-04 13:28:50.346434+00	https://youtu.be/g2hj3_lMbxA	Hit	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Kenny Mason	\N	hallway	{0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a03ffded-a2f2-464b-b93f-81c67c808d0d	2022-05-06 04:19:10.610368+00	https://open.spotify.com/album/6UmfEHtydzXRmrzpypt67j?si=H2-qYyu3TBCP1o7Qtx2ktA	Foul Play	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Sham1016	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
94ae6b1e-29ac-472b-b26b-7ce93666a4be	2022-05-07 20:33:08.092128+00	https://youtu.be/buCkL0KLKFw	Star	{🔦,Diemon}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Russ	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
48ecf6b2-4103-49ce-9d07-64aeb889234e	2022-04-08 17:11:04.06546+00	https://m.youtube.com/watch?v=ae3nMLWJlD0	Shining	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Yathegod, Jhevere	\N	hallway	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3663d106-9a31-47fe-a1d8-5b1a52daf40d	2022-05-01 20:41:37.409371+00	https://zora.co/collections/zora/8118	OH!	\N	1	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Carla the Poet	\N	Trish	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
33782d42-410c-4b67-a11c-ad250b3dda42	2022-08-17 17:42:47.606803+00	https://open.spotify.com/track/6EMJKZxejykO2nGfOxggEF?si=7l9hfa2XQkybzuO75pWNuw	let it fly	{🏴‍☠️}	0	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Veeze	\N	Ghostflow	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
76ba5675-e839-4a46-8c63-2c2aecdae54f	2022-05-03 17:45:30.923586+00	https://open.spotify.com/track/0tr5LQ6R0YiksxgRR90tnp?si=86e7a737696c40d6	Paranoiac	\N	1	\N	0x67A276b6768978C9E41Af5418E09Efc8a12a28dE	\N	Boring Lauren	\N	ODENZ	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
03ba5b53-8dab-46f5-816c-909904d134c2	2022-04-09 21:10:42.308061+00	https://glass.xyz/v/QP8iboGBk49lrEM3U7epqrO15mnGBe-J6QoKawaNHKw=	Don't Listen to Me	{MusicVideo,Maeko,Glass,PartyBid}	2	\N	0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74	\N	Maeko	\N	singnasty	{0x2d9c9c342E892191B6c0DEFC0C85b1f00E2763a7,0x67A276b6768978C9E41Af5418E09Efc8a12a28dE}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
9299daf0-f179-4234-bc7e-6f01601e2e4d	2022-08-17 17:45:13.170352+00	https://open.spotify.com/track/4ZiAnGIZFFUybp0NZXIYEG?si=48616e81e23941f7	Upside Down	\N	0	\N	0xfFba44c15Fe2768bC2234078dfac8c5A651A56e9	\N	The Story So Far	\N	AcidPunk	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a4b57942-6262-4059-8c7f-17539dde7c1b	2022-03-11 14:54:30+00	https://beta.catalog.works/tracks/8eaaf850-1f0a-4be8-b312-66f116316510	Aliens Exist	{"Saint Lyor",VanBuren,ODENZ}	3	\N	0x67A276b6768978C9E41Af5418E09Efc8a12a28dE	\N	Saint Lyor	\N	ODENZ	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xb077473009E7e013B0Fa68af63E96773E0A5D6A4,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
5131c989-8ade-4770-8745-04255f1df5c3	2022-04-29 15:04:30.337782+00	https://soundcloud.com/xchrispatrick/gang-activity-full	Gang Activity	\N	3	\N	0x67A276b6768978C9E41Af5418E09Efc8a12a28dE	\N	Chris Patrick	\N	ODENZ	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4d68d9d7-ded4-4fed-98e4-d9d2e80f98cd	2022-10-23 13:26:57.269997+00	https://youtu.be/tUk8BdDRmx4	Street Cred	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Jeezy, DJ Drama	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
64d79240-b7dd-424a-a3d9-39ee9dbe365e	2022-04-24 21:31:52.445486+00	https://soundcloud.com/officialvuko/let-it-breathe-prod-vuko-x	LET IT BREATHE	{VUKO}	0	\N	0x9921B926788E91Aa9db885c214Db5FEe8943b771	\N	VUKO	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
dfc36dea-09b8-4fbd-9d22-0d1b1a78f7c3	2022-10-07 18:13:15.366759+00	https://www.youtube.com/watch?v=DJOq3-Mvd4Y&list=PLZj0f97NF3V7fpn6RYJNP-eNkxyc6dyyO&index=6	CHAOS NOW* (Shorts)	{"Bradley J Calder"}	2	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Jean Dawson	\N	hallway	{0x52fA05393a003d234eFBA136E68DA835aeB64a26,0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
066e5599-d455-4ece-b5aa-4ca4f4391e3d	2022-11-09 01:23:06.151873+00	https://www.youtube.com/watch?v=WjVaRSRmG98	CITATION	{🏴‍☠️}	0	\N	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	 BOOTYCHAAAIN	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a645fe77-be6f-4bfd-88e4-f1c05d4f59ef	2022-03-30 20:50:53+00	https://soundcloud.com/afkmaxxx/2a-1/s-sgbwTAdCTEK?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	(Beat Battle 1/2) Maxxx	{}	0	\N	0x65FAc90a3479D9D8591c819BCa40085457BF8F25	\N	MAXXX	\N	afkMAXXX	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
35e403b6-228e-4546-9bb9-4218bc297d5f	2022-03-30 20:51:23+00	https://soundcloud.com/afkmaxxx/chainsmokers-flip-110bpm-prod/s-NJCxfHqGqZ7?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	(Beat Battle 2/2)	{}	0	\N	0x65FAc90a3479D9D8591c819BCa40085457BF8F25	\N	MAXXX	\N	afkMAXXX	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
81781e0c-97bd-4765-8017-ae5f0806cab5	2022-03-30 20:55:23+00	https://www.dropbox.com/s/lhzzsombqnpxdsj/2.%20Asha%20DaHomey%20_Liquor%20Store_.mp3?dl=0	Liquor Store	{}	0	\N	0x97e5A788351ad8649B77d282F0D6e08a47813AfC	\N	Asha DaHomey	\N	Asha DaHomey	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
59f8e929-aeb8-4b46-a709-e39b8b5f29bd	2022-09-02 17:12:18.183741+00	https://youtu.be/9YDMcSV5IMs	Our Destiny	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	A$AP Rocky, Playboi Carti	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
9da9d1aa-af0a-4f97-89ff-b44fcc5a237f	2022-03-09 21:26:54+00	https://foundation.app/@mcbess/ladies/5	Meat	{}	2	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	McBess	\N	hallway	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
eb1c8f94-5dbb-4c18-a1f1-513f7852f798	2022-04-30 18:56:29.264066+00	https://youtu.be/97zWk5xzlws	Butterfly Doors	{Jamla,"Roc Nation",🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Reuben Vincent	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
512f92fc-4cb1-44c5-8a54-2e19a2892dc3	2022-04-23 22:07:38.467413+00	https://youtu.be/OJwt30U4io8	Gas Station	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Tia Corine	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a183e3c0-4fe4-4f69-959b-774cd2fdbd16	2022-09-06 03:24:56.267555+00	https://twitter.com/natenumbereight/status/1566587316109549572?s=20&t=GbSUUtqz1GMIBiNnb9eyvQ	JELEEL!Freestyle.mp4	\N	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	NateNumberEight	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1575da64-fd27-4d65-b3e5-e03fc2606bf1	2022-03-09 02:34:31+00	https://opensea.io/assets/0x868193f5743436b7052549e6a3640580a9355f27/2637	Rugstore	{Phlote,🏴‍☠️}	3	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Rug Weaver	\N	Ghostflow	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x1ce9200E1547F8bfb3EFa961FF0b8F88356Ccae2,0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f70c4a96-8084-478c-a830-bd18fb2b1eaa	2022-04-30 13:23:14.564755+00	https://foundation.app/@PatDimitri?tab=created	Peace	\N	0	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Pat Dimitri	\N	Trish	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
cb2e8dc3-e6de-4648-bdb9-4fa39d935674	2022-04-24 22:24:03.070547+00	https://open.spotify.com/track/4h1Vann4dJFv8BfbM8Q6XI?si=PVG6BvkKTUKf0feAt5RsPw	Woah	{r&b,pop,soul}	3	\N	0xc6729C943584fe18345B5551599a8Fa3e14D432a	\N	Leo Pastel & Muwosi	\N	\N	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a74cb0ac-7669-4e4d-bec7-34494331e5c2	2022-08-28 14:23:06.300455+00	https://open.spotify.com/track/5A6a0uxEtTq97BFWG7UShw?si=9cf8e9c282494f81	In The Mix	{Makintsmind,"No Gimmicks","UK Rap"}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Sentry	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
508c441f-888f-40cb-b9b5-501910ff4a71	2022-08-30 22:50:00.297735+00	https://open.spotify.com/track/4M9zMlL6nQvdOofh92EsC7?si=df876570100c437f	Hawk	\N	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Ransom	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2425d3c0-8efb-4294-8c63-360c1b816833	2022-08-17 17:46:54.996652+00	https://www.youtube.com/watch?v=jaGWy8yd-PY	Ain't Shit Change (Feat Chris Brown)	\N	0	\N	0xfFba44c15Fe2768bC2234078dfac8c5A651A56e9	\N	Cal Scruby	\N	AcidPunk	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
18bb236d-ec52-4907-bbee-d8ad1a87abef	2022-10-23 13:46:53.576351+00	https://youtu.be/Woc-KKpu0DI	Scarface	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Jeezy, DJ Drama, EST Gee	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4960cdf4-342f-4e88-a535-3d5453c28c89	2022-05-04 18:15:50.314661+00	https://www.youtube.com/watch?v=JFpxtJji020	Red Light	{"Hood Tali GG",Philly,"Philadelphia Sound"}	1	\N	0xfb3197Bd5b7F2E39c1e89B7619A697827eD2deff	\N	Hood Tali GG	\N	\N	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
524429be-4793-4e1f-8a4e-de156f2d3ab0	2022-05-11 23:11:22.469282+00	https://open.spotify.com/track/6UFivO2zqqPFPoQYsEMuCc?si=9d34d76a111842e7	Bags	\N	0	\N	0x67A276b6768978C9E41Af5418E09Efc8a12a28dE	\N	Clairo	\N	ODENZ	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
dd8a3642-235a-4b20-abde-916b47a3fe5b	2022-04-20 00:32:38.282313+00	https://www.youtube.com/watch?v=h5xmVpqhSRw	(SIC)	{🏴‍☠️}	1	\N	0xb53B1DF71705aa51efe96FaB14c6B11763c9768F	\N	Sid Mason	\N	Jelly	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
93a41af9-8430-42f9-97cf-7db6b3941c8c	2022-09-06 03:30:03.699002+00	https://www.youtube.com/watch?v=k472YAVzoGU	Hoshi Neko	{japanese}	1	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	YAMANTAKA // SONIC TITAN	\N	future modern	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4b8bbcf4-a6f6-493e-a8c9-227114f03a55	2022-09-02 18:17:27.464206+00	https://www.youtube.com/watch?v=7hOy9E6OQHY	Geechie Suede	{Jamla,"Roc Nation"}	2	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Reuben Vincent	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
5378aaa0-eead-485b-b511-55b518813808	2022-05-05 14:16:33.805974+00	https://open.spotify.com/track/1XytXq5sFSLJ0QCZ8wGDvG?si=amidtuiST1yrgg1Bh3QKJQ	Three Still Listening	\N	0	\N	0x88F5d29B88664371401B6786A01db137fC5FcA61	\N	Chavis Chance	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a97f9641-01ab-40e9-b599-e927e3fd9025	2022-03-15 00:48:23+00	https://soundcloud.com/tannaleone/lucky?in=tannaleone/sets/with-the-villains-lucky	Lucky	{ODENZ,"TANNA LEONE"}	5	\N	0x67A276b6768978C9E41Af5418E09Efc8a12a28dE	\N	Tanna Leone	\N	ODENZ	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x7d1f0b6556f19132e545717C6422e8AB004A5B7c,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0x5ab45FB874701d910140e58EA62518566709c408}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d3311b8f-3897-4194-8bad-e2fb1aca1d3e	2022-04-24 22:28:58.857042+00	https://youtu.be/pPChqTkDZKU	Are U Coming Over?	{soul,indie-pop,DIY,boyband,hip-hop,r&b}	0	\N	0xc6729C943584fe18345B5551599a8Fa3e14D432a	\N	Hard Car Kids	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
99726c4d-8918-4ca9-a1bb-35d26a415ef8	2022-04-26 01:53:44.131922+00	https://soundcloud.com/sounds-processing/father-lets-kick-his-ass-ft?in_system_playlist=personalized-tracks%3A%3Aaj-washington-528604433%3A1135652722	Let's Kick His Ass!	{🏴‍☠️,😇}	3	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Father	\N	Ghostflow	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74,0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d79f4ea7-224d-4cdf-9c31-f4da474ed9e5	2022-05-03 03:01:07.335553+00	https://soundcloud.com/talibahsafiya/ten-toes-demo?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	Ten Toes Down	\N	0	\N	0x10B69a0684DaF1B616e12Fe3ee3D286571f46F4f	\N	Talibah Safiya	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b4ce2518-772f-4f98-98a5-e2d62887ee20	2022-03-22 22:53:05+00	https://open.spotify.com/track/5DW8HhxDTmu5rADcLS2P8z?si=836afc23f07a4d73	Mafia	{}	1	\N	0x67A276b6768978C9E41Af5418E09Efc8a12a28dE	\N	4KMichael	\N	ODENZ	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
dccfbb37-0222-4095-b7c9-2482bae21ff9	2022-03-31 20:17:07.454224+00	https://soundcloud.com/seanwiremhk/too-much-to-lose?in=seanwiremhk/sets/one-nour-chapter-1prod-gibdj	Too Much To Lose	\N	0	\N	0x67A276b6768978C9E41Af5418E09Efc8a12a28dE	\N	$ean Wire	\N	ODENZ	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
37168c15-9b58-4878-a05f-fdcc9774bb1a	2022-03-31 20:39:10.270695+00	https://soundcloud.com/latrelljames/the-samo?in=latrelljames/sets/still	The Samo	{ODENZ}	0	\N	0x67A276b6768978C9E41Af5418E09Efc8a12a28dE	\N	Latrell James	\N	ODENZ	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2dc87f4e-c917-4331-b74a-3f80996c88d8	2022-05-10 21:02:39.22018+00	https://www.youtube.com/watch?v=ibsa3DWGoO8&t=16s	I Wish	{🏴‍☠️}	3	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Saint Lyor	\N	Ghostflow	{0x67A276b6768978C9E41Af5418E09Efc8a12a28dE,0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ef8b2048-8bcd-4f9b-a7ec-916d37c76d00	2022-05-17 02:47:58.328073+00	https://opensea.io/collection/case-simmons-image-pollocks	Image Pollocks	{🏴‍☠️}	1	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Case Simmons	\N	Ghostflow	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c4be20dc-1e13-4bd4-aa52-ea5b25f7ae5b	2022-03-28 15:19:42+00	https://open.spotify.com/track/37fiLM6El5x7IZ5mHjBJ5W?si=ae1d13792b474628	Immaculate Conception	{TETRA,HIP-HOP,"BRONX NY","NY RAP","EXPERIMENTAL RAP","NEW YORK"}	1	\N	0xFea1F357b453C9CD89b893B07baA6AbfE8536CA2	\N	TETRA	\N	TETRA	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
58b6a2d4-2797-4719-992f-4565cb8cb95f	2022-05-04 15:57:41.884722+00	https://audius.co/eddy_wardo/jameson-109169	JAMESON	{Rap,Hip-Hop,Lo-Fi,Audius,Scuml°rd,cauzndefx,DylanA}	0	\N	0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74	\N	Scuml°rd x cauzndefx x Dylan A	\N	singnasty	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
5e5caaab-19f8-4637-a89d-6ddde928616f	2022-04-30 19:05:26.534985+00	https://soundcloud.com/tannaleone/here-we-go-again	Here We Go Again	{🔦,pgLANG}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Tanna Leone	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6b807e93-0af4-4468-8d9c-505ef08bab32	2022-05-01 08:12:58.51113+00	https://www.youtube.com/watch?v=iO6bY3YUeEo	Focus	\N	1	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	AE	\N	Trish	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e931c363-31c5-488c-9721-15d64f302892	2022-08-28 14:28:43.792974+00	https://open.spotify.com/track/480ql0IwG0v0HYFLR69SWy?si=92b4537879d64fe2	Concerns in a Cullinan	{"Concerns in a Cullinan",Makintsmind,"Bravado Trap Rap",UK}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Flights	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a5776a05-268a-4b3a-9d77-5f67e05b9e53	2022-03-31 20:34:41.028024+00	https://soundcloud.com/latrelljames/run-forrest-1?in=latrelljames/sets/under-2	Run Forrest	{ODENZ}	1	\N	0x67A276b6768978C9E41Af5418E09Efc8a12a28dE	\N	Latrell James	\N	ODENZ	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
693ca6e2-aa29-464e-bb45-f70905f24fe6	2022-04-29 16:34:15.325171+00	https://toroymoi.bandcamp.com/album/mahal	MAHAL	{Bandcamp,Electronic,Independent,Dance}	3	\N	0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74	\N	Toro y Moi	\N	singnasty	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0xc2469e9D964F25c58755380727a1C98782a219ac,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e6f80b4f-4c8c-4e68-ad20-f6c073ce1baa	2022-03-30 20:54:38+00	https://www.dropbox.com/s/qe8gdb7tr9z2i6a/1.%20Asha%20DaHomey%20-%20_Mmhmm_.mp3?dl=0	MmHmm	{}	0	\N	0x97e5A788351ad8649B77d282F0D6e08a47813AfC	\N	Asha DaHomey	\N	Asha DaHomey	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
bb4a0d9a-f1ed-478a-acbf-53ba65ddc6bb	2022-03-31 20:50:50.068919+00	https://soundcloud.com/vintage-lee/coach-lee	Coach Lee	{ODENZ}	0	\N	0x67A276b6768978C9E41Af5418E09Efc8a12a28dE	\N	Vintage Lee	\N	ODENZ	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d36fe81c-8362-4837-9d9a-77df18e55cd7	2022-11-11 15:29:15.024452+00	https://soundcloud.com/itschxrry/the-falls-1	The Falls	\N	0	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Chxrry22	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
43b793ed-a964-4bc6-880a-e57041bf92a2	2022-03-24 20:33:57+00	https://soundcloud.com/lordfelix/if-god-did-not-exist?in=lordfelix/sets/if-god-did-not-exist-it-would	IF GOD DID NOT EXIST	{ODENZ}	3	\N	0x67A276b6768978C9E41Af5418E09Efc8a12a28dE	\N	FELIX!	\N	ODENZ	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f71b1703-8a4f-4649-a95c-437b48ffe4e0	2022-09-12 16:12:01.573742+00	https://www.youtube.com/watch?v=yoHDrzw-RPg	Hound Dog	\N	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Big Mama Thornton	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3b97b576-1c0f-45cc-b249-105a3af25aa8	2022-10-23 13:50:05.519454+00	https://youtu.be/XUsl8GjwxVM	How Deep	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Jeezy, DJ Drama	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
66eb53ca-8a71-47ef-b178-2c78e3f54ea1	2022-04-24 23:13:03.681895+00	https://open.spotify.com/track/4U3SyExg87JdVtUeKopAfT?autoplay=true	Longing For	\N	0	\N	0x4dFD08B2B8ab7C8dE88Be6dE522799b47bd5ACb6	\N	Dohsi	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ccb038bc-2241-42b9-b1d5-0279d0a55375	2022-09-02 18:19:01.895742+00	https://youtu.be/dfeGh5boU3I	I Ain't Gon Hold Ya	{"Music Video",Jeezy,Snowman}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	DJ Drama, Jeezy	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ef498bd3-425a-4527-b115-41e4bd1b16bc	2022-09-25 22:18:07.1813+00	https://youtu.be/nmjXjQ35f2Y	SOLARIUM	{Visualizer}	3	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	sam gellaitry	\N	hallway	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5,0xf75779719f72f480e57b1ab06a729af2d051b1cd}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
014e1103-c517-4384-92e9-9bef8dfe5732	2022-11-10 23:32:18.100696+00	https://open.spotify.com/track/5gC2aJwuSzGe3IJVlk9r2O?si=49babacd95f44c7d	Final Credits	\N	0	\N	0x8d41859049c156e70fa381e07a757d5db2f33e1d	\N	Midland	\N	jakeabel7	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4c91ec44-9d2b-4d27-aa4a-abea3e3a5062	2022-08-19 18:40:45.452037+00	https://soundcloud.com/amea-sc/the-great-beyond	The Great Beyond	\N	3	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	AMEA	\N	athenayasaman	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x52fA05393a003d234eFBA136E68DA835aeB64a26,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
425cdfd4-a174-4b82-a4a4-f500d4e22f6a	2022-08-17 18:36:33.81614+00	https://www.nts.live/shows/raji-rags/episodes/raji-rags-5th-august-2022	London, 05.08.22	{🏴‍☠️}	0	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Raji Rags	\N	Ghostflow	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7493de88-1ea9-4dd3-b912-9403dfdb724c	2022-05-05 15:19:41.509562+00	https://youtu.be/3A5IEF6WG_k	Keepin It Cute	{prodigy,youth,"female rapper"}	1	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Lani Love	\N	future modern	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
83752f4a-72b1-4eda-be3a-544082593b7a	2022-05-03 14:16:05.398374+00	https://soundcloud.com/rossh_tunes/divinity	divinity	{instrumental,beat,producer,production,"easy listening"}	0	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	divinity	\N	lifeofclaude	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
244d8ea3-0812-4822-b104-df89021dd3e3	2022-04-21 14:52:19.049059+00	https://youtu.be/ZZsbQR6dayE	Tippity Top	{"Victor Victor",🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Moneymade Eli	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
48372424-bcf9-4f4a-a6ef-c59837e41229	2022-03-22 23:43:53+00	https://soundcloud.com/leonemusic/your-night-out	Your Night, Out	{}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Frank Leone	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b1ea60ce-1dc3-44f2-8952-4fede3d5a9e6	2022-05-22 23:02:09.993554+00	https://youtu.be/BqNet1sSYlc	Mirror	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Mogli	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
308c9bd7-2e59-417d-b171-a6d269c35b1a	2022-05-01 20:46:00.765094+00	https://www.sound.xyz/yahzarah	Beautiful Place	\N	1	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	YahZarah	\N	Trish	{0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
043395ff-07a4-4162-8d8e-3312e2c62ff9	2022-05-01 06:31:00.193506+00	https://opensea.io/collection/gummo-land	Gummo Land	{photography,"black and white","fine art"}	1	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Brian Catelle	\N	Trish	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
509971a7-58f1-4df6-a0f3-56f8a8c61365	2022-03-03 19:18:33+00	https://beta.catalog.works/jansportj/it-s-the-new	It's The New	{}	1	\N	0x1ce9200E1547F8bfb3EFa961FF0b8F88356Ccae2	\N	Jansport J	\N	UncleMikey3.0	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
36dc7749-9e51-431b-8329-0d01a3e5f644	2022-10-23 14:05:31.389482+00	https://youtu.be/3Oo13LN4K4s	BIG SNO	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Jeezy, DJ Drama	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6a8d9cdd-e7fe-4517-9686-c189b996e0a5	2022-05-04 16:06:58.193363+00	https://www.youtube.com/watch?v=vxj-PhixV74	Shake That Shit	{Philly,"Shake That Shit",Viral,"Hardbody Youngins","Philadelphia Sound","DJ Crazy","Dance Music"}	2	\N	0xfb3197Bd5b7F2E39c1e89B7619A697827eD2deff	\N	Zahsosaa & DSturdy	\N	\N	{0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e425e499-931c-4c00-9300-721f276026b9	2022-05-01 08:33:47.982214+00	https://open.spotify.com/album/3BfXObMjXI6zBLpxLusmxW?si=20nvpqtHSW2C6HpHNMnGQg	EP 000001-000012 Instrumentals	\N	1	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Black Dave	\N	Trish	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1cba65e9-ea05-45a7-bcdc-0a0020073c4e	2022-11-01 17:34:17.538714+00	https://www.youtube.com/watch?v=bv9UM7AJ_jk	It's Been Wrong	\N	0	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	The Lostines	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e264564c-e595-436f-a516-55983d34c364	2022-05-01 23:26:30.858882+00	https://ladywray.bandcamp.com/album/queen-alone	It's Been a Long Time	{"old soul","young vessel",doowop}	1	\N	0x7BD69d24a9B2f2ba32A0061309D767C4235e87Df	\N	Lady Wray	\N	\N	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
14f7c838-6088-4f77-9766-7ed56bd74028	2022-05-05 16:02:33.342511+00	https://soundcloud.com/dannyxsingh/obama-freestyle?in=dannyxsingh/sets/ilovegod&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	OBAMA FRESTYLE	\N	0	\N	0x2AD084D80B7034E31c8025fdbc8C32fA756Eb4Ba	\N	Danny Singh	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
13417467-3929-4e9d-af07-05b5ef6f8964	2022-07-05 21:47:04.594492+00	https://youtu.be/yfFeNTcmGPY	RUN ft. Dae Chapelle & Young Thug	{"Killer Mike","Hip Hop","Young Thug",Atlanta}	3	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Killer Mike	\N	discoveringEs	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
9a29cffb-8a3d-4bdf-8394-acae7ad3d8cf	2022-09-02 18:20:11.736663+00	https://youtu.be/UXCtt53tqBQ	Detox	{"Music Video",QC,"Lil Baby"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Lil Baby	\N	hallway	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4df95703-ac30-4020-bad4-5cd539cd2361	2022-08-05 00:49:20.50864+00	https://soundcloud.com/kingkavon/free-spirit-prod-by-kenshibeatsgohard?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	Free Spirit	{rap,"phlote live vote"}	1	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	King Kavon	\N	lifeofclaude	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b7202957-0354-4323-a9a7-1337e747bfb4	2022-05-27 19:35:31.707941+00	https://soundcloud.com/kcamp427/k-camp-woozie?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	Woozie	{"K CAMP",WOOZIE,SAUCY}	1	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	K CAMP	\N	lifeofclaude	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2c2fb31f-bf1f-499b-8e71-f2487b2d013f	2022-05-08 21:15:26.113713+00	https://www.youtube.com/watch?v=va4OIEtNqY8	7th Letter	{"bub styles",scary,"new york rap","real rap","hard hitting bars",textures,"luxurious rap","more fetta",G}	1	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	Bub Styles x Pro Dillinger 	\N	lifeofclaude	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b61b25e2-fa18-4596-9ce7-7327b1a6a0f9	2022-08-28 14:33:06.538269+00	https://open.spotify.com/track/6oFN2iGoZ69hcBb9WCLVaU?si=e49ebde979444361	Blessings	{"Lost Souls","UK Rap",Makintsmind}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Coops	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
59fa090f-9df5-48b4-9837-59d638df2b80	2022-05-17 02:50:43.246393+00	https://opensea.io/collection/simco-drops-petra-cortright-room	Room	{🏴‍☠️}	1	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Petra Cortright	\N	Ghostflow	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
abe1002b-a71d-4432-8b74-1c31d3939058	2022-05-06 17:00:15.983284+00	https://www.youtube.com/watch?v=mzqWUeMOB-I	Shopping Spree	\N	1	\N	0x67A276b6768978C9E41Af5418E09Efc8a12a28dE	\N	Vintage Lee	\N	ODENZ	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3b23c402-bdbb-4bb2-8328-a1a0e4d28ef3	2022-05-03 23:43:48.528183+00	https://drive.google.com/file/d/1KM8nFo_JS2SfHL6hVEKM4R5wEJAU3M5d/view?usp=sharing	Unreleased	{unreleased,"future modern","video game music",fantasy,"space pirate sound"}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	iforgotmyname	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4758b8c1-803e-4569-b210-7ff04c55fee5	2022-05-08 21:55:51.393572+00	https://www.youtube.com/watch?v=G2FqD0GOz04	Brag	{"ny rap",alliyah,"creative af",laya,"up and coming","you're welcome"}	1	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	LAYA ft. Fivio Foreign	\N	lifeofclaude	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e2b328c6-0a81-43cb-8d82-814b5c08c550	2022-04-29 16:50:01.300522+00	https://www.youtube.com/watch?v=GXTrWzPTHOw	Dog Food	{Rap,DMV,MusicVideo,IDK,DenzelCurry,KAYTRANADA}	3	\N	0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74	\N	IDK x Denzel Curry x KAYTRANADA	\N	singnasty	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
537e9c94-8365-4723-9d80-3ffddcaa1703	2022-05-07 20:42:39.187959+00	https://youtu.be/bkDezyYKHZQ	Beady Eyes	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	SIPHO	\N	hallway	{0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f6a8b1b5-e95b-42df-beb3-dc71e317aa3b	2022-05-06 16:54:08.759272+00	https://open.spotify.com/track/7xL89LGJ9Fe9DyzFCEyyjK?si=fQ5X7OZvTNOoofRxtQ7Z8Q&context=spotify%3Asearch%3Afrank%2Bleone%2Bblu	Baby, Don’t Jump Too High	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Frank Leone, Blu, Andy Savoie	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ec898a11-ffa6-46a3-ac87-f0e549e2a1b9	2022-05-09 15:14:53.035383+00	https://youtu.be/dEmbAvy4pSw	Bricks in the Wall	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Hak Baker	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
827a9f3b-6461-46d9-b853-02aa66514bda	2022-04-23 22:58:40.458823+00	https://soundcloud.com/mikedimes/religion	Religion	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Mike Dimes	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
5ef0494e-0bcf-4d05-bfa2-f823201f1bdb	2022-04-30 17:21:57.052343+00	https://youtu.be/LX5OQV8CLec	Girlfriend	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Kaash Paige	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7bbf0418-fb10-40a1-9041-013c12952d19	2022-04-12 19:27:00.326793+00	https://www.youtube.com/watch?v=hwfSuRLbetY	047	{ODENZ}	3	\N	0x67A276b6768978C9E41Af5418E09Efc8a12a28dE	\N	Raiche	\N	ODENZ	{0x2d9c9c342E892191B6c0DEFC0C85b1f00E2763a7,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6226496c-9833-4d79-8237-92724404b7d3	2022-09-02 18:21:21.650203+00	https://youtu.be/wUGyZM9rcnY	We Cry Together (Short Film)	{"Short Film","Kendrick Lamar",pglang}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Kendrick Lamar	\N	hallway	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4a5220d0-7855-4afc-acbc-35bd5759af4a	2022-08-17 20:17:58.541552+00	https://on.soundcloud.com/CmKKEVtvyKuGUbMP9	Journey Of Love 	{🏴‍☠️}	0	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	kohotekk	\N	Ghostflow	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ca1949cb-60fb-4d92-b7f1-89e0d06c7111	2022-10-23 14:07:59.359213+00	https://youtu.be/jPfpyBflhtE	One Hunnid	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Jeezy	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
06ba63e1-3ac6-4e60-a5b8-9bdfa52d183b	2022-03-26 04:40:38+00	https://open.spotify.com/track/06bxB6azJmKQOM55IlzNqj?si=eb3fb8fd90434650	Parade	{}	1	\N	0x19a4fc15c43242FCE096eaA92f99A6ddBD6a97CD	\N	James Gardin	\N	JamesGardin_	{0x1ce9200E1547F8bfb3EFa961FF0b8F88356Ccae2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2be7f8f3-a738-45ae-abc0-4fc4e35824d2	2022-03-31 20:12:04.989798+00	https://soundcloud.com/seanwiremhk	Origami	\N	1	\N	0x67A276b6768978C9E41Af5418E09Efc8a12a28dE	\N	$ean Wire	\N	ODENZ	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
562a523b-7bd9-4400-94b4-f9efb8d31aac	2022-04-03 13:38:14.93921+00	https://open.spotify.com/track/5fm9HnEhUKxE3OIUu7haCO?si=eb2acab4df454086	No Law	{ODENZ}	1	\N	0x67A276b6768978C9E41Af5418E09Efc8a12a28dE	\N	Latrell James	\N	ODENZ	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
86897f35-572d-44fb-a0f0-de7459a15e25	2022-04-15 17:29:16.035704+00	https://glass.xyz/v/PmAkyRuzAHAuRh0cCmWzJPOTxvEXcAiUzJir0SQ6ty8=	Pootie Tang	{🏴‍☠️,💎💎}	0	\N	0xb53B1DF71705aa51efe96FaB14c6B11763c9768F	\N	JayProb and Rocky Snyda 	\N	Jelly	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0b7b0217-db91-4771-ba18-090ce36c60a8	2022-08-30 23:04:34.558498+00	https://open.spotify.com/track/2H5fttzme6EKocX6CCip4W?si=259bf3839fa54d31	Tek & an O-Z	\N	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	The God Fahim	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d8ef7b71-6cfc-4758-8ef3-c2b16602f237	2022-09-01 18:10:05.72315+00	https://youtu.be/SmKBscTUeAU	The Horns of Abraxas	{"Music Video"}	3	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Roc Marciano, The Alchemist	\N	hallway	{0xb60D2E146903852A94271B9A71CF45aa94277eB5,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
87871f46-ac62-4d0d-99cb-a07df232211a	2022-05-02 18:23:11.622659+00	https://vimeo.com/190119580	Cinnamon	{"luxury rap","ny rap",queens,rrr,"nyc rap","old school rap",underground,lyrical,"car music","visuals crazy","new rapper"}	1	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	YL	\N	lifeofclaude	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
5f8c7eea-fed0-48f9-900a-c4f395deeaec	2022-05-01 23:31:13.424892+00	https://blackspadevmc.bandcamp.com/track/after	After	{st.louis,voice,"album good from front to back treat yaself"}	0	\N	0x7BD69d24a9B2f2ba32A0061309D767C4235e87Df	\N	Black Spade	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
bab0e266-a8ca-4d76-a14f-3fb69efcc119	2022-04-22 17:29:47.344763+00	https://open.spotify.com/track/3wfxDEXvdkojLaeLNAzZLL?si=2joh9Q0NSOStcPSoheT_8Q	No Strings: The Let Go	{🔦,Rap}	3	\N	0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47	\N	Ben Reilly	\N	Lil Josh	{0x1ce9200E1547F8bfb3EFa961FF0b8F88356Ccae2,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d8a5b143-d722-4e51-83d5-50fd234f4a69	2022-04-03 13:43:48.786807+00	https://open.spotify.com/track/4FKqhjSJxSKhJg9uQAH5Rh?si=30c4349406024c82	When	{ODENZ}	1	\N	0x67A276b6768978C9E41Af5418E09Efc8a12a28dE	\N	Latrell James	\N	ODENZ	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
03a7f32f-5379-42d7-a821-a5595a22ef46	2022-05-18 17:00:13.738071+00	https://www.youtube.com/watch?v=xtXD-8v5i3I	Yellow Incandescent Glaring Bouncy Sunshine	{🏴‍☠️}	2	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Quinn Mason	\N	Ghostflow	{0x1d14d9e297DfbcE003f5A8EbcF8cBa7fAEe70B91,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
63f34864-7caf-43e5-8590-9aa9414e33e2	2022-05-04 00:32:42.279096+00	https://www.youtube.com/watch?v=3qTYO7idTDc&ab_channel=DaRichKidzzVEVO	Hot Cheetos and Takis	{youth,prodigy,"future modern","music video"}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Da Rich Kidzz	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
171d7df7-3487-4b10-8e6a-e0300373c9ce	2022-05-09 14:04:40.625433+00	https://www.youtube.com/watch?v=uAPUkgeiFVY	The Heart Pt. 5	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Kendrick Lamar	\N	hallway	{0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
42efeba1-b212-44b6-ba27-5f23ecbbb04b	2022-04-23 23:00:43.867186+00	https://youtu.be/ii3UAVKQHKE	Mistaken	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	AE	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7cbf88c5-223b-4d13-9642-1d5104ed989e	2022-04-17 01:25:43.345462+00	https://youtu.be/MRM8R8TJzTI	Bentley Baton Rouge	{"New Orleans"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	LANGO w/ (Michael Armstead & Slimm)	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
02ef4d3f-9ce2-4db7-9082-e1a8583761ff	2022-05-25 02:24:51.720211+00	https://opensea.io/assets/ethereum/0xa7d8d9ef8d8ce8992df33d8b8cf4aebabd5bd270/292000052	Corners #52	{🏴‍☠️}	0	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Rafaël Rozendaal	\N	Ghostflow	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
73e33933-68a5-41b8-9e06-4894d648110c	2022-05-26 16:26:13.518462+00	https://soundcloud.com/dirty-projectors/i-feel-energy-feat-amber-mark	I Feel Energy (feat. Amber Mark)	{🏴‍☠️}	1	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Dirty Projectors	\N	Ghostflow	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
72d1a6d6-2502-4f8e-a4b0-62f5f9299afe	2022-11-01 17:35:54.186727+00	https://youtu.be/Zcm2xxaMNrE	I'm Your Man	\N	0	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Daddies	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ebfad6d3-571d-4942-9abf-1f63a828016b	2022-08-28 14:36:26.396153+00	https://open.spotify.com/track/5jNjs0vQX3fqfp9HcGStgT?si=6b0150e3b4c040f6	Frenzy	{"UK Amapiano","Psychedelic Piano",Makintsmind,"Euro 305"}	1	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	European 305	\N	MakintsMind	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d319cee9-f8d4-4ed3-8889-fde6881f348a	2022-10-23 14:13:54.024127+00	https://youtu.be/vZKfrwflOsg	Uh Huh	{Audio}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Big30, ATL Jacob	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ca0a8c5d-7d21-4b4c-80b5-c1d313bec9b9	2022-11-01 17:36:38.74986+00	https://youtu.be/j5R9bAf93ZE?list=OLAK5uy_lEuPHEKdHgzOcQaFglC0FPcUxULdCwy_8	More	\N	0	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Daddies	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
baae3276-c34f-41f8-8d51-b727f6b37ddf	2022-04-17 02:12:55.286201+00	https://sidne.bandcamp.com/track/reaper	Reaper	{rock,distortion,alternative,electronic,"dark wave","face melt","slow burn",sidne}	1	\N	0x85AAffc1F91cD828C82D5d0006B38C34b05917e9	\N	SIDNE	\N	SIDNE	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
30fd08e3-654d-438a-ab82-0cd2448adac7	2022-03-30 19:58:50+00	https://drive.google.com/file/d/1cR6hgsFqH-B4gO9kMEh9iVDnOZSxFY4y/view?usp=sharing	Temptations	{}	0	\N	0x0E0624A2E88E0Dc9B56f9c9Ce2D6907eDd2B8FdF	\N	Ricky Felix 	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7745f7eb-3954-4030-bbff-d87c7237e705	2022-08-25 19:08:48.223991+00	https://www.youtube.com/watch?v=vB7UChgELW4	No Names	{pomona}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Bearcap	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ce7fc58e-2b6b-4ae8-8461-244f0c5f4eff	2022-04-02 17:22:50.440953+00	https://soundcloud.com/user-520684837/geromino?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	Geromino	\N	0	\N	0x2AD084D80B7034E31c8025fdbc8C32fA756Eb4Ba	\N	Salimata	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
39979c49-982b-45e1-b0d8-aa31f09e4697	2022-04-02 22:05:23.418274+00	https://soundcloud.com/cozybounceworld/imthere-66bpm/s-G1eoA7U6Enb?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	imthere	{"summer walker",flip,soulection,rnb,soul}	0	\N	0x24e48db6d94f5dF5524Ae428a2f12F0f2b3Ad48c	\N	BIG COZY	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
00707059-1520-43fa-8420-fd58be0cefe8	2022-04-02 22:13:17.516836+00	https://soundcloud.com/cozybounceworld/smellinlike?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	smellinlike	{smino,soulection,"zero fatigue",bounce,"future bass"}	0	\N	0x24e48db6d94f5dF5524Ae428a2f12F0f2b3Ad48c	\N	BIG COZY	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b9e00d5c-1ceb-4f2e-8fe0-7b9757d46c3b	2022-04-17 18:41:56.189737+00	https://soundcloud.com/lagirlfriendmusic/is-freedom	Is Freedom	{summer,electronic,electro,vibes,pop,"dark wave",slaps}	0	\N	0x85AAffc1F91cD828C82D5d0006B38C34b05917e9	\N	L.A. Girlfriend	\N	SIDNE	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d6df7921-c0bb-468f-9d78-706ea3d67b08	2022-08-30 23:06:09.199921+00	https://open.spotify.com/track/55ZqHgOPgnixejDbDBiuYX?si=30d78fd2a1734dce	Memento Mori	\N	1	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Tha God Fahim	\N	MakintsMind	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
211f65ee-c5d9-442d-a9e8-ab33e7f89e24	2022-09-16 19:18:17.756611+00	https://on.soundcloud.com/u8pGW	ILLUSIONS 	\N	3	\N	0x62F541d08dcA3e1044282DA4a9aa63590B6fFb34	\N	Modest	\N	ModestMotives	{0x52fA05393a003d234eFBA136E68DA835aeB64a26,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b827973c-0003-4b26-88f8-ceadf7160a6a	2022-08-21 15:35:14.465286+00	https://www.youtube.com/watch?v=-Hyhektdveg	I Got You featuring Tay Iwar	\N	3	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	Juls	\N	athenayasaman	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
566e5ed7-f17e-40c1-9332-62744ecf1d06	2022-04-15 17:30:29.036711+00	https://open.spotify.com/track/1lu1qW0KFaYUv2cQJl71ok?si=lZk3353oQKem4rm-WTk-3A	Porn Acting*	\N	5	\N	0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47	\N	Jean Dawson	\N	Lil Josh	{0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x5ab45FB874701d910140e58EA62518566709c408}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c36a33d5-11ba-4ae5-8609-35b9f67f1db2	2022-05-26 15:54:45.48671+00	https://soundcloud.com/garrensean/matter-of-time	Matter of Time	{🏴‍☠️}	1	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Garren Sean	\N	Ghostflow	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e8a2070d-5d4b-4a79-baf4-c044c17f08a7	2022-03-28 12:18:05+00	https://beta.catalog.works/esty/holy-ghost-	Holy Ghost $$$	{latin,music,esty,catalog}	1	\N	0x089036a0835C6cF82e7fC42e9e95DfE05e110c81	\N	Esty	\N	Xcelencia	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d5cb0dd6-ddd2-44d4-92a1-4763ec1aa006	2022-03-28 15:06:10+00	https://open.spotify.com/album/28YkMn1kv89gWQv4x2prIy	C'est La Vie	{}	1	\N	0x83859Ad182b99Cd1f755c1E746D3df8380363d65	\N	Luca Maxim	\N	Luca Maxim	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
068a1975-0fdd-48c4-b3cb-98204b6d3647	2022-05-25 01:56:30.594828+00	https://twitter.com/teamphlote/status/1529267096340811777?s=20&t=tvYEn8bzDem7cliorfZDmQ	Hard Tweetz	{🏴‍☠️}	1	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Phlote DAO	\N	Ghostflow	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1d2b9b5f-88ce-4d8e-ace7-48b30240b63a	2022-05-30 17:58:04.673467+00	https://braxtoncook.bandcamp.com/	Gold	{🏴‍☠️}	3	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Braxton Cook	\N	Ghostflow	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4092c906-daf9-49fd-a860-1b19653fafe4	2022-06-11 02:50:20.351123+00	https://www.lyingflat.place/	Lying Flat	\N	2	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Anonymous	\N	Ghostflow	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
12b30e37-ea37-4c00-8943-8a6759891d18	2022-07-08 14:24:53.55266+00	https://open.spotify.com/track/5QRdNrSAB5lx9TQPrEED30?si=96e5148e66744b1f	EDGEWOOD	{🏴‍☠️}	1	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Black Forces	\N	Ghostflow	{0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f558d4e7-a9cd-4131-9fc8-e0d556c48097	2022-05-08 22:04:54.255629+00	https://www.youtube.com/watch?v=qy5f0Ol9ksQ	Flying Kites	{"hip hop",rap,neptunes,pharrell,tumblr,art,"mac demarco",alternative}	1	\N	0x4C241596065A1Dc9Fe57ecbB6872aF3cC8fFE444	\N	HRSH	\N	\N	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c09f20ce-223f-4455-8cb9-42c640147476	2022-04-04 16:40:14.269511+00	https://youtu.be/G4Dih99NAj8	Nice & Good	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Knucks, SL	\N	hallway	{0xb077473009E7e013B0Fa68af63E96773E0A5D6A4}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6d588e5a-d314-4954-8178-9069a4ce63cb	2022-05-09 22:05:43.846159+00	https://mdcl.mirror.xyz/fzjndANXHKbzSo3evq-JDTbCzXd7hGJ9jAE4jdk-2Is	Mashibeats Remix Contest	{remix,contest,competition,mashibeats}	3	\N	0x3360A4e0Eb33161dA911B85f7C343E02ea41BbbD	\N	MdCL	\N	\N	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3bcc65a3-fcd6-4392-84f0-98105d65e3b5	2022-05-08 22:03:28.180332+00	https://www.youtube.com/watch?v=p1fvtWqQ3qU	SOLIDGOLDGUALABOY	\N	3	\N	0x4C241596065A1Dc9Fe57ecbB6872aF3cC8fFE444	\N	EASE WORLD	\N	\N	{0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b348f646-0778-4704-96ba-8f46f848f841	2022-10-23 14:54:57.802428+00	https://youtu.be/xiACPvQpOhw?list=PL73GAwYINhRihVSDSmFgblXZOG_49U719	Honest	{Audio}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Baby Tate	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
5c97ffbf-7a9d-458d-9a4c-22602599bb21	2022-05-11 03:13:29.457677+00	https://www.youtube.com/watch?v=VRempzSde6g	GO	{O-Slice,DMV,Rap,Hip-Hop,Bounce,MusicVideo}	0	\N	0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74	\N	O-Slice	\N	singnasty	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e781267c-84ff-405a-ae19-573c836ac3f4	2022-05-11 03:11:18.744095+00	https://www.youtube.com/watch?v=K_7Aj3KT9dk	Water (Live Performance)	{PNMA,DMV,R&B,Soul,NeoSoul}	1	\N	0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74	\N	PNMA	\N	singnasty	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
fd9c9b1c-7f1f-429a-aafe-dd0b0314f140	2022-05-11 03:08:33.818229+00	https://www.youtube.com/watch?v=5jbRiViuTw0	Good Morning Cut 1	{ChrisAllen,DMV,Rap,Hip-Hop,Bounce,MusicVideo}	2	\N	0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74	\N	Chris Allen	\N	singnasty	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
51cf983b-40a8-4876-b4d8-76909dc1e624	2022-11-01 17:36:58.596515+00	https://youtu.be/Z5qq-nRUcaA?list=OLAK5uy_lEuPHEKdHgzOcQaFglC0FPcUxULdCwy_8	Snubbed	\N	0	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Daddies	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
929bb4cf-ad98-49cd-8bf5-0901f6c891bb	2022-05-10 02:56:15.04914+00	https://open.spotify.com/track/7assj55W294RyVmiaR3sn3?si=NmOWJsAkRuyqSJ0TDbk-Eg	Pay to Pray	{🔦}	3	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Old Orleans, BUD	\N	hallway	{0x67A276b6768978C9E41Af5418E09Efc8a12a28dE,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a058312f-24dc-4fe9-8633-d7eb0feeb8ca	2022-08-08 14:51:24.131181+00	https://www.youtube.com/watch?v=N53zkq_ypoc	"Phantom"	\N	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Chester Watson	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
346886e1-0065-4721-af20-c79e78b01820	2022-05-11 03:06:58.300568+00	https://www.youtube.com/watch?v=u_E_zxioFUM	Locomotion	{ANEXIS.,PreciousJewel,DMV,Rap,R&B,Soul}	3	\N	0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74	\N	Precious Jewel x ANEXIS.	\N	singnasty	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
cfbf05a0-6952-46ea-a911-45965d613a4f	2022-08-26 16:00:20.004328+00	https://youtu.be/kIVoE91DyC0?list=PLX2IRvQHzAlydFfZbzHZyuh_yw-NSbdhz	Stars	{JID,"Forever Story",Dreamville}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	JID, Yasiin Bey 	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
51882f92-ea21-444a-931f-0c657175be77	2022-05-11 03:02:03.953322+00	https://lordy.bandcamp.com/album/the-four-knights-game-ep	THE FOUR KNIGHTS GAME (EP)	{ANKHLEJOHN,DMV,Rap,Hip-Hop,EP,Bandcamp}	3	\N	0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74	\N	ANKHLEJOHN	\N	singnasty	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
94e7ad0e-0b36-4c55-be8b-2e6d5ec5e72c	2022-05-11 03:14:50.068991+00	https://www.youtube.com/watch?v=gFWinz71Xj8	All Mine	{ButchDawson,DMV,Baltimore,Rap,Hip-Hop,MusicVideo}	3	\N	0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74	\N	Butch Dawson	\N	singnasty	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
493c6a24-3040-4f24-84c1-a4a5e4044fbc	2022-06-06 10:24:14.723442+00	https://soundcloud.com/ilian-tape/itlp04-skee-mask-compro	Compro (album)	{Electronic,breakbeat,ambient}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Skee mask	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
dc6c2204-3dfe-478f-8168-1db472f984a5	2022-08-11 20:09:01.79567+00	https://www.youtube.com/watch?v=AuEjB_AO90Y	Womp Womp ft. Jeremih	{chicago}	3	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Valee	\N	future modern	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e89574ba-d4aa-4fdd-84b9-18d94607c131	2022-05-04 15:39:38.919645+00	https://www.youtube.com/watch?v=lxsGmME0cbc	Paparazzi	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Mike Dimes	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c9abc9f9-dc82-45be-bbd6-cf4a5e51b659	2022-05-07 20:22:16.612717+00	https://youtu.be/8x5DRnokBRw	Poker Night	{🔦,Rap}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Armani Caesar	\N	hallway	{0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6d2fdc99-caa4-4898-b8f3-0faad91bfd3d	2022-05-07 20:36:03.299762+00	https://youtu.be/B1GfItEdfPc	Fk U Mean/Hold Me Dwn	{🔦,"Skyler Vander Molen"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Pink Siifu	\N	hallway	{0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2ffccb00-db8f-4719-b721-695debf9a558	2022-05-10 17:08:00.958793+00	https://youtu.be/gvlQ8fbUeFA	Lane	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Sampa The Great, Denzel Curry	\N	hallway	{0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7aaf36f4-c19e-48f1-b0fc-380c1d205196	2022-05-10 17:06:40.263046+00	https://youtu.be/_83AOaZ3Iyg	Je’Mappelle	{🔦}	2	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Benzz	\N	hallway	{0x67A276b6768978C9E41Af5418E09Efc8a12a28dE,0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d0f16819-a8b9-4861-88aa-2439ce30493d	2022-09-02 19:01:36.602147+00	https://youtu.be/Snhq7hyPhhc	All I Really Wanted	{Dipset,"Fool's Gold",Audio,"Killa Cam",Harlem}	2	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Cam'ron, A-Trak	\N	hallway	{0x5ab45FB874701d910140e58EA62518566709c408,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7cbd9f38-9bbb-4643-9ef1-35a2a60c7041	2022-08-28 14:41:58.559621+00	https://open.spotify.com/track/7MwMzRjO5zUYrO3uN3trwV?si=e422d24e1cef411d	It Nuh Easy	{Makintsmind,"It Nuh Easy",Reggae}	4	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Blvk H3ro	\N	MakintsMind	{0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x5ab45FB874701d910140e58EA62518566709c408}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8aa4ad63-9ecc-40d7-8e6c-ce5a182db8e5	2022-08-30 23:08:51.286254+00	https://open.spotify.com/track/632HbDP8bVQ6qqK491ecNH?si=1aacdc2262804075	I Wonder	{OTB}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	KingIkeem ft Don Flamingo	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8d5bc0f4-1d83-47d8-b9d1-7d4773bd486f	2022-10-23 15:01:02.820872+00	https://youtu.be/Aq0LFNFrMhM	Flowers	{"Lyric Video"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	TOBi	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
cc0e3691-d3d9-4cad-8bde-d32da6f806f1	2022-05-11 15:48:21.796124+00	https://www.youtube.com/watch?v=dHSvK2jpB_Y	LEAP OF FAITH (Live Performance)	{BamAlexander,DMV,Rap,Hip-Hop}	0	\N	0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74	\N	Bam Alexander	\N	singnasty	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
96b19c7a-4816-446b-8506-68b4f103b91a	2022-11-01 17:37:31.279394+00	https://youtu.be/JZr7htmEJnc?list=OLAK5uy_lEuPHEKdHgzOcQaFglC0FPcUxULdCwy_8	Waiting	\N	0	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Daddies	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c785cc3b-a43e-455b-b27a-4e6d973da184	2022-05-11 21:03:52.092788+00	https://www.youtube.com/watch?v=QbxqeGfVa54	Frequency (Cengiz Remix)	\N	0	\N	0x3360A4e0Eb33161dA911B85f7C343E02ea41BbbD	\N	LCSM	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6c4fd771-5e90-4de1-bf01-4490b3ad71bf	2022-05-11 21:04:19.489961+00	https://www.youtube.com/watch?v=ZCQfoAG74Ow	Pleasewakeupalittlefaster please . . . 	\N	0	\N	0x3360A4e0Eb33161dA911B85f7C343E02ea41BbbD	\N	Carlos Nino + Friends	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
76ebc416-efb9-438c-a8e2-6a1bf6c20289	2022-05-11 21:03:31.40424+00	https://www.youtube.com/watch?v=p46Tm9-7i7E	Red Room	\N	1	\N	0x3360A4e0Eb33161dA911B85f7C343E02ea41BbbD	\N	Hiatus Kaiyote	\N	\N	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
9dcdf703-1f92-4066-99ae-2ddaf59f4e08	2022-05-11 21:04:39.19106+00	https://www.youtube.com/watch?v=LF46if1Enc8	Bahia Dreamin'	\N	1	\N	0x3360A4e0Eb33161dA911B85f7C343E02ea41BbbD	\N	Karriem Riggins	\N	\N	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
403fdc43-9123-4bab-a46f-31d197c3ed86	2022-09-02 19:02:53.759078+00	https://youtu.be/8rU2hnKhDNA	Too Much	{"Music Video","Gangsta Gibbs"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Freddie Gibbs, Moneybagg Yo	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ea51b180-b2af-420d-8182-e711158d5271	2022-03-30 16:03:10+00	https://soundcloud.com/dmanahatan/see-the-love?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	See The Love	{}	3	\N	0x1d14d9e297DfbcE003f5A8EbcF8cBa7fAEe70B91	\N	Yuri Beats	\N	yuri beats	{0xb077473009E7e013B0Fa68af63E96773E0A5D6A4,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1b8a3cbb-dffe-4bf9-8651-4000165ac9e9	2022-05-11 14:05:43.789417+00	https://youtu.be/ptk68qC1woI	Letter Sounds	{educational,"nursery rhymes","phonics song","chlidren's song",youth,prodigy}	1	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Gracie's Corner	\N	future modern	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7a1e2905-ab55-4b6c-b649-939f5b7700f0	2022-05-11 14:18:25.604272+00	https://soundcloud.com/malzmonday/100s-and-50s-4-mk-m?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	100's & 50's	{rap,"hip hop",lyrical,"nice beat","whip music"}	0	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	Malz Monday	\N	lifeofclaude	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
af32a655-399e-4b5e-bb96-93ed40e732a6	2022-05-11 14:19:51.975822+00	https://soundcloud.com/skinny/blicky-feat-belly	Blicky (feat. Belly)	{skinny,belly,bipoc,arabaic,trap,horns}	0	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	$kinny	\N	lifeofclaude	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
eadba97a-64b6-47d0-8c0b-7acdf8f4332b	2022-05-11 14:27:15.969822+00	https://soundcloud.com/sy-ari/free-agency-prod-by-natra-average	Free Agency (prod. by Natra AVerage)	{"hard hitting",flex,rap,gucci,louis,fendi}	0	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	Sy Ari Da Kid	\N	lifeofclaude	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2290ea08-a675-4127-8cc2-bc6f74ccf5ff	2022-05-11 14:31:12.947442+00	https://www.youtube.com/watch?v=xGIUcNzEp7M	Palo De Santo / Handball	{"bodega bamz",bruja,pr,"latin trap","spanish rap",energy,"new york",queens,bars,"ava maria"}	0	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	Bodega Bamz	\N	lifeofclaude	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
85679035-934e-46e7-820f-06be5330a8e7	2022-06-07 15:38:57.749788+00	https://youtu.be/Jw6mjolZ6B4	All the Smoce	{🔦,"Music Video"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Kent Jamz, GoodJoon	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
018b0bf3-b1da-4f35-ab4d-b40dccf1855a	2022-05-11 13:18:09.462601+00	https://open.spotify.com/track/5cD0SQXZshc0DLmfVFaT8v?si=CLE1-o-PRQC9qSQ_zffbaw	Flex	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Piff Marti	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
402b983d-ecba-4361-98b7-968efd3a0f1e	2022-05-11 13:38:10.879976+00	https://djharrison.bandcamp.com/track/2021-disco-feat-stimulator-jones	2021 Disco	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	DJ Harrison, Stimulator Jones	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
efd8176e-01d8-419d-858d-844f403fd9c6	2022-05-11 13:43:31.364569+00	https://soundcloud.app.goo.gl/5cPFNycGJyx4x42R9	Feels Forreal Radio	{Mix,🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Kandon Kyser	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ec059f6e-4e0a-4a53-8cc8-7b400aa13df3	2022-05-11 14:44:45.838944+00	https://open.spotify.com/track/0WZv29OGhRABeryXBPMAV6?si=7PgQZbmaRBKm7BFT7mPgeg&context=spotify%3Aalbum%3A656VMGOU4NL8RpviUz5IYF	Ozumba Mbadiwe	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Reekado Banks 	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a04cf12d-dfd2-4fd3-a74e-a39f7b24f0ff	2022-05-11 15:00:52.955426+00	https://open.spotify.com/track/1lwog8HivRMpJFkyWKJcWK?si=dJl7Iz1-Sn-g3ej-kWnLZA	Arms Around Me	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Gundelach	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0b82af6b-dded-49b0-8c66-eea644176189	2022-05-11 20:28:22.770242+00	https://www.youtube.com/watch?v=yrq1pVgGkMs	No Gold Teeth	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Black Thought & Danger Mouse	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e4a7e381-b8cd-4396-9a79-bcc3ed42fb56	2022-09-06 01:26:46.07319+00	https://www.dropbox.com/s/rr6k89r0kjhxv7r/French%20House%20Nephew.mp3?dl=0	French House RXK Nephew	{"Mash up",blend,dj,mxing,RXKnephew,"french house",natural,NTRL,"Le Naturel","austin texas"}	1	\N	0x579a79a9a199Ebd8a793BbB1F33fa709Ad38fadE	\N	NTRL 	\N	\N	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d54f7742-a343-4226-9af6-edcf3c1caf6b	2022-08-28 14:45:05.409868+00	https://open.spotify.com/track/2CzI4WpYbtQSoTHwE7vg3y?si=8e8e76886b924727	Quiet Thoughts	{"Real Life Music",Makintsmind,Foresta}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Foresta, Kaba Pyramid, Protoje	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
963efbf8-0a2d-4991-9354-d856d012bea8	2022-10-23 20:00:06.697679+00	https://futuretape.xyz/token/0x0bc2a24ce568dad89691116d5b34deb6c203f342/284	Uninvited 	{🏴‍☠️}	0	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	CONNiE DiGiTAL	\N	Ghostflow	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
9e2cc744-65d7-486e-bbc7-79ddea21cc4a	2022-05-14 03:46:30.318443+00	https://soundcloud.com/facer/glassface-lightning/s-VwAKo9dk0Z7?in=facer/sets/glassface-vivid-color-dreams/s-ikX6B9sxrrD&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	Lightning	\N	3	\N	0xc2469e9D964F25c58755380727a1C98782a219ac	\N	Glassface	\N	Glassface	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0f86b602-5a37-44ad-935e-36525e8ba5ab	2022-05-13 23:02:33.030873+00	https://www.spores.vision/	Spores 	{🏴‍☠️}	2	\N	0xb53B1DF71705aa51efe96FaB14c6B11763c9768F	\N	Keyon Christ	\N	Jelly	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xc2469e9D964F25c58755380727a1C98782a219ac}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0f58e168-7198-4fd3-a5d4-1433c6aeae1f	2022-08-27 00:43:33.312656+00	https://rlx-000.bandcamp.com/track/diamonds-feat-crimeapple	DIAMONDS feat. CRIMEAPPLE	{HEBUYS,HERDIAMONDS,VERSACESHEWEARS,BINGBING,BLINGBLING,EMERALDS,RUBIROSE,LAWRENCEMASS}	0	\N	0x8d5fb8Aca8294FC9A701408494288D2d7de42F7E	\N	RLX	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
cc58c8a9-9215-47d9-8b64-afc3be417bc9	2022-11-01 17:37:59.455854+00	https://youtu.be/n41yEqXnr2A?list=OLAK5uy_lEuPHEKdHgzOcQaFglC0FPcUxULdCwy_8	Dreams	\N	0	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Daddies	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1898a51f-0cea-4a5c-808d-1ba14189443e	2022-09-02 19:05:09.051029+00	https://youtu.be/ScDgJJi5Guc	Kody Blu 31	{"Ravie B",Dreamville,JID,"Music Video"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	JID	\N	hallway	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e79714ae-09f1-4683-b70f-769dfc8ba6c2	2022-07-22 13:03:40.655865+00	https://open.spotify.com/track/3xdmWDWMICpZCjroQ5gzi5?si=75d1147b0d72487e	Angel Tongue	{🏴‍☠️}	0	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Light Asylum	\N	Ghostflow	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
467ee818-9d8b-42da-af8b-c3b3c9e13944	2022-05-12 00:43:26.621286+00	https://open.spotify.com/track/0JbIo7FNbBjKu2EB2Ux1Ge?si=8PQbaEriT6KCAquE7wxXRQ	Play It Cool 	{Scolla,Skewby,"Play It Cool",Detroit,Soul,Rap}	3	\N	0x889ca9161034ECC87D51677C0D775Fbe1D3499e5	\N	Scolla	\N	\N	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
63b9690e-5cb1-4caf-8650-a3394c1df057	2022-06-28 02:18:35.32163+00	https://youtu.be/KsDT5Wa0hwI	Ravyn Lenae: Tiny Desk Concert	{"Ravyn Lenae",R&B,NPR}	0	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Ravyn Lenae	\N	discoveringEs	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
41b9aa8b-754e-4121-b8b5-09f3dd73f587	2022-08-09 12:54:56.09987+00	https://open.spotify.com/track/3Sxd2zTEoWwMPAVbBJGwAC?si=XCe_SlUKSe-XAV8HpPAsjg&context=spotify%3Aplaylist%3A37i9dQZF1E36VdZUyoPmVj	No Mas!	{🏴‍☠️}	0	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Grip	\N	Ghostflow	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7803a5e1-7aa6-41d5-8d21-7bdef09f1b4a	2022-08-09 13:37:13.551158+00	https://open.spotify.com/track/5yQK2KygOPaDjgFutqlqRv?si=IeQJ4Dc6T6Oam3nKWsBErA&context=spotify%3Aplaylist%3A37i9dQZF1E36VdZUyoPmVj	Innerstate	{🏴‍☠️}	0	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Zaia	\N	Ghostflow	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2da6e90a-c295-4cc8-b0c8-02572cabd9d6	2022-08-17 20:16:09.705878+00	https://soundcloud.com/dreamvacation/a-dream-vacation-summer-of-love?si=5f0def797bee49a5943cb4cf00b70c0f&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	A Dream Vacation of Summer Love	{🏴‍☠️}	0	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Dream Vacation	\N	Ghostflow	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
011f2a68-8e9a-46ea-b3cf-e480487a165d	2022-05-17 09:20:01.133847+00	https://www.sound.xyz/msft/take-back	Take / Back	\N	0	\N	0xB5DE69B65007069e039F2f1e4933aFAd58062382	\N	MSFT	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3f01b5f5-a669-4844-b541-6720aad255ef	2022-08-18 13:17:34.442361+00	https://on.soundcloud.com/6G8U	Doja Cat - Streets (RVOL Remix)	{🏴‍☠️}	2	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Reggie Volume 	\N	Ghostflow	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b7e6d4fd-e33c-412c-9464-409f204cecb1	2022-05-10 21:34:25.36738+00	https://zora.co/collections/0xCa21d4228cDCc68D4e23807E5e370C07577Dd152/45682	Zorbs	{🏴‍☠️}	5	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Zora	\N	Ghostflow	{0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74,0xc2469e9D964F25c58755380727a1C98782a219ac,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7f459fdd-908b-4917-b5b4-093fc07dcb25	2022-09-07 20:16:10.735672+00	https://youtu.be/DsURwTS0OSA	Keep It 100	{"Jet Life",Makintsmind}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Trademark Da Skydiver	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
30ee9f77-7696-42c6-9dcc-e36e4af7b8f3	2022-08-30 23:13:08.426611+00	https://open.spotify.com/track/13hdZWbWPvtczmB8gpD4hA?si=f4b1742226c441b8	Street Lights	{OTB}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	King Ikeem	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6c6d6e54-06a9-4247-aca0-0b8cc2276940	2022-05-18 03:00:39.049535+00	https://www.youtube.com/watch?v=BlWxKCq0d2k	I'm Fresh	{"drain gang","shield gang","sad boys",thailand,stockholm,sweden}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Thaiboy Digital 	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
24b69fd4-e6af-4d47-8d49-99fae41a4a8f	2022-05-18 03:37:18.759957+00	https://www.youtube.com/watch?v=2Szs2uAUSAg	Cullinan	{rage,glitch}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Yeat & Playboi Carti	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c192683e-5c4a-4322-b3a7-2b82f9129846	2022-05-13 15:09:20.687754+00	https://duvaltimothy.bandcamp.com/album/son	Son	{🔦,"Carrying Colour",UK}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Duval Timothy, Rosie Lowe	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0f39abe5-23a7-4ae8-a521-9515ac8631e9	2022-05-13 15:11:39.650605+00	https://duvaltimothy.bandcamp.com/album/help	Help	{🔦,UK,"Carrying Colour"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Duval Timothy	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
57776d94-8104-4afc-bcbc-d38b55fa60dd	2022-05-13 15:20:03.928568+00	https://duvaltimothy.bandcamp.com/album/2-sim	2 Sim	{🔦,UK,"Carrying Colour"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Duval Timothy	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ec58b761-b209-493a-b5a4-1bc87c757c4a	2022-05-13 15:22:43.053203+00	https://duvaltimothy.bandcamp.com/album/sen-am	Sen Am	{🔦,UK,"Carrying Colour"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Duval Timothy	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
66beb809-96d8-45a1-b88d-652eb7722288	2022-08-19 14:28:26.19013+00	https://youtu.be/9yCpL-YWcVc	V O R T E X	{"Rikkí Wright",Brainfeeder}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Terence Etc.	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b1c445f5-0e8d-43fb-a185-d1c0e4f47579	2022-05-20 21:14:50.939498+00	https://www.youtube.com/watch?v=uAPUkgeiFVY&ab_channel=KendrickLamar	Heart Part 5	\N	0	\N	0x0b1cc9292401D5Cb64875A441853Ada7630148b4	\N	Kendrick Lamarr	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4dc290f2-d88e-46f0-bcc7-ab8b4883e037	2022-10-25 04:58:30.203841+00	https://www.youtube.com/watch?v=83KR_UBWdPI	No Cars Go	\N	1	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Arcade Fire	\N	future modern	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6dba10db-a865-40ad-aa46-0529cc2f8fe2	2022-11-01 17:41:52.31644+00	https://sodagong.bandcamp.com/track/caged-at-last	Caged At Last	\N	0	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Mister Water Wet	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
fdeddce7-e381-44ff-9b55-67408f9f05ed	2022-05-25 02:21:57.559357+00	https://opensea.io/assets/ethereum/0xd02f211bcb4747379e717def0504e01e067567c8/70	Homage 70	{🏴‍☠️}	0	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Rafaël Rozendaal	\N	Ghostflow	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
cb6a9fe7-d600-4fc9-93e4-f679a661aaae	2022-06-30 21:00:45.453795+00	https://open.spotify.com/track/1gavmgVemDQr6pFaowen50?si=tUBUhdDLSQWyq9Po11tBmQ&context=spotify%3Aalbum%3A16AQyjz1z9rOsTm6iVrBUR	Bother	{🏴‍☠️}	1	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Los Sins	\N	Ghostflow	{0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
48e691ef-2e89-4f33-8899-c792a2843eca	2022-09-02 19:06:43.376617+00	https://youtu.be/ES9CqKPkdeU	Persuasive	{"Music Video",TDE}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Doechii, SZA	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
52dd2010-8fea-4ab9-a936-d4ac51a22e66	2022-08-28 15:00:22.29193+00	https://open.spotify.com/track/1QnGIsCK3Oueb7cn20iXro?si=afc1e34a31c54c97	Off The Edge	{"Nikhil Beats","Uk Music","Alt Music",Makintsmind}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Nikhil ft Safiyyah 	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a274f4b3-8662-4803-aa03-abe57800ad6b	2022-09-06 15:45:40.923462+00	https://ipfs.moralis.io:2053/ipfs/QmYHc1ftbWHazeovAjJ4nBPAieDN9stsTuLngFiRCbPJEP	LOFFST MOONWXXXLK3R	{"MAD DELTA",BVLL,LOFFST,MD,DMV,"SELF PRODUCED","SELF ENGINEERED",PHONK,XXXTENTACION}	0	\N	0x1502F98D90cc10b11B994566dFC44EC84035eCE8	\N	LOFFST	\N	Horace.eth	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a5539100-0a9a-46ba-86de-92cfac9769fa	2022-03-22 23:34:52+00	https://open.spotify.com/album/5lPkYCoNdfxahmLktMdXx3	Chains	{Hood,🏴‍☠️,Trap}	1	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	KP Cannons	\N	Ghostflow	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f2e625a5-c296-46fd-89af-95dc9d24959e	2022-06-08 05:00:26.111816+00	https://soundcloud.com/senojnayr/dat-durt-147bpm	DAT DURT	\N	2	\N	0xeb54D707252Ee9E26E6a4073680Bf71154Ce7Ab5	\N	SENOJNAYR	\N	\N	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
84587ab5-d08a-4499-a76e-e4cb1d7809fe	2022-08-18 20:39:35.002363+00	https://soundcloud.com/a_nexis/sets/hbcu?si=8067916286aa4a9d9afd961029f3e85e&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	HBCU	{🏴‍☠️}	3	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Anexis.	\N	Ghostflow	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
48319a8b-2c93-4cab-a345-f622417238ee	2022-07-18 19:27:32.703032+00	https://www.youtube.com/watch?v=AYCY5yI6CHo	Black Techno Matters	{🏴‍☠️}	1	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Stukes	\N	Ghostflow	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
12eb56ae-0234-464c-9437-825ab278fd2a	2022-08-27 14:50:55.771744+00	https://open.spotify.com/track/17E3lZxFJnO49Gb0tdgVn0?si=tjq32YLmQCO1eGplqZmpwg&context=spotify%3Aartist%3A1np8xozf7ATJZDi9JX8Dx5	Joy	{🏴‍☠️}	0	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Salute	\N	Ghostflow	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
152b8dc4-6f08-4c66-bbdf-327e9275d66f	2022-03-05 03:04:34+00	https://opensea.io/assets/0x0317acbf0d1a69e9641afc4a44333c89943f40ca/1	Looking Out	{🏴‍☠️,Vibes,"Future Music"}	5	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Yuri Beats	\N	Ghostflow	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xb077473009E7e013B0Fa68af63E96773E0A5D6A4,0x1d14d9e297DfbcE003f5A8EbcF8cBa7fAEe70B91,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x5ab45FB874701d910140e58EA62518566709c408}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7623e4e1-22a5-4123-ba4f-6f4517029f4b	2022-10-19 04:39:15.981539+00	https://open.spotify.com/track/2fTGh0imCRgP2FcsLLlj01?si=96d7e17499f54c47	30	{🏴‍☠️}	3	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	TiaCorine	\N	Ghostflow	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47,0xf75779719f72f480e57b1ab06a729af2d051b1cd}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b7744343-a1a8-40f5-8467-2c45a492f30d	2022-05-23 12:37:43.34321+00	https://youtu.be/uI6XCm4qqg4	This Shit	{🏴‍☠️}	0	\N	0xb53B1DF71705aa51efe96FaB14c6B11763c9768F	\N	Spacemoth	\N	Jelly	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b14034ab-b641-4dfc-be22-dbc174d3c606	2022-05-23 12:47:35.722499+00	https://youtu.be/nMSJPi08hIg	sophia 	{🏴‍☠️}	1	\N	0xb53B1DF71705aa51efe96FaB14c6B11763c9768F	\N	Uffie 	\N	Jelly	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a462f2f8-0595-4745-9dd9-a1dac8442d9a	2022-05-23 06:55:42.568124+00	https://open.spotify.com/track/1sVcGFUKpH8Wu4oca6O5Rq?si=b22eee531855455b	Vinyl	\N	0	\N	0xacef50638be46aDcd6f5C7DFD9bf5894266794FC	\N	Berwyn	\N	harishm	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ad4b2252-90ae-4b94-af10-7973100481ad	2022-05-23 22:26:18.141683+00	https://www.youtube.com/watch?v=29sGKB4aROQ	Each and Every Moment (prod. Dilip)	{detroit,"bruiser brigade","no hook"}	1	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Zelooperz	\N	future modern	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
425b1f85-3950-4570-ac2e-e5a6ae9010a6	2022-05-18 22:08:14.199537+00	https://soundcloud.com/yvngxchrisss/damn-homie-feat-lil-yachty?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	DAMN HOMIE (feat. Lil Yachty)	{gang,yachty,"lil boat"}	1	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	yvngxchris	\N	lifeofclaude	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
fe327d80-1dbf-4f9a-8aa7-f3f7dea5e9a8	2022-05-19 14:53:08.140848+00	https://youtu.be/I4yBibEDd0g	Tyler Durden	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Nineteen97	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f6ef25e2-de1c-4d95-9b23-467b82825dd9	2022-05-20 14:35:46.362053+00	https://youtu.be/QDFWiH3KKYU	Eye Tell (!)	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Jim Legxacy	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
eba49756-f044-4e4e-91d9-de50b651093c	2022-05-20 16:26:11.749089+00	https://youtu.be/LHmYvi6Gy5k	Wait for Me	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	AGAT, Zelooperz	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4d736603-dc4d-4f46-bd80-4e03519d4517	2022-05-21 18:08:58.865524+00	https://youtu.be/oT1q7_XvWPQ	Alive Ain't Always Living	{🔦,"Mello Music Group"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Quelle Chris	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a578b400-b832-49f6-8479-18d02285de86	2022-05-25 13:58:56.511956+00	https://soundcloud.com/terrorhythm/plastician-juche-enight	eNight Revisited	{bass,garage,"future garage",wave,hardwave}	0	\N	0xAd66810a7358ad499C611d50108D0E0A8733E913	\N	Plastician	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
9f0cb599-7dc5-4245-aeee-0eceafd56316	2022-05-31 06:55:36.624667+00	https://beta.catalog.works/musebymonday/band-of-the-hawk	Band of the Hawk	\N	1	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Matt Monday	\N	Trish	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b43622da-9fd0-41b2-b63b-9922cd7b6bef	2022-10-26 17:01:42.595812+00	https://youtu.be/xCUWScPU124	PRADA U	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Meechy Darko	\N	hallway	{0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ac9768a3-1503-4d54-a402-90d7edc382a3	2022-11-01 17:43:25.620936+00	https://munsterrecords.bandcamp.com/track/the-sand-man	Sandman	\N	0	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Laghonia	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f04864c3-54cb-4199-826c-459af2f6cec6	2022-11-11 01:10:29.958809+00	https://www.youtube.com/watch?v=V1bEi-MmUxM&ab_channel=bakar	Pitstop	{bakar,r&b,fire,heat,new,"brent faiyaz",london,UK}	0	\N	0xd1a160724f6912537b0dd4cce5e5c134ace2cc97	\N	Bakar	\N	untitledfiles00	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b34d2022-0d56-4365-910e-535a514d3194	2022-10-13 20:33:33.445946+00	https://youtu.be/K1Rab8affzE	Angel	\N	3	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	SAULT	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0xf75779719f72f480e57b1ab06a729af2d051b1cd}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
af477476-4ea4-43fe-9241-c0c7813ac724	2022-05-31 06:53:50.799095+00	https://beta.catalog.works/musebymonday/red-eye	Red Eye	\N	1	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Matt Monday	\N	Trish	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4c0d22a8-4dfc-4e6d-993e-eed8eafee339	2022-05-26 02:35:04.693088+00	https://youtu.be/TFwNMaTY5Z8	Complex of Killing A Man	{🔦,"Music Video"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	BLK ODYSSY, Baby Rose	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a2d2c585-968f-448b-b232-1a2e7b2a9f72	2022-06-06 10:34:40.959284+00	https://soundcloud.com/musicismysanctuary/falty-dl-frigid-air-oflynn-remix-blueberry-records	Falty DL "Frigid Air (O'Flynn Remix)	{deephouse}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Falty DL	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
06324de3-819c-4aed-a1a8-922e9ae2bc35	2022-06-09 16:08:45.343391+00	https://opensea.io/collection/silk-road-by-ezra-miller	Silk Road	{generative,landscape,memory,arweave,webgl}	0	\N	0xf93D8b05aA184F3b6B76D85418DBa1472735ED54	\N	Ezra Miller	\N	henry	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
602274d8-0268-4c2f-a564-8b23d8022d74	2022-08-19 14:33:58.082348+00	https://youtu.be/9syqivQrfDE	2007	{Dreamville,JID}	2	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	JID	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ec4fe096-2dd7-4e03-a0f7-dc7a5626da79	2022-05-29 00:55:37.299223+00	https://www.youtube.com/watch?v=_GIi2wefTwM	This Year	{"rip lil peep","black lil peep","soundcloud golden era"}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Lil Tracy	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
96342b4b-f03f-464e-90e0-e807eeee0c84	2022-05-29 00:58:59.179302+00	https://www.youtube.com/watch?v=5ihsAv08Pi8	PUSSY MONEY WEED	{estonia,¥€$}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Tommy Cash	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
5eec4754-7f96-4563-8e3c-478527f21fd0	2022-05-29 16:46:21.136885+00	https://www.youtube.com/watch?v=eLRzPyGVwq4	Atlanta Neighborhood	\N	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Danger Incorporated	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c357a084-5a7e-44b3-95af-cbbca0555b18	2022-05-27 19:37:46.660864+00	https://soundcloud.com/amonrahh/san-diego?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	San Diego?	{"EASY GOING","CALI CONNECT",AMON,"SAN DIEGO"}	0	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	Amon	\N	lifeofclaude	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
256f1920-5904-4c02-b806-f8d73e726758	2022-05-26 16:53:44.282111+00	https://youtu.be/jarVx2qCh18	Lately	{"Eli Derby",6LACK,🔦,"Music Video"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Eli Derby, 6LACK	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
de9a59df-e20b-43c2-a6a0-a1cb64467b09	2022-05-26 20:43:30.197543+00	https://youtu.be/SM6PRVFKcU4	Boy Estate	{🔦,EP}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Kehelo, NOVA, Bernard Jabs, Dutchboy, Chad Desjarlais, Yawshi	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a12e36b6-a45a-4e4f-8ecd-8971639d9447	2022-05-30 14:04:04.055051+00	https://youtu.be/hu4OdBn4Yoo	Southman	{UK,🔦,G-Funk}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Novelist	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c94427f2-bf17-4c53-8e43-610d66d6cade	2022-05-27 22:53:06.94895+00	https://youtu.be/4XACcdvI97o	Janet Planet	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	TOPS	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ce4bcafd-8a41-425b-95d4-cf1afdbc1627	2022-05-30 18:49:34.834332+00	https://wearefromthefuture.bandcamp.com/	 A Night at Bellsynth	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	From The Future	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
93ff7b4a-3639-4197-be24-8108d8ee2171	2022-05-30 18:25:05.964025+00	https://shaunandtrox.bandcamp.com/track/timmy-chans	Timmy Chans	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Fatboyshaun & Trox	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1cd82506-aa46-4b9b-82dc-3eee1068ca73	2022-05-30 18:13:37.038922+00	https://thebrianjackson.bandcamp.com/album/this-is-brian-jackson	This is Brian Jackson	{Album}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Brian Jackson	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
20108041-5d5c-4abe-94aa-c913774dc16a	2022-05-25 18:37:08.530472+00	https://soundcloud.com/khruangbin/chocolate-hills?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	Chocolate Hills	{experimental,"trip hop","alternative jazz"}	3	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	KhruangBin	\N	lifeofclaude	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ab8d0c69-b59f-4759-a524-347d78b73a28	2022-09-06 15:48:36.088587+00	https://ipfs.moralis.io:2053/ipfs/QmYHc1ftbWHazeovAjJ4nBPAieDN9stsTuLngFiRCbPJEP	COBAIN FREESTYLE BY 888MOMENT	{"MAD DELTA",888MOMENT,MARYLAND,DELAWARE,"EAST COAST","PROD. HOUDINIFR"}	0	\N	0x1502F98D90cc10b11B994566dFC44EC84035eCE8	\N	888MOMENT	\N	Horace.eth	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b2e87a17-6395-4c69-bac4-05a9732dbaed	2022-09-07 20:25:22.722526+00	https://youtu.be/NE9w3wipnKM	Gang Related	{Logic,Makintsmind}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Logic	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6f98b5f6-ca68-4e01-9f25-7da808179dd0	2022-08-28 15:03:08.902004+00	https://open.spotify.com/track/4eW5j7SlKXABz73bzrZtIr?si=5c36c8a078914b44	If I Should Die	{Alt,Makintsmind,"If I Should Die",Niia}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Niia	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
58836914-5ea3-4af0-a83b-8c73b09f3597	2022-05-30 19:34:06.543346+00	https://zora.co/collections/0xdC17fED95041881d56482aC5Ff1deC958C033E33/3	VILLIAN	{Jazz,r&b}	0	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Rama	\N	Trish	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
90c0063c-7626-4dbf-85bc-dd84c3bf9208	2022-10-26 17:03:23.836124+00	https://youtu.be/n2PcDQtxgdg	Basement Check	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Psalm One 	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d28f1d77-7a30-40fd-beac-f4d9c37d66b4	2022-08-19 15:12:38.968064+00	https://youtu.be/lcXt5tU_QM8	THREE HEADS*	{"Music Video","Jean Dawson","Bradley J Calder"}	5	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Jean Dawson	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x52fA05393a003d234eFBA136E68DA835aeB64a26,0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01,0xa8c37C36Eebae030a0C4122aE8A2eb926b55Ad0c}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a88c8f2f-c617-4d8d-a9b0-5ac59265b384	2022-11-01 17:44:16.862314+00	https://munsterrecords.bandcamp.com/track/billy-morsa	Billy Morsa	\N	0	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Laghonia	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
5f297bcc-a42f-4744-b4d3-39fab2af6739	2022-08-27 00:56:55.902178+00	https://rlx-000.bandcamp.com/album/dodi	WE GUCCI	{ESTUPIDO,PITOVAL,PILATES,AINTNOTIMEICOULDWASTE,WEGUCCI,HOUSEOFGUCCI,LODIDODI,SAVETIMESMOOTH,SEEINITHRU}	1	\N	0x8d5fb8Aca8294FC9A701408494288D2d7de42F7E	\N	RLX.000	\N	\N	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3fadb475-f823-4f35-ada8-c2cc1c2cf100	2022-10-11 15:42:29.111799+00	https://soundcloud.com/thrillabands/butterfliesxdolphins?in=thrillabands/sets/poweredbythemoon-presents-subtropic-summer	ButterfliesxDolphins	\N	3	\N	0x580Fe897EF7026F9994324D654EB631663FC24C7	\N	Poweredbythemoon	\N	\N	{0x5ab45FB874701d910140e58EA62518566709c408,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xf75779719f72f480e57b1ab06a729af2d051b1cd}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0942dc43-0a90-4554-87be-d169cf08efae	2022-05-31 15:23:45.692383+00	https://open.spotify.com/track/5ZRM9cNzt2CS9eZyzEyRtZ?si=9df7ae1a08984584	Toma Tusi	\N	0	\N	0xacef50638be46aDcd6f5C7DFD9bf5894266794FC	\N	Russ	\N	harishm	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2a5968ef-32d0-44c4-a124-8aeebb866ab2	2022-06-09 16:22:56.227355+00	https://open.spotify.com/track/2MSKUCw4Tx5HRN8sMhmbUx?si=419b9e9b6b6b4900	Let it Happen	\N	0	\N	0xf93D8b05aA184F3b6B76D85418DBa1472735ED54	\N	Jon Bap 	\N	henry	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
662d32c9-ceb7-4b34-95e6-e7e94f379fd3	2022-05-14 03:15:55.547613+00	https://soundcloud.com/facer/sets/glassface-vivid-color-dreams/s-ikX6B9sxrrD?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	Glassface	{glassface,music}	5	\N	0xc2469e9D964F25c58755380727a1C98782a219ac	\N	Glassface	\N	Glassface	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b7995fbb-e6bc-4ea3-b4e1-b8010e8dc1ca	2022-11-11 00:57:33.528238+00	https://soundcloud.com/whoisbeam/milo-coffee-bean-freestyle-feat-vory	Milo (Coffee Bean Freestyle)	{vory,beam,hiphop,r&b,fire,new,"travis scott",astroworld}	3	\N	0xd1a160724f6912537b0dd4cce5e5c134ace2cc97	\N	Beam ft Vory	\N	untitledfiles00	{0x0bbac2bd3134a318deb31137d87d42bf54325cb7,0xf75779719f72f480e57b1ab06a729af2d051b1cd,0xef58304e292fbaeacfdec25b67b3438031fde313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
32174ca0-be12-45c0-b6f6-b18701f07a9e	2022-05-31 13:10:38.141285+00	https://magnetikmoments.bandcamp.com/track/bone-collector	Bone Collector	{Baltimore,"Los Angeles",Rap,🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	ullnevano x JustDon Bank$	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2c1e2837-f39f-4161-aec0-27812fd7f0c4	2022-08-28 15:05:11.074862+00	https://open.spotify.com/track/0IbJBhAkIFqTHoYjWYxpzZ?si=2cbbfe17a9374c33	Wickedest	{Wickedest,"Afro Rnb",Makintsmind}	1	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Tamera	\N	MakintsMind	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d18f87e3-498c-4cb9-9a92-e538468813cf	2022-05-31 19:14:36.191352+00	https://zora.co/collections/0xdC17fED95041881d56482aC5Ff1deC958C033E33/2	Feel Good	{jazz,soul,r&b}	0	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Rama	\N	Trish	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f88934b9-8379-4ffb-b4ef-db8b2cc3c8ee	2022-05-31 19:15:55.276825+00	https://zora.co/collections/0xdC17fED95041881d56482aC5Ff1deC958C033E33/1	Cute little Girl	{jazz,r&b}	0	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Rama	\N	Trish	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
544a5142-2506-4b87-bc9f-9dad956a28db	2022-05-26 16:53:16.664247+00	https://soundcloud.com/greentea-peng-108510205/your-mind	Your Mind	{🏴‍☠️}	0	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Greantea Peng	\N	Ghostflow	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
994bb4b1-c525-4d70-be41-4653873d43a6	2022-09-13 21:05:50.480067+00	https://www.youtube.com/watch?v=UU-QeaUUAxc	Night Walker	{goth,sickboyrari}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Black Kray	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
12639287-cee2-4419-805d-877ac70398d9	2022-05-31 19:17:23.500581+00	https://zora.co/collections/0xdC17fED95041881d56482aC5Ff1deC958C033E33/12	NUMB	{Jazz,R&B}	0	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Rama	\N	Trish	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6149c8dd-a1f9-423a-8e64-6c82ab8f534f	2022-05-31 20:04:35.732495+00	https://opensea.io/assets/ethereum/0x495f947276749ce646f68ac8c248420045cb7b5e/88734372949206584880547212620741210320160475197301464648873740338960986537985	Survival Mode	\N	0	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Garisinau	\N	Trish	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d7c48645-bd04-4153-aa3e-1ec52ecc3128	2022-05-31 20:08:47.69294+00	https://objkt.com/asset/hicetnunc/424263	Welcome	\N	0	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	miwako	\N	Trish	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e9d6fd62-7a05-4107-80b9-ac187c8548e9	2022-06-01 04:53:17.424679+00	https://beta.catalog.works/dominosmusic/love-in-death	Love in Death	{"hip hop",rap}	0	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Domino	\N	Trish	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
32817222-0e54-4cb2-a8b3-dca1d4adcaba	2022-05-31 07:21:19.40678+00	https://www.mintsongs.com/songs/5424	Wolf	{metal,"goes hard"}	1	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Black Dave	\N	Trish	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
332db991-50c4-40fd-8828-a64ee2b32618	2022-10-26 17:04:31.269422+00	https://youtu.be/OWs6-h_UrTs	What Else	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Rapper Big Pooh	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
724e79e0-e855-4184-9acd-d385a4a3bb73	2022-11-01 17:44:51.817518+00	https://munsterrecords.bandcamp.com/track/a-trouble-child	Trouble Child	\N	0	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Laghonia	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2e237675-5902-4b7d-8a3f-5d2887999e68	2022-06-01 21:56:13.337753+00	https://open.spotify.com/track/2xma75K3LpGnaB5iC0algz?si=65e33b06910844d1	Pins and Needles	{alternative,sad,singer-songwriter}	3	\N	0x88F5d29B88664371401B6786A01db137fC5FcA61	\N	Anna Luther	\N	\N	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b61609fa-38cb-4e09-bd40-3c56a957083c	2022-06-04 14:14:46.967618+00	https://zora.co/collections/0xdC17fED95041881d56482aC5Ff1deC958C033E33/3	Villain	\N	0	\N	0x3De7fd5f98f7394bF2F3bdf30a575CcEcecf0A10	\N	Rama	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
03d5a6f1-e3a3-4127-be09-bc426dcfe3fa	2022-06-02 21:36:05.780161+00	https://open.spotify.com/track/374TqcVubV5DWCs9YJHhKX?si=e497f21bc6fb40d3	Breathe	{folk,trippy,meditation}	1	\N	0x8A19EE2B23EF483C6c9B2De1e65D8c799Cd80EA1	\N	spence the guru	\N	\N	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6365e489-f787-4b6d-ba25-859f2b3c1f79	2022-05-31 15:27:08.425221+00	https://open.spotify.com/track/6ZOhPKOWY55pmcGFmQAE86?si=7a247fa83a304e5d	Good Times	\N	3	\N	0xacef50638be46aDcd6f5C7DFD9bf5894266794FC	\N	Miraa May ft Mahalia	\N	harishm	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2cec7f56-dffc-42fa-8d83-3c19e49e9e19	2022-11-11 01:00:49.244972+00	https://open.spotify.com/track/5toJOk9lwGQE323SnQ8Tii?si=db517a8c027748c1	TRIP	{Vancouver,Canada,hiphop,"travis scott",rap,new,fire,trippy,toronto}	1	\N	0xd1a160724f6912537b0dd4cce5e5c134ace2cc97	\N	Boslen	\N	untitledfiles00	{0x0bbac2bd3134a318deb31137d87d42bf54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8ad70382-84da-42cb-86dd-2180a91a356e	2022-06-05 16:08:53.238245+00	https://soundcloud.com/gordon-fordom/theodore-grams-badland-breez-til-i/s-Hrq6MwEk1Pe?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	'Til I	{"Philly musuc","theodore grams","badland breez"}	1	\N	0xfb3197Bd5b7F2E39c1e89B7619A697827eD2deff	\N	Theodore Grams & Badland Breez	\N	\N	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6d803058-bd5c-422b-8c50-0f2cdd8f22b4	2022-05-31 08:29:11.483478+00	https://open.spotify.com/track/3oYuIcMNiEgy3HMX2BPUb2?si=ded5700ff3444809	All Night Long	\N	1	\N	0xacef50638be46aDcd6f5C7DFD9bf5894266794FC	\N	Debbie	\N	harishm	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c7f85ef7-5341-42a4-8571-b2720b9e5c59	2022-10-26 17:06:48.802384+00	https://youtu.be/Zg5uQ4AxNd8	Broken Dreams	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Rapper Big Pooh, Blakk Soul	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d93f2b2a-e624-4fe8-bbcb-345b521c1083	2022-05-03 22:41:55.572844+00	https://soundcloud.com/user-203514650/hot-tamale-girl	Hot Tamale Girl	{prodigy,🔥,"future modern"}	3	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Young Hi-Way	\N	future modern	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01,0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3d9742f6-0261-4b33-bf57-94ea685da2f9	2022-06-09 21:19:50.242684+00	https://www.youtube.com/watch?v=fzP0LO0AFjk	New Jack City	{"eem triplin","corner boy music",trap,"new jack city"}	1	\N	0xfb3197Bd5b7F2E39c1e89B7619A697827eD2deff	\N	Eem Triplin	\N	\N	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d2bc1a18-bafe-49a6-b9cf-fa76ecd10465	2022-06-06 10:16:33.605493+00	https://soundcloud.com/chris-coco/haraket-taint-djrum-remix	Taint (Djrum Remix)	{Postdubstep,Downtempo,Electronica,Djrum}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Haraket	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e042b26f-1da8-4827-a430-f8779956b445	2022-06-06 10:20:27.521615+00	https://soundcloud.com/harriscole	pause/chapsitkc	\N	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	harris cole	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e5af9345-b75a-42c2-b8a5-8a9ba79b19a1	2022-06-02 15:56:57.492208+00	https://soundcloud.com/draftday1/no-limit?ref=clipboard&p=i&c=0&si=6FDF4193C0A6499EB9BC74F6A14AB3A0&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	No Limit	{underground,"no limit",racki,"draft day",shiii,slaps}	1	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	Draft Day	\N	lifeofclaude	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
63147799-572f-4402-be53-c0d4d3b9767e	2022-06-01 14:36:08.544755+00	https://youtu.be/p769m-mAjHg	Benny's Got a Gun	{🔦,"Music Video"}	3	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	BLK Odyssy, Benny the Butcher, George Clinton	\N	hallway	{0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ded21f9b-23ef-4461-a46e-722f468482a4	2022-06-05 23:41:56.949335+00	https://www.youtube.com/watch?v=3360YfaNZLM	Kesha Dem	{🔦,RIP}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Trouble	\N	hallway	{0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6e947209-385f-40ef-9a91-3dda4b92df57	2022-08-19 16:11:10.232657+00	https://youtu.be/b-3CkF2DG8Y	Don't Check Me	{"Music Video","Larry June","Bay Area"}	2	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Larry June	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
07fd861d-c18a-4525-a96b-b43a862ffc69	2022-06-08 13:59:10.109906+00	https://chaos.build/	Chaos	\N	2	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Songcamp	\N	Ghostflow	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8ce21e7a-1f7e-4a5b-baca-9acb22ff7438	2022-06-10 03:21:21.926237+00	https://www.youtube.com/watch?v=4wwEfn-wR4c	My Overreactive Imagination feat. Groupthink + sylvie lou (Lyric Visualizer)	{GodlyTheRuler,Midwest,Rap,Pop,MusicVideo}	2	\N	0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74	\N	Godly The Ruler	\N	singnasty	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d948e62f-7f88-4882-a97d-96f5ddc629d8	2022-06-01 04:55:43.295757+00	https://beta.catalog.works/dominosmusic/coupe	Coupe	{rap,"hip hop"}	0	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Domino	\N	Trish	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
06c527ee-94d1-4bab-ac60-8c004e6bbee7	2022-06-01 04:56:56.691825+00	https://beta.catalog.works/dominosmusic/the-process-2020-	The Process	{rap,"hip hop"}	0	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Domino	\N	Trish	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0351842a-6994-46b2-86e5-361f8043bd8c	2022-06-10 03:25:01.828028+00	https://www.youtube.com/watch?v=L_TYdP4fCy8	$hook [Audio]	{"Tre' Amani",DMV,LostKids,Rap,Trap,Hip-Hop,Maryland}	3	\N	0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74	\N	Tre' Amani	\N	singnasty	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x52fA05393a003d234eFBA136E68DA835aeB64a26}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7c22f027-1776-4045-84a7-92e28ec71896	2022-06-14 18:23:37.504135+00	https://open.spotify.com/track/78ywqAbY9QktwlTHyc8c4I?si=3440373703684880	Elegant & Gang	\N	1	\N	0xacef50638be46aDcd6f5C7DFD9bf5894266794FC	\N	D-Block Europe	\N	harishm	{0x52fA05393a003d234eFBA136E68DA835aeB64a26}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
db28e281-1281-4c78-a3cb-429a676e24b6	2022-06-09 16:27:58.870674+00	https://open.spotify.com/track/2EpGUKbeWG99bJRMAzGYY6?si=f642c36e2c92440e	Dicey	{Ambient,House,"New York"}	2	\N	0xf93D8b05aA184F3b6B76D85418DBa1472735ED54	\N	Cofaxx	\N	henry	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7918139f-48c6-4bc5-8896-ebd1164577d5	2022-06-14 18:25:00.960265+00	https://www.youtube.com/watch?v=dqybjZxflro	Daily Duppy GRM Daily	\N	1	\N	0xacef50638be46aDcd6f5C7DFD9bf5894266794FC	\N	Yungen	\N	harishm	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
9ae095b1-6ce6-411e-baaf-8c8878593d3a	2022-06-09 21:21:33.358703+00	https://www.youtube.com/watch?v=qLQl5IX_G80	Awkward Freestyle	{"Eem Triplin","corner boy music",trap,awkward}	3	\N	0xfb3197Bd5b7F2E39c1e89B7619A697827eD2deff	\N	Eem Triplin	\N	\N	{0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
fa2409d3-560f-43a7-99b8-35a4b27f782e	2022-05-30 20:46:24.000803+00	https://geniuscorp.fr/cryptomusichistory	CRYPTO MUSIC HISTORY 2008 - 2022	{cryptomusic,musicnft}	3	\N	0x8C62dD796e13aD389aD0bfDA44BB231D317Ef6C6	\N	Mighty33	\N	Mighty33	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
96af09ad-246d-4e08-84de-068269ebfafc	2022-06-13 14:15:00.642963+00	https://open.spotify.com/track/4ko5AAQIPn6CFUTMMa1sOD?si=7Qf0CXu2TBOznZmA9cH9bw	Goof	\N	0	\N	0xb53B1DF71705aa51efe96FaB14c6B11763c9768F	\N	Reveal 	\N	Jelly	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
69bbf120-40bb-4078-90ff-5ba5e4a99078	2022-10-26 17:05:31.7403+00	https://youtu.be/1FSrkC7hafA	LS400	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Rapper Big Pooh	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
fcf6e3b8-68ab-4b7f-ad44-1bfc8c7e1de8	2022-11-01 17:45:40.022944+00	https://munsterrecords.bandcamp.com/track/my-love	My Love	\N	0	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Laghonia	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
57a68ab2-a36f-4a57-9a15-542f41a36c8d	2022-06-10 15:21:43.012778+00	https://open.spotify.com/track/08w1hnWW4GhVm61DoVojsY	Grace	\N	1	\N	0xa9A94e4718c045CCdf94266403aF4aDD53A2fD15	\N	Rag'n'Bone Man	\N	chidi.mishael	{0x52fA05393a003d234eFBA136E68DA835aeB64a26}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
43757190-798b-4017-89e3-f8c83553ff0a	2022-06-17 02:11:46.115998+00	https://open.spotify.com/track/316psfgQyeOKRKVltAV3kz?si=paRc6rZlTEOMeU4CRI5frQ	SWISH/USE 2 ft. Brent Faiyaz	{FLEE,Melodic,"Hip Hop"}	0	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	FLEE	\N	discoveringEs	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
26d1bf37-5ae6-4794-bb63-d7e1f86ec1cd	2022-06-17 02:14:55.005711+00	https://open.spotify.com/track/5LOm90AQvCbkge77907Wy2?si=6Cr8VGV1R02RkI1eYNlOKw	Retune Speed on 0	{Rap,Uptempo,Atlanta,ForteBowie}	0	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	ForteBowie	\N	discoveringEs	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f664f32b-c1df-452e-8e95-a815d90a79ad	2022-08-19 18:38:14.420073+00	https://open.spotify.com/track/48dhuuXSIRH40dLdfURue2?si=11148c4279f24234	Collateral Damage	\N	2	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	BXKS	\N	athenayasaman	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
afff1d62-0c5e-457e-8249-48fa77dae443	2022-06-14 18:23:09.822222+00	https://open.spotify.com/track/4z6aaeEo8nIGKeQwNIxTR1?si=13f58c3b6eaf4b89	96 Of My Life	\N	4	\N	0xacef50638be46aDcd6f5C7DFD9bf5894266794FC	\N	JME	\N	harishm	{0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x52fA05393a003d234eFBA136E68DA835aeB64a26}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b5c30d33-807d-4331-a6c4-b5cbf00c5a16	2022-06-10 03:46:44.054375+00	https://www.youtube.com/watch?v=C3v5cynxMGQ	Novacane x Frank Ocean (Freestyle)	{Deante'Hitchcock,Atlanta,Rap,Hip-Hop,Freestyle,FrankOcean}	3	\N	0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74	\N	Deante' Hitchcock	\N	singnasty	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x52fA05393a003d234eFBA136E68DA835aeB64a26}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7f281625-c1f5-4396-b0be-c3f059b07bb9	2022-06-16 16:19:32.242585+00	https://www.youtube.com/watch?v=qmCHCMlEvQ	Never Snitch	{arabic}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	$kinny	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
eb57390b-08c5-4f17-b376-0ec627d6b75e	2022-06-12 23:27:43.597727+00	https://www.npr.org/sections/world-cafe/2022/05/24/1100684558/lizzie-no-has-a-way-of-writing-songs-that-are-tender-incisive-gentle-but-intense	World Cafe (NPR Set)	{Live,🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Lizzie No 	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
338c0355-1e60-4a6a-9d35-4d80602581d3	2022-06-12 23:20:38.699027+00	https://youtu.be/hAD65VW5YUw	Kinto	{Instrumental}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	UJI	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4ce664d7-3670-4ee3-930e-9885021fc013	2022-09-06 15:51:51.533346+00	https://ipfs.moralis.io:2053/ipfs/QmYHc1ftbWHazeovAjJ4nBPAieDN9stsTuLngFiRCbPJEP	PRETTY LIGHTS	{"MAD DELTA","PROD. NOTORIOUS NICK",MARYLAND,"HIP HOP",RAP,"IT'S BMB",888MOMENT,BVLL,"AUGUST 2022"}	0	\N	0x1502F98D90cc10b11B994566dFC44EC84035eCE8	\N	BVLL, IT'S BMB, 888MOMENT	\N	Horace.eth	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f58c7f1c-9590-4daf-9496-726fb5bfa4b8	2022-06-16 13:08:23.576692+00	https://ever-ready-surfaces.com/	Ever Ready Surfaces	{🏴‍☠️}	1	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Joe Hamilton	\N	Ghostflow	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ff4000fd-b5ba-463e-b9fa-3b9a9f3eb59f	2022-06-23 14:21:43.86618+00	https://www.youtube.com/watch?v=6IVh2Ob8COM	MINHA QUERIDA	{"chill baile",baile}	3	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	Wealstarcks	\N	athenayasaman	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
832827df-e2cc-4088-8e41-e10ef5cccafb	2022-06-15 01:22:34.362054+00	https://cookinsoul.bandcamp.com/album/off-the-strength	 OFF THE STRENGTH (Album)	{CookinSoul,LordApex,UK,Rap,Hip-Hop,BoomBap,Album}	3	\N	0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74	\N	Cookin Soul & Lord Apex	\N	singnasty	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b6d43c38-7449-4ba7-a437-ecc38bc93e1e	2022-08-30 23:31:34.375885+00	https://open.spotify.com/track/7EYcMW8KqabkkNrbFF48kI?si=5afda3c1fe5443f7	Good as It Get	{Good$ense,Family,"Black Money Syndicate"}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Good$ense	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c82c0b64-a366-4917-b4fc-4d12f8a39d8d	2022-06-27 23:30:04.932657+00	https://youtu.be/CeW-Sn3E8Ag	JUST SAY THAT ft. Glorilla	{"Duke Deuce",Memphis}	3	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Duke Deuce	\N	discoveringEs	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x5ab45FB874701d910140e58EA62518566709c408,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a9824230-c2e0-4b68-9ebc-7c998e839bd2	2022-06-17 03:39:21.519666+00	https://youtu.be/tvY31eN3gtE	Point And Kill ft. Obongjayar	{UK,Rap,Nigeria}	3	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Little Simz	\N	discoveringEs	{0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7e5c3c21-25b1-44b4-9171-116d160f59c9	2022-06-17 16:37:02.473071+00	https://open.spotify.com/track/5jXkIfEuXtDo70a3KbmVUB?si=01874096f9534d6a	Lock it Up	{Punk,Pop-Punk,Rock}	2	\N	0xfFba44c15Fe2768bC2234078dfac8c5A651A56e9	\N	No Pressure	\N	AcidPunk	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e25d0477-417a-4c5a-88e3-dc7468d869b4	2022-06-27 23:08:19.792247+00	https://open.spotify.com/album/6To6T5lr8PLhCQ8ik3vPdv?si=nsfkdUxmSkWyPD94eiTlbQ	ALIEN	{BEAM,"Hip Hop","Dance Hall"}	3	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	BEAM	\N	discoveringEs	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7505bc67-9c63-4895-8126-694c9df01d3f	2022-06-23 14:18:50.788726+00	https://www.youtube.com/watch?v=ek0L7wh4Fe8	Blessings	{"hip hop",rap}	1	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	TiDUS	\N	athenayasaman	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
de74a2f2-b645-4899-861a-4ef4d656c372	2022-06-13 14:21:02.801621+00	https://open.spotify.com/track/51qw9DAEYn0RS23LtwZU84?si=HOOzQ2MUQLmAx-Cki3OJZw&context=spotify%3Aplaylist%3A37i9dQZF1E8OdDVkNxqT2W	Barry Can’t Swim 	{🏴‍☠️}	3	\N	0xb53B1DF71705aa51efe96FaB14c6B11763c9768F	\N	El Layali 	\N	Jelly	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x52fA05393a003d234eFBA136E68DA835aeB64a26,0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ceb3c4c6-c449-443c-8c19-6f49854311d1	2022-06-22 17:19:13.361619+00	https://music.apple.com/ng/album/sweetest-taboo/1609415230?i=1609415239	Sweetest taboo	\N	2	\N	0xbD69B5984b3CDEbC5307a9D34103F4CfD7C9fBb9	\N	GCN	\N	\N	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x52fA05393a003d234eFBA136E68DA835aeB64a26}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f8271777-a4b8-49ad-bf6b-a3ee8201dc4f	2022-06-27 23:17:35.579113+00	https://open.spotify.com/track/4k0kI3nDzSOTGzQUTDnCpC?si=fd054f6a388d4df3	profile	{Kinrose,"Hip Hop",DMV}	1	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Kinrose	\N	discoveringEs	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
56ba922d-e4ce-4e6f-8ea2-ef2c7d42995a	2022-06-16 16:31:14.511552+00	https://www.youtube.com/watch?v=lPBvHkDDNhI	Gassed Up	{plug}	3	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Nebu Kiniza	\N	future modern	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x52fA05393a003d234eFBA136E68DA835aeB64a26,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6e2f3ff2-64a2-4985-ae4d-5ba7d0b7ade9	2022-08-27 01:31:26.602309+00	https://www.youtube.com/watch?v=O-eLWMvVA6c	CHANCE OF FLURRIES	{INSURANCEPLUSDENTAL,KARMALOOP,OLDNAVY,RUNMYFADE,STRANGEVOICE,STRINGCHOICE,CHANCEOFLURRIES,ADHOMINEM,DREAMOFLABOR,SHATTER,STAINYOURHONOR,FORGIVEMEFATHER,DOLCILAB}	1	\N	0x8d5fb8Aca8294FC9A701408494288D2d7de42F7E	\N	THERAVADA	\N	\N	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7b461685-5e02-4df2-ba81-bfe1ddb06285	2022-06-17 14:16:54.255183+00	https://www.youtube.com/watch?v=oEJ7JT29btA	Sting	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Zinadelphia	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2d046aee-9788-4748-b421-6b2ae52820f2	2022-06-27 23:40:15.755848+00	https://youtu.be/gpwYTeRSgc8	GOOD TIMES / PROBLEMZ	{JUNGLE,Groove,Disco}	3	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	JUNGLE	\N	discoveringEs	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f01b066f-b4ca-43e6-8ece-3296d355b95a	2022-06-17 17:05:53.218765+00	https://soundcloud.com/itsr3llofficial/sticky-r3ll-remix	Sticky (R3LL Remix)	\N	3	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	R3LL	\N	Ghostflow	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xfFba44c15Fe2768bC2234078dfac8c5A651A56e9,0x2C9836105e6a314764950272be379fe794Ec69A9}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
aca49766-e40f-4cd9-b76d-fa459b5d93f9	2022-06-23 14:44:04.305513+00	https://www.youtube.com/watch?v=UGmaeSbdhrw	Mantra	\N	3	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	Makaya McCraven	\N	athenayasaman	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a0e7cbb4-fdc5-49ad-bfbb-a1bc357064b0	2022-06-23 14:28:01.199272+00	https://www.youtube.com/watch?v=m_mANAZAZBo	Mash up the Dance	\N	3	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	Watch The Ride, Nia Archives	\N	athenayasaman	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
08068d6f-d67e-4ff7-b5f4-870b77817339	2022-06-27 23:23:36.150809+00	https://open.spotify.com/track/1YfMIYpgvfjhtSX8E4MWya?si=954ff0fd09f847ac	a really damn long day	{Pop,"Gus Glasser",Indie,R&B}	2	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Gus Glasser	\N	discoveringEs	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1c7cd953-87ae-4364-9a9c-e388e1e14333	2022-06-17 03:35:05.056008+00	https://youtu.be/wZiPs0vqFFU	Same Old Ways	{R&B,UK}	2	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Ama Lou	\N	discoveringEs	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4cf72e7d-dbb7-4873-969f-7d6afdb46a73	2022-06-17 02:18:17.952723+00	https://open.spotify.com/track/3l3Vw7XixEZtDyarJH347d?si=zJLDRoc1QdeYek8JcV8rbg	Explict	{Rap,"West Coast","Coast Contra",Lyrical}	2	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Coast Contra	\N	discoveringEs	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ae224660-280f-4295-9299-ad0f62fa56e1	2022-06-17 02:16:46.481608+00	https://open.spotify.com/track/4eYLwnZeOr8FujAqTxeoQc?si=KIbhCUL0QkW0Uz_ld9c4rw	Merlot	{r&b,"slow burn",smooth}	2	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Jamilah Barry	\N	discoveringEs	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
283160c4-b439-4693-8581-24df72e2eecd	2022-09-09 19:13:29.656321+00	https://youtu.be/-6kPJulgYNg	Players Anthem	{"Premo Rice","The Bishop","Maryland Mac",Makintsmind}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Premo Rice	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6ee3116c-c022-453c-b262-46d31eecd794	2022-06-28 19:05:25.215054+00	https://www.youtube.com/watch?v=C9cS8b0gD2E	Foolish	\N	0	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	Natanya Popoola	\N	athenayasaman	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
94ff9676-6f39-4a98-b200-7e3ad8683abf	2022-07-11 17:53:08.368023+00	https://www.youtube.com/watch?v=fY5AXzCeNRk	My Shadow	{rock,buffalo,"new york city"}	3	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	Quinton Brock	\N	athenayasaman	{0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
64497aa9-6d84-44d7-82b3-de83b41d9e4e	2022-06-27 23:12:02.599008+00	https://youtu.be/uCEv2NMr46E	The Highs & The Lows (2022) ft. Joey Bada$$	{"Chance the Rapper",Chicago,"New York","Hip Hop"}	3	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Chance the Rapper	\N	discoveringEs	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4ecacf34-2781-48ff-976c-18315f8da6c1	2022-10-26 17:10:06.341174+00	https://youtu.be/-KgeqmIj4KU	Mask On	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Sampa The Great, Joey Bada$$	\N	hallway	{0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
17bfa666-348b-44e2-b545-6e331f58c6fa	2022-06-28 19:08:10.430351+00	https://www.youtube.com/watch?v=JxGcOHNgMm0	Jah Knows ft. Knucks, Guiltybeatz, & Kyra	\N	5	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	Nesta	\N	athenayasaman	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0x52fA05393a003d234eFBA136E68DA835aeB64a26,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
701a2f43-f908-435f-8354-23355e05baee	2022-08-28 15:20:38.600189+00	https://open.spotify.com/track/6JNWW04efhUMFnP035ddYQ?si=2740c3bee04044e6	No Punchlines	{Nines,"UK Rap",CRS,Makintsmind,"Trap Rap"}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Nines	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
dcba7053-b998-48f9-865a-a3958336cd72	2022-06-28 19:14:34.747598+00	https://www.youtube.com/watch?v=7YPWM6ckOT4	Almost Went Too Far	{jazz,"uk jazz"}	3	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	Joe Armon-Jones	\N	athenayasaman	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f16379e8-38d6-41f8-96b9-fb12ee863fca	2022-06-28 21:24:49.275326+00	https://open.spotify.com/track/0MKb6jtMMFY0FZNg6P3dAI?si=a461198646b844d1	Divine	{Lofi}	0	\N	0xa52B442bfeca885d7DE4F74971337f6Cf4E86f3B	\N	BLVK	\N	Timer°°	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
33fc8a7f-c105-46f2-bd47-229be7c71847	2022-07-05 15:27:06.064649+00	https://open.spotify.com/track/22CjVpcH29cyyXljhLAPew?si=a2606aec7db84ee6	re	\N	0	\N	0x7bAc7a7f036e944Cc7fa04090FBb125253B63784	\N	re	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2074dd04-bbb5-43cb-83ed-91cdc59ab9d4	2022-11-01 17:46:17.665457+00	https://munsterrecords.bandcamp.com/track/and-i-saw-her-walking	And I Saw Her Walking	\N	0	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Laghonia	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
422a7d60-5248-4ef1-afa9-663316fc246f	2022-06-28 02:45:15.236977+00	https://youtu.be/r-gkSte4QdA	Adekunle Gold: Tiny Desk (Home) Concert	{"Adekunle Gold",Afrobeats,Nigeria,"Live Music"}	3	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Adekunle Gold	\N	discoveringEs	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
36818c72-21b3-403f-98c7-a2f2d71ac5af	2022-06-29 14:29:09.027337+00	https://opensea.io/assets/ethereum/0x56e48e7b75e5d1a8414a8781cc743d5c904ca00d/413	The Ghost of Frank Dukes 👻	{🏴‍☠️}	0	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Frank Dukes	\N	Ghostflow	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0195abf1-469d-4656-9989-1479560ef016	2022-08-27 01:04:33.892513+00	https://www.youtube.com/watch?v=IC51N9xKd94&list=PLvwgS-uCoxIhfSUjXaAMgWjGxptYUpJJJ&index=109	DIGITAL HEARTS	{KEEPITSOLID,REMINISCENT,FELLVICTIMTOALADYFROMTHELIBERALARTS,PIVOTAL,MISSOURIMOTEL6,ITSALWAYSWHOYOUTHINKITIS,STUPIDSAMPLE,VANDALIZING,TANTALIZING,ANALYZING}	1	\N	0x8d5fb8Aca8294FC9A701408494288D2d7de42F7E	\N	DJ LUCAS	\N	\N	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
fb4c9e52-43cb-4306-9bf5-7351a06eff3e	2022-07-03 07:19:40.189279+00	https://open.spotify.com/track/22CjVpcH29cyyXljhLAPew?si=f7b3acccecea4318	Bad Apples	{Dark}	1	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Object	\N	Keenboo	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
06344e6e-ec5e-4c37-a646-8cdc9ee9c469	2022-06-30 15:12:19.759463+00	https://www.spores.vision/	Spores	{🏴‍☠️}	0	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Various	\N	Ghostflow	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d0ed62df-fc33-462e-af04-848cdcab57cc	2022-08-19 21:23:40.45137+00	https://open.spotify.com/track/4vI2KCvXTAPR3vfiWg1J78?si=hYA0vssiQ7Gs9ejGuqoyVw	Terminator	{Afrobeats,Amapiano}	3	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Asake	\N	discoveringEs	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1d44c783-b3b4-4a7d-8319-04fdf767b309	2022-04-21 14:33:25.021957+00	https://youtu.be/xkBr67Fxybk	Gaslight	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	INJI	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3d57439f-6fa7-4ff1-81f7-f9c065866bc2	2022-05-04 02:19:04.182054+00	https://youtu.be/ww6ykF2ktaI	FNF	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Glorilla & Hitkidd	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
07b009b3-4e64-4846-b521-e712892ecd52	2022-07-01 18:14:26.115527+00	https://youtu.be/vr2xMRSObto	Earth is Ghetto	\N	4	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Aliah Sheffield	\N	Trish	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5,0x52fA05393a003d234eFBA136E68DA835aeB64a26}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
343ee5ba-d171-41b0-b261-570232eaa138	2022-07-05 18:39:03.477962+00	https://www.youtube.com/watch?v=VTRRHQ4bjWU	Wheele	\N	2	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	Anunaku & DJ Plead	\N	athenayasaman	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
9f6e53dd-24dc-45d9-ae45-03516fa32953	2022-04-27 19:07:02.518388+00	https://youtu.be/9T-fLIl6of0	On My Mind	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	midwxst	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d27f6b7b-82a2-4991-b42c-0d2a0789c3f2	2022-04-29 18:42:21.25741+00	https://youtu.be/MnTeiyjJqy8	What It Do	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Sauce Walka	\N	hallway	{0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a8faf688-826b-4222-9763-1295473cd35e	2022-06-17 02:10:05.467195+00	https://open.spotify.com/track/3aw8jokbWLL3Zi089H1vwu?si=nRBx-LKsQTee-zLV3rB4_Q	Kumama	{production,afrohouse,"ike slimster"}	2	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Ike Slimster	\N	discoveringEs	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
76a3a2fa-2877-4c80-abcd-1f5fc90b592b	2022-06-28 21:25:40.313182+00	https://open.spotify.com/track/21IiEw3SqSLLcMmPQt44zC?si=ad608f4d00fc4590	1995	\N	0	\N	0xa52B442bfeca885d7DE4F74971337f6Cf4E86f3B	\N	CoryaYo	\N	Timer°°	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4eabd4a3-d359-4456-86aa-f054815040e0	2022-07-11 18:08:24.473352+00	https://tangents.bandcamp.com/track/exaptation-2	 Exaptation	{experimental,quartet,sydney,improvisation,electronic}	0	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	Tangents	\N	athenayasaman	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
cc88f3ba-8e04-44f5-865e-e748a3a4ce4a	2022-08-28 17:42:05.35248+00	https://www.certifiedmixtapez.com/Main/Details?refId=f6f05968	PAPAYA SALAD MERCHANT 	{GOLDENCHILD,STARKER,PAPAYASALADMERCHANT,SAMPLEBEFOREACTIONBRONSON,THECHAIRMANSINTENT,SAMPLESTORY,SAMPLEOFSOUL,ONUMASINGSIRI,MAEKHASOMTAM,SUCKER4SAMPLES,BACKSTORY,DIDITFIRST,DIDITRIGHT,PUTYASPINONNIT,TRACK09}	2	\N	0x8d5fb8Aca8294FC9A701408494288D2d7de42F7E	\N	STARKER	\N	\N	{0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
96abb06a-c833-41f7-9cbb-140cbc205f0a	2022-07-17 14:07:02.27266+00	https://www.youtube.com/watch?v=9fZTpMiCxN8	MAD	{ghana,accra}	4	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	SuperJazzClub	\N	athenayasaman	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x52fA05393a003d234eFBA136E68DA835aeB64a26}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
34e5a068-72ba-4647-b85d-bcbfd221025c	2022-08-19 20:08:43.497838+00	https://youtu.be/TpXbVbY8S-8	Out Here	{"Music Video"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	The Homies	\N	hallway	{0x52fA05393a003d234eFBA136E68DA835aeB64a26}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a976bc19-4e1e-421b-aec2-fd7311d9138b	2022-07-13 06:20:27.407602+00	https://soundcloud.com/kholgray/glimpse-7-10-22-mixdown/s-CC7CcSs3ZnU?in=kholgray/sets/childish/s-rJTclRTALJX&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	Glimpse	\N	1	\N	0xd7E422083C3D6Cb923Bc44754Fad0dD1D1bF46d9	\N	Ayotemi, Zalma Bour, Floro	\N	jamesroeser	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a929e6ea-feb1-4e42-ab7a-6eadce09c83a	2022-07-13 06:22:15.571269+00	https://open.spotify.com/track/3hSEuBI1CJ1wDseqWztRB5?si=ce2da1f51f8b48d1	Sideways	\N	1	\N	0xd7E422083C3D6Cb923Bc44754Fad0dD1D1bF46d9	\N	Daniel Hex	\N	jamesroeser	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
cd1d05db-d67d-4093-b97b-01f387fb3c60	2022-07-17 01:40:50.489776+00	https://www.youtube.com/watch?v=4t1zDhu6_FU	Been Broke	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Tobe Nwigwe, 2 Chainz, Chamillionaire	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
65d66014-2e74-4918-8dc9-05a03232c7b0	2022-10-26 17:22:07.819484+00	https://youtu.be/qfgxE1Kd45k	Pop Star	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Teller Bank$, Rent Money	\N	hallway	{0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
bdada368-2abd-4ca0-8dfd-3f8e0257aab8	2022-07-14 13:56:28.727507+00	https://open.spotify.com/album/6xafM0XsHSc9ix0gyliT7C?si=QwN2JFgbSUuYE_d_uqc0lQ https://open.spotify.com/album/6xafM0XsHSc9ix0gyliT7C?si=QwN2JFgbSUuYE_d_uqc0lQ	Energy	{"drink sum wtr"}	3	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Aundrey Guillaume	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x52fA05393a003d234eFBA136E68DA835aeB64a26,0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3f1b43e4-12eb-4164-86a4-91e0bf16d0fa	2022-11-01 17:47:04.645322+00	https://munsterrecords.bandcamp.com/track/glue	Glue	\N	0	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Laghonia	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f8f23130-7833-4c06-ae07-33946359dcfa	2022-04-12 23:00:39.032726+00	https://soundcloud.com/tulengua/mental-kamrie/s-lttqwn5MbIr?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	Mental	\N	5	\N	0x2d9c9c342E892191B6c0DEFC0C85b1f00E2763a7	\N	Kamrie	\N	\N	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x67A276b6768978C9E41Af5418E09Efc8a12a28dE,0xb53B1DF71705aa51efe96FaB14c6B11763c9768F,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ce0cdedd-2954-4226-9891-8c2a2d78359c	2022-07-14 23:06:11.564477+00	https://youtu.be/RNlLKrKCQ-o	One In A Million 	\N	0	\N	0x579a79a9a199Ebd8a793BbB1F33fa709Ad38fadE	\N	Ron Wayne 	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4064fea4-5cae-473e-972e-7a3aeabb45d1	2022-07-13 13:53:31.279169+00	https://create.zora.co/editions/0x2df53f0f4ad5e26fb71e67d39889ecfac984dd1c	L0-Strip 1 (Opening Credits) 29	{Zora,ZoraCreate,VisualArt,MultiMedia,GREGNWMN,YoursTruly.,JAH,OpenEdition,Soundtrack}	3	\N	0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74	\N	Yours Truly. x GREGNWMN	\N	singnasty	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x52fA05393a003d234eFBA136E68DA835aeB64a26,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f76cfa4f-aa16-4972-a67e-e2d2fae7aafd	2022-08-30 23:25:03.723013+00	https://open.spotify.com/track/44oIIykB9cMhzLCPC0saU7?si=34c8f6498dce4f2a	Chess Moves	{Good$ense,OTB,"New Orleans"}	1	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Young Roddy ft King Ikeem	\N	MakintsMind	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
84118902-b61f-4606-aa3c-8bef357fe551	2022-05-31 15:29:04.352841+00	https://open.spotify.com/track/5iNvnrGvOV6J17eUUc0skt?si=853c05ed6dd54693	Intensive Snare	\N	4	\N	0xacef50638be46aDcd6f5C7DFD9bf5894266794FC	\N	Plastician ft Skepta	\N	harishm	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
79602396-762f-4a9a-a472-8c009ab0d30e	2022-07-18 11:54:09.633389+00	https://open.spotify.com/track/6oPHIxQgRXSQxUbWTNAeNh?si=ef02d4d4636d40a9	Yes I Am	\N	1	\N	0x3a3297881e9904d0463fec7Acd9d6d34b915dCB7	\N	pg.lost	\N	ishannegi	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7392b5e4-af80-4faf-84a9-806fc4f4aec2	2022-07-12 18:41:22.596653+00	https://soundcloud.com/draftday1/draft-day-put-it-up?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	Put It Up	{reggae,sample,rap,drill,"draft day"}	0	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	Draft Day	\N	lifeofclaude	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e75f3653-ef6a-4a5c-92df-b234fc43fcbc	2022-06-02 03:26:23.567802+00	https://soundcloud.com/luluroseofficial/crazy-for-you?in=luluroseofficial/sets/silky&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	Crazy For You	{"lulu rose","self composition",jazz,soul}	4	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	LULU ROSE	\N	lifeofclaude	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0x1502F98D90cc10b11B994566dFC44EC84035eCE8,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6398ad42-47d4-41a0-a0b7-8d7f1982b125	2022-07-14 14:12:15.435044+00	https://soundcloud.com/ikeslimster/drakedownhillrefix-mp3?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	DRAKEDOWNHILLREFIX	{"Ike Slimster",Drake,Production,Experimental}	3	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Ike Slimster	\N	discoveringEs	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4efe27e7-52d3-4360-b183-fd2b0edae587	2022-11-11 14:00:52.377284+00	https://duvaltimothy.bandcamp.com/track/plunge	Plunge	\N	3	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Duval Timothy	\N	\N	{0x371107cc397a1fd11fd5a7ac8421a3e43f886444,0xf75779719f72f480e57b1ab06a729af2d051b1cd,0xef58304e292fbaeacfdec25b67b3438031fde313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d73ccaaf-33ff-4048-a620-b38fdc49f840	2022-10-26 17:28:24.617875+00	https://youtu.be/CUYFO5_Xr-I	Cain and Abel	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Teller Bank$, Ed Glorious	\N	hallway	{0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
891bc06c-f8bf-4ffd-b5f4-26472c0b9f36	2022-06-28 19:10:50.247288+00	https://www.youtube.com/watch?v=dPf24Js6aaI	Damaged Feelings	\N	5	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	Neemz	\N	athenayasaman	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74,0x52fA05393a003d234eFBA136E68DA835aeB64a26}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
992fa1cb-af4b-493e-a5b5-4ae7d6453721	2022-05-02 19:29:49.221167+00	https://youtu.be/vkmpoVjwpng	Sailor Moon	\N	5	\N	0x00daEbab128f5CFc805D75324c20c6fEaf6B26b2	\N	LAYA	\N	Sirjwheeler	{0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x67A276b6768978C9E41Af5418E09Efc8a12a28dE,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x52fA05393a003d234eFBA136E68DA835aeB64a26}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
661ce2ae-f5ed-43d0-a526-4cbecb83b283	2022-06-19 02:11:05.133398+00	https://gardens.feltzine.art/	Gardens of Felt Zine Delights	{FeltZine,NFT,DigitalArt,Generative}	3	\N	0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74	\N	FELT Zine	\N	singnasty	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x1d14d9e297DfbcE003f5A8EbcF8cBa7fAEe70B91}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b2c1b126-95e5-4afa-bd80-df5ae3307372	2022-08-19 20:13:23.441016+00	https://youtu.be/bxtHJXJz_5A	For Tonight	{Visualizer,"Good Job Larry"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Larry June, Syd	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
5e2b9875-69ff-4fac-ac49-b876611d64ed	2022-07-12 18:42:38.946429+00	https://soundcloud.com/guapdad4000/alpha?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	Alpha	{guapdad,"scam rap","hood shit",sonnet,"classical music"}	5	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	Guapdad 4000 	\N	lifeofclaude	{0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x1d14d9e297DfbcE003f5A8EbcF8cBa7fAEe70B91,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x52fA05393a003d234eFBA136E68DA835aeB64a26}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c33a218f-bdb6-4a19-baef-1c3a8ec83273	2022-11-01 17:47:36.507353+00	https://munsterrecords.bandcamp.com/track/bahia	Bahia	\N	0	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Laghonia	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a4d5193d-bd25-4d5a-be0a-6dd79278a9ad	2022-05-02 19:32:18.027401+00	https://youtu.be/kkoSOeel9yE	The Mission	\N	4	\N	0x00daEbab128f5CFc805D75324c20c6fEaf6B26b2	\N	Bakar	\N	Sirjwheeler	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
bcad115d-b158-47e2-ba5c-033f7a2f9182	2022-07-25 14:53:42.564921+00	https://open.spotify.com/track/6MsEajhvcMbnuWXT1y6HL2?si=1493d85e6484427d	No Matter	{"Breven Kim","No Matter"}	0	\N	0x7D8059e9721Ef92CCBa605775D1A7F6d8eF146c9	\N	Breven Kim	\N	peak.less	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
301e18c3-10da-4e07-91b2-74b84ff048c3	2022-07-25 14:17:08.804672+00	https://open.spotify.com/track/5CbX4a6s3B0sBKAVHSNGTo?si=1c1838a135c24559	strongboi	\N	1	\N	0x7D8059e9721Ef92CCBa605775D1A7F6d8eF146c9	\N	strongboi	\N	peak.less	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
94a4be74-e5f9-4431-b6b7-f7378b03e968	2022-07-25 14:04:08.260132+00	https://open.spotify.com/track/3EedXwPKa8RQdWDwPL3Rxx?si=9b97f3d250324ccb	Violation of the Mind	{"Alt Pop",Berlin,Groove,Alternative}	1	\N	0x7D8059e9721Ef92CCBa605775D1A7F6d8eF146c9	\N	Mirrors for Princes	\N	peak.less	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ce44d106-8f45-4cdf-be41-22b738acab74	2022-09-08 05:47:37.296585+00	https://www.youtube.com/watch?v=i93-hlwULUk	Fever	\N	1	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Little Willie John	\N	future modern	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
423ceee9-67e6-4e33-b487-613ebd023a96	2022-07-21 16:19:20.560599+00	https://youtu.be/lztekkV1ZKQ	The Vision	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Maxo Kream, Anderson PAAK	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b2a089ec-0715-4cd1-8d04-b21a3789f15a	2022-07-24 22:40:12.769658+00	https://youtu.be/nGHlJRFMjmM	If I Get Caught	{"OVO Sound"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	DVSN	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
69d44196-589c-4b9e-937f-d7a53ff6ff19	2022-07-24 22:46:48.293111+00	https://youtu.be/AMTWsIst-KY	7 Hours	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Wakai	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f2a6d753-b5be-4219-88c6-a0f97fb80757	2022-08-28 13:40:15.103203+00	https://open.spotify.com/track/48KjqtDc37Ws6SaeG9zKjL?si=a3635b6492d14734	Milliseconds	{#Threesome3,#makintsmind}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	HusKing Pin	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
16d13ac1-e2d2-4268-83ec-c7d821d3fde8	2022-09-14 02:44:58.196755+00	https://open.spotify.com/album/6D8N662VkQzE7fkKD5ca0Y?si=2tj2AX8XSpKtcLEWH2ZC3Q	Fall Apart	{EP,Rock}	0	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Amber Ryann	\N	discoveringEs	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
81ac9e7f-f9b7-4add-9bee-a5e6cf682fce	2022-07-25 14:16:13.586467+00	https://open.spotify.com/track/5QZqQSNkvDFfPRQELiUFxV?si=6cbccf3997044911	Leather Free Seats	{"Lil Seyi",RnB,"Bedroom Producer",DIY}	3	\N	0x7D8059e9721Ef92CCBa605775D1A7F6d8eF146c9	\N	Lil Seyi	\N	peak.less	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f25a9406-6c9e-404f-bc4f-82c572a38061	2022-09-09 19:16:06.920616+00	https://youtu.be/qbLynfKGBMM	Rubberband Man 	\N	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Premo Rice	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2fe8d717-1273-472c-bbb2-3750509084fd	2022-07-25 14:59:55.392477+00	https://open.spotify.com/track/1TQPnxJI10zAtGuFeCLtGs?si=c756da3dec864497	Say What You Want	{"Daniel Allan",DEEGAN,Hyperpop,"Ultra Bass"}	0	\N	0x7D8059e9721Ef92CCBa605775D1A7F6d8eF146c9	\N	Daniel Allan, DEEGAN	\N	peak.less	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8c33a3b5-677f-4d32-a402-066792cd29b7	2022-07-25 14:19:43.450564+00	https://open.spotify.com/track/70mgOSaBp9RDin8xrbKOUr?si=4a967df165ee43fc	Sick & Tired	{"Lime Garden",Indie,"Sick and Tired",Brighton,"United Kingdom"}	1	\N	0x7D8059e9721Ef92CCBa605775D1A7F6d8eF146c9	\N	Lime Garden	\N	peak.less	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
148e38e1-6da7-46bc-9af4-913960a54b34	2022-06-27 16:02:46.567645+00	https://youtu.be/iE25hx5ihIk	Blackout (Glastonbury 2022)	{🔦,Turnstile,"Live Music"}	3	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Turnstile	\N	hallway	{0x52fA05393a003d234eFBA136E68DA835aeB64a26,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
dde1291e-70e2-46a8-95df-4ae6b972ceda	2022-08-19 20:43:43.404013+00	https://youtu.be/plmI1P42rZc	Bandwagon	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Declaime, Madlib	\N	hallway	{0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e886ca58-17c2-486f-9350-6713202d88ed	2022-04-20 20:02:35.603919+00	https://soundcloud.com/brissdontmiss/grace-park-legend-norfside?in=brissdontmiss/sets/grace-park-legend-deluxe	Grace Park Legend (Norfside)	{la,"cali swag","dope samples","los angeles",bompton,"low rider","car music","heavy bass"}	2	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	HUEY BRISS	\N	lifeofclaude	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b4a5c627-2455-4604-9bf3-a722ab5e100c	2022-09-02 23:48:25.678245+00	https://open.spotify.com/track/3rG6VPI8QPN64ER0QOUqUL?si=f8f6c2b82cce4214	I'm Him	{"New Rap","West Coast shit"}	3	\N	0x2dD3FefF13B61C98a792DB20a7971106e3352A7B	\N	Larry June	\N	\N	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
583b271a-1453-42a4-a544-e6268b7cf485	2022-09-09 19:17:13.828887+00	https://youtu.be/r87-9F1TunQ	Unsolved Murder 	{Khalas}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Snap Capone	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
142216be-f092-4c72-9ee6-40654bc08ffb	2022-04-30 18:25:18.266206+00	https://www.youtube.com/watch?v=g8SVsEgrygY	Just Coz	{🔦,Giggs,UK}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Aitch, Giggs	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4768e473-3703-40eb-8dd5-3a1e9b999ed6	2022-09-06 15:54:11.022397+00	https://ipfs.moralis.io:2053/ipfs/QmYHc1ftbWHazeovAjJ4nBPAieDN9stsTuLngFiRCbPJEP	PARADISE BY IT'S BMB	{"IT'S BMB","MAD DELTA","HIP HOP","EAST COAST","PROD. NOTORIOUS NICK",MARYLAND,BALTIMORE,"WASHINGTON DC",RNB,R&B}	0	\N	0x1502F98D90cc10b11B994566dFC44EC84035eCE8	\N	IT'S BMB PROD. NOTORIOUS NICK	\N	Horace.eth	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
28410b2d-cd0f-4087-b7e6-79319aa0d728	2022-06-10 03:28:08.063756+00	https://www.youtube.com/watch?v=kZ4C3xNMyI0	Naira Marley: Tiny Desk (Home) Concert	{NairaMarley,Nigeria,Marlians,TinyDesk,AfroBeats,Rap}	4	\N	0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74	\N	Naira Marley	\N	singnasty	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x52fA05393a003d234eFBA136E68DA835aeB64a26,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x5ab45FB874701d910140e58EA62518566709c408}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e2b4efbe-1ee8-4523-b620-e624b54a3c3f	2022-07-26 21:23:44.139416+00	https://open.spotify.com/track/2w5ZvWh4KHgPFVmEVqViI9?si=jKVIBsV1Q9KTa8T4dhCj8A&context=spotify%3Aplaylist%3A37i9dQZF1E8MAoEN8DBPmB	Life and Echo	{🏴‍☠️}	3	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Lomeli	\N	Ghostflow	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
9b301c81-c1dc-4289-b5f5-aa91062e87b2	2022-08-04 06:58:57.920967+00	https://soundcloud.com/chillchildren/junyii-ovrds	o v r d s	{asap,rocky,slowtempo,hazy}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	junyii	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
80b83e08-9e3e-480c-acce-89a5b856aa7c	2022-08-04 07:01:23.084406+00	https://soundcloud.com/jarjarjr/love-me-tender	love me tender	{lofi}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	ｊａｒｊａｒｊｒ	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
41377439-a0d0-4df2-b0a3-f860e25a7fbd	2022-07-25 14:52:24.38587+00	https://open.spotify.com/track/76nKkLXCAoJwnjUylYic4D?si=a99e09f9ed6143bb	You Up?	{"Johan Lenox",Orchestral,"You Up?"}	3	\N	0x7D8059e9721Ef92CCBa605775D1A7F6d8eF146c9	\N	Johan Lenox	\N	peak.less	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e8e11159-85e0-4444-9c63-17e00685dfdc	2022-10-26 17:44:02.303533+00	https://youtu.be/KsAMDOKX6UQ	Supernatural	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Teller Bank$, Ed Glorious	\N	hallway	{0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e3786d46-c7c0-454b-8f13-8c4c39a133a7	2022-05-31 20:01:04.676403+00	https://opensea.io/assets/ethereum/0xd5d0bb6b5e6dd29055271b5ea9d2d746c66ce98d/1020847100762815390390123822295304634390	Password	{r&B}	1	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	TK the Great	\N	Trish	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e01dda74-2d99-4b97-b3d0-b3fd7091b508	2022-09-09 19:52:06.056656+00	https://open.spotify.com/track/3l6D0NUQn6Ttyz5ePSPk5w?si=702f6608c22c4b09	Bang	{🏴‍☠️}	3	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Chaz French	\N	Ghostflow	{0xb60D2E146903852A94271B9A71CF45aa94277eB5,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
135e84db-49f9-490e-8ff3-79e6d77f6a4d	2022-11-01 17:48:25.52379+00	https://thecasualdots.bandcamp.com/track/high-speed-chase	High Speed Chase	\N	0	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	The Casual Dots	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
378ba509-21a2-4156-b4db-c98f21cae912	2022-08-19 21:17:08.822476+00	https://open.spotify.com/album/4X5ASi7GO7EBR9yIuRri0S?si=zFMIBBGATN-LsHYM4JpAjw	Phone Calls Gimme Anxiety	{"Hip Hop",EP}	3	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Peter $un	\N	discoveringEs	{0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2880b6b4-d502-43f9-986e-e700d31084e9	2022-10-26 18:03:30.172723+00	https://youtu.be/Pgl9yMorjvk	It's Me	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Taleban Dooda	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
46b4f8dc-7364-4e2a-9388-0a937e62b7fb	2022-07-05 20:58:53.00841+00	https://www.youtube.com/watch?v=kwAezs4L8GY	FLOSS | a film by Mike Melinoe	\N	3	\N	0xcE012cA872B9856d006ea51500D56fD7F2f01b38	\N	Mike Melinoe	\N	mikemelinoe	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3b4fbe35-c29f-4ef3-8d75-00774ade1963	2022-09-03 11:30:15.013812+00	https://youtu.be/Kj5wQJcpRIQ	Laughing Stock	{Homerton,UKRap,Makintsmind}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Kay-O	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
51991932-dab5-4b34-85de-3242d7f29e06	2022-11-01 17:49:32.48177+00	https://thecasualdots.bandcamp.com/track/velvet-fields	Velvet Fields	\N	0	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	The Casual Dots	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ca542c3b-bb56-43ae-91f5-1eac6edcb2ea	2022-07-25 20:41:04.359004+00	https://open.spotify.com/track/6XeFSQd5hMclo2nxUgZR2d?si=0270f5b040214298	Share Ur Feelings	\N	1	\N	0xd7E422083C3D6Cb923Bc44754Fad0dD1D1bF46d9	\N	Junior Varsity	\N	jamesroeser	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
cb9461e5-e53f-47f0-a40e-6ba3b77477f8	2022-09-06 15:56:43.09384+00	https://ipfs.moralis.io:2053/ipfs/QmYHc1ftbWHazeovAjJ4nBPAieDN9stsTuLngFiRCbPJEP	40 MILLI BY IT'S BMB & DESCENTIVE	{MARYLAND,"MAD DELTA","PROD. NOTORIOUS NICK","HIP HIP",RAP,DESCENTIVE,"WASHINGTON DC",BALTIMORE}	0	\N	0x1502F98D90cc10b11B994566dFC44EC84035eCE8	\N	IT'S BMB & DESCENTIVE PROD. NOTORIOUS NICK	\N	Horace.eth	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
15f67497-c02d-49ac-afee-2fde9321cac5	2022-07-27 15:11:06.812346+00	https://youtu.be/MrJl1Pskxvs	BEAM	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Slay Squad	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2179d5eb-8dd4-48c5-9c52-cdb1e690597a	2022-07-31 15:50:52.036169+00	https://youtu.be/Tl8NTrrgm3A	Don't Come Back 	{Soul,🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Lava La Rue	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1b2f1fdf-7a74-4107-a0a8-386991c5ac31	2022-08-02 22:26:20.527654+00	https://soundcloud.com/bignumbanine/ten	Ten	{"boom bap","car bop","ride out"}	1	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	BIGNUMBANINE	\N	lifeofclaude	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
27947066-262f-4a18-9bcf-736f6958086c	2022-08-02 22:24:46.068385+00	https://soundcloud.com/temsbaby/no-woman-no-cry	No Woman No Cry	{tems,cover,"bob marley"}	0	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	Tems	\N	lifeofclaude	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
cb443928-133e-442e-ad18-79da600272f5	2022-08-02 22:21:27.24381+00	https://www.youtube.com/watch?v=e4oKKSbFM9U	BQE 	{bqe,"nyc rap","boom bap",ock,"bodega rap"}	0	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	OJZ feat. Sean Hawkins Jr & Mid-Nite	\N	lifeofclaude	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6c72894a-bd4f-46f6-bf44-0a5b500d6264	2022-05-10 16:30:24.141781+00	https://youtu.be/czewN5aS6Fg	A Trip to the Cornerstore 038	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	TRIZZ	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8b6afb58-0a0c-4489-bb20-3f9f492d34d0	2022-08-02 22:36:22.820643+00	https://soundcloud.com/simmiesims/hoochie-mama-feat-tyga?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	Hoochie Mama	{tyga,"hoochie mama","hoochie man shorts","it slaps","tyga and buddy?","cali cartel",rap,"cali rap"}	0	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	Buddy feat Tyga	\N	lifeofclaude	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
104afb76-86ad-4a49-9311-7ed622f5daf0	2022-04-30 18:43:22.524738+00	https://youtu.be/wZiPs0vqFFU	Same Old Ways	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Ama Lou	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
147c20fc-bc4a-4b28-9a10-bd4e086acd6b	2022-04-23 23:22:20.313502+00	https://youtu.be/w5fd9kAohHo	Purpose	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	 Fyfe, Iskra Strings, Ghostpoet	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
33bf29f5-6adf-4f3f-b4f0-eaa29287d2bd	2022-05-07 20:18:15.623301+00	https://youtu.be/ChCCCikiNY0	We Da Guys	{🔦,Rap,Alabama}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	MGM Lett, Yung OG	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d6694744-ae7a-4eff-b33c-a64403b010dc	2022-04-21 14:40:02.989355+00	https://youtu.be/uQO1SZNH38E	Comes With the Damage	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Chase Shakur	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
283e6d71-f8e4-425e-8409-708e3bfe8078	2022-04-23 22:47:33.09051+00	https://youtu.be/7QEhVl8NXk0	S’aäi	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Ofoutan	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d15a9ba2-2013-4bfb-9551-a133d673476b	2022-04-04 17:22:48.539099+00	https://www.youtube.com/watch?v=detRdOANQpw&t=35s	Good Life	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Idman	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8478b80a-32c8-411f-bf53-9029779cbdc3	2022-10-26 18:23:44.992897+00	https://youtu.be/Qv3abm2dtW0	Amorpha	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Bitchin Bajas	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
9f617ce4-a82c-4cc2-b11a-a6f4d29dfd5b	2022-11-01 17:51:08.112732+00	https://cchhrroonnoopphhaaggee.bandcamp.com/track/after-a-storm	After A Storm	\N	0	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Chronophage	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0b353e92-3385-4d42-8e78-c465c2dee3fd	2022-09-03 11:37:05.702225+00	https://youtu.be/RsY8bPLnIk8	Bad Habits	{StrictlyWaveyMusic,Baseman,"UK Rap",Makintsmind}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Baseman	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
327b1d61-b93f-4f75-9f7b-989041fd255b	2022-06-06 10:05:42.171374+00	https://soundcloud.com/overmono/so-u-kno	So U Kno	{Banger,UK,Overmono,Breakbeat,Techno}	1	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Overmono	\N	Keenboo	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a46c6298-1128-48b0-8a63-6ead7d1b5ef8	2022-08-04 06:52:39.518746+00	https://soundcloud.com/jordan-rakei/eye-to-eye-dan-kye-remix	Eye to Eye	{r&b,soul,electronic}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Jordan Rakei & Dan Kye	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4b45a523-6e58-4cf4-bbae-e2898a031a84	2022-08-04 06:55:20.242294+00	https://soundcloud.com/prrrrrrr-records/kordz-weve-been-orchestral-edit	We've been	{orchestral,electronic}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	kordz	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
506b386c-702f-4d36-b8b2-815aa3054af0	2022-08-04 07:09:41.697829+00	https://soundcloud.com/sonder/too-fast	Too Fast	{r&b,soul}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Sonder	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
dcc2b076-53b6-4f39-aa92-b99bb15296f5	2022-08-02 22:43:23.001688+00	https://soundcloud.com/doeboyfbg/scoreboard-1?in=doeboyfbg/sets/catch-me-if-you-can-240804575&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	Scoreboard	{"imma slap you","thug shi",blicky,"doe boy fresh",hoe}	0	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	Doe Boy	\N	lifeofclaude	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3e36b250-ab07-4dd0-9419-ad7ae7937c3d	2022-04-04 17:35:07.459645+00	https://youtu.be/6nEvNpeV8RI	Dear Gina	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Kadhja Bonet	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8e23ed02-3b77-4f16-ad20-4d56a17b721c	2022-04-17 01:40:10.402712+00	https://youtu.be/hOar_Qg0Z_8	Rounds	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Jaywop	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
fb49f059-6d36-4e43-a894-bb17157c4ed8	2022-04-23 22:25:14.317364+00	https://youtu.be/tXbN5Zy1F9Y	Genius	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Kelow Latesha	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e57cc0ec-dc90-44d4-99c3-d2080e077e81	2022-04-19 16:01:37.148698+00	https://youtu.be/vxj-PhixV74	Shake Dhat	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Zahsosaa, Dsturdy, DJ Crazy 	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c2733482-c307-4739-8f49-6be973244160	2022-04-30 17:47:33.820003+00	https://youtu.be/MMAM_9v50zk	Hotel Bel-Air	{🔦,"Music Video"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Larry June, Jay Worthy	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a76665bc-570e-416d-8c90-99f5f0a4526e	2022-04-21 14:08:33.675619+00	https://youtu.be/DwDJy7BKWXc	In/On	{Instrumental}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Daniel Villarreal	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a03c067b-3cfb-4377-be7c-2abc8cbdb17f	2022-04-17 01:26:17.242237+00	https://youtu.be/yI0xc8d0EUs	Take Time	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	glbl wrmng	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b5640252-6961-47c3-9dc6-d1d38f40bb7c	2022-04-17 00:44:38.411459+00	https://youtu.be/nou4Wn-_uEo	Being In Love	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Wet Leg	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
532e7993-f430-4432-aef5-231eb9cf19cb	2022-04-04 17:19:18.943477+00	https://youtu.be/GffAVxhpIKQ	Benny Made Me Do It Freestyle	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Booggz	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
70249acc-620b-4746-863a-f83f97890cba	2022-05-09 15:03:12.074965+00	https://youtu.be/bXUsb57dHU0	Love Me Back	{🔦,Summertime}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Trinidad Cardona	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b723e6d6-daaf-495c-9002-6edc3bc70d9d	2022-05-10 17:04:34.455885+00	https://youtu.be/y50bUsQDPRE	Extrovert	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Monjola	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
06118e1f-1d58-4aa4-ba5b-0ad123c58103	2022-10-26 18:25:32.724302+00	https://youtu.be/s9PzYuVwCSE	Poland	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Lil Yachty	\N	hallway	{0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
089d40e7-0df6-4343-9ef8-aa99952b72b1	2022-04-23 22:31:42.640933+00	https://youtu.be/VoSvHmKg1Fk	Ride	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Namir Blade	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
470cffa6-0cc8-4c65-81c1-9cb04bc17379	2022-04-19 16:30:23.545797+00	https://griffspex.bandcamp.com/album/live-from-transmutation?from=embed	(Live) From Transmutation	{🔦,Album}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Griff Spex	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4d819405-1fc9-4c16-b65b-f2b941c30203	2022-04-21 14:12:10.705768+00	https://youtu.be/5kP7DAOQt2Q	Southside Fade	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	reggie	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
134626f6-785c-4507-b3c5-d828bf167d98	2022-05-09 15:09:39.030039+00	https://youtu.be/hrkuo0y8gMU	6L GTR	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	The Chats	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a7905b6f-acfc-4fad-be75-79d05fbf69cd	2022-04-19 16:45:32.213165+00	https://youtu.be/Jr6ebcIKfac	Good Friday	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Kota The Friend	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
dae53de2-9a8b-45d5-a71c-731f5d16d416	2022-04-30 18:26:33.708303+00	https://youtu.be/Tub68KMmUFM	leaving my mark on the earth	{🔦,Future,Kanye,Flip}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	tuamie	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
41be3568-84d7-40c2-85e3-3b83c39b1684	2022-04-27 19:06:10.093194+00	https://soundcloud.com/they-hate-change/sets/some-days-i-hate-my-voice	Sometimes I Hate My Voice	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	They Hate Change	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
96b26251-5bef-4e84-ae52-04c25a99a520	2022-08-04 07:03:17.409077+00	https://soundcloud.com/radiojuicy1/verbz-mr-slipz-lessons-of-adolescence-out-now	Lessons Of Adolescence	{album}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Verbz & Mr Slipz	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4929291a-6caa-4ff9-8ee4-956fc661ace0	2022-08-04 07:04:28.704387+00	https://soundcloud.com/jamvvis/lavender-remix	lavender (jamvvis edit)	{r&b,soul,lofi}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	the trp	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
91aa6070-c63f-4569-a969-cfe5b2a33767	2022-08-04 07:08:44.735967+00	https://soundcloud.com/yespleaserecords/nick-hill-know-this	Know This	{dreamwave,hypnotize}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Nick Hill	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a827f233-7e97-4114-ad67-f7e68eb8ffa0	2022-08-04 07:10:36.597819+00	https://soundcloud.com/sonder/feel-1	Feel	{r&b,soul}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Sonder	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6e1bc7ef-8d85-45d1-abde-1e64afab1fd5	2022-08-04 07:12:29.447244+00	https://soundcloud.com/beatmachinearon/beyourself	beyourself	{unity,beats,byourself}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	beatmachinearon 	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
699197cf-a8f1-4014-b5ae-2ab76adb1f6a	2022-08-04 07:14:02.681947+00	https://soundcloud.com/knxwledge/so-rt	so[rt]	{Beats,nodyahead}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Knx.[ノレッジ]	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
9cccb868-10e0-456e-a07e-c617bdeb7172	2022-08-04 07:15:57.875443+00	https://soundcloud.com/chloeburbank/joji-rain-on-me	rain on me	{rainy,moody,piano}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	joji	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
dc8bbbea-46d5-435d-89f2-50fad1148c55	2022-08-04 07:17:44.084947+00	https://soundcloud.com/jarjarjr/minnie	mini	{pac,lofi}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	ｊａｒｊａｒｊｒ	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ce6608e0-7fe8-45b6-a826-a1582ecf5f0a	2022-08-04 07:25:48.548074+00	https://www.youtube.com/watch?v=hmAEFieyoTY	Priority ft. P Money	{uk,meaningfulrap}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Mr. Mitch	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d75e1999-2cdb-4fec-9fcc-bc7dfb08b312	2022-08-04 07:28:23.122181+00	https://soundcloud.com/kaytranada/flippin-on-you	FLIPPIN ON YOU	{kaytranada,"destiny's child"}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	"KKAAYYTTRRAA"	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
eb861236-2c68-4adc-8afe-7e93dfe9a043	2022-08-04 07:30:46.892672+00	https://soundcloud.com/allanrayman/all-at-once	All At Once	\N	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	allan rayman	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
218836a8-3b01-4e4e-8606-4c8a80015ebe	2022-08-04 07:33:40.614234+00	https://soundcloud.com/bernards-nile/moral-fiber-f-calm-plex	Moral Fiber	{clossic,hiphop}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Supreme Mathematicians	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e0325f95-c333-4fca-ae93-9d7e6f6f87f4	2022-08-04 07:35:14.088808+00	https://soundcloud.com/achesmusic/her	Her	{sexy,beat}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Aches	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
881f6af7-37f4-4a1b-bb8b-3cc574f67700	2022-08-04 07:36:13.140339+00	https://soundcloud.com/jesseboykinsiii/show-me-who-you-are	Show Me Who You Are (prod. by Machinedrum)	{sexy}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Jesse Boykins III	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3b936ff8-1208-49ad-b656-50215caad3cc	2022-08-04 07:40:10.48591+00	https://soundcloud.com/darkwaveduchess/fruit	Fruit	{r&b}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	ABRA	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b54d2ae2-5fe6-4234-97a9-82a7aec2dc48	2022-08-04 07:41:10.300878+00	https://soundcloud.com/mickjenkins/spread-love-prod-by-sango	Spread Love (Prod. by Sango)	{anthem,spreadlove}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	MICK JENKINS	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b0658939-637d-4a44-9cec-9a33464fbf64	2022-08-04 07:47:07.056277+00	https://soundcloud.com/elderbrook/elderbrook-closer	Closer	{techno,bright,electronic}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Elderbrook	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f9c27778-8a5e-4c7e-ab38-b9c8b4ebf0e1	2022-08-04 07:49:19.67073+00	https://soundcloud.com/lilsilva/sets/lil-silva-mabel-ep	Mabel EP	{EP,Banks,electronic}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Lil Silva	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4aac920a-3748-4cf2-9b58-db561b8f1bdd	2022-08-04 08:22:27.942421+00	https://soundcloud.com/annie-mac-presents/fmm-jarreau-vandal-x-mr-carmack-james-joint-rihanna-cover	James Joint	{cover,rihanna,soulection}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Jarreau Vandal x Mr Carmack	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
165cda70-5f48-46b1-baec-2fb42856b67b	2022-08-04 08:23:39.534589+00	https://soundcloud.com/truthosmufasa/you-told-a-lie-prod-dyslexis	You Told A Lie	\N	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	TruthosMufasa	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
271dad1a-2c9a-4e70-a36b-41d4f083b904	2022-08-04 08:24:32.674683+00	https://soundcloud.com/topdawgent/sza-twoam	twoAM	{tde,r&b}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	SZA	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
44762b05-0666-4287-9b1e-4b3efd60b014	2022-08-04 08:26:13.726471+00	https://soundcloud.com/erykah-she-ill-badu/come-and-see-badu-the-official-badu-party-remix	Come And See (PARTY NEXT DOOR DUET REMIX)	{thequeen}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Erykah Badu	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7b38ea9f-a2b1-495f-a6a8-d02a3c543111	2022-08-04 08:28:42.079859+00	https://soundcloud.com/redbull/river-tiber-illusions-feat-pusha-t	Illusions feat. Pusha T	\N	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	River Tiber	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
aeffed9a-322e-40e3-bbe4-75e715ef00b4	2022-08-04 08:29:45.936583+00	https://soundcloud.com/danielcaesar/streetcar	Streetcar	{r&b}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Daniel Caesar	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0c637fb9-afad-4ded-8283-32ef481cb332	2022-08-04 08:30:41.198877+00	https://soundcloud.com/blkwdutch/dutch-no-measure	NO MEASURE	{r&b,soul}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	DUTCH	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7d4e3aec-0da0-4e05-ab38-0b65c094ffd6	2022-08-04 08:32:57.340553+00	https://soundcloud.com/atlas-bound/lullaby	Lullaby	{soulful,gonnabealright}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Atlas Bound	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
5b9b8419-ee43-40a7-b302-0a06d9fb6c48	2022-04-29 18:41:09.459825+00	https://youtu.be/nykKajNmBXs	Baby Blue	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Jensen Kirk	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
035f9283-c297-4d47-b77c-ae636f622abd	2022-08-04 08:34:16.333437+00	https://soundcloud.com/vaperror/aqua-domain	Aqua Domain	{"under water",aqua,beats}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	VAPERROR	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
bfaa7ef5-e3c5-4c78-8100-a55a950c002e	2022-08-04 08:35:52.784488+00	https://soundcloud.com/duneofficial/devotion	Devotion	{chill,electronic}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Duñe	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
66eb7661-26a7-4b59-a1a4-70bf42e838a0	2022-08-04 08:37:22.822863+00	https://soundcloud.com/non_drifter/thinking-of-you	Thinking Of You	{beats,chill}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Non Drifter	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
64efd198-7788-4e97-8ef5-4c412e2b4f2c	2022-08-04 08:38:48.701921+00	https://soundcloud.com/greenwoodsharps/mr-key-greenwood-sharps-exact	Exact Costs pt2 // This Much I Know	{uk,rap}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Mr Key & Greenwood Sharps	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7f2354d4-8039-437e-b4e6-a6ae4dbf8d23	2022-08-04 08:40:08.153824+00	https://soundcloud.com/benjamingordn/found-me-now	Found Me Now	{gospel}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Benjamin Gordon	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ea00233f-c5ab-4679-8d9b-19887c17fa3f	2022-08-04 08:41:43.445129+00	https://soundcloud.com/tillaarce/know-yourself-prod-josh-arce-loner-muaka	Know Yourself [Prod. Josh Arcé + Loner Muaka]	{downtempo,chill,beats}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Tilla	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
57e33afa-109e-4d84-8d67-8ff3702051eb	2022-08-04 08:46:09.129096+00	https://soundcloud.com/morotki/blinded-by-the-lights	Blinded By The Lights (The Streets) ライトに目がくらん	{electronic}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Morotki	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4baeff12-ac43-4b67-8b16-876ab93936ac	2022-08-04 08:47:34.710999+00	https://soundcloud.com/bigdadasound/roots-manuva-dont-breathe-out-1	Don’t Breathe Out	{hiphop,r&b}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Big Dada	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
602b2066-be3a-4ba6-82ae-c651911d0d3c	2022-08-04 08:48:15.102881+00	https://soundcloud.com/skepta/nasty	Nasty	{UK,grime}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Skepta	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ee76d663-a0f2-4332-a766-928673e8ce17	2022-08-04 08:49:59.70994+00	https://soundcloud.com/toroymoi/pitch-black-ft-rome-fortune	Pitch Black Ft. Rome Fortune	{hiphop,chill}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Toro y Moi	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e153ed1a-bdde-4c28-871c-87246fe22f88	2022-08-04 08:51:59.644939+00	https://soundcloud.com/banksbanksbanks/banks-change-dream-koala-remix	Change (Dream Koala Remix)	{electronic,chill,alternative}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	BANKS.	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2dd37b47-f250-4ad7-9661-1c86b9f1e98b	2022-08-04 08:52:54.252336+00	https://soundcloud.com/fitzroy/name-your-track	Name your track	{beats,lofi}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	fitzroy	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
145217b7-5331-49ac-8709-e8970a8d7779	2022-08-04 08:55:37.947348+00	https://soundcloud.com/dafranchize13/flava-in-ya-ear-remix-craig	Flava In Ya Ear [Remix]	{classic,rap}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Craig Mack	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
44881046-3755-45fd-b693-e0f7126755bd	2022-08-04 08:57:08.084168+00	https://soundcloud.com/keider/shlohmo-beams	Beams	{electronic,oneofakind}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Shlohmo	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
9c43c10f-0feb-40d7-93bc-a1c5d33a4e43	2022-08-04 08:58:33.13136+00	https://soundcloud.com/joekay/sage-the-gemini-dont-you-joe	Don't You (Joe Kay's Slowed Edit)	{hazy,slow,rap}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	JOE KAY	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e2b51da9-7db5-4a4e-abcb-2ce5d894807a	2022-08-04 09:00:19.09782+00	https://soundcloud.com/enoonmusic/cashville	Cashville	{chill,sunny,feelit,puffpuff}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	E•Noon	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ebd4aa21-567e-46ec-8d1a-bdc390bd6237	2022-08-04 09:01:44.206639+00	https://soundcloud.com/teeeeefy/ab-soul-empathy-feat-alori-joh	Empathy (Feat. Alori Joh & Ja Vonte')	{tde,r&b,hiphop}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Ab-Soul	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0252b6cf-a5aa-4155-a571-331313e3a976	2022-08-04 09:02:47.704507+00	https://soundcloud.com/soulection/waldo-kobes-room-revision-prod	Kobe's Room (Revision) [Prod. by Sango]	{soulection,hiphop}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Waldo	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1be0c919-946e-457b-8058-54a549f3eae3	2022-08-04 09:04:11.754418+00	https://soundcloud.com/sajeofficial/saje-lost-tonight	Lost Tonight	{chill}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Saje	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a294d15f-89ba-4f76-b250-55df6300f201	2022-08-04 09:05:06.252167+00	https://soundcloud.com/chloexmartini/jay-prince-polaroids-chloe	 Polaroids (Chloe Martini Remix)	{funky,hiphop,positive}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Jay Prince	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
03caf168-19e6-4aac-99c2-fb7b11fc0931	2022-08-04 09:07:56.938869+00	https://soundcloud.com/melloworange/hir-o-blackstar	Blackstar	{beats,glitch,spaceout}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Hir-O	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
620e4538-8519-471f-8f45-36c36bbaf608	2022-08-04 09:10:57.581268+00	https://soundcloud.com/coinbanks/thomas-lawrence-feat-20syl-tab-one-kooley-high-and-the-ruby-horns	Track 3 on  Heads EP	{hiphop,dreamy,sunny,"slow day"}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Coin Banks & Thomas Lawrence	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e9255df5-21e3-450e-bff1-5a06a1fce0cd	2022-08-04 09:12:35.819335+00	https://soundcloud.com/jenovah/missy-elliot-shes-a-btch-jenovah-remix	She's A B*tch (Jenovah Remix)	\N	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Missy Elliot	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c818e6a5-6ea9-42a7-b23e-f42bd5c805ab	2022-08-04 09:13:37.718641+00	https://soundcloud.com/onkeentoo	Treat Me Like Fire	{r&b}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	LION BABE	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7f28dabf-11d4-4f0e-92c0-fab871cb9835	2022-08-04 09:15:13.808455+00	https://soundcloud.com/dreamkoala/we-cant-be-friends	We Can't Be Friends.	{slowtempo,sorry}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Dream Koala	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
861bf193-8256-4c98-a228-bb0423697b6e	2022-05-16 18:04:35.830302+00	https://youtu.be/DcNW-Z_riy0	Plum	{LuckyMe,🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Omega Sapien, Sega Bodega	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2b0f5c04-cc3e-404d-a283-39f6240113e9	2022-08-04 09:17:25.412317+00	https://soundcloud.com/jarreauvandal/fka-twigs-two-weeks-jarreau-vandal-cover-ft-ashley-rottjers	Two Weeks (FKA Twigs cover)	{r&b,electronic}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Jarreau Vandal ft. Ashley Röttjers	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a7276991-d7f6-4b4f-98e2-59cd35a4c7a6	2022-08-04 10:15:49.472784+00	https://soundcloud.com/superpoze/superpoze-x-stwo-untitled-1	Untitled	{electronic}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Superpoze x Stwo	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
767f693b-a74b-4e80-abb7-1093bd476330	2022-08-04 10:17:00.618493+00	https://soundcloud.com/cookinsoul/old-school	Old School	{pac,chill,hiphop,oldschool}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Cookin Soul	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
994c96b9-f31a-4e70-99e9-c53ae2ede364	2022-08-04 10:18:03.315739+00	https://soundcloud.com/cookinsoul/yg-blanco-block-party-prod	Block Party (prod. Cookin Soul)	{hiphop,chill,sunny,party}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	YG x Blanco x DB tha General	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
65532c92-e96d-4b4b-9f13-deacee4d10dd	2022-08-04 10:19:02.274699+00	https://soundcloud.com/ninja-tune/kelis-bless-the-telephone-trinidad-senolia-deep-remix	 'Bless The Telephone' (Trinidad-Senolia Deep Remix)	{ninjatune,electronic}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Kelis 	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
13573053-476f-4ab5-bd4c-0bff4859d52c	2022-08-04 10:19:58.954726+00	https://soundcloud.com/moodygood/slum-village-in-love-moody	Fall In Love [Moody Good Remix]	{bass}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Slum Village	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c609ceec-c3eb-4503-9833-1dfe5d6d983a	2022-08-04 10:21:05.880563+00	https://soundcloud.com/iceh2orecords/raekwon-ghostface-killah-slim	Slim Thick Remix (Dirty)	{wufam,chill,hiphop}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Raekwon & Ghostface killah	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ed099c64-f0c8-4298-bfcc-17f958494d9f	2022-08-04 10:23:30.747236+00	https://soundcloud.com/dreamkoala/odyssey-2	Odyssey	{alternative}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	DREAM KOALA 	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d66cb9c4-0a18-487b-90dc-e30b0a043a9f	2022-08-04 10:24:35.815795+00	https://soundcloud.com/stwosc/if-i-ruled-the-world-stwo-fitz	If I Ruled The World (Stwo & Fitzroy Remix)	\N	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Nas ft. Lauryn Hill 	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
32ab45d2-c90b-4fe8-b500-9ed5cfed647a	2022-08-04 10:25:30.559238+00	https://soundcloud.com/stwosc/virgo	Virgo feat. Shay Lia	{r&b,chill}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	stwo	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d9bedd7c-ec5a-41f5-9328-e98d294f6501	2022-08-04 10:26:56.044838+00	https://soundcloud.com/liveforthefunk/stwo-lovin-u	Lovin U	{woobwoob}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Stwo	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d5269e9a-128b-4565-a47c-103c22daf61f	2022-08-04 10:29:42.055563+00	https://soundcloud.com/huhwhatandwhere/stwo-syrup	Syrup	{beats}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Stwo	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
cb784a71-32e0-4d30-acc7-fc53956efeac	2022-08-04 14:46:03.754943+00	https://22amusic.bandcamp.com/track/estate	Estate	{"cosmica italiana",italy,"jazz funk",jazz,"cosmic jazz",22a}	0	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	Lorenzo Morresi & Tenderlonious	\N	athenayasaman	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
fd4e32f6-317f-4ca8-b779-29df41892182	2022-08-19 21:26:01.315198+00	https://www.instagram.com/reel/ChcmXtnMEeu/?igshid=YmMyMTA2M2Y=	Where I Wanna Be (Cover)	{R&B}	3	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Elmiene	\N	discoveringEs	{0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
12179bb2-fd90-4d60-ba61-d741ff0cee16	2022-09-01 00:33:39.914448+00	https://www.reverbnation.com/jaimito/song/20885474-fairytale-prod-eyedress	Fairy Tale ft. Eyedress	{"rock hill","new york","hip hop",punk,sneakergaze}	1	\N	0xBB4839c63Fb47AF438E51b38380256f8A4a7b919	\N	Jimmy V	\N	jimmyv	{0x5ab45FB874701d910140e58EA62518566709c408}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3ed159bf-095b-4caf-9cb7-d479b1834df8	2022-08-04 10:27:41.876333+00	https://soundcloud.com/huhwhatandwhere/common-i-want-you-kaytranada	I Want You (KAYTRANADA Edition)	{kaytranada,dance}	1	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Common	\N	Keenboo	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f185889d-b87c-4e65-954d-0e8829298d8e	2022-08-05 00:47:39.107501+00	https://music.apple.com/us/album/neptune/1621358272?i=1621358274	Neptune	{rap,"phlote live vote"}	0	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	RGN Raf	\N	lifeofclaude	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8434035f-a40a-4107-b568-80c21ec63f67	2022-05-31 07:37:21.905933+00	https://create.zora.co/editions/0x3e7fa0f13125ea8f1f17250bdd0924c974d3e80d	Foundation	{dance,electronic}	3	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Glassface	\N	Trish	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0221e871-37f8-4168-840a-b1de8a50f06d	2022-08-04 10:21:51.360465+00	https://soundcloud.com/promnitebeats/denzel-curry-threatz-promnite	 THREATZ [Promnite Edition]	{hiphop,electronic}	1	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Denzel Curry	\N	Keenboo	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8a5b5a39-7406-4609-a4db-17bd877866e8	2022-08-28 13:53:31.849228+00	https://open.spotify.com/track/0y1x810fdYuUKr1lJrIOuL?si=a614bbf6355842b9	2 Bars	{Makintsmind,"2nd Exit"}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	2nd Exit	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
149d6f71-47e3-4bdb-ae5a-447cb09146d5	2022-08-20 00:54:03.951002+00	https://soundcloud.com/fatmankey/love-on-ice-prod-kenny-beats	Love on Ice	{"kenny beats",atlanta}	1	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Key!	\N	future modern	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b07d1ff5-ae2f-441b-8423-096ba2495924	2022-10-26 18:32:23.935229+00	https://hugolx.bandcamp.com/track/surrender	Surrender	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Hugo LX	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c92d139e-0288-41c6-9ddb-96a4fb960b53	2022-11-01 17:53:58.500653+00	https://youtu.be/CJQ-YQTZVgQ?list=PLxrP7av91NNyEmuiwB5UTqxZwTC8hB4cQ	Look @ This	\N	0	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Quavo, Takeoff	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
33a21978-edf8-40f1-8d9f-c1541eaa4b5f	2022-08-28 13:56:03.024262+00	https://open.spotify.com/track/7JMAwZ5zhRJVXoX5gzdEs2?si=9c0407893c294f4b	Lost and Found	{Makintsmind,"Lost and Found"}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Pud	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1d90768c-bec7-43d3-8c30-cef521165ce5	2022-08-11 20:35:17.588281+00	https://www.youtube.com/watch?v=Jtyc--u6fUg	AMERICAN MUSCLE	{atlanta,independent}	2	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	THOUXANBANFAUNI	\N	future modern	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e49f4ba0-eb9c-43ff-8584-71449ad367d1	2022-09-01 14:08:32.583624+00	https://www.youtube.com/watch?v=VN5JvSA4QEY	Bic	\N	0	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	Twenty Duce & Tailormade Tyson	\N	athenayasaman	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8a0da9cc-b387-4a5d-a3fe-143531a1169b	2022-09-04 14:29:40.89638+00	https://youtu.be/qYocJ1Xhzk4	Scenario Freestyle	{"Coast Contra"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Coast Contra	\N	hallway	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4c95ff59-8a2d-4a7e-b121-9cca7854bbdb	2022-09-06 16:01:10.273303+00	https://ipfs.moralis.io:2053/ipfs/QmYHc1ftbWHazeovAjJ4nBPAieDN9stsTuLngFiRCbPJEP	OHSAY BY H, EYE OF & 888MOMENT PROD. GUSTOMANE	{"MAD DELTA",RAP,"HIP HOP","OH SAY CAN YOU SEE","PROD. GUSTOMANE",MARYLAND,"WASHINGTON DC",FINLAND}	0	\N	0x1502F98D90cc10b11B994566dFC44EC84035eCE8	\N	H, EYE OF & 888MOMENT PROD. GUSTOMANE	\N	Horace.eth	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
15ffb74e-cca5-4498-8300-2ff40e8ca5d5	2022-04-01 16:31:02.196396+00	https://soundcloud.com/phraternity/theodore-grams-elohima-feat-tierra-whack-prod-by-bside-music	Elohima	{"theodore grams","tierra whack",elohima,philly,"god is a black woman","rap sigils",sigil,spiritual,phraternity,conscious}	4	\N	0xfb3197Bd5b7F2E39c1e89B7619A697827eD2deff	\N	Theodore Grams Featuring Tierra Whack	\N	\N	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0x5ab45FB874701d910140e58EA62518566709c408}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
01f89150-9bf4-4211-ba30-0d81a490ff96	2022-08-08 00:12:32.33625+00	https://www.youtube.com/watch?v=Z4rTfwjn0yQ&ab_channel=CivPierre	Neverland	{🏴‍☠️}	2	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Civ Pierre	\N	Ghostflow	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b195626b-d3b2-4665-b4f4-3baf2c3fc75a	2022-03-22 23:40:37+00	https://open.spotify.com/track/6zHdJuj7GTtqrW4JrPgP4N?si=d13551dad3b74af0	We Major	{Jazz,"Good Shit"}	1	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Braxton Cook	\N	Ghostflow	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
50a124b7-031d-4a73-be76-72f72c1b4462	2022-05-03 01:35:15.880506+00	https://www.youtube.com/watch?v=iCopIeeA2R0	Live on KEXP	{🏴‍☠️}	1	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Kelly Finnigan & The Atonements	\N	Ghostflow	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f4e075f6-a59e-48bd-9c26-b2662f4f5fa1	2022-08-05 22:02:48.953825+00	https://moontidegallery.bandcamp.com/album/good-boy	Good Boy (EP)	{MoonTideGallery,Indie,Pop,Baltimore,Bandcamp,EP}	1	\N	0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74	\N	Moon Tide Gallery	\N	singnasty	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
915e66f0-1f5c-40b0-bdbe-bcbd278b26d1	2022-04-21 01:02:27.313315+00	https://soundcloud.com/ralphylondon	DDT (Ft. KiiBA)	{🏴‍☠️,Phlote,"Most Wanted"}	0	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Ralphy London	\N	Ghostflow	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7d2dbd7e-d816-4303-bc6a-f9fcd5e4679b	2022-08-05 01:03:03.302709+00	https://soundcloud.com/pulptaboo/deranged?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	Deranged	{dance,"phlote live vote"}	0	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	Pulp Taboo	\N	lifeofclaude	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
10ddbbbb-17ba-478f-807a-ff53f0e118e8	2022-07-26 16:26:39.579423+00	https://open.spotify.com/track/5HxZVwYpdu1SgUvl411nZ6?si=9e30aee1a05a47e8	Force of Habit	{🏴‍☠️}	2	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Paris Texas	\N	Ghostflow	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
da350214-597d-4bb4-b868-42f4484f99fd	2022-09-10 12:53:43.471425+00	https://youtu.be/zMILg6KbEcA	Lucious 	{Knucks,Makintsmind,Drill}	3	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Knucks ft Kwengface	\N	MakintsMind	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
64f94f79-c8dd-472a-89f8-9099028d7fa3	2022-10-26 18:35:26.278577+00	https://shyone.bandcamp.com/track/scorpio-sun	Scorpio Sun	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Shy One	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e2a75fe2-0201-4358-9276-930dcd1691cf	2022-11-11 15:28:50.5373+00	https://soundcloud.com/itschxrry/the-other-side	The Otherside	\N	0	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Chxrry22	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d0da24ba-8ca5-48b3-9f37-689c17035c2a	2022-11-03 03:49:04.94606+00	https://open.spotify.com/track/5FLpZcyK0v3SFkIZZ8YPQP?si=0dfb34aa0f4542b3	THROUGH 2 U	{🏴‍☠️}	3	\N	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	Bktherula, Ski Mask	\N	\N	{0x0bbac2bd3134a318deb31137d87d42bf54325cb7,0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47,0xf75779719f72f480e57b1ab06a729af2d051b1cd}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4528e61a-84fc-42d2-8bf0-3b62e959ded4	2022-10-31 18:46:01.161744+00	https://open.spotify.com/track/2OQ1V0e2O56AeIo4ywuYKF?si=481e06575ed94ec8	People Everywhere (Still Alive)	\N	3	\N	0x8d41859049c156e70fa381e07a757d5db2f33e1d	\N	Khruangbin	\N	jakeabel7	{0x0bbac2bd3134a318deb31137d87d42bf54325cb7,0xef58304e292fbaeacfdec25b67b3438031fde313,0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
caf842eb-0ea0-41fd-b937-3bfb121afba3	2022-10-26 18:38:30.118066+00	https://shyone.bandcamp.com/track/b-tch-u-better	Bitch U Better	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Shy One	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0b1413e4-e7de-4f2b-b710-184081862716	2022-08-05 19:47:22.796326+00	https://open.spotify.com/album/1PKVzqQuDJbaiIjAu7cJ9u?autoplay=true&source_application=google_assistant	The Road to Demon City	\N	1	\N	0xf10747b5e895F77C14A42c71Ac6619dBCf1D7AF8	\N	Choirboy Dank	\N	Choirboy Dank	{0x5ab45FB874701d910140e58EA62518566709c408}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e31042f7-3772-4109-9efc-eea9f5646be2	2022-11-16 20:55:33.30692+00	https://open.spotify.com/track/3Vpn6xh4JmtryjRp80Krqh?si=778a375b2d4c4b4f	Eternal September	\N	0	\N	0x8d41859049c156e70fa381e07a757d5db2f33e1d	\N	Avalon Emerson	\N	jakeabel7	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b7b6be9a-4554-42c6-81d7-4812ee798f74	2022-08-30 13:32:34.211754+00	https://soundcloud.com/alan-the-chemist/roc-marciano-the-alchemist-1?in=alan-the-chemist/sets/the-elephant-mans-bones&si=3c32c8248b504f48a7ea70ff3fb9f2fb&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	Zip Guns	{luxurious,"nyc boom bap","boom bap",nyc,"chain snatchin",rap}	3	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	Roc Marciano & The Alchemist (feat. Knowledge The Pirate) 	\N	lifeofclaude	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x5ab45FB874701d910140e58EA62518566709c408}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
576f197e-cc27-46f1-a865-4f8ae6e65dfa	2022-08-08 16:16:30.68316+00	https://www.youtube.com/watch?v=-UxPCnyb_VM	Pyro	{canada,vancouver,rage}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Killy	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d51894dc-6665-4fb1-bbab-33743c25b6f6	2022-08-20 01:00:35.421575+00	https://www.youtube.com/watch?v=i7rVmeeXIvM	Grace Park Legend	{"norf side","long beach"}	3	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Huey Briss & Nikobeats	\N	future modern	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x52fA05393a003d234eFBA136E68DA835aeB64a26,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1281c8c7-5d35-4d81-bec1-9f090c5e062b	2022-08-08 16:27:28.257071+00	https://www.youtube.com/watch?v=PKalQrHXayI	Beamerboy	{"emo rap"}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Lil Peep	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0c62d463-35cb-45f2-9632-55a9f429abe6	2022-09-01 14:11:15.566638+00	https://www.youtube.com/watch?v=5iTyvWiCc1M	7AM ft. Bawo	\N	0	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	Louis Culture & YAMA//SATO	\N	athenayasaman	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
312652ff-2049-41e8-be5e-4b2c4be04112	2022-09-12 00:25:56.94268+00	https://www.youtube.com/watch?v=Iy9HQmYmxpw	Jiggy Bop	{"top memba",lagos}	3	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Kida Kudz	\N	future modern	{0x52fA05393a003d234eFBA136E68DA835aeB64a26,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2baaa6a3-4cfd-4b6b-92f4-0c7fec02254c	2022-08-10 13:41:30.742796+00	https://www.youtube.com/watch?v=EVlGLtCnN-Y	Dance Now	{🔦,"Music Video",JID}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	JID	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
9dd39170-1469-4d89-b55e-bbe689c8ea48	2022-09-06 16:03:30.461472+00	https://ipfs.moralis.io:2053/ipfs/QmYHc1ftbWHazeovAjJ4nBPAieDN9stsTuLngFiRCbPJEP	YTK - WOE	{YTK,BALTIMORE,"LET IT OFF FREESTYLE",RAP,"GOSPEL RAP","MAD DELTA"}	0	\N	0x1502F98D90cc10b11B994566dFC44EC84035eCE8	\N	YTK	\N	Horace.eth	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1d13e086-7c98-49f3-a649-a947362edd72	2022-07-22 13:10:14.985083+00	https://open.spotify.com/track/246gZM3O0R14GSrh7ckccf?si=2e376dac1026449f	Infatuation - Original Mix	{🏴‍☠️}	0	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Citizenn	\N	Ghostflow	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a3a05249-57c3-499c-89ee-71cfd170859f	2022-08-08 14:50:14.972258+00	https://www.youtube.com/watch?v=Kt0Mr4V3DS4	Time Traveler	{dreamy,clouds,hiphop,420}	3	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Chester Watson	\N	Keenboo	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
9b4c81d4-acfe-4809-b321-b5f249bf697e	2022-09-09 14:51:27.910816+00	https://youtu.be/vn9xLph8KwQ?list=PL7FP4DkWGBb5BmcBuFaDjBVEaePMeE866	Bruddanem	{Dreamville,JID,"The Forever Story"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	JID, Lil' Durk	\N	hallway	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2d5a0b05-ccab-4bdf-9f3b-7888ee969eea	2022-08-28 13:58:39.597539+00	https://open.spotify.com/track/5OmN19NRa8PM9lTO5zaWOZ?si=3c24184015694529	mate in five	{Makintsmind,Joetry}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Joe James	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
37ad86f5-fdb0-460c-84bc-234641f79752	2022-08-10 14:58:56.646802+00	https://www.youtube.com/watch?v=SoPt02GnK4Q	Already Knowing	\N	0	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	Miles Ryan Harris	\N	athenayasaman	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7ff4c2d7-8543-4c53-883a-0772bd871b7d	2022-10-26 18:40:11.970551+00	https://shyone.bandcamp.com/track/bird-bop	Bird Bop	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Shy One	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
562330b7-9d5f-43a9-803a-663b1c888bea	2022-05-09 15:30:47.046521+00	https://www.youtube.com/watch?v=cBda4UchbNU	Prince of the Mitten	{"scam rap",detroit,shittyboyz}	2	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Babytron	\N	future modern	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
fdd339f0-f5ec-4a2d-91c6-9f5dbaa451ab	2022-08-08 16:47:14.232728+00	https://www.youtube.com/watch?v=YyNv5wDhs2Q	Frenches	{drill,uk,france}	3	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Digga D x Timal	\N	future modern	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
dc7a1d05-13cd-4391-a6f4-9e9f4a8c34a6	2022-08-30 13:35:07.22121+00	https://soundcloud.com/moneysbmg/aww-man?si=3c32c8248b504f48a7ea70ff3fb9f2fb&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	Aww Man	{"lethal bars",ooooof,rap,"rap music","fat money",bars,savage}	0	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	Fat Money	\N	lifeofclaude	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4c9555fa-fcf5-4639-989e-65ae27a25727	2022-08-28 14:00:48.868649+00	https://open.spotify.com/track/6jDurwjOP0bly2BAHeBLLL?si=5d2978b08a294610	Built to Last	{Makintsmind,"Talk is cheap"}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Finn Foxell	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
92a5a090-ab6f-4af9-a454-a9df76f3629b	2022-05-04 16:19:34.572177+00	https://audius.co/verbsisthehomie/verbs-hella-baller-art-gallery-04-thunder-cloud-4-feat-breezy-lovejoy-281746	Thunder Cloud 4 ft. Breezy Lovejoy	{"anderson paak","hella baller art gallery","drink water art labs","art rap","los angeles",deathLA}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	VerBs	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1505c0bc-6ce6-4307-844f-21d15ef2fa70	2022-11-03 23:26:11.049232+00	https://open.spotify.com/track/3ajUnzvWMSSuz2dvNL7EZZ?si=69ff46cf5cbd47ae	Untitled God Song	\N	0	\N	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	Haley Heynderickx	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
238dbdc8-8ba5-48a6-9da7-3b2bd2e42a84	2022-05-08 19:18:26.021163+00	https://www.youtube.com/watch?v=QkzN1d6h8hE	Money So Big (Guitar Cover)	{cover,yeat,"electric guitar"}	1	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Alex Coats	\N	future modern	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6ee97a01-6e08-4143-a851-cfb0db0afe66	2022-05-09 15:19:56.229903+00	https://www.youtube.com/watch?v=O1J0dyQh5vE	Shirley	{Kent,"UK drill","snowy music video"}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Farfromhome	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
89d550a9-9f70-45ce-b128-d06561592b70	2022-05-04 16:25:23.420088+00	https://soundcloud.com/user-409034444/yung-hurn-mhm-official-music-prod-by-stickle	MHM	{"german rap"}	1	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Yung Hurn	\N	future modern	{0xc2469e9D964F25c58755380727a1C98782a219ac}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
5cae26f4-9353-4a5e-8ee6-2d0482fd6e65	2022-05-08 19:29:45.991698+00	https://www.youtube.com/watch?v=If_3mCIUVFI	Butterfly Bankai	{shanghai,"rhode island school of design",keyworld,neilaworld,VV}	1	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	SEBii	\N	future modern	{0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
36b86623-e4a0-44fa-9535-97172b98ed44	2022-05-08 19:19:52.557215+00	https://www.youtube.com/watch?v=2N1liztehz8	Bliss ft. FKA twigs	{sadboys,draingang}	3	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Yung Lean	\N	future modern	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xc2469e9D964F25c58755380727a1C98782a219ac,0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1c172c15-b860-4517-9387-9aee4503f861	2022-05-18 03:41:46.078075+00	https://www.youtube.com/watch?v=8Hjafyksskg	Suicidal (prod. lunchbox & blkyth)	{blkyth,lunchbox}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Yeat	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
93608e58-f96a-45d7-97bc-adff55239885	2022-05-18 03:02:13.639479+00	https://www.youtube.com/watch?v=AkDJ9aMeh28	Emperor of the Universe	{detroit,"beat switch","scam rap","lyrical lemonade"}	1	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Babytron	\N	future modern	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d61b66fe-0512-46d0-967a-67c727f5b7fa	2022-08-08 16:25:53.44351+00	https://glass.xyz/v/iqPxyUlXDKThP-NSuABL8mpIJqbHWD0ez4KY9npVzf0=	dip like crypto	{3d,metaverse,afrosurreal,afrofuturist,psychedelic,"crypto rap","dc maryland","howard university","self produced","3d animated","self animated"}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	MARCY MANE	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8daa48e8-cbe7-4312-9247-c078ea2e1c7b	2022-08-08 16:45:13.808692+00	https://www.youtube.com/watch?v=EsajeQO0vzU	Inside Out	{rage,"new soundcloud"}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Yeat & SeptembersRich	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c9aacffe-7f99-499a-818e-95b6878168d9	2022-08-08 16:45:57.728127+00	https://www.youtube.com/watch?v=VbCoaNeySrg	Kinda Krazy	\N	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Yeat	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
9aac87b8-a944-42c6-a959-1cb536d22e56	2022-08-08 16:49:09.348646+00	https://www.youtube.com/watch?v=ww6ykF2ktaI	FNF	{memphis}	1	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	HitKidd & Glorilla	\N	future modern	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a5c64e12-226d-4130-b15b-bd40ff8c6594	2022-11-11 15:30:50.698782+00	https://soundcloud.com/itschxrry/do-it-again-1	Do It Again	\N	0	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Chxrry22	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
effda46f-b8b1-439b-bde6-5aecf609196a	2022-09-06 16:05:29.249688+00	https://ipfs.moralis.io:2053/ipfs/QmYHc1ftbWHazeovAjJ4nBPAieDN9stsTuLngFiRCbPJEP	YTK - GILLIGAN	{"MAD DELTA",YTK,"FEBRUARY 2020",MARYLAND,CALIFORNIA,"WASHINGTON DC"}	0	\N	0x1502F98D90cc10b11B994566dFC44EC84035eCE8	\N	YTK	\N	Horace.eth	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2f875ca3-8d93-479e-bcb6-922bc83c1572	2022-08-08 16:18:37.369638+00	https://www.youtube.com/watch?v=MyY_KF5ZtEo	DIVE IN!	{rage,"rhode island"}	3	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	JELEEL!	\N	future modern	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
9cb7d4ac-b8d2-4096-99af-938a3f740f5f	2022-08-10 20:29:01.691917+00	https://www.youtube.com/watch?v=_Q6Rixmvujc	Soapy	{naija,yoruba,afrobeats}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Naira Marley	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4d2f1ac1-6c92-4d6b-be9f-39c59e76894f	2022-08-10 20:33:58.029891+00	https://www.youtube.com/watch?v=1VrWaED18_g	SOCO ft. TERRI X SPOTLESS X CEEZA MILLI X WIZKID (OFFICIAL VIDEO)	{afrobeats}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	STARBOY	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8aabb21f-e2f4-4310-9698-33d5a3a0de8d	2022-08-10 20:37:34.114388+00	https://www.youtube.com/watch?v=zUU1bIWpH5c	Dumebi	{afrobeats}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Rema	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
bc8ea800-c47a-473f-88c0-34438be27404	2022-08-10 20:40:56.096606+00	https://www.youtube.com/watch?v=7vyGnES3KlY	4 The Betta	{chicago,"alternative trap"}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Lucki	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
afb7417b-da51-4cac-ac2d-918f763d64d2	2022-08-10 20:42:50.147038+00	https://www.youtube.com/watch?v=7-QK_1oHoiQ	MORE THAN EVER	{chicago,"alternative trap"}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Lucki	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a1d68a46-ede6-445c-9a90-3ec2fb93babb	2022-08-10 20:44:52.408494+00	https://www.youtube.com/watch?v=3rk6_Ax0mQo	Did You See	{afroswing,"road rap"}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	J Hus	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c80b874e-09ce-4e3a-87da-05a2a4417093	2022-08-11 16:07:20.466825+00	https://www.youtube.com/watch?v=Fas2lVNRdSI	Wasted	{chicago}	1	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Nnamdi	\N	future modern	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
86472ff3-836b-4e58-8edc-1b1e089bb4e8	2022-08-20 14:12:32.855742+00	https://soundcloud.com/bbykodie/hustle-1	Hustle	{texas}	1	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	BBY KODIE	\N	future modern	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
611abaa0-305c-4cec-a002-e43108147548	2022-04-19 02:13:19.397502+00	https://soundcloud.com/malzmonday/seet-deh?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	Seet Deh!	{"malz monday",ossining,"underground rap","new york",rap}	3	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	Malz Monday	\N	lifeofclaude	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1cc18de3-829c-4863-9df5-f14b13e0b197	2022-05-21 19:12:45.502545+00	https://youtu.be/S_cv6dJONcc	Nature Heals	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Wynne	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6413e1e0-25d5-40ce-bb97-879ad40a39bb	2022-10-26 18:48:42.198743+00	https://phoenixg.bandcamp.com/track/next-up-ds-pedigree-chunks-with-added-tender-chewy-bitz	Next Up (D's Pedigree Chunks With Added Tender Chewy Bitz)	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Mr. G	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
61398f06-e645-4f9f-a21a-6b94d3c17c52	2022-08-11 20:42:44.15068+00	https://soundcloud.com/thouxanban/fully-flared	FULLY FLARED	{atlanta,independent,clairvoyance}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	THOUXANBANFAUNI	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
96ded6f3-580d-4760-b0c7-a531aa367242	2022-11-11 15:34:02.541102+00	https://soundcloud.com/itschxrry/us	Us	\N	0	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Chxrry22	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
485f91dd-15b8-4e71-9d18-daab2abc0df1	2022-05-03 14:33:24.166498+00	https://soundcloud.com/westsideboogie/aight?in_system_playlist=personalized-tracks%3A%3Akulturehubmusic%3A1227152185	AIGHT	{aight,"west coast","bounce to this","low rider","gang shit",ho,"west side",crip,"big crip","crip walk"}	1	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	Westsideboogie	\N	lifeofclaude	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
35fa4028-fa5e-424c-adbd-7e249f9aa465	2022-04-19 02:16:10.12942+00	https://soundcloud.com/mrsaks5th/vigilante-produced-by-dalton-x-turbz?in=kulturehubmusic/sets/phlote-radio-004	Vigilante	\N	1	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	Mid-Nite	\N	lifeofclaude	{0x7d1f0b6556f19132e545717C6422e8AB004A5B7c}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3b62706f-8703-4dec-889c-380349b314b7	2022-05-08 21:12:43.508753+00	https://soundcloud.com/skinny/salam?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	Salam	{salam,"swizz beatz",skiiny,$kinny,"arabaic trap",arabic,habiibi,ock}	1	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	$kinny	\N	lifeofclaude	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
66f54dc8-3bc5-4b7e-b2bf-c7e1005682e1	2022-05-08 21:59:13.214032+00	https://youtu.be/cZjnUiQyC5g	7h59 	{"french rap",french,"french trap"}	0	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	Luidji	\N	lifeofclaude	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
fcd5cef1-8d56-40d0-9bda-d9066bf0b996	2022-05-08 21:18:21.332387+00	https://www.youtube.com/watch?v=TyA4cJVx3ME	Samurai(UMA) 	{"vel the wonder",chicha,LA,chicana,"woman rapper",bars,vel,"kill bill",uma}	1	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	Vel The Wonder	\N	lifeofclaude	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c23af198-bf2e-41f4-999c-4b2e273a5956	2022-05-08 21:20:15.565315+00	https://www.youtube.com/watch?v=zCfVZ60DkjU	The Only Constant	{"real rap",queens,"homeboy sandman",lyrical,"sunday jamz"}	1	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	Homeboy Sandman	\N	lifeofclaude	{0x5ab45FB874701d910140e58EA62518566709c408}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
72cdfe08-0231-409c-9feb-ad49277b07a1	2022-08-11 14:23:14.102421+00	https://t.co/ZRNan5sXgz	Anti	{"Music Video","Austin Veseley"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	NNAMDÏ	\N	hallway	{0x5ab45FB874701d910140e58EA62518566709c408}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7c74da1b-6945-4bf1-8d4e-5a81705463e7	2022-08-05 01:43:09.190792+00	https://ipfs.moralis.io:2053/ipfs/Qmf7dDzcsfTuMdKYqX3Tz4ur9j2vpG4JBYp2yGtU2w43hK	Got It On Me	{"rap brooklyn"}	1	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	KillaKMadeinBrooklyn	\N	lifeofclaude	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4c2581d0-3d79-47bd-a564-0063183729d4	2022-09-16 19:14:21.207071+00	https://on.soundcloud.com/CEBsM	LEAVE ME	\N	0	\N	0x62F541d08dcA3e1044282DA4a9aa63590B6fFb34	\N	Modest	\N	ModestMotives	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8c1d907d-30f7-47b6-b131-94ab3fdd95dc	2022-08-28 14:03:10.703314+00	https://open.spotify.com/track/6ksef4YQFsbAPXBrzclQZw?si=66e2daec3a0243c6	Shout Me	{Makintsmind,"Talk is Cheap"}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Finn Foxell ft Safiyyah	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a3514ee6-0dc2-4b21-a938-7ffb9315124b	2022-05-02 18:26:19.86458+00	https://www.youtube.com/watch?v=htHzlgYrjk0	 Smoke (ft. Lil' Fame of M.O.P)	{"that jay-z nod","you heard this",yl,starker,vinyl,"old school rap","rap roots",rapheads,"rap heads",smoke,"smoker music","stoner music","smoke to this",lyrical,"real rap","real recognize real"}	1	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	YL & Starker	\N	lifeofclaude	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6704e027-7bcd-4cf6-a57c-9998c4caebc4	2022-10-26 19:05:08.166086+00	https://phoenixg.bandcamp.com/track/u-feel-mi-kai-alces-new-feel	U Feel Mi	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Mr. G, Kai Alce	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ecb7d9a1-7b1f-47d2-b488-b8681a043fa1	2022-04-25 13:59:30.380963+00	https://soundcloud.com/skinny/tamam-feat-fat-money	Tamam	{"middle east",arabaic,rap,"arab rap","west coast","hard hitting",ramadan,mubarak,tamam,sturdy}	0	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	$kinny ft. Fat Money	\N	lifeofclaude	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a1c4be42-397f-4147-a901-0a5d4ea9fdc4	2022-05-03 14:22:26.734381+00	https://soundcloud.com/wavy_bagels/anitaaa-waaave-2	anitaaa waaave 2	{"lo fi",lofi,lo.fi,beat,flip,rnb,instrumental,instru,mental}	0	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	Wavy Bagels	\N	lifeofclaude	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
383d80e4-aea9-4a66-b73e-ca2dcddf969d	2022-05-11 17:58:59.697787+00	https://soundcloud.com/bonitapodcast/woah-nelliee-a-bonita-guest-mix?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	Woah Nelliee | A Bonita Guest Mix	{"dj mix",djing,mix}	0	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	BONITA MUSIC	\N	lifeofclaude	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
9fae8a66-829b-4d2c-bb13-eed205151c29	2022-05-11 20:32:55.759652+00	https://soundcloud.com/bohanphoenix/two-commas-american-dream?in=bohanphoenix/sets/the-prince	Two Commas (American Dream)	{"asian trap",aapi,"asian rap","chinese rap",chinese,asian}	1	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	BOHAN PHOENIX	\N	lifeofclaude	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2ed8ceaa-c738-4f42-9884-7a21841a2f84	2022-07-12 18:46:17.485581+00	https://soundcloud.com/slugchrist/government-check-ft-big-baby-scumbag?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	Government Check	{"slug christ","government check",slap,"big bass","i hate mgk"}	1	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	Slug Christ	\N	lifeofclaude	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6540ce35-3e19-4d1c-8af6-308820338f6f	2022-07-12 18:44:09.525228+00	https://soundcloud.com/overdozmusic/12-taking-me-down-feat?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	Taking Me Down	{overdoz,"west coast","kendrick lamar","smopke one and poke one","kush wine"}	1	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	OverDoz.	\N	lifeofclaude	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
89c7538b-6245-469f-9614-d6013d4f933e	2022-08-04 23:43:28.418128+00	https://soundcloud.com/mantrablu/itisntthathard?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	It isn't that hard	{mantrablu,"produced by foolie $urfin",rap}	0	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	MantraBlu	\N	lifeofclaude	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
86706e8f-2f93-4405-9e79-3e8a72e126d1	2022-08-04 23:44:49.55217+00	 https://soundcloud.com/kdhnxlwa/910a?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	9/10	{kdhn,rap,"phlote live vote"}	0	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	KDHN	\N	lifeofclaude	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f31d71ee-743e-4c2c-95f5-8f951723a9a8	2022-08-05 00:45:50.575241+00	https://soundcloud.com/nicholi-white/zach-gowen?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	Zach Gowen	\N	0	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	Holiday N	\N	lifeofclaude	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
bb532086-9205-4937-96ee-706e05b7e8fa	2022-08-05 01:23:51.189558+00	https://ipfs.moralis.io:2053/ipfs/QmYDtuhrTaXckiZWajUPepinyPSXtkYY5AEzTTSeGbLqY6	Twerk MF	{dance,edm,rap,"phlote live vote"}	0	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	Toddy Dozian	\N	lifeofclaude	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6ee6e09a-91ca-4004-b197-d430b573cd82	2022-05-18 22:11:13.128256+00	https://soundcloud.com/ygaddie/smoke-fee-interlude	Pudge Rodriguez	{ASAP,MOB,"ASAP ANT","YG ADDIE",HARLEM,BRONX}	3	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	YG ADDIE A$AP ANT	\N	lifeofclaude	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8013f858-5b31-48bd-a9b4-ab4cac81dde1	2022-08-05 01:26:14.115039+00	https://ipfs.moralis.io:2053/ipfs/QmYDtuhrTaXckiZWajUPepinyPSXtkYY5AEzTTSeGbLqY6	Flex	{flex,rap,"phlote live vote"}	1	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	Piff Marti	\N	lifeofclaude	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
bc539baa-4be3-4fff-9978-08914ba9493b	2022-05-11 18:01:24.749383+00	https://soundcloud.com/gorillanems/bing-bong-feat-vado-shoota93?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	Bing Bong (feat. Vado & Shoota93) (Underground Remix)	{nems,"hard hitting","bing bong","new york on fire"}	1	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	NEMS	\N	lifeofclaude	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
98df08a4-e90b-441b-a5b1-51445c49e9cc	2022-08-21 15:16:45.198642+00	https://youtu.be/jyVym_gTC6s?t=62	Advice (Prod by Madlib)	\N	2	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	LMD	\N	athenayasaman	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
97441833-9722-4959-a45c-e60babf25b99	2022-08-28 14:06:28.364306+00	https://open.spotify.com/track/67YxKFUvrrLjcBEJb040ER?si=4440c5d794ba456a	After	{Makintsmind,Spain,After}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Deva 	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d451b8fe-eb3c-40f7-9653-3d5dd87ea180	2022-08-05 01:45:40.769217+00	https://ipfs.moralis.io:2053/ipfs/Qmf7dDzcsfTuMdKYqX3Tz4ur9j2vpG4JBYp2yGtU2w43hK	Lockdown	{rnb}	0	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	Daniel Ross	\N	lifeofclaude	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
308cd327-1068-4d09-bec2-b8ffc4ce85ba	2022-08-05 01:15:07.230284+00	https://music.apple.com/us/album/oh-wah/1582953041?i=1582953045	Oh Wah	\N	1	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	RianB	\N	lifeofclaude	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8979c299-8486-4565-9c11-8c72070481ad	2022-08-21 15:18:45.066999+00	https://www.youtube.com/watch?v=G3gqALUYOe4	Moons Freestyle	\N	0	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	Tessellated	\N	athenayasaman	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0a889932-4e39-4fc4-abf0-3f02a82b9dea	2022-08-12 17:54:29.750769+00	https://soundcloud.com/captaincuts/life-of-emo?si=e91b17e65f8045e388cfaa8f7de9fcdf&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	The Life of Emo	{Emo,Mix}	0	\N	0xfFba44c15Fe2768bC2234078dfac8c5A651A56e9	\N	Captain Cuts	\N	AcidPunk	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
969d0f10-e0bf-408e-867a-c7637c921bf9	2022-08-12 22:11:12.991983+00	https://gothmoneyrecords.bandcamp.com/track/11-uzi-edward	Uzi Edwards	{"dirt road",goth}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	BLACK KRAY	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
bd0ffe0e-f20d-4884-a60d-bac3a315f32c	2022-08-13 17:05:44.003564+00	https://soundcloud.com/breakworldrecs/sets/goth-money-trillionaires	Goth Money Trillionaires	{goth,emo,"soundcloud og"}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Goth Money Records	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7fac37ed-918a-4981-b934-e02f6b620d34	2022-08-14 13:57:10.43576+00	https://www.youtube.com/watch?v=G9fc2r7m1so	Did You See - Live from the BRITs Nominations Show 2018	{uk,afroswing}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	J Hus	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d6599f70-cd30-47d3-87f5-aac302c0487b	2022-08-14 13:58:01.918961+00	https://www.youtube.com/watch?v=gLj9YCI3fuA	In The Fire (ft. Giggs, Ghetts, Meekz & Fredo) (Live at The BRITs 2022)	{uk,nigeria}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Dave 	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
22fd2c08-d6f5-473d-832f-97944c0e5238	2022-08-14 14:00:19.698607+00	https://www.youtube.com/watch?v=1lWxMne0NEk	Verdansk	{uk,nigeria}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Dave	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
94b1f684-a92c-43ae-9131-935f97095831	2022-08-14 14:20:23.744912+00	https://www.youtube.com/watch?v=VFK2DoDaAUc	Money Talks ft. Dave	{uk,drill}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Fredo	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
cb4df004-5a98-4287-9eae-866dcd3fd0c8	2022-08-14 14:52:33.200605+00	https://www.youtube.com/watch?v=oFqVvjq6BGM	Clash ft. Stormzy	{uk}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Dave	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8263f195-1054-40db-b2c3-53213a2bfe4e	2022-08-14 16:12:39.710325+00	https://www.youtube.com/watch?v=OdD-SEIDRBc	King Tut King Shad	{762}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Trench Gang	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
206d6409-04e9-47f1-9d0c-647d7c939d0a	2022-08-16 01:21:24.35283+00	https://www.youtube.com/watch?v=Nk7hnwvTFHM	Ard Up	{rage,irvine,oregon}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Yeat	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1e9f5412-f994-470f-abf4-6d9959463438	2022-08-16 01:22:48.812646+00	https://www.youtube.com/watch?v=Ob4tChuRFvs	Bluwuu	{uk,drill}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Digga D	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
023dacb4-4c65-4897-b405-de194f42d661	2022-08-16 01:56:42.031018+00	https://www.youtube.com/watch?v=1fofQt6UpP8	Price Went Up	{"avant garde",pop,illinois}	1	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Nnamdi	\N	future modern	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
44058555-088e-4ebc-9335-1753742cb9fd	2022-05-21 19:13:58.485241+00	https://youtu.be/Efmq_uXt1Rk	Welcome to Hell	{🔦,"music video"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	black midi	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
acd2d054-d600-403d-8fb0-8e52d98113cb	2022-08-16 01:41:08.666382+00	https://www.youtube.com/watch?v=nHujh3yA3BE	chorus	{electronic}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Holly Herndon	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a86f975f-dac8-43fd-a177-da919f4dad3f	2022-08-16 01:27:56.559367+00	https://nnamdi.bandcamp.com/track/gimme-gimme	Gimme Gimme	{chicago}	1	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Nnamdi	\N	future modern	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
aea0850f-02b8-4cc7-998f-74fdae0ab53b	2022-08-16 02:28:34.183908+00	https://open.spotify.com/track/52qJVV29G6n6mbqavdCwpt?si=65ac1c39cab046fa	Fools Gold	{}	0	\N	0xfFba44c15Fe2768bC2234078dfac8c5A651A56e9	\N	Calling All Captains	\N	AcidPunk	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c8ed7739-9b49-4a0a-9509-54ec73239911	2022-04-08 17:14:40.545378+00	https://soundcloud.com/duolitty/ayyy-mama-kgn2020	Ayyy Mama	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	duolitty	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
76a0ed7c-1328-4061-a9e1-3186317ca566	2022-04-29 18:35:49.848862+00	https://youtu.be/fTC4pioY1nE	KickDoe	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	DaBoii	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
30b33f16-0145-42f4-839d-9c74e7a631fb	2022-08-16 15:28:05.75891+00	https://www.youtube.com/watch?v=Cp4q6qi6inQ	Back to Basics ft. Skepta	{uk,drill,road}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Headie One	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d34e07b3-f32f-4395-ac41-a5d07a42dffa	2022-08-16 15:37:32.605955+00	https://www.youtube.com/watch?v=4An4oR035j8	Amygdala	{pixie}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Bladee & Ecco2k	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7a075bf4-967c-4474-b26b-899c76f07e38	2022-08-16 15:41:19.877972+00	https://www.youtube.com/watch?v=tT1KsSnWBhM	I'm Goofy	\N	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Bladee	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3219d5bb-8219-4e1d-aa98-649ebd5852ac	2022-08-16 15:45:28.194799+00	https://www.youtube.com/watch?v=2KkMyDSrBVI	Obedient ft. Ecco2k	{"drain gang"}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Bladee	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
10309c6c-f949-461a-b392-98b9eb3298fe	2022-08-16 16:47:57.618342+00	https://soundcloud.com/bladee1000/bladee-mechatok-rainbow	Rainbow	{"drain gang"}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Bladee & Mechatok	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4bcd078f-efcb-4639-aa4d-c75263157287	2022-08-16 17:38:33.045178+00	https://www.youtube.com/watch?v=Ug3g3F9gwGM	Wrist Cry	{"drain gang"}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Bladee	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
47c08da9-01c9-41e1-b17f-385150d7b6ff	2022-04-30 20:15:46.87556+00	https://youtu.be/P7MKx1F5mus	Ambition For Cash	{🔦,"Key Glock"}	2	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Key Glock	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
493deda8-3d76-41be-8a14-bc8ec0175874	2022-04-01 15:12:59.653108+00	https://www.youtube.com/watch?v=RPpXgrjmgHA	Glass House	\N	2	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Paw Paw Rod	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
137d87af-2691-444c-8aae-7c5f55000849	2022-04-17 01:11:32.566922+00	https://soundcloud.com/sapphireblue/how-i-feel	How I Feel	{"New Orleans"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	BluShakurX	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
db2f0044-dd1c-4992-a263-93c6ce0a9074	2022-04-30 17:41:53.417292+00	https://soundcloud.com/praisemusic/life-unknown	Life Unknown	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Praise	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a77466e5-90b0-4c03-aa9c-7f5e755b6069	2022-04-17 01:29:41.829627+00	https://youtu.be/Blx0h-RDPgQ	Time Gon Tell	{🔦,"New Orleans"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Guwap Dash, La Reezy	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6bd868f1-3823-406d-b03e-1800438200d6	2022-04-17 01:38:56.182512+00	https://youtu.be/jM5qWGnwnj8	Time	{}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Ferge x Fisherman	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a745b2f3-c653-46bd-98c8-4d4782a37db4	2022-04-27 15:25:06.799998+00	https://youtu.be/avkIRiL2q_M	FINAL FOUR	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Flee Lord & Mephux ( Ft. Conway The Machine, Roc Marciano & Trae the Truth)	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d23d891a-27e7-4131-8a9a-71ad9be21c84	2022-04-23 23:10:25.588836+00	https://youtu.be/VJ8wK8Z-g4o	River Keep Running	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Acantha Long	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8f76322b-89ac-4e2a-a3ee-995573fb61e2	2022-04-17 00:51:22.611393+00	https://youtu.be/XsWXgK1okwE	Ice Cream Man	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Chase Plato	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
36b2740e-6a74-499c-9a4a-25788495b80b	2022-04-29 18:31:16.043782+00	https://youtu.be/yy1X6ThVNyM	Duntsane	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Young Nudy, BabyDrill	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
046594f9-4103-4002-b408-6a0dd1716e91	2022-04-01 14:45:37.43669+00	https://www.youtube.com/watch?v=RPpXgrjmgHA	Glass House	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Paw Paw Rod	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0bd5fb2b-1ccf-4fa7-a02a-9d838f7ed598	2022-04-01 15:15:16.769936+00	https://www.youtube.com/watch?v=RPpXgrjmgHA	Glass House	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Paw Paw Rod	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
9fedaed1-4c82-4f79-95b1-1432a43855f6	2022-04-23 22:23:11.991493+00	https://youtu.be/zZgG9KEhdMI	The Shine	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Tony Bontana	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
22346569-3b6c-4561-a824-783a41806470	2022-04-21 14:05:29.957841+00	https://soundcloud.com/yayabey/keisha	keisha	{🔦,R&B}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Yaya Bey	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
593413b6-9776-44a8-b9a3-9343b5110709	2022-04-19 17:12:39.268471+00	https://youtu.be/FlCIu8KLjuQ	One Night	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	ADMT	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
38249abb-8213-4ce3-9b5c-bc122af5754b	2022-05-21 19:16:46.236641+00	https://youtu.be/fMwcjt9Xarw	Ironic	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Ezale	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c47280e6-f6e2-4075-9bdf-2ac347fcefe7	2022-04-21 14:02:32.128929+00	https://soundcloud.com/leonemusic/2021-prod-mcquaid	2021	{🔦,Rap}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Frank Leone	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ef6b29d6-981a-4e26-8744-3e4134c9efba	2022-04-08 17:00:20.045704+00	https://soundcloud.com/pjd_music/nimbus	Nimbus	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	pjd.	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
dbabeb33-00f8-41ef-b1a4-eba026be1618	2022-04-27 19:04:30.662988+00	https://soundcloud.com/blxst1/sets/before-you-go-889532149	Before You Go	{🔦,Cruising,R&B}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Blxst	\N	hallway	{0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e1a97a3e-f127-4461-9ae6-ba3ffe8b976e	2022-04-17 01:13:04.440948+00	https://soundcloud.com/jasmine-williams-201/4-u	4 U	{🔦,"New Orleans"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	OddtheArtist	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f9e8a868-51cc-4e33-a0ca-a7fc58ebfac0	2022-04-30 20:19:01.403031+00	https://youtu.be/2cwbqwZS7So	Shake Em Off	{🔦}	2	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Trae tha Truth, Babyface Ray	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
428ff907-cbda-4f7e-bd56-204c0fc169ee	2022-04-19 16:47:56.106037+00	https://youtu.be/Paa__1jBMMM	SWING IT!	\N	3	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Kaelin Ellis, Sw8vy	\N	hallway	{0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
501cc7ad-855a-4038-991d-2e79e25724b5	2022-04-21 14:35:48.145219+00	https://youtu.be/eL2L2fXJokc	Anytime	\N	3	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Joony	\N	hallway	{0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
cc81e974-36c1-4b20-aef5-8d9c82d6ae95	2022-05-03 19:05:48.059657+00	https://youtu.be/3ta0cPNyFUw	Degree	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Cola	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c7aabec5-a546-4114-84fa-ceeb9969e666	2022-05-04 13:26:16.852421+00	https://youtu.be/Frpr909nO-s	Timbaland to Yo Missy	{🔦,"Van Buren Records"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Meech BOLD	\N	hallway	{0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
aa8501b8-8920-4e4e-93ba-52138a04cce5	2022-05-10 05:06:46.069032+00	https://open.spotify.com/track/1t6h7C3pQyTqHwekmhrNGZ?si=jL9M-OldTnSm1dZKTKQxQQ	On Mommas	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	U-N-I	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
79644533-ebfb-41fd-acf7-d3030d472f33	2022-04-17 01:46:59.990962+00	https://sichtexot.bandcamp.com/album/plaything-cipher?from=embed	Plaything: Cipher	{🔦,Instrumental}	2	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	fat jon as Maurice Galactica	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
57d50757-6aa9-469d-9fd9-2d06a8eca61a	2022-04-23 22:50:02.132051+00	https://youtu.be/42W4k7C5vmI	By the Way	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Maandy, Exray, Trio Mío	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
fa6d731f-ee46-4879-9522-20c0fdc3507d	2022-04-23 23:26:39.341538+00	https://youtu.be/vhWTfbBygUE	First Batch	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Ben Marc	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
21ab6277-6437-40f2-922a-e1c89559d512	2022-04-30 18:47:31.163891+00	https://soundcloud.com/mitchmoney/rocket-bunny-feat-pitchblk	Rocket Bunny	{🔦,seeyousoon}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Mitch$$$, PitchBLK	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e87aa249-b06c-40ca-9f44-3378c7b9b160	2022-04-23 22:52:12.098163+00	https://youtu.be/MiMPut0PjVw	Wonder	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Diamond Platnum	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e674dcd0-35e5-4d8e-96ff-3c847a0e8120	2022-04-17 00:28:53.274735+00	https://youtu.be/zO9VEB9lfXM	Heavy Heart	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Bartees Strange	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ec195ea0-c6c2-400e-998a-59ce4b27480c	2022-03-31 15:35:06.203422+00	https://totallyenormousextinctdinosaurs.bandcamp.com/album/when-the-lights-go	Blood In the Snow	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Totally Enormous Extinct Dinosaurs	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f2961914-6646-4674-8be2-d909b89da824	2022-03-31 15:22:24.059497+00	https://soundcloud.com/civil_writez/civ-in-the-i-e	Civ in the I.E.	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Civ Pierre	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0167f4d2-f1ef-4144-8495-65e0a9b3cdd9	2022-04-23 22:53:31.002217+00	https://youtu.be/zjcwr-Bf5nQ	Toko Toko	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Dadju, Ronisia	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0438ad44-a15e-4efa-9c6a-42c8a8686ef0	2022-04-21 14:45:25.085096+00	https://soundcloud.com/trecapital/bridge	Bridge	{🔦,Rap,"West Coast"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Tre Capital, Xzibit, Nottz	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e51325fa-7c9b-4edc-8c8a-571a11188d06	2022-03-29 16:08:53+00	https://nbatopshot.com/listings/p2p/3e9f35e2-a880-4de0-9dd4-25dd30c3edad+091e600c-8cd6-472c-8792-55db3bcc2edf	Dunk Throwdowns (Series 3)	{}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Daniel Gafford	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6c1b900b-25cd-41a8-bd07-73e2c5ac8f3e	2022-03-29 16:16:53+00	https://nbatopshot.com/listings/p2p/3e9f35e2-a880-4de0-9dd4-25dd30c3edad+361f8878-3a15-477e-a2e1-66a816f2b79a	Dunk Throwdowns (Series 3) (KG Jersey Retirement)	{"Kevin Garnett",Dunk,"Jalen Brown",Posterize}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Jalen Brown	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
30e242d0-3cab-4416-9f86-93bb66fc9963	2022-04-23 22:11:23.291933+00	https://youtu.be/BE3vRF2QnT0	Jive	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Tate228	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
84de5844-0e2f-4167-bd81-93aa73346c7e	2022-05-10 16:20:27.725683+00	https://youtu.be/VmdQ16aYER4	Blue Ceiling	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Moanday	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
803af2d4-4d2c-484b-b881-d390b8e49b56	2022-03-09 20:19:07+00	https://foundation.app/@abieyuwa/foundation/56683	Agwọ (Éké)	{}	4	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Abieyuwa	\N	hallway	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x1ce9200E1547F8bfb3EFa961FF0b8F88356Ccae2,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0x52fA05393a003d234eFBA136E68DA835aeB64a26}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d70e5e45-d0a5-43f2-afa3-a4dc90b2f7bf	2022-10-26 19:19:41.413689+00	https://www.youtube.com/watch?v=XPd1cB2yy4o	Boundaries	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Jamila Woods	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7ee46bf4-aca6-49fb-a49d-081985730848	2022-04-08 17:20:31.610543+00	https://drive.google.com/file/d/1rDrF3-_Qe-yJAVICo71wtl0bUOgKEChd/view?usp=drivesdk	Same Shit	\N	2	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Isaiah Cotto	\N	hallway	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
36fdeb0e-e12d-4a89-b2aa-28c7fdda3d6e	2022-04-19 17:31:42.137022+00	https://youtu.be/nM0k0uP8DJY	Nunu	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Airplane James	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
25685fd5-a185-4f7d-bbef-2d3071a8a5ae	2022-03-31 15:27:01.701067+00	https://youtu.be/cp_6N3MTJvM	better	\N	2	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	redveil	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
54e5948f-dc81-4215-9c55-b671a3a04a87	2022-03-31 15:37:14.536294+00	https://pachyman.bandcamp.com/album/el-sonido-nuevo-de	 El Sonido Nuevo de	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Pachyman	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
54842123-89c8-43c9-83c1-820a28259366	2022-04-17 00:34:15.925959+00	https://youtu.be/muEyle9evDQ	New Beginning	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Automatic	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
46002238-b60e-4d06-8557-d07737073c84	2022-03-31 19:56:15.741968+00	https://youtu.be/6Or6STx6UFU	505	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Coast Contra	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
fde55456-8297-48da-bcc6-bfc07719e35d	2022-04-04 17:44:48.457872+00	https://youtu.be/68tfpvdnsv0	Put It Down	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Kevin Holliday	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2dae4851-8feb-4fc3-8679-fa6c59b9f86a	2022-04-23 22:13:04.878382+00	https://beta.catalog.works/abjonian/about-you-	about you.	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Abjo	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
9da12ad8-a8c6-41f9-9d64-887b6a346eff	2022-04-23 22:55:17.150823+00	https://youtu.be/OaQ3GOLh6mU	Wrapper	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Blade Brown, K Trap	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1f9b34e8-f290-4301-9cad-2d67e26053f4	2022-04-30 19:15:02.432124+00	https://soundcloud.com/tannaleone/february	February	{🔦,pgLANG}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Tanna Leone	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3c293fc3-dc8e-4376-91b1-6a7b48987b5a	2022-04-17 01:16:23.161013+00	https://soundcloud.com/sleazyez/stuck-inside	Stuck Inside	{"New Orleans"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	$leazy EZ	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3d86a157-4d56-4589-82dc-475c12788053	2022-04-21 14:53:23.708526+00	https://youtu.be/VvLmFWHYGTk	Let Me Talk My Shit Pt. 3	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Sleazyworld Go	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ea51e9fa-74b5-4a23-b53c-0257b73ecd60	2022-04-08 17:22:49.426064+00	https://soundcloud.app.goo.gl/vYAdFWAAux3Y8Ucp6	Doctor K-Hole	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Luxtress	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2b89e9e6-f472-4427-af7f-c9f4b4cb1326	2022-04-08 20:19:28.459046+00	https://youtu.be/-gDHbVCSnuk	Backwards	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Lil Silva, Sampha	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8afc5daa-cd7d-4d2f-b48d-db1846566a14	2022-04-23 22:15:26.461201+00	https://youtu.be/1QOf5M0aMGI	Statistics	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	YL and Zoomo	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f3b4e003-6a1b-4e01-ae15-31dd886d3a5f	2022-04-23 22:56:31.852386+00	https://youtu.be/9sDu6jL-EeI	Hart	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	David Armada	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
185dc8d6-2601-4973-bab9-20bcb2d0f591	2022-03-31 15:24:38.90909+00	https://soundcloud.com/civil_writez/inland-pressure	Inland Pressure	{🔦,"Inland Empire",California,Rap}	3	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Civ Pierre	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a33a4784-46b3-4aad-9cf7-8ee114e12b38	2022-04-23 22:17:47.804472+00	https://beta.catalog.works/blackdave/sharp	Sharp	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Black Dave	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2e74f0dd-f6e1-4426-b0f7-35f640fe25e2	2022-04-30 19:20:03.945124+00	https://youtu.be/iA8iAZiR2RE	Repeat	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Houdini, NorthSideBenji	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0ad53e2b-f1b6-4d16-9075-73af8331ba7a	2022-04-17 01:44:37.46049+00	https://scvtterbrvin.bandcamp.com/album/hollywood-outlaw	Hollywood Outlaw	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	SCVTTERBRVIN	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4c6e1250-9678-4e10-b9a4-7a83fb02484e	2022-04-17 00:40:51.522176+00	https://youtu.be/BCQiAozfK0E	God Is A Reptile	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	JayWood	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2bde6f0e-fd38-4a50-a9d6-b87bb217ac30	2022-04-21 15:00:49.999149+00	https://youtu.be/IEU7AfQ9_ig	See You Soon	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Akemi Fox	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
52ac1f6d-e3d0-4d92-bb24-e3010d7e613e	2022-05-07 21:36:28.390854+00	https://youtu.be/WSmwBoW_tgk	NAS FILM	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Trillary Banks, Dibo Brown, Pariz	\N	hallway	{0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
572e01aa-c62d-4cba-9dfe-c50bf0fdbad0	2022-05-09 15:18:23.763068+00	https://youtu.be/Gbg5qDG-bPk	Die Hard	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Knucks, Stormzy	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ae68162a-dd01-4de7-98b1-d3bca8e3ec20	2022-05-09 20:33:49.484712+00	https://youtu.be/0A1pL9A3yRM	Bring It Back	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	JayBaby TheGreaty	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3dd0083d-e4e5-450a-9222-d62891762d31	2022-03-29 15:52:51+00	https://nbatopshot.com/listings/p2p/e769f4b4-b469-45be-b777-0f9e24d548e2+2084578e-1ba4-4645-8d45-ae82f4c6a37b	Assist Metallic Silver FE (Series 3)	{"Ja Morant"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Ja Morant	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
5ea5efd5-e4c4-4ff8-991b-b29d39065050	2022-04-29 17:46:32.883324+00	https://soundcloud.com/champagnesavvy/sets/poor	Poor	{🔦,Tennessee}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Savvy	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
91e5c36b-ad5e-4936-accb-2641f7123c7d	2022-04-17 14:17:33.437593+00	https://saultglobal.bandcamp.com/album/air	Air	{🔦}	2	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	SAULT	\N	hallway	{0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74,0x7d1f0b6556f19132e545717C6422e8AB004A5B7c}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c2823408-01a8-4058-9175-46cc03ed94c2	2022-10-26 19:36:50.693512+00	https://youtu.be/GAaGca9K48U	The Light	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Loota, Brodinski, Modulaw, Gliiico	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
cd19c820-9a26-490e-88c4-905fc18dd324	2022-03-25 18:34:11+00	https://soundcloud.com/abstract-media#:~:text=Abstract%20Media-,Maytag%20(Tax%20Free),-Posted%201%20month	Maytag (tax free)	{🔦}	2	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Ben Reilly	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b789c1a2-2673-40c4-95d3-d83d62531310	2022-04-30 17:25:16.445479+00	https://youtu.be/8MUwBrHK85g	Dancing Queen	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Baby Tate	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8dd1bed2-f26a-47a3-9e05-5e1f7538c344	2022-04-30 19:22:53.247948+00	https://youtu.be/ZQuWSyeFvzQ	Letter 2 My Brother	{🔦,4PF}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Lil Kee	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
307f251a-49c1-4646-a2be-26a9bed1a984	2022-05-16 18:09:47.392992+00	https://www.youtube.com/watch?v=Jprzsxj5k8U&list=OLAK5uy_lcjCRO1kX9JNoalf6aAF8GytczC70-pZ4	Aethiopes	{🔦,album}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	billy woods	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c327d8b8-b693-4113-8d31-7a25a951ee20	2022-03-29 15:38:05+00	https://nbatopshot.com/listings/p2p/757f23fd-f7ae-465c-a006-f09dcfd5dbd5+636300a8-d470-4dcd-b2f2-3ef623965c74	Dunk Throwdowns (Series 2)	{"Ja Morant",Dunk,Rare}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Ja Morant	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d4d61733-c1e6-483c-a27e-9f0f8a1fd7fa	2022-04-23 22:19:13.438553+00	https://youtu.be/QlX0ttXd-m0	Dayton 88	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Seafood Sam	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
555d8c67-73b8-4b39-ac8e-c43495e72722	2022-04-21 14:01:49.643062+00	https://soundcloud.com/leonemusic/from-the-jump-prod-mcquadi	From the Jump	{🔦,Rap}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Frank Leone	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
aa3d3087-f96e-44c5-95dc-37c4fee8cdbb	2022-04-08 16:55:50.613752+00	https://open.spotify.com/track/0tyCOpYTebKHT52hv8PkkE?si=J-aiyp9nRsaZHwY_6UdLtg&nd=1	Coretta	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Zay Lewis	\N	hallway	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
5692d058-db0c-416d-aaa8-6102241475dd	2022-04-08 17:01:24.440111+00	https://soundcloud.com/divine_wrath/woah	Woah	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Divine Wrath	\N	hallway	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f8549959-df71-412c-a33f-ad989b1fcdfd	2022-04-17 01:33:54.209605+00	https://youtu.be/Bzm0WlqaFBo	Yearnin	{"New Orleans"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Stone Cold Jzzle, Cash Cobain	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
13389a20-3ed1-4fe3-8ee8-fc1b476ead8c	2022-04-17 01:35:53.402212+00	https://youtu.be/GpH0K119cQk	Problems	{"New Orleans"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	OddTheArtist	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2eb4b619-6394-4a77-8648-af132fbfea87	2022-04-30 19:30:07.442406+00	https://youtu.be/67_C9FRkyGU	Lower	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Big Jade	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1de77d58-d57b-4fa1-8d5e-2c2a0ac69882	2022-04-23 22:21:36.373387+00	https://youtu.be/kz1cxVpsyeY	Oh Really	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Lou Phelps, Guapdad 4000, Joyce Wrice, Kiefer	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
afb9883b-8244-4400-853b-973fa0d28021	2022-03-04 19:14:04+00	https://zora.co/collections/0xD4878B9A2903B92420d871fc3D5484911582ca19/2	All You Care to See: A Music Video	{}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	ALARA	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
597c174b-dc6e-4e4d-9901-01179fbe56e7	2022-04-17 01:10:32.390765+00	https://youtu.be/ncP7g9MtsOU	Sliding On the Intro	{"New Orleans"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Tatyanna XL	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
edb022e6-228b-41cc-a50f-9b07f4671ce6	2022-04-17 00:58:37.712162+00	https://youtu.be/hpnwm91JP3Y	Colour Me Blue	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Alfie Templeman	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a9db8606-c544-4767-9255-d8f397c046b4	2022-04-30 17:34:27.671216+00	https://youtu.be/B2nZ_e0_jHc	The Rhythm	{🔦,Hatchie,Canada,"Music Video"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Hatchie	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
bdec20e0-6939-4351-b140-f10cec0fcab0	2022-04-29 18:28:01.839136+00	https://youtu.be/n3T5WvzuLDQ	Fireman	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	FNF Chop	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6c408675-86ea-4896-bca4-b460f8b7ddf7	2022-04-23 23:03:52.888772+00	https://soundcloud.com/jonvinyl/favours	Favours	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Jon Vinyl 	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7fc8f40e-2021-41e5-89c6-523c9cfedbb6	2022-04-17 00:06:58.95077+00	https://youtu.be/I1WPDHrrRMQ	Not Born To Behave	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	MDRA, Spoogzz	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
69050642-feba-4cef-8452-1fedbf6c1590	2022-05-10 04:38:32.741384+00	https://youtu.be/erwZ14QMG0M	Savior Complex	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Brandon	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6b391b82-4979-44f2-9b75-e7945c6b6a32	2022-05-10 16:47:52.816037+00	https://youtu.be/r1asrhWt_fM?list=OLAK5uy_m_UUDYj8KS6i520Vpah7E4iEQp1d6UNBE	Letters from Home	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Malcolm Parsons	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c674b7bb-81eb-4aef-be01-2de44e74e6bd	2022-05-10 17:15:51.091898+00	https://soundcloud.com/when-we-dip/premiere-kaz-james-footprints-another-record-label	When We Dip	{🔦,Instrumental,"Weekend Ready"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Kaz James	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c59daaad-7a9e-4482-b4b7-828594799403	2022-05-13 15:35:07.331143+00	https://duvaltimothy.bandcamp.com/album/dukobanti	Dukobanti	{🔦,UK,"Carrying Colour"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Duval Timothy	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
cc7e560f-2c74-4758-9ba7-44b7c8fac53b	2022-05-16 15:18:27.337883+00	https://youtu.be/K_hkwDs5y6M	I'm the One	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Big Moochie Grape	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3a23a71c-1b0f-4c42-97e2-da35a3abe27e	2022-05-16 17:29:27.09412+00	https://youtu.be/80l_waLeFZY	Hotline	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	bLAck pARty	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4bec8246-3349-4313-b8e3-c218005b41c0	2022-05-16 17:55:37.085973+00	https://youtu.be/9SB1Zop0Ko4	Hold the Line	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Bartees Strange	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1d1c4385-fa2b-4c1e-9930-873f8a1cd538	2022-05-15 17:34:02.464944+00	https://youtu.be/H8tFWMxMaDE	Too Much	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Lucky Daye, Mark Ronson	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
958851c1-e391-4110-9f67-cfaa8cbb94c1	2022-05-16 13:37:00.470208+00	https://newmoralityzine.bandcamp.com/track/lose-my-head	Lose My Head	{🔦,Punk}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Camp Fade	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8dea42b9-9b43-435b-b2a8-1824005d5e01	2022-05-16 13:43:06.952231+00	https://youtu.be/xyz2VE3uCbg	Spiritual Delusion	{"Stamp The Wax",🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	D.Tiffany and Roza Terenzi	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3b220adf-a785-4ee6-a387-2d21af9186f3	2022-05-16 13:48:57.774381+00	https://youtu.be/DkYQW3_dWcA	Never Was Wrong	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	BLXST	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c8e22cb1-9d1b-4388-9dc9-ae14ea4bc206	2022-05-16 13:50:08.740029+00	https://youtu.be/bwghoT8Fo3Y	Gold	{🔦,R&B}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Arin Ray	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
81815084-fc5c-426f-9dc5-e86716bd1b6d	2022-05-16 13:51:56.645726+00	https://soundcloud.com/meechlife/sets/let-there-be-light-487530689	Let There Be Light	{🔦,Album,"New York",Rap}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Elcamino	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e2f3b323-1aca-4b3b-aec6-e2bf3133f791	2022-05-16 13:53:41.790424+00	https://youtu.be/brbOTU5TiKY	The Deal	{🔦,"Drakeo The Ruler","Music Video"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	DaBoii, Drakeo The Ruler	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
5cb83268-c702-417f-b2d6-52c27979aa74	2022-05-16 13:58:35.809271+00	https://youtu.be/_G6Px7xVURI	Echauffement	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Dayo Lamar, Fior 2 Bior	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
62469d7b-d97e-4afa-8d0a-f8a8a3f1d7f2	2022-05-16 18:19:47.4902+00	https://youtu.be/HUXCJfetaB0	Blat Blat	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Nolaboy, Yung Ro	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
66e60777-7139-4d22-9d7d-8efc82d06441	2022-05-16 17:34:23.275385+00	https://youtu.be/H8Wgwp3Nhgo	Came In the Scene	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Headie One	\N	hallway	{0x5ab45FB874701d910140e58EA62518566709c408}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c4bb1d28-5a9f-48fb-aea5-785d409977ce	2022-05-16 18:10:51.966031+00	https://youtu.be/I1g-fmMNeQE	Ultra Magnetic	{🔦,rap}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Ta'East	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7e2008e4-a871-445a-a3ad-d23eca157124	2022-05-21 23:17:54.014391+00	https://www.youtube.com/watch?v=-LxqaWvX61M	Jolene	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Victony, KTIZO	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d92ae6b8-8cbc-4a76-837f-6b9cf23a9de8	2022-05-21 18:11:19.007461+00	https://youtu.be/1jxuLtCwqUo	iScream	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Deaton Chris Anthony, beabadoobee	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
78e1ef33-6e08-4259-bf60-0fc7fe449c2a	2022-05-21 18:13:13.85975+00	https://youtu.be/5tKdZWK1iAs	Pressure Cooker	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Dazy, Militarie	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8009dbfd-a608-4eaa-a93b-0f3afa5a905c	2022-05-21 18:16:26.680429+00	https://youtu.be/aXv86L9AyYo	5 Mississippi	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Boldy James, Real Bad Man	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b7047354-c64e-4161-a670-dd0ae343ab77	2022-05-21 18:19:58.228552+00	https://youtu.be/qnNqTKGsuhM	Made Of	{"Lyric Video","Music Video",🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Phoenix James	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
663ebbde-db99-48fe-a150-b8e8ee38482d	2022-05-21 18:21:00.391894+00	https://youtu.be/03C0wlQA37c	Fulton Park	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Cola	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b9fcca8c-361c-4d1f-b8a5-111fbc387ff6	2022-05-21 18:22:41.233707+00	https://www.youtube.com/watch?v=kzT9QJbEssU	Water Table	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Cola	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
06cde1fc-59df-4654-9cef-d0fd28afc537	2022-05-21 18:24:53.943112+00	https://youtu.be/Xo-FdoN9CwM	Callin'	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Deante Hitchcock, Big KRIT, WESTSIDE Boogie	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4508a3ec-bdc4-4923-abbd-a2981a1a591c	2022-05-21 18:27:51.110861+00	https://youtu.be/etjao24Rjm4	All My Children	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Deante Hitchcock	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0d19c66f-703f-445e-83cb-1a933f39c515	2022-05-21 18:37:07.433917+00	https://www.youtube.com/watch?v=rIg109Bm1L0	The Codes	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	IDK, Mike Dimes	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1429e26a-5461-431b-b44f-b1101aa45df9	2022-05-21 18:38:28.488912+00	https://youtu.be/59jH6Eom6x8	Straight To It	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Young Devyn	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
81812a8d-09e8-426c-8558-d1a7ca1c1db7	2022-05-21 18:58:56.027092+00	https://www.youtube.com/playlist?list=PLS2VSTPe3ipeqGf2BLRVt3Jgs9fs6RI5D	With The InCrowd	{Album,🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	AGAT	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
202657da-46fd-48ee-9ffa-304d940b520c	2022-05-21 19:10:59.033129+00	https://www.youtube.com/watch?v=FCA9u88nOuA	Like This	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Young Devyn	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7c266a98-3200-4755-b9fd-85330597248d	2022-05-21 23:22:19.189249+00	https://youtu.be/DFDyUpU-0uY	Kolomental	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Victony	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f7c3f14a-126f-4463-a1f8-3a5c87708081	2022-05-21 23:26:32.541504+00	https://youtu.be/Bg844EncclI	Alcatraz	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	French Montana	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c3ab0f47-94ff-4363-b7c2-846a983e37e5	2022-05-21 23:29:08.454198+00	https://youtu.be/d6_8C_rlVBI	22 Carats	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Headie One, GAZO	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
fe6fff93-132d-4035-804b-41e78cd08cb2	2022-05-21 23:34:25.418619+00	https://youtu.be/oG0xynhEnuc	Suffer	{🔦,UK}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Giggs, Tion Wayne	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ab302e1d-cb3e-48da-8a2c-1d598f71b09a	2022-05-21 18:31:52.942296+00	https://youtu.be/TKKDMTLMAAw	Drugstore	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	IDK	\N	hallway	{0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ed4a496f-f40d-4cfd-97ee-c272d3648a6b	2022-05-21 18:35:38.808083+00	https://youtu.be/7cr03aONVpI	Zaza Tree	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	IDK	\N	hallway	{0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f32d7a20-7600-4b77-8265-1e2cc0ab073c	2022-05-21 18:18:01.741843+00	https://youtu.be/7Yw9IxykmUI	Tell Me Why	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	WET	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0663d4af-7580-43e0-8f0c-3a9ee1c5d97d	2022-05-24 00:40:27.075331+00	https://youtu.be/H48Seaa0_LY	Glitchin	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Miles From Kinshasa	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0a2c6f89-6399-48ad-85cf-0cfb7c7209ac	2022-05-24 01:55:31.396671+00	https://anwarmarshall.bandcamp.com/track/sphere-2	Sphere	{🔦,Instrumental}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Anwar Marshall	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
eb85a4ab-fb26-4251-984f-a18406302bd2	2022-05-31 12:46:52.558512+00	https://youtu.be/iuqWkbTCbt8	Drop	{"Cool & Dre",🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Yung Pooda	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4e632ee2-3244-45b1-843f-40c0a2f15be2	2022-05-31 12:26:39.984058+00	https://youtu.be/ZDOKtQrQvaI	Randy Moss	{🔦,"A$AP Mob","Music Video"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	ASAP P on the Boards, MVX	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
671b0dfb-d67e-49f9-98a8-9cab8057ac34	2022-05-31 13:27:53.628868+00	https://youtu.be/oE2gLNAB8Fo	Return of the Manc	{🔦,UK,"GRM Daily","Music Video"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Just Banco	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
eae963b3-a966-4249-bab2-4cbeac6e197a	2022-05-31 13:22:53.87931+00	https://www.mixcloud.com/djtahleim/the-wonder-of-fania-vol-2-stevie-wonder-fanial-all-stars-tribute/	The Wonder of Fania Vol. 2 (Stevie Wonder & Fania All Stars Tribute)	{Mix,🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	DJ Tahleim	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
624e3845-3552-461e-a2b5-88fee5ab6042	2022-05-31 13:41:33.160061+00	https://youtu.be/4nRV4TBS6PM	Borrow	{🔦,"Music Video"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	KayCyy	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d4d9fe96-9498-4f06-b21e-871d7dbccf0b	2022-06-04 19:29:51.828223+00	https://youtu.be/7guj5DWRftI	"I Wanna Dance With Somebody" ( Turnstile Live Concert )	{🔦}	2	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Whitney Houston (Mosh Pit)	\N	hallway	{0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74,0xfFba44c15Fe2768bC2234078dfac8c5A651A56e9}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8c4e3cd8-4436-4e29-8526-a14b72beccf7	2022-09-25 21:07:07.315286+00	https://youtu.be/7efMRORlCTM	Time	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Giveon	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ae82a2fa-4431-4016-a305-d1fbf4ffab5f	2022-11-17 00:23:13.830781+00	https://youtu.be/HIj6N0XAKyk	Off Them Thangs 	\N	0	\N	0x91af49c2eba7197d1ecfd54a74cdc9f7e94a3a23	\N	Killa Fonte (feat. Bla$ta)	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d507a2e2-404c-4016-9778-cb05221fa3db	2022-06-12 23:18:03.484216+00	https://belowsystem.bandcamp.com/track/keep-it-a-buck?from=embed	Keep It A Buck	{Seven,"Kansas City","Los Angeles",🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	TRIZZ, MIKE SUMMERS	\N	hallway	{0x52fA05393a003d234eFBA136E68DA835aeB64a26}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
819d6ec6-04c1-4906-8663-7f13a1c0219b	2022-06-12 23:08:48.831889+00	https://youtu.be/B19sFdI9PzE	3D	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Ravyn Lenae, Smino	\N	hallway	{0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a8ae1556-b1a7-40f5-ad96-0016b74d777e	2022-06-27 01:59:51.188177+00	https://youtu.be/ANRzUDXB9XI	Price of Fame	{"Lost Kids","Brent Faiyaz","House Cleaning",Essentials}	3	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Brent Faiyaz	\N	hallway	{0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x52fA05393a003d234eFBA136E68DA835aeB64a26}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
5452177c-36aa-49c1-bcb0-c3d6922eba9b	2022-06-27 13:49:33.924233+00	https://theia.finance/	Partner?	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Theia Finance	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f65f283d-263f-4acd-88cb-6fa29913d4c7	2022-05-24 16:22:40.949856+00	https://youtu.be/LiiCZSu2L5g	Blackout (Live on Fallon)	{🔦,Live,Turnstile,Maryland}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Turnstile	\N	hallway	{0xfFba44c15Fe2768bC2234078dfac8c5A651A56e9}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
01b35776-b074-45ce-96b0-e6fc1a9ff2a1	2022-06-17 14:11:41.059237+00	https://youtu.be/OLn2Ct5zd-M	Mirrorball	{🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Zinadelphia	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
82919f34-8d78-4aeb-b14f-a579ed17fb76	2022-10-26 19:45:22.810167+00	https://youtu.be/-v4IJ9f8mMQ	Burning	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Loota, Brodinski, Modulaw, MOSS OMEN	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8dbea5ea-a79b-4b8f-ba99-dc05a630ffe6	2022-06-27 16:21:22.724903+00	https://nervus.bandcamp.com/album/the-evil-one	The Evil One	{Album,🔦}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Nervus 	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
89655c23-8838-484f-a4c6-abd58a5134c7	2022-06-22 16:53:01.13082+00	https://youtu.be/NHem6_GOKz4	2020 Vision	{🔦,"Music video"}	3	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Raury	\N	hallway	{0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x52fA05393a003d234eFBA136E68DA835aeB64a26}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a4bd4f73-f0e2-4246-8659-b36b5edf4c55	2022-06-27 16:16:05.63596+00	https://youtu.be/kHNCHjmFSck	Too Precious	{🔦,"Music Videos"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Em Beihold	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c69aaa15-140d-49b3-b516-cb495c5e3fb9	2022-07-24 23:17:42.204174+00	https://fauzia.bandcamp.com/	Time	{🔦}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Fauzia	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a639964b-613c-410b-aefa-bc50160a936b	2022-08-11 19:58:59.555726+00	https://youtu.be/K1-OmSFrbRw?list=PL1fQIY0gm4JaKDTyR20j8HylH7IzX5Wyf	Nun To Do	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Young Nudy	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3b791720-978e-4a7a-80d7-d81e5cb02cdd	2022-08-11 20:08:16.778076+00	https://youtu.be/SIHS1lLzqOo	Picture in My Mind	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Pink Pantheress, Sam Gellaitry 	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c0c63d02-b56d-4b5e-a693-e5cada60c0c4	2022-08-12 13:55:21.852037+00	https://youtu.be/JUBqJzLPjXE	Persuasive	{🔦,TDE,SZA,"Music Video"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Doechii	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
831324d9-7a59-4f57-9be6-63b20bc89b4b	2022-11-17 00:24:35.667161+00	https://www.youtube.com/watch?v=jkOWPIw6dBM	Gospel	{"UK Rap"}	0	\N	0x91af49c2eba7197d1ecfd54a74cdc9f7e94a3a23	\N	Glizz	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
02d72312-0471-4a8b-98b5-bfaec4f23793	2022-06-30 16:25:51.377821+00	https://youtu.be/7Oe3p9lUqCg	Liquid Light	{🔦,"Music Video"}	4	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Butcher Brown	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74,0x52fA05393a003d234eFBA136E68DA835aeB64a26}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
90f26b8b-f5e5-4525-b8fc-76264134a8d4	2022-06-27 16:35:25.464344+00	https://youtu.be/s9j-9lUJSwQ	29 (Freestyle)	{🔦}	3	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	JID	\N	hallway	{0x52fA05393a003d234eFBA136E68DA835aeB64a26,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
5deb93e3-e0b9-4c88-854a-177daa9d7b3c	2022-08-30 13:40:57.325851+00	https://soundcloud.com/skyzoomusic/humble-brag?si=0da27d0bb6524b25a2ab7b29ae2d96e3&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	Humble Brag	{"old school","new school","around my way sample",sample,"good samples",humble,braggadocios,rap,"spoken word"}	0	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01	\N	Skyzoo	\N	lifeofclaude	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2b7efaad-de39-47e5-9ce7-029dd117204f	2022-06-30 16:28:58.757806+00	https://www.youtube.com/watch?v=XUtSjJUar3k	Fana Hues - "Drive" (See You Next Year Performance Video)	{🔦,"Fana Hues","Pigeons & Planes"}	4	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Fana Hues	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x52fA05393a003d234eFBA136E68DA835aeB64a26}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a0bfa5ca-67a4-40d0-b9f8-7309122153fa	2022-06-30 16:42:50.064326+00	https://youtu.be/glHqWvkpRqo	NPR Tiny Desk	{"NPR Tiny Desk",Live,DC,"Denzel Curry"}	3	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Denzel Curry	\N	hallway	{0x52fA05393a003d234eFBA136E68DA835aeB64a26,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
04bbca70-423d-4e6e-bfcb-940b66f88e0d	2022-06-07 01:33:59.358395+00	https://open.spotify.com/track/0A1DZSozhyiAiUoja2onGk?si=9463694b17d24980	Heart	\N	3	\N	0xfFba44c15Fe2768bC2234078dfac8c5A651A56e9	\N	OTR	\N	AcidPunk	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
cebf4a05-b56e-4212-b34d-ce063c3faf76	2022-09-06 16:08:11.998208+00	https://ipfs.moralis.io:2053/ipfs/QmYHc1ftbWHazeovAjJ4nBPAieDN9stsTuLngFiRCbPJEP	GLOKKDWN	{MARYLAND,BALTIMORE,"KING LYRIKZ","ENGINEERED MAD DELTA","MAD DELTA"}	0	\N	0x1502F98D90cc10b11B994566dFC44EC84035eCE8	\N	KING LYRIKZ	\N	Horace.eth	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
13a3dfff-9d34-402d-9f02-1c6a37dc9a99	2022-08-25 03:06:12.918957+00	https://www.youtube.com/watch?v=WUu39PJ_TI0	Cocoon	\N	3	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	070 Shake	\N	future modern	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
eb9fb415-c118-422b-8d6e-604b76cc35e2	2022-08-28 14:09:53.754749+00	https://open.spotify.com/track/3MltWdcj0XAvLh3kC8pvJZ?si=eabc46b3d4424bad	Search 2	{Makintsmind,"Codeine Dose 2.0","Listen to the lyrics"}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Coinz	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c7ab4d03-bef1-4b1a-93d1-274f9dc518a1	2022-09-04 23:02:53.485108+00	https://open.spotify.com/track/59nRrHhYBKARLtLanyZf6y?si=2a707af18e384b9e	Sleep When I Die	\N	3	\N	0x2dD3FefF13B61C98a792DB20a7971106e3352A7B	\N	Peezy	\N	\N	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
fe3b4d66-95a2-4bd6-a238-6bd696355c66	2022-08-19 19:26:58.55205+00	https://www.youtube.com/watch?v=p3V9vPFJc8s	Last	{"Headphones please"}	3	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Tourist x The Range	\N	Keenboo	{0x52fA05393a003d234eFBA136E68DA835aeB64a26,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
93e70039-10f1-4a13-b349-a57d1d589b14	2022-09-09 19:07:19.099582+00	https://youtu.be/qT26xHsprvk	Centipede	{#Amindi,#KennyMason,#centipede,Makintsmind}	3	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Amindi ft Kenny Mason	\N	MakintsMind	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
588e4df3-fd5a-44a8-b1ec-742b2925185a	2022-10-26 19:56:45.268893+00	https://www.youtube.com/watch?v=r1_BV_6Qg4U	Honeydew	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Loota, Brodinski, Modulaw	\N	hallway	{0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
5e59f0e2-c91c-491b-bfbc-b7a8d5263729	2022-11-13 03:25:33.79187+00	https://open.spotify.com/track/1LdNCXmBjZ59oZpUzR1yVM?si=vZtDsZ8sR5-pSxfAHVx8OQ&context=spotify%3Aalbum%3A6QviaEi8rHkwfYSRAHUZ8I	Miklatski 	\N	2	\N	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	David Sabastian, DJ Drama	\N	\N	{0x0bbac2bd3134a318deb31137d87d42bf54325cb7,0xf75779719f72f480e57b1ab06a729af2d051b1cd}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d5a138d0-9313-4247-b631-1b6ec6e32d54	2022-11-03 03:51:26.084219+00	https://open.spotify.com/track/6Pj3meDGkdOCufJoDO9sDJ?si=18b96c76916d448b	Orange Soda (Jersey Club Remix)	{🏴‍☠️}	2	\N	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	Sjayy	\N	\N	{0x0bbac2bd3134a318deb31137d87d42bf54325cb7,0xf75779719f72f480e57b1ab06a729af2d051b1cd}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7d49e9c6-1d8a-484f-bf61-8f108bdbe3ef	2022-11-16 19:09:11.839071+00	https://open.spotify.com/track/6NCHlfYsTsmrAHBerVXAEg?si=fed95e30d0cb483f	Roofie	\N	3	\N	0x2ad084d80b7034e31c8025fdbc8c32fa756eb4ba	\N	Maerko	\N	\N	{0x8d41859049c156e70fa381e07a757d5db2f33e1d,0xef58304e292fbaeacfdec25b67b3438031fde313,0x0bbac2bd3134a318deb31137d87d42bf54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e995befe-d506-4859-a622-f9b5737d5f32	2022-11-17 00:26:34.758665+00	https://youtu.be/rBZ4CK2tces	Us Against The World	{"Fully Lidge",Strandz}	1	\N	0x91af49c2eba7197d1ecfd54a74cdc9f7e94a3a23	\N	Strandz	\N	\N	{0x371107cc397a1fd11fd5a7ac8421a3e43f886444}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0e434b78-ebfe-4105-8274-6fd7cdf09b51	2022-05-04 00:58:09.181689+00	https://www.youtube.com/watch?v=rX8bK7pn3ZI&ab_channel=KennyMason	Play Ball	{atlanta,art,rock,genreless,hiphop}	3	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Kenny Mason	\N	future modern	{0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7a6ec5d5-6c6a-49af-820d-93c7cdf8b1ee	2022-10-26 19:58:16.632702+00	https://youtu.be/VupLK54x8Ro	Different Trains	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Loota, Brodinski, Modulaw, Tohji	\N	hallway	{0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4b8323dc-645f-4a86-9b77-51fab15c5388	2022-11-05 05:01:40.823783+00	https://open.spotify.com/track/6TkMxzRiOhA3yXCZWnsQHS?si=DISQgcNrRximHZDNwg357Q&context=spotify%3Astation%3Aalbum%3A3Shttps://open.spotify.com/track/6TkMxzRiOhA3yXCZWnsQHS?si=DISQgcNrRximHZDNwg357Q&context=spotify%3Astation%3Aalbum%3A3SKVtzmihlnGFylW5nC5kjKVtzmihlnGFylW5nC5kj	Groceries	{🏴‍☠️}	3	\N	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	Carrtoons, Nigel Hall	\N	\N	{0x0bbac2bd3134a318deb31137d87d42bf54325cb7,0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47,0xf75779719f72f480e57b1ab06a729af2d051b1cd}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3a309b59-f295-4969-892f-fd9c7e8cceb1	2022-11-11 20:05:57.537295+00	https://open.spotify.com/track/28vQdg4AnfUMNsPZDbM1at?si=91eecf601fd340cd	I'm Trying	\N	3	\N	0x8d41859049c156e70fa381e07a757d5db2f33e1d	\N	Octa Octa	\N	jakeabel7	{0xef58304e292fbaeacfdec25b67b3438031fde313,0x371107cc397a1fd11fd5a7ac8421a3e43f886444,0x0bbac2bd3134a318deb31137d87d42bf54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6ef3b9da-8107-4180-8c6a-9e4c4b08a770	2022-11-17 00:30:15.017884+00	https://youtu.be/guLaANap5zU	SELFISH	\N	0	\N	0x91af49c2eba7197d1ecfd54a74cdc9f7e94a3a23	\N	Different Breed  (ft. Emzo & CapoCTB) 	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
23f3efcb-4e3f-49b0-ae10-1f9c92330292	2022-11-16 15:55:03.118175+00	https://on.soundcloud.com/pi3epi4Fb89jp6iJ9	[003]	{🏴‍☠️}	1	\N	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	SÖREN	\N	\N	{0x0bbac2bd3134a318deb31137d87d42bf54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
35dcdec0-325a-4836-b34f-3d95a1eff1bf	2022-09-14 02:55:10.768732+00	https://open.spotify.com/track/0KG7XrgM20KEmJrKsyFDAm?si=gJCJn8v1SQizfdmwWqb3bQ	Let You Go ft. TSHA & Kareen Lomax	{Dance}	0	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Diplo	\N	discoveringEs	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
36d591e4-5780-45e4-a48e-a5eaaa850728	2022-10-26 20:04:10.820806+00	https://www.youtube.com/watch?v=nfHscy_Z-hA	I'll Fight You	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Open Mike Eagle, Diamond D	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
84ac0ff9-1014-4861-8ca2-ac8bbb8e1973	2022-11-05 18:57:55.399734+00	https://www.youtube.com/watch?v=jvqsexKeJc8	Takeoff ft. Kerron Ali	\N	3	\N	0x58f2dc9b1b73c5609c2fe0fc9cfc32d1a54701a5	\N	Rob V	\N	\N	{0x0bbac2bd3134a318deb31137d87d42bf54325cb7,0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47,0xf75779719f72f480e57b1ab06a729af2d051b1cd}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
cb37c125-c572-46db-b397-84d14b426748	2022-11-11 15:22:12.606718+00	https://youtu.be/wol2o1SECRQ	Twiss	\N	3	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Louis Culture	\N	\N	{0x371107cc397a1fd11fd5a7ac8421a3e43f886444,0xf75779719f72f480e57b1ab06a729af2d051b1cd,0xef58304e292fbaeacfdec25b67b3438031fde313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
95b35c11-811b-4da6-b1b9-0f58b6de2c6a	2022-11-17 00:36:38.122591+00	https://youtu.be/bMeFEKKfzY4	Show Me 	\N	0	\N	0x91af49c2eba7197d1ecfd54a74cdc9f7e94a3a23	\N	Anne Trevis	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
aa041c64-49f4-4a07-a8e4-a1d973a1a80f	2022-11-17 00:42:22.525438+00	https://youtu.be/FbN_NsIT-vQ	You Heard 	\N	2	\N	0x91af49c2eba7197d1ecfd54a74cdc9f7e94a3a23	\N	Premo Rice (feat. Kris Hollis)	\N	\N	{0xef58304e292fbaeacfdec25b67b3438031fde313,0x0bbac2bd3134a318deb31137d87d42bf54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
aeb03028-b441-4b97-86b5-c14f69bf121e	2022-09-14 03:00:23.063024+00	https://open.spotify.com/track/6WvjZs6aOzTmi9wd0mZc1P?si=-uKqbTHgTimI3AfPO8D6iA	Koko	{Afrohouse}	0	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Karen Nyame KG & Mista Silva	\N	discoveringEs	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7cca1153-9aee-4ec8-82ab-54fddc938bf6	2022-09-11 00:39:55.758565+00	https://open.spotify.com/track/1JseAs562lQva7llJ0bibp?si=7227f5db46024310	Like Tu Danz	{🏴‍☠️}	3	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Juls, Kida Kudz, Ms Banks, Pa Salieu	\N	Ghostflow	{0xb60D2E146903852A94271B9A71CF45aa94277eB5,0x5ab45FB874701d910140e58EA62518566709c408,0x52fA05393a003d234eFBA136E68DA835aeB64a26}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
502533de-79e3-414d-997c-5f7644f26d01	2022-09-13 02:31:12.602272+00	https://www.youtube.com/watch?v=YfZPz7okidc	Black Cab	\N	3	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Higher Brothers	\N	future modern	{0xA23a740E0086B52d73ecDBb53423cCb53E0686D0,0x52fA05393a003d234eFBA136E68DA835aeB64a26,0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
65459bb0-43ac-4ee8-a377-071d41b7920c	2022-09-14 19:20:15.971812+00	https://youtu.be/mAmqc71cpNU	How Could You	{"Rhode Island",Makintsmind,"Lily Rayne"}	3	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Lily Rayne	\N	MakintsMind	{0x52fA05393a003d234eFBA136E68DA835aeB64a26,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
93a73679-e7da-4f75-b742-2a35e7d6f0d5	2022-09-14 02:46:11.627769+00	https://open.spotify.com/album/0lzPMIAYhhUSD2BPT0VQWI?si=P_phINwPQn2a1QjwyfMqTA	Mr. Money With The Vibe	{Asake,Afrobeat,Album}	2	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Asake	\N	discoveringEs	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
15271749-73aa-4aae-b36c-752ad595a9eb	2022-09-14 02:47:50.704178+00	https://open.spotify.com/album/2Wm8mlkUTt3yzDZ3qrPIe6?si=JKcq5zXDTJqnaurfkc5e2Q	Outside	{R&B,Single}	3	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Bryson Tiller	\N	discoveringEs	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
799f6463-a0dd-4496-90fa-465640c53df5	2022-09-16 08:41:50.246066+00	https://open.spotify.com/track/04sZfyhVJs0feZjVDq53Y8	PIRATE RADIO	{"Jean Dawson","Chaos Now"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Jean Dawson	\N	hallway	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
61733b33-1530-4f8d-bf2b-356ab57c8083	2022-09-14 02:58:28.429909+00	https://open.spotify.com/track/6GD1eomgaGT1Epto6Q5eAo?si=AteW7FFLTQiuYmBTOQD-ng	goldern hour	{Pop}	3	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	JVKE	\N	discoveringEs	{0xb60D2E146903852A94271B9A71CF45aa94277eB5,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4e636e81-1823-46bb-a945-38fee40eb1c3	2022-09-14 01:28:28.726878+00	https://www.youtube.com/watch?v=A45gzN0cgow&t=5s	Wasted Away	{"Music Video"}	2	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Kelela	\N	hallway	{0x52fA05393a003d234eFBA136E68DA835aeB64a26,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
48985ade-2094-496c-8ad3-ff4ecf61a52a	2022-09-11 01:02:05.226884+00	https://open.spotify.com/track/2ipbVg9oVEJ6VJMOAwZOVG?si=7cf11040e152410a	Honey	{🏴‍☠️}	3	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Salute	\N	Ghostflow	{0xb60D2E146903852A94271B9A71CF45aa94277eB5,0x52fA05393a003d234eFBA136E68DA835aeB64a26,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
35c0a654-1c09-4730-9e25-55d73a4aef94	2022-11-11 15:24:19.700579+00	https://youtu.be/Z75ClTtBaZA	Das U	\N	1	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Planet Giza	\N	\N	{0x371107cc397a1fd11fd5a7ac8421a3e43f886444}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
9d4e8872-5285-49b3-ab11-0cadb8e05dd7	2022-09-12 19:53:05.509545+00	https://youtu.be/LsQCNtCH2sc	WeChat	\N	3	\N	0xfFba44c15Fe2768bC2234078dfac8c5A651A56e9	\N	Higher Brothers	\N	AcidPunk	{0x5ab45FB874701d910140e58EA62518566709c408,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d411332c-5ec2-4a6a-a61e-7e896757a851	2022-09-16 08:40:08.882306+00	https://www.youtube.com/watch?v=_dYC6QndB2o	PIRATE RADIO*	{"Music Video"}	5	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Jean Dawson	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x5ab45FB874701d910140e58EA62518566709c408,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74,0x371107cc397A1fd11FD5A7aC8421a3E43F886444}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1a82aff4-e610-4835-ac6f-8742b26ba9f6	2022-10-26 21:49:58.839379+00	https://www.youtube.com/watch?v=pCxPSwYoHWoH	'trippin	\N	3	\N	0x6170deb8280DB45B6f01c6A2376021782E9199E1	\N	Heath240	\N	ghostly	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
54a28a71-6e78-4e3a-a1f3-c088820650c3	2022-11-06 19:19:14.588174+00	https://www.youtube.com/watch?v=Eg3BRUugDmU&list=OLAK5uy_mWftWZK3WRI1P-dN2JIGtlBNEDlYMWsp4	Real Chill	{plug,hiphop,chill,10kdunkin,"Tony Shhnow","Count Qua","lil xelly",geniuscorp,mighty33,mndyrmm,cashcache,toprankin,dylvinci,"yung brando",kiltkarter,plutoboi,ingo,winstonlc}	2	\N	0x8c62dd796e13ad389ad0bfda44bb231d317ef6c6	\N	mndyrmm	\N	\N	{0x0bbac2bd3134a318deb31137d87d42bf54325cb7,0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
872f4e8a-385d-415c-a3e6-44fc29b86eec	2022-11-17 00:39:11.642864+00	https://youtu.be/68outmDQ8_4	Fall Back 	{"Lofi Soul","South Africa"}	0	\N	0x91af49c2eba7197d1ecfd54a74cdc9f7e94a3a23	\N	Cindii Masina	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c0d86c58-143f-4fe4-99b6-2029ca4313f3	2022-09-14 19:06:36.773222+00	https://www.youtube.com/watch?v=7Kyd14JaLcg	Cursive	{"Che Lingo","UK Rap",Makintsmind,TRIP}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Ché Lingo	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
201a04a6-5c5a-4dfe-b416-f95f0c52ddaf	2022-09-17 00:50:53.958168+00	https://www.youtube.com/watch?v=Y-IDeUGnO5c	Trampoline/Rocking Chair	\N	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Yung Bredda	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
31f08c28-7ee6-4820-8f1a-68647ff25862	2022-09-17 01:12:58.68054+00	https://www.youtube.com/watch?v=HDajKZ3ytdY	Victim	\N	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Drain Gang	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2a2f2c6d-8db5-4e07-8e6e-b847ae3a9734	2022-11-17 00:40:44.960922+00	https://youtu.be/OQSX1zKDQpE	HH pt. 2	\N	0	\N	0x91af49c2eba7197d1ecfd54a74cdc9f7e94a3a23	\N	Premo Rice	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1931be83-69bc-4452-a04a-721b89abe0af	2022-09-02 18:26:27.696551+00	https://youtu.be/wy7GIm7GLnQ	24-8	{"Music Video"}	2	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Smino	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a36ddaf8-23ed-4524-9044-7180453f8cbb	2022-09-10 03:16:12.015352+00	https://youtu.be/gsaZRcL-OTQ	NPR Tiny Desk	{"Live Performance","NPR Tiny Desk"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	JID 	\N	hallway	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
55eb9db2-f7c0-4b13-bbdf-96dccd2946c0	2022-09-01 14:23:14.536741+00	https://www.youtube.com/watch?v=PP5gFdXwSog	Gostar do Mundo	\N	3	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	Sessa	\N	athenayasaman	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
fc39ae01-559b-4364-ae38-7693fb5962d0	2022-05-11 03:19:57.150437+00	https://zora.co/collections/zora/6185	Moral Portal	{MontsJune,Zora,VisualArt,Animation,DigitalArt,NFT}	3	\N	0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74	\N	Monts June	\N	singnasty	{0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ae2ab866-268a-4776-8072-08e35e282cd1	2022-09-14 02:49:22.488978+00	https://open.spotify.com/album/4F4pEuqTnYIX3wvoDfpaZ2?si=NrcGqLKBTp-l3V2tCvQjsQ	A Short Film	{"Hip Hop",Atlanta,EP}	2	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Money Makin' Nique & Jace	\N	discoveringEs	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
659be412-0a6b-4b51-92ab-b7580d537c54	2022-09-26 12:44:41.853657+00	https://thepowposse.bandcamp.com/album/2k15	¿Questions? (2015)	\N	0	\N	0x579a79a9a199Ebd8a793BbB1F33fa709Ad38fadE	\N	NTRL	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
698b8321-6f19-4198-a60c-1255e55dab02	2022-09-18 05:37:23.498445+00	https://www.youtube.com/watch?v=cdDisd0_vRg	Reflejo	{colombia,"spanish rap"}	1	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Kasbeel	\N	future modern	{0x52fA05393a003d234eFBA136E68DA835aeB64a26}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
82d63b2b-fb05-4743-9916-f48f01c67ae0	2022-09-18 21:13:14.518714+00	https://youtu.be/CdXf5PmwoTg	FXCK Everybody Freestyle	\N	2	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Chelsea Pastel	\N	hallway	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x52fA05393a003d234eFBA136E68DA835aeB64a26}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c1bb4a31-1622-4fa8-b87a-b8f173bb5c6f	2022-09-17 03:24:58.346652+00	https://www.youtube.com/watch?v=7E26_sjxbYY	Stay Alive	{toronto,sudan}	3	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Mustafa	\N	future modern	{0x52fA05393a003d234eFBA136E68DA835aeB64a26,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e2b36531-41cb-43ea-9e40-949bde4ea96c	2022-09-18 18:33:32.86072+00	https://www.youtube.com/watch?v=Vhsy8ucWYSY	Warrior ft. Big Sean	{ysl,"lil keed",t-shyne}	3	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Young Slime Life	\N	future modern	{0x52fA05393a003d234eFBA136E68DA835aeB64a26,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
9dd7e8e9-40db-44f0-b37b-ab9b187d2e89	2022-09-26 16:58:57.929535+00	https://on.soundcloud.com/ttRLf	LET IT GO 	\N	0	\N	0x62F541d08dcA3e1044282DA4a9aa63590B6fFb34	\N	Modest	\N	ModestMotives	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
5921029d-d8e3-40d0-ac50-2135aec60f86	2022-09-25 22:07:03.938357+00	https://youtu.be/OiO6U23KYuc	NO SIGNS	{Audio}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	sam gellaitry	\N	hallway	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3042e685-e8ca-4012-a18c-d0d44c0c9188	2022-09-25 21:26:04.357683+00	https://youtu.be/h1JCzrAX0n0	STRIPEZ	{"Music Video"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	WARA	\N	hallway	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6e71245d-6ab4-4d6b-848c-87823b15a5b8	2022-09-19 21:23:31.166753+00	https://wayspace.app/	WAYSPACE	{jackintheway,sweetman.eth,Album,WAYSPACE}	1	\N	0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74	\N	jackintheway	\N	singnasty	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
45eb8c67-523b-4816-b558-1f07005949f9	2022-09-17 15:51:47.91156+00	https://youtu.be/ZsClYdITuek	Dor Do Povo 	{"SA Rap",Makintsmind}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Maglera Doe Boy 	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8c5e944e-1381-4ca6-973b-2b14fc7d7e7b	2022-09-19 21:26:21.679551+00	https://www.youtube.com/watch?v=UEGc07uzB7U	Bloodline (Music Video)	{OliverMalcolm,YouTube,MusicVideo,London,IndieRock}	0	\N	0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74	\N	Oliver Malcolm	\N	singnasty	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
af4f2960-b910-480e-8f76-6a678a438a6e	2022-09-09 16:40:28.638476+00	https://open.spotify.com/track/54B9JQXq1Q3oTE9DIp1mHg?si=_oXNUeXnSSWs34j83bxcXg&context=spotify%3Asearch%3Ashrooms%2Btrip%2Bchaz	Shroom Trip	{🏴‍☠️}	3	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Chaz French	\N	Ghostflow	{0x2dD3FefF13B61C98a792DB20a7971106e3352A7B,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c930b2cc-5966-4bfe-bc14-2d8bcb590295	2022-10-27 21:24:09.763749+00	https://open.spotify.com/track/0CmVeXcmPTzqPU3LDJV74s?si=40e83213953441fe	Yo Voy - Post-Punk Version 	\N	0	\N	0x8D41859049c156E70fa381e07a757D5Db2f33E1d	\N	Depresion Post-Mordem	\N	jakeabel7	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
09611588-1667-4e80-b9e2-3ac956c5db7a	2022-09-20 01:10:01.564578+00	https://open.spotify.com/track/3JllpKemgrmnf07ObpurNb?si=f299f20c2f7f49c5	on air (shadows version) ft. Moby & serpentwithfeet	\N	0	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	always centered at night	\N	discoveringEs	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
88a1a884-6efe-44cc-b42c-db00ad306e51	2022-09-20 01:11:40.997638+00	https://open.spotify.com/track/1JKH156F7aeqFLjHK892H6?si=610a337c77b640dc	The Reason	\N	0	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	James Vickery	\N	discoveringEs	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
adb368fa-df48-47d9-89a4-7ec8c12a8640	2022-10-07 16:28:09.958096+00	https://www.youtube.com/watch?v=dQfGaKGMgQI	Champagne Problems	\N	5	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	ENNY	\N	athenayasaman	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x371107cc397A1fd11FD5A7aC8421a3E43F886444,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x52fA05393a003d234eFBA136E68DA835aeB64a26,0x0bbac2bd3134a318deb31137d87d42bf54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
82684276-b617-4e3c-b21a-210be9709ec9	2022-08-27 00:48:13.448166+00	https://www.youtube.com/watch?v=dl-KvqhPBEk&list=OLAK5uy_klHqQnR0jw-SrFd-m0P_pWK4DstltJ6Ok&index=11	MOCHA JOE	{INTERNATIONALHOUSE,MOCHAJOE,LATTELARRY,AYOAGWIMBAWE,BOOSTININHOUSTON,UNCLELITO,AYOYOUMAD,DUMBINOUTLIKEJIMCARREY,SPITESHOP,CAKE,STARKTERYX,RRR}	3	\N	0x8d5fb8Aca8294FC9A701408494288D2d7de42F7E	\N	STARKER	\N	\N	{0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
981cf9f4-82c2-47a8-a068-0aee2c0ec9b5	2022-08-27 00:44:55.077076+00	https://audiomack.com/2y4trm5tth/song/desiigner-jaguar-audio	Jaguar	{PANDA,JAGUAR,ANIMALKINGDOM,G.O.O.D.MUSIC,RADAR}	2	\N	0x8d5fb8Aca8294FC9A701408494288D2d7de42F7E	\N	Desiigner	\N	\N	{0x5ab45FB874701d910140e58EA62518566709c408,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
418e82d8-984b-4327-9de6-e56328218fc0	2022-09-15 22:41:27.421959+00	https://www.youtube.com/watch?v=hQNkd7pP_6A	Cc	{"drain gang"}	3	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Ecco2k	\N	future modern	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0f9b3558-6720-4849-bbed-b0bf5442126c	2022-09-15 16:28:21.125699+00	https://youtu.be/N5lnIa6bJrU	All Along (Remix)	{Remix}	2	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Rochelle Jordan, Kaytranada	\N	hallway	{0x52fA05393a003d234eFBA136E68DA835aeB64a26,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d7fcea29-a7ed-4528-9ec4-adcdebb12e28	2022-11-17 03:54:53.847505+00	https://www.youtube.com/watch?v=UmNdFe9bQxA	96.3	\N	1	\N	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	Swan Lingo	\N	\N	{0x371107cc397a1fd11fd5a7ac8421a3e43f886444}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e335aeb7-73c5-4240-9848-13a372246c5f	2022-09-20 01:10:55.306771+00	https://open.spotify.com/track/5cECPK2MfXHYncVB9wLoMR?si=628c44fda798431d	Bang ft. Tobe Nwigwe	\N	1	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Jacob Banks	\N	discoveringEs	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
799e9a75-c791-4bf6-8ce1-b370a50b56de	2022-09-25 21:32:56.601955+00	https://youtu.be/JFaMCIVHz2I	Runner	{"Music Video"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Alex G	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6db87a53-e79e-4d19-93fa-603c66296536	2022-09-17 01:03:43.861089+00	https://www.youtube.com/watch?v=NGdiQm4wI2M	Drain Story	\N	3	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Bladee	\N	future modern	{0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c6531e8f-2ba5-4325-872b-2be58c23dc4c	2022-09-20 02:19:47.698448+00	https://open.spotify.com/track/6X5pvJz2oSwMk6JbXBiMBy?si=db3852dd4b4d4a40	Fastest Alone	\N	2	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	FORAGER	\N	discoveringEs	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0ec4a082-9946-44f0-9a07-8772ccb4e440	2022-08-28 15:16:21.577711+00	https://open.spotify.com/track/2Ltv7ANLf82ZC8EmgA7VM2?si=8bea4cc749b44754	After Hours	{"Late Night Music",XXX,"UK Rap",Makintsmind,Skrapz}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Skrapz 	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
9f9ec365-fb84-4af7-95d4-805a3ad47de4	2022-09-20 01:08:34.792825+00	https://open.spotify.com/track/7EqezifSDgoyiNnj7TPJYc?si=7dcc8eb46aad4e47	Off Goes The Light	{Indie,Pop}	3	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Bibio	\N	discoveringEs	{0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
507c67d7-a023-446e-9d43-98bab2083961	2022-09-16 19:15:26.30989+00	https://on.soundcloud.com/bB32r	SHADOWS	\N	3	\N	0x62F541d08dcA3e1044282DA4a9aa63590B6fFb34	\N	Modest	\N	ModestMotives	{0x52fA05393a003d234eFBA136E68DA835aeB64a26,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8bac54b1-6d06-402f-a2ed-9d67e306501c	2022-11-11 14:02:13.001053+00	https://duvaltimothy.bandcamp.com/track/up	Up	\N	3	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Duval Timothy	\N	\N	{0x371107cc397a1fd11fd5a7ac8421a3e43f886444,0xf75779719f72f480e57b1ab06a729af2d051b1cd,0xef58304e292fbaeacfdec25b67b3438031fde313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a6b24a0a-1a89-4b44-93e7-c8545f757051	2022-11-11 14:01:32.382132+00	https://duvaltimothy.bandcamp.com/track/wood-ft-yu-su	Wood	\N	3	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Duval Timothy, Yu-Su	\N	\N	{0x371107cc397a1fd11fd5a7ac8421a3e43f886444,0xf75779719f72f480e57b1ab06a729af2d051b1cd,0xef58304e292fbaeacfdec25b67b3438031fde313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
21ee012d-b327-403b-b756-8dadfa10f16b	2022-10-28 13:02:18.013035+00	https://open.spotify.com/track/1rOKAsJZJDIikOKDeUfPRV?si=8965dddee46d487c	Last Words	{🏴‍☠️}	3	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Kenny Beats	\N	Ghostflow	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x0bbac2bd3134a318deb31137d87d42bf54325cb7,0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
aa7fe22e-9beb-47a7-9a05-097693eb9fb6	2022-11-06 23:27:47.17142+00	https://youtu.be/p7-jb1tq9qY	.dungeon	{"Music Video"}	3	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Aundrey Guillaume	\N	\N	{0xef58304e292fbaeacfdec25b67b3438031fde313,0x371107cc397a1fd11fd5a7ac8421a3e43f886444,0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b3b34c9a-7170-472b-8c12-efedbcb8c75d	2022-11-17 00:46:23.917057+00	https://youtu.be/UoqGVou8lxw	Two12's 	\N	2	\N	0x91af49c2eba7197d1ecfd54a74cdc9f7e94a3a23	\N	Premo Rice (feat. Curren$y)	\N	\N	{0xef58304e292fbaeacfdec25b67b3438031fde313,0x0bbac2bd3134a318deb31137d87d42bf54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
bfc0db46-8fb4-4bf0-8cdf-666fd8f9ec91	2022-11-11 14:02:46.945264+00	https://duvaltimothy.bandcamp.com/track/thunder-ft-fauzia	Thunder	\N	3	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Duval Timothy, Fauzia	\N	\N	{0x371107cc397a1fd11fd5a7ac8421a3e43f886444,0xf75779719f72f480e57b1ab06a729af2d051b1cd,0xef58304e292fbaeacfdec25b67b3438031fde313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2c74d446-5501-43a5-91aa-ad4da125c054	2022-11-17 19:21:09.052821+00	https://open.spotify.com/track/2bR81lBtf6lo9uEWBfYnDm?si=keO4WVw-SViWCeZGFAXIsQ&context=spotify%3Aartist%3A0FhIrpIiYQ5NIuAVXc9Kcm	Something 4 U	{🏴‍☠️}	0	\N	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	Sam Addeo, Biyo	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3d150bb8-427f-4d92-8b71-c234570b18bc	2022-09-19 21:24:56.317206+00	https://butcherbrownmusic.bandcamp.com/album/butcher-brown-presents-triple-trey-featuring-tennishu-and-r4nd4zzo-bigb4nd	Triple Trey featuring Tennishu and R4ND4ZZO BIGB4ND (LP)	{ButcherBrown,Richmond,Jazz,Hip-Hop,Bandcamp,Album}	4	\N	0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74	\N	Butcher Brown	\N	singnasty	{0x52fA05393a003d234eFBA136E68DA835aeB64a26,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x371107cc397A1fd11FD5A7aC8421a3E43F886444}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
33332015-400d-4376-adff-27fcb45a0e25	2022-08-28 14:15:03.337256+00	https://open.spotify.com/track/1NJOLXpjBPke7EaOLYqtJQ?si=b5dec0d070e04fee	Paranoia Central	{"Codeine Dose 1.0",Makintsmind,"Listen to the lyrics please"}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Coinz	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
10aeb337-1660-461d-bf8d-8fe6b783b791	2022-08-28 14:20:48.539562+00	https://open.spotify.com/track/5tEOxKGrIkEnfM9T2S6t6D?si=cfcc616ea5004538	GL33	{Makintsmind,"UK Drill","No Gimmicks","Witty Bars"}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Sentry	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c34eea6e-8410-4c9a-b630-b750e8fa31d2	2022-08-30 22:45:49.97026+00	https://youtu.be/-KHEjd6GNxA	Grinding	{"UK Rap",Makintsmind,Twyce}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Twyce	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d9f04ca6-e720-4b43-9dc1-0ecd6c090a7b	2022-10-27 21:22:46.9551+00	https://open.spotify.com/track/28XDE6yXI6Bp4U3nLSGqzp?si=2e041788a85a46e4	Smooth Operator	\N	3	\N	0x8D41859049c156E70fa381e07a757D5Db2f33E1d	\N	Sade	\N	jakeabel7	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d358c750-873b-49f0-8d98-52e6a4c8bf4b	2022-11-17 00:51:50.572212+00	https://youtu.be/YrioxStGrCg	Revolution	\N	2	\N	0x91af49c2eba7197d1ecfd54a74cdc9f7e94a3a23	\N	ScribblesWho	\N	\N	{0xef58304e292fbaeacfdec25b67b3438031fde313,0x0bbac2bd3134a318deb31137d87d42bf54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4ebb6e72-afcb-49b1-9476-b16c252bdf64	2022-11-07 16:27:16.012994+00	https://open.spotify.com/album/5xsQ1kbF0N4gACvzizviLO?si=uQg1gCFBQkitd47do4PqPw	Control	{hazy,swowtempo}	3	\N	0x371107cc397a1fd11fd5a7ac8421a3e43f886444	\N	Dal	\N	\N	{0xef58304e292fbaeacfdec25b67b3438031fde313,0x0bbac2bd3134a318deb31137d87d42bf54325cb7,0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
bfb58be2-4516-4781-864e-2250fc6183f0	2022-11-11 15:20:13.742913+00	https://youtu.be/Zwmlqx0rEig	McQueen	\N	1	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	NBA Youngboy 	\N	\N	{0xf75779719f72f480e57b1ab06a729af2d051b1cd}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f17c757c-0e92-4832-81f0-18f104973028	2022-11-11 15:18:58.548199+00	https://youtu.be/v_uvUdJBVaQ	Right Now	\N	1	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	NBA Youngboy	\N	\N	{0xf75779719f72f480e57b1ab06a729af2d051b1cd}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
11381ffe-0411-4622-aff2-e50a8050b456	2022-11-09 00:55:49.539187+00	https://www.youtube.com/watch?v=qFAlmXxhav0	JOSH ALLEN	{JOSHALLEN,BUFFALOKIDS,JOEMONTANA,REALDEALHOLYFIELD,SOSOSOULFUL,NOWAYOUT,PUFFY,KENTUCKY,ROBERTAFLACK,GOOGOODOLLS,PEACEFLYGOD,RIDINPERFECT,COURAGE}	3	\N	0x8d5fb8aca8294fc9a701408494288d2d7de42f7e	\N	CHASE FETTI	\N	\N	{0xef58304e292fbaeacfdec25b67b3438031fde313,0x0bbac2bd3134a318deb31137d87d42bf54325cb7,0xf75779719f72f480e57b1ab06a729af2d051b1cd}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e67d07f9-2fa1-48a8-8a6c-7a14068e38b9	2022-11-11 14:05:50.632135+00	https://duvaltimothy.bandcamp.com/track/drift-ft-lamin-fofana	Drift	\N	3	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Duval Timothy, Lamin Fofana	\N	\N	{0x371107cc397a1fd11fd5a7ac8421a3e43f886444,0xf75779719f72f480e57b1ab06a729af2d051b1cd,0xef58304e292fbaeacfdec25b67b3438031fde313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1c6a7329-2dc9-4613-b47b-f5423b28684a	2022-09-21 18:29:35.887627+00	https://www.youtube.com/watch?v=YZEDM96cXt	fter You Get What You Want (You Don't Want It)	{"atlantic city","prohibition era"}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Boardwalk Empire OST	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c81f843b-764d-48f2-91e6-6863c288b4ed	2022-09-21 18:34:53.693305+00	https://beta.catalog.works/tayf3rd/i-smoke-i-drank-i-jerk	i smoke i drank i jerk	{"long beach",jerk}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Tayf3rd	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
41ab5681-3402-4569-80d3-0a9938023694	2022-09-21 20:19:04.343036+00	https://soundcloud.com/civil_writez/bougie	Bougie	{"Human Resources",Rap}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Civ Pierre	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
76644339-1574-4b89-81b8-686c4a47f4e0	2022-09-21 20:20:13.01543+00	https://soundcloud.com/civil_writez/gun-range	Gun Range	{"Civ Pierre","Human Resources"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Civ Pierre	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7afd1602-d0f6-42ab-9523-bdf19c7ff7c6	2022-08-28 13:44:37.987522+00	https://open.spotify.com/track/5CQF3Yqfl9AJ53uTMb5Hma?si=5b5417f483fa4e92	Round Us	{Makintsmind,"PLAyer 4ever"}	3	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Niko G4	\N	MakintsMind	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
20dae8b2-7815-4934-b8a2-f6357944759c	2022-09-21 19:12:37.974875+00	https://www.youtube.com/watch?v=K8NJ187Ejng	Pressure	\N	3	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	Sækyi	\N	athenayasaman	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x371107cc397A1fd11FD5A7aC8421a3E43F886444}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1d584ba8-2212-4a89-8f2c-bb2be260f732	2022-09-21 20:20:56.914169+00	https://soundcloud.com/civil_writez/i-pray	I Pray	{"Human Resources"}	2	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Civ Pierre	\N	hallway	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
81d1a46b-ca9d-4516-ab85-8517ec9a6fbe	2022-10-28 14:52:43.643187+00	https://asunojokei.bandcamp.com/track/gaze	Gaze	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Asunojokei	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
36d6d89d-baca-4295-a4ec-9338e487d8b7	2022-09-23 19:45:41.099466+00	https://open.spotify.com/track/4zwq3QUKgMNk0NSLl7fpbP?si=9be2c4759dfd4992	Why Why Why Why Why	{🏴‍☠️}	2	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	SAULT	\N	Ghostflow	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
54c65383-46c1-4431-9d22-b29a88896963	2022-09-21 22:23:30.114625+00	https://www.youtube.com/watch?v=99uhw47_bfQ	I Ain't Stressin Today	{"jackson mississippi"}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Dear Silas	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4bac3b8f-1638-460a-8f3a-e884207b457c	2022-09-22 02:38:09.497597+00	https://www.youtube.com/watch?v=4GHFwOXwKdY	Born Poor	{based,oakland,"bay area"}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Lil B	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0b25989e-4491-4545-810d-abc42f99b259	2022-09-22 03:14:22.037193+00	https://open.spotify.com/track/1N0x6QjETxN1cvvgp2KRyn?si=Hvbt30rcQ56egINHBlf-Iw&context=spotify%3Astation%3Aalbum%3A7qWVvcaFH5Wlv0vxBXMOUQ	The Letter Blue - Branches Remix	{Flex,🏴‍☠️,remix}	0	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Wet, Branches	\N	Ghostflow	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8defcdfe-6389-47fe-8d2f-5e6496c3fd12	2022-09-23 17:04:29.380704+00	https://www.youtube.com/watch?v=2HX88bAT0ZM&list=RD2HX88bAT0ZM&t=5s&ab_channel=MonkeytownRecords	The Walker	{electronica,ambient,IDM}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Dark Sky	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2d96ea72-c91e-4679-991c-c75689cb9e7b	2022-09-21 21:44:56.736305+00	https://audius.co/jimmyspace_v/braindead-prod-jakfo4-107440	Braindead	{shoegaze,sneakergaze,"Rock Hill NY"}	2	\N	0xBB4839c63Fb47AF438E51b38380256f8A4a7b919	\N	Jimmy V	\N	jimmyv	{0x5ab45FB874701d910140e58EA62518566709c408,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ee6b434c-0a59-459a-b431-4d2095cdbc8e	2022-09-25 21:40:49.832756+00	https://youtu.be/nEix6FPMHec	Hello	{Audio}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	µ-Ziq	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
446dc2ec-aa24-4bf2-b876-c322d19e41b8	2022-09-23 15:37:55.20351+00	https://youtu.be/vdxdhZku1Yg	Krazy	{atlanta,trap}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Rich Homie Quan	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c5755fa6-1121-42a5-967d-a654a356ed92	2022-09-21 20:59:54.510803+00	https://www.youtube.com/watch?v=cNbVCsCFFJQ	i smoke i drank i jerk	{"long beach","cambodia town","Black Korean artist","snoop's protege","west coast"}	2	\N	0x690D7e51aa3E0CF5D0005659A382AA9bd8A07096	\N	tayf3rd	\N	tayf3rd	{0x5ab45FB874701d910140e58EA62518566709c408,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
98459800-9495-4cdb-8bfe-381be5743e33	2022-09-22 04:04:24.524062+00	https://open.spotify.com/album/0jQ1xcflGtmlCYkV3ITlfG?si=YKagwb1CQDq7bdth8iNbUA	Fall In Line	\N	3	\N	0x3a08B1A499A043d5757C19Cc18F3E0c36dD753af	\N	Jay Dot Rain	\N	\N	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2871cf71-5796-42ce-86ae-4560637da2d2	2022-09-22 21:11:16.29693+00	https://youtu.be/MB5H0KElgSA	Pushing	{ScummySZN,HennyStillPouring,"South London",Makintsmind,Scummy}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Lil Torment 	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
98b8edb8-34dc-4c66-8b48-e3ca0216fc24	2022-09-23 17:10:23.929793+00	https://www.youtube.com/watch?v=SlfpvKqE2Is&ab_channel=OliverPesaresi	I Lied	{Electronic,Lowtempo}	0	\N	0x371107cc397A1fd11FD5A7aC8421a3E43F886444	\N	Telefon Tel Aviv	\N	Keenboo	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
303ce049-9bec-4d23-b1da-5275d90d095c	2022-09-22 04:06:49.926208+00	https://open.spotify.com/album/46HwodyD4OFy4YFIAdPfYm?si=ecZ0zBH6T4C7KT_x0DVilQ	Really Do	\N	3	\N	0x3a08B1A499A043d5757C19Cc18F3E0c36dD753af	\N	Jay Dot Rain	\N	\N	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x371107cc397A1fd11FD5A7aC8421a3E43F886444,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
22ee5a7d-c539-4466-8ece-e1916ee2c13c	2022-11-07 16:59:55.494444+00	https://www.youtube.com/watch?v=wZ9HG0nGe-g	Don't Walk Away	\N	3	\N	0x8d41859049c156e70fa381e07a757d5db2f33e1d	\N	Jade	\N	jakeabel7	{0xef58304e292fbaeacfdec25b67b3438031fde313,0x0bbac2bd3134a318deb31137d87d42bf54325cb7,0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
89b720bb-a469-4672-befd-c44d893d9267	2022-09-22 04:05:23.571426+00	https://open.spotify.com/album/4s13Hmnp207U9eUfqf2gCc?si=QOu3DytSRsyMuQKfpmJE3A	NOW OR NEVER featuring Tate228	\N	2	\N	0x3a08B1A499A043d5757C19Cc18F3E0c36dD753af	\N	Jay Dot Rain	\N	\N	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6e4386fb-ceea-4fb7-be27-b571b770b80a	2022-09-23 18:34:02.331785+00	https://www.youtube.com/watch?v=2D36c3u3q0c	Fortune's Future	{violin}	3	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	Jordan Waré	\N	athenayasaman	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a3c9d0cf-a89e-4da6-b10a-5bbe66dec2c5	2022-09-22 05:18:30.656676+00	https://www.youtube.com/watch?v=gXosj66r1Uc	Chaka Khan ft. Kenny Beats	{"north carolina",winston-salem}	3	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	TiaCorine	\N	future modern	{0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
602c5d4a-6501-40eb-b4a7-02563667c1c0	2022-09-26 01:49:47.131044+00	https://youtu.be/q9uxQo6ACBM	Will I Ever Be ? 	\N	0	\N	0x579a79a9a199Ebd8a793BbB1F33fa709Ad38fadE	\N	NTRL	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ac93d81e-b25b-4844-8d9e-e0789614144e	2022-10-28 14:59:24.245587+00	https://asunojokei.bandcamp.com/track/tidal-lullaby	Tidal Library	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Asunojokei	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d28e1517-14fe-4778-bee8-be125d145c12	2022-09-25 21:05:37.921206+00	https://youtu.be/WtePeSEdTRI	RUNNITUP	{"Music Video"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	ZORA, Myia Thornton	\N	hallway	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0a1970f2-9d9b-45fc-a00c-286564c16510	2022-09-25 20:38:10.552197+00	https://youtu.be/tJbP7VjSmxw	Honey Bun	{"Music Video"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Haviah Mighty	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3869b506-fef8-4e4f-a02f-114bded5b739	2022-09-25 21:12:08.564169+00	https://youtu.be/AYXPi78BJ6Y	This is My City - Federal Reserve Version	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Cam'ron, A-Trak	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
49447eac-b4a9-4d3e-a557-cb5da38bfe90	2022-09-25 21:15:37.01338+00	https://youtu.be/5Bs_qtOntEk	Dipset Acrylics	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Cam'ron, A-Trak, Mr. Vegas	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
357055fd-1c9c-40eb-921c-ffd4eec6b497	2022-09-25 21:21:15.661939+00	https://youtu.be/Tfyepd8zZ7c	Dipshits	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Cam'ron, A-Trak, Juelz Santana, & Damon Dash	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b1d8726e-7783-4018-bddd-7dcaa0a6ff24	2022-09-25 21:36:17.82844+00	https://youtu.be/SuoSbXT3GNc	you (Acoustic)	{"Music Video","Live Performance"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Ckay	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e2cac0a9-a9c6-4c14-ab89-829b71d5bbfe	2022-09-25 21:55:58.770144+00	https://youtu.be/LxgxaPNgETs	Ice Cream Dream	{"Music Video"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	DreamDoll, French Montana	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
10ab2308-d1be-40b9-9d2f-1a8025973e1d	2022-09-25 21:58:56.257367+00	https://youtu.be/43VBLrudSOg	Welcome to the West	{Visualizer}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Mila J, DJ Battlecat	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
5fb31bb7-9402-4640-92f6-75728f54fe8d	2022-09-25 21:49:29.062439+00	https://youtu.be/OahUOLcr4T8	Say It Now	{Subpop,"Music Video"}	2	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Hannah Jadagu	\N	hallway	{0x5ab45FB874701d910140e58EA62518566709c408,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
359e8dca-cec6-462b-9041-e300c3ec00fb	2022-09-26 12:43:02.196507+00	https://fkanatural.bandcamp.com/album/ntrl-blend-tape	NTRL Blend Tape Volume 1	\N	0	\N	0x579a79a9a199Ebd8a793BbB1F33fa709Ad38fadE	\N	NTRL 	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
bb636221-010f-40c6-b923-6239ed858337	2022-09-25 22:31:27.922909+00	https://youtu.be/owa8OJabpD4	DELIVER!	{"Music Video"}	2	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	JELEEL!, Internet Money	\N	hallway	{0x5ab45FB874701d910140e58EA62518566709c408,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
87990fda-1a1f-428f-aac3-17c1756e2762	2022-09-25 22:28:06.551101+00	https://youtu.be/RC8u7RJe-TE	Sunshine	{"Music Video"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Steve Lacy	\N	hallway	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6c65665f-3a78-42e7-b4c5-d3b95c30653d	2022-09-25 22:19:45.380118+00	https://youtu.be/qTTMzzQeET8	NAME TO A FACE	{Visualizer}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	sam gellaitry	\N	hallway	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
126fbc85-12a1-4318-a885-4f81b05629d7	2022-09-28 13:31:15.138489+00	https://youtu.be/vhLy-i3zO-E	Nosedive	\N	3	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Kenny Mason, Jean Dawson	\N	hallway	{0x5ab45FB874701d910140e58EA62518566709c408,0xb60D2E146903852A94271B9A71CF45aa94277eB5,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
08f8ffba-9a43-464c-ad26-b9cb8fd2886c	2022-09-25 21:24:13.176723+00	https://youtu.be/kPY-JmYpVgU	BLAZPHEMY (MINI-MOVIE)	{"Music Video"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	WARA	\N	hallway	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
adfb309d-ebb0-4d4f-b5a0-dc93f3c70ce5	2022-09-25 21:17:46.041221+00	https://youtu.be/r-Gs5HnMmsg	Think Boy	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Cam'ron, A-Trak, Jim Jones, Styles P.	\N	hallway	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0150562d-f09a-4ea6-94c9-72fa9122e918	2022-09-23 19:48:36.533411+00	https://open.spotify.com/track/13oV3JUJWwMtqoSJIIUINr?si=c823892f5027471b	Goodbye My Love	{🏴‍☠️}	2	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Jungle, Priya Ragu	\N	Ghostflow	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
99d13e68-99a7-45a7-8223-b7d876b16766	2022-09-25 21:38:42.380437+00	https://youtu.be/y1g-WdCfMDE	Geeked And Blessed	{Audio}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	LUCKI	\N	hallway	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
223f7b40-6faa-4671-8f61-dd65d53a4709	2022-09-25 07:59:32.535905+00	https://www.youtube.com/watch?v=-REzc3GDcJk	Tabi no Tochuu - Spice and Wolf OP [Piano]	{piano}	2	\N	0xc9d636c52C44b2E166273F7DCD3A2e3A29272bf7	\N	Animenz	\N	tiffanyzhoucc	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e737a468-71d0-46ee-94d8-ee5eda42aeeb	2022-09-27 16:20:38.113149+00	https://open.spotify.com/track/1u64J1odgtj9Aq7TTiELAe?si=5ded8b9651574ca6	Bossa em Havana	\N	0	\N	0xa52B442bfeca885d7DE4F74971337f6Cf4E86f3B	\N	Linearwave	\N	Timer°°	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
986f3f5d-27b2-4032-b394-d3f3328c85d5	2022-09-25 20:21:15.842174+00	https://youtu.be/YiQPWF-9MUg	SPICY	{"UK RAP","NY DRILL","HOT GIRL SUMMER"}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	SIXSAIDIT	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2b1607ee-e8d5-4e80-9904-6f058dbd81be	2022-09-28 13:33:27.966115+00	https://youtu.be/zlPw8ZAYsJ0	Spin N Flip	{"Lyric Video"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Kenny Mason, Young Nudy	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
56e39c69-896f-476f-9514-08f431131989	2022-09-23 04:36:04.560545+00	https://www.youtube.com/watch?v=zwa7NzNBQig	Tomorrow 2 ft. Cardi B	\N	3	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Glorilla	\N	future modern	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3808ea67-5398-4e56-9f6c-a33bd020dd9a	2022-09-26 17:00:17.09752+00	https://youtu.be/Ea4ndLe_hn8	X-Wing	{"Music Video"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Denzel Curry	\N	hallway	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8b2bda48-4443-4f3d-a7c9-a5d4e1d073c7	2022-09-25 22:13:45.930987+00	https://youtu.be/Au71upB4tG0	EUPHORIA (..OK!) 	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	sam gellaitry	\N	hallway	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
dbadda0c-ec87-45f1-87e7-1d9f6ab2446f	2022-10-28 15:02:37.21367+00	https://tomesselle.bandcamp.com/album/praise-bes-ep	Praise Bes EP	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Tom Esselle	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a17428ef-75ce-4060-8651-7c9aceaebd10	2022-09-21 20:21:48.059869+00	https://soundcloud.com/civil_writez/kylie-jenner	Kylie Jenner	{"Human Resources"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Civ PIerre	\N	hallway	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
69ef7fa0-94ca-4059-9130-134f59efc865	2022-09-08 05:28:43.498698+00	https://www.youtube.com/watch?v=-JMechSxBq0	All My Shit St**id	\N	3	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	ILOVEMAKONNEN 	\N	future modern	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0xef58304e292fbaeacfdec25b67b3438031fde313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
fc24f631-2c1b-477e-a6d9-edbd6594c8d2	2022-08-04 14:54:57.910924+00	https://www.youtube.com/watch?v=X2KszPmGiBM	Brooklyn Ballers - musclecars 'The Stuy Needs Me' Mix	{brooklyn,bedstuy,"new york city"}	2	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	Jitwam, musclecars	\N	athenayasaman	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4b567692-5397-481e-98f1-d1798bb39d36	2022-09-21 20:44:23.02288+00	https://www.youtube.com/watch?v=lojM8m_t6P0	V for Vendetta	{queens,joker,gotham,woke,prophetic,conscious,radical,satirical,revolutionary}	4	\N	0x1EF036Df0e3e331c8Ed038ce875Fb02230dbf44D	\N	Big Baby Gandhi	\N	bigbabygandhi	{0x5ab45FB874701d910140e58EA62518566709c408,0x371107cc397A1fd11FD5A7aC8421a3E43F886444,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
07d9ea63-8171-4577-b9d3-19ca9d62899e	2022-08-18 03:57:58.812567+00	https://www.youtube.com/watch?v=jhQFJJ6gq8M	MIRROR (HYMN)	{"drain gang"}	3	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Bladee	\N	future modern	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
dc9770ea-cd1a-4591-bbbc-039d82dba75f	2022-04-09 14:52:45.599029+00	https://youtu.be/-Z1va-YqO64	Griselda Freestyle	{🔦,Austin,TX,Freestyle,Rap}	3	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Sauce Walka	\N	hallway	{0xb077473009E7e013B0Fa68af63E96773E0A5D6A4,0x7d1f0b6556f19132e545717C6422e8AB004A5B7c,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a687e4cc-f6d1-42ec-91af-ef29b8547c43	2022-04-08 17:15:55.2861+00	https://open.spotify.com/track/4g2tE24Xp50C8e4GNyPDEz?si=M_IeJ1NgS2KLD6O8cNnMSQ&nd=1	Chit Chat	\N	3	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Passive Aggressive	\N	hallway	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b95f3761-f3a9-4d28-909c-601ed8d4258e	2022-09-24 20:28:31.320107+00	https://www.youtube.com/watch?v=q6cEmraN94k	BRETMAN ROCK FREESTYLE FT. THANKQ AND DEVIN CHEFF	{hawaii}	3	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	8RO8	\N	future modern	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
deae3d50-f9ea-405a-8e8a-82b915bf9f7c	2022-09-20 15:18:08.731005+00	https://www.youtube.com/watch?v=gwLER140PfA	Fent	{rap,yeat,plugg}	2	\N	0xFE72483f5270f70E03259eb6C7F54246ED1f8519	\N	imsickofjun	\N	greg	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
aba81011-17d8-4d2c-81fc-66bed863fd1f	2022-09-20 02:13:56.832986+00	https://open.spotify.com/track/7bKflYjDNza5uPgfGhC4lC?si=e64c4e5a206347b4	Let's Go Outside	\N	3	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Far Caspian	\N	discoveringEs	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8daf4276-cd86-455a-b8f5-00dcc9bd4dc6	2022-08-20 04:46:33.335551+00	https://www.youtube.com/watch?v=6CB5BzBNKYY	Power Freaks	{"cross border"}	5	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Jean Dawson	\N	future modern	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x52fA05393a003d234eFBA136E68DA835aeB64a26,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a6b2ca7e-7c62-44a2-a77e-d09b02fc859d	2022-09-14 19:11:14.737223+00	https://www.youtube.com/watch?v=9jytbdG_f2Q	More	{IAMDDB,"ALT MUSIC",Makintsmind}	2	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	IAMDDB	\N	MakintsMind	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8fc93267-5226-4143-a41e-1cc318dd9466	2022-06-28 21:26:47.673043+00	https://open.spotify.com/track/0C1RaT1eyqvoeqskbaTg3E?si=77d57f395d12410b	The Secret History	{Soundtrack}	2	\N	0xa52B442bfeca885d7DE4F74971337f6Cf4E86f3B	\N	Andrew Skeet	\N	Timer°°	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
321ede39-4485-425b-927e-de76e2d55443	2022-08-30 23:20:08.439829+00	https://open.spotify.com/track/53OMzmUjX7QjByYQhnTjv5?si=777545fa69fe4abf	I Really	{Good$ense,"New Orleans","Rote Da Ruler"}	1	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Young Roddy	\N	MakintsMind	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
837409d7-b4e5-4529-9603-6963a543f462	2022-08-30 22:51:55.382279+00	https://open.spotify.com/track/1qIiT7AGuMNoZrGSZ7M41A?si=d95b083fafcc4125	Makin it 	\N	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Ransom	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3c4e1dd9-b422-43c9-af15-a9b0d5d72472	2022-08-28 14:30:44.158271+00	https://open.spotify.com/track/4uvjWFDfwVBCuklvHGVSck?si=b492675748dd45d7	DXB to LHR	{Makintsmind,"UK Rap"}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Flights	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f7014649-d832-4f08-be77-11faa48b0f57	2022-08-30 22:57:56.264592+00	https://open.spotify.com/track/2DlSq4xRnuIAdpfytVikPD?si=225ea197e2a449dd	Captions	{"Must Listen Project!"}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Ransom ft Tyrant	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4b0bc852-7395-483b-9b4c-86df7a584d78	2022-08-30 23:01:02.529881+00	https://open.spotify.com/track/5KMozJFbhSYLnIgQCOzl9V?si=b5dcce894f134f19	More Than Money	{Flintlock}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Knowledge The Pirate 	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c386767b-9621-405f-b958-03ef3e9ef4c0	2022-08-28 14:38:39.217015+00	https://open.spotify.com/track/1mckZt3j1Z2jlQXH1vrdKs?si=93ed86800d3242f2	Deep End	{"Euro 305","UK Amapiano",Makintsmind}	1	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	European 305	\N	MakintsMind	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
fd6e83ca-09ce-4fb1-ae59-b12c8c148677	2022-08-30 23:10:39.665091+00	https://open.spotify.com/track/6jwAeY0Jz9Uu4b1pt1tmdy?si=e130689cb8394742	Black Power	{"3 Ikeem",OTB}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	King Ikeem	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f5680ebc-a087-4c87-a9e6-d83fd409db45	2022-08-28 14:57:41.769923+00	https://open.spotify.com/track/7Lvgoj5cLclEdg9ZRDpa5P?si=82b154160b44482f	Face Your Demons 	{"Face You Demons","UK Music",Makintsmind}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Nikhil Beats ft Meron T	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
98efcca0-34e0-4c30-b6aa-e7213caa3640	2022-08-30 23:17:12.014459+00	https://open.spotify.com/track/5Uux6TTq2bDFDsrbwNkc6A?si=1c2918957726481f	Level Up Again	{JetLife}	3	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Young Roddy ft Trademark Da Skydiver 	\N	MakintsMind	{0x2dD3FefF13B61C98a792DB20a7971106e3352A7B,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8bf59e7e-a2de-4400-a460-b88f51bbc1c6	2022-09-07 20:18:10.357947+00	https://youtu.be/XifQmA79-Fk	Drug Prescription	{Spitta,Curren$y,JetLife,Makinstmind}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Curren$y	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
958c5e68-a2b1-4f53-af23-2ab83fe5762b	2022-04-05 23:30:46.829379+00	https://open.spotify.com/track/4ko5AAQIPn6CFUTMMa1sOD?si=221aacb977014204	Goof	\N	3	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Reveal 	\N	MakintsMind	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
9986e873-a273-466d-aa3b-1ff427706994	2022-08-30 23:22:35.933157+00	https://open.spotify.com/track/1rqz6LLEAwBLSKeEKrlEk2?si=902cb929aa084072	Love Lost	{"Good $ense",JetLife,"New Orleans"}	1	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Young Roddy	\N	MakintsMind	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
90323175-582d-45be-a02f-61996bb796da	2022-09-07 20:35:19.968704+00	https://youtu.be/OW_IanhPvvg	Make Love	{RnB,Makintsmind}	2	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	BJ The Chicago Kid	\N	MakintsMind	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d43f66c7-18d6-4d45-acb1-33c3a959eb68	2022-08-28 15:07:52.001102+00	https://open.spotify.com/track/7mUKxF5yhoNRI6SBQ78oLl?si=f76f84e529644dbd	Obsession	{"UK Rap","C biz",Obsession,Makintsmind}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	C BIZ	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a1457c34-78b8-4e7b-94f2-9f9d0d2b4942	2022-08-28 15:13:53.845533+00	https://open.spotify.com/track/3Z2qWOa0E4XLD0bMKYdu6X?si=5f7cc1c844234de7	Can't Give The Game Up	{"UK Rap",Makintsmind,"Different Cloth","Skrapz ICB","Church Road Soliders"}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Skrapz (ICB)	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a56eeb0a-3f8f-4312-8ea6-5390edd7cabe	2022-08-28 13:47:37.971838+00	https://open.spotify.com/track/56Ap16wE2cA87TupxfMCfG?si=64a0a57ddf2c43a2	Right Wriss Pt2	{Makintsmind,"The Rice Tape"}	3	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Premo Rice	\N	MakintsMind	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2e07815f-bea5-4e95-9935-06d509d74fe7	2022-09-14 19:15:40.250295+00	https://youtu.be/7qi3OidA-C8	The Ride 	{"UK Alt Rap",ChilHop,Makintsmind}	3	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Dip & Lo-Wu	\N	MakintsMind	{0x52fA05393a003d234eFBA136E68DA835aeB64a26,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a26e6d06-c1c3-4fb7-af4b-f3850536acfd	2022-10-28 15:05:12.292537+00	https://jenniferloveless.bandcamp.com/album/around-the-world	Around the World	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Jennifer Loveless	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
028da111-9e90-4447-a03a-8d1a3a34dc3d	2022-08-28 13:50:54.2096+00	https://open.spotify.com/track/51sunsxDFVeNActPsNteGV?si=80cb919aa54f444e	Westside Digital	{Makintsmind,"All Blue"}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	G Perico	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c019a3b8-4318-41c5-af8e-b146954ff0dd	2022-09-03 11:40:57.717797+00	https://youtu.be/O34gz8wOFrg	Run To It 	{StrictlyWaveyMusic,Baseman,Makintsmind}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Baseman	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8205d4da-e721-48d4-8b0d-63521ce8e1f2	2022-09-10 16:32:50.075317+00	https://open.spotify.com/track/0xV9H4ED3bpdTQwYLy75D0?si=343b8b2a546f49cb	My Love	{"Alt UK Music",Makintsmind}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Meron T ft Hagan	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
9e926110-1da2-4fd9-b0d0-25b3afab0a4d	2022-09-14 19:23:49.808259+00	https://www.youtube.com/watch?v=-6HaoTFxZcI	GLEE	{"UK Rap","No Gimmicks","Raw Rap","House Of Gold"}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Sentry	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b5cf8c09-4725-4cba-837f-e00a7a71db57	2022-09-17 15:55:57.535241+00	https://youtu.be/bkq2MfUW3_I	No Stall	{Platinus,Makintsmind,"Alt Rap","Underground UK Rap"}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Bib Sama	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2979eab6-8a17-44b6-9b5e-01d05cdcdb81	2022-09-17 15:45:52.99156+00	https://youtu.be/8pV-qMOYxeI	Jetset	{Ojerime,"Alt Music",Makintsmind}	3	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Ojerime	\N	MakintsMind	{0x52fA05393a003d234eFBA136E68DA835aeB64a26,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
bfc68515-4cf3-4964-b17d-3da155425731	2022-09-17 15:49:07.023242+00	https://youtu.be/jp-bCcqE0rE	Groovy Baby	{"SA Raps",Makintsmind,MUD}	3	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Priddy Ugly	\N	MakintsMind	{0x52fA05393a003d234eFBA136E68DA835aeB64a26,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6b90b6c5-fd07-4615-a284-26dee3094e82	2022-09-14 19:04:13.03045+00	https://youtu.be/hhRwTlo-Tzc	Thankyou Jacka	{"The Free Minded","Larry June"}	3	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Larry June 	\N	MakintsMind	{0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e30f040d-c642-42db-aa4a-9c3a052eb9c2	2022-09-20 23:09:56.410645+00	https://youtu.be/euncEN1F_08	No Patience 	{RNB,"Late Night Gems",Makintsmind}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Abdou 	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c8a777e0-ba3a-4ce8-b192-71ce8185ca79	2022-09-20 22:56:18.537475+00	https://www.youtube.com/watch?v=kavRCOmuvyQ	Understand 	{"The Element Of Surprise",10/10,"Listen to This !!!"}	1	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Rashad & Confidence	\N	MakintsMind	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
80246444-acd0-4571-933b-2ecb41d5df28	2022-09-25 20:23:53.630151+00	https://youtu.be/sguX98DPZsg	Buckhead Freestyle	\N	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	SixSaidIt	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
9fbb2dfb-5e86-40c4-9135-7cf447e71afa	2022-09-20 23:06:16.077579+00	https://youtu.be/9PGIGVXnh0g	Growin Pains	{Throwback}	2	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Overdoz	\N	MakintsMind	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a4fd6744-7c66-4ee1-a224-ba9db669c3ea	2022-10-28 15:05:41.196651+00	https://offtrackrecordings.bandcamp.com/track/message-in-the-air	Message In the Air	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	John Barera	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
45ed6dbe-de0f-4a85-9a94-bc528524b704	2022-09-23 23:23:45.176319+00	https://youtu.be/BK72YNkZwQ4	Dark Hearted	{SSS,BFK,"Soul Sold Separately",Makintsmind}	2	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Freddie Gibbs	\N	MakintsMind	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
92c10254-9384-419f-a3cf-1a49919f519d	2022-09-25 20:29:52.742353+00	https://youtu.be/f_N9DVbD61c	Crystal	\N	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	SixSaidIt	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c28f39d8-d901-4d76-8e39-c641f0ef6876	2022-09-20 22:53:18.110444+00	https://www.youtube.com/watch?v=DyMMKnzN0p0	Please Don't Play With Fire	{makintsmind,ukrap}	3	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	One Acen ft JME	\N	MakintsMind	{0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
576a4509-3573-4004-a346-eeaa6c04f826	2022-09-28 08:44:17.473443+00	https://www.youtube.com/watch?v=A_asfZhfTBk	Household Goods	{uk,dance}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Totally Enormous Extinct Dinosaurs	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
57eb92b4-6e18-4fa5-9eb6-89bcf0152400	2022-09-28 08:47:19.04786+00	https://www.youtube.com/watch?v=0qIAN9FZGrM	Metahuman	{"beep boop",portland}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	EPROM	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
45389d71-cbc6-473c-acf5-635c726160df	2022-09-28 08:52:56.082648+00	https://www.youtube.com/watch?v=-tBXeAQBXHA	Hype Me Up	{jamaica,"the bronx",dancehall}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	HoodCelebrityy	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
05b32708-4ec4-4560-9678-5d573d0ab006	2022-09-28 13:28:30.786882+00	https://youtu.be/rZJ7JXdj_og	333/ATOM	{"Lyric Video"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Kenny Mason	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ce963711-fb8c-43c4-aaca-d4f9a9a16648	2022-09-28 13:32:40.180566+00	https://youtu.be/kNI_HKUAsw8	Givenchy	{"Lyric Video"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Kenny Mason	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
84aa6274-77ee-45ae-b2b1-e1ada890b28a	2022-09-28 09:20:51.166987+00	https://www.youtube.com/watch?v=kq0esXnc29k	messy in heaven	\N	3	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	venbee	\N	future modern	{0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d69dcb3c-2f83-44e0-b609-e410a313de47	2022-09-28 13:34:12.788158+00	https://youtu.be/CxecDC2mA50	Shell	{"Lyric Video"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Kenny Mason	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ce343c84-691b-4fba-843e-d5220c468798	2022-09-28 13:37:50.889339+00	https://youtu.be/ilBDCxzIftw	Minute Forever	{"Lyric Video"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Kenny Mason	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2d8ad840-07f7-4435-8101-ee24a2913e03	2022-09-28 13:41:24.392919+00	https://youtu.be/EaQiFyK-AWU	Double Up	{"Lyric Video"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Kenny Mason	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
72b038f7-39ea-49a3-ac8a-1ce2461c94a5	2022-09-28 13:44:53.031074+00	https://youtu.be/UD9eQ02o51M	Zoomies	{"Lyric Video"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Kenny Mason	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
cbd8be15-cd77-4422-be8e-15b65a2bfeff	2022-09-28 13:46:00.673309+00	https://youtu.be/e6gNPGJ97ls	RX	{"Lyric Video"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Kenny Mason, Amindi	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
cf775f46-a990-4db2-afaa-a1e0513bb927	2022-10-28 15:07:24.995251+00	https://offtrackrecordings.bandcamp.com/track/give-u-my-love	Give U My Love	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	John Barera	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
33b1559f-fa6b-4d3f-911b-382a5c4f2515	2022-09-25 22:22:50.517815+00	https://youtu.be/VF-FGf_ZZiI	Bad Habit	{"Music Video"}	3	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Steve Lacy	\N	hallway	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5,0xef58304e292fbaeacfdec25b67b3438031fde313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
77c6fafa-4cb2-4868-b24a-262f909a4b81	2022-09-23 23:29:23.761927+00	https://www.youtube.com/watch?v=2litzsFCwkA	MELMADEMEDOIT	{STORMZY,MELMADEMEDOIT,UKRAP,UKGRIMESCENE,MERKY,"JOSE MOURINHO"}	3	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Stormzy	\N	MakintsMind	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d318a571-3223-43a7-9b5e-ae8371d6ee82	2022-09-28 13:38:51.712981+00	https://youtu.be/LQzCBD23mIs	Halos	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Kenny Mason	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
166c88e5-dd4b-413d-8d17-f72bcc82a13e	2022-09-30 20:41:13.980135+00	https://www.youtube.com/watch?v=d9zaFGANyrI	1er Gaou	{"ivory coast",coupé-décalé}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Magic System	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8aed558b-2caa-4781-8ec4-362b2d8b4d9a	2022-10-07 18:15:56.620403+00	https://youtu.be/hasJZ_ohjgU	KIDS EAT PILLS*	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Jean Dawson	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8ecd8805-005f-4c16-a1d0-1563fbecffc1	2022-09-29 03:14:29.789231+00	https://www.youtube.com/watch?v=CcNo07Xp8aQ	Dancing On My Own	{sweden,electropop}	4	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Robyn	\N	future modern	{0xcEbc98F37D83164dE8169ec1eeA1F76c0669A486,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b08695f6-a95a-4f8e-8f2a-1b8ce760b510	2022-09-30 01:39:24.741495+00	https://www.youtube.com/watch?v=eu0KsZ_MVBc	Because I'm Me ft. Camp Lo	{sampledelia,australia}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	The Avalanches	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b071df7c-a768-446d-b14d-e59e904b5e1f	2022-09-30 01:53:21.944589+00	https://youtu.be/hTGJfRPLe08	Gosh	{"the xx"}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Jamie xx	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2ab39f38-2d1d-4014-944d-d690fcbf432e	2022-09-30 01:56:34.092041+00	https://youtu.be/eUSkZCoGalo	2 Die 4	{"swedish pop"}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Tove Lo	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
358a7316-0dc0-449e-883d-515fcec2f513	2022-09-30 02:03:51.658018+00	https://www.youtube.com/watch?v=2tvW25Qu5WE	New Shapes ft. Caroline Polachek, Chris and the Queens	{"what you want","i aint got it"}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Charli XCX	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1568a4ef-34da-4b7f-ac88-4d146ccd7ab7	2022-09-30 02:13:47.528042+00	https://youtu.be/WlPzUVyjyIA	Lightning	\N	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Rico Nasty	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3e1cf716-90e8-41f1-8c93-a1ee530abb6b	2022-09-25 21:44:28.010312+00	https://youtu.be/FjE0DWz9dkA	Sex Appeal	{"Music Video"}	3	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	BLACKSTARKIDS	\N	hallway	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74,0x5ab45FB874701d910140e58EA62518566709c408}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b3320b53-5c72-4e8c-874e-de91f80c418e	2022-09-30 02:22:01.667424+00	https://youtu.be/PM0qn7KzryQ	BDE ft. Slowthai	\N	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Shygirl	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d7575f69-f560-4e0b-8a97-799eab4b10f4	2022-09-29 04:22:35.981815+00	https://www.youtube.com/watch?v=8RQDPwODja4	Disco Tits	{sweden}	4	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Tove Lo	\N	future modern	{0xcEbc98F37D83164dE8169ec1eeA1F76c0669A486,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xb60D2E146903852A94271B9A71CF45aa94277eB5,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b68d461e-229b-458e-ba71-eeb4ee911232	2022-09-30 23:03:15.781297+00	https://www.youtube.com/watch?v=PUza4x2V5fU	carefully	\N	0	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	Timi O	\N	athenayasaman	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4c2ed208-9df2-44ef-b101-974c68fe79d8	2022-09-30 23:04:39.777393+00	https://www.youtube.com/watch?v=Dh5E4R0Dor4	25	\N	0	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	Timi O	\N	athenayasaman	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2aa1a01e-d56f-4ea6-a4f7-2a55533fa82c	2022-09-28 13:29:52.934632+00	https://youtu.be/MnsCD2nfIRk	BOA	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Kenny Mason	\N	hallway	{0xb60D2E146903852A94271B9A71CF45aa94277eB5}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
03da58a4-0d94-4600-a154-444ca7385cdd	2022-09-30 22:58:18.45247+00	https://www.youtube.com/watch?v=JMQytbllfWc	Away	{}	4	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	Keamo	\N	athenayasaman	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d28bfc74-c299-4a79-8d88-3bef75ac64b8	2022-10-05 15:01:32.83705+00	https://youtu.be/d6ljVVHAGiQ	WTF	{"Music Video"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Savannah Re	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4b1d002f-a54a-4909-8cb0-8c1083a16282	2022-09-28 13:52:09.458024+00	https://youtu.be/C3GtplJCyCE	Westside	{"Lyric Video"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Kenny Mason	\N	hallway	{0xb60D2E146903852A94271B9A71CF45aa94277eB5}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
dd22c118-8d30-4d11-973a-5454fc1e6434	2022-10-28 15:09:13.62701+00	https://offtrackrecordings.bandcamp.com/track/we-got-this	We Got This	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	John Barera	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
844c9f0f-9250-4fd0-9f4d-3c8e670873f1	2022-10-04 23:49:11.00855+00	https://www.youtube.com/watch?v=1J-_W-N2548	Function	{🏴‍☠️,dance}	0	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Tentendo and Jordan Dennis	\N	Ghostflow	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
13c5548c-db63-4b7a-ab4b-0ad0f24f1bb2	2022-10-05 00:08:06.347574+00	https://www.youtube.com/watch?v=-GbzS9JdAmw	Hypnotize	{🏴‍☠️,Dance}	1	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	stevedreez	\N	Ghostflow	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0a93cae5-f9d1-4b70-9ab3-4408853ba1e8	2022-10-04 23:56:28.314664+00	https://www.youtube.com/watch?v=g2iOxL0SlNU	Buzzkill	{🏴‍☠️}	1	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Take Van	\N	Ghostflow	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e0293c6f-df1e-40fa-bc00-8ee059f2a60d	2022-10-03 00:54:19.893465+00	https://youtu.be/yfoAEs6jgWE	Self Made	\N	3	\N	0xb1984b5790A483Ea646A21BD64614328775d4174	\N	Slimka 	\N	\N	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4bc70816-b22e-4cd5-846c-42324c8adc33	2022-10-05 14:53:36.426474+00	https://youtu.be/c4Sa3Fx9Ss8	Happier Than Ever (Billie Eilish Cover)	{"BBC Radio 1"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Rina Sawayama	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4c59b635-8799-44d9-be30-3c584a3ef510	2022-10-05 14:36:36.441895+00	https://williecolon.bandcamp.com/track/willie-whopper	Willie Whopper	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Willie Colon	\N	hallway	{0x5ab45FB874701d910140e58EA62518566709c408}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
9a6f4b59-f62b-40a1-bfcf-baaa5a1e0332	2022-10-01 00:25:51.440571+00	https://music.apple.com/us/album/burn-it-up/1643068734?i=1643068741	Burn It Up	{JKJ,Hip-Hop,McKeesport,Pittsburgh,Trap,Rap,Dark}	3	\N	0xC53Eae37e0cAE1d0dBa541455D56d97F1d37B002	\N	JKJ	\N	JKJMusic	{0x5ab45FB874701d910140e58EA62518566709c408,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f2b00193-d54f-4017-9911-68b426d3a29f	2022-09-23 23:21:46.573127+00	https://youtu.be/03QnHArqJeE	Open Up	{#SOULECTION,#OpenUp,#MackKeane,ESTA,Makintsmind}	3	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Mack Keane ft ESTA	\N	MakintsMind	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ae1eec8c-ab7c-4fbb-9d98-a6620df52192	2022-10-03 01:17:32.628652+00	https://youtu.be/mds7TYMwn2w	Toronto Funhouse 	{🏴‍☠️}	1	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Tyriqueordie	\N	Ghostflow	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2988ba09-ff8a-40d0-ad83-adae6c754261	2022-10-05 14:18:20.383716+00	https://youtu.be/8jBZAZxH73k	We Gon See	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Chavis Chandler, Bo404	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
50951173-c1bb-47ca-9388-7a67311c3786	2022-10-05 14:18:58.145352+00	https://youtu.be/f32eCeneIbY	One Wish	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Shordie Shordie	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
cf841b63-f598-4e47-93c2-99b3db0370fe	2022-10-05 14:28:14.651727+00	https://youtu.be/GOb52mMh1LM	Fuck 12 Freestyle	{"Lyric Video"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	LaRussell, Guapdad4000, Tales of the Town	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6b182e4f-b4ec-4132-8b68-b2abbbd346f4	2022-10-05 14:41:16.455088+00	https://tompkinssquare.bandcamp.com/album/searching-in-grenoble-the-1978-solo-piano-concert	 Searching in Grenoble : The 1978 Solo Piano Concert	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Mal Waldron	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
331b2435-40eb-4dd4-bc58-f43b6d983a75	2022-10-05 14:45:13.805934+00	https://lunali.bandcamp.com/album/jams-2-ep	daydream	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Luna Li	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4315c591-5a6a-43ed-8851-dba38339904d	2022-10-05 14:47:59.387267+00	https://youtu.be/2MaxTUT4sAU	Wasted	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	TeaMarr	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ebdf43cc-621d-4fc3-8fec-11c01a9c1980	2022-10-05 13:21:23.568669+00	https://theeblkpearl.bandcamp.com/track/top-notch-goddess	Top Notch Goddess	\N	1	\N	0x4A4f34c8CE0ac04Cf8d85806CD860C47Ab66430b	\N	Thee BLK Pearl 	\N	\N	{0x5ab45FB874701d910140e58EA62518566709c408}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
e5452c8d-e363-49b9-a1ca-e89ab646a11c	2022-10-02 17:49:04.081889+00	https://open.spotify.com/track/5NDAjPZGAlMz3PqyttrE2s?si=e5d9219946e24866	Bruh	\N	1	\N	0xa52B442bfeca885d7DE4F74971337f6Cf4E86f3B	\N	jump man 93	\N	Timer°°	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
59afb59f-5be1-4e09-8a04-8e5a42185a1d	2022-10-05 14:14:24.88855+00	https://youtu.be/zwZh0XagO5o	Ballin'	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Earlly Mac	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
93ff5ca4-e1f3-46d5-b99a-7031dee562e2	2022-10-05 14:00:58.700079+00	https://youtu.be/PedbTAZ6wzg	Bless The Dead	\N	2	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Trizz, Mike Summers, T.F, ICECOLDBISHOP, Bale 	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
99901842-9224-4bce-a48e-8c84d840647b	2022-10-05 14:32:00.10743+00	https://youtu.be/PckNCXIINV0	Iced Tea	{"Music Video"}	2	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Joyce Wrice, Kaytranada	\N	hallway	{0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
314dfded-027b-46a1-bc95-ca4ae74bb203	2022-04-30 13:27:29.086255+00	https://opensea.io/assets/0x495f947276749ce646f68ac8c248420045cb7b5e/44700177556079130579027571864789921161109844202338692374214745856868708515850	Seasons	\N	0	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Pat Dimitri	\N	Trish	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
03d7fe2d-1040-4de9-b493-f188d28464f8	2022-05-01 21:08:54.13037+00	https://www.youtube.com/watch?v=Zyp1yXyXtnk	IDENTITY CRISIS	\N	0	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	ED BALLOON	\N	Trish	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b11713de-f6eb-4271-a409-d420e8ffd5ed	2022-05-01 08:20:09.726383+00	https://beta.catalog.works/musebymonday/bayside-manor	Bayside Manor	{rap,"hip hop"}	1	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Monday!	\N	Trish	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
12ced061-bb8e-4a2c-931d-83232e7e9f1f	2022-05-01 08:21:53.415038+00	https://beta.catalog.works/musebymonday/beneath-the-night	Beneath the Night	{rap}	1	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Monday!	\N	Trish	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7786b586-4182-479f-937e-d70ff8919b85	2022-04-30 13:45:13.339507+00	https://drive.google.com/drive/folders/1d3LSubFBTgK0RXLqDlmdAm0YyjZ7zQGO?usp=sharing	Runway	\N	2	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Matt Monday	\N	Trish	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f9ef20c7-53b5-4c16-b474-8febb20a39a2	2022-04-30 13:48:48.077958+00	https://beta.catalog.works/musebymonday	Sajin	\N	2	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Monday & Black Dave	\N	Trish	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f948823c-3733-474c-98f2-0c78fdb1336e	2022-05-31 06:51:52.560885+00	https://beta.catalog.works/musebymonday/sajin	Sajin	\N	1	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Matt Monday	\N	Trish	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4b14490c-ff1c-40c3-9457-046739bef780	2022-05-31 07:09:31.095371+00	https://www.sound.xyz/blackdave/triple-beam	Triple Beam	\N	1	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Black Dave	\N	Trish	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d4e2113e-fe23-47a8-8e67-552699bab178	2022-05-31 07:19:48.845937+00	https://www.mintsongs.com/songs/5425	I'm In Love With You	{"goes hard",metal}	1	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Black Dave	\N	Trish	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3c09b5f0-e6e2-4bc2-8b10-212eb522f075	2022-05-31 07:16:28.489618+00	https://www.mintsongs.com/songs/5426	Small Streams, Strong Rivers	{rap,metal,"goes hard"}	1	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Black Dave	\N	Trish	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f794f554-007e-4ace-a8a2-ceb67fe8771c	2022-05-31 19:56:20.863293+00	https://beta.catalog.works/charmtayloristhefuturehttps://open.spotify.com/track/5Q76QuxFwZp3S9tYJNktTg?si=ca7fabc68dd34084	Shine	{"hip hop",rap}	2	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Charm Taylor	\N	Trish	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x5ab45FB874701d910140e58EA62518566709c408}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2b076af5-eb57-4070-bfd0-a60950e39b2d	2022-06-01 04:58:19.977434+00	https://beta.catalog.works/dominosmusic	Heaven and Hell	{"hip hop",rap}	0	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Domino	\N	Trish	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
12f63bf5-b3f0-4538-afbf-94b8634fd442	2022-06-03 04:37:46.388839+00	https://open.spotify.com/track/52UthFOfrbtnjBMK6jyLqk?si=40cd7229400b49dd	Nothing is Safe	\N	1	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Clipping	\N	Trish	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
db8ec06e-e8be-4f18-a2f7-fdc46964bf49	2022-10-05 14:02:45.496332+00	https://youtu.be/-KnWg-ZAVoQ	3am In Florissant	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Davie Napalm 	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
72391dd5-033b-4be7-aa38-e5a840d8878b	2022-09-29 03:13:21.404263+00	https://www.youtube.com/watch?v=F6ImxY6hnfA	Call Your Girlfriend	{electropop,sweden}	2	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Robyn	\N	future modern	{0xcEbc98F37D83164dE8169ec1eeA1F76c0669A486,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ab874133-ec75-4802-a365-923a9fda4b26	2022-10-01 19:09:08.563692+00	https://music.apple.com/gb/album/biggest-single/1575892641	Biggest	{"black superman"}	4	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Idris Elba	\N	future modern	{0xb60D2E146903852A94271B9A71CF45aa94277eB5,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8f4aa9a6-9f05-4293-a55c-b3bc8c08e1f7	2022-10-28 15:21:11.54318+00	https://youtu.be/N5JyO33SaXM	Greedy	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Ailsa Tully	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3c2069dc-e0c6-477e-a625-ff4496e05ad4	2022-10-06 03:23:24.418999+00	https://www.youtube.com/watch?v=jwNMtPulE50	On Me	{"tik tok"}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Mike Floss	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
db776edc-00cf-4d19-89e6-8e287628d50b	2022-10-06 03:28:29.049138+00	https://soundcloud.com/2floody/rager-prod-swanbeatz	Rager	{rage}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	2Floody	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
514b22c9-51a1-4377-9c72-a2d9a8a1d2a5	2022-11-01 17:53:00.38846+00	https://youtu.be/a5uRn5-9Suc	Bars Into Captions	{"Official Visualizer"}	1	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Quavo, Takeoff	\N	\N	{0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f89e9073-bb86-4f32-a936-5b5fbcb55eb5	2022-10-06 05:57:09.637095+00	https://www.youtube.com/watch?v=g6L3OSFbUY8	Green Aisles	\N	1	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Real Estate	\N	future modern	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a9302337-52cc-4aaf-8c8a-dabc1bf4ef05	2022-10-07 18:16:35.992474+00	https://youtu.be/fy8mvna7YEc	POSITIVE ONE NEGATIVE ONE*	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Jean Dawson	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6693c82c-1bd9-47b1-a8ad-5ce605480cb6	2022-10-06 11:48:02.142283+00	https://www.youtube.com/watch?v=Nsrygut8X6U	Sunshine	{"hip hop"}	1	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Rye Rye ft MIA	\N	Trish	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
28104590-d9bd-4f2c-9d2a-17d5db5e5c1d	2022-10-05 15:18:11.006597+00	https://youtu.be/_lIgwawdyaI	Nowhere But Up	{"Music Video"}	3	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Phony Ppl	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f916f82c-c794-4c50-9006-79c38aeb920a	2022-10-06 21:41:47.26066+00	https://youtu.be/u-2TtuxlEVQ	One Of A Kind	{BlockBoy,@makintsmind,"UK Rap"}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Leemz	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
582fb1b0-30ff-46b2-ae31-2eca4b10518d	2022-10-06 21:44:20.782072+00	https://youtu.be/wqqZPjKvUcs	4 The Money	{"Fully Lidge","UK Rap",@makintsmind}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Strandz	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a703a250-431d-4097-8b98-5be175ba2da8	2022-10-06 21:48:21.486147+00	https://youtu.be/03dt9-9PeOo	Criminal	{"UK Rap"}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Strandz	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
982da1b7-1af2-40ab-92c4-5d6e774e7ebb	2022-10-06 21:59:49.899758+00	https://youtu.be/XddXVNfnQ28	Nothing Lasts Forever	{SBK,"UK Rap / Grime"}	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	SBK	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
870d5ade-9719-493c-8010-aef97ac36366	2022-10-06 22:11:44.162787+00	https://youtu.be/fo8gV0lSpsg	sbk - 141414 / Let Go	\N	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	SBK	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a4ff5802-e95f-4ccb-ac49-5f86f6a85d4d	2022-10-06 22:15:46.88852+00	https://youtu.be/5eXwknHm77c	Snitch	\N	0	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	SBK 	\N	MakintsMind	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
bbb5ae70-46e8-492f-943b-535cd3795cc8	2022-10-07 05:52:48.879144+00	https://soundcloud.com/770rd/poland-lil-yachtyprod-f1lthy	Poland	{wockhardt}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Lil Yachty	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
25b6f53e-fdf7-44aa-a5c3-df36d0f3fcd1	2022-10-07 05:56:07.617504+00	https://www.youtube.com/watch?v=cAttZRHPRqg	Mhmm	{florida,"free him"}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Lil Polo Da Don	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0f2dcdf5-fa4f-41ee-9db6-0f46a3e8f0d1	2022-10-07 06:02:51.708934+00	https://www.youtube.com/watch?v=jeeA2MyGXBE	Static	{inglewood}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Steve Lacy	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ddca4325-982b-45f6-bed4-0acf36ba1fb2	2022-10-31 12:55:58.765513+00	https://open.spotify.com/track/0aKtvv32TRcxswX8jCkWxI?si=7de6b4273fbe4473	Sunset Sky	\N	1	\N	0x72a29592f782016e8ba87e83e854f246e4fb363a	\N	A Big Enough Sky	\N	\N	{0xa52b442bfeca885d7de4f74971337f6cf4e86f3b}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
89b59800-1fef-4124-95da-39415ac3d1c1	2022-10-07 16:13:56.235482+00	https://www.youtube.com/watch?v=kqDD_pGgQyo	223's ft. Babytron	{midwest,indiana}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	midwxst	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1a591182-3e08-494e-83d0-138a322ce108	2022-10-07 16:15:59.763175+00	https://www.youtube.com/watch?v=3goxLMs6wQI	Mr. Do The Dash	{detroit,scam}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Babytron	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6cbd26b4-2c58-403c-be86-5f8163688ff4	2022-10-07 13:38:04.90432+00	https://open.spotify.com/track/0UfiLEHHKzibhZDgPe8f2W?si=390a6c9ebe234db6	Time	\N	3	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Aaron May	\N	MakintsMind	{0x371107cc397A1fd11FD5A7aC8421a3E43F886444,0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47,0x0bbac2bd3134a318deb31137d87d42bf54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
29dfbc7c-6e80-435c-b379-bcb596298d25	2022-10-07 14:02:36.60589+00	https://open.spotify.com/track/2nzVYhW0dohj75ILgGsC79?si=96a2da077d4a4381	Can't Wake Up 	\N	3	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	ahmadanonimis	\N	MakintsMind	{0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
065e634e-875f-4cbf-81db-35209741e4b3	2022-10-06 21:55:20.640788+00	https://youtu.be/0yonORB4s_s	CIA	{SSS,"Soul Sold Separately",Gibbs}	3	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Freddie Gibbs	\N	MakintsMind	{0x371107cc397A1fd11FD5A7aC8421a3E43F886444,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ecfa2fe0-ac3d-445d-9576-c15c4b2b6f4d	2022-10-06 21:53:00.195215+00	https://youtu.be/IhVkUe9oDwM	Gold Rings	{SSS,BFK}	1	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Freddie Gibbs ft Pusha T	\N	MakintsMind	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
5a87c179-a2f5-4395-a7ff-89af6ebfa973	2022-10-07 16:52:13.596378+00	https://open.spotify.com/track/1OdYXTMwjl4f4g4ch05CEq?si=36a717967fa64fe2	Бом	{moscow,trumpet,dance,house,rap}	3	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5	\N	Antoha MC	\N	athenayasaman	{0x371107cc397A1fd11FD5A7aC8421a3E43F886444,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
db129df6-a469-49e4-8d70-83f19309c2a0	2022-10-07 13:13:43.261599+00	https://open.spotify.com/track/0vbmYCIWENdYyJ36Q4CdSz?si=9e8f3e5323904273	90 Proof	\N	3	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	Smino ft J Cole 	\N	MakintsMind	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
fcef6a12-c239-47a0-bd09-b294ce1045ce	2022-10-07 13:03:32.59633+00	https://open.spotify.com/track/6H6ZtVp6DymejLOJLdRzOI?si=9ad1b1bb76584aba	Shordie	\N	3	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	G Herbo ft Gunna	\N	MakintsMind	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
fd367f33-09ad-49c2-a9b4-ffb5bd2fcaf0	2022-10-06 11:49:49.73949+00	https://youtu.be/fXJc2NYwHjw	 93 'Til Infinity	{"90's hip hop","hip hop",90s}	3	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	Souls Of Mischief	\N	Trish	{0x5ab45FB874701d910140e58EA62518566709c408,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ad5b46c0-5ba5-4626-8bda-fc99439fcdfc	2022-10-07 18:19:04.482466+00	https://youtu.be/C0FZnpyD0ao	SCREW FACE*	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Jean Dawson	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4ef4791f-2e5f-4179-bdb4-7c2f55e11ebb	2022-10-07 18:20:47.987704+00	https://youtu.be/dH--H8ldtAE	HUH*	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Jean Dawson	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
82afc301-0e15-4f0b-b8de-54d3ad9bac34	2022-10-07 18:22:05.335623+00	https://youtu.be/e8cOvgIpcHw	SICK OF IT*	{"MUSIC VIDEO"}	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Jean Dawson	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ba82eb68-aba2-4c1f-9b8b-4d94df130cca	2022-10-11 11:57:22.243363+00	https://www.youtube.com/watch?v=1YDLFUXCRUo	YOU'RE A PARASITE	{🏴‍☠️}	3	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	RIOVAZ	\N	Ghostflow	{0x371107cc397A1fd11FD5A7aC8421a3E43F886444,0x52fA05393a003d234eFBA136E68DA835aeB64a26,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7eb6355f-7d85-4bab-a894-f3213af0b584	2022-10-08 14:41:37.475453+00	https://open.spotify.com/track/1HjM0fHlNYFgIFwgv0q58Z?si=VuqiXo7kSWaAb5N4pcengA	Soul Belongs 2 U	{🏴‍☠️}	0	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Dreamcastmoe	\N	Ghostflow	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
d5f0925e-129a-4259-a76c-a9ef1b4d2235	2022-10-13 20:36:22.448648+00	https://youtu.be/B_nm0wLxXeI	Thousand Knives (Ryuichi Sakamoto Cover)	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Thundercat	\N	hallway	{0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6e8141a2-69f2-4b18-a1ad-cbe371c652be	2022-10-09 22:00:16.060944+00	https://open.spotify.com/track/2WeDmp1zye21RZjLd5rYqb?si=366b745899d74ccc	Battant Pavillon Étranger	\N	0	\N	0x38d59276DcF946a506E2D18534dce2bef9c50D4f	\N	Ornette	\N	kanna+	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
c168a983-8d31-48e2-ac07-0c4866becc94	2022-10-10 20:29:18.357128+00	https://open.spotify.com/track/7MzztXJbhqwsBFpQuMLJbf?si=627a2a0cc29e4369	Cosmo	\N	0	\N	0x38d59276DcF946a506E2D18534dce2bef9c50D4f	\N	Skotty Welch	\N	kanna+	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8d2a89b1-c6a4-49e2-a078-0ed6f76b2506	2022-10-11 20:08:17.295987+00	https://open.spotify.com/track/2887RUxGDlUQbLlySpZ8Kq?si=1bb5586e0ab048bb	Chasing the Light	\N	0	\N	0x38d59276DcF946a506E2D18534dce2bef9c50D4f	\N	Skotty Welch	\N	kanna+	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
df5c64de-f7f0-41b8-a573-46c62d5e06fb	2022-10-03 00:14:04.230305+00	https://open.spotify.com/track/5EI94cNPh81RIh1NZy5qqR?si=54J1tiIdRH-1kg2vaSrlQQ	Dinsdag	\N	5	\N	0xAc801951867c4fE73bEeAe4961A6557FfdC83bfF	\N	Rarri Jackson	\N	emez	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
4a0a1fe3-68dd-48cd-a68a-4c53456fba12	2022-10-08 14:41:21.84192+00	https://open.spotify.com/track/1HjM0fHlNYFgIFwgv0q58Z?si=VuqiXo7kSWaAb5N4pcengA	Soul Belongs 2 U	{🏴‍☠️}	3	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Dreamcastmoe	\N	Ghostflow	{0x52fA05393a003d234eFBA136E68DA835aeB64a26,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8738cb6d-40df-4fe9-9391-fe7a56f90301	2022-10-12 03:14:34.735664+00	https://www.youtube.com/watch?v=QTmRmPDS9tw	NOSTYLIST	{i-20,atlanta}	3	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Destroy Lonely	\N	future modern	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1f427acb-ac27-45e4-a21d-1f37eb9cd5d9	2022-10-12 14:50:50.413485+00	https://open.spotify.com/track/6YBiXXECi9ePcN6hToOpU1?si=017a4c16002c4ec4	Ga$ton Rasta	{🏴‍☠️}	0	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	CalvoMusic, DJ Glo 410	\N	Ghostflow	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
b2699353-4fc8-447e-8a51-c931553587e9	2022-10-12 22:05:11.591617+00	https://www.youtube.com/watch?v=gpwYTeRSgc8	GOOD TIMES	\N	1	\N	0x8D41859049c156E70fa381e07a757D5Db2f33E1d	\N	Jungle	\N	jakeabel7	{0x371107cc397A1fd11FD5A7aC8421a3E43F886444}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
57b33912-130d-4aa2-ac01-9e16222712dd	2022-10-07 18:17:17.728164+00	https://youtu.be/Exw73HfzQTo	BAD FRUIT*	\N	3	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Jean Dawson, Earl Sweatshirt	\N	hallway	{0x5ab45FB874701d910140e58EA62518566709c408,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
5b2a3b91-510d-49e2-ad3b-5fb77602e177	2022-10-07 18:23:09.207132+00	https://youtu.be/_dYC6QndB2o	PIRATE RADIO*	{"MUSIC VIDEO"}	3	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Jean Dawson	\N	hallway	{0x371107cc397A1fd11FD5A7aC8421a3E43F886444,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x52fA05393a003d234eFBA136E68DA835aeB64a26}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
8bf5f424-5d3b-4908-ad83-bea243d644c5	2022-10-07 18:20:20.22246+00	https://youtu.be/HKyOUrLMdac	Black Michael Jackson	\N	3	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Jean Dawson, George Clanton	\N	hallway	{0x5ab45FB874701d910140e58EA62518566709c408,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x52fA05393a003d234eFBA136E68DA835aeB64a26}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1a3840d8-a2ef-4c48-9d16-333044a8ad8e	2022-10-12 18:34:18.437948+00	https://www.youtube.com/watch?v=hAuahyHJfRo	Ain't Going Back	{🏴‍☠️}	1	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Rican Da Menace	\N	Ghostflow	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
882c2985-26eb-47ec-97d3-b16b01da7b9d	2022-10-13 15:23:30.744677+00	https://open.spotify.com/track/1ofE8ysdx2yRlfk21hqipf?si=v9l0BjEsSvyUi5Ss8ry7sA	Bitch We From Baltimore	{🏴‍☠️}	0	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	CalvoHarris, Charles	\N	Ghostflow	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7a3be358-46ce-4f0e-a60a-d56ac7c8b6a5	2022-10-17 05:05:18.715333+00	https://open.spotify.com/track/2yYxbpJ6kVvA6vxHVF4dpw?si=LgIsrQygT0aNbV5X_ggg0Q	you can miss me	\N	3	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Kinrose	\N	discoveringEs	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
5fe32496-5e7c-4f8c-93f5-6e0be3ffca4b	2022-10-13 15:48:54.284649+00	https://www.youtube.com/watch?v=_XGiuBGloDg	Body Low	\N	0	\N	0x8D41859049c156E70fa381e07a757D5Db2f33E1d	\N	Hutty	\N	jakeabel7	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2094b9fc-d2e8-4eb5-b0d3-f5f87c75497b	2022-10-14 04:18:07.177649+00	https://www.youtube.com/watch?v=PR6pHtiNT_k	Caldonia	{swing,r&b,blues}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Louis Jordan	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
759eb4b1-5de1-4216-8321-0b6ef8bd17ea	2022-10-14 17:35:12.754844+00	https://www.youtube.com/watch?v=CMWLX0KXwF4	no one dies from love	{swedish,electropop}	0	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Tove Lo	\N	future modern	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
22f9c6af-caf3-4dd7-9d2d-923c04ccf52d	2022-10-14 18:45:30.747602+00	https://open.spotify.com/track/4HcmKnUwCKsloslonqMzCN?si=f95dc95efa684aed	Streetside	\N	0	\N	0x8D41859049c156E70fa381e07a757D5Db2f33E1d	\N	Bru-C	\N	jakeabel7	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7362e628-1043-416e-a7fb-569edc2eff1c	2022-10-17 04:48:41.381455+00	https://youtu.be/29mk5rz3m7Q	Stressed | A COLORS SHOW	\N	3	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Doechii	\N	discoveringEs	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
9917eedd-d14d-465b-9324-6c4a4107d483	2022-10-17 04:51:52.919679+00	https://open.spotify.com/track/1I5jWUS5ItnNE7eBV2HuPl?si=07CJMoNmTImlK-NsVPMGdg	Same Ole	\N	1	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Kelechief	\N	discoveringEs	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
76651608-74d5-4698-a21b-61e5cd456e90	2022-10-07 18:15:17.376496+00	https://youtu.be/7Wop8A6S6_k	GLORY*	\N	2	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Jean Dawson	\N	hallway	{0x5ab45FB874701d910140e58EA62518566709c408,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a6c0d29d-4cb5-4bbe-819a-d37981699fd3	2022-10-10 19:01:06.909218+00	https://hausofaltr.bandcamp.com/track/4-matic-amal-x-jamesbangura	4 MATIC	{🏴‍☠️,DANCE,TECHNO,BRC}	3	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	BLACK RAVE CULTURE	\N	Ghostflow	{0x371107cc397A1fd11FD5A7aC8421a3E43F886444,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ff9ce3cb-4946-48df-bf57-8b75bdc34007	2022-10-07 13:07:07.435846+00	https://open.spotify.com/track/2rR5N3uF8V4mPX9pxdrcaC?si=cc02a079c67e49e1	Outside Looking In 	\N	3	\N	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23	\N	G Herbo	\N	MakintsMind	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
bb4c82b1-c972-4667-ad20-37aaecd699a8	2022-10-06 12:21:22.529982+00	https://youtu.be/MJCHeEQV454?t=139	The Roots ft. Erykah Badu	\N	3	\N	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2	\N	You Got Me 	\N	Trish	{0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7dcc531c-ded6-4757-98d1-83308c65a58f	2022-09-25 21:52:16.72864+00	https://youtu.be/Xbs5Hg2fYD4	e-motions	{"Music Video"}	3	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Mura Masa, Erika de Casier	\N	hallway	{0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f69b301e-4f1e-4d04-82d3-7fe04a0c28a9	2022-04-30 19:16:26.757764+00	https://youtu.be/cP2GQqk2kx0	Black Iverson	{TWNSHP,🔦}	5	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Guap	\N	hallway	{0x5f8b9B4541Ecef965424f1dB923806aAD626Add2,0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01,0xc2469e9D964F25c58755380727a1C98782a219ac,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
a7579e54-e242-41bd-bb8f-521682a046af	2022-10-17 05:03:00.357658+00	https://open.spotify.com/track/7z84Fwf1R3Z2BwHCP620CI?si=wRulLNvmRlGRC7sYXefHHQ	This Is Why	\N	0	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Paramore	\N	discoveringEs	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2d40a01a-263f-43a8-8760-cfd87dfc645a	2022-10-07 18:18:31.427554+00	https://youtu.be/d6WrshMFrlA	0-HEROES*	\N	3	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Jean Dawson	\N	hallway	{0x5ab45FB874701d910140e58EA62518566709c408,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0xf75779719f72f480e57b1ab06a729af2d051b1cd}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6e3b870b-0d1c-4ee3-8064-2bd42211404c	2022-10-11 23:37:28.750167+00	https://open.spotify.com/track/3ROIeElZPzrnmViqcpBTXE?si=65af10706a29426f	With You	\N	3	\N	0xAc801951867c4fE73bEeAe4961A6557FfdC83bfF	\N	NNAVY	\N	emez	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x52fA05393a003d234eFBA136E68DA835aeB64a26}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7c0746b3-a141-4cd4-a46b-39d41f8e4600	2022-10-13 20:34:50.803095+00	https://youtu.be/elZt57t28ZE	Doves	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Mavi	\N	hallway	{0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
58cc531d-41df-4294-8b01-d9660f7ea3c8	2022-10-16 16:10:53.868821+00	https://youtu.be/v90XPlqdAmY	Flu Game	{"Music Video"}	4	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Reese LaFlare	\N	hallway	{0x52fA05393a003d234eFBA136E68DA835aeB64a26,0x5ab45FB874701d910140e58EA62518566709c408,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
107bbf2f-d3c8-472f-a347-057751a0e3c2	2022-10-17 05:54:03.20396+00	https://open.spotify.com/track/6djAahFEn7cEVeFtFdsnkZ?si=rvWHOwasR_qiTUw62kWTVg	Necessity	\N	0	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Rudeboy Ruger	\N	discoveringEs	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
dc10158f-1ac0-40e7-b773-8e1ee8e823e7	2022-10-17 05:56:16.844297+00	https://open.spotify.com/track/5kgAx66UyTaHgoYJREwgI2?si=rkm8924zQkKznU-M48Vdbw	Jeez Louise	\N	0	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	King Kitty	\N	discoveringEs	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1fe5d718-6b04-43b1-903d-e7a2f7ccf4a2	2022-10-17 05:58:42.411158+00	https://open.spotify.com/track/6aGpM4DXts4pdRhVKbRYuk?si=hKI1CChRQ3KP5jjqpBAspQ	Don't Play With It (ft. Billy B)	\N	0	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Lola Brooke	\N	discoveringEs	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
5d9245f0-b8ba-4a00-8b5d-ff38c35dd616	2022-10-19 16:47:30.037249+00	https://youtu.be/VTcZ-TV_nuU	Back to the Basics (Official Live Performance)	{Live}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Future	\N	hallway	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1a8d3992-00d8-4bfc-a72c-257857877747	2022-10-08 14:45:39.43655+00	https://open.spotify.com/track/6rqjxPBRBBCuEZarxi7beI?si=BXBXwg_BTgqstWuQalaRKQ&context=spotify%3Aartist%3A05PeUup2zYw9VOGnaknbn9	Up 2 U	{🏴‍☠️}	3	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Dreamcastmoe, Will DiMaggio, DJ EAZ	\N	Ghostflow	{0x371107cc397A1fd11FD5A7aC8421a3E43F886444,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
92444ceb-56db-4a07-83f3-5204711f9ac4	2022-10-17 05:04:03.57151+00	https://open.spotify.com/track/1OFQT3lHGbnn3x9jPtagXk?si=94tm72o1T4abMPb68mk0yg	Willing To Trust (with Ty Dolla $ign)	\N	2	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Kid Cudi	\N	discoveringEs	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
26f56f5f-02a2-461a-8f01-85547b14e0c0	2022-10-18 15:40:10.444318+00	https://soundcloud.com/zuksftw/in-the-meantime	In the Meantime	\N	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Zuks	\N	hallway	{0x52fA05393a003d234eFBA136E68DA835aeB64a26}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
1f555f4d-1f14-48d1-bf11-f1bc450c9923	2022-10-19 17:39:24.260654+00	https://soundcloud.com/gripss/cory-n-mel-feat-tate228	Cory-n-Mel	\N	0	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Grip, Tate228	\N	hallway	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
f9fa35be-9a20-4f5b-b1f5-38f7aa8ba210	2022-10-17 06:20:24.541977+00	https://soundcloud.com/austinmarc/tippy-toes?si=7f75a6defe354e6386aa3fd875fef43a&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	tippy toes	\N	3	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	austin marc	\N	discoveringEs	{0xa52b442bfeca885d7de4f74971337f6cf4e86f3b,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xEf58304E292fBAeacFdeC25b67b3438031FdE313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
2d85b183-26a0-4a61-b5f3-5b3cde083ac2	2022-10-19 18:35:48.64625+00	https://youtu.be/-5m_pyNTkqE	Bruddanem/Crack Sandwich	\N	3	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	JID	\N	hallway	{0x371107cc397A1fd11FD5A7aC8421a3E43F886444,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0xf75779719f72f480e57b1ab06a729af2d051b1cd}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0840b20d-b0eb-41ab-950c-154b117c92bb	2022-10-18 02:11:37.237181+00	https://www.youtube.com/watch?v=KSYhGgYPZxU	Vince Carter ft. Smiley	{toronto,canada}	1	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Killy	\N	future modern	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ee216166-5286-48fe-93be-17a3f5da73af	2022-10-18 23:21:14.994072+00	https://open.spotify.com/track/42K7gCdALsYYyaccZzifzU?si=1fe325bbeb6d4663	You Want the Sun	{🏴‍☠️}	1	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Niki & The Dove	\N	Ghostflow	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
12fbd87c-762b-49bd-b0fa-f8d58756c9be	2022-08-26 16:04:22.793197+00	https://youtu.be/gXerx0erltc?list=PLX2IRvQHzAlydFfZbzHZyuh_yw-NSbdhz	Just In Time	{Dreamville,JID,"Forever Story",Weezy,"Lil' Wayne"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	JID, Lil Wayne	\N	hallway	{0xf75779719f72f480e57b1ab06a729af2d051b1cd}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
badcdd0d-4c99-465f-b6c7-042748c3f13a	2022-10-17 06:13:55.977692+00	https://open.spotify.com/track/4pKxSb1G8lArMWLqFCSPUz?si=SiXU7wTMSLmTRF--w91vgg	Live Life (ft. Tems)	\N	1	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Show Dem Camp	\N	discoveringEs	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
9f58f115-bfd4-4faa-bfca-c4088319f63d	2022-10-17 06:11:05.224272+00	https://open.spotify.com/track/0hKlMpG1YsUvUe4TE8qFdB?si=e2WBGUGiS_WSvyKk6aVgqA	Selfish (ft. BEAM)	\N	1	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	RINI	\N	discoveringEs	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
10448504-3589-455a-b842-a62f5fdc4f8d	2022-10-17 06:08:51.651736+00	https://open.spotify.com/track/6gcYBd3WWWhT2tIklhFX9i?si=MdvpVdgiTWKV_6G4y_s3wg	LNSH (Slopped)	\N	1	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Gus Glasser	\N	discoveringEs	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
43740d6a-e349-4d54-9bd2-e5ff5ddc1feb	2022-10-17 05:09:11.337817+00	https://soundcloud.com/jay-dott-cee/the-sequence?si=7f75a6defe354e6386aa3fd875fef43a&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	the sequence	\N	1	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	JayDottCee	\N	discoveringEs	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
824d0e0f-783a-4e3c-aca6-f524bf87785b	2022-10-19 16:55:46.20934+00	https://www.youtube.com/watch?v=sch1Fi2M0Gg	Mutate	{Audio}	4	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Duval Timothy	\N	hallway	{0x52fA05393a003d234eFBA136E68DA835aeB64a26,0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x371107cc397A1fd11FD5A7aC8421a3E43F886444}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
93e094d9-610d-403f-a277-f80ef475d9a2	2022-10-15 19:48:52.348315+00	https://open.spotify.com/track/3bQWyx3JDz53yP2uij16Jj?si=bcb2f4b517134dd0	BUSSIFAME	{🏴‍☠️}	1	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	DAWN RICHARD	\N	Ghostflow	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
0aee8da7-b587-4e91-be69-15567498baf2	2022-10-20 04:35:37.873097+00	https://youtu.be/7x2vthADVZo	Danger	\N	3	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Olivia Dean	\N	discoveringEs	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
819c8e72-a424-404b-9a01-42e1f470af44	2022-10-20 15:12:22.776673+00	https://www.youtube.com/watch?v=xt56GyJu85M	Plasma	\N	1	\N	0xAc801951867c4fE73bEeAe4961A6557FfdC83bfF	\N	DR. GABBA	\N	emez	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
5012426c-c9e1-4e2e-a8f0-7957b2790c0f	2022-10-31 16:02:40.622185+00	https://youtu.be/bgczD79ksCk	Untitled	\N	0	\N	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Mr. Princess	\N	\N	\N	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
05dbdada-7c89-445e-a1a6-46b278da9c17	2022-10-20 19:39:16.258562+00	https://youtu.be/ST2XV0UYu6k	Thowy's Revenge	{"Music Video"}	1	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Benny the Butcher, The Alchemist	\N	hallway	{0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
82766b64-e766-47f9-b1d3-a9dbe3a061c3	2022-10-20 01:37:49.207118+00	https://open.spotify.com/track/4rM0vHNzYyHPnB7AOJkQDN?si=LSCQpYxLTamXfT2idM6Bew&context=spotify%3Aartist%3A01e2RpQnWTK9JymAdAv7KA	Vader 	{Flip,🏴‍☠️}	3	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Reggie Volume 	\N	Ghostflow	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x371107cc397A1fd11FD5A7aC8421a3E43F886444,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
3b6c7269-e755-476a-9282-04659e881ab7	2022-11-28 15:32:46.965676+00	https://youtu.be/rCIJrpcpWdg\\	so be it (SNL Live)	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Black Star	\N	\N	\N	f	0x0DaC0582A10063D8d44bDf193F7257b71a169Ad0	\N
0d1aa136-5766-4de2-918d-8535fda391d3	2022-10-18 03:15:31.052321+00	https://open.spotify.com/track/5ebhZk50qN3ulXS41xSH6r?si=AMLh9HbqTGqR2SNociUPaQ	Harry Brompton’s Ice Tea	{🏴‍☠️}	3	\N	0xEf58304E292fBAeacFdeC25b67b3438031FdE313	\N	Judu Heart 	\N	Ghostflow	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0x52fA05393a003d234eFBA136E68DA835aeB64a26,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
ee7c13d3-c5ff-4093-adf8-0cc69d4d4305	2022-10-20 00:13:39.454953+00	https://soundcloud.com/1981tokyo/rock-wit-u?si=49c869565eb647258637459957881bca&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	Rock Wit U	\N	3	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Ashanti, 1981 Toyko	\N	discoveringEs	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47,0xf75779719f72f480e57b1ab06a729af2d051b1cd}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
39fe178a-6d01-4a0b-93cb-5e41581b266f	2022-10-20 04:42:00.449494+00	https://youtu.be/T0DDfUSZdUQ	POF	\N	3	\N	0x52fA05393a003d234eFBA136E68DA835aeB64a26	\N	Ari Lennox	\N	discoveringEs	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47,0xf75779719f72f480e57b1ab06a729af2d051b1cd}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
50529d52-451c-437f-950a-15ca55b57967	2022-10-20 20:57:08.304531+00	https://www.youtube.com/watch?v=mzpMpj0FHTU	One Up	{uk,drill,obeah,obayi}	3	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Central Cee	\N	future modern	{0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0xef58304e292fbaeacfdec25b67b3438031fde313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
cca4596f-9a6c-43cb-b972-1312a4aac968	2022-10-20 19:36:35.253943+00	https://nnamdi.bandcamp.com/track/touchdown	Touchdown	\N	3	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	Nnamdi	\N	hallway	{0x5ab45FB874701d910140e58EA62518566709c408,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0xef58304e292fbaeacfdec25b67b3438031fde313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
7b29021f-a6f0-43c3-b183-21989add6549	2022-10-20 15:55:15.400595+00	https://youtu.be/-w7Kve9SqUo	Where I Go	{"Music Video","Anderson Paak"}	3	\N	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7	\N	NxWorries, H.E.R.	\N	hallway	{0x371107cc397A1fd11FD5A7aC8421a3E43F886444,0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47,0xef58304e292fbaeacfdec25b67b3438031fde313}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
6e34ec45-ada6-410b-968d-0c3de5957005	2022-12-01 17:03:44.817617+00	https://open.spotify.com/track/4oebzB09U8UoYtNnS6vTjt?si=5c1804003c8141e9	Pudgy 	\N	0	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	Smino, Lil Uzi Vert	\N	\N	\N	f	0x6773EDbB29DCf0Ab2d2aa3367594EeAc5458F3a9	\N
37ce2af3-7b40-4664-8411-e858de35f7ee	2022-12-01 17:20:43.531619+00	https://youtu.be/nCkqzLNE9W8	Next to Me	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Popcaan	\N	\N	\N	f	0xcd88a9bdb02D1e1D982f3D3cf2eDDDF1511d8623	\N
4586d474-4f4c-437a-a7fc-106f6d10da2a	2022-12-06 15:17:47.640467+00	https://youtu.be/dG2RLSoGe44	Anywhere But Home	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	SEULGI	\N	\N	\N	f	0xf718a261AA8B3FdB89639d681428b4F0fC87Bb8c	\N
86c1d6a4-41d6-48c9-8163-61b889d8e11f	2022-12-06 15:21:09.771788+00	https://soundcloud.com/jamesvickery/the-reason-1	The Reason	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	James Vickery	\N	\N	\N	f	0xC135dD2D450893134da436104B95A097BF42bb28	\N
e67f8c7e-bc71-4974-a37e-573acba04e75	2022-12-07 01:32:47.034488+00	https://soundcloud.com/itsesentrik2/sets/her-loss-the-edits?si=d78440bfc1d1435b8180cd03989ca0cd&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	her loss | the edits	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	esentrik²	\N	\N	\N	f	0x72DC6D18Fdf17DeED754C8b58128006Ea7f9169F	\N
22b8bd22-c113-4b8a-a94b-853bcbbf0c5a	2022-12-07 05:30:51.152628+00	https://open.spotify.com/track/0aKXCCuh6cE84wjcVeSFXG?si=1C-SmoVoR-SmIRC37G2W2w	Sip of My Sip	\N	0	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	Cakes da Killa	\N	\N	\N	f	0xe88ea79Aeb0d82C71935b68B7bAd61724F1e61a0	\N
f0b9f796-3761-4833-bcb6-a5c8cf3ef32b	2022-12-07 15:28:21.505615+00	https://open.spotify.com/track/3RCxk1AJv2I6qHTGHaQSDF?si=UdOjJzRpRX-GaQ4MTiFn1w&context=spotify%3Aalbum%3A10t8VXwMKS8cDq2Pc6rQB7	Yamo Yugi Moto	\N	0	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	Khary	\N	\N	\N	f	0x0000000000000000000000000000000000001010	\N
6b76da8e-553d-4671-9091-5516817fcee7	2022-12-09 05:00:39.6019+00	https://open.spotify.com/track/5hw5sIkVm7hAGYmf6UL19g?si=f48e6bdcbedd4b63	Na Boko Samba - Rework	\N	0	\N	0x8d41859049c156e70fa381e07a757d5db2f33e1d	\N	Aroop Roy	\N	\N	\N	f	0x94Fa3B0e8a4487867dc0F23C93b0824e8A2b16bf	\N
9a3e35ba-691d-4353-91bf-013cf3069960	2022-12-11 03:43:28.506658+00	https://www.sound.xyz/msft/alley	Alley	\N	0	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0x371107cc397a1fd11fd5a7ac8421a3e43f886444	\N	MSFT	\N	\N	\N	f	0x0000000000000000000000000000000000001010	\N
7923b440-0b94-4d2e-9a91-c4f44f380f3a	2022-12-11 03:58:53.209072+00	https://www.sound.xyz/mdcl/smoked-something	Smoked Something	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x371107cc397a1fd11fd5a7ac8421a3e43f886444	\N	Mark de Clive-Lowe	\N	\N	\N	f	0x0000000000000000000000000000000000001010	\N
15efb468-8a07-42bb-aaab-585dfcb0f299	2022-12-11 04:19:19.105025+00	https://eth.glass.xyz/v/GyfEupX1nLZlff10E7kuksmJ6EPj2GXDy0u1DC0wLBA=?curator=0x371107cc397A1fd11FD5A7aC8421a3E43F886444	Sound of Fractures	\N	0	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0x371107cc397a1fd11fd5a7ac8421a3e43f886444	\N	Sound of Fractures	\N	\N	\N	f	0x0000000000000000000000000000000000001010	\N
d3185efb-9af5-4601-8588-35bc9e82fc31	2022-12-11 04:56:14.404465+00	https://www.sound.xyz/snoopdogg/death-row-session-vol-2-420-edition	Death Row Session: Vol. 2 (420 Edition)	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x371107cc397a1fd11fd5a7ac8421a3e43f886444	\N	Snoop Dogg	\N	\N	\N	f	0x0000000000000000000000000000000000001010	\N
84b398d2-bcfe-4aa8-a0bc-215daec3eb81	2022-12-14 14:24:48.895473+00	https://youtu.be/ylwm_RgKw-8	Split In Di Middle	\N	0	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0xf47ed857754f690d8219b2f1459fe5f329a83cbc	\N	Freezy	\N	\N	\N	f	0x0000000000000000000000000000000000001010	\N
8a79cc2e-6c79-4864-a512-b60da40264f5	2022-12-14 14:31:02.360877+00	https://youtu.be/Ftr5zRexcqA	Who I am ( I am a Saint Lucian)	\N	0	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0xf47ed857754f690d8219b2f1459fe5f329a83cbc	\N	Arthur Allain	\N	\N	\N	f	0x0000000000000000000000000000000000001010	\N
adffa264-a930-4864-828e-c654e80f703a	2022-12-06 15:47:07.040892+00	https://soundcloud.com/lancey-foux/spirit-of-x2c	Spirit of X2C	\N	1	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Lancey Foux	\N	\N	{0xa52b442bfeca885d7de4f74971337f6cf4e86f3b}	f	0x9d1d3967155677DAa43aBB686C0080A8F59E7979	\N
7443f1ad-d96b-42f1-b13e-52bdb716db28	2022-12-13 15:39:38.250501+00	https://open.spotify.com/track/5cV8Yzck6rgkGXfows7xdS?si=25d582927a804c56	Let Me Love You Down - 2dam Doap Plush	\N	1	\N	0x8d41859049c156e70fa381e07a757d5db2f33e1d	\N	Plush Management Inc.	\N	\N	{0x0bbac2bd3134a318deb31137d87d42bf54325cb7}	f	0xf92c5290Fd6D37e47bf8096b8C1b07e0b5a977CC	\N
4022e064-3132-4a4f-b0fd-dddf45cc7f03	2022-12-07 05:26:07.797131+00	https://open.spotify.com/track/4A33rjRNxA1uG6W8VyVMoR?si=Ekvw8M6LT_aQ_W7c_iJdEA	Everything Is Going To Be Alright	\N	1	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	Barry Can't Swim	\N	\N	{0x0bbac2bd3134a318deb31137d87d42bf54325cb7}	f	0xAe944D5180E800cbF4CB06Ae121E013f02ed8415	\N
7e2feee1-ffc9-4c16-a422-a84513aacf21	2022-12-16 00:38:45.115274+00	https://open.spotify.com/track/2IVxSQz6cVIKARhzGdbzKI?si=uUe8aqOYQuyWa-T-SurSxQ&context=spotify%3Aartist%3A66l6SXrWHLjXFHfv202kdA	Jingle Bells pt 1	\N	0	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	Pastor TL Barett and the Youth for Christ Choir 	\N	\N	\N	f	0x0000000000000000000000000000000000001010	\N
5e24d4cc-99cd-41d2-9629-88166e26cbc0	2022-12-07 01:15:30.682137+00	https://soundcloud.com/1981tokyo/111-1981-tokyo-2022	você se foi	\N	1	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	1981 tokyo	\N	\N	{0xef58304e292fbaeacfdec25b67b3438031fde313}	f	0x2047c75cb75DddBD29AB9313c2ef3a0384dFBef0	\N
5a9d0604-a244-45c8-be78-deb5cdbe5c7f	2022-12-10 11:21:21.063467+00	https://open.spotify.com/track/6owrHlxTXgxPI9vZjkCmIA?si=b3d562193e9549ab	Yer Luv	\N	2	\N	0x8d41859049c156e70fa381e07a757d5db2f33e1d	\N	Not Enough Soul	\N	\N	{0xef58304e292fbaeacfdec25b67b3438031fde313,0x0bbac2bd3134a318deb31137d87d42bf54325cb7}	f	0x6f3Eb3bcD26d0ADc809FC99F6075C59ff922451E	\N
5113e7fd-3aef-4585-9d3d-bf0bf6a7a16e	2022-12-19 16:53:20.946112+00	https://youtu.be/i7ndkJl_Tao	Live Life	\N	0	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0xf47ed857754f690d8219b2f1459fe5f329a83cbc	\N	Ricky T	\N	\N	\N	f	0x0000000000000000000000000000000000001010	\N
9ba90778-625f-46d8-8e91-0200ca30a358	2022-12-19 16:59:39.915511+00	https://youtu.be/-WgD6lA3wFk	Eat Man Money	\N	0	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0xf47ed857754f690d8219b2f1459fe5f329a83cbc	\N	4-1 Band	\N	\N	\N	f	0x0000000000000000000000000000000000001010	\N
48b61461-26ff-4be6-aa46-834f7f0ec90b	2022-12-19 17:58:06.01219+00	https://youtu.be/UWZo6VzPQUM	Buck the System	\N	1	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Duke Deuce, ATM Richbaby	\N	\N	{0xef58304e292fbaeacfdec25b67b3438031fde313}	f	0x50F8a9532d74fE2FB30f18645BD2B0d4CCEDC168	\N
2645b181-d063-4510-a399-3e1f38d1ac4d	2022-12-19 21:48:29.770329+00	https://www.youtube.com/watch?v=GtUVQei3nX4	Drop It Like Its Hot	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Snoop Dogg, Pharrell	\N	\N	\N	f	0xD2e47b194a79a583eC7545A4B4AF416e3De5B1a9	\N
0b1de8fe-18bf-4468-84ed-8e6a7e63d5ee	2022-12-16 01:21:21.518558+00	https://soundcloud.com/1981tokyo/chillvember-vi-mix?ref=clipboard&p=i&c=1&si=58D06D841A20433DB774573C561EE7FB&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	CHILLVEMBER VI	\N	1	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	1981 Tokyo 	\N	\N	{0x0bbac2bd3134a318deb31137d87d42bf54325cb7}	f	0xA98ec2EAfe50dB9060B9EA12197b78B9223e960B	\N
758ae0c1-f24f-4753-880f-2dae4bb24a4d	2022-12-20 18:41:06.638617+00	https://youtu.be/ln_gYFBtCu8	TYLER DURDEN	\N	0	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Jxylen	\N	\N	\N	f	0x99267743fF445552386Ff59450916e9DF0cAf1eC	\N
d3e1b01b-52f7-4c4a-86f5-bfe77aa96afc	2022-12-20 18:43:22.571102+00	https://www.youtube.com/watch?v=ln_gYFBtCu8	TYLER DURDEN	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Jxylen	\N	\N	\N	f	0xA2cFaC033d6F14fCC4cB802fD4f442182ddB60b1	\N
b1215ebf-0bf0-459a-a2f8-3baa708acb98	2022-12-20 18:46:37.148956+00	https://youtu.be/ln_gYFBtCu8	TYLER DURDEN	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Jxylen	\N	\N	\N	f	0xaa279D4a88B83c408326035B41CA6629DDf2C94f	\N
4cf4720f-f294-4a00-bbae-a88e877fcb4c	2022-12-20 19:21:35.84779+00	https://youtu.be/5T4q06XDjlI	Broken	\N	1	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Little Simz	\N	\N	{0x371107cc397a1fd11fd5a7ac8421a3e43f886444}	f	0xFfad4595d1709F98A6314803F8084DE2d26305F6	\N
b4c0ea1a-f29f-47ce-8cca-ee8e7c263268	2022-12-20 18:36:02.878792+00	https://youtu.be/TXc6X0OzXaY	Who Even Cares	\N	1	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Little Simz	\N	\N	{0x371107cc397a1fd11fd5a7ac8421a3e43f886444}	f	0xd36a306a85e282d88545a02e6F9d0cab29aB6d65	\N
b4f83ba8-46f3-4486-9da3-6eb2eb46a5a6	2022-12-20 19:45:07.675418+00	https://www.sound.xyz/bloodywhite/toni-with-deegan	toni (with Deegan)	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x371107cc397a1fd11fd5a7ac8421a3e43f886444	\N	Bloody White	\N	\N	\N	f	0x2b2fC5138f63D91c62DA0CF128355450DBc3Ca0B	\N
d8260536-d0fc-4118-9d17-317972b6810d	2022-12-20 19:36:43.287635+00	https://www.sound.xyz/zionkuwonu/turtles-ft-malak-watson	Turtles ft. Malak Watson	\N	1	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0x371107cc397a1fd11fd5a7ac8421a3e43f886444	\N	Zion Kuwonu	\N	\N	{0x0bbac2bd3134a318deb31137d87d42bf54325cb7}	f	0x5F1d5ca0Ec7fb147cb7e7e5c717eC27b15B562F6	\N
859ce8cb-9258-4ee2-80f9-6cd0b737f56a	2022-12-20 20:18:53.885792+00	https://cuneiformrecords.bandcamp.com/track/woven-forest-she-had-synesthesia-2	Janel Lepin	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	 Woven Forest - She Had Synesthesia	\N	\N	\N	f	0x8d569d1A6dFAF6fd5fC0502679562fDAF826DC1c	\N
b76adc22-a075-42cc-985b-ba601b297fcb	2022-12-20 18:28:12.678423+00	https://soundcloud.com/justicexavier/manonthemoon	MAN ON THE MOON	\N	1	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	justicexavier	\N	\N	{0xef58304e292fbaeacfdec25b67b3438031fde313}	f	0x7197dcBD836A3e2C7D0198386feda8f0A189386e	\N
1b4eff6d-f8d5-4acb-bad9-d3f150fec474	2022-12-20 22:48:50.480789+00	https://www.sound.xyz/milesryanharris/be-here-long	Be Here Long	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x371107cc397a1fd11fd5a7ac8421a3e43f886444	\N	MILES RYAN HARRIS	\N	\N	\N	f	0xaEA5349DA94a560B18186665b73375338a52a75A	\N
8fc940de-4f74-4f59-8535-b395974b32e2	2022-12-21 14:17:21.312665+00	https://open.spotify.com/track/2mzM4Y0Rnx2BDZqRnhQ5Q6?si=07fc8fbbccac4a24	Free Mind	\N	1	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	Tems	\N	\N	{0x0bbac2bd3134a318deb31137d87d42bf54325cb7}	f	0x3D9f376461DC2adf39E45729cF75750ab7D36481	\N
74461aba-55e9-43fc-8a92-fa0d501b483b	2022-12-20 20:13:57.541015+00	https://maryhalvorson.bandcamp.com/album/amaryllis	Amaryllis	\N	1	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Mary Halvorson	\N	\N	{0xef58304e292fbaeacfdec25b67b3438031fde313}	f	0xc1321E2138004C617C14b2faA600F9F4C11B4310	\N
11cde931-1962-4e7d-830e-ce3555136551	2022-12-20 18:33:42.250233+00	https://youtu.be/jdah4KgE_Dc	The Art of Being Happy	\N	1	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Lucas	\N	\N	{0xef58304e292fbaeacfdec25b67b3438031fde313}	f	0x93f213E1AdD25E61F7fCa4393a3D1E47a405cF8A	\N
5a52a4f1-2c16-42f5-a3c3-4f1db161150f	2022-12-22 21:30:40.00718+00	https://www.youtube.com/watch?v=7icGNCSMa5U	Peppas	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Westside Gunn	\N	\N	\N	f	0x89cD311397883B566CC48cad638fD566E771e91C	\N
2fc21e9c-6877-4f1c-9ade-c114490e1656	2022-12-22 21:38:35.108775+00	https://youtu.be/87Z2Kds4KPo	Quantum Leap	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Roc Marciano	\N	\N	\N	f	0x10b043aeDc72e2B6d9624516850EBb864e202eAc	\N
36d948ca-18d2-4392-ab11-2da145743e85	2022-12-24 01:47:32.72994+00	https://www.youtube.com/watch?v=bWebqCRw7o4	Chill Out Album	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	KLF 	\N	\N	\N	f	0xc4EDFFbD1ba77d5f0CBACB234356A46c22bF6f54	\N
d2c9f96c-9b07-4aa5-96a3-d99408ad87b5	2022-12-24 01:51:56.780291+00	https://open.spotify.com/track/3Vpn6xh4JmtryjRp80Krqh?si=559a717871914453	Eternal September	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	Avalon Emerson, Anunaku, A+A	\N	\N	\N	f	0xBD73b0a1C7Ab965Bb69c3D3ac6b96e10Ffc1fc59	\N
ae207225-ce52-407f-ae81-b5410b132f8e	2022-12-27 21:59:12.458648+00	https://www.ninaprotocol.com/Dc4UD9n3HXoUNX7XzWM5VfwtpZzUjXDjKDmrXQcrYQh	Polysurfer	\N	0	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0x371107cc397a1fd11fd5a7ac8421a3e43f886444	\N	Caprithy	\N	\N	\N	f	0x7da678F9132C55ECc7bBe43e2DBbfd5728a65F69	\N
62eb9fcb-7750-4c04-9f31-6b594fc2209b	2022-12-22 21:52:27.512981+00	https://open.spotify.com/track/2Lam81DfTSjkSpMmWlRmIr?si=7721ac7d5d6949b2	The World Is Always Ending	\N	2	\N	0x8d41859049c156e70fa381e07a757d5db2f33e1d	\N	Nala, Nikki, Nair	\N	\N	{0xef58304e292fbaeacfdec25b67b3438031fde313,0x371107cc397a1fd11fd5a7ac8421a3e43f886444}	f	0xDB4F9AA2Ba9b79Ff78fa902701aC02E43524eBac	\N
71d05ff5-8092-4018-908d-7c87cf24a629	2022-12-27 23:49:58.086442+00	https://www.sound.xyz/milesryanharris/forbidden-fruit	Forbidden Fruit	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x371107cc397a1fd11fd5a7ac8421a3e43f886444	\N	Miles Ryan Harris	\N	\N	\N	f	0x127Dd260100AABA3e04362EcBE099F6BB4a4F802	\N
0b69e2eb-2253-44f9-b817-228028a39bbc	2022-12-29 17:10:56.619813+00	https://open.spotify.com/track/4WOQ4mmDh2fNBMh2K2Bw6c?si=faee90ccdbf64b01	Make Up Ya Mind	\N	1	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	dreamcastmoe	\N	\N	{0x0bbac2bd3134a318deb31137d87d42bf54325cb7}	f	0x822460F306b66a1D6c0BC71163d6E26633c43839	\N
3ae57ef0-8d7c-472d-8997-77bf2e5e2c41	2022-12-29 17:41:08.988231+00	https://soundcloud.com/aylu/silent-dub?si=2775f198d9e34b9195892cc346d2782c&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing	Silent Dub	\N	1	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	Aylu	\N	\N	{0xb60d2e146903852a94271b9a71cf45aa94277eb5}	f	0x44ec37BBD61258Fc70515ec946ba5541aC0b8F3d	\N
3bbcbacd-f119-4540-b02f-b297b5e825d6	2022-12-29 17:27:26.653014+00	https://open.spotify.com/track/14UEvrPgy16q1kLClxnPDG?si=6c54a637e1dd4360	Happy Birtday	\N	2	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	Grupo Celebracion	\N	\N	{0xa52b442bfeca885d7de4f74971337f6cf4e86f3b,0xb60d2e146903852a94271b9a71cf45aa94277eb5}	f	0x1CA3E708E161723242960Db2AFD70837e02C1596	\N
a18ac0ea-35d0-472c-ae22-4d6db178f963	2023-01-09 21:12:05.103507+00	https://www.youtube.com/watch?v=taAW6z4Ean8	test	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0xa52b442bfeca885d7de4f74971337f6cf4e86f3b	\N	test	\N	\N	\N	f	0x223D73D6E87d00C280CA0972d3aDF2a144fd1450	\N
e8e1c4d1-dadf-47f5-bc76-73e139234e68	2023-01-09 22:13:42.217033+00	https://www.youtube.com/watch?v=taAW6z4Ean8	2123123	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0xa52b442bfeca885d7de4f74971337f6cf4e86f3b	\N	test1	\N	\N	\N	f	0x6f4Cf33ad5dcD82AF8Cb4aAeF1a85891C7369a86	\N
f4456606-22b1-4030-ad76-7c1abba2b1b1	2022-12-29 18:15:52.913887+00	https://www.youtube.com/watch?v=rUxyKA_-grg	test	\N	2	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0xfd72023562f26ff319b3dbae57b565dfcc16393a	\N	test	\N	\N	{0x0bbac2bd3134a318deb31137d87d42bf54325cb7,0x56cef7b74cc7121bb88c6d9b469819b5d32c9b22}	f	0x43d2497Ff33F2d242C5C11ACa6246f73390fF9fa	\N
ecf47b5f-f4a8-4799-8f73-75f24ed531ae	2022-12-29 18:45:06.690291+00	https://www.youtube.com/watch?v=rcUxyKA_-grg	zcxx	\N	5	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0xfd72023562f26ff319b3dbae57b565dfcc16393a	\N	czxz	\N	\N	{0x0bbac2bd3134a318deb31137d87d42bf54325cb7,0xb60d2e146903852a94271b9a71cf45aa94277eb5,0xa52b442bfeca885d7de4f74971337f6cf4e86f3b,0x56cef7b74cc7121bb88c6d9b469819b5d32c9b22,0xb9b0511011ec8a7e4a3a6e6822a3c84eb71b81f0}	f	0xEEc68D4ec5e1F4621e8C266206F491E0b134c1D1	\N
83d68087-9d23-4945-bfae-6a10153d662c	2023-01-09 23:34:57.634267+00	https://www.youtube.com/watch?v=rUffxyKA_-grg	test	\N	1	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x71947e53f4d4d4f1eef64dd360ef60a725e5373c	\N	test	\N	\N	{0xb60d2e146903852a94271b9a71cf45aa94277eb5}	f	0xaf7370F29bca5197e2fbf29a9557044f6C5eBdBC	\N
6813c8e5-59f1-4c60-962f-dc81eac97283	2023-01-09 23:36:06.617554+00	https://www.youtube.com/test	HTest	\N	1	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x71947e53f4d4d4f1eef64dd360ef60a725e5373c	\N	HTest	\N	\N	{0x0bbac2bd3134a318deb31137d87d42bf54325cb7}	f	0x8030b76f4d7dC487FBC10C694cABD3AF28B0B797	\N
55312af7-af22-490e-8355-7c53c5a34241	2023-01-23 16:07:29.143355+00	https://youtu.be/sUSyeybnjcg	Cuff It / Wetter Remix	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	BLXST	\N	\N	\N	f	0xe8C3817356163d5AAfeFce94884D8A38Dc1CC725	\N
9ea60a32-e08b-4edc-b5eb-cc5918064c74	2023-01-11 14:10:21.871821+00	https://opensea.io/assets/ethereum/0x75eeab04cbeefc40ade03d154a48aa80c7c1c57b/6	The Red Vineyard	\N	2	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x40c423d16d1a9b90535cad9d54ba4a2766d066da	\N	Kane Mayfield	\N	\N	{0x0bbac2bd3134a318deb31137d87d42bf54325cb7,0x56cef7b74cc7121bb88c6d9b469819b5d32c9b22}	f	0x856Ce27187bfCcee9cF0630D009562664425De9a	\N
e3e09b86-a09f-4395-bd20-c4c9a911506a	2023-01-10 02:48:17.360293+00	https://youtu.be/UrMASjP5te4	Super Kick Party	\N	1	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Westside Gunn	\N	\N	{0x56cef7b74cc7121bb88c6d9b469819b5d32c9b22}	f	0xCD366B117bE09025be9E1d4973F7413Bf97eAaCA	\N
f7202da8-44c4-4392-944b-a0125966caaa	2023-01-23 16:10:10.766171+00	https://youtu.be/0nCLnfKqnJg	Goated	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Armani White, Denzel Curry	\N	\N	\N	f	0xd43b5bD452392b81a8C8aC39fbC7e0318e2c6ACF	\N
de58ee30-d9ea-47f5-bb7d-620fc1d6016e	2023-01-24 01:21:35.551263+00	https://open.spotify.com/track/1irS4vMWGfb0Qv0xJ1vAuP?si=79a194e8b5384f35	Like This N Like That	\N	0	\N	0x8d41859049c156e70fa381e07a757d5db2f33e1d	\N	Quavius	\N	\N	\N	f	0x9812B9d411928F1796ed2C2de20bC90c8e1FeC10	\N
350da340-bc10-4002-9a8a-e6fcca1f7eec	2023-01-17 01:41:47.358593+00	https://www.sound.xyz/daveb/so-many-ways-prod-da-p	So Many Ways (Prod. Da-P)	\N	1	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0x371107cc397a1fd11fd5a7ac8421a3e43f886444	\N	Dave B	\N	\N	{0x0bbac2bd3134a318deb31137d87d42bf54325cb7}	f	0x342B1D2343eF188BD145e554933B40edc70E5534	\N
5cc238f3-a4db-4db3-aec5-7529b949be1a	2023-01-12 16:49:17.430736+00	https://open.spotify.com/track/25N44BStT31TgGY3YfSoph?si=bd3ac9893d7b4a96	gleam	\N	4	\N	0x8d41859049c156e70fa381e07a757d5db2f33e1d	\N	Amal	\N	\N	{0xb60d2e146903852a94271b9a71cf45aa94277eb5,0x56cef7b74cc7121bb88c6d9b469819b5d32c9b22,0x883a368a32e8763427aa86ffa85ed9f24d654085,0x0bbac2bd3134a318deb31137d87d42bf54325cb7}	f	0xC8A17c2206703b13536FBf030abB27048Fe02647	\N
c259681f-3103-4259-b89c-ecc7d4076473	2023-01-24 01:25:46.339096+00	https://open.spotify.com/track/2rBGMpYRuhMYZC9adf3Xwb?si=c31c246b71a44293	¡Your Turn!	\N	0	\N	0x8d41859049c156e70fa381e07a757d5db2f33e1d	\N	Randy Ego	\N	\N	\N	f	0x373cced6F561805a039280e63AB7b046A3C5f40D	\N
5db785aa-1886-4760-9daa-6214ab356a90	2023-01-24 01:30:07.698586+00	https://open.spotify.com/track/1C7RTmtfwbxQUIKDDd5Y7a?si=5fc8d95f5c1b40fd	She's Just the Type of Girl	\N	0	\N	0x8d41859049c156e70fa381e07a757d5db2f33e1d	\N	Circuitry	\N	\N	\N	f	0x5Ca6D0447553f052584071e91Dac66B8328DEA3C	\N
d3d5984a-c414-46a6-a148-a6bf8d8acbff	2023-01-24 01:27:45.70336+00	https://open.spotify.com/track/4DDeC0YCtDKXgmTygJmb07?si=aad9b19b3e0b4a81	¡Vivian's Hex!	\N	1	\N	0x8d41859049c156e70fa381e07a757d5db2f33e1d	\N	Randy Ego	\N	\N	{0xef58304e292fbaeacfdec25b67b3438031fde313}	f	0x3Cdc0d34CeE8f0F02fea39915555Cc8D8A54f11F	\N
33138513-b7c6-4504-83c0-747147f6e98e	2023-01-24 01:23:57.848972+00	https://open.spotify.com/track/1irS4vMWGfb0Qv0xJ1vAuP?si=79a194e8b5384f35	What I Gotta Do	\N	1	\N	0x8d41859049c156e70fa381e07a757d5db2f33e1d	\N	Jelani Kwesi	\N	\N	{0xef58304e292fbaeacfdec25b67b3438031fde313}	f	0xFdE62eE400EA404817FB40c8D1A6b18d2587D1EA	\N
9ca0a884-f422-4b89-bf27-b46ec39839f5	2023-01-24 19:20:27.340115+00	https://open.spotify.com/track/1SQUpaFHUAG42eIawsuSlj?si=6eMG4HShReu1KpWNOy4N9g	Leo	\N	0	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0xd02257d9354b8d3858a6a722df920a36b38d7ef8	\N	Dreamcastmoe	\N	\N	\N	f	0x0000000000000000000000000000000000001010	\N
787383ca-a9c5-46ca-a8dd-4ba6973b3a92	2023-01-26 14:43:48.281475+00	https://open.spotify.com/album/0h7WAAvFPveqgL5Ftjfqig?si=WgG5sx3HQQSdUE_rBVEf1A	The Good Book, Vol 2. 	\N	1	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0xef58304e292fbaeacfdec25b67b3438031fde313	\N	The Alchemist, Budgie	\N	\N	{0xb60d2e146903852a94271b9a71cf45aa94277eb5}	f	0x0a48722A6bd9Fbe939176F59B0b9E259b9e37833	\N
9f731272-4977-426c-9d59-89008504f82c	2023-01-31 14:29:46.73555+00	https://youtu.be/DRke6LIgiGM	BDP	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Westside Gunn	\N	\N	\N	f	0x5b422e19f12E63A8d3cD57B2A7A15b60B408a5d0	\N
181f10ee-2e8c-4f50-9555-a2fa5bf439f2	2023-01-24 01:35:17.154665+00	https://open.spotify.com/track/1dd4XqqJ0BRtpr2uZhzHdC?si=a915a2cafbf149f3	Under Pressure	\N	2	\N	0x8d41859049c156e70fa381e07a757d5db2f33e1d	\N	Circuitry	\N	\N	{0xef58304e292fbaeacfdec25b67b3438031fde313,0x0bbac2bd3134a318deb31137d87d42bf54325cb7}	f	0xcE2381cF6AeB646f93E021091A8C1A380895c24F	\N
9a9c4dc1-14df-4467-bb23-2e15fd1d67cf	2023-01-31 14:34:28.825091+00	https://youtu.be/mrAwwXz_44M	Blicky Bop	\N	0	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Fly Anakin	\N	\N	\N	f	0xd8A981B605A1DBfE4e91112Cf871f50Cbe8d5A05	\N
82e5eee7-9399-4010-9aa0-50b9ed316363	2023-01-31 15:52:12.63314+00	https://youtu.be/4bZeLOvGBgY	Two Tens	\N	1	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	Cordae, Anderson Paak	\N	\N	{0xb60d2e146903852a94271b9a71cf45aa94277eb5}	f	0x95dce286c01047049f6FcEc6083A6Cd26F561a98	\N
97b00ad1-7c6c-4c3c-8fca-8fabffa26a3b	2023-01-31 15:35:19.957298+00	https://youtu.be/6YX2QMCVZD8	Grateful	\N	1	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	El Michels Affair, Black Thought	\N	\N	{0xb60d2e146903852a94271b9a71cf45aa94277eb5}	f	0x6C69913c22d3709B51104D9e426a4065443550D9	\N
4d9bbfea-45cf-40be-9f66-ac612e301e28	2022-08-22 21:02:51.760675+00	https://www.youtube.com/watch?v=yF-NC3eRsqc	Munch	{bronx}	4	\N	0x5ab45FB874701d910140e58EA62518566709c408	\N	Ice Spice	\N	future modern	{0xEf58304E292fBAeacFdeC25b67b3438031FdE313,0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7,0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47,0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01}	f	0xb3727e8fa83e7a913a8c13bad9c2b70f83279782	\N
37147662-5ea1-48f8-bfb5-fcbc3d6bcdab	2023-01-23 16:02:24.29706+00	https://soundcloud.com/twatwave/sets/g4ost-2	Ghost 2	\N	1	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	ICYTWAT	\N	\N	{0xb60d2e146903852a94271b9a71cf45aa94277eb5}	f	0x86837432D595a5c5BcC1F67c8ad31a650D6d6170	\N
8b9451e2-135e-45ea-aada-8015df621296	2023-02-03 01:12:21.184458+00	https://www.sound.xyz/daktyl/instinct-pt-1	Instinct	\N	3	{ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc}	0x371107cc397a1fd11fd5a7ac8421a3e43f886444	\N	Daktyl	\N	\N	{0x0bbac2bd3134a318deb31137d87d42bf54325cb7,0xc68fdd7fedf3e45efbc97096bdbaeea92540b3a4,0xb60d2e146903852a94271b9a71cf45aa94277eb5}	f	0x27b206CC302C0e500AC967956021f2C1A70Bc9aa	\N
8acb4375-61df-4605-890b-ebed5b0b5e78	2023-02-15 17:28:19.429383+00	https://youtu.be/X6k7-LcTnfo	Wassup	\N	1	{c36e16db-38af-4f97-a308-a4b6534f7bf2}	0x0bbac2bd3134a318deb31137d87d42bf54325cb7	\N	B. Cool-Aid	\N	\N	{0xef58304e292fbaeacfdec25b67b3438031fde313}	f	0xc6bd982C81fED22bd71BA610E07171859bee4058	\N
\.


--
-- Data for Name: Marketplace_Items_Table; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

COPY public."Marketplace_Items_Table" ("itemID", "itemAddress", "itemLink", "itemName", "itemCreatedAt") FROM stdin;
\.


--
-- Data for Name: Playlists_Table; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

COPY public."Playlists_Table" ("playlistID", "createdAt", "followerCount", "playlistLink", genres, "playlistName", "submissionIDs") FROM stdin;
c36e16db-38af-4f97-a308-a4b6534f7bf2	2022-11-09 22:15:14.526431+00	\N	\N	\N	Secret Radio	\N
ba3c44dd-6bb9-42e1-af65-1bcc1d8a39cc	2022-11-09 22:53:07.967932+00	\N	\N	\N	Most Wanted	\N
\.


--
-- Data for Name: Users_Table; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

COPY public."Users_Table" ("createdAt", "curatorSubmissionIDs", "artistSubmissionIDs", username, city, twitter, "profilePic", "updateTime", email, wallet) FROM stdin;
2022-03-25 17:49:40.515945+00	\N	\N	JamesGardin	Lansing	twitter.com/jamesgardin_	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x198F7e5f79B6efe3D67591ee62b527e99a6F2F38/profile	\N	\N	0x198f7e5f79b6efe3d67591ee62b527e99a6f2f38
2022-03-25 23:18:10.223791+00	\N	\N	Yanti	London	https://twitter.com/vabyanti	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xAF1B99F0B6bBB348D0E09bf35776E587a1977226/profile	\N	\N	0xaf1b99f0b6bbb348d0e09bf35776e587a1977226
2022-04-19 23:21:05.320734+00	\N	\N	OrcaMane	Fontana	twitter.com/noajames	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x42ACfC0Da38899168Dd4F9A66a5c8228cbbeFEB1/profile	\N	\N	0x42acfc0da38899168dd4f9a66a5c8228cbbefeb1
2022-04-20 15:56:18.564031+00	\N	\N	CONFUSIONisDEAD	New York	https://twitter.com/CONFUSIONisDEAD	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x18B4B34F5F2eF62b7F33830d358B656D87a93D31/profile	\N	\N	0x18b4b34f5f2ef62b7f33830d358b656d87a93d31
2022-03-26 04:46:29.70114+00	\N	\N	JamesGardin_	Lansing	Jamesgardin_	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x19a4fc15c43242FCE096eaA92f99A6ddBD6a97CD/profile	\N	\N	0x19a4fc15c43242fce096eaa92f99a6ddbd6a97cd
2022-03-27 19:51:11.938137+00	\N	\N	afkMAXXX	Los Angeles	afkMAXXX	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x65FAc90a3479D9D8591c819BCa40085457BF8F25/profile	\N	\N	0x65fac90a3479d9d8591c819bca40085457bf8f25
2022-03-28 12:19:48.392364+00	\N	\N	Xcelencia	Orlando	Xcelencia	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x089036a0835C6cF82e7fC42e9e95DfE05e110c81/profile	\N	\N	0x089036a0835c6cf82e7fc42e9e95dfe05e110c81
2022-03-28 14:59:06.092676+00	\N	\N	Luca Maxim	World	https://mobile.twitter.com/lucamaxiim	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x83859Ad182b99Cd1f755c1E746D3df8380363d65/profile	\N	\N	0x83859ad182b99cd1f755c1e746d3df8380363d65
2022-03-28 15:15:22.352568+00	\N	\N	TETRA	BRONX	@TETRAGOCOMMANDO	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xFea1F357b453C9CD89b893B07baA6AbfE8536CA2/profile	\N	\N	0xfea1f357b453c9cd89b893b07baa6abfe8536ca2
2022-03-28 22:20:06.040817+00	\N	\N	SeanyGee	Sydney	seanogardner	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x4Ce96AaCBf4a605084d757141bE016De8431b285/profile	\N	\N	0x4ce96aacbf4a605084d757141be016de8431b285
2022-03-30 09:37:44.125731+00	\N	\N	Deadwalker	Metaverse	https://twitter.com/walkerrockets	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xEEb6Faae3094b31859f6B7b34a183Ae212e43cfb/profile	\N	\N	0xeeb6faae3094b31859f6b7b34a183ae212e43cfb
2022-03-11 20:24:11.12133+00	\N	\N	UncleMikey3.0	Lisboa, Portugal	anderjaska	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x1ce9200E1547F8bfb3EFa961FF0b8F88356Ccae2/profile	\N	\N	0x1ce9200e1547f8bfb3efa961ff0b8f88356ccae2
2022-03-30 16:43:17.417875+00	\N	\N	joshkarbon	Baltimore	joshkarbon	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x554Ff22048E90DbdB82dfAaF724BD01641D71AFe/profile	\N	\N	0x554ff22048e90dbdb82dfaaf724bd01641d71afe
2022-03-30 20:27:56.651053+00	\N	\N	Asha DaHomey	\N	@isThatAsha	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x97e5A788351ad8649B77d282F0D6e08a47813AfC/profile	\N	\N	0x97e5a788351ad8649b77d282f0d6e08a47813afc
2022-03-24 20:28:01.156517+00	\N	\N	ODENZ	Greater Houston	@ODENZTV	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x67A276b6768978C9E41Af5418E09Efc8a12a28dE/profile	\N	\N	0x67a276b6768978c9e41af5418e09efc8a12a28de
2022-04-07 04:16:28.000991+00	\N	\N	singnasty	DC	@singnasty	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74/profile	\N	\N	0x3ddea6385b7d0b75a6dae639bc39cb315fcc0f74
2022-04-19 02:11:02.418611+00	\N	\N	lifeofclaude	Bronx	@10k80minutes	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01/profile	\N	\N	0x1e19fb57c419fc45cb771e91ae00925c2db8fd01
2022-04-17 02:15:35.069766+00	\N	\N	SIDNE	San Diego	sidnexiv	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x85AAffc1F91cD828C82D5d0006B38C34b05917e9/profile	\N	\N	0x85aaffc1f91cd828c82d5d0006b38c34b05917e9
2022-04-12 19:24:39.573174+00	\N	\N	Lil Josh	Federalsburg, MD	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47/profile	2022-08-23 15:07:27.457+00	\N	0xc4fe904b8e2d7a0a9e1de8ebb07ecc908c27de47
2022-04-18 00:52:40.615512+00	\N	\N	Verbs	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x8Ef4E20a765dF2c6d0AC077C7C9E175fed1ADaaC/profile	\N	\N	0x8ef4e20a765df2c6d0ac077c7c9e175fed1adaac
2022-04-14 18:25:39.615018+00	\N	\N	GrowExpand	illadelph	@GrowExpand	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x2be31e1066D6ad8C525A4f762d10117C753b35A3/profile	\N	\N	0x2be31e1066d6ad8c525a4f762d10117c753b35a3
2022-03-15 14:12:41.012697+00	\N	\N	Ghostflow	D.C.	@teamphlote	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xEf58304E292fBAeacFdeC25b67b3438031FdE313/profile	2022-07-25 20:22:24.63+00	aj@phlote.co	0xef58304e292fbaeacfdec25b67b3438031fde313
2022-03-14 19:44:00.043839+00	\N	\N	hallway	Federalsburg	https://twitter.com/hallwayfinds	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7/profile	2022-08-16 18:06:13.378+00	hallway@phlote.co	0x0bbac2bd3134a318deb31137d87d42bf54325cb7
2022-04-16 16:39:47.574031+00	\N	\N	Jelly	The Internet 	@jellyjeezus	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xb53B1DF71705aa51efe96FaB14c6B11763c9768F/profile	\N	\N	0xb53b1df71705aa51efe96fab14c6b11763c9768f
2022-03-14 18:08:40.041177+00	\N	\N	zfogg	Washington, DC	zfogg	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x276Adf94808668338ff61df00d63c2F8ce056206/profile	\N	\N	0x276adf94808668338ff61df00d63c2f8ce056206
2022-03-22 23:14:15.242726+00	\N	\N	almndbtr	Los Angeles	almndbtr	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x85fc6505df723C427D5bBc1b32D7e1EC66c1a55e/profile	\N	\N	0x85fc6505df723c427d5bbc1b32d7e1ec66c1a55e
2022-03-23 16:46:56.590893+00	\N	\N	chadhillydilly	Vancouver	@chadhillydilly	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xdFBB06683a882E827907422dbFE836E5430fE2aC/profile	\N	\N	0xdfbb06683a882e827907422dbfe836e5430fe2ac
2022-03-25 17:33:35.838106+00	\N	\N	joey	Chicago	@joeyburbach	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x604e88bf430847B62391FBb717cB6F18A683B00b/profile	\N	\N	0x604e88bf430847b62391fbb717cb6f18a683b00b
2022-06-10 15:26:57.487543+00	\N	\N	chidi.mishael	Lagos	@chidimishael	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	okoronkwochidi10@gmail.com	0xa9a94e4718c045ccdf94266403af4add53a2fd15
2022-04-09 20:47:54.488678+00	\N	\N	singnastydos	DC	@singnasty	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	\N	0xb077473009e7e013b0fa68af63e96773e0a5d6a4
2022-04-28 23:31:47.538946+00	\N	\N	Mighty33	Paris	mighty_33	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	\N	0x8c62dd796e13ad389ad0bfda44bb231d317ef6c6
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x2ad084d80b7034e31c8025fdbc8c32fa756eb4ba
2022-05-14 03:30:47.184715+00	\N	\N	Glassface	Los Angeles	@glassface_	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xc2469e9D964F25c58755380727a1C98782a219ac/profile	2022-05-14 03:30:41.377+00	\N	0xc2469e9d964f25c58755380727a1c98782a219ac
2022-05-06 17:13:46.822584+00	\N	\N	emez	Washington, DC		https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xAc801951867c4fE73bEeAe4961A6557FfdC83bfF/profile	2022-05-06 17:13:46.226+00	erinwashington50@gmail.com	0xac801951867c4fe73beeae4961a6557ffdc83bff
2022-05-02 19:34:05.911961+00	\N	\N	Sirjwheeler	Los Angeles	@sirjwheeler	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x00daEbab128f5CFc805D75324c20c6fEaf6B26b2/profile	2022-05-02 19:34:00.988+00	\N	0x00daebab128f5cfc805d75324c20c6feaf6b26b2
2022-05-04 19:46:15.561191+00	\N	\N	Anderjaska2.1	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	\N	0x7d1f0b6556f19132e545717c6422e8ab004a5b7c
2022-05-05 20:40:04.558182+00	\N	\N	\N	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x9921B926788E91Aa9db885c214Db5FEe8943b771/profile	2022-05-05 20:40:01.751+00	\N	0x9921b926788e91aa9db885c214db5fee8943b771
2022-04-30 13:50:59.345435+00	\N	\N	Trish	Los Angeles	@nft_ish	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x5f8b9B4541Ecef965424f1dB923806aAD626Add2/profile	2022-04-30 13:50:57.916+00	trish@boop.art	0x5f8b9b4541ecef965424f1db923806aad626add2
2022-06-02 10:01:12.99411+00	\N	\N	harishm	London	@harish_malhi	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	\N	0xacef50638be46adcd6f5c7dfd9bf5894266794fc
2022-07-08 22:30:08.029787+00	\N	\N	mikemelinoe	Detroit, MI	@MikeMelinoe	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xcE012cA872B9856d006ea51500D56fD7F2f01b38/profile	2022-07-08 22:30:06.303+00	mgmt@goldaintcheap.com	0xce012ca872b9856d006ea51500d56fd7f2f01b38
2022-06-23 23:33:57.537108+00	\N	\N	R3LL	Newark / Irvington NJ	itsR3LL	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x2C9836105e6a314764950272be379fe794Ec69A9/profile	2022-06-23 23:33:55.526+00	itsr3ll@gmail.com	0x2c9836105e6a314764950272be379fe794ec69a9
2022-05-05 04:44:06.416543+00	\N	\N	yuri beats	mt. airy	@yuri_beats	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x1d14d9e297DfbcE003f5A8EbcF8cBa7fAEe70B91/profile	2022-05-05 04:44:05.166+00	\N	0x1d14d9e297dfbce003f5a8ebcf8cba7faee70b91
2022-06-13 02:56:24.338208+00	\N	\N	discoveringEs	New York	twitter.com/esfamojure	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x52fA05393a003d234eFBA136E68DA835aeB64a26/profile	2022-06-13 02:57:37.407+00	esther.famojure@gmail.com	0x52fa05393a003d234efba136e68da835aeb64a26
2022-06-07 01:33:12.926777+00	\N	\N	AcidPunk	\N	https://twitter.com/AcidPunk0x	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xfFba44c15Fe2768bC2234078dfac8c5A651A56e9/profile	2022-06-07 01:49:44.59+00	acidpunk0x@gmail.com	0xffba44c15fe2768bc2234078dfac8c5a651a56e9
2022-06-08 05:02:04.70305+00	\N	\N	\N	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xeb54D707252Ee9E26E6a4073680Bf71154Ce7Ab5/profile	2022-06-08 05:02:03.138+00	\N	0xeb54d707252ee9e26e6a4073680bf71154ce7ab5
2022-05-11 21:44:44.043858+00	\N	\N	John Gotty	Nashville	@JohnGotty	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	\N	0xb38631d498f6d8b57d356d740523ae7a7fa91821
2022-06-23 13:11:45.274658+00	\N	\N	\N	metaverse	w0000CE0	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x0000CE08fa224696A819877070BF378e8B131ACF/profile	2022-06-23 13:11:43.74+00	\N	0x0000ce08fa224696a819877070bf378e8b131acf
2022-06-08 19:00:46.0205+00	\N	\N	Horace.eth	Baltimore MD	HoraceCurates	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x1502F98D90cc10b11B994566dFC44EC84035eCE8/profile	2022-06-08 19:00:44.156+00	horace.maddelta@gmail.com	0x1502f98d90cc10b11b994566dfc44ec84035ece8
2022-06-09 16:09:32.367844+00	\N	\N	henry	new york	henrywires	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	abstract.prototype@gmail.com	0xf93d8b05aa184f3b6b76d85418dba1472735ed54
2022-07-13 06:14:33.320046+00	\N	\N	jamesroeser	Los Angeles	james_roeser	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	jroeser@rimark.io	0xd7e422083c3d6cb923bc44754fad0dd1d1bf46d9
2022-06-23 14:03:05.340054+00	\N	\N	athenayasaman	new york	twitter.com/athenayasaman	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5/profile	2022-06-23 14:11:11.224+00	\N	0x58f2dc9b1b73c5609c2fe0fc9cfc32d1a54701a5
2022-07-13 17:23:35.36462+00	\N	\N	Yung Spielburg	Los Angeles	https://twitter.com/Yung_Spielburg	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xa8c37C36Eebae030a0C4122aE8A2eb926b55Ad0c/profile	2022-07-13 17:23:46.376+00	yung.spielburg@gmail.com	0xa8c37c36eebae030a0c4122ae8a2eb926b55ad0c
2022-07-13 18:20:14.1466+00	\N	\N	\N	Nantes	@Magna90371786	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x26F2d5d1BA02Da6C9825498708264d0f19eaf717/profile	2022-07-13 18:20:11.865+00	ghestemantoine@protonmail.com	0x26f2d5d1ba02da6c9825498708264d0f19eaf717
2022-07-18 11:55:41.919842+00	\N	\N	ishannegi	Delhi	https://twitter.com/xIN_8	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	ishannegi@pm.me	0x3a3297881e9904d0463fec7acd9d6d34b915dcb7
2022-07-20 16:29:38.740899+00	\N	\N	\N	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xDa8e436494E605AfF1927E995a908837f8fc3965/profile	2022-07-20 16:29:37.403+00	\N	0xda8e436494e605aff1927e995a908837f8fc3965
2022-05-20 03:07:58.776297+00	\N	\N	blackdave	Charleston, SC	blackdave	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xeD22Bb0106c24C7f6b4d8AAe33639e1467061F64/profile	2022-08-29 15:41:30.398+00	\N	0xed22bb0106c24c7f6b4d8aae33639e1467061f64
2022-05-03 22:42:38.421734+00	\N	\N	future modern	Silicollywood	https://twitter.com/afuturemodern	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x5ab45FB874701d910140e58EA62518566709c408/profile	2022-08-10 21:30:41.881+00	\N	0x5ab45fb874701d910140e58ea62518566709c408
2022-08-29 00:29:27.048386+00	\N	\N	\N	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x61379E0Aa98427e5d49D78b2EB54991e1ebF8d0d/profile	2022-08-29 00:29:29.128+00	\N	0x61379e0aa98427e5d49d78b2eb54991e1ebf8d0d
2022-07-20 19:25:06.267576+00	\N	\N	Opium Hum	Berlin	https://twitter.com/opiumhum	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xf1708BcCF4CE044699Ea2ECAFc2FF0C5139bdBC3/profile	2022-07-20 19:25:04.281+00	m@zora.co	0xf1708bccf4ce044699ea2ecafc2ff0c5139bdbc3
2022-09-02 02:44:56.371619+00	\N	\N	\N	new york city	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x2dD3FefF13B61C98a792DB20a7971106e3352A7B/profile	2022-09-02 02:47:55.752+00	jonathanfig4@gmail.com	0x2dd3feff13b61c98a792db20a7971106e3352a7b
2022-08-16 19:48:09.001857+00	\N	\N	ForteBowie	Atlanta	@fortebowie	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xcf3571AcCFCcFa1710984E6EDD659Fc9A906DC8C/profile	2022-08-16 19:58:41.296+00	everythingbowie@gmail.com	0xcf3571accfccfa1710984e6edd659fc9a906dc8c
2022-07-25 14:02:34.379386+00	\N	\N	peak.less	Berlin	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x7D8059e9721Ef92CCBa605775D1A7F6d8eF146c9/profile	2022-07-25 14:03:04.984+00	harry@peakless.co.uk	0x7d8059e9721ef92ccba605775d1a7f6d8ef146c9
2022-07-27 19:24:40.384444+00	\N	\N	\N	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x0C1fd979293d12051BDd551131673D7b63119db8/profile	2022-07-27 19:26:45.412+00	\N	0x0c1fd979293d12051bdd551131673d7b63119db8
2022-08-04 07:43:39.305481+00	\N	\N	Keenboo	Klaipeda	https://twitter.com/keenboo2022	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x371107cc397A1fd11FD5A7aC8421a3E43F886444/profile	2022-08-04 07:43:35.272+00	tom.budrys@gmail.com	0x371107cc397a1fd11fd5a7ac8421a3e43f886444
2022-08-04 18:37:26.343057+00	\N	\N	THRILLABXXNDS	Hemet	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x8b21E57F4cdB99c088AdCA33A4Eefba0d8713e93/profile	2022-08-04 18:37:50.982+00	actifyyy@gmail.com	0x8b21e57f4cdb99c088adca33a4eefba0d8713e93
2022-08-06 04:50:03.118648+00	\N	\N	\N	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x0dC4d7A2C908023E3fBa150e386FE2aEDa6f4172/profile	2022-08-06 04:50:01.408+00	\N	0x0dc4d7a2c908023e3fba150e386fe2aeda6f4172
2022-08-08 14:39:21.032737+00	\N	\N	Choirboy Dank	Demon City	danksinatra	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xf10747b5e895F77C14A42c71Ac6619dBCf1D7AF8/profile	2022-08-08 14:39:18.6+00	choirboydank@gmail.com	0xf10747b5e895f77c14a42c71ac6619dbcf1d7af8
2022-08-16 15:45:13.323251+00	\N	\N	easysleep	San Francisco	@mattjss	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	easysleepgg@gmail.com	0x68695286a38b9ec030756454f2b1ea3e9bbf9590
2022-08-30 15:21:01.609623+00	\N	\N	AaronsVilla	CHI->NYC	https://twitter.com/VillaAarons	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x7De19fF74dBb2F208Fb3D8a19eBE7995Cef8345c/profile	2022-08-30 15:20:57.807+00	AaronsVilla88.4487W@gmail.com	0x7de19ff74dbb2f208fb3d8a19ebe7995cef8345c
2022-08-29 15:13:38.107702+00	\N	\N	tester	tester	tester	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	t@t.com	0xc68fdd7fedf3e45efbc97096bdbaeea92540b3a4
2022-09-02 00:43:29.641921+00	\N	\N	sddfsdf	dfs	dsf	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	zdfZ@dsf.com	0x883a368a32e8763427aa86ffa85ed9f24d654085
2022-08-24 18:27:37.697872+00	\N	\N	hbkj0sh	Federalsburg	@JoshBea33263809	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x20805EE724EA3CAAbA5D9F2fd95E18ae756802E0/profile	2022-08-24 18:32:21.131+00	saviorhi127@gmail.com	0x20805ee724ea3caaba5d9f2fd95e18ae756802e0
2022-08-23 23:52:45.59429+00	\N	\N	ReggieVolume	Jersey City	@ReggieVolume	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	reggievolume@gmail.com	0x6eaa694f9b5df42961fbaea1563bf6ee658cb681
2022-08-25 17:25:56.956134+00	\N	\N	ThatsHymn	LA	ThatsHymn	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xd336Bc97859B582137E7e69a3c1AA4337fF225e9/profile	2022-08-25 17:25:55.368+00	mgmt@thatshymn.com	0xd336bc97859b582137e7e69a3c1aa4337ff225e9
2022-09-13 03:16:06.590884+00	\N	\N	\N	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xA23a740E0086B52d73ecDBb53423cCb53E0686D0/profile	2022-09-13 03:16:04.869+00	\N	0xa23a740e0086b52d73ecdbb53423ccb53e0686d0
2022-09-02 00:33:42.692319+00	\N	\N	sdds	dsd	ds	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	sds@sd.com	0x56cef7b74cc7121bb88c6d9b469819b5d32c9b22
2022-09-14 16:09:29.238979+00	\N	\N	testing	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	testing@gmail.com	0xa67d77830a1274948e38e0c9a646d96f16bf492d
2022-09-16 19:08:26.930622+00	\N	\N	ModestMotives	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x62F541d08dcA3e1044282DA4a9aa63590B6fFb34/profile	2022-09-16 19:08:25.381+00	Modestmotives@gmail.com	0x62f541d08dca3e1044282da4a9aa63590b6ffb34
2022-09-15 16:49:14.745005+00	\N	\N	greg	boston	twitter.com/gregisonfire	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xFE72483f5270f70E03259eb6C7F54246ED1f8519/profile	2022-09-15 16:49:12.258+00	greg.got.music@gmail.com	0xfe72483f5270f70e03259eb6c7f54246ed1f8519
2022-09-21 20:34:50.123081+00	\N	\N	bigbabygandhi	Queens, NY, NY	https://twitter.com/BIGBABYGANDHI	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x1EF036Df0e3e331c8Ed038ce875Fb02230dbf44D/profile	2022-09-21 20:34:55.302+00	bigbabygandhi@gmail.com	0x1ef036df0e3e331c8ed038ce875fb02230dbf44d
2022-09-21 20:54:48.952499+00	\N	\N	tayf3rd	Long Beach	https://twitter.com/TAYF3RD	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x690D7e51aa3E0CF5D0005659A382AA9bd8A07096/profile	2022-09-21 20:55:00.606+00	threesus1076@gmail.com	0x690d7e51aa3e0cf5d0005659a382aa9bd8a07096
2022-09-21 21:23:58.371708+00	\N	\N	jimmyv	San Antonio, TX	https://twitter.com/jimmyspacev	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xBB4839c63Fb47AF438E51b38380256f8A4a7b919/profile	2022-09-21 21:42:40.534+00	beats4jimmyv@gmail.com	0xbb4839c63fb47af438e51b38380256f8a4a7b919
2022-09-22 04:01:14.333538+00	\N	\N	\N	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x3a08B1A499A043d5757C19Cc18F3E0c36dD753af/profile	2022-09-22 04:02:04.912+00	\N	0x3a08b1a499a043d5757c19cc18f3e0c36dd753af
2022-09-25 07:57:42.540055+00	\N	\N	tiffanyzhoucc	Shanghai	tiffanyzhoucc	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xc9d636c52C44b2E166273F7DCD3A2e3A29272bf7/profile	2022-09-25 07:57:53.645+00	tiffanyzhoucc@gmail.com	0xc9d636c52c44b2e166273f7dcd3a2e3a29272bf7
2022-10-05 13:10:57.93894+00	\N	\N	\N	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x4A4f34c8CE0ac04Cf8d85806CD860C47Ab66430b/profile	2022-10-05 13:10:56.631+00	\N	0x4a4f34c8ce0ac04cf8d85806cd860c47ab66430b
2022-11-09 17:52:31.001739+00	\N	\N	Bigg Tonn	Woodstown	@apchmstry	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x635d0a248d76c5fa4998aa1a379124d2653ae99a/profile	2022-11-09 17:52:38.223+00	alton.washington@gmail.com	0x635d0a248d76c5fa4998aa1a379124d2653ae99a
2022-11-11 00:54:56.544355+00	\N	\N	untitledfiles00	Vancouver	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	aneesh@chaosclubdigital.com	0xd1a160724f6912537b0dd4cce5e5c134ace2cc97
2022-09-27 20:17:54.209635+00	\N	\N	snow!	Cincinnati	www.Twitter.com/sadboysnow	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xaB03dbe6bD5230Fe59E6c4Fb5F3De96164a6d794/profile	2022-09-27 20:18:34.536+00	workwithsnow@gmail.com	0xab03dbe6bd5230fe59e6c4fb5f3de96164a6d794
2022-03-29 23:28:51.8088+00	\N	\N	MakintsMind	UK, London	Makintsmind	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23/profile	2022-09-27 23:35:16.84+00	makint90@hotmail.com	0x91af49c2eba7197d1ecfd54a74cdc9f7e94a3a23
2022-11-14 14:14:04.513467+00	\N	\N	HBKJoshMetaMask	Federalsburg	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xf75779719f72f480e57b1ab06a729af2d051b1cd/profile	2022-11-14 14:14:00.588+00	soulsavage@gmail.com	0xf75779719f72f480e57b1ab06a729af2d051b1cd
2022-10-01 00:20:04.440326+00	\N	\N	JKJMusic	McKeesport	JKJ412	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xC53Eae37e0cAE1d0dBa541455D56d97F1d37B002/profile	2022-10-01 00:21:38.96+00	Jordan@jkjmusic.com	0xc53eae37e0cae1d0dba541455d56d97f1d37b002
2022-08-29 15:28:15.414969+00	\N	\N	Theo		\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N		0x31e5fbadb610954cb6e486c746d49883546413ed
2022-10-02 17:21:11.493105+00	\N	\N	testingAcc	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	homam@phote.co	0xbc74e5a0d8b06184faa100bc4a30568d72615890
2022-10-07 16:54:30.523146+00	\N	\N	kanna+	dc	Steve_Dorst	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x38d59276DcF946a506E2D18534dce2bef9c50D4f/profile	2022-10-09 21:53:34.737+00	steve@perpetuofilms.org	0x38d59276dcf946a506e2d18534dce2bef9c50d4f
2022-11-16 18:27:12.086021+00	\N	\N	parker	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	pqseagren@gmail.com	0x2aab747822b72b9e749252899f19f92e107454dc
2022-10-26 21:44:36.694061+00	\N	\N	ghostly	NYC	ghostly	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x6170deb8280DB45B6f01c6A2376021782E9199E1/profile.jpeg	2022-10-26 21:45:18.491+00	sam@ghostly.com	0x6170deb8280db45b6f01c6a2376021782e9199e1
2022-12-08 18:54:27.732501+00	\N	\N	OKDunc	OKC	OKDunc	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-08 18:54:27.732501+00	okduncanv@gmail.com	0x4fafa767c9cb71394875c139d43aee7799748908
2022-12-09 04:50:22.01492+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 04:50:22.01492+00	\N	0x0c213e6f00b89a57639dbecfec21be8fda9b4a45
2022-12-09 04:46:02.842153+00	\N	\N	jakeabel7	DC	@cryptabel	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 04:46:02.842153+00	jakeabel.value@gmail.com	0x8d41859049c156e70fa381e07a757d5db2f33e1d
2022-12-09 21:14:18.536411+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:14:18.536411+00	\N	0x892dc20b79287052fb4e21e131ff867c9ee003a7
2022-12-09 21:15:20.046837+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:15:20.046837+00	\N	0x675f0278e3b5e853e6767b87c4519afb4cc1d3a2
2022-12-09 21:16:13.503342+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:16:13.503342+00	\N	0x579a79a9a199ebd8a793bbb1f33fa709ad38fade
2022-12-09 21:16:54.838371+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:16:54.838371+00	\N	0x481682c6183bbaaf0b8b8136875dfa24bf508826
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0xfb3197bd5b7f2e39c1e89b7619a697827ed2deff
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x7bd69d24a9b2f2ba32a0061309d767c4235e87df
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x8d5fb8aca8294fc9a701408494288d2d7de42f7e
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0xcd930261704f384dc53f8691f0cbf961355293f8
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x0e0624a2e88e0dc9b56f9c9ce2d6907edd2b8fdf
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0xe73edd9414b9eb0e169283105cb1f0916823364f
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x6c5a162a3158ab52bc10414bae9766a1bac599df
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x24e48db6d94f5df5524ae428a2f12f0f2b3ad48c
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0xd3055381ce349b4cb7116a0b3fab762c3f16fa45
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x0c4076f4a49236ade7d21ede9e551c229fcf492d
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x41da01ebfeaf7091780bab72a91d4aca85a6dde7
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0xab5c2cf4097928add69b5f5c1b78b031966da696
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x9bc9a0eb9fafe9014ddc6ab1a3cd661f585a5641
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x0e35b828026f010a291c1dc0939427b2963d8d5a
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x5013f00ece420e380cb276c0bdc9ab96063ffb85
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0xdca9184f72bcc0838fbcbae7a46a86d9d4a52b63
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0xc5f904512e22da5c5fd86499449fe9ba85205233
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x2d9c9c342e892191b6c0defc0c85b1f00e2763a7
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0xc6729c943584fe18345b5551599a8fa3e14d432a
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x88f5d29b88664371401b6786a01db137fc5fca61
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x10b69a0684daf1b616e12fe3ee3d286571f46f4f
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x4dfd08b2b8ab7c8de88be6de522799b47bd5acb6
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x4c241596065a1dc9fe57ecbb6872af3cc8ffe444
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x3360a4e0eb33161da911b85f7c343e02ea41bbbd
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x889ca9161034ecc87d51677c0d775fbe1d3499e5
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0xb5de69b65007069e039f2f1e4933afad58062382
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x0b1cc9292401d5cb64875a441853ada7630148b4
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0xad66810a7358ad499c611d50108d0e0a8733e913
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x580fe897ef7026f9994324d654eb631663fc24c7
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x3de7fd5f98f7394bf2f3bdf30a575ccececf0a10
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x8a19ee2b23ef483c6c9b2de1e65d8c799cd80ea1
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0xbd69b5984b3cdebc5307a9d34103f4cfd7c9fbb9
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x7bac7a7f036e944cc7fa04090fbb125253b63784
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0xb1984b5790a483ea646a21bd64614328775d4174
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x72a29592f782016e8ba87e83e854f246e4fb363a
2022-12-11 20:37:21.774028+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-11 20:37:21.774028+00	\N	0x68729ea0a58565fb60fabce0066e8979d6da4fae
2022-12-13 02:27:28.775179+00	\N	\N	Bomi	Seoul	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-13 02:27:28.775179+00	bom50573@gmail.com	0xea9696c00295716f6411c6907ada5cce0d75c15f
2022-12-29 18:14:15.72228+00	\N	\N	tester12	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-29 18:14:15.72228+00	test@test.ca	0xfd72023562f26ff319b3dbae57b565dfcc16393a
2022-12-14 14:12:12.072579+00	\N	\N	dupesdidit	Vieux Fort Saint Lucia	@dupesdiditmusic	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/0xf47ed857754f690d8219b2f1459fe5f329a83cbc/profile	2022-12-14 14:13:20.451+00	dupesletsgo@gmail.com	0xf47ed857754f690d8219b2f1459fe5f329a83cbc
2022-12-16 21:03:07.159962+00	\N	\N	Kausixx	Moscow	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-16 21:03:07.159962+00	alexfacum@gmail.com	0xcb0d11ea8f7181aed2d775ff0e6581d0ac5c3ce3
2022-12-16 21:32:57.488112+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-16 21:32:57.488112+00	\N	0xf7a78cb2eb03510d17818ebaf07a1a17f882711a
2022-12-18 01:45:23.182522+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-18 01:45:23.182522+00	\N	0xf2234d46b6d1bdbd61f349a7f3e8d68caef272b7
2022-12-29 18:18:19.446497+00	\N	\N	BrandNewWallet	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-29 18:18:19.446497+00	asdasd@gmail.com	0x88514f8e92bd60c97a652f38e527cc580ab66301
2022-12-29 18:22:13.346853+00	\N	\N	NewWallet	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-29 18:22:13.346853+00	asdasdasd@gmail.com	0xd5093163ed157543fcac46fa3fc5cb00ae15f67f
2022-12-29 18:26:27.144448+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-29 18:26:27.144448+00	\N	0x7c1bd7bc0a4ed72e08ae00cad4eb91c020fe534d
2022-12-29 18:26:26.919957+00	\N	\N	OtherNewWallet	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-29 18:26:26.919957+00	uehuehu@gmail.com	0x6d365cb8b0f9fee582f77015ada4a361ba5c43f8
2023-01-04 06:22:15.306714+00	\N	\N	testerAcc10	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2023-01-04 06:22:15.306714+00	test@test.com	0xb9b0511011ec8a7e4a3a6e6822a3c84eb71b81f0
2023-01-02 21:42:56.932129+00	\N	\N	adamprotz	London	twitter.com/adamprotz	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/0xc576d28163c4ce3cccc5436708893da42dd2445c/profile	2023-01-02 21:43:59.512+00	adamprotz@gmail.com	0xc576d28163c4ce3cccc5436708893da42dd2445c
2023-01-05 02:05:57.799928+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2023-01-05 02:05:57.799928+00	\N	0x71947e53f4d4d4f1eef64dd360ef60a725e5373c
2023-01-06 16:51:08.994035+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2023-01-06 16:51:08.994035+00	\N	0xfcdd256267ade068babfb94f526a47aadf143a55
2022-06-28 21:19:49+00	\N	\N	Timer°°	Greifswald	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xa52B442bfeca885d7DE4F74971337f6Cf4E86f3B/profile	2022-06-28 21:20:13+00	theocarraraleao@gmail.com	0xa52b442bfeca885d7de4f74971337f6cf4e86f3b
2023-01-10 16:58:51.09832+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2023-01-10 16:58:51.09832+00	\N	0xdaf02bc35b0eba38744e046ea6314fdf7ce8a113
2023-01-31 17:55:04.146567+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2023-01-31 17:55:04.146567+00	\N	0x03e9206f2a1234fefad2c0b07a86b1e0f5cb8d0d
2023-01-11 14:03:07.858024+00	\N	\N	KLICK	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/0x40c423d16d1a9b90535cad9d54ba4a2766d066da/profile	2023-01-11 14:03:56.704+00	klick.tez@gmail.com	0x40c423d16d1a9b90535cad9d54ba4a2766d066da
2022-08-23 15:20:05.575318+00	\N	\N	outr3ach	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	\N	0xb60d2e146903852a94271b9a71cf45aa94277eb5
2023-01-24 19:03:26.660842+00	\N	\N	Dreamcastmoe	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/0xd02257d9354b8d3858a6a722df920a36b38d7ef8/profile	2023-01-24 19:05:21.996+00	Officialdreamcast@gmail.com	0xd02257d9354b8d3858a6a722df920a36b38d7ef8
2023-01-25 19:14:31.683883+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2023-01-25 19:14:31.683883+00	\N	0x01d0faeb7a9f1a450ac25a5f6cd44db1359cbf9f
2023-01-25 19:15:22.079537+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2023-01-25 19:15:22.079537+00	\N	0x3af4a2fec2baedd571042942d3bd412b673dd28b
2023-01-25 19:16:10.840876+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2023-01-25 19:16:10.840876+00	\N	0x49027ef8931082ca59f0037b80a4f518d500bc4f
2023-02-09 01:20:17.725322+00	\N	\N	testAccount	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2023-02-09 01:20:17.725322+00	test11@test.com	0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266
2023-02-09 01:28:24.194777+00	\N	\N	testerAcc	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2023-02-09 01:28:24.194777+00	hsadhsa@ahsdhsa.com	0xd2f8af18dcd90a87bc8a5daaa931430b12a1613c
\.


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

COPY public.comments ("submissionID", slug, threadid, "createdAt", "updatedAt", title, content, "isPublished", "authorId", "parentId", live, "isPinned", "isDeleted", "isApproved") FROM stdin;
\.


--
-- Data for Name: users_table_duplicate; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

COPY public.users_table_duplicate ("createdAt", "curatorSubmissionIDs", "artistSubmissionIDs", username, city, twitter, "profilePic", "updateTime", email, wallet) FROM stdin;
2022-03-25 17:49:40.515945+00	\N	\N	JamesGardin	Lansing	twitter.com/jamesgardin_	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x198F7e5f79B6efe3D67591ee62b527e99a6F2F38/profile	\N	\N	0x198F7e5f79B6efe3D67591ee62b527e99a6F2F38
2022-03-25 23:18:10.223791+00	\N	\N	Yanti	London	https://twitter.com/vabyanti	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xAF1B99F0B6bBB348D0E09bf35776E587a1977226/profile	\N	\N	0xAF1B99F0B6bBB348D0E09bf35776E587a1977226
2022-04-19 23:21:05.320734+00	\N	\N	OrcaMane	Fontana	twitter.com/noajames	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x42ACfC0Da38899168Dd4F9A66a5c8228cbbeFEB1/profile	\N	\N	0x42ACfC0Da38899168Dd4F9A66a5c8228cbbeFEB1
2022-04-20 15:56:18.564031+00	\N	\N	CONFUSIONisDEAD	New York	https://twitter.com/CONFUSIONisDEAD	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x18B4B34F5F2eF62b7F33830d358B656D87a93D31/profile	\N	\N	0x18B4B34F5F2eF62b7F33830d358B656D87a93D31
2022-03-26 04:46:29.70114+00	\N	\N	JamesGardin_	Lansing	Jamesgardin_	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x19a4fc15c43242FCE096eaA92f99A6ddBD6a97CD/profile	\N	\N	0x19a4fc15c43242FCE096eaA92f99A6ddBD6a97CD
2022-03-27 19:51:11.938137+00	\N	\N	afkMAXXX	Los Angeles	afkMAXXX	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x65FAc90a3479D9D8591c819BCa40085457BF8F25/profile	\N	\N	0x65FAc90a3479D9D8591c819BCa40085457BF8F25
2022-03-28 12:19:48.392364+00	\N	\N	Xcelencia	Orlando	Xcelencia	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x089036a0835C6cF82e7fC42e9e95DfE05e110c81/profile	\N	\N	0x089036a0835C6cF82e7fC42e9e95DfE05e110c81
2022-03-28 14:59:06.092676+00	\N	\N	Luca Maxim	World	https://mobile.twitter.com/lucamaxiim	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x83859Ad182b99Cd1f755c1E746D3df8380363d65/profile	\N	\N	0x83859Ad182b99Cd1f755c1E746D3df8380363d65
2022-03-28 15:15:22.352568+00	\N	\N	TETRA	BRONX	@TETRAGOCOMMANDO	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xFea1F357b453C9CD89b893B07baA6AbfE8536CA2/profile	\N	\N	0xFea1F357b453C9CD89b893B07baA6AbfE8536CA2
2022-03-28 22:20:06.040817+00	\N	\N	SeanyGee	Sydney	seanogardner	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x4Ce96AaCBf4a605084d757141bE016De8431b285/profile	\N	\N	0x4Ce96AaCBf4a605084d757141bE016De8431b285
2022-03-30 09:37:44.125731+00	\N	\N	Deadwalker	Metaverse	https://twitter.com/walkerrockets	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xEEb6Faae3094b31859f6B7b34a183Ae212e43cfb/profile	\N	\N	0xEEb6Faae3094b31859f6B7b34a183Ae212e43cfb
2022-03-11 20:24:11.12133+00	\N	\N	UncleMikey3.0	Lisboa, Portugal	anderjaska	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x1ce9200E1547F8bfb3EFa961FF0b8F88356Ccae2/profile	\N	\N	0x1ce9200E1547F8bfb3EFa961FF0b8F88356Ccae2
2022-03-30 16:43:17.417875+00	\N	\N	joshkarbon	Baltimore	joshkarbon	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x554Ff22048E90DbdB82dfAaF724BD01641D71AFe/profile	\N	\N	0x554Ff22048E90DbdB82dfAaF724BD01641D71AFe
2022-03-30 20:27:56.651053+00	\N	\N	Asha DaHomey	\N	@isThatAsha	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x97e5A788351ad8649B77d282F0D6e08a47813AfC/profile	\N	\N	0x97e5A788351ad8649B77d282F0D6e08a47813AfC
2022-03-24 20:28:01.156517+00	\N	\N	ODENZ	Greater Houston	@ODENZTV	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x67A276b6768978C9E41Af5418E09Efc8a12a28dE/profile	\N	\N	0x67A276b6768978C9E41Af5418E09Efc8a12a28dE
2022-04-07 04:16:28.000991+00	\N	\N	singnasty	DC	@singnasty	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74/profile	\N	\N	0x3DDEa6385B7D0b75A6dAE639bc39cB315FcC0F74
2022-04-19 02:11:02.418611+00	\N	\N	lifeofclaude	Bronx	@10k80minutes	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01/profile	\N	\N	0x1E19Fb57c419fC45cB771e91aE00925c2Db8fd01
2022-04-17 02:15:35.069766+00	\N	\N	SIDNE	San Diego	sidnexiv	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x85AAffc1F91cD828C82D5d0006B38C34b05917e9/profile	\N	\N	0x85AAffc1F91cD828C82D5d0006B38C34b05917e9
2022-04-12 19:24:39.573174+00	\N	\N	Lil Josh	Federalsburg, MD	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47/profile	2022-08-23 15:07:27.457+00	\N	0xC4FE904b8E2D7A0A9e1De8eBB07ecC908C27dE47
2022-04-18 00:52:40.615512+00	\N	\N	Verbs	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x8Ef4E20a765dF2c6d0AC077C7C9E175fed1ADaaC/profile	\N	\N	0x8Ef4E20a765dF2c6d0AC077C7C9E175fed1ADaaC
2022-04-14 18:25:39.615018+00	\N	\N	GrowExpand	illadelph	@GrowExpand	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x2be31e1066D6ad8C525A4f762d10117C753b35A3/profile	\N	\N	0x2be31e1066D6ad8C525A4f762d10117C753b35A3
2022-03-15 14:12:41.012697+00	\N	\N	Ghostflow	D.C.	@teamphlote	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xEf58304E292fBAeacFdeC25b67b3438031FdE313/profile	2022-07-25 20:22:24.63+00	aj@phlote.co	0xEf58304E292fBAeacFdeC25b67b3438031FdE313
2022-03-14 19:44:00.043839+00	\N	\N	hallway	Federalsburg	https://twitter.com/hallwayfinds	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7/profile	2022-08-16 18:06:13.378+00	hallway@phlote.co	0x0Bbac2BD3134a318DEb31137D87d42BF54325cb7
2022-04-16 16:39:47.574031+00	\N	\N	Jelly	The Internet 	@jellyjeezus	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xb53B1DF71705aa51efe96FaB14c6B11763c9768F/profile	\N	\N	0xb53B1DF71705aa51efe96FaB14c6B11763c9768F
2022-03-14 18:08:40.041177+00	\N	\N	zfogg	Washington, DC	zfogg	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x276Adf94808668338ff61df00d63c2F8ce056206/profile	\N	\N	0x276Adf94808668338ff61df00d63c2F8ce056206
2022-03-22 23:14:15.242726+00	\N	\N	almndbtr	Los Angeles	almndbtr	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x85fc6505df723C427D5bBc1b32D7e1EC66c1a55e/profile	\N	\N	0x85fc6505df723C427D5bBc1b32D7e1EC66c1a55e
2022-03-23 16:46:56.590893+00	\N	\N	chadhillydilly	Vancouver	@chadhillydilly	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xdFBB06683a882E827907422dbFE836E5430fE2aC/profile	\N	\N	0xdFBB06683a882E827907422dbFE836E5430fE2aC
2022-03-25 17:33:35.838106+00	\N	\N	joey	Chicago	@joeyburbach	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x604e88bf430847B62391FBb717cB6F18A683B00b/profile	\N	\N	0x604e88bf430847B62391FBb717cB6F18A683B00b
2022-06-10 15:26:57.487543+00	\N	\N	chidi.mishael	Lagos	@chidimishael	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	okoronkwochidi10@gmail.com	0xa9A94e4718c045CCdf94266403aF4aDD53A2fD15
2022-04-09 20:47:54.488678+00	\N	\N	singnastydos	DC	@singnasty	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	\N	0xb077473009E7e013B0Fa68af63E96773E0A5D6A4
2022-04-28 23:31:47.538946+00	\N	\N	Mighty33	Paris	mighty_33	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	\N	0x8C62dD796e13aD389aD0bfDA44BB231D317Ef6C6
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x2AD084D80B7034E31c8025fdbc8C32fA756Eb4Ba
2022-05-14 03:30:47.184715+00	\N	\N	Glassface	Los Angeles	@glassface_	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xc2469e9D964F25c58755380727a1C98782a219ac/profile	2022-05-14 03:30:41.377+00	\N	0xc2469e9D964F25c58755380727a1C98782a219ac
2022-05-06 17:13:46.822584+00	\N	\N	emez	Washington, DC		https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xAc801951867c4fE73bEeAe4961A6557FfdC83bfF/profile	2022-05-06 17:13:46.226+00	erinwashington50@gmail.com	0xAc801951867c4fE73bEeAe4961A6557FfdC83bfF
2022-05-02 19:34:05.911961+00	\N	\N	Sirjwheeler	Los Angeles	@sirjwheeler	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x00daEbab128f5CFc805D75324c20c6fEaf6B26b2/profile	2022-05-02 19:34:00.988+00	\N	0x00daEbab128f5CFc805D75324c20c6fEaf6B26b2
2022-05-04 19:46:15.561191+00	\N	\N	Anderjaska2.1	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	\N	0x7d1f0b6556f19132e545717C6422e8AB004A5B7c
2022-05-05 20:40:04.558182+00	\N	\N	\N	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x9921B926788E91Aa9db885c214Db5FEe8943b771/profile	2022-05-05 20:40:01.751+00	\N	0x9921B926788E91Aa9db885c214Db5FEe8943b771
2022-04-30 13:50:59.345435+00	\N	\N	Trish	Los Angeles	@nft_ish	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x5f8b9B4541Ecef965424f1dB923806aAD626Add2/profile	2022-04-30 13:50:57.916+00	trish@boop.art	0x5f8b9B4541Ecef965424f1dB923806aAD626Add2
2022-06-02 10:01:12.99411+00	\N	\N	harishm	London	@harish_malhi	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	\N	0xacef50638be46aDcd6f5C7DFD9bf5894266794FC
2022-07-08 22:30:08.029787+00	\N	\N	mikemelinoe	Detroit, MI	@MikeMelinoe	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xcE012cA872B9856d006ea51500D56fD7F2f01b38/profile	2022-07-08 22:30:06.303+00	mgmt@goldaintcheap.com	0xcE012cA872B9856d006ea51500D56fD7F2f01b38
2022-06-23 23:33:57.537108+00	\N	\N	R3LL	Newark / Irvington NJ	itsR3LL	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x2C9836105e6a314764950272be379fe794Ec69A9/profile	2022-06-23 23:33:55.526+00	itsr3ll@gmail.com	0x2C9836105e6a314764950272be379fe794Ec69A9
2022-05-05 04:44:06.416543+00	\N	\N	yuri beats	mt. airy	@yuri_beats	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x1d14d9e297DfbcE003f5A8EbcF8cBa7fAEe70B91/profile	2022-05-05 04:44:05.166+00	\N	0x1d14d9e297DfbcE003f5A8EbcF8cBa7fAEe70B91
2022-06-13 02:56:24.338208+00	\N	\N	discoveringEs	New York	twitter.com/esfamojure	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x52fA05393a003d234eFBA136E68DA835aeB64a26/profile	2022-06-13 02:57:37.407+00	esther.famojure@gmail.com	0x52fA05393a003d234eFBA136E68DA835aeB64a26
2022-06-07 01:33:12.926777+00	\N	\N	AcidPunk	\N	https://twitter.com/AcidPunk0x	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xfFba44c15Fe2768bC2234078dfac8c5A651A56e9/profile	2022-06-07 01:49:44.59+00	acidpunk0x@gmail.com	0xfFba44c15Fe2768bC2234078dfac8c5A651A56e9
2022-06-08 05:02:04.70305+00	\N	\N	\N	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xeb54D707252Ee9E26E6a4073680Bf71154Ce7Ab5/profile	2022-06-08 05:02:03.138+00	\N	0xeb54D707252Ee9E26E6a4073680Bf71154Ce7Ab5
2022-05-11 21:44:44.043858+00	\N	\N	John Gotty	Nashville	@JohnGotty	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	\N	0xB38631d498f6d8b57d356D740523AE7A7Fa91821
2022-06-23 13:11:45.274658+00	\N	\N	\N	metaverse	w0000CE0	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x0000CE08fa224696A819877070BF378e8B131ACF/profile	2022-06-23 13:11:43.74+00	\N	0x0000CE08fa224696A819877070BF378e8B131ACF
2022-06-08 19:00:46.0205+00	\N	\N	Horace.eth	Baltimore MD	HoraceCurates	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x1502F98D90cc10b11B994566dFC44EC84035eCE8/profile	2022-06-08 19:00:44.156+00	horace.maddelta@gmail.com	0x1502F98D90cc10b11B994566dFC44EC84035eCE8
2022-06-09 16:09:32.367844+00	\N	\N	henry	new york	henrywires	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	abstract.prototype@gmail.com	0xf93D8b05aA184F3b6B76D85418DBa1472735ED54
2022-07-13 06:14:33.320046+00	\N	\N	jamesroeser	Los Angeles	james_roeser	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	jroeser@rimark.io	0xd7E422083C3D6Cb923Bc44754Fad0dD1D1bF46d9
2022-06-23 14:03:05.340054+00	\N	\N	athenayasaman	new york	twitter.com/athenayasaman	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5/profile	2022-06-23 14:11:11.224+00	\N	0x58F2dc9B1b73c5609C2Fe0fC9cFc32D1A54701A5
2022-07-13 17:23:35.36462+00	\N	\N	Yung Spielburg	Los Angeles	https://twitter.com/Yung_Spielburg	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xa8c37C36Eebae030a0C4122aE8A2eb926b55Ad0c/profile	2022-07-13 17:23:46.376+00	yung.spielburg@gmail.com	0xa8c37C36Eebae030a0C4122aE8A2eb926b55Ad0c
2022-07-13 18:20:14.1466+00	\N	\N	\N	Nantes	@Magna90371786	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x26F2d5d1BA02Da6C9825498708264d0f19eaf717/profile	2022-07-13 18:20:11.865+00	ghestemantoine@protonmail.com	0x26F2d5d1BA02Da6C9825498708264d0f19eaf717
2022-07-18 11:55:41.919842+00	\N	\N	ishannegi	Delhi	https://twitter.com/xIN_8	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	ishannegi@pm.me	0x3a3297881e9904d0463fec7Acd9d6d34b915dCB7
2022-07-20 16:29:38.740899+00	\N	\N	\N	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xDa8e436494E605AfF1927E995a908837f8fc3965/profile	2022-07-20 16:29:37.403+00	\N	0xDa8e436494E605AfF1927E995a908837f8fc3965
2022-05-20 03:07:58.776297+00	\N	\N	blackdave	Charleston, SC	blackdave	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xeD22Bb0106c24C7f6b4d8AAe33639e1467061F64/profile	2022-08-29 15:41:30.398+00	\N	0xeD22Bb0106c24C7f6b4d8AAe33639e1467061F64
2022-05-03 22:42:38.421734+00	\N	\N	future modern	Silicollywood	https://twitter.com/afuturemodern	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x5ab45FB874701d910140e58EA62518566709c408/profile	2022-08-10 21:30:41.881+00	\N	0x5ab45FB874701d910140e58EA62518566709c408
2022-08-29 00:29:27.048386+00	\N	\N	\N	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x61379E0Aa98427e5d49D78b2EB54991e1ebF8d0d/profile	2022-08-29 00:29:29.128+00	\N	0x61379E0Aa98427e5d49D78b2EB54991e1ebF8d0d
2022-07-20 19:25:06.267576+00	\N	\N	Opium Hum	Berlin	https://twitter.com/opiumhum	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xf1708BcCF4CE044699Ea2ECAFc2FF0C5139bdBC3/profile	2022-07-20 19:25:04.281+00	m@zora.co	0xf1708BcCF4CE044699Ea2ECAFc2FF0C5139bdBC3
2022-09-02 02:44:56.371619+00	\N	\N	\N	new york city	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x2dD3FefF13B61C98a792DB20a7971106e3352A7B/profile	2022-09-02 02:47:55.752+00	jonathanfig4@gmail.com	0x2dD3FefF13B61C98a792DB20a7971106e3352A7B
2022-08-16 19:48:09.001857+00	\N	\N	ForteBowie	Atlanta	@fortebowie	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xcf3571AcCFCcFa1710984E6EDD659Fc9A906DC8C/profile	2022-08-16 19:58:41.296+00	everythingbowie@gmail.com	0xcf3571AcCFCcFa1710984E6EDD659Fc9A906DC8C
2022-07-25 14:02:34.379386+00	\N	\N	peak.less	Berlin	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x7D8059e9721Ef92CCBa605775D1A7F6d8eF146c9/profile	2022-07-25 14:03:04.984+00	harry@peakless.co.uk	0x7D8059e9721Ef92CCBa605775D1A7F6d8eF146c9
2022-07-27 19:24:40.384444+00	\N	\N	\N	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x0C1fd979293d12051BDd551131673D7b63119db8/profile	2022-07-27 19:26:45.412+00	\N	0x0C1fd979293d12051BDd551131673D7b63119db8
2022-08-04 07:43:39.305481+00	\N	\N	Keenboo	Klaipeda	https://twitter.com/keenboo2022	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x371107cc397A1fd11FD5A7aC8421a3E43F886444/profile	2022-08-04 07:43:35.272+00	tom.budrys@gmail.com	0x371107cc397A1fd11FD5A7aC8421a3E43F886444
2022-08-04 18:37:26.343057+00	\N	\N	THRILLABXXNDS	Hemet	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x8b21E57F4cdB99c088AdCA33A4Eefba0d8713e93/profile	2022-08-04 18:37:50.982+00	actifyyy@gmail.com	0x8b21E57F4cdB99c088AdCA33A4Eefba0d8713e93
2022-08-06 04:50:03.118648+00	\N	\N	\N	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x0dC4d7A2C908023E3fBa150e386FE2aEDa6f4172/profile	2022-08-06 04:50:01.408+00	\N	0x0dC4d7A2C908023E3fBa150e386FE2aEDa6f4172
2022-08-08 14:39:21.032737+00	\N	\N	Choirboy Dank	Demon City	danksinatra	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xf10747b5e895F77C14A42c71Ac6619dBCf1D7AF8/profile	2022-08-08 14:39:18.6+00	choirboydank@gmail.com	0xf10747b5e895F77C14A42c71Ac6619dBCf1D7AF8
2022-08-16 15:45:13.323251+00	\N	\N	easysleep	San Francisco	@mattjss	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	easysleepgg@gmail.com	0x68695286a38b9ec030756454F2B1eA3e9bBf9590
2022-08-23 15:20:05.575318+00	\N	\N	outr3ach	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	\N	0xb60D2E146903852A94271B9A71CF45aa94277eB5
2022-08-30 15:21:01.609623+00	\N	\N	AaronsVilla	CHI->NYC	https://twitter.com/VillaAarons	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x7De19fF74dBb2F208Fb3D8a19eBE7995Cef8345c/profile	2022-08-30 15:20:57.807+00	AaronsVilla88.4487W@gmail.com	0x7De19fF74dBb2F208Fb3D8a19eBE7995Cef8345c
2022-08-29 15:13:38.107702+00	\N	\N	tester	tester	tester	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	t@t.com	0xc68FDD7fEdF3e45Efbc97096BDBaEEA92540B3A4
2022-09-02 00:43:29.641921+00	\N	\N	sddfsdf	dfs	dsf	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	zdfZ@dsf.com	0x883A368A32e8763427Aa86FFa85ED9f24d654085
2022-08-29 15:28:15.414969+00	\N	\N	Theo		\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N		0x31E5FBAdB610954Cb6e486C746d49883546413eD
2022-08-24 18:27:37.697872+00	\N	\N	hbkj0sh	Federalsburg	@JoshBea33263809	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x20805EE724EA3CAAbA5D9F2fd95E18ae756802E0/profile	2022-08-24 18:32:21.131+00	saviorhi127@gmail.com	0x20805EE724EA3CAAbA5D9F2fd95E18ae756802E0
2022-08-23 23:52:45.59429+00	\N	\N	ReggieVolume	Jersey City	@ReggieVolume	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	reggievolume@gmail.com	0x6EAa694F9B5Df42961FBAea1563bf6EE658Cb681
2022-08-25 17:25:56.956134+00	\N	\N	ThatsHymn	LA	ThatsHymn	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xd336Bc97859B582137E7e69a3c1AA4337fF225e9/profile	2022-08-25 17:25:55.368+00	mgmt@thatshymn.com	0xd336Bc97859B582137E7e69a3c1AA4337fF225e9
2022-09-13 03:16:06.590884+00	\N	\N	\N	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xA23a740E0086B52d73ecDBb53423cCb53E0686D0/profile	2022-09-13 03:16:04.869+00	\N	0xA23a740E0086B52d73ecDBb53423cCb53E0686D0
2022-09-02 00:33:42.692319+00	\N	\N	sdds	dsd	ds	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	sds@sd.com	0x56ceF7b74CC7121bb88C6D9b469819B5D32c9B22
2022-09-14 16:09:29.238979+00	\N	\N	testing	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	testing@gmail.com	0xA67d77830A1274948e38e0c9a646D96F16bF492D
2022-09-16 19:08:26.930622+00	\N	\N	ModestMotives	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x62F541d08dcA3e1044282DA4a9aa63590B6fFb34/profile	2022-09-16 19:08:25.381+00	Modestmotives@gmail.com	0x62F541d08dcA3e1044282DA4a9aa63590B6fFb34
2022-09-15 16:49:14.745005+00	\N	\N	greg	boston	twitter.com/gregisonfire	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xFE72483f5270f70E03259eb6C7F54246ED1f8519/profile	2022-09-15 16:49:12.258+00	greg.got.music@gmail.com	0xFE72483f5270f70E03259eb6C7F54246ED1f8519
2022-09-21 20:34:50.123081+00	\N	\N	bigbabygandhi	Queens, NY, NY	https://twitter.com/BIGBABYGANDHI	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x1EF036Df0e3e331c8Ed038ce875Fb02230dbf44D/profile	2022-09-21 20:34:55.302+00	bigbabygandhi@gmail.com	0x1EF036Df0e3e331c8Ed038ce875Fb02230dbf44D
2022-09-21 20:54:48.952499+00	\N	\N	tayf3rd	Long Beach	https://twitter.com/TAYF3RD	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x690D7e51aa3E0CF5D0005659A382AA9bd8A07096/profile	2022-09-21 20:55:00.606+00	threesus1076@gmail.com	0x690D7e51aa3E0CF5D0005659A382AA9bd8A07096
2022-09-21 21:23:58.371708+00	\N	\N	jimmyv	San Antonio, TX	https://twitter.com/jimmyspacev	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xBB4839c63Fb47AF438E51b38380256f8A4a7b919/profile	2022-09-21 21:42:40.534+00	beats4jimmyv@gmail.com	0xBB4839c63Fb47AF438E51b38380256f8A4a7b919
2022-09-22 04:01:14.333538+00	\N	\N	\N	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x3a08B1A499A043d5757C19Cc18F3E0c36dD753af/profile	2022-09-22 04:02:04.912+00	\N	0x3a08B1A499A043d5757C19Cc18F3E0c36dD753af
2022-09-25 07:57:42.540055+00	\N	\N	tiffanyzhoucc	Shanghai	tiffanyzhoucc	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xc9d636c52C44b2E166273F7DCD3A2e3A29272bf7/profile	2022-09-25 07:57:53.645+00	tiffanyzhoucc@gmail.com	0xc9d636c52C44b2E166273F7DCD3A2e3A29272bf7
2022-10-05 13:10:57.93894+00	\N	\N	\N	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x4A4f34c8CE0ac04Cf8d85806CD860C47Ab66430b/profile	2022-10-05 13:10:56.631+00	\N	0x4A4f34c8CE0ac04Cf8d85806CD860C47Ab66430b
2022-11-09 17:52:31.001739+00	\N	\N	Bigg Tonn	Woodstown	@apchmstry	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x635d0a248d76c5fa4998aa1a379124d2653ae99a/profile	2022-11-09 17:52:38.223+00	alton.washington@gmail.com	0x635d0a248d76c5fa4998aa1a379124d2653ae99a
2022-11-11 00:54:56.544355+00	\N	\N	untitledfiles00	Vancouver	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	aneesh@chaosclubdigital.com	0xd1a160724f6912537b0dd4cce5e5c134ace2cc97
2022-09-27 20:17:54.209635+00	\N	\N	snow!	Cincinnati	www.Twitter.com/sadboysnow	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xaB03dbe6bD5230Fe59E6c4Fb5F3De96164a6d794/profile	2022-09-27 20:18:34.536+00	workwithsnow@gmail.com	0xaB03dbe6bD5230Fe59E6c4Fb5F3De96164a6d794
2022-03-29 23:28:51.8088+00	\N	\N	MakintsMind	UK, London	Makintsmind	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23/profile	2022-09-27 23:35:16.84+00	makint90@hotmail.com	0x91Af49c2eBa7197d1ECFd54A74cdc9f7e94A3a23
2022-11-14 14:14:04.513467+00	\N	\N	HBKJoshMetaMask	Federalsburg	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xf75779719f72f480e57b1ab06a729af2d051b1cd/profile	2022-11-14 14:14:00.588+00	soulsavage@gmail.com	0xf75779719f72f480e57b1ab06a729af2d051b1cd
2022-10-01 00:20:04.440326+00	\N	\N	JKJMusic	McKeesport	JKJ412	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xC53Eae37e0cAE1d0dBa541455D56d97F1d37B002/profile	2022-10-01 00:21:38.96+00	Jordan@jkjmusic.com	0xC53Eae37e0cAE1d0dBa541455D56d97F1d37B002
2022-10-02 17:21:11.493105+00	\N	\N	testingAcc	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	homam@phote.co	0xbc74E5a0d8b06184Faa100bC4a30568d72615890
2022-10-07 16:54:30.523146+00	\N	\N	kanna+	dc	Steve_Dorst	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x38d59276DcF946a506E2D18534dce2bef9c50D4f/profile	2022-10-09 21:53:34.737+00	steve@perpetuofilms.org	0x38d59276DcF946a506E2D18534dce2bef9c50D4f
2022-11-16 18:27:12.086021+00	\N	\N	parker	\N	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/default	\N	pqseagren@gmail.com	0x2aab747822b72b9e749252899f19f92e107454dc
2022-10-26 21:44:36.694061+00	\N	\N	ghostly	NYC	ghostly	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0x6170deb8280DB45B6f01c6A2376021782E9199E1/profile.jpeg	2022-10-26 21:45:18.491+00	sam@ghostly.com	0x6170deb8280DB45B6f01c6A2376021782E9199E1
2022-12-08 18:54:27.732501+00	\N	\N	OKDunc	OKC	OKDunc	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-08 18:54:27.732501+00	okduncanv@gmail.com	0x4fafa767c9cb71394875c139d43aee7799748908
2022-12-09 04:50:22.01492+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 04:50:22.01492+00	\N	0x0c213e6f00b89a57639dbecfec21be8fda9b4a45
2022-12-09 04:46:02.842153+00	\N	\N	jakeabel7	DC	@cryptabel	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 04:46:02.842153+00	jakeabel.value@gmail.com	0x8d41859049c156e70fa381e07a757d5db2f33e1d
2022-12-09 21:14:18.536411+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:14:18.536411+00	\N	0x892dc20b79287052FB4E21E131ff867c9ee003A7
2022-12-09 21:15:20.046837+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:15:20.046837+00	\N	0x675F0278e3b5e853e6767b87c4519Afb4CC1d3a2
2022-12-09 21:16:13.503342+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:16:13.503342+00	\N	0x579a79a9a199Ebd8a793BbB1F33fa709Ad38fadE
2022-12-09 21:16:54.838371+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:16:54.838371+00	\N	0x481682C6183bBAAf0b8B8136875dFa24BF508826
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0xfb3197Bd5b7F2E39c1e89B7619A697827eD2deff
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x7BD69d24a9B2f2ba32A0061309D767C4235e87Df
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x8d5fb8Aca8294FC9A701408494288D2d7de42F7E
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0xCd930261704f384DC53F8691f0cBF961355293f8
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x0E0624A2E88E0Dc9B56f9c9Ce2D6907eDd2B8FdF
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0xE73edd9414b9Eb0E169283105CB1F0916823364F
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x6c5A162A3158ab52Bc10414BaE9766A1bac599dF
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x24e48db6d94f5dF5524Ae428a2f12F0f2b3Ad48c
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0xD3055381ce349b4cB7116A0b3FAb762c3f16FA45
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x0c4076f4A49236adE7D21ede9e551C229FCf492d
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x41DA01eBfeAF7091780BaB72A91D4aCa85a6DDe7
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0xab5c2Cf4097928Add69b5F5C1B78B031966da696
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x9bc9A0eb9FAFe9014ddC6Ab1A3Cd661F585a5641
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x0e35B828026F010A291C1DC0939427b2963D8d5a
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x5013f00ECe420E380Cb276c0Bdc9ab96063FFB85
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0xdCA9184F72BCC0838fbCBae7A46a86D9d4A52b63
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0xC5F904512E22dA5C5fd86499449fE9bA85205233
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x2d9c9c342E892191B6c0DEFC0C85b1f00E2763a7
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0xc6729C943584fe18345B5551599a8Fa3e14D432a
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x88F5d29B88664371401B6786A01db137fC5FcA61
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x10B69a0684DaF1B616e12Fe3ee3D286571f46F4f
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x4dFD08B2B8ab7C8dE88Be6dE522799b47bd5ACb6
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x4C241596065A1Dc9Fe57ecbB6872aF3cC8fFE444
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x3360A4e0Eb33161dA911B85f7C343E02ea41BbbD
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x889ca9161034ECC87D51677C0D775Fbe1D3499e5
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0xB5DE69B65007069e039F2f1e4933aFAd58062382
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x0b1cc9292401D5Cb64875A441853Ada7630148b4
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0xAd66810a7358ad499C611d50108D0E0A8733E913
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x580Fe897EF7026F9994324D654EB631663FC24C7
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x3De7fd5f98f7394bF2F3bdf30a575CcEcecf0A10
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x8A19EE2B23EF483C6c9B2De1e65D8c799Cd80EA1
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0xbD69B5984b3CDEbC5307a9D34103F4CfD7C9fBb9
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x7bAc7a7f036e944Cc7fa04090FBb125253B63784
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0xb1984b5790A483Ea646A21BD64614328775d4174
2022-12-09 21:26:28.084843+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-09 21:26:28.084843+00	\N	0x72a29592f782016e8ba87e83e854f246e4fb363a
2022-12-11 20:37:21.774028+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-11 20:37:21.774028+00	\N	0x68729ea0a58565fb60fabce0066e8979d6da4fae
2022-12-13 02:27:28.775179+00	\N	\N	Bomi	Seoul	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-13 02:27:28.775179+00	bom50573@gmail.com	0xea9696c00295716f6411c6907ada5cce0d75c15f
2022-12-29 18:14:15.72228+00	\N	\N	tester12	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-29 18:14:15.72228+00	test@test.ca	0xfd72023562f26ff319b3dbae57b565dfcc16393a
2022-12-14 14:12:12.072579+00	\N	\N	dupesdidit	Vieux Fort Saint Lucia	@dupesdiditmusic	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/0xf47ed857754f690d8219b2f1459fe5f329a83cbc/profile	2022-12-14 14:13:20.451+00	dupesletsgo@gmail.com	0xf47ed857754f690d8219b2f1459fe5f329a83cbc
2022-12-16 21:03:07.159962+00	\N	\N	Kausixx	Moscow	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-16 21:03:07.159962+00	alexfacum@gmail.com	0xcb0d11ea8f7181aed2d775ff0e6581d0ac5c3ce3
2022-12-16 21:32:57.488112+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-16 21:32:57.488112+00	\N	0xf7a78cb2eb03510d17818ebaf07a1a17f882711a
2022-12-18 01:45:23.182522+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-18 01:45:23.182522+00	\N	0xf2234d46b6d1bdbd61f349a7f3e8d68caef272b7
2022-12-29 18:18:19.446497+00	\N	\N	BrandNewWallet	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-29 18:18:19.446497+00	asdasd@gmail.com	0x88514f8e92bd60c97a652f38e527cc580ab66301
2022-12-29 18:22:13.346853+00	\N	\N	NewWallet	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-29 18:22:13.346853+00	asdasdasd@gmail.com	0xd5093163ed157543fcac46fa3fc5cb00ae15f67f
2022-12-29 18:26:27.144448+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-29 18:26:27.144448+00	\N	0x7c1bd7bc0a4ed72e08ae00cad4eb91c020fe534d
2022-12-29 18:26:26.919957+00	\N	\N	OtherNewWallet	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2022-12-29 18:26:26.919957+00	uehuehu@gmail.com	0x6d365cb8b0f9fee582f77015ada4a361ba5c43f8
2023-01-04 06:22:15.306714+00	\N	\N	testerAcc10	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2023-01-04 06:22:15.306714+00	test@test.com	0xb9b0511011ec8a7e4a3a6e6822a3c84eb71b81f0
2023-01-02 21:42:56.932129+00	\N	\N	adamprotz	London	twitter.com/adamprotz	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/0xc576d28163c4ce3cccc5436708893da42dd2445c/profile	2023-01-02 21:43:59.512+00	adamprotz@gmail.com	0xc576d28163c4ce3cccc5436708893da42dd2445c
2023-01-05 02:05:57.799928+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2023-01-05 02:05:57.799928+00	\N	0x71947e53f4d4d4f1eef64dd360ef60a725e5373c
2023-01-06 16:51:08.994035+00	\N	\N	\N	\N	\N	https://goekxcdbwpktmthbsbih.supabase.co/storage/v1/object/public/profile-pics/default.png	2023-01-06 16:51:08.994035+00	\N	0xfcdd256267ade068babfb94f526a47aadf143a55
2022-06-28 21:19:49+00	\N	\N	Timer°°	Greifswald	\N	https://alytqvwillylytpmdjai.supabase.co/storage/v1/object/public/profile-pics/0xa52B442bfeca885d7DE4F74971337f6Cf4E86f3B/profile	2022-06-28 21:20:13+00	theocarraraleao@gmail.com	0xa52b442bfeca885d7de4f74971337f6cf4e86f3b
\.


--
-- Data for Name: votes; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

COPY public.votes ("commentId", "userId", value) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public) FROM stdin;
files	files	\N	2022-10-27 15:18:09.387176+00	2022-10-27 15:18:09.387176+00	t
profile-pics	profile-pics	\N	2022-10-27 15:20:38.333906+00	2022-10-27 15:20:38.333906+00	t
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2022-10-16 19:29:37.874367
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2022-10-16 19:29:37.881378
2	pathtoken-column	49756be03be4c17bb85fe70d4a861f27de7e49ad	2022-10-16 19:29:37.883915
3	add-migrations-rls	bb5d124c53d68635a883e399426c6a5a25fc893d	2022-10-16 19:29:37.907904
4	add-size-functions	6d79007d04f5acd288c9c250c42d2d5fd286c54d	2022-10-16 19:29:37.91444
5	change-column-name-in-get-size	fd65688505d2ffa9fbdc58a944348dd8604d688c	2022-10-16 19:29:37.950841
6	add-rls-to-buckets	63e2bab75a2040fee8e3fb3f15a0d26f3380e9b6	2022-10-16 19:29:37.955439
7	add-public-to-buckets	82568934f8a4d9e0a85f126f6fb483ad8214c418	2022-10-16 19:29:37.958769
8	fix-search-function	1a43a40eddb525f2e2f26efd709e6c06e58e059c	2022-10-16 19:29:37.962619
9	search-files-search-function	34c096597eb8b9d077fdfdde9878c88501b2fafc	2022-10-16 19:29:37.966397
10	add-trigger-to-auto-update-updated_at-column	37d6bb964a70a822e6d37f22f457b9bca7885928	2022-10-16 19:29:37.970497
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata) FROM stdin;
f723e9a1-3184-4124-874f-b2fcde6a5720	profile-pics	default.png	\N	2022-11-02 21:37:37.31736+00	2022-11-02 21:37:37.514389+00	2022-11-02 21:37:37.31736+00	{"size": 48196, "mimetype": "image/png", "cacheControl": "max-age=3600"}
397c09b5-20b0-4b48-b2e5-e4928fb14599	profile-pics	0xa52b442bfeca885d7de4f74971337f6cf4e86f3b/profile	\N	2022-11-02 21:47:18.013022+00	2022-11-02 22:04:08.993656+00	2022-11-02 21:47:18.013022+00	{"size": 2216526, "mimetype": "image/png", "cacheControl": "max-age=3600"}
feaf146b-ee29-4f74-bf8f-fad5f94c406e	profile-pics	0x31e5fbadb610954cb6e486c746d49883546413ed/profile	\N	2022-11-05 16:46:22.027323+00	2022-11-05 16:46:25.462727+00	2022-11-05 16:46:22.027323+00	{"size": 14483672, "mimetype": "image/jpeg", "cacheControl": "max-age=3600"}
0e66260b-127d-42f1-9b92-65ee210103e7	profile-pics	0x371107cc397a1fd11fd5a7ac8421a3e43f886444/profile	\N	2022-11-30 16:50:45.074661+00	2022-11-30 16:50:45.598276+00	2022-11-30 16:50:45.074661+00	{"eTag": "\\"083a7ce40102292fc1f6a490c743c7db\\"", "size": 847615, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2022-11-30T16:50:46.000Z", "contentLength": 847615, "httpStatusCode": 200}
2d9b06b4-68c2-4e16-8cde-57b0459a4d8d	profile-pics	0xf47ed857754f690d8219b2f1459fe5f329a83cbc/profile	\N	2022-11-22 20:44:44.22578+00	2022-12-14 14:13:23.901137+00	2022-11-22 20:44:44.22578+00	{"eTag": "\\"9d17a40c9dc9d4b7a0367f7f0005daf1\\"", "size": 918775, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2022-12-14T14:13:24.000Z", "contentLength": 918775, "httpStatusCode": 200}
5a165e95-c63f-44ff-981b-2f51b807fa00	profile-pics	0xef58304e292fbaeacfdec25b67b3438031fde313/profile	\N	2022-11-20 16:25:53.15003+00	2022-11-20 16:25:53.36468+00	2022-11-20 16:25:53.15003+00	{"eTag": "\\"a1316a90b8c13137a87ca99983391eb9\\"", "size": 608213, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2022-11-20T16:25:54.000Z", "contentLength": 608213, "httpStatusCode": 200}
237184a6-cadb-4aea-bb2f-949288996a92	profile-pics	0x8d5fb8aca8294fc9a701408494288d2d7de42f7e/profile	\N	2022-11-21 23:51:41.758634+00	2022-11-21 23:51:41.986634+00	2022-11-21 23:51:41.758634+00	{"eTag": "\\"20baeff809bfdf6288fb46aa004dc429\\"", "size": 127620, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2022-11-21T23:51:42.000Z", "contentLength": 127620, "httpStatusCode": 200}
53cdf1ca-bfa0-4a30-aa25-d3052f8b4c0e	profile-pics	0x0bbac2bd3134a318deb31137d87d42bf54325cb7/profile	\N	2022-11-17 22:04:31.568709+00	2022-11-22 16:01:09.572227+00	2022-11-17 22:04:31.568709+00	{"eTag": "\\"d86af8ca461cfa6017436368108d3642\\"", "size": 49556, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2022-11-22T16:01:10.000Z", "contentLength": 49556, "httpStatusCode": 200}
c7466d2c-978c-4cd2-ae76-8d2c07e81af6	profile-pics	0xc576d28163c4ce3cccc5436708893da42dd2445c/profile	\N	2023-01-02 21:44:04.599256+00	2023-01-02 21:44:05.535335+00	2023-01-02 21:44:04.599256+00	{"eTag": "\\"b5a88a4a57ca93512acca7ceff42ed8f\\"", "size": 2792032, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2023-01-02T21:44:06.000Z", "contentLength": 2792032, "httpStatusCode": 200}
76c3a06e-05c5-492e-a11b-c63b05a28e62	profile-pics	0x40c423d16d1a9b90535cad9d54ba4a2766d066da/profile	\N	2023-01-11 14:04:01.651905+00	2023-01-11 14:04:01.932131+00	2023-01-11 14:04:01.651905+00	{"eTag": "\\"3aceddd0b3dcda52450d043b25efa834\\"", "size": 607036, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2023-01-11T14:04:02.000Z", "contentLength": 607036, "httpStatusCode": 200}
95ae1c6d-c90b-4b47-b0b1-9a230c5d9eea	profile-pics	0xd02257d9354b8d3858a6a722df920a36b38d7ef8/profile	\N	2023-01-24 19:05:22.688585+00	2023-01-24 19:05:22.918255+00	2023-01-24 19:05:22.688585+00	{"eTag": "\\"681e8bbdb615901f893b2dc3020f88ec\\"", "size": 113454, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2023-01-24T19:05:23.000Z", "contentLength": 113454, "httpStatusCode": 200}
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 1, false);


--
-- Name: comments_submissionID_seq; Type: SEQUENCE SET; Schema: public; Owner: supabase_admin
--

SELECT pg_catalog.setval('public."comments_submissionID_seq"', 1, false);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (provider, id);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: Artist_Submission_Table Artist_Submission_Table_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public."Artist_Submission_Table"
    ADD CONSTRAINT "Artist_Submission_Table_pkey" PRIMARY KEY ("submissionID");


--
-- Name: Artist_Submission_Table Artist_Submission_Table_transactionHash_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public."Artist_Submission_Table"
    ADD CONSTRAINT "Artist_Submission_Table_transactionHash_key" UNIQUE ("transactionHash");


--
-- Name: Comments_Table Comments_Table_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public."Comments_Table"
    ADD CONSTRAINT "Comments_Table_pkey" PRIMARY KEY ("commentID");


--
-- Name: Curator_Submission_Table Curator_Submission_Table_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public."Curator_Submission_Table"
    ADD CONSTRAINT "Curator_Submission_Table_pkey" PRIMARY KEY ("submissionID");


--
-- Name: Curator_Submission_Table Curator_Submission_Table_transactionHash_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public."Curator_Submission_Table"
    ADD CONSTRAINT "Curator_Submission_Table_transactionHash_key" UNIQUE ("transactionHash");


--
-- Name: Marketplace_Items_Table Marketplace_Items_Table_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public."Marketplace_Items_Table"
    ADD CONSTRAINT "Marketplace_Items_Table_pkey" PRIMARY KEY ("itemID");


--
-- Name: Playlists_Table Playlists_Table_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public."Playlists_Table"
    ADD CONSTRAINT "Playlists_Table_pkey" PRIMARY KEY ("playlistID");


--
-- Name: Playlists_Table Playlists_Table_playlistName_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public."Playlists_Table"
    ADD CONSTRAINT "Playlists_Table_playlistName_key" UNIQUE ("playlistName");


--
-- Name: Users_Table Users_Table_phloteUsername_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public."Users_Table"
    ADD CONSTRAINT "Users_Table_phloteUsername_key" UNIQUE (username);


--
-- Name: Users_Table Users_Table_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public."Users_Table"
    ADD CONSTRAINT "Users_Table_pkey" PRIMARY KEY (wallet);


--
-- Name: Users_Table Users_Table_profileEmail_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public."Users_Table"
    ADD CONSTRAINT "Users_Table_profileEmail_key" UNIQUE (email);


--
-- Name: Users_Table Users_Table_userWalletAddress_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public."Users_Table"
    ADD CONSTRAINT "Users_Table_userWalletAddress_key" UNIQUE (wallet);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY ("submissionID");


--
-- Name: comments comments_slug_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_slug_key UNIQUE (slug);


--
-- Name: users_table_duplicate users_table_duplicate_phloteUsername_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.users_table_duplicate
    ADD CONSTRAINT "users_table_duplicate_phloteUsername_key" UNIQUE (username);


--
-- Name: users_table_duplicate users_table_duplicate_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.users_table_duplicate
    ADD CONSTRAINT users_table_duplicate_pkey PRIMARY KEY (wallet);


--
-- Name: users_table_duplicate users_table_duplicate_profileEmail_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.users_table_duplicate
    ADD CONSTRAINT "users_table_duplicate_profileEmail_key" UNIQUE (email);


--
-- Name: users_table_duplicate users_table_duplicate_walletAddress_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.users_table_duplicate
    ADD CONSTRAINT "users_table_duplicate_walletAddress_key" UNIQUE (wallet);


--
-- Name: votes votes_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.votes
    ADD CONSTRAINT votes_pkey PRIMARY KEY ("commentId", "userId");


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_token_session_id; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_token_session_id ON auth.refresh_tokens USING btree (session_id);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_token_idx ON auth.refresh_tokens USING btree (token);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: Artist_Submission_Table Artist_Submission_Table_marketplaceItemID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public."Artist_Submission_Table"
    ADD CONSTRAINT "Artist_Submission_Table_marketplaceItemID_fkey" FOREIGN KEY ("marketplaceItemID") REFERENCES public."Marketplace_Items_Table"("itemID");


--
-- Name: Comments_Table Comments_Table_authorWallet_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public."Comments_Table"
    ADD CONSTRAINT "Comments_Table_authorWallet_fkey" FOREIGN KEY ("authorWallet") REFERENCES public."Users_Table"(wallet);


--
-- Name: Comments_Table Comments_Table_submissionID_artist_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public."Comments_Table"
    ADD CONSTRAINT "Comments_Table_submissionID_artist_fkey" FOREIGN KEY ("submissionID_artist") REFERENCES public."Artist_Submission_Table"("submissionID") ON DELETE CASCADE;


--
-- Name: Comments_Table Comments_Table_submissionID_curator_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public."Comments_Table"
    ADD CONSTRAINT "Comments_Table_submissionID_curator_fkey" FOREIGN KEY ("submissionID_curator") REFERENCES public."Curator_Submission_Table"("submissionID") ON DELETE CASCADE;


--
-- Name: Curator_Submission_Table Curator_Submission_Table_marketplaceItemID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public."Curator_Submission_Table"
    ADD CONSTRAINT "Curator_Submission_Table_marketplaceItemID_fkey" FOREIGN KEY ("marketplaceItemID") REFERENCES public."Marketplace_Items_Table"("itemID");


--
-- Name: comments comments_parentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT "comments_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES public.comments("submissionID");


--
-- Name: votes votes_commentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.votes
    ADD CONSTRAINT "votes_commentId_fkey" FOREIGN KEY ("commentId") REFERENCES public.comments("submissionID");


--
-- Name: buckets buckets_owner_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_owner_fkey FOREIGN KEY (owner) REFERENCES auth.users(id);


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: objects objects_owner_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_owner_fkey FOREIGN KEY (owner) REFERENCES auth.users(id);


--
-- Name: objects  Let anyone do anything 1m0cqf_0; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY " Let anyone do anything 1m0cqf_0" ON storage.objects FOR SELECT USING ((bucket_id = 'files'::text));


--
-- Name: objects  Let anyone do anything 1m0cqf_1; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY " Let anyone do anything 1m0cqf_1" ON storage.objects FOR INSERT WITH CHECK ((bucket_id = 'files'::text));


--
-- Name: objects  Let anyone do anything 1m0cqf_2; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY " Let anyone do anything 1m0cqf_2" ON storage.objects FOR UPDATE USING ((bucket_id = 'files'::text));


--
-- Name: objects  Let anyone do anything 1m0cqf_3; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY " Let anyone do anything 1m0cqf_3" ON storage.objects FOR DELETE USING ((bucket_id = 'files'::text));


--
-- Name: objects anon user can add profile pics jh40r1_0; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "anon user can add profile pics jh40r1_0" ON storage.objects FOR SELECT USING ((bucket_id = 'profile-pics'::text));


--
-- Name: objects anon user can add profile pics jh40r1_1; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "anon user can add profile pics jh40r1_1" ON storage.objects FOR INSERT WITH CHECK ((bucket_id = 'profile-pics'::text));


--
-- Name: objects anon user can add profile pics jh40r1_2; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "anon user can add profile pics jh40r1_2" ON storage.objects FOR UPDATE USING ((bucket_id = 'profile-pics'::text));


--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: supabase_admin
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO supabase_admin;

--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT ALL ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA graphql_public; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA graphql_public TO postgres;
GRANT USAGE ON SCHEMA graphql_public TO anon;
GRANT USAGE ON SCHEMA graphql_public TO authenticated;
GRANT USAGE ON SCHEMA graphql_public TO service_role;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT ALL ON SCHEMA storage TO postgres;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- Name: FUNCTION algorithm_sign(signables text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.algorithm_sign(signables text, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint) TO dashboard_user;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION sign(payload json, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.sign(payload json, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION try_cast_double(inp text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.try_cast_double(inp text) TO dashboard_user;


--
-- Name: FUNCTION url_decode(data text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.url_decode(data text) TO dashboard_user;


--
-- Name: FUNCTION url_encode(data bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.url_encode(data bytea) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- Name: FUNCTION verify(token text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.verify(token text, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION comment_directive(comment_ text); Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql.comment_directive(comment_ text) TO postgres;
GRANT ALL ON FUNCTION graphql.comment_directive(comment_ text) TO anon;
GRANT ALL ON FUNCTION graphql.comment_directive(comment_ text) TO authenticated;
GRANT ALL ON FUNCTION graphql.comment_directive(comment_ text) TO service_role;


--
-- Name: FUNCTION exception(message text); Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql.exception(message text) TO postgres;
GRANT ALL ON FUNCTION graphql.exception(message text) TO anon;
GRANT ALL ON FUNCTION graphql.exception(message text) TO authenticated;
GRANT ALL ON FUNCTION graphql.exception(message text) TO service_role;


--
-- Name: FUNCTION get_schema_version(); Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql.get_schema_version() TO postgres;
GRANT ALL ON FUNCTION graphql.get_schema_version() TO anon;
GRANT ALL ON FUNCTION graphql.get_schema_version() TO authenticated;
GRANT ALL ON FUNCTION graphql.get_schema_version() TO service_role;


--
-- Name: FUNCTION increment_schema_version(); Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql.increment_schema_version() TO postgres;
GRANT ALL ON FUNCTION graphql.increment_schema_version() TO anon;
GRANT ALL ON FUNCTION graphql.increment_schema_version() TO authenticated;
GRANT ALL ON FUNCTION graphql.increment_schema_version() TO service_role;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: postgres
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;


--
-- Name: SEQUENCE key_key_id_seq; Type: ACL; Schema: pgsodium; Owner: postgres
--

GRANT ALL ON SEQUENCE pgsodium.key_key_id_seq TO pgsodium_keyiduser;


--
-- Name: FUNCTION extension(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.extension(name text) TO anon;
GRANT ALL ON FUNCTION storage.extension(name text) TO authenticated;
GRANT ALL ON FUNCTION storage.extension(name text) TO service_role;
GRANT ALL ON FUNCTION storage.extension(name text) TO dashboard_user;
GRANT ALL ON FUNCTION storage.extension(name text) TO postgres;


--
-- Name: FUNCTION filename(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.filename(name text) TO anon;
GRANT ALL ON FUNCTION storage.filename(name text) TO authenticated;
GRANT ALL ON FUNCTION storage.filename(name text) TO service_role;
GRANT ALL ON FUNCTION storage.filename(name text) TO dashboard_user;
GRANT ALL ON FUNCTION storage.filename(name text) TO postgres;


--
-- Name: FUNCTION foldername(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.foldername(name text) TO anon;
GRANT ALL ON FUNCTION storage.foldername(name text) TO authenticated;
GRANT ALL ON FUNCTION storage.foldername(name text) TO service_role;
GRANT ALL ON FUNCTION storage.foldername(name text) TO dashboard_user;
GRANT ALL ON FUNCTION storage.foldername(name text) TO postgres;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT ALL ON TABLE auth.audit_log_entries TO postgres;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.identities TO postgres;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT ALL ON TABLE auth.instances TO postgres;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.mfa_amr_claims TO postgres;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.mfa_challenges TO postgres;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.mfa_factors TO postgres;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT ALL ON TABLE auth.refresh_tokens TO postgres;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.saml_providers TO postgres;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.saml_relay_states TO postgres;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.schema_migrations TO dashboard_user;
GRANT ALL ON TABLE auth.schema_migrations TO postgres;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.sessions TO postgres;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.sso_domains TO postgres;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.sso_providers TO postgres;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT ALL ON TABLE auth.users TO postgres;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- Name: SEQUENCE seq_schema_version; Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE graphql.seq_schema_version TO postgres;
GRANT ALL ON SEQUENCE graphql.seq_schema_version TO anon;
GRANT ALL ON SEQUENCE graphql.seq_schema_version TO authenticated;
GRANT ALL ON SEQUENCE graphql.seq_schema_version TO service_role;


--
-- Name: TABLE valid_key; Type: ACL; Schema: pgsodium; Owner: postgres
--

GRANT ALL ON TABLE pgsodium.valid_key TO pgsodium_keyiduser;


--
-- Name: TABLE "Artist_Submission_Table"; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public."Artist_Submission_Table" TO postgres;
GRANT ALL ON TABLE public."Artist_Submission_Table" TO anon;
GRANT ALL ON TABLE public."Artist_Submission_Table" TO authenticated;
GRANT ALL ON TABLE public."Artist_Submission_Table" TO service_role;


--
-- Name: TABLE "Comments_Table"; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public."Comments_Table" TO postgres;
GRANT ALL ON TABLE public."Comments_Table" TO anon;
GRANT ALL ON TABLE public."Comments_Table" TO authenticated;
GRANT ALL ON TABLE public."Comments_Table" TO service_role;


--
-- Name: TABLE "Curator_Submission_Table"; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public."Curator_Submission_Table" TO postgres;
GRANT ALL ON TABLE public."Curator_Submission_Table" TO anon;
GRANT ALL ON TABLE public."Curator_Submission_Table" TO authenticated;
GRANT ALL ON TABLE public."Curator_Submission_Table" TO service_role;


--
-- Name: TABLE "Marketplace_Items_Table"; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public."Marketplace_Items_Table" TO postgres;
GRANT ALL ON TABLE public."Marketplace_Items_Table" TO anon;
GRANT ALL ON TABLE public."Marketplace_Items_Table" TO authenticated;
GRANT ALL ON TABLE public."Marketplace_Items_Table" TO service_role;


--
-- Name: TABLE "Playlists_Table"; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public."Playlists_Table" TO postgres;
GRANT ALL ON TABLE public."Playlists_Table" TO anon;
GRANT ALL ON TABLE public."Playlists_Table" TO authenticated;
GRANT ALL ON TABLE public."Playlists_Table" TO service_role;


--
-- Name: TABLE "Users_Table"; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public."Users_Table" TO postgres;
GRANT ALL ON TABLE public."Users_Table" TO anon;
GRANT ALL ON TABLE public."Users_Table" TO authenticated;
GRANT ALL ON TABLE public."Users_Table" TO service_role;


--
-- Name: TABLE comments; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.comments TO postgres;
GRANT ALL ON TABLE public.comments TO anon;
GRANT ALL ON TABLE public.comments TO authenticated;
GRANT ALL ON TABLE public.comments TO service_role;


--
-- Name: SEQUENCE "comments_submissionID_seq"; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE public."comments_submissionID_seq" TO postgres;
GRANT ALL ON SEQUENCE public."comments_submissionID_seq" TO anon;
GRANT ALL ON SEQUENCE public."comments_submissionID_seq" TO authenticated;
GRANT ALL ON SEQUENCE public."comments_submissionID_seq" TO service_role;


--
-- Name: TABLE submissions; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.submissions TO postgres;
GRANT ALL ON TABLE public.submissions TO anon;
GRANT ALL ON TABLE public.submissions TO authenticated;
GRANT ALL ON TABLE public.submissions TO service_role;


--
-- Name: TABLE users_table_duplicate; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.users_table_duplicate TO postgres;
GRANT ALL ON TABLE public.users_table_duplicate TO anon;
GRANT ALL ON TABLE public.users_table_duplicate TO authenticated;
GRANT ALL ON TABLE public.users_table_duplicate TO service_role;


--
-- Name: TABLE votes; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.votes TO postgres;
GRANT ALL ON TABLE public.votes TO anon;
GRANT ALL ON TABLE public.votes TO authenticated;
GRANT ALL ON TABLE public.votes TO service_role;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO postgres;


--
-- Name: TABLE migrations; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.migrations TO anon;
GRANT ALL ON TABLE storage.migrations TO authenticated;
GRANT ALL ON TABLE storage.migrations TO service_role;
GRANT ALL ON TABLE storage.migrations TO postgres;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO postgres;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: pgsodium; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA pgsodium GRANT ALL ON SEQUENCES  TO pgsodium_keyiduser;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: pgsodium; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA pgsodium GRANT ALL ON TABLES  TO pgsodium_keyiduser;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO service_role;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: postgres
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE SCHEMA')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO postgres;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: postgres
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO postgres;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

