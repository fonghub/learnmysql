### MySQL性能
1. 层次结构
    1. 客户端
    2. MySQL服务层
        1. 连接管理器
        2. 查询缓存
        3. 查询解析
        4. 查询优化器
    3. 存储引擎层
2. 存储引擎分类
    1. myisam存储引擎
    2. Innodb存储引擎

3. mysiam存储引擎
    1. 文件组成：myisam存储引擎表由frm，MYI和MYD组成
    2. 特性：
        1. 并发性和锁级别：表级锁，读锁和写锁互斥，并发性不高
        2. 表损坏和修复：check table tablename，repair table tablename，myisamchk
        3. myisam表支持全文索引
        4. myisam表支持数据压缩：myisampack
    3. 限制
        1. 5.0以前限制单表大小，表的大小有两个配置的乘积决定：MAX_Rows * AVG_ROW_LENGTH
    4. 适用场景
        1. 非事务型应用
        2. 只读类应用
        3. 空间类应用

4. Innodb存储引擎
    > MySQL5.5及之后版本的默认存储引擎

    1. 表空间 innodb_file_per_table = ON/OFF
    
    >ON表示独立表空间：tablename.ibd
    >
    >OFF表示系统表空间：ibdataX

    2. 如何选择表空间

    3. 特性
        1. innodb是一种事务型存储引擎
        2. 完全支持事务的ACID特性
        3. Redo Log 和 Undo Log
            1. Redo Log 持久化 存储已提交的事务
                - 重做日志文件 innodb_log_files_in_group
                - 重做日志缓冲区 innodb_log_buffer_size
            1. Undo Log 存储未提交的事务
    
    4. 锁的类型
        1. 共享锁（也称读锁）
        2. 独占锁（也称写锁）

    5. 锁的粒度
        1. 表级锁
        2. 行级锁

    6. 阻塞和死锁
        1. 阻塞
        2. 死锁：系统会自动处理死锁

5. 其他存储引擎
    1. CSV存储引擎
    3. Archive存储引擎
    4. Memory存储引擎
    5. Federated存储引擎

6. 如何选择存储引擎
    1. 支持事务
    2. 备份
    3. 奔溃恢复
    4. 存储引擎的特有特性

7. MySQL服务器参数介绍
    1. 获取参数方式
        1. 命令行参数 —— 当前有效
        2. 配置文件 —— 永久有效
    
    2. 参数作用域
        1. 全局参数

        set global 参数名=参数值

        set @@global.参数名=参数值

        2. 会话参数

        set [session] 参数名=参数值

        set @@session.参数名=参数值

    3. 内存配置相关参数
        1. sort_buffer_size - 查询排序缓冲区大小
        2. join_buffer_size - 表连接缓冲区
        3. read_buffer_size - 读缓冲区大小
        4. read_rnd_buffer_size - 索引缓冲区大小
        5. innodb_buffer_pool_size - innodb缓冲池大小
        
        设置值可参考公式：总内存 - （每个线程所需要的内存 * 连接数） - 系统保留内存

        每个线程所需要的内存 = sort_buffer_size + join_buffer_size + read_buffer_size + read_rnd_buffer_size

        5. key_buffer_size - myisam表使用，用于缓存索引

    4. I/O相关参数
        1. Innode I/O相关配置
            - Innodb_log_file_size - 控制单个事务日志的大小
            - Innodb_log_files_in_group - 控制事务日志个数
            - 事务日志总大小 = Innodb_log_file_size * Innodb_log_files_in_group
            - Innodb_log_buffer_size - 控制事务日志缓冲区大小
            - Innodb_flush_log_at_trx_commit - 控制刷新事务日志的频度，默认值为1，建议设置为2
                - =0 - 每秒一次 log -> cache -> disk
                - =1 - 每次提交 log -> cache -> disk
                - =2 - 每次提交 log -> cache 每秒一次 cache -> disk
            - Innodb_flushh_method - O_DIRECT
            - Innodb_file_per_table - 启用Innodb系统表空间
            - Innodb_doublewrite - 启用Innodb双写缓存
        2. MyIsam I/O相关配置
            - delay_key_write - 控制关键字缓冲区中的脏块刷新频度
                - OFF - 每次操作后 刷新键缓冲中的脏块到磁盘
                - ON - 只对指定表使用刷新
                - ALL - 对所有MyIsam表使用延迟刷新

    5. 安全相关配置参数
        - expire_logs_days - 指定自动清理binlog的天数
        - max_allowed_packet - 控制MySQl可以接收的包的大小
        - skip_name_resolve - 禁用DNS查找
        - sysdate_is_now - 确保sysdate()返回确定性日期
        - read_only - 禁止非super权限的用户写权限
        - skip_slave_start - 禁用slave自动恢复
        - sql_mode - 设置MySQL所使用的SQL模式
            - strict_trans_tables
            - no_engine_subtitution
            - no_zero_date
            - no_zero_in_date
            - only_full_group_by
            - ...

    6. 其他常用配置参数
        - sync_binlog - 控制MySQL如何向磁盘刷新binlog
            - 0 - 
            - 1 - 
        - tmp_table_size 和 max_heap_table_size - 控制内存临时表大小
        - max_connections - 控制允许的最大连接数

8. 总结 - 性能优化顺序
    1. 优化数据库结构设计和SQL语句（持续优化）
    2. 数据库存储引擎的选择和参数配置（不要混合使用存储引擎）
    3. 系统选择及优化
    4. 硬件升级