SELECT COUNT(DISTINCT p.property_id) as high_value_properties
FROM owners o
LEFT JOIN properties p
ON o.owner_id = p.owner_id
WHERE p.market_value > 500000
