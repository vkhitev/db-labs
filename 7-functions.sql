USE tolling;

-- 7.x Functions
DROP function IF EXISTS total_beet_supply;
DELIMITER $$
CREATE FUNCTION total_beet_supply (_id INT)
RETURNS DECIMAL(10, 2)
BEGIN
	RETURN (
		SELECT
			IFNULL(SUM(beet_supplied), 0)
		FROM supply
		WHERE supply.agent_id = _id
    );
END$$

DROP function IF EXISTS total_sugar_estimated;
DELIMITER $$
CREATE FUNCTION total_sugar_estimated (_id INT)
RETURNS DECIMAL(10, 2)
BEGIN
	RETURN (
		SELECT
			IFNULL(SUM(sugar_estimated), 0)
		FROM supply
		WHERE supply.agent_id = _id
    );
END$$

DROP function IF EXISTS total_bagasse_estimated;
DELIMITER $$
CREATE FUNCTION total_bagasse_estimated (_id INT)
RETURNS DECIMAL(10, 2)
BEGIN
	RETURN (
		SELECT
			IFNULL(SUM(bagasse_estimated), 0)
		FROM supply
		WHERE supply.agent_id = _id
    );
END$$
    
DROP function IF EXISTS total_sugar_shipped;
DELIMITER $$
CREATE FUNCTION total_sugar_shipped (_id INT)
RETURNS DECIMAL(10, 2)
BEGIN
	RETURN (
		SELECT
			IFNULL(SUM(sugar_shipped), 0)
		FROM shipment
		WHERE shipment.agent_id = _id
    );
END$$

DROP function IF EXISTS total_bagasse_shipped;
DELIMITER $$
CREATE FUNCTION total_bagasse_shipped (_id INT)
RETURNS DECIMAL(10, 2)
BEGIN
	RETURN (
		SELECT
			IFNULL(SUM(bagasse_shipped), 0)
		FROM shipment
		WHERE shipment.agent_id = _id
    );
END$$

DROP function IF EXISTS rest_sugar;
DELIMITER $$
CREATE FUNCTION rest_sugar (_id INT)
RETURNS DECIMAL(10, 2)
BEGIN
	RETURN ( SELECT total_sugar_estimated(_id) - total_sugar_shipped(_id) );
END$$

DROP function IF EXISTS rest_bagasse;
DELIMITER $$
CREATE FUNCTION rest_bagasse (_id INT)
RETURNS DECIMAL(10, 2)
BEGIN
	RETURN ( SELECT total_bagasse_estimated(_id) - total_bagasse_shipped(_id) );
END$$

DELIMITER ;