import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:todolist/l10n/l10n.dart';
import 'package:todolist/src/core/logging/app_logger.dart';
import 'package:todolist/src/features/home/presentation/home_page.dart';
import 'package:todolist/src/features/settings/application/app_settings_provider.dart';
import 'package:todolist/src/features/settings/application/app_settings_service.dart';
import 'package:todolist/src/infrastructure/repositories/repository_providers.dart';

class UnlockPage extends ConsumerStatefulWidget {
  const UnlockPage({super.key});

  static const routePath = '/unlock';
  static const routeName = 'unlock';

  @override
  ConsumerState<UnlockPage> createState() => _UnlockPageState();
}

class _UnlockPageState extends ConsumerState<UnlockPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final LocalAuthentication _localAuth = LocalAuthentication();

  String? _error;
  bool _isFingerprintAvailable = false;
  bool _isFaceAvailable = false;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _checkBiometric();
  }

  Future<void> _checkBiometric() async {
    final settingsAsync = ref.read(appSettingsProvider);
    final settings = settingsAsync.valueOrNull;

    if (settings == null) {
      return;
    }

    try {
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      final canUseBiometric = canCheckBiometrics || isDeviceSupported;

      if (mounted) {
        setState(() {
          _isFingerprintAvailable = canUseBiometric && settings.enableFingerprintAuth;
          _isFaceAvailable = canUseBiometric && settings.enableFaceAuth;
        });
      }

      // 自动触发生物识别（优先人脸,其次指纹）
      if (_isFaceAvailable || _isFingerprintAvailable) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          await _authenticateWithBiometric();
        }
      }
    } catch (e) {
      final logger = ref.read(appLoggerProvider);
      logger.error('检查生物识别失败', e, StackTrace.current);
    }
  }

  Future<void> _authenticateWithBiometric() async {
    if (_isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
      _error = null;
    });

    try {
      String reason = '';
      if (_isFaceAvailable && _isFingerprintAvailable) {
        reason = '请使用人脸或指纹解锁应用';
      } else if (_isFaceAvailable) {
        reason = '请使用人脸解锁应用';
      } else if (_isFingerprintAvailable) {
        reason = '请使用指纹解锁应用';
      }

      final authenticated = await _localAuth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          useErrorDialogs: true,
          sensitiveTransaction: false,
        ),
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: '验证身份',
            cancelButton: '取消',
            goToSettingsButton: '去设置',
            goToSettingsDescription: '未设置生物识别。请前往"设置 > 安全"进行设置。',
            biometricHint: '',
            biometricNotRecognized: '未识别，请重试',
            biometricSuccess: '验证成功',
            biometricRequiredTitle: '需要生物识别',
            deviceCredentialsRequiredTitle: '需要设备凭据',
            deviceCredentialsSetupDescription: '需要设备凭据',
          ),
        ],
      );

      if (authenticated && mounted) {
        ref.read(passwordUnlockedProvider.notifier).state = true;
        context.go(HomePage.routePath);
      } else if (mounted) {
        setState(() {
          if (_isFaceAvailable && _isFingerprintAvailable) {
            _error = '验证失败';
          } else if (_isFaceAvailable) {
            _error = '人脸验证失败';
          } else if (_isFingerprintAvailable) {
            _error = '指纹验证失败';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = '验证出错: ${e.toString()}';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settingsAsync = ref.watch(appSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.unlockTitle)),
      body: settingsAsync.when(
        data: (settings) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.unlockPrompt,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // 生物识别按钮
                    if (_isFingerprintAvailable || _isFaceAvailable) ...[
                      FilledButton.icon(
                        onPressed: _isAuthenticating ? null : _authenticateWithBiometric,
                        icon: _isAuthenticating
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Icon(_isFaceAvailable && _isFingerprintAvailable
                                ? Icons.face
                                : _isFaceAvailable
                                  ? Icons.face
                                  : Icons.fingerprint),
                        label: Text(_isAuthenticating
                          ? '验证中...'
                          : _isFaceAvailable && _isFingerprintAvailable
                            ? '使用人脸/指纹解锁'
                            : _isFaceAvailable
                              ? '使用人脸解锁'
                              : '使用指纹解锁'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey.shade300)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              '或使用密码',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey.shade300)),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],

                    // 密码输入
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: l10n.settingsPasswordField,
                          prefixIcon: const Icon(Icons.lock),
                          errorText: _error,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.settingsPasswordRequired;
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) => _unlock(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _unlock,
                      icon: const Icon(Icons.lock_open),
                      label: Text(l10n.unlockAction),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        _passwordController.clear();
                        setState(() => _error = null);
                      },
                      child: Text(l10n.commonReset),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(l10n.settingsLoadError('')),
          ),
        ),
      ),
    );
  }

  Future<void> _unlock() async {
    final l10n = context.l10n;
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final password = _passwordController.text;
    final service = ref.read(appSettingsServiceProvider);
    final isValid = await service.verifyPassword(password);
    if (!mounted) return;
    if (isValid) {
      context.go(HomePage.routePath);
    } else {
      setState(() {
        _error = l10n.unlockFailed;
      });
    }
  }
}
