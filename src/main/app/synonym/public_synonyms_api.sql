begin
   <<create_public_synonyms_for_api_objects>>
   for r in (
      select 'create or replace public synonym '
             || table_name
             || ' for '
             || owner
             || '.'
             || table_name as create_synonym_stmt,
             table_name as synonym_name
        from role_tab_privs
       where role = 'API_ROLE'
         and owner = 'APP'
   )
   loop
      execute immediate r.create_synonym_stmt;
      sys.dbms_output.put_line('public synonym '
         || r.synonym_name
         || ' created.');
   end loop create_public_synonyms_for_api_objects;
end;
/
