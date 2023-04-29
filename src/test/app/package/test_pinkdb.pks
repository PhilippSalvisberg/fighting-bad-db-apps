create or replace package test_pinkdb is
   --%suite
   --%suitepath(pinkdb)

   --%test
   procedure app_schema_privileges;

   --%test
   procedure connect_user_privileges;
   
   --%test
   procedure connect_user_objects;

   --%test
   procedure connect_direct_object_privs;
   
   --%test
   procedure api_role_object_privs;   
end test_pinkdb;
/
