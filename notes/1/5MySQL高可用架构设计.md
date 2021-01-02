### MySQL高可用架构设计
1. 二进制日志
    1. MySQL服务层日志
        - 二进制日志
        - 慢查询日志
        - 通用日志
    2. MySQL存储引擎层日志
        - 重做日志redo log
        - 回滚日志undo log

2. 二进制日志格式
    1. 基于段的格式
        - binlog_format=statement
        - 记录执行的SQL语句
        - 每次更改日志格式后，要刷新一下日志 - flush logs
        - 使用mysqlbinlog binlog.log 查看二进制日志
    2. 基于行的格式
        - binlog_format=ROW
        - 记录影响的每一行的语句
        - 辅助参数 - binlog_row_image = [full|minimal|noblob]
            - full - 记录受影响前后的每一行的每一列的数据内容
            - minimal - 只记录受影响的列的前后数据内容
            - noblob - 不记录blog和text列的数据，如果没有修改该列
        - 使用mysqlbinlog -vv binlog.log 查看二进制日志
    3. 混合日志格式
        - binlog_format=maxed
        - 根据SQL语句由系统决定基于段和基于行的日志格式进行选择

    4. 格式选择
        - 选择row格式或者mixed格式

3. 二进制日志格式对复制的影响
    1. 三种日志格式
        - 基于SQL语句的复制 - SBR
        - 基于行的复制 - RBR
        - 混合模式

    2. 基于SQL语句的复制 - SBR
        - 优点
            - 日志量少，节约网络传输I/O
            - 并不强制要求主从数据库的表定义完全相同
        - 缺点
            - 对于非确定性函数值，无法保证主从复制数据的一致性
            - 对于存储过程、触发器和自定义函数进行的修改造成数据不一致
            - 在从库上需要更多的锁

    3. 基于行的复制 - RBR
        - 优点
            - 可以应用于任何SQL的复制，包括非确定函数，存储过程等
            - 减少从库上锁的使用
        - 缺点
            - 要求主从数据库的表结构相同，否则可能中断复制
            - 无法在从库上单独执行触发器

    4. 推荐使用基于行的复制
4. MySQL复制工作过程
    1. 主库将变更写入二进制日志
    2. 从库读取主库的二进制日志，并写入到从库的中继日志（relay_log）中
    3. 在从库上重放中继日志中的日志

5. MySQL复制的方式
    1. 基于日志点的复制
    2. 基于GTID的复制

6. 基于日志点的复制
    1. 配置步骤
        - 在主库上建立复制账号

        create user 'repl'@'IP段' identified by 'password'; -- IP段为从库IP

        grant replication slave on *.* to 'repl'@'IP段';

        - 配置主库
            - bin_log = mysql-bin
            - server_id = 100
        - 配置从库
            - bin_log = mysql-bin -- 从库可将此配置注释，不记录二进制日志，减少IO和存储
            - server_id = 101
            - relay_log = mysql-relay-bin
            - log_slave_update = on
            - read_only = on
        - 初始化从库
            - mysqldump --master-data=2 --single-transaction    -- 详细的[mysqldump](https://www.cnblogs.com/chenmh/p/5300370.html)命令用法参考
            - xtrabackup --slave-info (所有的表均为innodb存储引擎)

        - 启动复制链路
            - 在master上执行 ```show master status``` 命令，获取```master_log_file```和```master_log_pos```值
            - change master to master_host='host ip',master_user='repl',master_password='123456',master_log_file='bin_log',master_log_pos=pos;
        - 开始复制
            - start slave;
            - 执行 ```show slave status``` 命令,验证slave上的IO线程和SQL线程是否都是执行状态
    2. 优点
        - 是MySQL最早支持的复制技术，bug相对较少
        - 对SQL查询没有任何限制
        - 故障处理比较容易
    3. 缺点
        - 故障转移时重新获取新的主库的日志点信息比较困难

7. 基于GTID的复制ID     [5.6及以上才支持的复制方式]
    1. 定义：全局事务ID，其保证为每一个在主上提交的事务在复制集群中可以生成一个唯一的ID
    2. 配置步骤
        - 配置主库
            - bin_log = mysql-bin
            - server_id = 100
            - gtid_mode = on
            - enforce-gtid-consistency
            - log-slave-update = on     5.7以下版本才需要配置
        - 配置从库
            - server_id = 101
            - relay_log = relay_log
            - gtid_mode = on
            - enforce-gtid-consistency
            - log-slave-update = on
            - read_only = on    建议
            - master_info_repository = TABLE    建议
            - relay_log_info_repository = TABLE     建议
        - 初始化从库
        - 启动GTID复制
            - change master to master_host='host ip',master_user='repl',master_password='123456',master_auto_position=1;
            - 重启服务器

8. MySQL复制拓扑
    1. 一主多从
    2. 主主复制

9. MySQL复制性能优化
    1. 影响因素
        - 主库写入二进制日志的时间
        - 二进制日志传输时间
        - 从库只有一个SQL线程,串行重写relay-log

10. 复制常见问题
    1. 数据损坏或丢失引起主从复制错误
    2. 在从库上进行数据修改造成的主从复制错误

11. 高可用介绍
    1. 定义:高可用H.A.(High Availability) 指的是通过尽量缩短因日常维护操作(计划)和突发的系统崩溃(非计划)所导致的停机时间,以提高系统和应用的可用性.
    2. 系统不可用的原因
        - 严重的主从延迟
        - 主从复制中断
        - 锁引起的大量阻塞
        - 软硬件故障
    3. 如何实现高可用

12. MMM架构介绍
    1. MMM - Multi-Master Replication Manager
    2. 功能单一,配置简单


13. HMA 架构介绍
    1. MHA - MySQL High Availability
    2. 功能强大,配置复杂


14. 读写分离和负载均衡
    1. 程序实现读写分离
        - 优点
            - 由开发人员控制查询从库或者主库,对于查询速度敏感的数据比较有效
            - 由程序直接连接数据库,所以性能损耗比较少
        - 缺点
            - 增加了开发工作量,程序代码更加复杂
            - 认为控制,容易出现错误
    2. 中间件实现读写分离
        - mysql-proxy 中间件
        - maxScale 中间件
        - 优点
            - 由中间件根据查询语法分析,自动完成读写分离
            - 对程序透明,对于已有程序不用做修改
        - 缺点
            - 增加了中间层后,所以查询效率有损耗
            
15. MaxScale中间件
    1. Authentication 认证插件
    2. Protocal 协议插件
    3. Router 路由插件
    4. Monitor 监控插件
    5. Filter&Logging 日志和过滤插件
