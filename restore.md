Here’s the step-by-step guide for restoring a MySQL database from a single backup:

---

### **How to Restore Database from a Single MySQL Database Backup**

1. **Check the Current Databases:**

   First, connect to MySQL and check the existing databases.

   ```bash
   [root@rac2 ~]# mysql
   Welcome to the MySQL monitor.  Commands end with ; or \g.
   Your MySQL connection id is 12
   Server version: 8.0.23 MySQL Community Server - GPL

   mysql> SELECT table_schema AS "Database",
       -> ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS "Size (MB)"
       -> FROM information_schema.TABLES
       -> GROUP BY table_schema;
   +--------------------+-----------+
   | Database           | Size (MB) |
   +--------------------+-----------+
   | information_schema |      0.00 |
   | mysql              |      2.48 |
   | performance_schema |      0.00 |
   | sys                |      0.02 |
   +--------------------+-----------+
   4 rows in set (0.19 sec)
   ```

2. **Error While Restoring:**

   If you attempt to restore into a database that doesn’t exist, you’ll get an error like this:

   ```bash
   [root@rac2 ~]# mysql orcl < /u01/mysql/data/orcl/backup/db_backup_orcl_20210308.sql
   ERROR 1049 (42000): Unknown database 'orcl'
   ```

3. **Create the Database Manually:**

   You need to create the database before restoring. Use the following command to create it:

   ```sql
   mysql> create database orcl;
   Query OK, 1 row affected (0.00 sec)
   ```

4. **Verify the Database Creation:**

   Check the list of databases to confirm that `orcl` has been created:

   ```sql
   mysql> show databases;
   +--------------------+
   | Database           |
   +--------------------+
   | information_schema |
   | mysql              |
   | orcl               |  <-- Created manually
   | performance_schema |
   | sys                |
   +--------------------+
   5 rows in set (0.00 sec)
   ```

5. **Restore the Database:**

   Now that the database is created, you can restore it from the backup file:

   ```bash
   [root@rac2 ~]# mysql orcl < /u01/mysql/data/orcl/backup/db_backup_orcl_20210308.sql
   ```

   There should be no errors, and the database will be restored successfully.

---

This is the standard procedure for restoring a MySQL database from a backup when the target database doesn’t exist yet. Let me know if you need further clarification!
