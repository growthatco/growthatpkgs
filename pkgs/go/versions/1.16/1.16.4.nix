{ name, version, parent, sha256, packageFile
# <nixpkgs> 
, lib, callPackage, buildPackages, stdenv, darwin, gcc8Stdenv }:

let
  build = callPackage ./builder.nix ({
    inherit (darwin.apple_sdk.frameworks) Security Foundation;
  } // lib.optionalAttrs (stdenv.cc.isGNU && stdenv.isAarch64) {
    stdenv = gcc8Stdenv;
    buildPackages = buildPackages // { stdenv = buildPackages.gcc8Stdenv; };
  });
in build { inherit name version parent sha256 packageFile; }
