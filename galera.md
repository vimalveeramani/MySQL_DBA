
# Galera Cluster Manager Installation Guide

## Acknowledgments
This guide is adapted from the official documentation available at [Galera Cluster Installation]. For comprehensive information regarding Galera Cluster, please visit the official website at [galeracluster.com].

## Important Disclaimer
The commands and scripts provided here are intended for instructional purposes only and come with **no warranty**. The user assumes full responsibility for any damage or data loss that may occur from executing these commands.

![Galera Cluster](https://computingforgeeks.com/wp-content/uploads/2021/04/mariadb-galera-cluster-1024x545.png?ezimgfmt=ng:webp/ngcb23)

## (Optional) Configuring the Firewall
To allow communication between cluster nodes, you may need to adjust the firewall settings based on your operating system and firewall software.

Generally, you can allow traffic from your cluster nodes with commands like:

```bash
ufw allow from <NODE_IP_1>
ufw allow from <NODE_IP_2>
ufw allow from <NODE_IP_3>
```
**Caution:** Replace `<NODE_IP_X>` with the actual IP addresses of your nodes.

## Step 1: Add MySQL Repositories
Begin by adding the necessary MySQL and Galera package repositories to each of your servers. This ensures you can install the required versions of MySQL and Galera.

For this guide, we will use MySQL version 5.7. Start by adding the Galera repository key:

```bash
apt-key adv --keyserver keyserver.ubuntu.com --recv BC19DDBA
```

After this, create a new repository file on each server:

```bash
echo "deb http://releases.galeracluster.com/mysql-wsrep-5.7/ubuntu bionic main" | sudo tee /etc/apt/sources.list.d/galera.list
echo "deb http://releases.galeracluster.com/galera-3/ubuntu bionic main" | sudo tee -a /etc/apt/sources.list.d/galera.list
```

Next, prioritize the Codership repositories by creating a preference file:

```bash
echo -e "Package: *\nPin: origin releases.galeracluster.com\nPin-Priority: 1001" | sudo tee /etc/apt/preferences.d/galera.pref
```

Update your package list:

```bash
sudo apt update
```

## Step 2: Install MySQL
Install the MySQL and Galera packages on all servers:

```bash
sudo apt install mariadb-server mariadb-client
```

If you encounter errors, you can use the following commands to resolve them:

```bash
sudo dpkg -i --force-overwrite /var/cache/apt/archives/mysql-wsrep-common-5.7_5.7.32-25.24-1ubuntu18.04_amd64.deb
sudo apt -f install
```

During the installation, you will be prompted to set a strong password for the MySQL admin user.

## Step 3: Disable AppArmor
To allow Galera to function correctly, disable the default AppArmor profile:

```bash
sudo ln -s /etc/apparmor.d/usr.sbin.mysqld /etc/apparmor.d/disable/
sudo apparmor_parser -R /etc/apparmor.d/usr.sbin.mysqld
```

Repeat this step on all servers.

## Step 4: Configure the First Node
Create a configuration file on the first server:

```bash
sudo vi /etc/mysql/conf.d/galera.cnf
```

Insert the following configuration, adjusting the IP addresses as necessary:

```ini
[mysqld]
binlog_format=ROW
default-storage-engine=innodb
innodb_autoinc_lock_mode=2
bind-address=0.0.0.0
wsrep_on=ON
wsrep_provider=/usr/lib/galera/libgalera_smm.so
wsrep_cluster_name="my_cluster"
wsrep_cluster_address="gcomm://<NODE_IP_1>,<NODE_IP_2>,<NODE_IP_3>"
wsrep_sst_method=rsync
wsrep_node_address="<NODE_IP_1>"
wsrep_node_name="node-a"
```

## Step 5: Configure Remaining Nodes
On the second and third nodes, repeat the configuration steps, modifying only the `wsrep_node_address` and `wsrep_node_name`.

## Step 6: Open Required Ports
Ensure the necessary ports are open on all servers:

```bash
sudo ufw allow 3306,4567,4568,4444/tcp
sudo ufw allow 4567/udp
```

## Step 7: Start the Cluster
Enable MySQL to start on boot:

```bash
sudo systemctl enable mysql
```

Start the first node with:

```bash
mysqld_bootstrap
```

Then, start the remaining nodes normally:

```bash
sudo systemctl start mysql
```

## Step 8: Test Replication
To verify that replication is working, create a database on the first node and check if it appears on the others:

```bash
mysql -u root -p -e "CREATE DATABASE playground;"
```

Check the second node to confirm:

```bash
mysql -u root -p -e "SHOW DATABASES;"
```

## Conclusion
You have successfully installed and configured Galera Cluster Manager. For further details, refer to the [installation manual].
```
