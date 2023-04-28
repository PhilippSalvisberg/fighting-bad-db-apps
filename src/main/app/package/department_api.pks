create or replace package department_api is
   procedure ins(
      in_department_id   in integer,
      in_department_name in varchar2,
      in_location        in varchar2
   );
   procedure upd(
      in_department_id   in integer,
      in_department_name in varchar2,
      in_location        in varchar2
   );
   procedure del(
      in_department_id in integer
   );
end department_api;
/