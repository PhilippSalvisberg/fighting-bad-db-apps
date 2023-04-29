create or replace package body test_employees is
   -- -----------------------------------------------------------------------------------------------------------------
   -- initial_data
   -- -----------------------------------------------------------------------------------------------------------------
   procedure initial_data is
      c_actual sys_refcursor;
   begin
      -- act
      open c_actual for select * from employees;
      
      -- assert
      ut.expect(c_actual).to_have_count(14);
   end initial_data;

   -- -----------------------------------------------------------------------------------------------------------------
   -- new_emp
   -- -----------------------------------------------------------------------------------------------------------------
   procedure new_emp is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- arrange
      insert into emp (empno, ename, job, hiredate, sal, comm, deptno)
      values (-1, 'JACEK', 'DEVELOPER', date '2023-05-01', 4500, 150, 20);
      
      -- act
      open c_actual for
         select employee_name, job, manager_employee_id, hiredate, salary, commission, department_id
           from employees
          where employee_id = -1;
      
      -- assert
      open c_expected for
         select 'JACEK' as employee_name,
                'DEVELOPER' as job,
                cast(null as number) as manager_employee_id,
                date '2023-05-01' as hiredate,
                4500 as salary,
                150 as commission,
                20 as department_id
           from dual;
      ut.expect(c_actual).to_equal(c_expected);
   end new_emp;
end test_employees;
/