To safely purge binary log files, follow this procedure:

On each replica, use SHOW REPLICA STATUS to check which log file it is reading.

Obtain a listing of the binary log files on the source with SHOW BINARY LOGS.

Determine the earliest log file among all the replicas. This is the target file. If all the replicas are up to date, this is the last log file on the list.

Make a backup of all the log files you are about to delete. (This step is optional, but always advisable.)

Purge all log files up to but not including the target file.


PURGE BINARY LOGS Statement
`PURGE BINARY LOGS {
    TO 'log_name'
  | BEFORE datetime_expr
}`
