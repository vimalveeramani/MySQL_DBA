SELECT 
    host,
    user,
    COUNT(*) AS user_connections,
    SUM(COUNT(*)) OVER (PARTITION BY host) AS total_connections_per_host
FROM 
    information_schema.processlist
GROUP BY 
    host, user
ORDER BY 
    total_connections_per_host DESC, user_connections DESC;
