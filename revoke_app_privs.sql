set define off
set echo off
whenever sqlerror exit failure
set serveroutput on size unlimited
spool revoke_app_privs.log

prompt ================================================================================================================
prompt revoke all privileges from schema app
prompt ================================================================================================================
begin
   for r in (
      select 'revoke '
             || privilege
             || ' from app' as revoke_stmt,
             privilege
        from dba_sys_privs
       where grantee = 'APP'
   )
   loop
      execute immediate r.revoke_stmt;
      sys.dbms_output.put_line('privilege '
         || r.privilege
         || ' revoked.');
   end loop;
end;
/

spool off;
