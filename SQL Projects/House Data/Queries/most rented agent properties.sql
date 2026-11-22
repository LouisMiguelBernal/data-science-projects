SELECT 
	a.agent_name, 
	COUNT(*) AS Most_rented_properties
FROM properties p
LEFT JOIN agents a
ON p.agent_id = a.agent_id
WHERE p.status = 'Rented'
GROUP BY a.agent_name
ORDER BY Most_rented_properties DESC
LIMIT 1
