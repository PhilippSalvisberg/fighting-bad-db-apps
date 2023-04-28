declare
   co_prod_instance_name constant varchar2(30 char) := 'PROD';
   e_user_exists         exception;
   pragma exception_init(e_user_exists, -1920);
begin
   <<create_user>>
   begin
      if sys_context('userenv', 'instance_name') != co_prod_instance_name then
         -- create user if not exists...
         execute immediate q'[
            create user app_tester identified by app_tester
               --password expire
               default tablespace users
               quota unlimited on users
         ]';
         sys.dbms_output.put_line('user created.');
      end if;
   exception
      when e_user_exists then
         sys.dbms_output.put_line('user already exists.');
   end create_user;
   <<grant_privs>>
   begin
      if sys_context('userenv', 'instance_name') != co_prod_instance_name then
         -- default privileges
         execute immediate 'grant create session to app_tester';
         -- make developer a proxy user, connect with developer[demoapp] to become demoapp
         execute immediate 'alter user app grant connect through app_tester';
         sys.dbms_output.put_line('privileges granted.');
      end if;
   end grant_privs;
end;
/