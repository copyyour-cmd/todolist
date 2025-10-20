import mysql from 'mysql2/promise';
import fs from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';
import dotenv from 'dotenv';

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

async function initDatabase() {
  let connection;

  try {
    // 首先连接到 MySQL（不指定数据库）
    connection = await mysql.createConnection({
      host: process.env.DB_HOST || 'localhost',
      port: process.env.DB_PORT || 3306,
      user: process.env.DB_USER || 'root',
      password: process.env.DB_PASSWORD || 'goodboy',
      multipleStatements: true
    });

    console.log('✓ 连接到 MySQL 服务器成功');

    // 读取 schema.sql 文件
    const schemaPath = path.join(__dirname, '../database/schema.sql');
    const schema = await fs.readFile(schemaPath, 'utf8');

    console.log('✓ 读取数据库模式文件成功');

    // 执行 SQL 脚本
    await connection.query(schema);

    console.log('✓ 数据库初始化成功');
    console.log(`  数据库名称: ${process.env.DB_NAME || 'todolist_cloud'}`);
    console.log('  包含以下表:');
    console.log('    - users (用户表)');
    console.log('    - user_sessions (用户会话表)');
    console.log('    - user_tasks (用户任务表)');
    console.log('    - sync_logs (同步日志表)');
    console.log('    - password_resets (密码重置表)');

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
