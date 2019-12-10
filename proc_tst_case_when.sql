DROP PROCEDURE IF EXISTS `proc_tst_case_when`;

CREATE DEFINER = `root`@`localhost` PROCEDURE `proc_tst_case_when`(IN param INT)
BEGIN

	SELECT
	CASE param+1
	WHEN 1000 THEN 'gz'
	WHEN 1001 THEN 'sz'
	WHEN 1002 THEN 'zhh'
	WHEN 1003 THEN 'st'
	ELSE 'null'
	END city1;
	

	SELECT 
	CASE
	WHEN param=1000 THEN 'gz'
	WHEN param=1001 THEN 'sz'
	WHEN param=1002 THEN 'zhh'
	WHEN param=1003 THEN 'st'
	ELSE 'null'
	END city2;
END;

