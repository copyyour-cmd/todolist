import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import morgan from 'morgan';
import helmet from 'helmet';

dotenv.config();

import { testConnection } from './config/database.js';
import authRoutes from './routes/authRoutes.js';
import backupRoutes from './routes/backupRoutes.js';
import taskRoutes from './routes/taskRoutes.js';
import syncRoutes from './routes/syncRoutes.js';
import userRoutes from './routes/userRoutes.js';
import passwordRoutes from './routes/passwordRoutes.js';
import deviceRoutes from './routes/deviceRoutes.js';
import listRoutes from './routes/listRoutes.js';
import tagRoutes from './routes/tagRoutes.js';
import cloudSyncRoutes from './routes/cloudSyncRoutes.js';

const app = express();
const PORT = process.env.PORT || 3000;
const HOST = process.env.HOST || '192.168.88.209';

// 安全中间件
app.use(helmet());

// CORS 配置 - 白名单方式
const allowedOrigins = [
  'http://43.156.6.206:3000',
  'http://localhost',
  'http://127.0.0.1',
  /^http:\/\/localhost:\d+$/,  // 允许localhost的任意端口
  /^http:\/\/127\.0\.0\.1:\d+$/,  // 允许127.0.0.1的任意端口
];

app.use(cors({
  origin: function(origin, callback) {
    // 允许无origin的请求（如移动端应用）
    if (!origin) return callback(null, true);

    // 检查origin是否在白名单中
    const isAllowed = allowedOrigins.some(allowed => {
      if (typeof allowed === 'string') {
        return origin === allowed || origin.startsWith(allowed);
      }
      return allowed.test(origin);
    });

    if (isAllowed) {
      callback(null, true);
    } else {
      console.warn(`CORS拒绝来源: ${origin}`);
      callback(new Error('CORS策略拒绝此来源'));
    }
  },
  credentials: true
}));

// 解析请求体
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));

// HTTP 请求日志
app.use(morgan('dev'));

// 静态文件服务 - 提供上传的文件下载
app.use('/uploads', express.static('uploads'));

// 健康检查
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    service: 'TodoList API'
  });
});

// API路由
app.use('/api/auth', authRoutes);
app.use('/api/backup', backupRoutes);
app.use('/api/tasks', taskRoutes);
app.use('/api/lists', listRoutes);
app.use('/api/tags', tagRoutes);
app.use('/api/sync', syncRoutes);
app.use('/api/cloud-sync', cloudSyncRoutes);
app.use('/api/user', userRoutes);
app.use('/api/password', passwordRoutes);
app.use('/api/devices', deviceRoutes);

// 404处理
app.use((req, res) => {
  res.status(404).json({ error: '接口不存在' });
});

// 错误处理中间件
app.use((err, req, res, next) => {
  console.error('服务器错误:', err);
  res.status(500).json({
    error: '服务器内部错误',
    message: process.env.NODE_ENV === 'development' ? err.message : undefined
  });
});

// 启动服务器
async function startServer() {
  try {
    // 测试数据库连接
    const dbConnected = await testConnection();

    if (!dbConnected) {
      console.error('⚠️  警告: 数据库连接失败，但服务器仍将启动');
      console.error('   请确保MySQL服务已启动并运行数据库初始化脚本:');
      console.error('   mysql -u root -pgoodboy < database/init.sql');
    }

    app.listen(PORT, HOST, () => {
      console.log('═══════════════════════════════════════════════');
      console.log('✓ TodoList API 服务器启动成功');
      console.log(`✓ 监听地址: ${HOST}:${PORT}`);
      console.log(`✓ 服务地址: http://${HOST}:${PORT}`);
      console.log(`✓ 健康检查: http://${HOST}:${PORT}/health`);
      console.log('═══════════════════════════════════════════════');
      console.log('\n认证 API 端点:');
      console.log('  POST   /api/auth/register       - 用户注册');
      console.log('  POST   /api/auth/login          - 用户登录');
      console.log('  POST   /api/auth/refresh-token  - 刷新令牌');
      console.log('  GET    /api/auth/me             - 获取当前用户信息');
      console.log('  POST   /api/auth/logout         - 退出登录');
      console.log('\n备份 API 端点:');
      console.log('  POST   /api/backup/create       - 创建数据备份');
      console.log('  POST   /api/backup/restore/:id  - 恢复数据备份');
      console.log('  GET    /api/backup/list         - 获取备份列表');
      console.log('  GET    /api/backup/:id          - 获取备份详情');
      console.log('  DELETE /api/backup/:id          - 删除备份');
      console.log('  GET    /api/backup/history/list - 获取备份历史');
      console.log('\n任务 API 端点:');
      console.log('  GET    /api/tasks               - 获取任务列表');
      console.log('  GET    /api/tasks/:id           - 获取任务详情');
      console.log('  POST   /api/tasks               - 创建任务');
      console.log('  PUT    /api/tasks/:id           - 更新任务');
      console.log('  DELETE /api/tasks/:id           - 删除任务');
      console.log('  POST   /api/tasks/:id/restore   - 恢复任务');
      console.log('  POST   /api/tasks/batch/update  - 批量更新');
      console.log('  POST   /api/tasks/:id/attachments - 上传任务附件');
      console.log('  DELETE /api/tasks/:id/attachments/:attachmentId - 删除任务附件');
      console.log('\n列表 API 端点:');
      console.log('  GET    /api/lists               - 获取列表');
      console.log('  GET    /api/lists/:id           - 获取列表详情');
      console.log('  POST   /api/lists               - 创建列表');
      console.log('  PUT    /api/lists/:id           - 更新列表');
      console.log('  DELETE /api/lists/:id           - 删除列表');
      console.log('  POST   /api/lists/:id/restore   - 恢复列表');
      console.log('\n标签 API 端点:');
      console.log('  GET    /api/tags                - 获取标签');
      console.log('  GET    /api/tags/stats          - 获取标签统计');
      console.log('  GET    /api/tags/:id            - 获取标签详情');
      console.log('  POST   /api/tags                - 创建标签');
      console.log('  PUT    /api/tags/:id            - 更新标签');
      console.log('  DELETE /api/tags/:id            - 删除标签');
      console.log('  POST   /api/tags/:id/restore    - 恢复标签');
      console.log('\n同步 API 端点:');
      console.log('  POST   /api/sync                - 批量同步');
      console.log('  GET    /api/sync/status         - 同步状态');
      console.log('  GET    /api/sync/full           - 全量同步');
      console.log('\n用户 API 端点:');
      console.log('  GET    /api/user/profile        - 获取用户资料');
      console.log('  PUT    /api/user/profile        - 更新用户资料');
      console.log('  POST   /api/user/change-password - 修改密码');
      console.log('  POST   /api/user/avatar         - 上传头像');
      console.log('  DELETE /api/user/account        - 删除账户');
      console.log('\n密码重置 API 端点:');
      console.log('  POST   /api/password/reset-request - 请求重置');
      console.log('  POST   /api/password/verify-token - 验证令牌');
      console.log('  POST   /api/password/reset      - 重置密码');
      console.log('\n设备管理 API 端点:');
      console.log('  GET    /api/devices             - 获取设备列表');
      console.log('  GET    /api/devices/:id         - 获取设备详情');
      console.log('  DELETE /api/devices/:id         - 登出设备');
      console.log('  POST   /api/devices/logout-others - 登出其他设备');
      console.log('  PUT    /api/devices/:id/name    - 更新设备名称');
      console.log('═══════════════════════════════════════════════\n');
    });
  } catch (error) {
    console.error('✗ 服务器启动失败:', error);
    process.exit(1);
  }
}

startServer();

// 优雅退出
process.on('SIGINT', () => {
  console.log('\n正在关闭服务器...');
  process.exit(0);
});

process.on('SIGTERM', () => {
  console.log('\n正在关闭服务器...');
  process.exit(0);
});
