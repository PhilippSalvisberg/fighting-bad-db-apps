begin
   <<grant_api_views>>
   for r in (
      select 'grant read on '
             || view_name
             || ' to api_role' as grant_stmt,
             view_name
        from all_views
       where owner = 'APP'
         and view_name in ('DEPARTMENTS', 'EMPLOYEES', 'DEPARTMENT_SALARIES')
   )
   loop
      execute immediate r.grant_stmt;
      sys.dbms_output.put_line('read access granted on '
         || r.view_name
         || ' to api_role.');
   end loop grant_api_views;
end;
/

begin
   <<grant_api_packages>>
   for r in (
      select 'grant execute on '
             || object_name
             || ' to api_role' as grant_stmt,
             object_name as package_name
        from all_objects
       where object_type = 'PACKAGE'
         and owner = 'APP'
         and object_name like '%\_API' escape '\'
   )
   loop
      execute immediate r.grant_stmt;
      sys.dbms_output.put_line('execute rights granted on '
         || r.package_name
         || ' to api_role.');
   end loop grant_api_packages;
end;
/
