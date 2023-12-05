import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'app_integrity_checker_method_channel.dart';

abstract class AppIntegrityCheckerPlatform extends PlatformInterface {
  /// Constructs a AppIntegrityCheckerPlatform.
  AppIntegrityCheckerPlatform() : super(token: _token);

  static final Object _token = Object();

  static AppIntegrityCheckerPlatform _instance =
      MethodChannelAppIntegrityChecker();

  /// The default instance of [AppIntegrityCheckerPlatform] to use.
  ///
  /// Defaults to [MethodChannelAppIntegrityChecker].
  static AppIntegrityCheckerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AppIntegrityCheckerPlatform] when
  /// they register themselves.
  static set instance(AppIntegrityCheckerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getchecksum() {
    throw UnimplementedError('getchecksum() has not been implemented.');
  }

  Future<String?> getsignature() {
    throw UnimplementedError('getsignature() has not been implemented.');
  }
}
