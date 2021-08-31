{ niv ? import ./niv { }, talismanpkgs ? import ./packages.nix { } }:

with niv;

nixpkgs.mkShell rec {
  name = "release.talismanpkgs";
  env = nixpkgs.buildEnv {
    name = name;
    paths = buildInputs;
  };
  buildInputs = [
    # <talismanpkgs>
    talismanpkgs.jq_1_6
    talismanpkgs.nodejs_12_18_3
    talismanpkgs.python_3_7
  ];
}
