DROP FUNCTION IF EXISTS `func_tst_while`;

CREATE FUNCTION `func_tst_while`(end_i INT)
 RETURNS char(20)
    DETERMINISTIC
BEGIN
	DECLARE start_i INT DEFAULT 1;
	DECLARE result_i INT DEFAULT 0;
	WHILE start_i <= end_i DO
		SET result_i = result_i + start_i;
		SET start_i = start_i + 1;
	END WHILE;
	RETURN result_i;
END;