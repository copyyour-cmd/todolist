import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist/src/domain/entities/cloud_user.dart';
import 'package:todolist/src/features/cloud/application/cloud_auth_provider.dart';
import 'package:todolist/src/features/cloud/presentation/register_page.dart';

/// 登录页面
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  static const routePath = '/cloud/login';
  static const routeName = 'cloudLogin';

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _canUseBiometric = false;
  bool _hasSavedCredentials = false;

  @override
  void initState() {
    super.initState();
    _initBiometric();
  }

  Future<void> _initBiometric() async {
    final biometricService = ref.read(biometricAuthServiceProvider);
    
    // 检查设备是否支持生物识别
    final isSupported = await biometricService.isDeviceSupported();
    final canCheck = await biometricService.canCheckBiometrics();
    
    // 检查是否有保存的凭证
    final hasCredentials = await biometricService.hasCredentials();
    
    // 检查并加载"记住我"的用户名
    final rememberMe = await biometricService.getRememberMe();
    final savedUsername = await biometricService.getSavedUsername();
    
    if (mounted) {
      setState(() {
        _canUseBiometric = isSupported && canCheck;
        _hasSavedCredentials = hasCredentials;
        _rememberMe = rememberMe;
        if (savedUsername != null) {
          _usernameController.text = savedUsername;
        }
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    try {
      await ref.read(authStateProvider.notifier).login(
            username: username,
            password: password,
            deviceType: 'android',
            deviceId: 'device-${DateTime.now().millisecondsSinceEpoch}',
            deviceName: 'PKH110',
          );

      // 登录成功后处理"记住我"和指纹登录凭证
      final biometricService = ref.read(biometricAuthServiceProvider);
      
      // 保存"记住我"状态
      await biometricService.setRememberMe(_rememberMe, username: username);
      
      // 如果启用生物识别且登录成功，保存凭证
      if (_canUseBiometric && _rememberMe) {
        await biometricService.saveCredentials(
          username: username,
          password: password,
        );
      }

      if (mounted) {
        // 登录成功，返回上一页
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('登录成功！'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('登录失败: ${e.toString().replaceFirst('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 指纹登录
  Future<void> _handleBiometricLogin() async {
    final biometricService = ref.read(biometricAuthServiceProvider);
    
    // 获取保存的凭证
    final credentials = await biometricService.getSavedCredentials();
    if (credentials == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('未找到保存的登录信息，请先使用密码登录并启用"记住我"'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    // 执行生物识别认证
    final authenticated = await biometricService.authenticate(
      localizedReason: '使用指纹或面部识别登录云账户',
    );

    if (!authenticated) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('生物识别验证失败'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // 验证成功，使用保存的凭证登录
    try {
      await ref.read(authStateProvider.notifier).login(
            username: credentials['username']!,
            password: credentials['password']!,
            deviceType: 'android',
            deviceId: 'device-${DateTime.now().millisecondsSinceEpoch}',
            deviceName: 'PKH110',
          );

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('指纹登录成功！'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('登录失败: ${e.toString().replaceFirst('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authStateProvider);
    final isLoading = authState.status == AuthStatus.loading;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo和标题
                  Icon(
                    Icons.cloud,
                    size: 80,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '云同步登录',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '使用云账户同步您的待办数据',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // 用户名输入框
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: '用户名或邮箱',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    enabled: !isLoading,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '请输入用户名或邮箱';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // 密码输入框
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: '密码',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    obscureText: _obscurePassword,
                    enabled: !isLoading,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _handleLogin(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入密码';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // 记住我复选框
                  CheckboxListTile(
                    value: _rememberMe,
                    onChanged: isLoading
                        ? null
                        : (value) {
                            setState(() => _rememberMe = value ?? false);
                          },
                    title: const Text('记住我'),
                    subtitle: _canUseBiometric
                        ? const Text('启用后可使用指纹登录')
                        : null,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 24),

                  // 登录按钮
                  FilledButton(
                    onPressed: isLoading ? null : _handleLogin,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            '登录',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                  
                  // 指纹登录按钮（仅在有保存凭证时显示）
                  if (_canUseBiometric && _hasSavedCredentials) ...[
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('或', style: TextStyle(color: Colors.grey)),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: isLoading ? null : _handleBiometricLogin,
                      icon: const Icon(Icons.fingerprint, size: 28),
                      label: const Text('指纹登录'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),

                  // 注册链接
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '还没有账户？',
                        style: theme.textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: isLoading
                            ? null
                            : () => context.push(RegisterPage.routePath),
                        child: const Text('立即注册'),
                      ),
                    ],
                  ),

                  // 跳过按钮
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: isLoading ? null : () => context.pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('暂时跳过'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

