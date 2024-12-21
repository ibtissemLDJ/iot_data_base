-- partie 1
connect sys/1234 as sysdba
CREATE TABLESPACE iot_tbs DATAFILE 'C:\Users\LENOVO\OneDrive\Desktop\devoire_maison_BDD\TBA_IOT.DAT' SIZE 100M AUTOEXTEND ON ONLINE; 
CREATE TEMPORARY TABLESPACE IOT_TempTBS TEMPFILE 'C:\Users\LENOVO\OneDrive\Desktop\devoire_maison_BDD\TBS_TEM_IOT.DAT' SIZE 100M AUTOEXTEND ON; 
Create User DBAIOT  Identified by 1234 Default Tablespace iot_tbs   Temporary Tablespace IOT_TempTBS; 
GRANT ALL privileges to DBAIOT ;
-- partie 2
connect dbaiot/1234
-- Création de la table USER
CREATE TABLE USERS (
    IDUSER NUMBER PRIMARY KEY,
    LASTNAME VARCHAR(20) ,
    FIRSTNAME VARCHAR(20),
    EMAIL VARCHAR(40) UNIQUE
);

-- Création de la table SERVICE
CREATE TABLE SERVICE (
    IDSERVICE NUMBER PRIMARY KEY,
    NAME VARCHAR(20),
    SERVICETYPE VARCHAR(20)
);

-- Création de la table THING
CREATE TABLE THING (
    MAC CHAR(17) PRIMARY KEY ,
    IDUSER NUMBER REFERENCES USERS(IDUSER) ON DELETE CASCADE,
    THINGTYPE VARCHAR(20),
    PARAM VARCHAR(20)
);

-- Création de la table SUBSCRIBE
CREATE TABLE SUBSCRIBE (
    IDUSER NUMBER REFERENCES USERS(IDUSER) ON DELETE CASCADE,
    IDSERVICE NUMBER REFERENCES SERVICE(IDSERVICE) ON DELETE CASCADE,
    PRIMARY KEY (IDUSER, IDSERVICE)
);

ALTER TABLE USERS 
ADD ADRESSUSER VARCHAR(30);

ALTER TABLE USERS 
MODIFY ADRESSUSER VARCHAR(30) NOT NULL;

ALTER TABLE USERS 
MODIFY LASTNAME VARCHAR(20) NOT NULL;

ALTER TABLE USERS 
MODIFY ADRESSUSER VARCHAR(80);

ALTER TABLE USERS 
MODIFY ADRESSUSER VARCHAR(40);

ALTER TABLE USERS 
RENAME COLUMN ADRESSUSER TO ADRUSER;
DESC USERS; 

ALTER TABLE USERS
DROP COLUMN ADRUSER;
DESC USERS; 

ALTER TABLE SUBSCRIBE 
ADD START_DATE DATE;
ALTER TABLE SUBSCRIBE 
ADD END_DATE DATE;

-- partie 3 

insert into UTILISATEUR VALUES(1,'Souad','MESBAH','souad. mesbah@gmail.com');
insert into UTILISATEUR VALUES(2,'Younes','CHALAH','younes.chalah@gmail.com');
insert into UTILISATEUR VALUES(3,'Chahinaz','MELEK','chahinaz.melek@gmail.com');
insert into UTILISATEUR VALUES(4,'Samia','OUALI','samia.ouali@gmail.com');
insert into UTILISATEUR VALUES(5,'Djamel','MATI','djamel. mati@gmail.com');
insert into UTILISATEUR VALUES(6,'Assia','HORRA','assia. horra@gmail.com');
insert into UTILISATEUR VALUES(7,'Lamine','MERABAT','Lamine. MERABAT@gmail.com');
insert into UTILISATEUR VALUES(8,'Seddik','HMIA','seddik.hmia@gmail.com');
insert into UTILISATEUR VALUES(9,'Widad','TOUATI','widad.touati@gmail.com');




insert into SERVICE values (1,'myKWHome','smarthome');
insert into SERVICE values (2,'FridgAlert','smarthome');
insert into SERVICE values (3,'RUNstats','quantifiedself');
insert into SERVICE values (4,'traCARE','quantifiedself');
insert into SERVICE values (5,'dogWATCH','');
insert into SERVICE values (6,'CarUse','');


insert into THING values('f0:de:f1:39:7f:17',1,'','');
insert into THING values('f0:de:f1:39:7f:18',2,'','');
insert into THING values('f0:de:f1:39:7f:19',2,'thingtempo','60');
insert into THING values('f0:de:f1:39:7f:25',10,'','');
insert into THING values('f0:de:f1:39:7f:20',2,'thingtempo','1.5');
insert into THING values('f0:de:f1:39:7f:21',4,'','');
insert into THING values('f0:de:f1:39:7f:22',4,'','');


insert into SUBSCRIBE values (2,1,null,null);
insert into SUBSCRIBE values (2,2,null,null);
insert into SUBSCRIBE values (1,3,null,null);
insert into SUBSCRIBE values (3,7,null,null);

-- partie 4 
connect dbaiot/1234

CREATE USER ADMIN IDENTIFIED BY 1234
DEFAULT TABLESPACE IOT_TBS
TEMPORARY TABLESPACE IOT_TempTBS;

CONNECT ADMIN/1234;

GRANT CREATE SESSION TO Admin;
CONNECT Admin/1234 ;

connect DBAIOT/1234 ; 
GRANT CREATE TABLE, CREATE USER TO Admin;

connect admin/1234;
SELECT * FROM USER_SYS_PRIVS;

connect dbaiot/1234;
GRANT SELECT ON DBAIOT.USERS TO Admin;

connect admin/1234;
SELECT * FROM USER_SYS_PRIVS;

CREATE VIEW USER_THING AS
SELECT U.IDUSER, U.LASTNAME, U.FIRSTNAME, T.MAC, T.THINGTYPE, T.PARAM
FROM DBAIOT.USERS U , DBAIOT.THING T
WHERE U.IDUSER = T.IDUSER; 

connect dbaiot/1234
GRANT CREATE VIEW TO Admin;
GRANT SELECT ON DBAIOT.THING TO Admin;
--creation de l'index sur la table service while connecting in admin 
CREATE INDEX NAMESERVICE_IX ON DBAIOT.SERVICE(NAME);
GRANT CREATE ANY INDEX TO Admin;
CREATE INDEX NAMESERVICE_IX ON DBAIOT.SERVICE(NAME);
--suppression des privileges de l'admin 
SQL> connect dbaiot/1234
Connected.
SQL> REVOKE CREATE ANY INDEX FROM ADMIN;

Revoke succeeded.

SQL> REVOKE CREATE TABLE FROM ADMIN;

Revoke succeeded.

SQL> REVOKE CREATE SESSION FROM ADMIN;

Revoke succeeded.

SQL> REVOKE CREATE USER FROM ADMIN;

Revoke succeeded.

SQL> connect admin/1234
ERROR:
ORA-01045: user ADMIN lacks CREATE SESSION privilege; logon denied


Warning: You are no longer connected to ORACLE.
SQL> connect dbaiot/1234
Connected.
-- creation de vue 
SQL> CREATE PROFILE IOT_Profil
  2  LIMIT
  3      SESSIONS_PER_USER         3
  4      CPU_PER_CALL              3500
  5      CONNECT_TIME              90
  6      LOGICAL_READS_PER_CALL    1200
  7      PRIVATE_SGA               25K
  8      IDLE_TIME                 30
  9      FAILED_LOGIN_ATTEMPTS     5
 10      PASSWORD_LIFE_TIME        50
 11      PASSWORD_REUSE_TIME       40
 12      PASSWORD_REUSE_MAX        UNLIMITED
 13      PASSWORD_LOCK_TIME        1
 14      PASSWORD_GRACE_TIME       5;

Profile created.
--affecter le profile au admine 
SQL> ALTER USER Admin PROFILE IOT_Profil;

User altered.
--Création du rôle SUBSCRIBE_MANAGER

SQL> CREATE ROLE SUBSCRIBE_MANAGER;

Role created.

SQL>
SQL> GRANT SELECT ON DBAIOT.USERS TO SUBSCRIBE_MANAGER;

Grant succeeded.

SQL> GRANT SELECT ON DBAIOT.SERVICE TO SUBSCRIBE_MANAGER;

Grant succeeded.

SQL> GRANT UPDATE ON DBAIOT.SUBSCRIBE TO SUBSCRIBE_MANAGER;

--Assignez ce rôle à Admin.
GRANT SUBSCRIBE_MANAGER TO Admin;
-- Vérification des autorisations :
CONNECT Admin/1234 ; 
SELECT * FROM ROLE_TAB_PRIVS WHERE ROLE = 'SUBSCRIBE_MANAGER';


--partie 5

-- question 1 

Describe DICT;
select * from dict; 

--question 2 

DESCRIBE ALL_TAB_COLUMNS;
SELECT COMMENTS FROM DICT WHERE TABLE_NAME ='ALL_TAB_COLUMNS';

DESCRIBE USER_USERS;
SELECT COMMENTS FROM DICT WHERE TABLE_NAME ='USER_USERS'

DESCRIBE ALL_CONSTRAINTS;
SELECT COMMENTS FROM DICT WHERE TABLE_NAME ='ALL_CONSTRAINTS'

DESCRIBE USER_TAB_PRIVS;
SELECT COMMENTS FROM DICT WHERE TABLE_NAME ='USER_TAB_PRIVS'

-- question 3
SELECT USER FROM DUAL;

--question 4 
DESCRIBE USER_TAB_COLUMNS;

-- question 5 
CONNECT DBAIOT/1234

SELECT TABLE_NAME FROM USER_TABLES;

SELECT table_name, column_name, data_type, data_length, nullable 
FROM user_tab_columns
ORDER BY table_name, column_id;

--question 6 
SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER = 'SYSTEM';
SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER = 'DBAIOT';

-- quesion 7

SELECT * FROM USER_TAB_COLUMNS WHERE TABLE_NAME ='THING';
SELECT * FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'SUBSCRIBE';

-- question 8 
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE FROM USER_CONSTRAINTS WHERE TABLE_NAME IN ('THING', 'SUBSCRIBE');

-- question 9 
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME IN ('THING', 'SUBSCRIBE');

--question 10 
SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH 
FROM USER_TAB_COLUMNS 
WHERE TABLE_NAME = 'SUBSCRIBE';

--question 11 
--creation des privileges 
GRANT CREATE SESSION, CREATE TABLE TO Admin;
GRANT SELECT ON USER TO Admin; 
-- affichage des privileges au tanque Admin 
connect admin/1234

SELECT * FROM USER_SYS_PRIVS;
SELECT * FROM USER_TAB_PRIVS;

-- affichages des privileges au tanque systeme 

connect system/1234

SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'ADMIN'; 
SELECT * FROM DBA_TAB_PRIVS WHERE GRANTEE = 'ADMIN'; 

-- question 12 
SELECT * FROM USER_ROLE_PRIVS;

--questin 13 
SELECT OBJECT_NAME, OBJECT_TYPE 
FROM USER_OBJECTS;

--question 14 
SELECT OWNER 
FROM ALL_TABLES 
WHERE TABLE_NAME = 'SUBSCRIBE';

--question 15
SELECT BYTES / 1024 AS SIZE_IN_KB 
FROM USER_SEGMENTS 
WHERE SEGMENT_NAME = 'SUBSCRIBE';

--question 16

--creation de user 
CREATE USER user_iot IDENTIFIED BY 1234
DEFAULT TABLESPACE IOT_TBS 
TEMPORARY TABLESPACE IOT_TempTBS

--lui donner tous les privileges 
GRANT ALL PRIVILEGES TO user_iot;

--connection a cet user 
connect user_iot/1234

--verification 
select *from all_users;
select * from user_sys_privs;