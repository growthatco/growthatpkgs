{ call-package ? import ./_call-package.nix { }
, init ? import ./_init.nix { }
, nixpkgs-dir ? import ./_nixpkgs-dir.nix { }
, package-file ? import ./_package-file.nix { }
}: rec {
  inherit call-package init nixpkgs-dir package-file;
}
