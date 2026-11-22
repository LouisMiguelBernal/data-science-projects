SELECT conname, pg_get_constraintdef(pg_constraint.oid) AS constraint_definition
FROM pg_constraint
JOIN pg_class ON pg_constraint.conrelid = pg_class.oid
WHERE relname = 'properties'