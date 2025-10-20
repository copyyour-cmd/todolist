import multer from 'multer';
import path from 'path';
import crypto from 'crypto';
import fs from 'fs';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// 确保上传目录存在
const uploadsDir = path.join(__dirname, '../uploads');
const avatarsDir = path.join(uploadsDir, 'avatars');
const attachmentsDir = path.join(uploadsDir, 'attachments');

[uploadsDir, avatarsDir, attachmentsDir].forEach(dir => {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
});

/**
 * 白名单MIME类型
 */
const ALLOWED_MIME_TYPES = {
  image: [
    'image/jpeg',
    'image/png',
    'image/gif',
    'image/webp'
  ],
  document: [
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/vnd.ms-excel',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'text/plain'
  ],
  archive: [
    'application/zip',
    'application/x-rar-compressed'
  ],
  media: [
    'audio/mpeg',
    'video/mp4',
    'video/x-msvideo'
  ]
};

/**
 * 所有允许的MIME类型
 */
const ALL_ALLOWED_MIMES = [
  ...ALLOWED_MIME_TYPES.image,
  ...ALLOWED_MIME_TYPES.document,
  ...ALLOWED_MIME_TYPES.archive,
  ...ALLOWED_MIME_TYPES.media
];

/**
 * 生成安全的随机文件名
 */
function generateSecureFilename(originalname) {
  const hash = crypto.randomBytes(16).toString('hex');
  const ext = path.extname(originalname).toLowerCase();
  const timestamp = Date.now();
  return `${timestamp}-${hash}${ext}`;
}

/**
 * 验证文件扩展名
 */
function validateExtension(filename) {
  const allowedExts = [
    '.jpg', '.jpeg', '.png', '.gif', '.webp',
    '.pdf', '.doc', '.docx', '.xls', '.xlsx', '.txt',
    '.zip', '.rar',
    '.mp3', '.mp4', '.avi'
  ];

  const ext = path.extname(filename).toLowerCase();
  return allowedExts.includes(ext);
}

/**
 * 图片文件过滤器
 */
const imageFilter = (req, file, cb) => {
  try {
    // 1. 验证扩展名
    if (!validateExtension(file.originalname)) {
      return cb(new Error('不支持的文件扩展名'));
    }

    // 2. 验证MIME类型
    if (!ALLOWED_MIME_TYPES.image.includes(file.mimetype)) {
      return cb(new Error('只允许上传图片文件'));
    }

    // 3. 验证文件名长度
    if (file.originalname.length > 255) {
      return cb(new Error('文件名过长'));
    }

    cb(null, true);
  } catch (error) {
    cb(error);
  }
};

/**
 * 附件文件过滤器(更严格的验证)
 */
const attachmentFilter = (req, file, cb) => {
  try {
    // 1. 验证扩展名
    if (!validateExtension(file.originalname)) {
      return cb(new Error('不支持的文件类型'));
    }

    // 2. 验证MIME类型
    if (!ALL_ALLOWED_MIMES.includes(file.mimetype)) {
      return cb(new Error(`不允许的文件类型: ${file.mimetype}`));
    }

    // 3. 验证文件名
    if (file.originalname.length > 255) {
      return cb(new Error('文件名过长(最多255字符)'));
    }

    // 4. 检查危险文件名模式
    const dangerousPatterns = [
      /\.exe$/i,
      /\.bat$/i,
      /\.cmd$/i,
      /\.sh$/i,
      /\.php$/i,
      /\.jsp$/i,
      /\.asp$/i,
      /\.js$/i,
      /\.html$/i,
      /\.htm$/i
    ];

    if (dangerousPatterns.some(pattern => pattern.test(file.originalname))) {
      return cb(new Error('检测到潜在危险的文件类型'));
    }

    cb(null, true);
  } catch (error) {
    cb(error);
  }
};

/**
 * 头像上传配置
 */
const avatarStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, avatarsDir);
  },
  filename: (req, file, cb) => {
    const secureFilename = generateSecureFilename(file.originalname);
    cb(null, `avatar-${req.user.id}-${secureFilename}`);
  }
});

/**
 * 附件上传配置
 */
const attachmentStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, attachmentsDir);
  },
  filename: (req, file, cb) => {
    const secureFilename = generateSecureFilename(file.originalname);
    cb(null, secureFilename);
  }
});

/**
 * 头像上传中间件
 */
export const uploadAvatar = multer({
  storage: avatarStorage,
  fileFilter: imageFilter,
  limits: {
    fileSize: 5 * 1024 * 1024, // 5MB
    files: 1 // 只允许1个文件
  }
});

/**
 * 附件上传中间件
 */
export const uploadAttachment = multer({
  storage: attachmentStorage,
  fileFilter: attachmentFilter,
  limits: {
    fileSize: 50 * 1024 * 1024, // 50MB
    files: 5 // 最多5个文件
  }
});

/**
 * 文件内容验证中间件(上传后验证)
 * 使用magic number验证真实文件类型
 */
export async function validateFileContent(req, res, next) {
  if (!req.file && (!req.files || req.files.length === 0)) {
    return next();
  }

  try {
    const files = req.file ? [req.file] : req.files;

    for (const file of files) {
      // 读取文件头(magic number)
      const buffer = Buffer.alloc(12);
      const fd = fs.openSync(file.path, 'r');
      fs.readSync(fd, buffer, 0, 12, 0);
      fs.closeSync(fd);

      // 验证文件签名
      const isValid = validateFileSignature(buffer, file.mimetype);

      if (!isValid) {
        // 删除可疑文件
        fs.unlinkSync(file.path);

        return res.status(400).json({
          success: false,
          message: '文件内容验证失败,文件类型与声明不符'
        });
      }
    }

    next();
  } catch (error) {
    console.error('文件内容验证错误:', error);
    next(error);
  }
}

/**
 * 验证文件签名(magic number)
 */
function validateFileSignature(buffer, mimetype) {
  const signatures = {
    'image/jpeg': [[0xFF, 0xD8, 0xFF]],
    'image/png': [[0x89, 0x50, 0x4E, 0x47]],
    'image/gif': [[0x47, 0x49, 0x46, 0x38]],
    'application/pdf': [[0x25, 0x50, 0x44, 0x46]],
    'application/zip': [[0x50, 0x4B, 0x03, 0x04], [0x50, 0x4B, 0x05, 0x06]],
    'audio/mpeg': [[0xFF, 0xFB], [0xFF, 0xF3], [0xFF, 0xF2]],
  };

  const expectedSignatures = signatures[mimetype];
  if (!expectedSignatures) {
    // 如果没有定义签名,允许通过(但已通过MIME验证)
    return true;
  }

  // 检查是否匹配任一签名
  return expectedSignatures.some(signature => {
    for (let i = 0; i < signature.length; i++) {
      if (buffer[i] !== signature[i]) {
        return false;
      }
    }
    return true;
  });
}

/**
 * 上传错误处理中间件
 */
export function handleUploadError(err, req, res, next) {
  if (err instanceof multer.MulterError) {
    const errorMessages = {
      'LIMIT_FILE_SIZE': '文件大小超出限制',
      'LIMIT_FILE_COUNT': '文件数量超出限制',
      'LIMIT_UNEXPECTED_FILE': '意外的文件字段',
      'LIMIT_FIELD_KEY': '字段名过长',
      'LIMIT_FIELD_VALUE': '字段值过长',
      'LIMIT_FIELD_COUNT': '字段数量过多'
    };

    return res.status(400).json({
      success: false,
      message: errorMessages[err.code] || `上传错误: ${err.message}`,
      error: err.code
    });
  }

  if (err) {
    console.error('文件上传错误:', err);
    return res.status(400).json({
      success: false,
      message: err.message || '文件上传失败'
    });
  }

  next();
}

/**
 * 获取文件URL
 */
export function getFileUrl(req, filename, type = 'attachment') {
  const protocol = process.env.NODE_ENV === 'production' ? 'https' : 'http';
  const host = req.get('host');
  const baseUrl = `${protocol}://${host}`;

  if (type === 'avatar') {
    return `${baseUrl}/uploads/avatars/${filename}`;
  }
  return `${baseUrl}/uploads/attachments/${filename}`;
}

/**
 * 安全删除文件
 */
export function deleteFile(filepath) {
  try {
    if (fs.existsSync(filepath)) {
      fs.unlinkSync(filepath);
      return true;
    }
    return false;
  } catch (error) {
    console.error('删除文件失败:', error);
    return false;
  }
}

/**
 * 清理过期文件(可选,用于定时任务)
 */
export function cleanupExpiredFiles(directory, maxAgeInDays = 30) {
  const maxAge = maxAgeInDays * 24 * 60 * 60 * 1000;
  const now = Date.now();

  fs.readdirSync(directory).forEach(file => {
    const filepath = path.join(directory, file);
    const stat = fs.statSync(filepath);

    if (now - stat.mtimeMs > maxAge) {
      fs.unlinkSync(filepath);
      console.log(`已删除过期文件: ${file}`);
    }
  });
}
