import mysql from 'mysql2/promise';
import dotenv from 'dotenv';

dotenv.config();

async function initDatabase() {
  let connection;
  
  try {
    // 先连接到MySQL服务器（不指定数据库）
    connection = await mysql.createConnection({
      host: process.env.DB_HOST || 'localhost',
      port: process.env.DB_PORT || 3306,
      user: process.env.DB_USER || 'root',
      password: process.env.DB_PASSWORD || 'goodboy',
      charset: 'utf8mb4'
    });

    console.log('✓ 已连接到MySQL服务器');

    // 创建数据库
    const dbName = process.env.DB_NAME || 'todolist_cloud';
    await connection.query(`CREATE DATABASE IF NOT EXISTS ${dbName} DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci`);
    console.log(`✓ 数据库 ${dbName} 创建成功`);

    // 使用数据库
    await connection.query(`USE ${dbName}`);

    // 创建用户表
    await connection.query(`
      CREATE TABLE IF NOT EXISTS users (
        id INT PRIMARY KEY AUTO_INCREMENT,
        username VARCHAR(50) NOT NULL UNIQUE,
        email VARCHAR(100) NOT NULL UNIQUE,
        password_hash VARCHAR(255) NOT NULL,
        nickname VARCHAR(50),
        avatar_url VARCHAR(255),
        phone VARCHAR(20),
        status TINYINT DEFAULT 1,
        last_login_at DATETIME,
        last_login_ip VARCHAR(45),
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX idx_username (username),
        INDEX idx_email (email),
        INDEX idx_created_at (created_at)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    `);
    console.log('✓ users 表创建成功');

    // 创建用户会话表
    await connection.query(`
      CREATE TABLE IF NOT EXISTS user_sessions (
        id INT PRIMARY KEY AUTO_INCREMENT,
        user_id INT NOT NULL,
        token VARCHAR(500) NOT NULL UNIQUE,
        refresh_token VARCHAR(500),
        device_id VARCHAR(100),
        device_name VARCHAR(100),
        device_type VARCHAR(20),
        ip_address VARCHAR(45),
        user_agent TEXT,
        expires_at DATETIME NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        last_used_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        INDEX idx_user_id (user_id),
        INDEX idx_token (token(255)),
        INDEX idx_expires_at (expires_at)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    `);
    console.log('✓ user_sessions 表创建成功');

    // 创建用户任务表
    await connection.query(`
      CREATE TABLE IF NOT EXISTS user_tasks (
        id INT PRIMARY KEY AUTO_INCREMENT,
        user_id INT NOT NULL,
        client_id VARCHAR(100) NOT NULL,
        title VARCHAR(255) NOT NULL,
        notes TEXT,
        list_id VARCHAR(100),
        priority VARCHAR(20) DEFAULT 'none',
        status VARCHAR(20) DEFAULT 'pending',
        due_at DATETIME,
        remind_at DATETIME,
        completed_at DATETIME,
        deleted_at DATETIME,
        version INT DEFAULT 1,
        sync_status TINYINT DEFAULT 0,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        UNIQUE KEY uk_user_client_id (user_id, client_id),
        INDEX idx_user_id (user_id),
        INDEX idx_status (status),
        INDEX idx_due_at (due_at),
        INDEX idx_deleted_at (deleted_at)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    `);
    console.log('✓ user_tasks 表创建成功');

    // 创建同步日志表
    await connection.query(`
      CREATE TABLE IF NOT EXISTS sync_logs (
        id BIGINT PRIMARY KEY AUTO_INCREMENT,
        user_id INT NOT NULL,
        device_id VARCHAR(100),
        sync_type VARCHAR(20) NOT NULL,
        records_count INT DEFAULT 0,
        status VARCHAR(20) DEFAULT 'success',
        error_message TEXT,
        sync_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        INDEX idx_user_id (user_id),
        INDEX idx_sync_at (sync_at)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    `);
    console.log('✓ sync_logs 表创建成功');

    // 创建密码重置表
    await connection.query(`
      CREATE TABLE IF NOT EXISTS password_resets (
        id INT PRIMARY KEY AUTO_INCREMENT,
        user_id INT NOT NULL,
        reset_token VARCHAR(100) NOT NULL UNIQUE,
        expires_at DATETIME NOT NULL,
        used TINYINT DEFAULT 0,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        INDEX idx_reset_token (reset_token),
        INDEX idx_expires_at (expires_at)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    `);
    console.log('✓ password_resets 表创建成功');

    console.log('\n═══════════════════════════════════════');
    console.log('✓ 数据库初始化完成！');
    console.log('═══════════════════════════════════════');

  } catch (error) {
    console.error('✗ 数据库初始化失败:', error.message);
    process.exit(1);
  } finally {
    if (connection) {
      await connection.end();
    }
  }
}

initDatabase();

