SELECT 
	a.agent_name, 
	MAX(DISTINCT p.house_type) AS most_expensive_sold,
	COUNT(DISTINCT p.property_id) AS properties_sold,
	SUM( p.market_value) AS total_sold_value
FROM owners o
LEFT JOIN properties p
ON o.owner_id = p.owner_id
JOIN agents a
ON p.agent_id = a.agent_id
GROUP BY a.agent_name
ORDER BY properties_sold DESC
LIMIT 1

