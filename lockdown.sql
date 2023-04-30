set define off
set echo off
whenever sqlerror exit failure
set serveroutput on size unlimited
spool lockdown.log

prompt
prompt ================================================================================================================
prompt Start of lockdown.sql
prompt ================================================================================================================

prompt ================================================================================================================
prompt revoke all privileges from schema app (were directly granted)
prompt ================================================================================================================

begin
   for r in (
      select 'revoke '
             || privilege
             || ' from app' as revoke_stmt,
             privilege
        from dba_sys_privs
       where grantee = 'APP'
   )
   loop
      execute immediate r.revoke_stmt;
      sys.dbms_output.put_line('privilege '
         || r.privilege
         || ' revoked.');
   end loop;
end;
/

prompt ================================================================================================================
prompt remove network access for dbms_jdwp_debug
prompt ================================================================================================================

begin
   for r in (
      select host
        from dba_host_aces
       where privilege = 'JDWP'
         and principal = 'APP'
         and grant_type = 'GRANT'
   )
   loop
      sys.dbms_network_acl_admin.REMOVE_HOST_ACE(
         host => r.host,
         ace  => sys.xs$ace_type(
                    privilege_list => sys.xs$name_list('JDWP'),
                    principal_name => 'APP',
                    principal_type => sys.xs_acl.ptype_db
                 )
      );
      sys.dbms_output.put_line('network access revoked from app.');
   end loop;
end;
/

prompt ================================================================================================================
prompt drop users not required in production
prompt ================================================================================================================

declare
   e_user_does_not_exist exception;
   pragma exception_init(e_user_does_not_exist, -1918);
   --
   procedure drop_user(in_user in varchar2) is
   begin
      execute immediate 'drop user '
         || sys.dbms_assert.simple_sql_name(in_user)
         || ' cascade';
      sys.dbms_output.put_line(in_user || ' dropped.');
   exception
      when e_user_does_not_exist then
          sys.dbms_output.put_line(in_user || ' does not exist.');
   end drop_user;
begin
   drop_user('app_tester');
   drop_user('developer');
end;
/

prompt ================================================================================================================
prompt drop utPLSQL tests in schema app
prompt ================================================================================================================

begin
   for r in (
      select 'drop package app.'
             || object_name as drop_package_stmt,
             object_name
        from dba_objects
       where owner = 'APP'
         and object_type = 'PACKAGE'
         and object_name like 'TEST\_%' escape '\'
   )
   loop
      execute immediate r.drop_package_stmt;
      sys.dbms_output.put_line('test package '
         || r.object_name
         || ' dropped.');
   end loop;
end;
/

prompt ================================================================================================================
prompt recompile remaining, invalid packages in schema app
prompt ================================================================================================================

begin
   for r in (
      select 'alter package '
             || object_name
             || ' compile specification' as compile_stmt,
             object_type,
             object_name
        from dba_objects
       where owner = 'APP'
         and object_type = 'PACKAGE'
         and status != 'VALID'
      union all
      select 'alter package '
             || object_name
             || ' compile body' as compile_stmt,
             object_type,
             object_name
        from dba_objects
       where owner = 'APP'
         and object_type = 'PACKAGE BODY'
         and status != 'VALID'
   )
   loop
      execute immediate r.compile_stmt;
      sys.dbms_output.put_line('package '
         || r.object_type
         || ' '
         || r.object_name
         || ' compiled.');
   end loop;
end;
/

prompt
prompt ================================================================================================================
prompt End of lockdown.sql
prompt ================================================================================================================

prompt done.

spool off;
