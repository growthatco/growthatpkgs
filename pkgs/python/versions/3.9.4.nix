{ name, version, sha256, packageFile
# <nixpkgs>
, callPackage }:

let {
	passthru = callPackage ../passthru.nix { 
		inherit packageFile;
	};
	build = callPackage ../builder.nix { };
}
in build { inherit name version sha256 packageFile; }
