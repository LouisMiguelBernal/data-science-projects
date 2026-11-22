-- Count only 'Available' (unsold) properties per agent
SELECT 
    a.agent_name, 
    COUNT(*) AS unsold_properties             -- Counts only rows where status = 'Available'
FROM properties p
LEFT JOIN agents a ON p.agent_id = a.agent_id
WHERE p.status = 'Available'                 -- Filters to unsold properties before counting
GROUP BY a.agent_name
ORDER BY unsold_properties DESC
LIMIT 1;
