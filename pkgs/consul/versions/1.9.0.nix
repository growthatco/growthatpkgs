{ name, version, packageFile
# <nixpkgs>
, callPackage, buildHashiCorpPackage }:

let build = callPackage ../builder.nix { inherit buildHashiCorpPackage; };
in build {
  inherit name version packageFile;

  sha256 = "1kj7s8lvm26ijwv3rdpsdzc60hg1awxgwrzpld5bm4zcki7rd6s0";
}
