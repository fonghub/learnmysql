CREATE TABLE `test_i` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `num` int(11) DEFAULT '0',
  `edit_version` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

INSERT INTO `test`.`test_i` (`id`, `num`, `edit_version`) VALUES ('1', '200', '0');


-- 添加共享锁
BEGIN;
SELECT * FROM test_i LOCK IN SHARE MODE;
SET @slp = SLEEP(10);
COMMIT;



-- 同时执行修改操作
UPDATE test_i SET num=num-1 WHERE id=1;
SELECT * FROM test_i;



-- 结果是更新语句需要等待共享锁释放，才能开始执行更新操作
-- 当数据记录被添加共享锁时，不能执行修改操作，但是可以读取数据，也可以叠加添加共享锁