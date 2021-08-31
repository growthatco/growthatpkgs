{ callPackage, stdenv }:

let
  build = callPackage ../default.nix {};
in
  build {
    version = "1.0.0";
    sha256 = "1353c0i32ap3vfl3j783nkvq7bzqssyfdayp3g3jypwvgrrmkd5r";
    vendorSha256 = "1ackl6j7r06yh2vx5brs68759kh03xx9ndrg5fc942h0p2maznvb";
  }