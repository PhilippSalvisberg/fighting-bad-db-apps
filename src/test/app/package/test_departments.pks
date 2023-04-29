create or replace package test_departements is
   --%suite
   --%suitepath(app.api.view)

   --%test
   procedure initial_data;

   --%test
   procedure new_dept;
end test_departements;
/