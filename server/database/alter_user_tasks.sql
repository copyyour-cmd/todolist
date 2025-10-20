-- 为 user_tasks 表添加缺失字段以匹配 Flutter Task 实体
USE todolist_cloud;

-- 添加详细描述字段
ALTER TABLE user_tasks ADD COLUMN description TEXT COMMENT '任务详细描述' AFTER notes;

-- 添加标签字段（JSON格式存储）
ALTER TABLE user_tasks ADD COLUMN tags JSON COMMENT '标签列表（JSON数组）' AFTER list_id;

-- 添加重复类型字段
ALTER TABLE user_tasks ADD COLUMN repeat_type VARCHAR(50) COMMENT '重复类型: none, daily, weekly, monthly, yearly, custom' AFTER remind_at;

-- 添加重复规则字段（JSON格式）
ALTER TABLE user_tasks ADD COLUMN repeat_rule JSON COMMENT '重复规则（JSON格式）' AFTER repeat_type;

-- 添加子任务字段（JSON格式）
ALTER TABLE user_tasks ADD COLUMN sub_tasks JSON COMMENT '子任务列表（JSON数组）' AFTER repeat_rule;

-- 添加附件字段（JSON格式）
ALTER TABLE user_tasks ADD COLUMN attachments JSON COMMENT '附件列表（JSON数组）' AFTER sub_tasks;

-- 添加智能提醒字段（JSON格式）
ALTER TABLE user_tasks ADD COLUMN smart_reminders JSON COMMENT '智能提醒列表（JSON数组）' AFTER attachments;

-- 添加估计时长字段（分钟）
ALTER TABLE user_tasks ADD COLUMN estimated_minutes INT COMMENT '估计完成时长（分钟）' AFTER smart_reminders;

-- 添加实际时长字段（分钟）
ALTER TABLE user_tasks ADD COLUMN actual_minutes INT COMMENT '实际完成时长（分钟）' AFTER estimated_minutes;

-- 添加专注会话字段（JSON格式）
ALTER TABLE user_tasks ADD COLUMN focus_sessions JSON COMMENT '专注会话列表（JSON数组）' AFTER actual_minutes;

-- 添加位置提醒字段（JSON格式）
ALTER TABLE user_tasks ADD COLUMN location_reminder JSON COMMENT '位置提醒配置（JSON格式）' AFTER focus_sessions;

-- 添加排序顺序字段
ALTER TABLE user_tasks ADD COLUMN sort_order INT DEFAULT 0 COMMENT '排序顺序' AFTER location_reminder;

-- 添加是否置顶字段
ALTER TABLE user_tasks ADD COLUMN is_pinned TINYINT DEFAULT 0 COMMENT '是否置顶' AFTER sort_order;

-- 添加颜色标记字段
ALTER TABLE user_tasks ADD COLUMN color VARCHAR(20) COMMENT '颜色标记' AFTER is_pinned;

-- 添加来源模板ID字段
ALTER TABLE user_tasks ADD COLUMN template_id VARCHAR(100) COMMENT '来源模板ID' AFTER color;

-- 创建索引以优化查询
CREATE INDEX idx_is_pinned ON user_tasks(is_pinned);
CREATE INDEX idx_sort_order ON user_tasks(sort_order);
CREATE INDEX idx_repeat_type ON user_tasks(repeat_type);
CREATE INDEX idx_template_id ON user_tasks(template_id);

-- 更新notes字段为description（如果数据已存在）
UPDATE user_tasks SET description = notes WHERE description IS NULL AND notes IS NOT NULL;
