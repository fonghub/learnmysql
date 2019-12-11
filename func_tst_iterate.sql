DROP FUNCTION IF EXISTS `func_tst_iterate`;

CREATE FUNCTION `func_tst_iterate`(end_i INT)
 RETURNS int(11)
    DETERMINISTIC
BEGIN
	DECLARE start_i INT DEFAULT 1;
	DECLARE result_i INT DEFAULT 0;

	loop_lable:LOOP
		IF start_i <= end_i 
			THEN 
				SET result_i = result_i + start_i;
				SET start_i = start_i + 1;
				ITERATE loop_lable;
		END IF;
		LEAVE loop_lable;
	END LOOP loop_lable;

	RETURN result_i; 
END;