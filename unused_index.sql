SELECT IF (@@performance_schema, 'TRUE', 'FALSE') AS 'Performance Schema enabled';

\! echo "Unused Indexes since startup:";

SELECT
    *
FROM
    sys.schema_unused_indexes
ORDER BY
    object_schema,
    object_name,
    index_name;
