SELECT
    table_schema,
    ROUND(SUM(data_length + index_length) / 1024 / 1024, 3) AS 'Database Size (MB)',
    ROUND(SUM(data_free) / 1024 / 1024, 3) AS 'Free Space (MB)'
FROM
    information_schema.tables
GROUP BY
    table_schema
ORDER BY
    2 DESC;
