模拟无锁状态下的并发更新数据

CREATE TABLE `test_i` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `num` int(11) DEFAULT '0',
  `edit_version` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

INSERT INTO `test`.`test_i` (`id`, `num`, `edit_version`) VALUES ('1', '200', '0');

1.从test_i表取得num字段的值
2.修改num字段的值
3.模拟执行业务，让进程睡眠0.1秒
4.把num的新值更新到test_i表

CREATE DEFINER=`root`@`localhost` PROCEDURE `decr_num_1`(IN interv INT)
BEGIN
	WHILE interv > 0 DO
		SELECT num INTO @num FROM test_i WHERE id=1;
		SET @num = @num - 1;
		-- 休眠0.1秒，模拟业务消耗时长
		SET @slp = SLEEP(0.1);
		UPDATE test_i SET num = @num WHERE id=1;
		SET interv = interv - 1;
	END WHILE;
END

测试：调用存储过程，开两个进程，每个进程调用100次
1.顺序的调用，结果num字段的值变为了0，这个符合我们的预期值
2.并发的调用，结果num字段的值大于0，因为多个进程同时在修改num字段的值，导致读取到脏数据，把其他进程的修改给刷掉了

CALL decr_num_1(100);

CALL decr_num_1(100);