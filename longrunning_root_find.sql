SELECT 
    event_name, 
    OBJECT_TYPE, 
    OBJECT_SCHEMA, 
    OBJECT_NAME, 
    SQL_TEXT 
FROM 
    performance_schema.events_statements_current
WHERE 
    THREAD_ID = (
        SELECT THREAD_ID 
        FROM performance_schema.threads 
        WHERE PROCESSLIST_ID = query-id
    );
