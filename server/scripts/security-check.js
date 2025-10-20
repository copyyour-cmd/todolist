#!/usr/bin/env node

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

console.log('🔒 环境变量安全检查\n');
console.log('=' .repeat(60));

// 配置文件路径
const serverDir = path.join(__dirname, '..');
const envPath = path.join(serverDir, '.env');
const envExamplePath = path.join(serverDir, '.env.example');

let hasIssues = false;

// ===== 1. 检查.env文件是否存在 =====
console.log('\n[1] 检查 .env 文件存在性');
if (!fs.existsSync(envPath)) {
  console.error('   ❌ .env 文件不存在');
  console.log('   💡 执行: cp server/.env.example server/.env');
  hasIssues = true;
} else {
  console.log('   ✅ .env 文件存在');
}

// ===== 2. 检查.env.example是否包含敏感信息 =====
console.log('\n[2] 检查 .env.example 安全性');
if (fs.existsSync(envExamplePath)) {
  const exampleContent = fs.readFileSync(envExamplePath, 'utf8');

  const dangerousPatterns = [
    {
      pattern: /DB_PASSWORD=(?!your_|<|xxx|placeholder)[a-zA-Z0-9!@#$%^&*()_+\-=]{3,}/i,
      message: '数据库密码'
    },
    {
      pattern: /JWT_SECRET=(?!your_|<|xxx|placeholder)[a-zA-Z0-9\-_]{10,}/i,
      message: 'JWT密钥'
    },
    {
      pattern: /BACKUP_ENCRYPTION_KEY=(?!your_|<|xxx|placeholder)[a-zA-Z0-9\-_]{10,}/i,
      message: '备份加密密钥'
    },
    {
      pattern: /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/,
      message: 'IP地址',
      exclude: ['localhost', '127.0.0.1', '0.0.0.0']
    },
  ];

  let exampleIssues = false;
  dangerousPatterns.forEach(({ pattern, message, exclude }) => {
    const match = exampleContent.match(pattern);
    if (match) {
      const matchedText = match[0];
      const isExcluded = exclude && exclude.some(e => matchedText.includes(e));

      if (!isExcluded) {
        console.error(`   ❌ .env.example 包含真实 ${message}: ${matchedText}`);
        exampleIssues = true;
        hasIssues = true;
      }
    }
  });

  if (!exampleIssues) {
    console.log('   ✅ .env.example 不包含敏感信息');
  }
} else {
  console.log('   ⚠️  .env.example 文件不存在');
}

// ===== 3. 检查.gitignore配置 =====
console.log('\n[3] 检查 .gitignore 配置');
const gitignorePath = path.join(__dirname, '..', '..', '.gitignore');
if (fs.existsSync(gitignorePath)) {
  const gitignoreContent = fs.readFileSync(gitignorePath, 'utf8');
  const requiredPatterns = ['.env', 'server/.env'];
  const missingPatterns = requiredPatterns.filter(p => !gitignoreContent.includes(p));

  if (missingPatterns.length > 0) {
    console.error(`   ❌ .gitignore 缺少: ${missingPatterns.join(', ')}`);
    hasIssues = true;
  } else {
    console.log('   ✅ .gitignore 配置正确');
  }
} else {
  console.error('   ❌ .gitignore 文件不存在');
  hasIssues = true;
}

// ===== 4. 检查.env配置强度 =====
if (fs.existsSync(envPath)) {
  console.log('\n[4] 检查 .env 配置安全性');

  // 读取环境变量
  const envContent = fs.readFileSync(envPath, 'utf8');
  const env = {};
  envContent.split('\n').forEach(line => {
    const match = line.match(/^([^=]+)=(.*)$/);
    if (match) {
      env[match[1].trim()] = match[2].trim();
    }
  });

  const securityChecks = [
    {
      name: 'JWT_SECRET 长度',
      test: () => env.JWT_SECRET && env.JWT_SECRET.length >= 32,
      message: 'JWT密钥需要至少32字符',
      severity: 'high'
    },
    {
      name: 'JWT_SECRET 复杂度',
      test: () => {
        const secret = env.JWT_SECRET || '';
        return secret.length >= 32 &&
               (/[A-Z]/.test(secret) || /[a-z]/.test(secret)) &&
               (/[0-9]/.test(secret) || /[^A-Za-z0-9]/.test(secret));
      },
      message: 'JWT密钥应包含字母和数字/特殊字符',
      severity: 'high'
    },
    {
      name: '数据库密码存在',
      test: () => env.DB_PASSWORD && env.DB_PASSWORD.length > 0,
      message: '数据库密码不能为空',
      severity: 'critical'
    },
    {
      name: '数据库密码强度',
      test: () => {
        const pwd = env.DB_PASSWORD || '';
        return pwd.length >= 12 &&
               /[A-Z]/.test(pwd) &&
               /[a-z]/.test(pwd) &&
               /[0-9]/.test(pwd);
      },
      message: '数据库密码需要至少12字符，包含大小写字母和数字',
      severity: 'high'
    },
    {
      name: '避免弱密码',
      test: () => {
        const pwd = (env.DB_PASSWORD || '').toLowerCase();
        const weakPasswords = ['password', 'admin', '123456', 'qwerty', 'goodboy', 'test'];
        return !weakPasswords.some(weak => pwd.includes(weak));
      },
      message: '数据库密码不应包含常见弱密码',
      severity: 'critical'
    },
    {
      name: '避免使用 root 用户',
      test: () => env.DB_USER !== 'root',
      message: '生产环境不应使用 root 数据库用户',
      severity: 'medium'
    },
    {
      name: 'NODE_ENV 配置',
      test: () => ['development', 'production', 'test'].includes(env.NODE_ENV),
      message: 'NODE_ENV 应为 development、production 或 test',
      severity: 'low'
    },
    {
      name: 'BACKUP_ENCRYPTION_KEY 长度',
      test: () => !env.BACKUP_ENCRYPTION_KEY || env.BACKUP_ENCRYPTION_KEY.length >= 32,
      message: '备份加密密钥需要至少32字符',
      severity: 'medium'
    }
  ];

  let criticalIssues = 0;
  let highIssues = 0;
  let mediumIssues = 0;
  let lowIssues = 0;

  securityChecks.forEach(({ name, test, message, severity }) => {
    if (test()) {
      console.log(`   ✅ ${name}`);
    } else {
      const icon = severity === 'critical' ? '🚨' : severity === 'high' ? '❌' : '⚠️';
      console.error(`   ${icon} ${name}: ${message}`);
      hasIssues = true;

      if (severity === 'critical') criticalIssues++;
      else if (severity === 'high') highIssues++;
      else if (severity === 'medium') mediumIssues++;
      else lowIssues++;
    }
  });

  // ===== 5. 文件权限检查（仅Linux/Mac） =====
  if (process.platform !== 'win32') {
    console.log('\n[5] 检查文件权限');
    try {
      const stats = fs.statSync(envPath);
      const mode = stats.mode & parseInt('777', 8);
      const modeStr = mode.toString(8);

      if (mode <= parseInt('600', 8)) {
        console.log(`   ✅ .env 文件权限: ${modeStr} (安全)`);
      } else {
        console.error(`   ⚠️  .env 文件权限: ${modeStr} (建议设置为 600)`);
        console.log('   💡 执行: chmod 600 server/.env');
      }
    } catch (err) {
      console.log(`   ℹ️  无法检查文件权限: ${err.message}`);
    }
  }

  // ===== 安全报告总结 =====
  console.log('\n' + '='.repeat(60));
  console.log('安全检查报告');
  console.log('='.repeat(60));

  if (criticalIssues > 0) {
    console.error(`🚨 严重问题: ${criticalIssues} 个 - 必须立即修复！`);
  }
  if (highIssues > 0) {
    console.error(`❌ 高危问题: ${highIssues} 个 - 应尽快修复`);
  }
  if (mediumIssues > 0) {
    console.log(`⚠️  中危问题: ${mediumIssues} 个 - 建议修复`);
  }
  if (lowIssues > 0) {
    console.log(`ℹ️  低危问题: ${lowIssues} 个 - 可选修复`);
  }

  if (!hasIssues) {
    console.log('\n✅ 所有安全检查通过！');
    console.log('\n建议：');
    console.log('  - 定期轮换密钥（每季度）');
    console.log('  - 监控异常登录活动');
    console.log('  - 保持依赖包更新');
  } else {
    console.log('\n⚠️  发现安全问题，请立即修复！');
    console.log('\n修复建议：');
    console.log('  1. 查看 SECURITY.md 了解详细配置指南');
    console.log('  2. 查看 server/SECRETS_CHECKLIST.md 了解修复步骤');
    console.log('  3. 生成强密钥: openssl rand -base64 32');
    console.log('  4. 创建专用数据库用户，避免使用root');
  }
}

console.log('\n' + '='.repeat(60));
console.log(`检查完成时间: ${new Date().toLocaleString('zh-CN')}`);
console.log('='.repeat(60) + '\n');

process.exit(hasIssues ? 1 : 0);
