create or replace view departments as
   select deptno department_id,
          dname as department_name,
          loc as location
     from dept;
