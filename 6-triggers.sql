-- 6.1 Test table
CREATE TABLE test_table (
	required INT NOT NULL,
    uniq INT UNIQUE,
    prim INT PRIMARY KEY,
    agent_id INT,
    INDEX test_table_fk1_idx (agent_id),
    FOREIGN KEY (agent_id)
		REFERENCES agent(id)
        ON DELETE CASCADE,
    CHECK (uniq > 20)
);

-- 6.2 Add unique constraint
ALTER TABLE agent
	ADD CONSTRAINT UNIQUE (name);

-- 6.2 Test unique
INSERT INTO agent (name)
	VALUES ('Жовтун Викория'), ('Жовтун Викория');
    
-- 6.2 Unsigned constraints
ALTER TABLE tolling.supply
CHANGE COLUMN beet_supplied beet_supplied DECIMAL(10,3) UNSIGNED NOT NULL,
CHANGE COLUMN sugar_estimated sugar_estimated DECIMAL(10,3) UNSIGNED NOT NULL,
CHANGE COLUMN bagasse_estimated bagasse_estimated DECIMAL(10,3) UNSIGNED NOT NULL;
    
ALTER TABLE tolling.shipment
CHANGE COLUMN sugar_shipped sugar_shipped DECIMAL(10,3) UNSIGNED NOT NULL,
CHANGE COLUMN bagasse_shipped bagasse_shipped DECIMAL(10,3) UNSIGNED NOT NULL;

    
-- 6.3 Supply triggers
DROP TRIGGER IF EXISTS supply_BEFORE_INSERT;
DELIMITER $$
CREATE TRIGGER supply_BEFORE_INSERT
BEFORE INSERT ON supply
FOR EACH ROW
BEGIN
	IF
		new.sugar_estimated < new.beet_supplied * 0.10 OR
		new.sugar_estimated > new.beet_supplied * 0.25
	THEN
		SIGNAL SQLSTATE '45000'
			SET message_text = 'Can not add or update row: sugar_estimated not in range';
	END IF;
	IF
		new.bagasse_estimated < new.beet_supplied * 0.7 OR
        new.bagasse_estimated > new.beet_supplied * 0.85
	THEN
		SIGNAL SQLSTATE '45000'
			SET message_text = 'Can not add or update row: bagasse_estimated not in range';
	END IF;
END$$

DROP TRIGGER IF EXISTS supply_BEFORE_UPDATE;
DELIMITER $$
CREATE TRIGGER supply_BEFORE_UPDATE
BEFORE UPDATE ON supply
FOR EACH ROW
BEGIN
	IF
		new.sugar_estimated < new.beet_supplied * 0.10 OR
		new.sugar_estimated > new.beet_supplied * 0.25
	THEN
		SIGNAL SQLSTATE '45000'
			SET message_text = 'Can not add or update row: sugar_estimated not in range';
	END IF;
	IF
		new.bagasse_estimated < new.beet_supplied * 0.7 OR
        new.bagasse_estimated > new.beet_supplied * 0.85
	THEN
		SIGNAL SQLSTATE '45000'
			SET message_text = 'Can not add or update row: bagasse_estimated not in range';
	END IF;
END$$

-- Trigger fails
INSERT INTO supply (bill_date, beet_supplied, sugar_estimated, bagasse_estimated, agent_id)
	VALUES (STR_TO_DATE('2014-01-01', '%Y-%m-%d'), 1000, 150, 790, 1);
    
-- Shipment triggers
DROP TRIGGER IF EXISTS shipment_BEFORE_INSERT;
DELIMITER $$
CREATE TRIGGER shipment_BEFORE_INSERT
BEFORE INSERT ON shipment
FOR EACH ROW
BEGIN
	IF
		new.sugar_shipped + total_sugar_shipped(new.agent_id) > total_sugar_estimated(new.agent_id)
	THEN
		SIGNAL SQLSTATE '45000'
			SET message_text = 'Can not add or update row: too much sugar shipped';
	END IF;
	IF
		new.bagasse_shipped + total_bagasse_shipped(new.agent_id) > total_bagasse_estimated(new.agent_id)
	THEN
		SIGNAL SQLSTATE '45000'
			SET message_text = 'Can not add or update row: too much bagasse shipped';
	END IF;
END$$

DROP TRIGGER IF EXISTS shipment_BEFORE_UPDATE;
DELIMITER $$
CREATE TRIGGER shipment_BEFORE_UPDATE
BEFORE UPDATE ON shipment
FOR EACH ROW
BEGIN
	IF
		new.sugar_shipped + total_sugar_shipped(new.agent_id) - old.sugar_shipped > total_sugar_estimated(new.agent_id)
	THEN
		SIGNAL SQLSTATE '45000'
			SET message_text = 'Can not add or update row: too much sugar shipped';
	END IF;
	IF
		new.bagasse_shipped + total_bagasse_shipped(new.agent_id) - old.bagasse_shipped > total_bagasse_estimated(new.agent_id)
	THEN
		SIGNAL SQLSTATE '45000'
			SET message_text = 'Can not add or update row: too much bagasse shipped';
	END IF;
END$$

DELIMITER ;

-- Trigger fails
INSERT INTO shipment (bill_date, sugar_shipped, bagasse_shipped, agent_id)
	VALUES (STR_TO_DATE('2014-01-01', '%Y-%m-%d'), 10, 1600, 1);
    
-- 6.4 Indexes
ALTER TABLE agent
	ADD CONSTRAINT UNIQUE (name);

-- 6.5 Sequences
CREATE TABLE students (
	emp_no INT(4) AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(50),
	last_name  VARCHAR(50)
)