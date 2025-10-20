import mysql from 'mysql2/promise';
import dotenv from 'dotenv';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

dotenv.config();

async function initCloudSyncTables() {
  let connection;
  
  try {
    connection = await mysql.createConnection({
      host: process.env.DB_HOST || 'localhost',
      port: process.env.DB_PORT || 3306,
      user: process.env.DB_USER || 'root',
      password: process.env.DB_PASSWORD || 'goodboy',
      database: process.env.DB_NAME || 'todolist_cloud',
      charset: 'utf8mb4',
      multipleStatements: true
    });

    console.log('✓ 已连接到MySQL数据库');

    // 读取SQL文件
    const sqlFile = path.join(__dirname, '../database/cloud_sync_schema.sql');
    const sql = fs.readFileSync(sqlFile, 'utf8');

    // 执行SQL
    await connection.query(sql);

    console.log('✓ 云同步表结构创建成功');
    console.log('  - user_lists (用户列表)');
    console.log('  - user_tags (用户标签)');
    console.log('  - user_ideas (用户灵感)');
    console.log('  - user_settings (用户设置)');
    console.log('  - cloud_sync_records (同步记录)');
    console.log('  - cloud_snapshots (数据快照)');

    console.log('\n═══════════════════════════════════════');
    console.log('✓ 云同步数据库扩展完成！');
    console.log('═══════════════════════════════════════');

  } catch (error) {
    console.error('✗ 初始化失败:', error.message);
    process.exit(1);
  } finally {
    if (connection) {
      await connection.end();
    }
  }
}

initCloudSyncTables();

