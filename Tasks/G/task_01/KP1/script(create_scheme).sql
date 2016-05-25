--create user task1 with password task1
create user task1 identified by task1
-- create tablespace
default tablespace users quota 10M
-- limit temporary tablespace 10mb
temporary tablespace temp quota 10M on users;

-- add grants
grant connect, resource to task1;