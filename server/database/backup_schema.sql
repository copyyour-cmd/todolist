-- 备份相关数据库表
USE todolist_cloud;

-- 用户数据备份表
CREATE TABLE IF NOT EXISTS user_backups (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '备份ID',
    user_id INT NOT NULL COMMENT '用户ID',
    backup_name VARCHAR(255) NOT NULL COMMENT '备份名称',
    backup_type VARCHAR(20) DEFAULT 'full' COMMENT '备份类型: full-完整备份, incremental-增量备份',
    backup_size BIGINT DEFAULT 0 COMMENT '备份大小(字节)',
    device_id VARCHAR(100) COMMENT '设备ID',
    device_name VARCHAR(100) COMMENT '设备名称',
    device_type VARCHAR(20) COMMENT '设备类型',
    app_version VARCHAR(50) COMMENT '应用版本',
    backup_data LONGTEXT NOT NULL COMMENT '备份数据(JSON格式)',
    data_hash VARCHAR(64) COMMENT '数据哈希(用于校验)',
    is_encrypted TINYINT DEFAULT 0 COMMENT '是否加密',
    is_compressed TINYINT DEFAULT 0 COMMENT '是否压缩',
    backup_status VARCHAR(20) DEFAULT 'completed' COMMENT '备份状态: completed, failed, in_progress',
    error_message TEXT COMMENT '错误信息',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_created_at (created_at),
    INDEX idx_backup_type (backup_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户数据备份表';

-- 用户列表表（对应 Flutter 中的 TaskList）
CREATE TABLE IF NOT EXISTS user_lists (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '列表ID',
    user_id INT NOT NULL COMMENT '用户ID',
    client_id VARCHAR(100) NOT NULL COMMENT '客户端列表ID(UUID)',
    name VARCHAR(100) NOT NULL COMMENT '列表名称',
    icon VARCHAR(50) COMMENT '图标',
    color VARCHAR(20) COMMENT '颜色',
    sort_order INT DEFAULT 0 COMMENT '排序',
    is_default TINYINT DEFAULT 0 COMMENT '是否默认列表',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted_at DATETIME COMMENT '删除时间',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY uk_user_client_id (user_id, client_id),
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户列表表';

-- 用户标签表
CREATE TABLE IF NOT EXISTS user_tags (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '标签ID',
    user_id INT NOT NULL COMMENT '用户ID',
    client_id VARCHAR(100) NOT NULL COMMENT '客户端标签ID(UUID)',
    name VARCHAR(50) NOT NULL COMMENT '标签名称',
    color VARCHAR(20) COMMENT '颜色',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted_at DATETIME COMMENT '删除时间',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY uk_user_client_id (user_id, client_id),
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户标签表';

-- 用户设置表（扩展）
CREATE TABLE IF NOT EXISTS user_app_settings (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '设置ID',
    user_id INT NOT NULL UNIQUE COMMENT '用户ID',
    settings_data LONGTEXT NOT NULL COMMENT '设置数据(JSON格式)',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户应用设置表';

-- 备份恢复历史表
CREATE TABLE IF NOT EXISTS backup_restore_history (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '历史ID',
    user_id INT NOT NULL COMMENT '用户ID',
    backup_id BIGINT COMMENT '备份ID',
    operation_type VARCHAR(20) NOT NULL COMMENT '操作类型: backup, restore',
    status VARCHAR(20) DEFAULT 'success' COMMENT '状态: success, failed, partial',
    items_count INT DEFAULT 0 COMMENT '处理项目数',
    error_message TEXT COMMENT '错误信息',
    device_id VARCHAR(100) COMMENT '设备ID',
    ip_address VARCHAR(45) COMMENT 'IP地址',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (backup_id) REFERENCES user_backups(id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_backup_id (backup_id),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='备份恢复历史表';
