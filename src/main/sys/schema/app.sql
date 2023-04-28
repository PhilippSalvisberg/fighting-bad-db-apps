-- create user if not exists app no authentication...
declare
   e_user_exists exception;
   pragma exception_init(e_user_exists, -1920);
begin
   execute immediate q'[
      create user app no authentication
         default tablespace users
         quota unlimited on users
   ]';
   sys.dbms_output.put_line('schema created.');
exception
   when e_user_exists then
      sys.dbms_output.put_line('schema already exists.');
end;
/

-- connect
-- create session is also required for schema-only accounts
grant create session to app;

-- data (no sequences required in this app)
grant create table to app;

-- code (no trigger, types required in this app)
grant create procedure to app;
grant create view to app;

-- API
-- managing public synonyms, used for API
-- there is no out-of-the-box way to restrict the privilege to own objects
grant create public synonym to app;
grant drop public synonym to app;

-- privileges for non-production environments
declare
   co_prod_instance_name constant varchar2(30 char) := 'PROD';
   --
   function is_rac return boolean is
      l_found integer;
   begin
      select count(*)
        into l_found
        from v$instance
       where database_type = 'RAC';
      return l_found > 0;
   end is_rac;
begin
   if sys_context('userenv', 'instance_name') != co_prod_instance_name then
      -- privilege required for tests only
      execute immediate 'grant select any dictionary to app';
      -- debugging privileges required for dbms_debug and dbms_jdwp_debug
      execute immediate 'grant debug connect session to app';
      -- required only when debugging code of other schemas, e.g. utPLSQL
      execute immediate 'grant debug any procedure to app';
      sys.dbms_output.put_line('debug privileges granted.');
      if not is_rac() then
         -- we assume that a RAC instance is running in the OracleCloud where we cannot dbms_jdwp_debug
         sys.dbms_network_acl_admin.append_host_ace(
            host => '*',
            ace  => sys.xs$ace_type(
                       privilege_list => sys.xs$name_list('JDWP'),
                       principal_name => 'APP',
                       principal_type => sys.xs_acl.ptype_db
                    )
         );
         sys.dbms_output.put_line('network access granted.');
      end if;
   end if;
end;
/
