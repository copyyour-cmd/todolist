-- 回滚脚本：删除性能索引优化
-- 如需撤销所有索引优化，执行此脚本
-- 注意：此操作不可逆，请谨慎使用

USE todolist_cloud;

-- ============================================
-- 删除user_tasks表的复合索引
-- ============================================

-- 删除索引1：(user_id, status)
ALTER TABLE user_tasks DROP INDEX IF EXISTS idx_user_id_status;

-- 删除索引2：(user_id, due_at)
ALTER TABLE user_tasks DROP INDEX IF EXISTS idx_user_id_due_at;

-- 删除索引3：(user_id, deleted_at)
ALTER TABLE user_tasks DROP INDEX IF EXISTS idx_user_id_deleted_at;

-- ============================================
-- 删除user_lists表的复合索引
-- ============================================

-- 删除索引4：(user_id, is_default)
ALTER TABLE user_lists DROP INDEX IF EXISTS idx_user_id_is_default;

-- ============================================
-- 删除sync_logs表的复合索引
-- ============================================

-- 删除索引5：(user_id, sync_at)
ALTER TABLE sync_logs DROP INDEX IF EXISTS idx_user_id_sync_at;

-- ============================================
-- 删除cloud_sync_records表的复合索引
-- ============================================

-- 删除索引6：(user_id, started_at)
ALTER TABLE cloud_sync_records DROP INDEX IF EXISTS idx_user_id_started_at;

-- ============================================
-- 验证删除结果
-- ============================================

-- 查看user_tasks的剩余索引
-- SHOW INDEX FROM user_tasks;

-- 查看user_lists的剩余索引
-- SHOW INDEX FROM user_lists;

-- 查看sync_logs的剩余索引
-- SHOW INDEX FROM sync_logs;

-- 查看cloud_sync_records的剩余索引
-- SHOW INDEX FROM cloud_sync_records;

-- 回滚完成
-- SELECT 'All performance indexes have been rolled back successfully!' AS status;
