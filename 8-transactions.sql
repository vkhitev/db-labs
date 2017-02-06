USE tolling;
DROP procedure IF EXISTS rb;
DELIMITER $$
USE tolling$$
CREATE PROCEDURE rb(_id INT)
BEGIN
	DECLARE must_rollback BOOL DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET must_rollback = 1;
    START TRANSACTION;

	SAVEPOINT point1;

  -- This update is ok
	UPDATE supply
	SET sugar_estimated = sugar_estimated + 10
	WHERE agent_id = _id;

  -- This update fails trigger -> exception
	UPDATE shipment
	SET sugar_shipped = sugar_shipped + 1000
	WHERE agent_id = _id;

  IF must_rollback THEN
      ROLLBACK TO point1;
  ELSE
      COMMIT;
  END IF;
END$$

DELIMITER ;



SET AUTOCOMMIT = 0;



CALL details(@agent);

CALL rb(1);

-- Nothing changed after call rb
CALL details(@agent);

SET AUTOCOMMIT = 1;
