create or replace package body test_departement_salaries is
   -- -----------------------------------------------------------------------------------------------------------------
   -- initial_data
   -- -----------------------------------------------------------------------------------------------------------------
   procedure initial_data is
      c_actual sys_refcursor;
   begin
      -- act
      open c_actual for select * from department_salaries;
      
      -- assert
      ut.expect(c_actual).to_have_count(4);
   end initial_data;

   -- -----------------------------------------------------------------------------------------------------------------
   -- new_dept_and_emps
   -- -----------------------------------------------------------------------------------------------------------------
   procedure new_dept_and_emps is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- arrange
      insert into dept (deptno, dname, loc) values (-1, 'utPLSQL', 'Winterthur');
      insert into emp (empno, ename, job, hiredate, sal, comm, deptno)
      values (-1, 'JACEK', 'DEVELOPER', date '2023-05-01', 4500, 150, -1);
      insert into emp (empno, ename, job, hiredate, sal, comm, deptno)
      values (-2, 'SAM', 'DEVELOPER', date '2023-04-01', 4300, 250, -1);
      
      -- act
      open c_actual for
         select department_name, salary, number_of_employees
           from department_salaries
          where department_id = -1;
      
      -- assert
      open c_expected for
         select 'utPLSQL' as department_name, 8800 as salary, 2 as number_of_employees
           from dual;
      ut.expect(c_actual).to_equal(c_expected);
   end new_dept_and_emps;
end test_departement_salaries;
/
