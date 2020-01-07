模拟排他锁（悲观锁）
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
1.对数据表添加排他锁

-- 添加排他锁
BEGIN;
SELECT * FROM test_i FOR UPDATE;
UPDATE test_i SET num=num-1 WHERE id=1;
-- 睡眠10秒
SET @slp = SLEEP(10);
COMMIT;


2.执行更新数据操作

-- 同时执行修改操作
SELECT * FROM test_i;
UPDATE test_i SET num=num-1 WHERE id=1;
SELECT * FROM test_i;




-- 结果是第一个select语句的num值为200，第二个select语句的num值为198
-- 由结果可知，数据记录添加排他锁后，可以读取，但是不能修改，直到排他锁解除
-- 排他锁解除掉后，num=199，才会执行update语句，所以最后的结果为num=198