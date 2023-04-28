create or replace package employee_api is
   procedure ins(
      in_employee_id   in integer,
      in_employee_name in varchar2,
      in_job           in varchar2,
      in_hiredate      in date,
      in_department_id in integer
   );

   procedure set_name(
      in_employee_id   in integer,
      in_employee_name in varchar2
   );

   procedure set_job(
      in_employee_id in integer,
      in_job         in varchar2
   );

   procedure set_hiredate(
      in_employee_id in integer,
      in_hiredate    in date
   );

   procedure set_department(
      in_employee_id   in integer,
      in_department_id in integer
   );

   procedure set_manager(
      in_employee_id         in integer,
      in_manager_employee_id in integer
   );

   procedure set_salary(
      in_employee_id in integer,
      in_salary      in number
   );

   procedure set_commission(
      in_employee_id in integer,
      in_commission  in number
   );
   
   procedure del(
      in_employee_id in integer
   );
end employee_api;
/