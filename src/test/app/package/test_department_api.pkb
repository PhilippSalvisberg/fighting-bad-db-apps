create or replace package body test_departement_api is
   -- -----------------------------------------------------------------------------------------------------------------
   -- ins
   -- -----------------------------------------------------------------------------------------------------------------
   procedure ins is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- act
      department_api.ins(
         in_department_id   => -1,
         in_department_name => 'utPLSQL',
         in_location        => 'Winterthur'
      );
      
      -- assert
      open c_actual for
         select dname, loc
           from dept
          where deptno = -1;
      open c_expected for
         select 'utPLSQL' as dname, 'Winterthur' as loc
           from dual;
      ut.expect(c_actual).to_equal(c_expected);
   end ins;

   -- -----------------------------------------------------------------------------------------------------------------
   -- upd
   -- -----------------------------------------------------------------------------------------------------------------
   procedure upd is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- arrange
      ins;
      
      -- act
      department_api.upd(
         in_department_id   => -1,
         in_department_name => 'UTPLSQL',
         in_location        => 'WINTERTHUR'
      );
      
      -- assert
      open c_actual for
         select dname, loc
           from dept
          where deptno = -1;
      open c_expected for
         select 'UTPLSQL' as dname, 'WINTERTHUR' as loc
           from dual;
      ut.expect(c_actual).to_equal(c_expected);
   end upd;

   -- -----------------------------------------------------------------------------------------------------------------
   -- del
   -- -----------------------------------------------------------------------------------------------------------------
   procedure del is
      c_actual sys_refcursor;
   begin
      -- arrange
      ins;
      
      -- act
      department_api.del(
         in_department_id => -1
      );
      
      -- assert
      open c_actual for select * from dept where deptno = -1;
      ut.expect(c_actual).to_have_count(0);
   end del;
end test_departement_api;
/
