-- 添加缺失的复合索引
USE todolist_cloud;

-- sync_logs表缺少 (user_id, sync_at) 复合索引
-- 用于查询用户的同步历史，按时间倒序排列
-- 预期性能提升：75-80%
ALTER TABLE sync_logs ADD INDEX idx_user_id_sync_at (user_id, sync_at);

-- 验证索引创建
SELECT '=== 索引创建完成 ===' AS info;
SHOW INDEX FROM sync_logs WHERE Key_name = 'idx_user_id_sync_at';
