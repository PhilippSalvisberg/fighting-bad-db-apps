create or replace view employees as
   select empno as employee_id,
          ename as employee_name,
          job as job,
          mgr as manager_employee_id,
          hiredate as hiredate,
          sal as salary,
          comm as commission,
          deptno as department_id
     from emp;