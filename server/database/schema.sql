-- TodoList 云服务数据库
-- 创建数据库
CREATE DATABASE IF NOT EXISTS todolist_cloud DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE todolist_cloud;

-- 用户表
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    email VARCHAR(100) NOT NULL UNIQUE COMMENT '邮箱',
    password_hash VARCHAR(255) NOT NULL COMMENT '密码哈希',
    nickname VARCHAR(50) COMMENT '昵称',
    avatar_url VARCHAR(255) COMMENT '头像URL',
    phone VARCHAR(20) COMMENT '手机号',
    status TINYINT DEFAULT 1 COMMENT '状态: 0-禁用 1-正常',
    last_login_at DATETIME COMMENT '最后登录时间',
    last_login_ip VARCHAR(45) COMMENT '最后登录IP',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- 用户会话表（用于管理登录会话和token）
CREATE TABLE IF NOT EXISTS user_sessions (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '会话ID',
    user_id INT NOT NULL COMMENT '用户ID',
    token VARCHAR(500) NOT NULL UNIQUE COMMENT 'JWT Token',
    refresh_token VARCHAR(500) COMMENT '刷新Token',
    device_id VARCHAR(100) COMMENT '设备ID',
    device_name VARCHAR(100) COMMENT '设备名称',
    device_type VARCHAR(20) COMMENT '设备类型: ios, android, web',
    ip_address VARCHAR(45) COMMENT 'IP地址',
    user_agent TEXT COMMENT 'User Agent',
    expires_at DATETIME NOT NULL COMMENT '过期时间',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    last_used_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后使用时间',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_token (token(255)),
    INDEX idx_expires_at (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户会话表';

-- 用户任务表（云同步）
CREATE TABLE IF NOT EXISTS user_tasks (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '任务ID',
    user_id INT NOT NULL COMMENT '用户ID',
    client_id VARCHAR(100) NOT NULL COMMENT '客户端任务ID(UUID)',
    title VARCHAR(255) NOT NULL COMMENT '任务标题',
    notes TEXT COMMENT '任务备注',
    list_id VARCHAR(100) COMMENT '列表ID',
    priority VARCHAR(20) DEFAULT 'none' COMMENT '优先级',
    status VARCHAR(20) DEFAULT 'pending' COMMENT '状态',
    due_at DATETIME COMMENT '截止时间',
    remind_at DATETIME COMMENT '提醒时间',
    completed_at DATETIME COMMENT '完成时间',
    deleted_at DATETIME COMMENT '删除时间（软删除）',
    version INT DEFAULT 1 COMMENT '版本号',
    sync_status TINYINT DEFAULT 0 COMMENT '同步状态: 0-已同步 1-待上传 2-冲突',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY uk_user_client_id (user_id, client_id),
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_due_at (due_at),
    INDEX idx_deleted_at (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户任务表';

-- 同步日志表
CREATE TABLE IF NOT EXISTS sync_logs (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '日志ID',
    user_id INT NOT NULL COMMENT '用户ID',
    device_id VARCHAR(100) COMMENT '设备ID',
    sync_type VARCHAR(20) NOT NULL COMMENT '同步类型: push, pull, conflict',
    records_count INT DEFAULT 0 COMMENT '记录数量',
    status VARCHAR(20) DEFAULT 'success' COMMENT '状态: success, failed, partial',
    error_message TEXT COMMENT '错误信息',
    sync_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '同步时间',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_sync_at (sync_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='同步日志表';

-- 密码重置表
CREATE TABLE IF NOT EXISTS password_resets (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '重置ID',
    user_id INT NOT NULL COMMENT '用户ID',
    reset_token VARCHAR(100) NOT NULL UNIQUE COMMENT '重置令牌',
    expires_at DATETIME NOT NULL COMMENT '过期时间',
    used TINYINT DEFAULT 0 COMMENT '是否已使用',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_reset_token (reset_token),
    INDEX idx_expires_at (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='密码重置表';

-- 创建测试用户（可选）
-- 密码: test123456 (BCrypt加密后需要替换)
-- INSERT INTO users (username, email, password_hash, nickname, status)
-- VALUES ('testuser', 'test@example.com', '$2b$10$...', '测试用户', 1);
