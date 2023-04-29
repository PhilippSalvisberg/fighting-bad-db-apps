create or replace package test_departement_salaries is
   --%suite
   --%suitepath(app.api.view)

   --%test
   procedure initial_data;

   --%test
   procedure new_dept_and_emps;
end test_departement_salaries;
/
