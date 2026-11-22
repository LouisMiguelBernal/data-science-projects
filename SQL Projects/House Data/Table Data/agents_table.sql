CREATE TABLE agents (
    agent_id VARCHAR(10) PRIMARY KEY,
    agent_name VARCHAR(100),
    contact_number VARCHAR(20),
    email VARCHAR(100)
);

INSERT INTO agents (agent_id, agent_name, contact_number, email) VALUES
('a1', 'Alice Johnson', '555-1234', 'alice@agency.com'),
('a2', 'Marco Rodriguez', '555-5678', 'marco@realestate.com'),
('a3', 'Sarah Thompson', '555-9999', 'sarah@homesales.com');

ALTER TABLE properties
ADD COLUMN agent_id VARCHAR(10),
ADD FOREIGN KEY (agent_id) REFERENCES agents(agent_id);

-- Updating the properties table with agent_id links

UPDATE properties SET agent_id = 'a1' WHERE property_id = 'p1';
UPDATE properties SET agent_id = 'a2' WHERE property_id = 'p2';
UPDATE properties SET agent_id = 'a3' WHERE property_id = 'p3';
UPDATE properties SET agent_id = 'a1' WHERE property_id = 'p4';
UPDATE properties SET agent_id = 'a2' WHERE property_id = 'p5';
UPDATE properties SET agent_id = 'a3' WHERE property_id = 'p6';
UPDATE properties SET agent_id = 'a1' WHERE property_id = 'p7';
UPDATE properties SET agent_id = 'a2' WHERE property_id = 'p8';
UPDATE properties SET agent_id = 'a3' WHERE property_id = 'p9';
UPDATE properties SET agent_id = 'a1' WHERE property_id = 'p10';
