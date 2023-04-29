-- called from install.sql, hence no dedicated spool file

prompt
prompt ================================================================================================================
prompt APP: test package specifications (from install_test.sql)
prompt ================================================================================================================

prompt test_pinkdb.pks...
@src/test/app/package/test_pinkdb.pks

prompt
prompt ================================================================================================================
prompt APP: test package bodies (from install_test.sql)
prompt ================================================================================================================

prompt test_pinkdb.pkb...
@src/test/app/package/test_pinkdb.pkb
