import mysql from 'mysql2/promise';
import dotenv from 'dotenv';

dotenv.config();

// 创建连接池
const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 3306,
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || 'goodboy',
  database: process.env.DB_NAME || 'todolist_cloud',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
  charset: 'utf8mb4',
  timezone: '+00:00'
});

// 测试数据库连接
async function testConnection() {
  try {
    const connection = await pool.getConnection();
    console.log('✓ MySQL数据库连接成功');
    console.log(`  数据库: ${process.env.DB_NAME || 'todolist_cloud'}`);
    connection.release();
    return true;
  } catch (error) {
    console.error('✗ MySQL数据库连接失败:', error.message);
    return false;
  }
}

// 执行查询的辅助函数
async function query(sql, params = []) {
  try {
    const [results] = await pool.execute(sql, params);
    return results;
  } catch (error) {
    console.error('数据库查询错误:', error);
    throw error;
  }
}

/**
 * 执行事务 - 原子性操作支持
 * @param {Function} callback - 接收connection参数的异步函数
 * @returns {Promise<any>} callback的返回值
 *
 * 使用示例:
 * const result = await executeTransaction(async (conn) => {
 *   await conn.execute('INSERT INTO...', params1);
 *   await conn.execute('UPDATE...', params2);
 *   return someValue;
 * });
 */
async function executeTransaction(callback) {
  const connection = await pool.getConnection();
  try {
    // 开始事务
    await connection.beginTransaction();

    // 执行回调函数中的所有操作
    const result = await callback(connection);

    // 提交事务
    await connection.commit();
    return result;
  } catch (error) {
    // 发生错误，回滚事务
    await connection.rollback();
    console.error('事务回滚:', error.message);
    throw error;
  } finally {
    // 释放连接
    connection.release();
  }
}

export { pool, testConnection, query, executeTransaction };
