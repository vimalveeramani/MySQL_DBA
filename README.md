# MySQL DBA Repository

Welcome to the **MySQL DBA** repository! This repository contains scripts, configurations, and best practices for managing MySQL databases efficiently. It is designed for database administrators (DBAs) who work with MySQL in both standalone and cloud-based environments.

## 📌 Repository Overview
This repository includes:
- **Backup & Restore Scripts**: Automating MySQL backups using tools like `mysqldump`, Percona XtraBackup, and AWS S3.
- **Monitoring & Performance Tuning**: Queries and scripts for analyzing slow queries, monitoring replication, and optimizing performance.
- **Replication & High Availability**: Configurations and troubleshooting guides for MySQL replication, including row-based replication, ProxySQL setup, and Galera Cluster.
- **Security & User Management**: Best practices for user access control, privileges, and security enhancements.
- **Maintenance & Housekeeping**: Scripts for managing logs, purging old data, and automating routine DBA tasks.

## 🛠️ Features
- MySQL Backup Automation (local & AWS S3 storage)
- Query Optimization & Performance Monitoring
- ProxySQL Load Balancing Configuration
- Replication Setup (Master-Slave, Galera Cluster) & Troubleshooting
- MySQL Security & User Management
- Log Management (General Log & Slow Query Log handling, Binlog Purging)
- AWS RDS & Aurora MySQL Administration
- Stored Procedure & Function Analysis

## 📂 Folder Structure
```
/
├── backups/                 # Backup & restore scripts (backup.md, restore.md)
├── replication/             # Replication setup & troubleshooting (Master-Slave.md, galera.md)
├── monitoring/              # Monitoring & logging scripts (latency_by_host.sql, latency_by_user.sql, memory_by_host.sql, memory_by_user.sql, mysql_host_summary.sql, mysql_info.sql)
├── optimization/            # Query optimization & index analysis (non_indexed.sql, unused_index.sql, nonsystem_table.sql)
├── security/                # Security best practices & user management (user_list.sql, users.sql, users_summary.sql)
├── scripts/                 # Miscellaneous automation scripts (copytable.md, binlog_purging.md, db_by-size.sql)
├── procedures/              # Stored procedure & function-related queries (to_find_stored_procedure.sql, to_view_structure_sp.sql)
└── sessions/                # Session & connection management (sessions.sql, tables.sql)
```

## 🚀 Getting Started
### Prerequisites
- MySQL 8.0+ (Aurora MySQL 8.0.39 supported)
- AWS CLI (for S3 backup automation)
- ProxySQL (for load balancing)
- Percona Toolkit (for monitoring & tuning)
- PMM (Percona Monitoring & Management for MySQL)

### Installation & Usage
1. Clone the repository:
   ```sh
   git clone https://github.com/vimalveeramani/MySQL_DBA.git
   cd MySQL_DBA
   ```
2. Customize scripts as needed and execute them based on the requirements.

## 📖 Documentation
Refer to the detailed documentation in each folder for instructions on usage and best practices.

## 🤝 Contributing
Contributions are welcome! Feel free to submit pull requests or open issues for bug reports and feature requests.

## 📜 License
This repository is licensed under the [MIT License](LICENSE).

## 📧 Contact
For any queries, reach out via GitHub issues or email.

Happy DBA-ing! 🚀

