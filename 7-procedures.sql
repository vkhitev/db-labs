USE tolling;

-- 7.1 Common
DROP procedure IF EXISTS details;
DELIMITER $$
CREATE PROCEDURE details(in _id INT)
BEGIN
	SELECT
		total_beet_supply(_id) beet,
        total_sugar_estimated(_id) sugar_e,
        total_sugar_shipped(_id) sugar_s,
        rest_sugar(_id) sugar_r,
        total_bagasse_estimated(_id) bagasse_e,
        total_bagasse_shipped(_id) bagasse_s,
        rest_bagasse(_id) bagasse_r;
END$$
DELIMITER ;

-- 7.1 Uppercase
DROP procedure IF EXISTS upper_agent;
DELIMITER $$
CREATE PROCEDURE upper_agent ()
BEGIN
	SELECT
		id,
		UPPER(name) as name
	FROM agent;
END$$

DELIMITER ;

-- 7.2 Cursors
DROP procedure IF EXISTS build_agents_list;
DELIMITER $$
CREATE PROCEDURE build_agents_list (INOUT agents_list varchar(4000))
BEGIN
	DECLARE v_finished INTEGER DEFAULT 0;
	DECLARE v_name varchar(100) DEFAULT "";

	DEClARE agent_cursor CURSOR FOR
		SELECT name FROM agent;

	DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET v_finished = 1;

	OPEN agent_cursor;

	get_name: LOOP

		FETCH agent_cursor INTO v_name;

		IF v_finished = 1 THEN
			LEAVE get_name;
		END IF;

		SET agents_list = CONCAT(v_name, ", ", agents_list);

	END LOOP get_name;

	CLOSE agent_cursor;
END$$
DELIMITER ;

-- 7.2 Call procedure
SET @agents_list = "";
CALL build_agents_list(@agents_list);
SELECT @agents_list;
