CREATE TABLE `test_i` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `num` int(11) DEFAULT '0',
  `edit_version` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

INSERT INTO `test`.`test_i` (`id`, `num`, `edit_version`) VALUES ('1', '200', '0');

CREATE DEFINER=`root`@`localhost` PROCEDURE `decr_num_2`(IN interv INT)
BEGIN
	WHILE interv > 0 DO
		SELECT 
			num INTO @num
		FROM test_i WHERE id=1;
		SELECT 
			edit_version INTO @edit_version
		FROM test_i WHERE id=1;
		SET @num = @num - 1;
		-- 休眠0.1秒，模拟业务消耗时长
		SET @slp = SLEEP(0.1);
		UPDATE test_i SET num = @num,edit_version=@edit_version + 1 WHERE id = 1 AND edit_version=@edit_version;
		-- 返回受影响行数
		SELECT ROW_COUNT() INTO @result_id;
		IF @result_id = 1
			THEN SET interv = interv - 1;
		END IF;
	END WHILE;

END

-- 分别调用存储过程
CALL decr_num_2(100);

CALL decr_num_2(100);