CREATE SCHEMA IF NOT EXISTS pgbouncer; 

CREATE OR REPLACE FUNCTION pgbouncer.lookup(p_username text) RETURNS TABLE(username text, password text) LANGUAGE
sql SECURITY DEFINER SET search_path = pg_catalog, pg_temp AS $$ SELECT rolname::text AS username, rolpassword::text AS password FROM pg_authid WHERE rolname =
p_username; $$;

REVOKE ALL ON FUNCTION pgbouncer.lookup(text) FROM PUBLIC;


CREATE ROLE pgbouncer_auth_user LOGIN PASSWORD '';
CREATE ROLE pgbouncer_admin LOGIN PASSWORD '';
CREATE ROLE pgbouncer_stats LOGIN PASSWORD '';


GRANT EXECUTE ON FUNCTION pgbouncer.lookup(text) TO pgbouncer_auth_user;
