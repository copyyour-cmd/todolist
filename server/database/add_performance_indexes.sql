-- 性能索引优化脚本
-- 为TodoList数据库添加必要的复合索引以提升查询性能
-- 执行前请备份数据库

USE todolist_cloud;

-- ============================================
-- 任务表优化索引
-- ============================================

-- 索引1：(user_id, status) - 用于按用户和状态过滤任务
-- 常见查询：按状态显示用户任务列表
ALTER TABLE user_tasks ADD INDEX idx_user_id_status (user_id, status);

-- 索引2：(user_id, due_at) - 用于按截止日期排序任务
-- 常见查询：获取按截止日期排序的任务，用于日期视图
ALTER TABLE user_tasks ADD INDEX idx_user_id_due_at (user_id, due_at);

-- 索引3：(user_id, deleted_at) - 用于软删除过滤
-- 常见查询：获取未删除的用户任务
ALTER TABLE user_tasks ADD INDEX idx_user_id_deleted_at (user_id, deleted_at);

-- ============================================
-- 用户列表优化索引
-- ============================================

-- 索引4：(user_id, is_default) - 用于查找用户的默认列表
-- 常见查询：获取用户默认列表、设置默认列表时的其他列表更新
ALTER TABLE user_lists ADD INDEX idx_user_id_is_default (user_id, is_default);

-- ============================================
-- 用户标签优化索引
-- ============================================

-- 索引5：user_id已存在，无需重复添加
-- user_tags表已有 INDEX idx_user_id (user_id)
-- 验证：SHOW INDEX FROM user_tags;

-- ============================================
-- 同步日志优化索引
-- ============================================

-- 索引6：(user_id, sync_at) - 用于查询用户的同步历史
-- 常见查询：获取用户最近的同步记录，用于增量同步
ALTER TABLE sync_logs ADD INDEX idx_user_id_sync_at (user_id, sync_at);

-- 索引7：(user_id, sync_at) - 同步记录表的复合索引
-- 常见查询：查询特定用户的同步记录
ALTER TABLE cloud_sync_records ADD INDEX idx_user_id_started_at (user_id, started_at);

-- ============================================
-- 验证索引创建
-- ============================================

-- 查看user_tasks的所有索引
-- SHOW INDEX FROM user_tasks;

-- 查看user_lists的所有索引
-- SHOW INDEX FROM user_lists;

-- 查看user_tags的所有索引
-- SHOW INDEX FROM user_tags;

-- 查看sync_logs的所有索引
-- SHOW INDEX FROM sync_logs;

-- 查看cloud_sync_records的所有索引
-- SHOW INDEX FROM cloud_sync_records;
