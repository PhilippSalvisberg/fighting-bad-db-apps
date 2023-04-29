set define off
set echo off
whenever sqlerror exit failure
set serveroutput on size unlimited
spool uninstall.log

prompt ================================================================================================================
prompt safe guard, ensure script fails production
prompt ================================================================================================================

declare
   co_prod_instance_name constant varchar2(30 char) := 'PROD';
   e_user_exists         exception;
   pragma exception_init(e_user_exists, -1920);
begin
   if sys_context('userenv', 'instance_name') = co_prod_instance_name then
      raise_application_error(-20501, 'Disable this check if you want to run uninstallin in '
         || co_prod_instance_name || '.');
   end if;
end;
/

prompt ================================================================================================================
prompt drop roles
prompt ================================================================================================================

declare
   e_role_does_not_exist exception;
   pragma exception_init(e_role_does_not_exist, -1919);
   --
   procedure drop_role(in_role in varchar2) is
   begin
      execute immediate 'drop role ' || sys.dbms_assert.simple_sql_name(in_role);
   exception
      when e_role_does_not_exist then
         null;
   end drop_role;
begin
   drop_role('api_role');
end;
/

prompt ================================================================================================================
prompt drop users
prompt ================================================================================================================

declare
   e_user_does_not_exist exception;
   pragma exception_init(e_user_does_not_exist, -1918);
   --
   procedure drop_user(in_user in varchar2) is -- NOSONAR: G-8310
   begin
      execute immediate 'drop user ' -- NOSONAR: G-6010
         || sys.dbms_assert.simple_sql_name(in_user)
         || ' cascade';
      sys.dbms_output.put_line(in_user || ' dropped.');
   exception
      when e_user_does_not_exist then
          sys.dbms_output.put_line(in_user || ' does not exist.');
   end drop_user;
begin
   drop_user('app');
   drop_user('app_connect');
   drop_user('app_tester');
   drop_user('developer');
end;
/

prompt ================================================================================================================
prompt drop public synonyms referring to objects in app schema 
prompt ================================================================================================================

declare
   procedure drop_public_synonym(in_synonym_name in varchar2) is
   begin
      execute immediate 'drop public synonym ' || sys.dbms_assert.simple_sql_name(in_synonym_name);
      sys.dbms_output.put_line('public synonym ' || in_synonym_name || ' dropped.');
   end drop_public_synonym;
begin
   <<drop_public_syonyms>>
   for r in (
      select synonym_name from dba_synonyms where table_owner in ('APP')
   )
   loop
      drop_public_synonym(r.synonym_name);
   end loop drop_public_syonyms;
end;
/

spool off
