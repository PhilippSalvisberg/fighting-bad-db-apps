-- create role if not exists api_role
declare
   e_role_exists exception;
   pragma exception_init(e_role_exists, -1921);
begin
   execute immediate 'create role api_role';
   sys.dbms_output.put_line('role api_role created.');
exception
   when e_role_exists then
      sys.dbms_output.put_line('role api_role already exists.');
end;
/
