{ name, version, packageFile
# <nixpkgs>
, callPackage, buildHashiCorpPackage }:

let build = callPackage ../builder.nix { inherit buildHashiCorpPackage; };
in build {
  inherit name version packageFile;

  sha256 = "0zp2za1r5zpiyfmh5wkhxnccq22s080pnzy36rwasa10pz9vkwrj";
}
