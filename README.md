# PROYECTO BB.DD. - "BOY SCOUTS"
![logo](/SCOUTS_flor_lis.jpg)
## **_Autor_**: Saúl Altoubah León

En este archivo README.md se han creado 2 partes del proyecto SAL_SCOUTS: 1ª parte - Modelado y Administración, 2ª parte - Seguridad.

# 1ª PARTE: MODELADO Y ADMINISTRACIÓN
 - Árbol de directorios:

~~~
./
│
└───1a_parte
    │
    ├───SAL_DB
    │   ├───BAKs
    │   │       SAL_SCOUTS.bak
    │   │       SAL_SCOUTS_log.bak
    │   │
    │   └───SQL_scripts
    │           SALnewPerson.sql
    │           SALprofit_lossCalc.sql
    │           SAL_Filetable.sql
    │           SAL_particiones.sql
    │           SAL_SCOUTS_SSMS.sql
    │           SAL_temporal_tables.sql
    │           SAL_triggers.sql
    │           SAL_users_views_permissions.sql
    │
    ├───SAL_SCOUTS_model
    │   │   sal_boy_scouts_bd.dmd
    │   │   SAL_SCOUTS_logical_model.pdf
    │   │   SAL_SCOUTS_physical_diagram.pdf
    │   │   SAL_SCOUTS_relational_model.pdf
    │   │
    │   └───sal_boy_scouts_bd
    └───SAL_proyecto_SCOUTS.pdf
~~~



El índice del archivo PDF es el siguiente:

ÍNDICE

~~~
1. Introducción
2. Virtualización de máquinas virtuales en VMware
 2.1. Adaptadores de red
 2.2. MVs
  2.2.1. Clientes
   2.2.1.1. MV Windows 10
    2.2.1.1.1. Configuración inicial
     2.2.1.1.1.1. Configuración de interfaces de red
     2.2.1.1.1.2. Configuración del firewall
    2.2.1.1.2. Programas
     2.2.1.1.2.1. SQL Server 2017 + SSMS
      2.2.1.1.2.1.1. Instalación
      2.2.1.1.2.1.2. Configuración
      2.2.1.1.2.1.3. Utilización - BDs de ejemplo
       2.2.1.1.2.1.3.1. Pubs desde script
       2.2.1.1.2.1.3.2. Northwind con ATTACH
       2.2.1.1.2.1.3.3. AdventureWorks2017 desde .BAK
       2.2.1.1.2.1.3.4. WideWorldImporters con .BACPAC
     2.2.1.1.2.2. Oracle Express 18c
      2.2.1.1.2.2.1. Instalación
      2.2.1.1.2.2.2. Configuración
       2.2.1.1.2.2.2.1. SQLPlus
        2.2.1.1.2.2.2.1.1. Desbloqueo usuario HR
     2.2.1.1.2.3. SQL Developer - DataModeler
      2.2.1.1.2.3.1. Configuración
      2.2.1.1.2.3.2. Conexiones
   2.2.1.2. MV Ubuntu Desktop 18.04
    2.2.1.2.1. Configuración inicial
     2.2.1.2.1.1. Configuración de interfaces de red
     2.2.1.2.1.2. Configuración de firewall
    2.2.1.2.2. Programas
     2.2.1.2.2.1. SQL Server 2017 + Azure Data Studio
      2.2.1.2.2.1.1. Instalación
      2.2.1.2.2.1.2. Configuración
       2.2.1.2.2.1.2.1. SQLcmd
  2.2.2. Controlador de dominio
   2.2.2.1. MV Windows Server 2016
    2.2.2.1.1. Configuración inicial
     2.2.2.1.1.1. Configuración de interfaces de red
     2.2.2.1.1.2. Configuración del firewall
    2.2.2.1.2. Programas
     2.2.2.1.2.1. SQL Server 2017 + SSMS
      2.2.2.1.2.1.1. Conexión a instancias cliente
    2.2.2.1.3. Instalación desatendida
    2.2.2.1.4. Configuración del dominio
     2.2.2.1.4.1. Unión de los clientes al dominio

3. Proyecto Base de Datos - Boy Scouts
 3.1. Caso práctico
 3.2. Modelado Base de Datos
  3.2.1. Modelo lógico
  3.2.2. Modelo relacional
  3.2.3. Script SQL
  3.2.4. Diagrama físico
 3.3. Administración Base de Datos
  3.3.1. Filegroup
  3.3.2. Procedimientos almacenados
  3.3.3. Filestream - Filetable
  3.3.4. Bases de Datos Contenidas
  3.3.5. Particiones - Split/Merge/Switch/Truncate
  3.3.6. Tablas temporales
  3.3.7. Triggers
  3.3.8. Tablas In Memory

4. Git
 4.1. Instalación
 4.2. Funcionamiento - Comandos
 4.3. Github - Gitlab - BitBucket - Tortoise Git

~~~


-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/


# 2ª PARTE: SEGURIDAD
 - Árbol de directorios:

 ~~~
./
│
└───2a_parte
    │
    ├───backup
    │   │   SAL_SCOUTS_Full_TDE.bak
    │   │   SAL_SCOUTS_log_TDE.bak
    │   │   SAL_SCOUTS_TDEkey.pvk
    │   │   SAL_SCOUTS_TDEScout.cer
    │   │
    │   └───scripts
    │           SAL_always_encrypted.sql
    │           SAL_data_masking.sql
    │           SAL_encrypt_col_bkp_tde.sql
    │           SAL_RLS.sql
    │
    │   indice_proyecto_SCOUTS_2.txt
    └───proyecto_bbdd2_SEGURIDAD.pdf
~~~



El índice del archivo PDF es el siguiente:

ÍNDICE

~~~
1. Introducción
2. Encriptación (Encryption)
 2.1. Tools (VeraCrypt, Let's Encrypt)
 2.2. Encriptación de Columnas de BD
 2.3. Encriptación de Backup de BD
 2.4. Encrip. BD TDE (Transparent Data Encryption)
 2.5. Funciones
  2.5.1. DDM (Dynamic Data Masking)
  2.5.2. Row Encryption (RLS,Row-Level Security)
 2.6. Always Encrypted
 2.7. Tareas sobre BD en SSMS
  2.7.1. Data Discovery and Classification
  2.7.2. Vulnerability Assessment
3. Auditoría (Audit)
 3.1. Auditoría de Serv. y Especif.  de auditoría de serv.
 3.2. Especificación de auditoría de BD
 3.3. Bonus auditoría de BD
4. Legislación (GDPR - General Data Prot. Reg. (EU))
5. Ataques
 5.1. DDoS
 5.2. Injection SQL
 5.3. Ransomware
 5.4. Tools
6. Docker
 6.1. Docker aplicado a BD

~~~