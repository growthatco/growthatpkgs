{ constants ? import ./constants.nix, sources ? import ../nix { } }:

let inherit (sources) nixpkgs;
in { nixpkgs-dir, package-dir }: path: package-dir + "/${package-dir}/${path}"

