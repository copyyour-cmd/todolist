// 测试注册和登录API
async function testAuth() {
  const baseUrl = 'http://192.168.88.209:3000';

  console.log('═══════════════════════════════════════');
  console.log('测试注册登录API');
  console.log('═══════════════════════════════════════\n');

  try {
    // 1. 测试注册
    console.log('1. 测试用户注册...');
    const registerRes = await fetch(`${baseUrl}/api/auth/register`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        username: 'testuser001',
        email: 'test001@example.com',
        password: 'test123456',
        nickname: '测试用户001'
      })
    });

    const registerData = await registerRes.json();
    console.log('注册结果:', registerData);

    if (registerData.success) {
      console.log('✓ 注册成功!');
      console.log('  用户名:', registerData.data.user.username);
      console.log('  Token:', registerData.data.token.substring(0, 20) + '...');
    } else {
      console.log('✗ 注册失败:', registerData.message);
    }

    // 2. 测试登录
    console.log('\n2. 测试用户登录...');
    const loginRes = await fetch(`${baseUrl}/api/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        username: 'testuser001',
        password: 'test123456',
        deviceType: 'test',
        deviceId: 'test-device-001',
        deviceName: '测试设备'
      })
    });

    const loginData = await loginRes.json();
    console.log('登录结果:', loginData);

    if (loginData.success) {
      console.log('✓ 登录成功!');
      console.log('  用户名:', loginData.data.user.username);
      console.log('  Token:', loginData.data.token.substring(0, 20) + '...');

      // 3. 测试获取用户信息
      console.log('\n3. 测试获取用户信息...');
      const token = loginData.data.token;
      const meRes = await fetch(`${baseUrl}/api/auth/me`, {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      });

      const meData = await meRes.json();
      console.log('用户信息:', meData);

      if (meData.success) {
        console.log('✓ 获取用户信息成功!');
        console.log('  昵称:', meData.data.nickname);
        console.log('  邮箱:', meData.data.email);
      }
    } else {
      console.log('✗ 登录失败:', loginData.message);
    }

    console.log('\n═══════════════════════════════════════');
    console.log('✓ API测试完成');
    console.log('═══════════════════════════════════════');

  } catch (error) {
    console.error('\n✗ 测试出错:', error.message);
  }
}

testAuth();

