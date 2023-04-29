-- called from install.sql, hence no dedicated spool file

prompt
prompt ================================================================================================================
prompt APP: test package specifications (from install_test.sql)
prompt ================================================================================================================

prompt test_pinkdb.pks...
@src/test/app/package/test_pinkdb.pks

prompt test_departments.pks...
@src/test/app/package/test_departments.pks

prompt test_employees.pks...
@src/test/app/package/test_employees.pks

prompt test_department_salaries.pks...
@src/test/app/package/test_department_salaries.pks

prompt test_department_api.pks...
@src/test/app/package/test_department_api.pks

prompt test_employee_api.pks...
@src/test/app/package/test_employee_api.pks

prompt
prompt ================================================================================================================
prompt APP: test package bodies (from install_test.sql)
prompt ================================================================================================================

prompt test_pinkdb.pkb...
@src/test/app/package/test_pinkdb.pkb

prompt test_departments.pkb...
@src/test/app/package/test_departments.pkb

prompt test_employees.pkb...
@src/test/app/package/test_employees.pkb

prompt test_department_salaries.pkb...
@src/test/app/package/test_department_salaries.pkb

prompt test_department_api.pkb...
@src/test/app/package/test_department_api.pkb

prompt test_employee_api.pkb...
@src/test/app/package/test_employee_api.pkb
