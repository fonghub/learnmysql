### SQL查询优化
1. 获取有性能问题SQL的方法
    - 通过反馈问题获取有性能问题的SQL
    - 通过慢查询日志获取
    - 实时获取存在性能问题的SQL

2. 慢查询介绍
    - slow_query_log - 启动停止记录慢查询日志
    - slow_query_log_file - 指定慢查询日志的存储路径及文件
    - long_query_time - 指定记录慢查询日志SQL执行时间的阈值
    - log_queries_not_using_indexes - 是否记录未使用索引的SQL
    - 记录的SQL语句包括
        - 查询语句
        - 数据修改语句
        - 已经回滚的SQL
    - 慢查询日志分析工具（mysqldumpslow）
    - 慢查询日志分析工具（pt-query-digest）
3. 实时获取有性能问题SQL
    - select id,user,host,db,command,time,status from information_schema.processlist where time >= 60;

4. SQL的解析预处理及生成执行计划
    1. MySQL服务器处理查询请求的整个过程
        - 客户端发送SQL请求给服务器
        - 服务器检查是否可以在查询缓存中命中该SQL
        - 服务器端进行SQL解析，预处理，再由优化器生成对应的执行计划
        - 根据执行计划，调用存储引擎API来查询数据
        - 将结果返回给客户端
    2. 查询缓存对SQL性能的影响
        - query_cache_type - 设置查询缓存是否可用
            - on
            - off
            - demand
        - query_cache_size
        - query_cache_limit
        - query_cache_wlock_invalidate
        - query_cache_min_res_unit

    3. MySQL查询优化器
    4. MySQL查询优化器可优化的SQL类型
        - 重新定义表的关联顺序
        - 将外连接转化成内连接
        - 使用等价变换规则
        - 优化count(),min()和max()
        - 将一个表达式转化为常数表达式
        - 优化子查询
        - 提前终止查询

5. 如何确定查询处理各个阶段所消耗的时间
    1. 使用profile
        - set profiling = 1
        - 执行查询
        - show profiles;
        - show profile for query ID
    2. 使用performance_schema
        - 打开监控
            - UPDATE `performance_schema`.setup_instruments SET ENABLED='YES',TIMED='YES' WHERE `NAME` LIKE 'stage%'
            - UPDATE `performance_schema`.setup_consumers SET ENABLED='YES' WHERE `NAME` LIKE 'stage%'


6. 特定SQL的查询优化
    1. 修改大表的表结构
        - 创建新表
        - 把老表的数据导出到新表
        - 删除老表
        - 重命名新表
    2. 通过join来优化not in和<>
    3. 使用汇总表来优化统计查询

