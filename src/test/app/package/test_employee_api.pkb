create or replace package body test_employee_api is
   -- -----------------------------------------------------------------------------------------------------------------
   -- ins
   -- -----------------------------------------------------------------------------------------------------------------
   procedure ins is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- act
      employee_api.ins(
         in_employee_id   => -1,
         in_employee_name => 'JACEK',
         in_job           => 'DEVELOPER',
         in_hiredate      => date '2023-05-01',
         in_department_id => 20
      );
      
      -- assert
      open c_actual for
         select ename, job, hiredate, deptno
           from emp
          where empno = -1;
      open c_expected for
         select 'JACEK' as ename, 'DEVELOPER' as job, date '2023-05-01' as hiredate, 20 as deptno
           from dual;
      ut.expect(c_actual).to_equal(c_expected);
   end ins;

   -- -----------------------------------------------------------------------------------------------------------------
   -- set_name
   -- -----------------------------------------------------------------------------------------------------------------
   procedure set_name is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- arrange
      ins;
      
      -- act
      employee_api.set_name(
         in_employee_id   => -1,
         in_employee_name => 'Jacek'
      );

      -- assert
      open c_actual for select ename from emp where empno = -1;
      open c_expected for select 'Jacek' as ename from dual;
      ut.expect(c_actual).to_equal(c_expected);
   end set_name;

   -- -----------------------------------------------------------------------------------------------------------------
   -- set_job
   -- -----------------------------------------------------------------------------------------------------------------
   procedure set_job is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- arrange
      ins;
      
      -- act
      employee_api.set_job(
         in_employee_id => -1,
         in_job         => 'Developer'
      );

      -- assert
      open c_actual for select job from emp where empno = -1;
      open c_expected for select 'Developer' as job from dual;
      ut.expect(c_actual).to_equal(c_expected);
   end set_job;

   -- -----------------------------------------------------------------------------------------------------------------
   -- set_job_too_long
   -- -----------------------------------------------------------------------------------------------------------------
   procedure set_job_too_long is
   begin
      -- arrange
      ins;
      
      -- act
      employee_api.set_job(
         in_employee_id => -1,
         in_job         => 'Senior Developer'
      );
      
      -- assert
      -- expected exceptions:
      -- - ORA-06502: PL/SQL: numeric or value error: character string buffer too small (value_error) with employee_api.pkb 
      -- - ORA-12899: value too large for column "APP"."EMP"."JOB" (actual: 16, maximum: 9) 
      --   with employee_api_sqli.pkb and employee_api_sqli_fixed.pkb
      ut.fail('Runtime exception expected.');
   end set_job_too_long;

   -- -----------------------------------------------------------------------------------------------------------------
   -- set_job_try_sqli
   -- -----------------------------------------------------------------------------------------------------------------
   procedure set_job_try_sqli is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- arrange
      set_salary;
      
      -- act: SQL injection
      employee_api.set_job(
         in_employee_id => -1, -- JACEK
         in_job         => q'[S',sal='9]' -- try to set job to 'S' and sal to 9
      );

      -- assert
      open c_actual for select job, sal from emp where empno = -1;
      open c_expected for select q'[S',sal='9]' as job, 4700 as sal from dual;
      ut.expect(c_actual).to_equal(c_expected);
   end set_job_try_sqli;

   -- -----------------------------------------------------------------------------------------------------------------
   -- set_job_try_sqli_too_long
   -- -----------------------------------------------------------------------------------------------------------------
   procedure set_job_try_sqli_too_long is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- arrange
      set_salary;
      
      -- act: SQL injection
      employee_api.set_job(
         in_employee_id => 7788, -- SCOTT
         in_job         => q'[SALESMAN',sal='9000]' -- try to job to 'SALESMAN' and sal to 9000
      );
      
      -- assert 1) data
      open c_actual for select job, sal from emp where empno = 7788;
      open c_expected for select 'ANALYST' as job, 3000 as sal from dual;
      ut.expect(c_actual).to_equal(c_expected);

      -- assert 2) exception
      -- expected exceptions:
      -- - ORA-06502: PL/SQL: numeric or value error: character string buffer too small (value_error) with employee_api.pkb 
      -- - ORA-12899: value too large for column "APP"."EMP"."JOB" (actual: 19, maximum: 9) with employee_api_sqli_fixed.pkb
      -- with employee_api_sqli.pkb no exception is thrown, because SQL injection is possible (no value_error!)
      ut.fail('Runtime exception expected.');
   end set_job_try_sqli_too_long;

   -- -----------------------------------------------------------------------------------------------------------------
   -- set_hiredate
   -- -----------------------------------------------------------------------------------------------------------------
   procedure set_hiredate is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- arrange
      ins;
      
      -- act
      employee_api.set_hiredate(
         in_employee_id => -1,
         in_hiredate    => date '2020-01-01'
      );

      -- assert
      open c_actual for select hiredate from emp where empno = -1;
      open c_expected for select date '2020-01-01' as hiredate from dual;
      ut.expect(c_actual).to_equal(c_expected);
   end set_hiredate;

   -- -----------------------------------------------------------------------------------------------------------------
   -- set_department
   -- -----------------------------------------------------------------------------------------------------------------
   procedure set_department is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- arrange
      ins;
      
      -- act
      employee_api.set_department(
         in_employee_id   => -1,
         in_department_id => 10
      );

      -- assert
      open c_actual for select deptno from emp where empno = -1;
      open c_expected for select 10 as deptno from dual;
      ut.expect(c_actual).to_equal(c_expected);
   end set_department;

   -- -----------------------------------------------------------------------------------------------------------------
   -- set_manager
   -- -----------------------------------------------------------------------------------------------------------------
   procedure set_manager is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- arrange
      ins;
      employee_api.ins(
         in_employee_id   => -2,
         in_employee_name => 'SAM',
         in_job           => 'DEVELOPER',
         in_hiredate      => date '2023-04-01',
         in_department_id => 20
      );      

      -- act
      employee_api.set_manager(
         in_employee_id         => -1,
         in_manager_employee_id => -2
      );

      -- assert
      open c_actual for select mgr from emp where empno = -1;
      open c_expected for select -2 as mgr from dual;
      ut.expect(c_actual).to_equal(c_expected);
   end set_manager;

   -- -----------------------------------------------------------------------------------------------------------------
   -- set_salary
   -- -----------------------------------------------------------------------------------------------------------------
   procedure set_salary is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- arrange
      ins;

      -- act
      employee_api.set_salary(
         in_employee_id => -1,
         in_salary      => 4700
      );

      -- assert
      open c_actual for select sal from emp where empno = -1;
      open c_expected for select 4700 as sal from dual;
      ut.expect(c_actual).to_equal(c_expected);
   end set_salary;

   -- -----------------------------------------------------------------------------------------------------------------
   -- set_commission
   -- -----------------------------------------------------------------------------------------------------------------
   procedure set_commission is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- arrange
      ins;

      -- act
      employee_api.set_commission(
         in_employee_id => -1,
         in_commission  => 1234
      );

      -- assert
      open c_actual for select comm from emp where empno = -1;
      open c_expected for select 1234 as comm from dual;
      ut.expect(c_actual).to_equal(c_expected);
   end set_commission;

   -- -----------------------------------------------------------------------------------------------------------------
   -- del
   -- -----------------------------------------------------------------------------------------------------------------
   procedure del is
      c_actual sys_refcursor;
   begin
      -- arrange
      ins;

      -- act
      employee_api.del(
         in_employee_id => -1
      );

      -- assert
      open c_actual for select * from emp where empno = -1;
      ut.expect(c_actual).to_have_count(0);
   end del;
end test_employee_api;
/