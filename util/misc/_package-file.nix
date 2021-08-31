{ }: rec {
  package-file = { nixpkgs-dir }:
    { package-dir }:
    path:
    package-dir + "/${package-dir}/${path}";
}
