import 'package:flutter_test/flutter_test.dart';
import 'package:app_integrity_checker/app_integrity_checker.dart';
import 'package:app_integrity_checker/app_integrity_checker_platform_interface.dart';
import 'package:app_integrity_checker/app_integrity_checker_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAppIntegrityCheckerPlatform
    with MockPlatformInterfaceMixin
    implements AppIntegrityCheckerPlatform {
  @override
  Future<String?> getchecksum() => Future.value("");

  @override
  Future<String?> getsignature() => Future.value("");
}

void main() {
  final AppIntegrityCheckerPlatform initialPlatform =
      AppIntegrityCheckerPlatform.instance;

  test('$MethodChannelAppIntegrityChecker is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAppIntegrityChecker>());
  });

  test('getPlatformVersion', () async {
    //AppIntegrityChecker appIntegrityCheckerPlugin = AppIntegrityChecker();
    MockAppIntegrityCheckerPlatform fakePlatform =
        MockAppIntegrityCheckerPlatform();
    AppIntegrityCheckerPlatform.instance = fakePlatform;

    expect(await AppIntegrityChecker.getchecksum(), "");
  });
}
