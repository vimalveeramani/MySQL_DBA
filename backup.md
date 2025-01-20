
## Table of Contents
1. [How to Backup a Single MySQL Database?](#how-to-backup-a-single-mysql-database)
2. [How to Backup Multiple MySQL Databases?](#how-to-backup-multiple-mysql-databases)
3. [How to Backup All MySQL Databases?](#how-to-backup-all-mysql-databases)
4. [How to Backup All MySQL Databases into Separate Backup Files for Each Database?](#how-to-backup-all-mysql-databases-into-separate-backup-files-for-each-database)
5. [How to Create a Compressed MySQL Database Backup?](#how-to-create-a-compressed-mysql-database-backup)
6. [How to Run MySQL Database Backup in nohup?](#how-to-run-mysql-database-backup-in-nohup)
7. [How to Backup Specific Tables in a Database?](#how-to-backup-specific-tables-in-a-database)
8. [How to Backup Each Table in a Separate Backup File?](#how-to-backup-each-table-in-a-separate-backup-file)

---

## 1. How to Backup a Single MySQL Database?

```bash
[root@rac1 ~]# mysqldump -u root -p nobi > /u01/mysql/data/backup/database_nobi_bkp.sql
Enter password:
[root@rac1 ~]#
```

```bash
[root@rac1 ~]# ls -lrth /u01/mysql/data/backup/database_nobi_bkp.sql
-rw-r--r--. 1 root root 76M Mar  8 00:34 /u01/mysql/data/backup/database_nobi_bkp.sql
[root@rac1 ~]#
```

-- Create a Backup with Timestamp
```bash
mysqldump -u root -p nobi > /u01/mysql/data/backup/database_nobi_bkp_$(date +%Y%m%d).sql
```

```bash
[root@rac1 ~]# ls -lrth /u01/mysql/data/backup/database_nobi_bkp_*
-rw-r--r--. 1 root root 81M Mar  8 00:39 /u01/mysql/data/backup/database_nobi_bkp_20210308.sql
[root@rac1 ~]#
```

---

## 2. How to Backup Multiple MySQL Databases?

```sql
mysql> SELECT table_schema AS "Database",
    -> ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS "Size (MB)"
    -> FROM information_schema.TABLES
    -> GROUP BY table_schema;
+--------------------+-----------+
| Database           | Size (MB) |
+--------------------+-----------+
| mysql              |      2.48 |
| information_schema |      0.00 |
| performance_schema |      0.00 |
| sys                |      0.02 |
| nobi               |     66.64 |
| hit                |      4.52 |
+--------------------+-----------+
6 rows in set (0.09 sec)

mysql>
```

```bash
mysqldump -u root -p --databases nobi hit > /u01/mysql/data/backup/databases_nobi_hit_bkp_$(date +%Y%m%d).sql
Enter password:
[root@rac1 ~]#
```

```bash
[root@rac1 ~]# ls -ltr /u01/mysql/data/backup/databases_nobi_hit_bkp_*
-rw-r--r--. 1 root root 88757223 Mar  8 00:54 /u01/mysql/data/backup/databases_nobi_hit_bkp_20210308.sql
[root@rac1 ~]#
```

-- Backup MySQL databases to separate files
```bash
for i in $(mysql -e 'show databases' -s --skip-column-names | egrep 'hit|nobi'); do
mysqldump $i > /u01/mysql/data/backup/database_backup_"$i"_$(date +%Y%m%d).sql
done
```

```bash
[root@rac1 ~]# for i in $(mysql -e 'show databases' -s --skip-column-names | egrep 'hit|nobi'); do
>     mysqldump $i > /u01/mysql/data/backup/database_backup_"$i"_$(date +%Y%m%d).sql
> done
[root@rac1 ~]#
```

```bash
[root@rac1 ~]# ls -lrth /u01/mysql/data/backup/database_backup_*.sql
-rw-r--r--. 1 root root 3.6M Mar  8 01:24 /u01/mysql/data/backup/database_backup_hit_20210308.sql
-rw-r--r--. 1 root root  82M Mar  8 01:24 /u01/mysql/data/backup/database_backup_nobi_20210308.sql
[root@rac1 ~]#
```

---

## 3. How to Backup All MySQL Databases?

```bash
mysqldump -u root -p --all-databases > /u01/mysql/data/backup/databases_all_bkp_$(date +%Y%m%d).sql
Enter password:
[root@rac1 ~]#
```

```bash
[root@rac1 ~]# ls -lrth /u01/mysql/data/backup/databases_all_bkp_*
-rw-r--r--. 1 root root 86M Mar  8 00:57 /u01/mysql/data/backup/databases_all_bkp_20210308.sql
[root@rac1 ~]#
```

---

## 4. How to Backup All MySQL Databases into Separate Backup Files for Each Database?

```bash
for i in $(mysql -e 'show databases' -s --skip-column-names); do
mysqldump --single-transaction $i > /u01/mysql/data/backup/db_backup_"$i"_$(date +%Y%m%d).sql
done
```

```bash
[root@rac1 ~]# for i in $(mysql -e 'show databases' -s --skip-column-names); do
> mysqldump --single-transaction $i > /u01/mysql/data/backup/db_backup_"$i"_$(date +%Y%m%d).sql
> done
mysqldump: Dumping 'information_schema' DB content is not supported
[root@rac1 ~]#
[root@rac1 ~]# date
Mon Mar  8 01:39:59 +08 2021
[root@rac1 ~]#
```

```bash
[root@rac1 ~]# ls -lrth /u01/mysql/data/backup/db_backup_*
-rw-r--r--. 1 root root 3.6M Mar  8 01:39 /u01/mysql/data/backup/db_backup_hit_20210308.sql
-rw-r--r--. 1 root root 791 Mar  8 01:39 /u01/mysql/data/backup/db_backup_information_schema_20210308.sql
-rw-r--r--. 1 root root 1.1M Mar  8 01:39 /u01/mysql/data/backup/db_backup_mysql_20210308.sql
-rw-r--r--. 1 root root  82M Mar  8 01:39 /u01/mysql/data/backup/db_backup_nobi_20210308.sql
-rw-r--r--. 1 root root  40M Mar  8 01:39 /u01/mysql/data/backup/db_backup_performance_schema_20210308.sql
-rw-r--r--. 1 root root 293K Mar  8 01:39 /u01/mysql/data/backup/db_backup_sys_20210308.sql
[root@rac1 ~]#
```

---

## 5. How to Create a Compressed MySQL Database Backup?

```bash
mysqldump -u root -p nobi | gzip > /u01/mysql/data/backup/db_backup_nobi.sql.gz
Enter password:
[root@rac1 ~]#
```

```bash
[root@rac1 ~]# ls -lrth /u01/mysql/data/backup/db_backup_nobi.sql.gz
-rw-r--r--. 1 root root 24M Mar  8 01:50 /u01/mysql/data/backup/db_backup_nobi.sql.gz
[root@rac1 ~]#
```

---

## 6. How to Run MySQL Database Backup in nohup?

```bash
[root@rac1 ~]# nohup mysqldump nobi | gzip > /u01/mysql/data/backup/db_backup_nobi$(date +%Y%m%d).sql.gz &
[1] 30969
[root@rac1 ~]# nohup: ignoring input and redirecting stderr to stdout
```

```bash
[root@rac1 ~]# jobs -l
[1]+ 30968 Running                 nohup mysqldump nobi
     30969                       | gzip > /u01/mysql/data/backup/db_backup_nobi$(date +%Y%m%d).sql.gz &
[root@rac1 ~]#
[1]+  Done                    nohup mysqldump nobi | gzip > /u01/mysql/data/backup/db_backup_nobi$(date +%Y%m%d).sql.gz
[root@rac1 ~]#
[root@rac1 ~]# ls -lrth /u01/mysql/data/backup/db_backup_nobi*.gz
-rw-r--r--. 1 root root 24M Mar  8 01:54 /u01/mysql/data/backup/db_backup_nobi20210308.sql.gz
[root@rac1 ~]#
```

---

## 7. How to Backup Specific Tables in a Database?

```bash
[root@rac1 ~]# mysqldump -u root -p nobi data test_data test_data2 > /u01/mysql/data/backup/db_nobi_tables_bkp_$(date +%Y%m%d).sql
Enter password:
[root@rac1 ~]#
```

```bash
[root@rac1 ~]# ls -lrth /u01/mysql/data/backup/db_nobi_tables_bkp*
-rw-r--r--. 1 root root 82M Mar  8 02:13 /u01/mysql/data/backup/db_nobi_tables_bkp_20210308.sql
[root@rac1 ~]#
```

---

## 8. How to Backup Each

 Table in a Separate Backup File?

```bash
for table in $(mysql -u root -p -e 'use nobi; show tables;' | awk '{ print $1 }' | tail -n +2); do
mysqldump -u root -p nobi $table > /u01/mysql/data/backup/table_backup_"$table"_$(date +%Y%m%d).sql
done
```

```bash
[root@rac1 ~]# for table in $(mysql -u root -p -e 'use nobi; show tables;' | awk '{ print $1 }' | tail -n +2); do
> mysqldump -u root -p nobi $table > /u01/mysql/data/backup/table_backup_"$table"_$(date +%Y%m%d).sql
> done
Enter password:
```

```bash
[root@rac1 ~]# ls -lrth /u01/mysql/data/backup/table_backup_*.sql
-rw-r--r--. 1 root root 1.1M Mar  8 02:25 /u01/mysql/data/backup/table_backup_test_data_20210308.sql
-rw-r--r--. 1 root root 752K Mar  8 02:25 /u01/mysql/data/backup/table_backup_test_data2_20210308.sql
[root@rac1 ~]#
```

---

