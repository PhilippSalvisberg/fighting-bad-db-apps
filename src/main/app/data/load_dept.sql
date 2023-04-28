merge into dept t
using (
         select 10 as deptno, 'ACCOUNTING' as dname, 'NEW YORK' as loc
           from dual
         union all
         select 20, 'RESEARCH', 'DALLAS'
           from dual
         union all
         select 30, 'SALES', 'CHICAGO'
           from dual
         union all
         select 40, 'OPERATIONS', 'BOSTON'
           from dual
      ) s
   on (t.deptno = s.deptno)
 when matched then
      update
         set t.dname = s.dname,
             t.loc = s.loc
 when not matched then
      insert (t.deptno, t.dname, t.loc)
      values (s.deptno, s.dname, s.loc);
commit;

begin
   dbms_stats.gather_table_stats(ownname => 'app', tabname => 'dept');
end;
/
