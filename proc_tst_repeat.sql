DROP PROCEDURE IF EXISTS `proc_tst_repeat`;

CREATE PROCEDURE `proc_tst_repeat`()
BEGIN

DECLARE gid INT;
DECLARE a CHAR(100) DEFAULT '';
DECLARE done INT DEFAULT 0;


DECLARE cur CURSOR FOR SELECT itemid FROM jp_platform.game;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;

OPEN cur;

func:REPEAT
	FETCH cur INTO gid;
	SET a = CONCAT(a,gid);

UNTIL done=1 END REPEAT func;

CLOSE cur;
SELECT a;
END;