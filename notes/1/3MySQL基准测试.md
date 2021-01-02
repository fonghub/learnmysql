### MySQL基准测试
1. 什么是基准测试

基准测试是一种测量和评估软件性能指标的活动，用于建立某个时刻的性能基准，以便当系统发生软硬件变化时重新进行相同的基准测试以评估变化对性能的影响。

2. 如何进行基准测试
    1. 基准测试的目的
        1. 建立MySQL服务器的性能基准线
        2. 模拟比当前系统更高的负载，以找出系统的扩展瓶颈
        3. 测试不同的硬件、软件和操作系统配置
        4. 证明新的硬件设备是否配置正确
    2. 基准测试的方法
        1. 对整个系统进行基准测试
        2. 单独对MySQL进行基准测试
    3. 基准测试常见指标
        1. TPS - 单位时间内所处理的事务数
        2. QPS - 单位时间内所处理的查询数
        3. 响应时间 - 平均、最小、最大、百分比响应时间
        4. 并发量 - 同时处理的查询请求的数量

3. 基准测试
4. 基准测试工具
    1. mysqlslap（默认安装的工具）
        - 参数及其用法通过 mysqlslap --help 查看
        - --auto-generate-sql
        - --auto-generate-sql-add-autoincrement
        - --only-print
        - --concurrency
        - --iterations
        - --number-int-cols
        - --number-char-cols
        - --engine
        - --number-of-queries
        - --create-schema
        - --password
        - 实例 - mysqlslap --concurrency=1,50,100,200 --iterations=2 --number-char-cols=5 --number-int-cols=5 --auto-generate-sql --auto-generate-sql-add-autoincrement --engine=myisam,innodb --number-of-queries=10 --create-schema=subtest -p

    2. sysbench