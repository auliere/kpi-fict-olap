-- Create the user 
create user TASK3
  identified by "TASK3"
  default tablespace USERS
  temporary tablespace TEMP
  profile DEFAULT;
-- Grant/Revoke role privileges 
grant connect to TASK3;
grant resource to TASK3;
-- Grant/Revoke system privileges 
--grant unlimited tablespace to TASK3;
