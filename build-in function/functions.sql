-- 	分组字符连接函数 GROUP_CONCAT()
	SELECT GROUP_CONCAT(itemid) INTO @itemids FROM jp_platform.game WHERE subgametype=1;

-- 	select @itemids; -- 返回 2301,2401,2441,2414,2511,2461,2404,2451,2501
	SELECT 2301 INTO @itemid;
-- 	select @itemid; -- 返回 2301

--  查找字符序号函数LOCATE()
--  @itemids为字符串
--  @itemid为子字符串
--  返回子字符串第一个出现在字符串中的位置序号（从1开始）
	SELECT LOCATE(@itemid,@itemids); -- 返回1
	
-- 	查找第一个字符串序号函数FIND_IN_SET()
-- 	@itemids为字符串集合，使用“,”隔开
--  @itemid为子字符串
--  返回字符串集中第一个出现字符串的位置序号（从1开始）
	SELECT FIND_IN_SET(@itemid,@itemids); -- 返回1
