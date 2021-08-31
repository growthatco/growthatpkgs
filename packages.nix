{ sources ? import ./nix { }, util ? import ./util { } }:

let
  inherit (sources)
    nixpkgs
  ;
  inherit (builtins) 
    stringLength
    toString
  ;

  nixpkgsDir = { version }: ./. + "/modules/" + version + "/pkgs";
  nixpkgs-unstable = util.nixpkgsDirmodulesDir + ""
  nixpkgs-21-05 =

  nixpkgsDirectory = ./. + "/modules/nixpkgs/pkgs";

  rootFile = util.rootFile { inherit nixpkgsDirectory; };
  packageFile = util.packageFile { inherit nixpkgsDirectory; };

  build = { name, version, parent ? "", ... }@a:
    { ... }@b:
    if stringLength parent == 0 then
      nixpkgs.callPackage (./. + "/pkgs/${name}/versions/${version}.nix")
      (a // b)
    else
      nixpkgs.callPackage
      (./. + "/pkgs/${name}/versions/${parent}/${version}.nix") (a // b);

  package = package: version:
    { ... }@args:
    nixpkgs.callPackage (./. + "/pkgs/${package}/versions/${version}.nix")
    (args // { });

in rec {

  # === bazel ===

  bazelPackageDirectory = "development/tools/build-managers/bazel";
  bazelPackageFile = packageFile { packageDirectory = bazelPackageDirectory; };

  bazel = bazel_3_7_2;

  bazel_3_7_2 = build {
    name = "bazel";
    version = "3.7.2";
    parent = "3";
    sha256 = "1cfrbs23lg0jnl22ddylx3clcjw7bdpbix7r5lqibab346s5n9fy";
    packageFile = bazelPackageFile;
  } {
    buildJdk = openjdk_11_headless;
    buildJdkName = "java11";
    runJdk = openjdk_11_headless;
    bazel_self = bazel_3_7_2;
  };

  # === consul ===

  consulPackageDirectory = "servers/consul";
  consulPackageFile =
    packageFile { packageDirectory = consulPackageDirectory; };

  consul = consul_1_9_0;

  consul_1_9_0 = build {
    name = "consul";
    version = "1.9.0";
    packageFile = consulPackageFile;
  } { buildHashiCorpPackage = util.buildHashiCorpPackage; };

  # === go ===

  goPackageDirectory = "development/compilers/go";
  goPackageFile = packageFile { packageDirectory = goPackageDirectory; };

  go = go_1_16_4;

  go_1_16_4 = build {
    name = "go";
    version = "1.16.4";
    parent = "1.16";
    sha256 = "00rmsiq4h44r5dr5iyshv9b56jq7cakmailq2wcd6xqn59p6nkxf";
    packageFile = goPackageFile;
  } { };

  # === golangci-lint ===

  golangci-lintPackageDirectory = "development/tools/golangci-lint";
  golangci-lintPackageFile =
    packageFile { packageDirectory = golangci-lintPackageDirectory; };

  golangci-lint = golangci-lint_1_41_1;

  golangci-lint_1_41_1 = build {
    name = "golangci-lint";
    version = "1.41.1";
    sha256 = "1lcfp924zc98rlsv68v7z7f7i7d8bzijmlrahsbqivmhdd9j86pg";
    vendorSha256 = "1wrydl06v1x99iqna2m445xzldwnl1kx89dsnk2ns5r1j904aimk";
    packageFile = golangci-lintPackageFile;
  } { };

  # === google-cloud-sdk ===

  google-cloud-sdk = google-cloud-sdk_268_0_0;
  google-cloud-sdk-gce = google-cloud-sdk-gce_268_0_0;
  google-cloud-sdk_268_0_0 = package "google-cloud-sdk" "268.0.0" { };
  google-cloud-sdk-gce_268_0_0 = google-cloud-sdk.override { withGce = true; };

  # === helm ===

  helmPackageDirectory = "applications/networking/cluster/helm";
  helmPaackageFile = packageFile { packageDirectory = helmPackageDirectory; };

  helm = helm_3_6_0;

  helm_3_6_0 = build {
    name = "helm";
    version = "3.6.0";
    sha256 = "05hkqdgkkaxcqzc55jja809h9nggxv2k2m48sk3yif2cmxvvnmmi";
    vendorSha256 = "06ccsy30kd68ml13l5k7d4225vlax3fm2pi8dapsyr4gdr234c1x";
    packageFile = helmPaackageFile;
  } { };

  # === jq ===

  jqPackageDirectory = "development/tools/jq";
  jqPaackageFile = packageFile { packageDirectory = jqPackageDirectory; };

  jq = jq_1_6;

  jq_1_6 = build {
    name = "jq";
    version = "1.6";
    sha256 = "0wmapfskhzfwranf6515nzmm84r7kwljgfs7dg6bjgxakbicis2x";
    vendorSha256 = "1a7b29jgyqhx2ihxrd7i1vvdjlr8flfzc6n0xj303d01ljf7fhqh";
    packageFile = jqPaackageFile;
  } { };

  # === k9s ===

  k9sPackageDirectory = "applications/networking/cluster/k9s";
  k9sPaackageFile = packageFile { packageDirectory = k9sPackageDirectory; };

  k9s = k9s_0_24_10;

  k9s_0_24_10 = build {
    name = "k9s";
    version = "0.24.10";
    sha256 = "0n5z2xkn8xp8z8wfbbrixsz9b9svzmk0dmx1r1hrzavnbm3qhr92";
    vendorSha256 = "1a7b29jgyqhx2ihxrd7i1vvdjlr8flfzc6n0xj303d01ljf7fhqh";
    packageFile = k9sPaackageFile;
  } { };

  # === mirror ===

  mirror = mirror_1_0_0;
  mirror_1_0_0 = package "mirror" "1.0.0" { };

  # === nodejs ===

  nodejs = nodejs_12_18_3;
  nodejs_12_18_3 = package "nodejs" "12.18.3" { };
  nodejs_10_19_0 = package "nodejs" "10.19.0" { };

  # === nomad ===

  nomadPackageDirectory = "applications/networking/cluster/nomad";
  nomadPaackageFile = packageFile { packageDirectory = nomadPackageDirectory; };

  nomad = nomad_1_0_6;

  nomad_1_0_6 = build {
    name = "nomad";
    version = "1.0.6";
    packageFile = nomadPaackageFile;
  } { buildHashiCorpPackage = util.buildHashiCorpPackage; };

  # === openjdk ===

  openjdk = openjdk_16;
  openjdk_headless = openjdk_16_headless;

  openjdk_16 = nixpkgs.jdk16;
  openjdk_16_headless = nixpkgs.jdk16_headless;
  openjdk_11 = nixpkgs.jdk11;
  openjdk_11_headless = nixpkgs.jdk11_headless;
  openjdk_8 = nixpkgs.jdk8;
  openjdk_8_headless = nixpkgs.jdk8_headless;

  # === python ===

  # python_nixpkgs_dir = package_dir "development/interpreters/python";
  # python = python_3_9_4;

  # python_3_9_4 = build {
  #   name = "python";
  #   version = "3.9.4";
  #   dir = python_nixpkgs_dir;
  # } { };

  # python = python_3_9_4;
  # python_3_9_4 = nixpkgs.pkgs.python39;

  # === rust ===

  # cargo = cargo_1_43_0;
  # cargo_1_43_0 = rust_1_45_2builds.cargo;

  # clippy = clippy_1_43_0;
  # clippy_1_43_0 = rust_1_45_2builds.clippy;

  # rust = rust_1_45_2;
  # rustbuilds = rust.packages.stable;
  # rust_1_45_2 = nixpkgs.pkgs.rust_1_45;
  # rust_1_45_2builds = rust_1_45.packages.stable;

  # rustc = rustc_1_45_2;
  # rustc_1_45_2 = rust_1_45_2builds.rustc;

  # === skaffold ===

  skaffoldPackageDirectory = "development/tools/skaffold";
  skaffoldPaackageFile =
    packageFile { packageDirectory = skaffoldPackageDirectory; };

  skaffold = skaffold_1_24_1;

  skaffold_1_24_1 = build {
    name = "skaffold";
    version = "1.24.1";
    packageFile = skaffoldPaackageFile;
  } { };

  # === waypoint ===

  waypointPackageDirectory = "applications/networking/cluster/waypoint";
  waypointPaackageFile =
    packageFile { packageDirectory = waypointPackageDirectory; };

  waypoint = waypoint_0_3_2;

  waypoint_0_3_2 = build {
    name = "waypoint";
    version = "0.3.2";
    packageFile = waypointPackageDirectory;
  } { buildHashiCorpPackage = util.buildHashiCorpPackage; };
}
