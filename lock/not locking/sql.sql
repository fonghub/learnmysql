
CREATE TABLE `test_i` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `num` int(11) DEFAULT '0',
  `edit_version` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

INSERT INTO `test`.`test_i` (`id`, `num`, `edit_version`) VALUES ('1', '200', '0');

CREATE DEFINER=`root`@`localhost` PROCEDURE `decr_num_1`(IN interv INT)
BEGIN
	WHILE interv > 0 DO
		SELECT 
			num INTO @num
		FROM test_i WHERE id=1;
		SET @num = @num - 1;
		-- 休眠0.1秒
		SET @slp = SLEEP(0.1);
		UPDATE test_i SET num = @num WHERE id=1;
		SET interv = interv - 1;
	END WHILE;

END

-- 分别调用存储过程
CALL decr_num_1(100);

CALL decr_num_1(100);