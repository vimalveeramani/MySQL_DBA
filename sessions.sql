SELECT
    user,
    db,
    program_name,
    command,
    state,
    time,
    current_statement,
    current_memory,
    progress,
    lock_latency,
    rows_examined,
    rows_sent,
    rows_affected,
    tmp_tables,
    tmp_disk_tables,
    full_scan,
    last_statement,
    last_statement_latency,
    last_wait,
    last_wait_latency,
    trx_latency,
    trx_state
FROM
    sys.session
WHERE
    user <> 'sql/event_scheduler'
ORDER BY
    current_memory DESC;
