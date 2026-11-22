SELECT *
FROM owners o
LEFT JOIN properties p
ON p.owner_id = o.owner_id