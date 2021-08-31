{ name, version, sha256, vendorSha256, packageFile
# <nixpkgs>
, callPackage }:

let build = callPackage ../builder.nix { };
in build { inherit name version sha256 vendorSha256 packageFile; }
