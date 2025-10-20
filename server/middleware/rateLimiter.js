const rateLimit = require('express-rate-limit');

/**
 * 全局API速率限制
 * 15分钟内最多100个请求
 */
const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15分钟
  max: 100,
  message: {
    success: false,
    message: '请求过于频繁,请稍后再试'
  },
  standardHeaders: true, // 返回rate limit信息在`RateLimit-*`头部
  legacyHeaders: false, // 禁用`X-RateLimit-*`头部
  handler: (req, res) => {
    res.status(429).json({
      success: false,
      message: '请求过于频繁,请稍后再试',
      retryAfter: req.rateLimit.resetTime
    });
  }
});

/**
 * 登录速率限制
 * 15分钟内最多5次登录尝试
 * 成功的登录不计入限制
 */
const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15分钟
  max: 5,
  skipSuccessfulRequests: true, // 成功的请求不计数
  message: {
    success: false,
    message: '登录尝试次数过多,请15分钟后再试'
  },
  handler: (req, res) => {
    res.status(429).json({
      success: false,
      message: '登录尝试次数过多,请15分钟后再试',
      retryAfter: Math.ceil((req.rateLimit.resetTime - Date.now()) / 1000)
    });
  }
});

/**
 * 注册速率限制
 * 1小时内最多3次注册尝试
 */
const registerLimiter = rateLimit({
  windowMs: 60 * 60 * 1000, // 1小时
  max: 3,
  message: {
    success: false,
    message: '注册请求过多,请稍后再试'
  },
  handler: (req, res) => {
    res.status(429).json({
      success: false,
      message: '注册请求过多,请1小时后再试'
    });
  }
});

/**
 * 文件上传速率限制
 * 15分钟内最多10次上传
 */
const uploadLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 10,
  message: {
    success: false,
    message: '文件上传过于频繁,请稍后再试'
  }
});

/**
 * 密码重置速率限制
 * 1小时内最多3次
 */
const passwordResetLimiter = rateLimit({
  windowMs: 60 * 60 * 1000,
  max: 3,
  message: {
    success: false,
    message: '密码重置请求过多,请1小时后再试'
  }
});

/**
 * 云同步速率限制
 * 1分钟内最多5次同步
 */
const syncLimiter = rateLimit({
  windowMs: 60 * 1000, // 1分钟
  max: 5,
  message: {
    success: false,
    message: '同步请求过于频繁,请稍后再试'
  }
});

module.exports = {
  apiLimiter,
  loginLimiter,
  registerLimiter,
  uploadLimiter,
  passwordResetLimiter,
  syncLimiter
};
