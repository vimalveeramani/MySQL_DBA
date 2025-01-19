SELECT
    VERSION(),
    USER(),         -- client's reported user + host, same as SESSION_USER(), SYSTEM_USER()
    CURRENT_USER(), -- authenticated user name + host name - this is the one you want for debugging your mysql.user table configuration
    DATABASE(),     -- SCHEMA()
    NOW(),
    CURDATE(),
    CURTIME(),
    UTC_DATE(),
    UTC_TIME(),
    UTC_TIMESTAMP(),
    SYSDATE(),      -- returns date of function completion
    -- PS_CURRENT_THREAD_ID(),  -- MySQL 8.0.16+
    UUID_SHORT(),   -- integer
    UUID()   
