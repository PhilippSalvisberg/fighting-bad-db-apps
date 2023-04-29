create or replace package test_employees is
   --%suite
   --%suitepath(app.api.view)

   --%test
   procedure initial_data;

   --%test
   procedure new_emp;
end test_employees;
/