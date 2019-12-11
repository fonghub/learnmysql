DROP FUNCTION IF EXISTS `func_tst_loop`;
CREATE FUNCTION `func_tst_loop`(end_i INT)
 RETURNS int(11)
    DETERMINISTIC
BEGIN
	DECLARE start_i INT DEFAULT 1;
	DECLARE result_i INT DEFAULT 0;

	func:LOOP
		IF start_i > end_i 
			THEN LEAVE func;		
		END IF;

		SET result_i = result_i + start_i;
		SET start_i = start_i + 1;
	END LOOP func;
	RETURN result_i; 
END;