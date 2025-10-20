// 调试上传功能
async function debugUpload() {
  const baseUrl = 'http://192.168.88.209:3000';
  
  try {
    // 1. 登录
    console.log('1. 登录...');
    const loginRes = await fetch(`${baseUrl}/api/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        username: 'copyyour',
        password: '123456',
        deviceType: 'android',
        deviceId: 'debug-device',
      })
    });

    const loginData = await loginRes.json();
    if (!loginData.success) {
      console.log('登录失败:', loginData);
      return;
    }

    const token = loginData.data.token;
    console.log('✓ 登录成功\n');

    // 2. 上传空数据测试
    console.log('2. 上传空数据...');
    const emptyUpload = await fetch(`${baseUrl}/api/cloud-sync/upload`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
      body: JSON.stringify({
        tasks: [],
        lists: [],
        tags: [],
        ideas: [],
        deviceId: 'debug-device',
      }),
    });

    const emptyResult = await emptyUpload.json();
    console.log('空数据上传结果:', emptyResult);
    
    if (!emptyResult.success) {
      console.log('\n✗ 空数据上传失败');
      console.log('错误详情:', emptyResult);
      return;
    }
    
    console.log('✓ 空数据上传成功\n');

    // 3. 上传单个列表
    console.log('3. 上传单个列表...');
    const singleListUpload = await fetch(`${baseUrl}/api/cloud-sync/upload`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
      body: JSON.stringify({
        tasks: [],
        lists: [{
          id: 'test-list-001',
          name: '测试列表',
          colorHex: '#4C83FB',
          sortOrder: 0,
          isDefault: true,
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString(),
        }],
        tags: [],
        ideas: [],
      }),
    });

    const singleListResult = await singleListUpload.json();
    console.log('单个列表上传结果:', singleListResult);

    if (singleListResult.success) {
      console.log('\n✓ 单个列表上传成功！');
    } else {
      console.log('\n✗ 单个列表上传失败');
      console.log('错误:', singleListResult);
    }

  } catch (error) {
    console.error('\n✗ 测试失败:', error.message);
    console.error(error);
  }
}

debugUpload();

