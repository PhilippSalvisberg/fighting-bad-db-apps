set echo off
set define off
set sqlblanklines on
set verify off
set feedback off
whenever sqlerror exit failure
set serveroutput on size unlimited
spool install_bad_stuff.log

prompt
prompt ================================================================================================================
prompt Start of install_bad_stuff.sql
prompt ================================================================================================================

prompt
prompt ================================================================================================================
prompt SYS: grant unnecessary privileges to app schema
prompt ================================================================================================================

grant select any table to app;

prompt
prompt ================================================================================================================
prompt SYS: grant DBA privileges to app_connect
prompt ================================================================================================================

grant dba to app_connect;

prompt
prompt ================================================================================================================
prompt SYS: grant unnecessary object privileges to app_connect
prompt ================================================================================================================

grant all on app.emp to app_connect;

-- requires SYSDBA to succeed, ignore error
declare
   e_table_not_exists exception;
   pragma exception_init(e_table_not_exists, -942);
begin
   execute immediate 'grant execute on sys.dbms_sys_sql to app_connect';
   sys.dbms_output.put_line('granted execute rights on sys.dbms_sys_sql.');
exception
   when e_table_not_exists then
      sys.dbms_output.put_line('sys.dbms_sql does not exist (not SYSDBA).');
end;
/

/* example call, one of the most powerful package procedure in the Oracle Database:
declare
   l_handle integer;
   l_result integer;
   l_userid integer;
begin
   l_handle := sys.dbms_sys_sql.open_cursor;
   sys.dbms_sys_sql.parse_as_user(
      c             => l_handle,
      statement     => 'grant execute on sys.dbms_sys_sql to developer',
      language_flag => dbms_sql.native,
      username      => 'SYS'
   );
   l_result := sys.dbms_sys_sql.execute(l_handle);
   sys.dbms_sys_sql.close_cursor(l_handle);
end;
/
*/

prompt
prompt ================================================================================================================
prompt SYS: grant unnecessary object privileges to api_role
prompt ================================================================================================================

grant all on app.dept to api_role;

-- requires SYSDBA to succeed, ignore error
declare
   e_table_not_exists exception;
   pragma exception_init(e_table_not_exists, -942);
begin
   execute immediate 'grant execute on sys.dbms_sys_sql to api_role';
   sys.dbms_output.put_line('granted execute rights on sys.dbms_sys_sql.');
exception
   when e_table_not_exists then
      sys.dbms_output.put_line('sys.dbms_sql does not exist (not SYSDBA).');
end;
/

prompt
prompt ================================================================================================================
prompt SYS: create table in app_connect
prompt ================================================================================================================

declare
   e_table_exists exception;
   pragma exception_init(e_table_exists, -955);
begin
   execute immediate 'create table app_connect.emp as select * from app.dept';
   sys.dbms_output.put_line('table app_connect.dept created.');
exception
   when e_table_exists then
      sys.dbms_output.put_line('table app_connect.dept already exists.');
end;
/

prompt
prompt ================================================================================================================
prompt SYS: create SQL injection vulnerability in API package
prompt ================================================================================================================

prompt employee_api_sqli.pkb...
@src/main/app/package/alternatives/employee_api_sqli.pkb

prompt
prompt ================================================================================================================
prompt End of install_bad_stuff.sql
prompt ================================================================================================================

prompt done.

set define on
set feedback on
set verify on
set echo on
