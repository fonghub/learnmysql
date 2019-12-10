DROP FUNCTION IF EXISTS `func_tst_if`;

CREATE DEFINER = `root`@`localhost` FUNCTION `func_tst_if`(a INT,b INT)
 RETURNS int(11)
    DETERMINISTIC
BEGIN
	IF a > b THEN RETURN a; ELSE RETURN b; END IF;
END;

