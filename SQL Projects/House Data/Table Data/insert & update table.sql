UPDATE properties SET owner_id = CASE property_id
	WHEN 'p6' THEN 6
	WHEN 'p7' THEN 7
    WHEN 'p8' THEN 8
    WHEN 'p9' THEN 9
    WHEN 'p10' THEN 10
END
WHERE property_id IN ('p6','p7','p8','p9','p10')