{ pkgs ? import <nixpkgs> {config.android_sdk.accept_license = true;} }:

  let
    androidComposition = pkgs.androidenv.composeAndroidPackages {
         toolsVersion = "25.2.5";
         platformToolsVersion = "28.0.1";
         buildToolsVersions = [ "28.0.3" ];
         includeEmulator = false;
         platformVersions = [ "28" ];
         includeSources = false;
         includeDocs = false;
         includeSystemImages = false;
         includeNDK = true;
         ndkVersion = "18.1.5063045";
      };
  androidSdk = androidComposition.androidsdk;
  java = pkgs.adoptopenjdk-bin;
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    androidSdk
    java
    glibc
  ];
  # override the aapt2 that gradle uses with the nix-shipped version
  GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${androidSdk}/libexec/android-sdk/build-tools/28.0.3/aapt2";
  ANDROID_SDK_ROOT="${androidSdk}/libexec/android-sdk";
}
