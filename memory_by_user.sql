SELECT
    *
FROM
    sys.memory_by_user_by_current_bytes
WHERE
    user <> 'background'
ORDER BY
    total_allocated DESC;
