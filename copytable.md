```sql
-- Create the new database
CREATE DATABASE testclients;

-- Select the database to use
USE testclients;

-- Create the table in the new database and copy the data from the existing table
CREATE TABLE clientsTest AS SELECT * FROM clients.clients;
```

This sequence:
1. Creates a new database named `testclients`.
2. Switches to the `testclients` database using `USE`.
3. Creates a new table `clientsTest` in `testclients` and copies all data from the existing `clients.clients` table into it.

ls!
