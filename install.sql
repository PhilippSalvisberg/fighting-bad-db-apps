set echo off
set define off
set sqlblanklines on
set verify off
set feedback off
whenever sqlerror exit failure
set serveroutput on size unlimited
spool install.log

prompt
prompt ================================================================================================================
prompt Start of install.sql
prompt ================================================================================================================

prompt
prompt ================================================================================================================
prompt SYS: roles
prompt ================================================================================================================

prompt api_role.sql...
@src/main/sys/role/api_role.sql

prompt
prompt ================================================================================================================
prompt SYS: schemas
prompt ================================================================================================================

prompt app.sql...
@src/main/sys/schema/app.sql

prompt
prompt ================================================================================================================
prompt SYS: technical users
prompt ================================================================================================================

prompt app_connect.sql...
@src/main/sys/user/app_connect.sql

prompt app_tester.sql...
@src/main/sys/user/app_tester.sql

prompt
prompt ================================================================================================================
prompt SYS: real users
prompt ================================================================================================================

prompt developer.sql...
@src/main/sys/user/developer.sql

prompt
prompt *****************************************************************************************************************
prompt APP
prompt *****************************************************************************************************************

prompt alter session set current_schema = app...
alter session set current_schema = app;

prompt
prompt ================================================================================================================
prompt APP: tables
prompt ================================================================================================================

prompt dept.sql...
@src/main/app/table/dept.sql

prompt emp.sql...
@src/main/app/table/emp.sql

prompt
prompt ================================================================================================================
prompt APP: views
prompt ================================================================================================================

prompt departments.sql...
@src/main/app/view/departments.sql

prompt employees.sql...
@src/main/app/view/employees.sql

prompt department_salaries.sql...
@src/main/app/view/department_salaries.sql

prompt
prompt ================================================================================================================
prompt APP: initial data load
prompt ================================================================================================================

prompt load_dept.sql...
@src/main/app/data/load_dept.sql

prompt load_dept.sql...
@src/main/app/data/load_emp.sql


prompt
prompt ================================================================================================================
prompt APP: package specifications
prompt ================================================================================================================

prompt department_api.pks...
@src/main/app/package/department_api.pks

prompt employee_api.pks...
@src/main/app/package/employee_api.pks

prompt
prompt ================================================================================================================
prompt APP: package bodies
prompt ================================================================================================================

prompt department_api.pkb...
@src/main/app/package/department_api.pkb

prompt employee_api.pkb...
@src/main/app/package/employee_api.pkb

prompt
prompt ================================================================================================================
prompt APP: grants
prompt ================================================================================================================

prompt grant_api.sql...
@src/main/app/grant/grant_api.sql

prompt
prompt ================================================================================================================
prompt APP: synonyms
prompt ================================================================================================================

prompt public_synonyms_api.sql...
@src/main/app/synonym/public_synonyms_api.sql

prompt
prompt ================================================================================================================
prompt APP: utPLSQL tests (in non-production environments only)
prompt ================================================================================================================

set define on
define script_name=install_test.sql
column script_name noprint new_value script_name
select 'noop.sql' as script_name
  from dual
 where sys_context('userenv', 'instance_name') = 'PROD';

prompt &&script_name...
@&script_name
set define off

prompt
prompt ================================================================================================================
prompt End of install.sql
prompt ================================================================================================================

prompt done.

set define on
set feedback on
set verify on
set echo on
