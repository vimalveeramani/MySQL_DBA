SELECT
    *
FROM
    sys.schema_unused_indexes
ORDER BY
    object_schema,
    object_name,
    index_name;
