{ name, parent, version, sha256, packageFile
# <nixpkgs> 
, buildJdk, buildJdkName, runJdk, stdenv, bazel_self, callPackage, darwin }:

let
  build = callPackage ./builder.nix {
    inherit (darwin) cctools;
    inherit (darwin.apple_sdk.frameworks)
      CoreFoundation CoreServices Foundation;
    inherit buildJdk buildJdkName runJdk stdenv bazel_self;
  };
in build { inherit name version sha256 packageFile; }
