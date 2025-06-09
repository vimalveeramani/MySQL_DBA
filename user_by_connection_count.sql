SELECT user, COUNT(*) AS connection_count
FROM information_schema.processlist
GROUP BY user
ORDER BY connection_count DESC;
