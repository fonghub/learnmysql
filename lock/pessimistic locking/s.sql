模拟共享锁（悲观锁）
乐观锁需要我们自己来实现，相对于的，悲观锁由数据库自己实现，要用的时候，调用数据库的相关语句就可以了。
共享锁和排他锁是悲观锁的两种不同实现。
CREATE TABLE `test_i` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `num` int(11) DEFAULT '0',
  `edit_version` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

INSERT INTO `test`.`test_i` (`id`, `num`, `edit_version`) VALUES ('1', '200', '0');


测试：
相继执行一下操作
1.对数据表添加共享锁

-- 添加共享锁
BEGIN;
SELECT * FROM test_i LOCK IN SHARE MODE;
-- 睡眠10秒
SET @slp = SLEEP(10);
COMMIT;

2.执行更新数据操作

-- 同时执行修改操作
UPDATE test_i SET num=num-1 WHERE id=1;
SELECT * FROM test_i;



-- 结果是更新语句需要等待共享锁释放，才能开始执行更新操作
-- 当数据记录被添加共享锁时，不能执行修改操作，但是可以读取数据，也可以叠加添加共享锁