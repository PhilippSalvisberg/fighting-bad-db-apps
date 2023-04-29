create or replace package body test_pinkdb is
   -- -----------------------------------------------------------------------------------------------------------------
   -- global variables & constants
   -- -----------------------------------------------------------------------------------------------------------------
   co_connect_user constant dba_users.username%type := 'APP_CONNECT';
   co_api_role     constant dba_roles.role%type     := 'API_ROLE';

   -- -----------------------------------------------------------------------------------------------------------------
   -- get_privileges (private)
   -- -----------------------------------------------------------------------------------------------------------------
   function get_privileges(in_username in varchar2) return sys_refcursor is
      co_username  constant dba_users.username%type := in_username;
      c_privileges sys_refcursor;
   begin
      open c_privileges for
         with
            upriv as (
               -- system privileges granted to users
               select u.username, p.privilege as priv
                 from dba_sys_privs p
                inner join dba_users u
                   on u.username = p.grantee
               union all
               -- roles granted to users
               select u.username, p.granted_role as priv
                 from dba_role_privs p
                inner join dba_users u
                   on u.username = p.grantee
            ),
            rpriv as (
               -- roles without parent (=roots)
               select role as priv, null as parent_priv
                 from dba_roles
                where role not in (
                         select rrp.granted_role
                           from role_role_privs rrp
                      )
               union all
               -- roles granted to roles
               select granted_role as priv,
                      role as parent_priv
                 from role_role_privs
               union all
               -- system privileges granted to roles
               select privilege as priv,
                      grantee as parent_priv
                 from dba_sys_privs
                where grantee in (
                         select r.role
                           from dba_roles r
                      )
            ),
            rtree as (
               -- provides priv_path and is_leaf for every role/priv in the hierarchy
               select priv,
                      parent_priv,
                      sys_connect_by_path(priv, '/') || '/' as priv_path,
                      case
                         when connect_by_isleaf = '0' then
                            0
                         else
                            1
                      end as is_leaf
                 from rpriv
              connect by prior priv = parent_priv
            ),
            rgraph as (
               -- provides per priv all its possible parent privs or in other words
               -- provides per parent priv all its possible child privs
               -- this allows to join with parent_priv to get all privs
               select priv,
                      substr(priv_path, 2, instr(priv_path, '/', 2) - 2) as parent_priv,
                      is_leaf
                 from rtree
            ),
            ugraph as (
               -- extends the rgraph by users and their privs
               -- distinct is required since a priv can be part of multiple roles
               select distinct
                      upriv.username,
                      rgraph.priv,
                      cast(rgraph.parent_priv as varchar2(128 byte)) as granted_priv,
                      case
                         when rgraph.priv = rgraph.parent_priv then
                            1
                         else
                            0
                      end as direct_grant,
                      rgraph.is_leaf
                 from upriv
                 join rgraph
                   on upriv.priv = rgraph.parent_priv
            )
         -- main
         select priv
           from ugraph
          where username = co_username
            and is_leaf = 1;
      return c_privileges;
   end get_privileges;

   -- -----------------------------------------------------------------------------------------------------------------
   -- app_schema_privileges
   -- -----------------------------------------------------------------------------------------------------------------
   procedure app_schema_privileges is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- act
      c_actual := get_privileges(user); 
      
      -- assert
      open c_expected for
         select 'CREATE SESSION' as priv
           from dual
         union all
         select 'CREATE TABLE'
           from dual
         union all
         select 'CREATE PROCEDURE'
           from dual
         union all
         select 'CREATE VIEW'
           from dual
         union all
         select 'CREATE PUBLIC SYNONYM'
           from dual
         union all
         select 'DROP PUBLIC SYNONYM'
           from dual
         union all
         select 'SELECT ANY DICTIONARY'
           from dual
         union all
         select 'DEBUG CONNECT SESSION'
           from dual
         union all
         select 'DEBUG ANY PROCEDURE'
           from dual;
      ut.expect(c_actual).to_equal(c_expected).unordered;
   end app_schema_privileges;

   -- -----------------------------------------------------------------------------------------------------------------
   -- connect_user_privileges
   -- -----------------------------------------------------------------------------------------------------------------
   procedure connect_user_privileges is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- act
      c_actual := get_privileges(co_connect_user); 
      
      -- assert
      open c_expected for
         select 'CREATE SESSION' as priv
           from dual
         union all
         select 'API_ROLE'
           from dual;
      ut.expect(c_actual).to_equal(c_expected).unordered;
   end connect_user_privileges;

   -- -----------------------------------------------------------------------------------------------------------------
   -- connect_user_objects
   -- -----------------------------------------------------------------------------------------------------------------
   procedure connect_user_objects is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- act
      open c_actual for
         select object_type, object_name
           from dba_objects
          where owner = co_connect_user
          order by object_type, object_name; 
      
      -- assert
      open c_expected for
         select null as object_type, null as object_name
           from dual
          where rownum < 1;
      ut.expect(c_actual).to_equal(c_expected);
   end connect_user_objects;

   -- -----------------------------------------------------------------------------------------------------------------
   -- connect_direct_object_privs
   -- -----------------------------------------------------------------------------------------------------------------
   procedure connect_direct_object_privs is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- act
      open c_actual for
         select owner, type, table_name as name, privilege
           from dba_tab_privs
          where grantee = co_connect_user
          order by owner, type, table_name, privilege; 
      
      -- assert
      open c_expected for
         select null as owner, null as type, null as name, null as privilege
           from dual
          where rownum < 1;
      ut.expect(c_actual).to_equal(c_expected);
   end connect_direct_object_privs;

   -- -----------------------------------------------------------------------------------------------------------------
   -- api_role_object_privs
   -- -----------------------------------------------------------------------------------------------------------------
   procedure api_role_object_privs is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- act
      open c_actual for
         select owner, type, table_name as name, privilege
           from dba_tab_privs
          where grantee = co_api_role
            and (owner != user
                   or owner = user and type = 'TABLE')
          order by owner, type, table_name, privilege; 
      
      -- assert
      open c_expected for
         select null as owner, null as type, null as name, null as privilege
           from dual
          where rownum < 1;
      ut.expect(c_actual).to_equal(c_expected);
   end api_role_object_privs;
end test_pinkdb;
/