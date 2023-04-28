create or replace package body employee_api is
   procedure ins(
      in_employee_id   in integer,
      in_employee_name in varchar2,
      in_job           in varchar2,
      in_hiredate      in date,
      in_department_id in integer
   ) is
      co_empno    constant emp.empno%type    := in_employee_id;
      co_ename    constant emp.ename%type    := in_employee_name;
      co_job      constant emp.job%type      := in_job;
      co_hiredate constant emp.hiredate%type := in_hiredate;
      co_deptno   constant emp.deptno%type   := in_department_id;
   begin
      insert into emp(empno, ename, job, hiredate, deptno)
      values(co_empno, co_ename, co_job, co_hiredate, co_deptno);
   end ins;

   procedure set_name(
      in_employee_id   in integer,
      in_employee_name in varchar2
   ) is
      co_empno constant emp.empno%type := in_employee_id;
      co_ename constant emp.ename%type := in_employee_name;
   begin
      update emp
         set ename = co_ename
       where empno = co_empno;
   end set_name;

   procedure set_job(
      in_employee_id in integer,
      in_job         in varchar2
   ) is
      co_empno constant emp.empno%type := in_employee_id;
      co_job   constant emp.job%type   := in_job;
   begin
      update emp
         set job = co_job
       where empno = co_empno;
   end set_job;

   procedure set_hiredate(
      in_employee_id in integer,
      in_hiredate    in date
   ) is
      co_empno    constant emp.empno%type    := in_employee_id;
      co_hiredate constant emp.hiredate%type := in_hiredate;
   begin
      update emp
         set hiredate = co_hiredate
       where empno = co_empno;
   end set_hiredate;

   procedure set_department(
      in_employee_id   in integer,
      in_department_id in integer
   ) is
      co_empno  constant emp.empno%type  := in_employee_id;
      co_deptno constant emp.deptno%type := in_department_id;
   begin
      update emp
         set deptno = co_deptno
       where empno = co_empno;
   end set_department;

   procedure set_manager(
      in_employee_id         in integer,
      in_manager_employee_id in integer
   ) is
      co_empno constant emp.empno%type := in_employee_id;
      co_mgr   constant emp.mgr%type   := in_manager_employee_id;
   begin
      update emp
         set mgr = co_mgr
       where empno = co_empno;
   end set_manager;

   procedure set_salary(
      in_employee_id in integer,
      in_salary      in number
   ) is
      co_empno constant emp.empno%type := in_employee_id;
      co_sal   constant emp.sal%type   := in_salary;
   begin
      update emp
         set sal = co_sal
       where empno = co_empno;
   end set_salary;

   procedure set_commission(
      in_employee_id in integer,
      in_commission  in number
   ) is
      co_empno constant emp.empno%type := in_employee_id;
      co_comm  constant emp.sal%type   := in_commission;
   begin
      update emp
         set comm = co_comm
       where empno = co_empno;
   end set_commission;

   procedure del(
      in_employee_id in integer
   ) is
      co_empno constant emp.empno%type := in_employee_id;
   begin
      delete from emp where empno = co_empno;
   end del;
end employee_api;
/