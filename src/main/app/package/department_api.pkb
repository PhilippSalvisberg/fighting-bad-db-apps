create or replace package body department_api is
   procedure ins(
      in_department_id   in integer,
      in_department_name in varchar2,
      in_location        in varchar2
   ) is
      co_deptno constant dept.deptno%type := in_department_id;
      co_dname  constant dept.dname%type  := in_department_name;
      co_loc    constant dept.loc%type    := in_location;
   begin
      insert into dept(deptno, dname, loc)
      values (co_deptno, co_dname, co_loc);
   end ins;

   procedure upd(
      in_department_id   in integer,
      in_department_name in varchar2,
      in_location        in varchar2
   ) is
      co_deptno constant dept.deptno%type := in_department_id;
      co_dname  constant dept.dname%type  := in_department_name;
      co_loc    constant dept.loc%type    := in_location;
   begin
      update dept
         set dname = co_dname,
             loc = co_loc
       where deptno = co_deptno;
   end upd;

   procedure del(
      in_department_id in integer
   ) is
      co_deptno constant dept.deptno%type := in_department_id;
   begin
      delete from dept where deptno = co_deptno;
   end del;
end department_api;
/