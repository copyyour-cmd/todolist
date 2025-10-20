/**
 * 安全加固后的服务器配置示例
 *
 * 使用方法:
 * 1. 复制此文件为 server.js (或合并到现有server.js)
 * 2. 安装所需依赖: npm install express-rate-limit helmet xss-clean express-validator
 * 3. 更新 .env 文件中的密钥
 * 4. 启动服务器: npm start
 */

import express from 'express';
import helmet from 'helmet';
import xss from 'xss-clean';
import dotenv from 'dotenv';

// 导入自定义中间件
import { corsMiddleware, corsErrorHandler } from './middleware/corsConfig.js';
import {
  apiLimiter,
  loginLimiter,
  registerLimiter,
  uploadLimiter,
  syncLimiter
} from './middleware/rateLimiter.js';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// ============================================
// 1. 安全中间件配置
// ============================================

/**
 * Helmet - 设置安全HTTP头部
 */
app.use(helmet({
  // Content Security Policy
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      scriptSrc: ["'self'"],
      imgSrc: ["'self'", "data:", "https:"],
      connectSrc: ["'self'"],
      fontSrc: ["'self'"],
      objectSrc: ["'none'"],
      mediaSrc: ["'self'"],
      frameSrc: ["'none'"],
    },
  },

  // HTTP Strict Transport Security
  hsts: {
    maxAge: 31536000, // 1年
    includeSubDomains: true,
    preload: true
  },

  // Referrer Policy
  referrerPolicy: {
    policy: 'strict-origin-when-cross-origin'
  },

  // X-Frame-Options
  frameguard: {
    action: 'deny'
  },

  // X-Content-Type-Options
  noSniff: true,

  // X-XSS-Protection
  xssFilter: true
}));

/**
 * CORS配置
 */
app.use(corsMiddleware);

/**
 * XSS防护
 */
app.use(xss());

/**
 * 请求体大小限制
 */
app.use(express.json({
  limit: '10kb',
  strict: true
}));

app.use(express.urlencoded({
  extended: true,
  limit: '10kb'
}));

/**
 * 移除X-Powered-By头部
 */
app.disable('x-powered-by');

/**
 * 信任代理(如果使用Nginx等反向代理)
 */
if (process.env.NODE_ENV === 'production') {
  app.set('trust proxy', 1);
}

// ============================================
// 2. 速率限制
// ============================================

/**
 * 全局API速率限制
 */
app.use('/api/', apiLimiter);

/**
 * 静态文件服务(上传的文件)
 */
app.use('/uploads', express.static('uploads', {
  maxAge: '1d',
  etag: true,
  lastModified: true
}));

// ============================================
// 3. 路由配置
// ============================================

/**
 * 认证路由(带速率限制)
 */
import authRoutes from './routes/auth.js';
app.use('/api/auth/login', loginLimiter);
app.use('/api/auth/register', registerLimiter);
app.use('/api/auth', authRoutes);

/**
 * 任务路由
 */
import taskRoutes from './routes/tasks.js';
app.use('/api/tasks', taskRoutes);

/**
 * 云同步路由(带速率限制)
 */
import syncRoutes from './routes/sync.js';
app.use('/api/sync', syncLimiter);
app.use('/api/sync', syncRoutes);

/**
 * 文件上传路由(带速率限制)
 */
import uploadRoutes from './routes/upload.js';
app.use('/api/upload', uploadLimiter);
app.use('/api/upload', uploadRoutes);

/**
 * 列表路由
 */
import listRoutes from './routes/lists.js';
app.use('/api/lists', listRoutes);

/**
 * 标签路由
 */
import tagRoutes from './routes/tags.js';
app.use('/api/tags', tagRoutes);

/**
 * 笔记路由
 */
import noteRoutes from './routes/notes.js';
app.use('/api/notes', noteRoutes);

/**
 * 用户路由
 */
import userRoutes from './routes/users.js';
app.use('/api/users', userRoutes);

/**
 * 健康检查(不受速率限制)
 */
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV
  });
});

// ============================================
// 4. 错误处理
// ============================================

/**
 * CORS错误处理
 */
app.use(corsErrorHandler);

/**
 * 404处理
 */
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: '请求的资源不存在',
    path: req.originalUrl
  });
});

/**
 * 全局错误处理
 */
app.use((err, req, res, next) => {
  // 记录错误
  console.error('服务器错误:', err);

  // 判断错误类型
  if (err.name === 'ValidationError') {
    return res.status(400).json({
      success: false,
      message: '数据验证失败',
      errors: err.errors
    });
  }

  if (err.name === 'UnauthorizedError') {
    return res.status(401).json({
      success: false,
      message: '未授权访问'
    });
  }

  if (err.name === 'JsonWebTokenError') {
    return res.status(401).json({
      success: false,
      message: 'Token无效'
    });
  }

  if (err.name === 'TokenExpiredError') {
    return res.status(401).json({
      success: false,
      message: 'Token已过期'
    });
  }

  // 默认错误响应
  const statusCode = err.statusCode || 500;
  res.status(statusCode).json({
    success: false,
    message: process.env.NODE_ENV === 'production'
      ? '服务器内部错误'
      : err.message,
    ...(process.env.NODE_ENV === 'development' && {
      stack: err.stack
    })
  });
});

// ============================================
// 5. 优雅关闭
// ============================================

function gracefulShutdown(signal) {
  console.log(`\n收到 ${signal} 信号,开始优雅关闭...`);

  server.close(() => {
    console.log('✅ HTTP服务器已关闭');

    // 关闭数据库连接
    if (global.db) {
      global.db.end(() => {
        console.log('✅ 数据库连接已关闭');
        process.exit(0);
      });
    } else {
      process.exit(0);
    }
  });

  // 30秒后强制关闭
  setTimeout(() => {
    console.error('❌ 强制关闭服务器');
    process.exit(1);
  }, 30000);
}

process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
process.on('SIGINT', () => gracefulShutdown('SIGINT'));

// ============================================
// 6. 启动服务器
// ============================================

const server = app.listen(PORT, () => {
  console.log('='.repeat(50));
  console.log('🚀 TodoList服务器已启动');
  console.log('='.repeat(50));
  console.log(`📡 端口: ${PORT}`);
  console.log(`🌍 环境: ${process.env.NODE_ENV || 'development'}`);
  console.log(`⏰ 启动时间: ${new Date().toLocaleString('zh-CN')}`);
  console.log('='.repeat(50));
  console.log('\n安全配置:');
  console.log('✅ Helmet安全头部');
  console.log('✅ CORS跨域保护');
  console.log('✅ XSS防护');
  console.log('✅ 速率限制');
  console.log('✅ 输入验证');
  console.log('✅ 文件上传安全');
  console.log('='.repeat(50));
  console.log('\n⚠️  重要提醒:');
  console.log('1. 确保已更新.env中的JWT_SECRET');
  console.log('2. 确保已更新.env中的DB_PASSWORD');
  console.log('3. 生产环境务必启用HTTPS');
  console.log('4. 配置ALLOWED_ORIGINS环境变量');
  console.log('='.repeat(50));
});

// 处理未捕获的异常
process.on('uncaughtException', (err) => {
  console.error('❌ 未捕获的异常:', err);
  process.exit(1);
});

process.on('unhandledRejection', (reason, promise) => {
  console.error('❌ 未处理的Promise拒绝:', reason);
  process.exit(1);
});

export default app;
