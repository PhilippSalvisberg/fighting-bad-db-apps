-- works with employee_api_sqi.pkg (but should fail)
-- fails with employee_api_sqli_fixed.pkg (ORA-12899 in update, could be handled in employee_api)
-- fails with employee_app.pkg (ORA-6502: value_error, cannot to be handeld in employee_api, but by caller)
begin
   employee_api.set_job(
      in_employee_id => 7788,
      in_job         => q'[SALESMAN',sal='9000]'
   );
end;
/

-- works in all variants (should probably fail in all variants due to invalid job)
begin
   employee_api.set_job(
      in_employee_id => 7788,
      in_job         => q'[S',sal='9]'
   );
end;
/

-- query result & rollback
select * from emp where empno = 7788;
rollback;
