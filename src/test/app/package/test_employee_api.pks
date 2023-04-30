create or replace package test_employee_api is
   --%suite
   --%suitepath(app.api.pkg)

   --%test
   procedure ins;

   --%context(upd)

   --%test
   procedure set_name;

   --%context(job)

   --%test
   procedure set_job;

   --%test
   --%throws(value_error, -12899)
   procedure set_job_too_long; 
   
   --%test
   procedure set_job_try_sqli;

   --%test
   --%throws(value_error, -12899)
   procedure set_job_try_sqli_too_long;
   
   --%endcontext

   --%test
   procedure set_hiredate;

   --%test
   procedure set_department;

   --%test
   procedure set_manager;

   --%test
   procedure set_salary;

   --%test
   procedure set_commission;

   --%endcontext

   --%test
   procedure del;
end test_employee_api;
/
