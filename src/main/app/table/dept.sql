-- create table if not exists dept...
declare
   e_table_exists exception;
   pragma exception_init(e_table_exists, -955);
begin
   execute immediate q'[
      create table dept (
         deptno number(2, 0) not null constraint dept_pk primary key,
         dname  varchar2(14 char) not null,
         loc    varchar2(13 char) not null
      )
   ]';
   sys.dbms_output.put_line('table dept created.');
exception
   when e_table_exists then
      sys.dbms_output.put_line('table dept already exists.');
end;
/
