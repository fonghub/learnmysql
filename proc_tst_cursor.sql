DROP PROCEDURE IF EXISTS `proc_tst_cursor`;

CREATE DEFINER = `root`@`localhost` PROCEDURE `proc_tst_cursor`()
BEGIN
	DECLARE done INT DEFAULT 0;
	DECLARE a CHAR(100) DEFAULT '';
	DECLARE gid INT;

	DECLARE cur1 CURSOR FOR SELECT itemid FROM jp_platform.game;

	DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;

	OPEN cur1;
	
	func:LOOP
		FETCH cur1 INTO gid;
		IF done = 1 
			THEN LEAVE func;
		END IF;
		SET a = CONCAT(a,gid);
	END LOOP func;

	CLOSE cur1;
	SELECT a;
END;