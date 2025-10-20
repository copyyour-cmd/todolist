// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloud_auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$biometricAuthServiceHash() =>
    r'c864106c38890a6789bc2210c3459472aaf47223';

/// 生物识别认证服务Provider
///
/// Copied from [biometricAuthService].
@ProviderFor(biometricAuthService)
final biometricAuthServiceProvider =
    AutoDisposeProvider<BiometricAuthService>.internal(
  biometricAuthService,
  name: r'biometricAuthServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$biometricAuthServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BiometricAuthServiceRef = AutoDisposeProviderRef<BiometricAuthService>;
String _$cloudAuthServiceHash() => r'97cb9864c7b97f2482aff52c19f31ed63dee2bf7';

/// 认证服务Provider
///
/// Copied from [cloudAuthService].
@ProviderFor(cloudAuthService)
final cloudAuthServiceProvider = AutoDisposeProvider<CloudAuthService>.internal(
  cloudAuthService,
  name: r'cloudAuthServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cloudAuthServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CloudAuthServiceRef = AutoDisposeProviderRef<CloudAuthService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
