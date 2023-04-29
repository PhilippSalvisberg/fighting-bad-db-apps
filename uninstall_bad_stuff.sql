set echo off
set define off
set sqlblanklines on
set verify off
set feedback off
whenever sqlerror exit failure
set serveroutput on size unlimited
spool uninstall_bad_stuff.log

prompt
prompt ================================================================================================================
prompt Start of uninstall_bad_stuff.sql
prompt ================================================================================================================

prompt
prompt ================================================================================================================
prompt SYS: revoke unnecessary privileges from app schema
prompt ================================================================================================================

declare
   e_priv_not_granted exception;
   pragma exception_init(e_priv_not_granted, -1952);
begin
   execute immediate 'revoke select any table from app';
   sys.dbms_output.put_line('select any table privilege revoked.');
exception
   when e_priv_not_granted then
      sys.dbms_output.put_line('select any table privilege not granted.');
end;
/

prompt
prompt ================================================================================================================
prompt SYS: revoke DBA privileges from app_connect
prompt ================================================================================================================

declare
   e_role_not_granted exception;
   pragma exception_init(e_role_not_granted, -1951);
begin
   execute immediate 'revoke dba from app_connect';
   sys.dbms_output.put_line('dba role revoked.');
exception
   when e_role_not_granted then
      sys.dbms_output.put_line('dba role was not granted.');
end;
/

prompt
prompt ================================================================================================================
prompt SYS: revoke unnecessary object privileges from app_connect
prompt ================================================================================================================

-- does not fail if there is nothing to revoke
revoke all on app.emp from app_connect;

-- requires SYSDBA rights to succeed, normal DBA does not see the grant
declare
   e_priv_not_granted exception;
   pragma exception_init(e_priv_not_granted, -1927);
begin
   execute immediate 'revoke execute on sys.dbms_sys_sql from app_connect';
   sys.dbms_output.put_line('execute privilage on sys.dbms_sys_sql revoked.');
exception
   when e_priv_not_granted then
      sys.dbms_output.put_line('privilage on sys.dbms_sys_sql was not granted.');
end;
/

prompt
prompt ================================================================================================================
prompt SYS: revoke unnecessary object privileges from api_role
prompt ================================================================================================================

-- does not fail if there is nothing to revoke
revoke all on app.dept from api_role;

-- requires SYSDBA rights to succeed, normal DBA does not see the grant
declare
   e_priv_not_granted exception;
   pragma exception_init(e_priv_not_granted, -1927);
begin
   execute immediate 'revoke execute on sys.dbms_sys_sql from api_role';
   sys.dbms_output.put_line('execute privilage on sys.dbms_sys_sql revoked.');
exception
   when e_priv_not_granted then
      sys.dbms_output.put_line('privilage on sys.dbms_sys_sql was not granted.');
end;
/

prompt
prompt ================================================================================================================
prompt SYS: drop table in app_connect
prompt ================================================================================================================

declare
   e_table_not_exists exception;
   pragma exception_init(e_table_not_exists, -942);
begin
   execute immediate 'drop table app_connect.emp';
   sys.dbms_output.put_line('table app_connect.dept dropped.');
exception
   when e_table_not_exists then
      sys.dbms_output.put_line('table app_connect.dept does not exist.');
end;
/

prompt
prompt ================================================================================================================
prompt SYS: fix SQL injection vulnerability in API package
prompt ================================================================================================================

prompt employee_api.pkb...
@src/main/app/package/employee_api.pkb

prompt
prompt ================================================================================================================
prompt End of uninstall_bad_stuff.sql
prompt ================================================================================================================

prompt done.

set define on
set feedback on
set verify on
set echo on
