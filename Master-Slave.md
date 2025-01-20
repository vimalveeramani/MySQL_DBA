# How To Configure MySQL Master-Slave Replication? (One-Way Replication)

## Table of Contents
1. [Environment](#environment)
2. [On MySQL Master Server](#on-mysql-master-server)
   - [Update Master Server Config File](#update-master-server-config-file)
   - [Restart MySQL Server](#restart-mysql-server)
   - [Create User for Replication](#create-user-for-replication)
   - [Note Down Master Log Position](#note-down-master-log-position)
   - [Backup All Database of Master](#backup-all-database-of-master)
   - [Unlock Master Database](#unlock-master-database)
   - [Transfer Database Backup Dump File to Slave Server](#transfer-database-backup-dump-file-to-slave-server)
3. [On MySQL Slave Server](#on-mysql-slave-server)
   - [Update Slave Server Config File](#update-slave-server-config-file)
   - [Restart MySQL Server](#restart-mysql-server-1)
   - [Restore Database Dump into Slave Server](#restore-database-dump-into-slave-server)
   - [Setup Slave to Communicate Master Database](#setup-slave-to-communicate-master-database)
   - [Test Replication and Verify the Results](#test-replication-and-verify-the-results)
     - [Create Database Operation](#create-database-operation)
     - [Create Table Operation](#create-table-operation)
     - [Insert Table Operation](#insert-table-operation)
     - [Update Table Operation](#update-table-operation)
     - [Delete Table Operation](#delete-table-operation)

---

## 1. Environment

| Host Name      | Public IP       | Private IP      | MySQL Version |
|----------------|-----------------|-----------------|---------------|
| Master Server  | rac1            | 192.168.0.101   | 8.0           |
| Slave Server   | rac2            | 192.168.0.102   | 8.0           |

Private IP used for replication — Dedicated IP

---

## 2. On MySQL Master Server

### Update Master Server Config File

Edit `/etc/my.cnf` file and add the following entries.

```bash
server-id=1
bind-address=192.168.0.101
log-bin=mysql-bin
```

### Restart MySQL Server

```bash
systemctl restart mysqld
```

### Create User for Replication

Create the `nobi` user on the master for slave connection.

```sql
mysql> CREATE USER 'nobi'@'192.168.0.102' IDENTIFIED WITH mysql_native_password BY 'Mysql@123';
mysql> GRANT REPLICATION SLAVE ON *.* TO 'nobi'@'192.168.0.102';
mysql> FLUSH PRIVILEGES;
mysql> FLUSH TABLES WITH READ LOCK;
```

### Note Down Master Log Position

```sql
mysql> SHOW MASTER STATUS;
+------------------+----------+--------------+------------------+-------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+------------------+----------+--------------+------------------+-------------------+
| mysql-bin.000009 |     2369 |              |                  |                   |
+------------------+----------+--------------+------------------+-------------------+
```

### Backup All Database of Master

```bash
mysqldump --all-databases --master-data > /u01/mysql/data/backup/alldbdump.sql
```

### Unlock Master Database

```sql
mysql> UNLOCK TABLES;
```

### Transfer Database Backup Dump File to Slave Server

```bash
scp alldbdump.sql root@192.168.0.102:/u01/mysql/backup
```

---

## 3. On MySQL Slave Server

### Update Slave Server Config File

Edit the `/etc/my.cnf` file and add the following entries.

```bash
server-id=2
bind-address=192.168.0.102
log-bin=mysql-bin
```

### Restart MySQL Server

```bash
systemctl restart mysqld
```

### Restore Database Dump into Slave Server

```bash
mysql < /u01/mysql/backup/alldbdump.sql
```

### Setup Slave to Communicate Master Database

```sql
mysql> CHANGE MASTER TO
    -> MASTER_HOST='192.168.0.101',
    -> MASTER_USER='nobi',
    -> MASTER_PASSWORD='Mysql@123',
    -> MASTER_LOG_FILE='mysql-bin.000009',
    -> MASTER_LOG_POS=2369;
mysql> START SLAVE;
```

### Test Replication and Verify the Results

#### Create Database Operation

**a1) Create Database Operation on Master**

```sql
mysql> create database mynobi;
mysql> use mynobi;
mysql> show tables;
```

**a2) Verify Create Database Operation on Slave**

```sql
mysql> show databases;
mysql> use mynobi;
mysql> show tables;
```

#### Create Table Operation

**b1) Create Table Operation on Master**

```sql
mysql> create table MYSCB_DBA (
    -> ID int,
    -> NAME varchar(20),
    -> ROLE varchar(20),
    -> primary key (ID))
    -> ENGINE=InnoDB;
mysql> show tables;
```

**b2) Verify Create Table Operation on Slave**

```sql
mysql> show tables;
```

#### Insert Table Operation

**c1) Insert Table Operation on Master**

```sql
mysql> INSERT INTO MYSCB_DBA values(1,'nobi','DBA');
mysql> COMMIT;
mysql> SELECT * FROM MYSCB_DBA;
```

**c2) Verify Insert Table Operation on Slave**

```sql
mysql> SELECT * FROM MYSCB_DBA;
```

#### Update Table Operation

**d1) Update Table Operation on Master**

```sql
mysql> update MYSCB_DBA set role='L1DBA' where NAME='nobi';
mysql> COMMIT;
mysql> SELECT * FROM MYSCB_DBA WHERE NAME='nobi';
```

**d2) Verify Update Table Operation on Slave**

```sql
mysql> SELECT * FROM MYSCB_DBA WHERE NAME='nobi';
```

#### Delete Table Operation

**e1) Delete Table Operation on Master**

```sql
mysql> DELETE FROM MYSCB_DBA WHERE NAME='nobi';
mysql> commit;
mysql> SELECT * FROM MYSCB_DBA WHERE NAME='nobi';
```

**e2) Verify Delete Table Operation on Slave**

```sql
mysql> SELECT * FROM MYSCB_DBA WHERE NAME='nobi';
```
```

