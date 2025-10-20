/**
 * 安全的CORS配置
 * 只允许白名单中的域名访问
 */

const cors = require('cors');

/**
 * 从环境变量读取允许的源
 * 生产环境应该配置具体的域名
 * 开发环境可以使用localhost
 */
const getAllowedOrigins = () => {
  if (process.env.ALLOWED_ORIGINS) {
    return process.env.ALLOWED_ORIGINS.split(',').map(origin => origin.trim());
  }

  // 默认允许的源(仅用于开发)
  if (process.env.NODE_ENV === 'development') {
    return [
      'http://localhost:3000',
      'http://localhost:8080',
      'http://127.0.0.1:3000'
    ];
  }

  // 生产环境必须配置ALLOWED_ORIGINS
  console.warn('⚠️  警告: 生产环境未配置ALLOWED_ORIGINS,CORS将拒绝所有请求');
  return [];
};

const allowedOrigins = getAllowedOrigins();

const corsOptions = {
  origin: (origin, callback) => {
    // 允许没有origin的请求(如移动应用、Postman、服务器间调用)
    if (!origin) {
      return callback(null, true);
    }

    // 检查origin是否在白名单中
    if (allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      console.warn(`🚫 CORS阻止了来自 ${origin} 的请求`);
      callback(new Error(`来自 ${origin} 的请求未被CORS策略允许`));
    }
  },

  // 允许携带凭证(cookies, authorization headers等)
  credentials: true,

  // 允许的HTTP方法
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],

  // 允许的请求头
  allowedHeaders: [
    'Content-Type',
    'Authorization',
    'X-Requested-With',
    'Accept',
    'Origin'
  ],

  // 暴露的响应头(允许客户端访问)
  exposedHeaders: [
    'X-Total-Count',
    'X-Page-Count',
    'X-Current-Page'
  ],

  // 预检请求的缓存时间(秒)
  maxAge: 86400, // 24小时

  // 是否通过OPTIONS请求的预检
  preflightContinue: false,

  // OPTIONS请求的状态码
  optionsSuccessStatus: 204
};

/**
 * CORS中间件
 */
const corsMiddleware = cors(corsOptions);

/**
 * CORS错误处理中间件
 */
const corsErrorHandler = (err, req, res, next) => {
  if (err.message && err.message.includes('CORS')) {
    return res.status(403).json({
      success: false,
      message: 'CORS策略不允许此请求',
      error: process.env.NODE_ENV === 'development' ? err.message : undefined
    });
  }
  next(err);
};

/**
 * 打印CORS配置信息(仅开发环境)
 */
if (process.env.NODE_ENV === 'development') {
  console.log('✅ CORS配置:');
  console.log('   允许的源:', allowedOrigins);
  console.log('   允许凭证:', corsOptions.credentials);
  console.log('   允许方法:', corsOptions.methods);
}

module.exports = {
  corsMiddleware,
  corsErrorHandler,
  allowedOrigins
};
