create or replace package body employee_api is
   procedure ins(
      in_employee_id   in integer,
      in_employee_name in varchar2,
      in_job           in varchar2,
      in_hiredate      in date,
      in_department_id in integer
   ) is
   begin
      insert into emp(empno, ename, job, hiredate, deptno)
      values(in_employee_id, in_employee_name, in_job, in_hiredate, in_department_id);
   end ins;

   procedure upd_col(
      in_employee_id in integer,
      in_column_name in varchar2,
      in_value       in varchar2
   ) is
      co_templ constant clob := q'[update emp set #col# = :value where empno = :empno]';
      l_sql    clob;
   begin
      l_sql := replace(co_templ, '#col#', sys.dbms_assert.sql_object_name(in_column_name));
      execute immediate l_sql using in_value, in_employee_id;
   end upd_col;

   procedure set_name(
      in_employee_id   in integer,
      in_employee_name in varchar2
   ) is
   begin
      upd_col(
         in_employee_id => in_employee_id,
         in_column_name => 'empno',
         in_value       => in_employee_id
      );
   end set_name;

   procedure set_job(
      in_employee_id in integer,
      in_job         in varchar2
   ) is
   begin
      upd_col(
         in_employee_id => in_employee_id,
         in_column_name => 'job',
         in_value       => in_job
      );
   end set_job;

   procedure set_hiredate(
      in_employee_id in integer,
      in_hiredate    in date
   ) is
   begin
      update emp
         set hiredate = in_hiredate
       where empno = in_employee_id;
   end set_hiredate;

   procedure set_department(
      in_employee_id   in integer,
      in_department_id in integer
   ) is
   begin
      upd_col(
         in_employee_id => in_employee_id,
         in_column_name => 'deptno',
         in_value       => in_department_id
      );
   end set_department;

   procedure set_manager(
      in_employee_id         in integer,
      in_manager_employee_id in integer
   ) is
   begin
      upd_col(
         in_employee_id => in_employee_id,
         in_column_name => 'mgr',
         in_value       => in_manager_employee_id
      );
   end set_manager;

   procedure set_salary(
      in_employee_id in integer,
      in_salary      in number
   ) is
   begin
      upd_col(
         in_employee_id => in_employee_id,
         in_column_name => 'sal',
         in_value       => in_salary
      );
   end set_salary;

   procedure set_commission(
      in_employee_id in integer,
      in_commission  in number
   ) is
   begin
      upd_col(
         in_employee_id => in_employee_id,
         in_column_name => 'comm',
         in_value       => in_commission
      );
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