import UIKit
import IOSSecuritySuite
import Flutter
import Foundation
import MachO
import CommonCrypto

public class AppIntegrityCheckerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.emrys.aic/epic", binaryMessenger: registrar.messenger())
    let instance = AppIntegrityCheckerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getchecksum":
        let hashval = getHashVal()
        result(hashval)
      break
    case "getsig":
        let sigvalue = checkCodeSignature()
        result(sigvalue)
      break
    default:
        result(FlutterMethodNotImplemented)
    }
  }
}


public func getHashVal() -> String{
    let hashvalue3 = checkDartCode()
#if arch(arm64)
    let hashValue = IOSSecuritySuite.getMachOFileHashValue(.default)
    let hashValue2 = IOSSecuritySuite.getMachOFileHashValue(.custom("IOSSecuritySuite"))
    let finvalue = hashvalue3.prefix(8) + hashValue!.prefix(8) + hashValue2!.prefix(8)
    return String(finvalue);
    
#endif
    return String(hashvalue3.prefix(8));
}


public func getHash86() -> String{
    let hashvalue3 = checkDartCode()
    let finvalue = hashvalue3.prefix(8)
    return String(finvalue);
}

    public func checkCodeSignature() -> String {
        guard let url = Bundle.main.url(forResource: "CodeResources", withExtension:nil,subdirectory: "_CodeSignature") else{ return "" }
        if FileManager.default.fileExists(atPath: url.path) {
            if let data = FileManager.default.contents(atPath: url.path) {
                var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
                data.withUnsafeBytes {
                    _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
                }

                return Data(hash).hexEncodedString()

            }
        }

        return ""
    }

      public func checkDartCode() -> String {
          guard let url = Bundle.main.url(forResource: "App", withExtension:nil,subdirectory: "Frameworks/App.framework") else{ return "" }
          if FileManager.default.fileExists(atPath: url.path) {
              if let data = FileManager.default.contents(atPath: url.path) {
                  var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
                  data.withUnsafeBytes {
                      _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
                  }

                  return Data(hash).hexEncodedString()

              }
          }

          return ""
      }

       extension Data {
           fileprivate func hexEncodedString() -> String {
               return map { String(format: "%02hhx", $0) }.joined()
           }
       }
