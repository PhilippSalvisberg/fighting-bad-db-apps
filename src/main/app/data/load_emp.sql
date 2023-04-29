-- level 1
merge into emp t
using (
         select 7839 as empno,
                'KING' as ename,
                'PRESIDENT' as job,
                null as mgr,
                date '1981-11-17' as hiredate,
                5000 as sal,
                null as comm,
                10 as deptno
           from dual
      ) s
   on (t.empno = s.empno)
 when matched then
      update
         set t.ename = s.ename,
             t.job = s.job,
             t.mgr = s.mgr,
             t.hiredate = s.hiredate,
             t.sal = s.sal,
             t.comm = s.comm,
             t.deptno = s.deptno
 when not matched then
      insert (t.empno, t.ename, t.job, t.mgr, t.hiredate, t.sal, t.comm, t.deptno)
      values (s.empno, s.ename, s.job, s.mgr, s.hiredate, s.sal, s.comm, s.deptno);

-- level 2
merge into emp t
using (
         select 7566 as empno,
                'JONES' as ename,
                'MANAGER' as job,
                7839 as mgr,
                date '1981-04-02' as hiredate,
                2975 as sal,
                null as comm,
                20 as deptno
           from dual
         union all
         select 7698, 'BLAKE', 'MANAGER', 7839, date '1981-05-01', 2850, null, 30
           from dual
         union all
         select 7782, 'CLARK', 'MANAGER', 7839, date '1981-06-09', 2450, null, 10
           from dual
      ) s
   on (t.empno = s.empno)
 when matched then
      update
         set t.ename = s.ename,
             t.job = s.job,
             t.mgr = s.mgr,
             t.hiredate = s.hiredate,
             t.sal = s.sal,
             t.comm = s.comm,
             t.deptno = s.deptno
 when not matched then
      insert (t.empno, t.ename, t.job, t.mgr, t.hiredate, t.sal, t.comm, t.deptno)
      values (s.empno, s.ename, s.job, s.mgr, s.hiredate, s.sal, s.comm, s.deptno);

-- level 3
merge into emp t
using (
         select 7788 as empno,
                'SCOTT' as ename,
                'ANALYST' as job,
                7566 as mgr,
                date '1987-04-19' as hiredate,
                3000 as sal,
                null as comm,
                20 as deptno
           from dual
         union all
         select 7902, 'FORD', 'ANALYST', 7566, date '1981-12-03', 3000, null, 20
           from dual
         union all
         select 7499, 'ALLEN', 'SALESMAN', 7698, date '1981-02-20', 1600, 300, 30
           from dual
         union all
         select 7521, 'WARD', 'SALESMAN', 7698, date '1981-02-22', 1250, 500, 30
           from dual
         union all
         select 7654, 'MARTIN', 'SALESMAN', 7698, date '1981-09-28', 1250, 1400, 30
           from dual
         union all
         select 7844, 'TURNER', 'SALESMAN', 7698, date '1981-09-08', 1500, 0, 30
           from dual
         union all
         select 7900, 'JAMES', 'CLERK', 7698, date '1981-12-03', 950, null, 30
           from dual
         union all
         select 7934, 'MILLER', 'CLERK', 7782, date '1982-01-23', 1300, null, 10
           from dual
      ) s
   on (t.empno = s.empno)
 when matched then
      update
         set t.ename = s.ename,
             t.job = s.job,
             t.mgr = s.mgr,
             t.hiredate = s.hiredate,
             t.sal = s.sal,
             t.comm = s.comm,
             t.deptno = s.deptno
 when not matched then
      insert (t.empno, t.ename, t.job, t.mgr, t.hiredate, t.sal, t.comm, t.deptno)
      values (s.empno, s.ename, s.job, s.mgr, s.hiredate, s.sal, s.comm, s.deptno);

-- level 4
merge into emp t
using (
         select 7369 as empno,
                'SMITH' as ename,
                'CLERK' as job,
                7902 as mgr,
                date '1980-12-17' as hiredate,
                800 as sal,
                null as comm,
                20 as deptno
           from dual
         union all
         select 7876, 'ADAMS', 'CLERK', 7788, date '1987-05-23', 1100, null, 20
           from dual
      ) s
   on (t.empno = s.empno)
 when matched then
      update
         set t.ename = s.ename,
             t.job = s.job,
             t.mgr = s.mgr,
             t.hiredate = s.hiredate,
             t.sal = s.sal,
             t.comm = s.comm,
             t.deptno = s.deptno
 when not matched then
      insert (t.empno, t.ename, t.job, t.mgr, t.hiredate, t.sal, t.comm, t.deptno)
      values (s.empno, s.ename, s.job, s.mgr, s.hiredate, s.sal, s.comm, s.deptno);

commit;

begin
   sys.dbms_stats.gather_table_stats(ownname => 'app', tabname => 'emp');
end;
/