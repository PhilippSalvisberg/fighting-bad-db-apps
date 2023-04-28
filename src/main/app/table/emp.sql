-- create table if not exists emp...
declare
   e_table_exists exception;
   pragma exception_init(e_table_exists, -955);
begin
   execute immediate q'[
      create table emp (
         empno    number(4, 0)       not null  constraint emp_pk primary key,
         ename    varchar2(10 char)  not null,
         job      varchar2(9 char)   not null,
         mgr      number(4, 0)                 constraint emp_emp_mgr_fk references emp,
         hiredate date               not null,
         sal      number(7, 2),
         comm     number(7, 2),
         deptno   number(2, 0)       not null  constraint emp_dept_deptno_fk references dept
      )
   ]';
   sys.dbms_output.put_line('table emp created.');
exception
   when e_table_exists then
      sys.dbms_output.put_line('table emp already exists.');
end;
/

-- create index if not exists emp_emp_mgr_fk_i...
declare
   e_index_exists exception;
   pragma exception_init(e_index_exists, -955);
begin
   execute immediate q'[
      create index emp_emp_mgr_fk_i on emp (mgr)
   ]';
   sys.dbms_output.put_line('index emp_emp_mgr_fk_i created.');
exception
   when e_index_exists then
      sys.dbms_output.put_line('index emp_emp_mgr_fk_i already exists.');
end;
/

-- create index if not exists emp_dept_deptno_fk_i...
declare
   e_index_exists exception;
   pragma exception_init(e_index_exists, -955);
begin
   execute immediate q'[
      create index emp_dept_deptno_fk_i on emp (deptno)
   ]';
   sys.dbms_output.put_line('index emp_dept_deptno_fk_i created.');
exception
   when e_index_exists then
      sys.dbms_output.put_line('index emp_dept_deptno_fk_i already exists.');
end;
/
