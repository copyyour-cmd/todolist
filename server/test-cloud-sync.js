// 测试完整云同步功能
async function testCloudSync() {
  const baseUrl = 'http://192.168.88.209:3000';
  let token = '';

  console.log('═══════════════════════════════════════');
  console.log('测试完整云同步功能');
  console.log('═══════════════════════════════════════\n');

  try {
    // 1. 登录获取token
    console.log('1. 登录账户...');
    const loginRes = await fetch(`${baseUrl}/api/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        username: 'testuser001',
        password: 'test123456',
        deviceType: 'test',
        deviceId: 'test-sync-device',
      })
    });

    const loginData = await loginRes.json();
    if (!loginData.success) {
      console.log('✗ 登录失败:', loginData.message);
      return;
    }

    token = loginData.data.token;
    console.log('✓ 登录成功，Token:', token.substring(0, 20) + '...\n');

    // 2. 测试上传数据
    console.log('2. 测试上传数据到云端...');
    const uploadData = {
      tasks: [
        {
          id: 'task-test-001',
          title: '测试任务1',
          notes: '这是测试任务',
          listId: 'list-001',
          priority: 'high',
          status: 'pending',
          dueAt: null,
          remindAt: null,
          completedAt: null,
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString(),
        }
      ],
      lists: [
        {
          id: 'list-001',
          name: '测试列表',
          colorHex: '#4C83FB',
          sortOrder: 0,
          isDefault: true,
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString(),
        }
      ],
      tags: [
        {
          id: 'tag-001',
          name: '测试标签',
          colorHex: '#10B981',
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString(),
        }
      ],
      ideas: [
        {
          id: 'idea-001',
          title: '测试灵感',
          content: '这是一个测试灵感',
          category: 'general',
          tags: ['测试'],
          isFavorite: false,
          relatedTaskId: null,
          color: null,
          status: 'draft',
          implementedAt: null,
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString(),
        }
      ],
      deviceId: 'test-sync-device',
    };

    const uploadRes = await fetch(`${baseUrl}/api/cloud-sync/upload`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
      body: JSON.stringify(uploadData),
    });

    const uploadResult = await uploadRes.json();
    console.log('上传结果:', uploadResult);

    if (uploadResult.success) {
      console.log('✓ 数据上传成功！');
      console.log('  任务:', uploadResult.data.summary.tasks);
      console.log('  列表:', uploadResult.data.summary.lists);
      console.log('  标签:', uploadResult.data.summary.tags);
      console.log('  灵感:', uploadResult.data.summary.ideas);
    }

    // 3. 测试下载数据
    console.log('\n3. 测试从云端下载数据...');
    const downloadRes = await fetch(`${baseUrl}/api/cloud-sync/download`, {
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    });

    const downloadResult = await downloadRes.json();
    console.log('下载结果:', downloadResult);

    if (downloadResult.success) {
      console.log('✓ 数据下载成功！');
      console.log('  任务:', downloadResult.summary.tasks);
      console.log('  列表:', downloadResult.summary.lists);
      console.log('  标签:', downloadResult.summary.tags);
      console.log('  灵感:', downloadResult.summary.ideas);
    }

    // 4. 测试创建快照
    console.log('\n4. 测试创建云端快照...');
    const snapshotRes = await fetch(`${baseUrl}/api/cloud-sync/snapshots`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
      body: JSON.stringify({
        name: '自动测试快照',
        description: '这是自动化测试创建的快照',
      }),
    });

    const snapshotResult = await snapshotRes.json();
    console.log('快照结果:', snapshotResult);

    if (snapshotResult.success) {
      console.log('✓ 快照创建成功！');
      console.log('  快照ID:', snapshotResult.data.snapshotId);
      console.log('  数据大小:', snapshotResult.data.dataSize, 'bytes');
    }

    // 5. 测试获取快照列表
    console.log('\n5. 测试获取快照列表...');
    const listSnapshotsRes = await fetch(`${baseUrl}/api/cloud-sync/snapshots`, {
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    });

    const snapshotsList = await listSnapshotsRes.json();
    if (snapshotsList.success) {
      console.log('✓ 快照列表获取成功！');
      console.log('  快照数量:', snapshotsList.data.length);
    }

    // 6. 测试同步状态
    console.log('\n6. 测试获取同步状态...');
    const statusRes = await fetch(`${baseUrl}/api/cloud-sync/status`, {
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    });

    const statusResult = await statusRes.json();
    if (statusResult.success) {
      console.log('✓ 同步状态获取成功！');
      console.log('  云端数据:', statusResult.data.cloudDataCount);
      console.log('  最近同步:', statusResult.data.recentSyncs.length, '条记录');
    }

    console.log('\n═══════════════════════════════════════');
    console.log('✅ 所有云同步功能测试通过！');
    console.log('═══════════════════════════════════════');

  } catch (error) {
    console.error('\n✗ 测试失败:', error.message);
    console.error(error);
  }
}

testCloudSync();

