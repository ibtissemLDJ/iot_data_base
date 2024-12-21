-- connecter à la base de données avec des privilèges d'administration élevés
connect sys/1234 as sysdba
-- creation des tables spaces 
CREATE TABLESPACE iot_tbs DATAFILE 'C:\Users\LENOVO\OneDrive\Desktop\devoire_maison_BDD\TBA_IOT.DAT' SIZE 100M AUTOEXTEND ON ONLINE; 
CREATE TEMPORARY TABLESPACE IOT_TempTBS TEMPFILE 'C:\Users\LENOVO\OneDrive\Desktop\devoire_maison_BDD\TBS_TEM_IOT.DAT' SIZE 100M AUTOEXTEND ON; 
-- creation de user DBAIOT 
Create User DBAIOT  Identified by 1234 Default Tablespace iot_tbs   Temporary Tablespace IOT_TempTBS; 
-- doner tous les privilege au utilisateur DBAIOT 
GRANT ALL privileges to DBAIOT ;