CREATE SCHEMA IF NOT EXISTS pgbouncer; 

CREATE OR REPLACE FUNCTION pgbouncer.lookup(p_username text) 
RETURNS TABLE(username text, password text) LANGUAGE sql 
SECURITY DEFINER SET search_path = pg_catalog, pg_temp 
AS $$ 
  SELECT rolname::text AS username, rolpassword::text AS password FROM pg_authid WHERE rolname = p_username;
$$;

CREATE ROLE pgbouncer LOGIN PASSWORD '${PGBOUNCER_PWD}';

REVOKE ALL ON FUNCTION pgbouncer.lookup(text) FROM PUBLIC;

GRANT CONNECT ON DATABASE postgres TO pgbouncer;
GRANT USAGE ON SCHEMA pgbouncer TO pgbouncer;
GRANT EXECUTE ON FUNCTION pgbouncer.lookup(text) TO pgbouncer;
