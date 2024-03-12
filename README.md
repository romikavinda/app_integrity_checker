# app_integrity_checker


Flutter plugin to verify the integrity of the app and detect if it has been tampered at run time.

For iOS some of the integrity checks are Based on
[IOSSecuritySuite](https://github.com/securing/IOSSecuritySuite)


## Getting Started

# Install
```
$ flutter pub add app_integrity_checker

```

or add the below line to your package's pubspec.yaml:

```
dependencies:
  app_integrity_checker: ^1.0.5

```

# Platform Based Configurations

## Android
No Configurations Needed.

## iOS
No Configurations Needed.

# Usage

```
import 'package:app_integrity_checker/app_integrity_checker.dart';

    String checksum = await AppIntegrityChecker.getchecksum() ?? "checksum retrieval failed";     //retrieve app checksum value in SHA256
    String signature = await AppIntegrityChecker.getsignature() ?? "signature retrieval failed";  //retrieve app signature value in SHA256   



```



# Android output

## Checksum (SHA-256)
✤ This value is based on the checksum of the native code and does not include the checksum of the dart code.

✤ Best to use this value together with the app signature. eg - checksum value hashed with app signature verified at server level.

✤ This value will change with each build if changes are made to the native code or native code is tampered with.

## Signature (SHA-256)
✤ This value is based on the app signing certificate and value will change if the signing certificate is changed/tampered with. eg - code recompile after decompile or Release/Debug certificate.

✤ This value will not change with each build as long as the same signing certificate is used.




# iOS output

## Checksum (SHA-256)
✤ This value outputs a 24 character string for physical iOS device. For emulators or non Arm64 architecture devices this will be only first 8 characters.

✤ First 8 characters  - The checksum value of the dart code.Value might change with each build and also if dart code is tampered with.

✤ Second 8 characters - The checksum of the native swift code. value will change with each build if changes are made to the native code or native code is tampered with.(Only available for Arm64)

✤ Third 8 characters  - The checksum of IOSSecuritySuite dlib. value will change with each build if changes are made to the IOSSecuritySuite dlib or IOSSecuritySuite dlib is tampered with.(Only available for Arm64)

✤ Depending on your requirement you can decide to use either a part of the checksum value or all of it.

## Signature (SHA-256)
✤ This value is based on the app code signature and will change when uploaded to app store since apple replaces the developer certificates and uses their own certificates for code signing.

✤ Use appropriately to match your requirement.  
