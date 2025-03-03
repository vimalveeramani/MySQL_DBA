SELECT 
    table_name AS `Table`,
    ROUND((data_length + index_length) / 1024 / 1024, 2) AS `Size (MB)`
FROM information_schema.tables
WHERE table_schema = 'your_database_name'
AND table_name = 'your_table_name';
