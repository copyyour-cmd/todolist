// 测试云同步API
const http = require('http');

const API_BASE = 'http://192.168.88.209:3000';

// 测试健康检查端点
function testHealth() {
  return new Promise((resolve, reject) => {
    http.get(`${API_BASE}/health`, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        console.log('✓ Health Check:', JSON.parse(data));
        resolve();
      });
    }).on('error', reject);
  });
}

// 测试用户注册
function testRegister() {
  return new Promise((resolve, reject) => {
    const timestamp = Date.now().toString().slice(-8);
    const postData = JSON.stringify({
      username: 'user' + timestamp,
      email: 'test' + timestamp + '@example.com',
      password: 'Test123456'
    });

    const options = {
      hostname: '192.168.88.209',
      port: 3000,
      path: '/api/auth/register',
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(postData)
      }
    };

    const req = http.request(options, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        const result = JSON.parse(data);
        if (res.statusCode === 201) {
          console.log('✓ Register Success:', result.user);
          resolve(result);
        } else {
          console.log('✗ Register Failed:', result);
          reject(new Error('Register failed'));
        }
      });
    });

    req.on('error', reject);
    req.write(postData);
    req.end();
  });
}

// 测试同步状态
function testSyncStatus(token) {
  return new Promise((resolve, reject) => {
    const options = {
      hostname: '192.168.88.209',
      port: 3000,
      path: '/api/sync/status',
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${token}`
      }
    };

    http.request(options, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        const result = JSON.parse(data);
        console.log('✓ Sync Status:', result);
        resolve(result);
      });
    }).on('error', reject).end();
  });
}

// 运行所有测试
async function runTests() {
  try {
    console.log('\n=== 开始API测试 ===\n');

    // 1. 健康检查
    await testHealth();
    console.log('');

    // 2. 用户注册
    const registerResult = await testRegister();
    console.log('');

    // 3. 同步状态
    await testSyncStatus(registerResult.token);
    console.log('');

    console.log('=== 所有测试通过! ===\n');
  } catch (error) {
    console.error('✗ 测试失败:', error.message);
    process.exit(1);
  }
}

runTests();
