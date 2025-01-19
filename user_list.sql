SELECT
    host,
    user,
    max_connections,
    max_user_connections,
    password_expired,
    password_last_changed,
    password_lifetime,
    account_locked,
    password_reuse_time,
    password_require_current
FROM
    mysql.user
ORDER BY
    host,
    user;
