模拟乐观锁状态下的并发更新数据

乐观锁本身是不加锁的，只是在更新时判断一下数据是否被其他线程更新了；
使用版本号机制来实现乐观锁；
版本号机制的基本思路是在数据中增加一个字段version，表示该数据的版本号，每当数据被修改，版本号加1；

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
		SELECT num INTO @num FROM test_i WHERE id=1;
		SELECT edit_version INTO @edit_version FROM test_i WHERE id=1;
		SET @num = @num - 1;
		-- 休眠0.1秒，模拟业务消耗时长
		SET @slp = SLEEP(0.1);
		UPDATE test_i SET num = @num,edit_version=@edit_version + 1 WHERE id = 1 AND edit_version=@edit_version;
		-- 返回受影响行数
		SELECT ROW_COUNT() INTO @result_id;
		-- 当update成功时，受影响行数 @result_id为1，否则更新不成功
		IF @result_id = 1
			THEN SET interv = interv - 1;
		END IF;
	END WHILE;
END

测试：调用存储过程，开两个进程，每个进程调用100次
测试结果显示，无论是使用顺序调用还是并发调用，查询test_i表最后的结果都是为num=0,edit_version=200,
表示num字段递减200次，每次递减1
使用乐观锁的运行时间比不使用锁运行时间长
CALL decr_num_2(100);

CALL decr_num_2(100);