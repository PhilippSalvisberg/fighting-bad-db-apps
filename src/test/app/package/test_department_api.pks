create or replace package test_departement_api is
   --%suite
   --%suitepath(app.api.pkg)

   --%test
   procedure ins;

   --%test
   procedure upd;

   --%test
   procedure del;
end test_departement_api;
/
