const { body, validationResult } = require('express-validator');

/**
 * 密码强度验证
 * 要求: 至少8个字符,包含大小写字母、数字和特殊字符
 */
const passwordValidator = body('password')
  .isLength({ min: 8 })
  .withMessage('密码至少8个字符')
  .matches(/[a-z]/)
  .withMessage('密码必须包含小写字母')
  .matches(/[A-Z]/)
  .withMessage('密码必须包含大写字母')
  .matches(/[0-9]/)
  .withMessage('密码必须包含数字')
  .matches(/[!@#$%^&*(),.?":{}|<>]/)
  .withMessage('密码必须包含特殊字符');

/**
 * 用户名验证
 * 要求: 3-20个字符,只能包含字母、数字和下划线
 */
const usernameValidator = body('username')
  .isLength({ min: 3, max: 20 })
  .withMessage('用户名长度为3-20个字符')
  .matches(/^[a-zA-Z0-9_]+$/)
  .withMessage('用户名只能包含字母、数字和下划线')
  .trim()
  .escape();

/**
 * 邮箱验证
 */
const emailValidator = body('email')
  .optional()
  .isEmail()
  .withMessage('邮箱格式不正确')
  .normalizeEmail();

/**
 * 昵称验证
 */
const nicknameValidator = body('nickname')
  .optional()
  .isLength({ max: 50 })
  .withMessage('昵称最多50个字符')
  .trim()
  .escape();

/**
 * 任务标题验证
 */
const taskTitleValidator = body('title')
  .trim()
  .notEmpty()
  .withMessage('标题不能为空')
  .isLength({ max: 200 })
  .withMessage('标题最多200个字符')
  .escape();

/**
 * 任务列表ID验证
 */
const listIdValidator = body('listId')
  .trim()
  .notEmpty()
  .withMessage('列表ID不能为空')
  .isLength({ max: 255 })
  .withMessage('列表ID无效');

/**
 * 验证结果处理中间件
 */
const handleValidationErrors = (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({
      success: false,
      message: '输入验证失败',
      errors: errors.array().map(err => ({
        field: err.param,
        message: err.msg
      }))
    });
  }
  next();
};

/**
 * XSS防护 - 清理HTML标签
 */
const sanitizeHtml = (fieldName) => {
  return body(fieldName)
    .customSanitizer(value => {
      if (typeof value === 'string') {
        // 移除所有HTML标签
        return value.replace(/<[^>]*>/g, '');
      }
      return value;
    });
};

module.exports = {
  passwordValidator,
  usernameValidator,
  emailValidator,
  nicknameValidator,
  taskTitleValidator,
  listIdValidator,
  handleValidationErrors,
  sanitizeHtml
};
