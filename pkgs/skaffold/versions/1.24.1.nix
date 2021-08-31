{ name, version, packageFile
# <nixpkgs> 
, callPackage }:

let build = callPackage ../builder.nix { };
in build {
  inherit name version packageFile;

  revision = "c44d98a365e26a091cf2cde5a2378054d2d345b2";
  sha256 = "1fdd96q8rd0nxvc4r2bz37xx52aby986w5qiqkfp88d6vslf7x0c";
  vendorSha256 = "sha256:0sda5hfybb5bl40x0g80kqpj6isfrrz1dcv18b5l6z8dfs0jpbb8";
}
