DROP FUNCTION IF EXISTS `func_tst_if`;

CREATE FUNCTION `func_tst_if`(a INT,b INT)
 RETURNS int(11)
    DETERMINISTIC
BEGIN
	IF a > b 
		THEN SET b = a; 
	END IF;
	RETURN b;
END;