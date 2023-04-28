create or replace view department_salaries as
   select d.deptno department_id,
          d.dname as department_name,
          coalesce(sum(e.sal), 0) as salary,
          coalesce(count(e.empno), 0) as number_of_employees
     from dept d
     left join emp e
       on e.deptno = d.deptno
    group by d.deptno, d.dname;
