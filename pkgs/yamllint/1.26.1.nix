let
  pkgs = import (builtins.fetchGit {
    name = "860b56be91fb874d48e23a950815969a7b832fbc";
    url = "https://github.com/NixOS/nixpkgs/";
    ref = "refs/heads/nixpkgs-unstable";
    rev = "860b56be91fb874d48e23a950815969a7b832fbc";
  }) { };
in pkgs.yamllint
