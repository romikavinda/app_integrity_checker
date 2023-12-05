package com.emrys.aic.app_integrity_checker;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.Signature;
import android.os.Build;
import android.util.Base64;
import android.util.Log;

import androidx.annotation.NonNull;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.InvalidParameterSpecException;
import java.util.Arrays;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** AppIntegrityCheckerPlugin */
public class AppIntegrityCheckerPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    context = flutterPluginBinding.getApplicationContext();
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "com.emrys.aic/epic");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getchecksum")) {
      String checksum = getChecksum();
      result.success(checksum);

    }else if(call.method.equals("getsig")){
      String sig = getSignature();
      result.success(sig);
    }else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }


  private String getChecksum(){

    String crc = "";

    ZipFile zf = null;
    try {
      zf = new ZipFile(context.getPackageCodePath());
      ZipEntry ze = zf.getEntry("classes.dex");

      crc = String.valueOf(ze.getCrc());

    } catch (Exception e) {
      e.printStackTrace();
      crc =  "checksumFailed";
    }


    return crc;

  }

  private String getSignature() {
    StringBuilder currentSignature;
    currentSignature = new StringBuilder();
    try {

      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
        PackageInfo packageInfo = context.getPackageManager().getPackageInfo(context.getPackageName(), PackageManager.GET_SIGNING_CERTIFICATES);
        if (packageInfo == null
                || packageInfo.signingInfo == null) {
          return null;
        }
        if (packageInfo.signingInfo.hasMultipleSigners()) {
          for (Signature signature : packageInfo.signingInfo.getApkContentsSigners()) {

            MessageDigest md = MessageDigest.getInstance("SHA-256");

            md.update(signature.toByteArray());

            currentSignature.append(Base64.encodeToString(md.digest(), Base64.DEFAULT));

          }
        } else {
          for (Signature signature : packageInfo.signingInfo.getSigningCertificateHistory()) {

            MessageDigest md = MessageDigest.getInstance("SHA-256");

            md.update(signature.toByteArray());

            currentSignature.append(Base64.encodeToString(md.digest(), Base64.DEFAULT));

          }
        }
      } else {
        @SuppressLint("PackageManagerGetSignatures")
        PackageInfo packageInfo = context.getPackageManager().getPackageInfo(context.getPackageName(), PackageManager.GET_SIGNATURES);
        if (packageInfo == null
                || packageInfo.signatures == null
                || packageInfo.signatures.length == 0
                || packageInfo.signatures[0] == null) {
          return null;
        }
        for (Signature signature : packageInfo.signatures) {

          MessageDigest md = MessageDigest.getInstance("SHA-256");

          md.update(signature.toByteArray());

          currentSignature.append(Base64.encodeToString(md.digest(), Base64.DEFAULT));

        }
      }
    } catch (PackageManager.NameNotFoundException e) {
      currentSignature.append("Signature read failed");
    } catch (NoSuchAlgorithmException e) {
      currentSignature.append("Signature read failed");
    }
    return currentSignature.toString();
  }



}
