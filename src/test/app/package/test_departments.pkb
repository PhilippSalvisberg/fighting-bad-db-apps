create or replace package body test_departements is
   -- -----------------------------------------------------------------------------------------------------------------
   -- initial_data
   -- -----------------------------------------------------------------------------------------------------------------
   procedure initial_data is
      c_actual sys_refcursor;
   begin
      -- act
      open c_actual for select * from departments;
      
      -- assert
      ut.expect(c_actual).to_have_count(4);
   end initial_data;

   -- -----------------------------------------------------------------------------------------------------------------
   -- new_dept
   -- -----------------------------------------------------------------------------------------------------------------
   procedure new_dept is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- arrange
      insert into dept (deptno, dname, loc) values (-1, 'utPLSQL', 'Winterthur');
      
      -- act
      open c_actual for
         select department_name, location
           from departments
          where department_id = -1;
      
      -- assert
      open c_expected for
         select 'utPLSQL' as department_name, 'Winterthur' as location
           from dual;
      ut.expect(c_actual).to_equal(c_expected);
   end new_dept;
end test_departements;
/
