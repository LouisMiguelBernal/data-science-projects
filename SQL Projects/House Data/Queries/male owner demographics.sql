-- male owner demographics
SELECT 
	ROUND(AVG(o.age), 0) AS average_age,
	SUM(p.market_value) AS total_male_property_price
FROM owners o
JOIN properties p
ON o.owner_id = p.owner_id
WHERE sex = 'Male'
