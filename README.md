<h1 align="center" style="border-bottom: none;">📦 talismanpkgs</h1>
<h3 align="center">A Nix package channel for Talisman development</h3>
<p align="center">
  <a href="#badge">
    <img alt="semantic-release" src="https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg">
  </a>
</p>

**talismanpkgs** is a derivative of the [Nixpkgs](https://github.com/nixos/nixpkgs) collection - a collection of software packages that can be installed with the [Nix](https://nixos.org/nix/) package manager. In order to streamline development and CI pipelines at Talisman, we've implemented our own custom package channel quick and iterative development via **Nix**.

## Packages

| Packages           | Versions                                                                                                                                      |
| ------------------ | --------------------------------------------------------------------------------------------------------------------------------------------- |
| `bazel`            | <ul><li>3.2.0 (bazel_3_2_0)</li></ul>                                                                                                         |
| `cargo`            | <ul><li>1.43.0 (cargo_1_43_0)</li></ul>                                                                                                      |
| `clippy`           | <ul><li>1.43.0 (clippy_1_43_0)</li></ul>                                                                                                      |
| `consul`           | <ul><li>1.9.0 (consul_1_9_0)</li></ul>                                                                                                       |
| `go`               | <ul><li>1.14.13 (go_1_14_13)</li></ul>                                                                                                          |
| `golangci-lint`    | <ul><li>1.27.0 (golangci-lint_1_27_0)</li></ul>                                                                                               |
| `google-cloud-sdk` | <ul><li>268.0.0 (google-cloud-sdk_268_0_0)</li></ul>                                                                                          |
| `helm`             | <ul><li>3.4.1 (helm_3_4_1)</li></ul>                                                                                                          |
| `jq`               | <ul><li>1.6 (jq_1_6)</li></ul>                                                                                                                |
| `k9s`              | <ul><li>0.23.10 (k9s_0_23_10)</li></ul>                                                                                                       |
| `mirror`           | <ul><li>1.0.0 (mirror_1_0_0)</li></ul>                                                                                                        |
| `nodejs`           | <ul><li>12.18.3 (nodejs_12_18_3)</li><li>10.19.0 (nodejs_10_19_0)</li></ul>                                                                   |
| `nomad`            | <ul><li>0.10.9 (nomad_0_10_9)</li></ul>                                                                                                       |
| `openjdk`          | <ul><li>14.0.1 (openjdk_14)</li><li>11.0.6 (openjdk_11)</li><li>1.8.0_242 (openjdk_8)</li></ul>                                               |
| `python`           | <ul><li>3.7.x (python_3_7)</li></ul>                                                                                                        |
| `rustc`            | <ul><li>1.45.2 (rustc_1_45_2)</li></ul>                                                                                                       |
| `skaffold`         | <ul><li>1.15.0 (skaffold_1_15_0)</li><li>1.11.0 (skaffold_1_11_0)</li><li>1.10.1 (skaffold_1_10_1)</li><li>1.10.0 (skaffold_1_10_0)</li></ul> |
| `waypoint`         | <ul><li>1.15.0 (waypoint_0_1_5)</li></ul>                                                                                                     |

## Get Started

> Our home management system, [Casa](https://github.com/talismanco/casa), is shipped with the highest level revisions for all `talismanpkgs` packages.

- [Installation](#installation)
  - [Nix Channels](#nix-channels)
  - [Niv](#niv)

## Installing Nix

```bash
$ curl -L https://nixos.org/nix/install | sh
```

# Installation

## Nix Channels

Subscribe to the **talismanpkgs** custom channel

```bash
nix-channel --add https://github.com/talismanco/talismanpkgs/archive/master.tar.gz talismanpkgs
```

Import the channel in your derivations

```nix
talismanpkgs = import <talismanpkgs> {};
```

## Niv

`niv` is available in [nixpkgs](https://github.com/NixOS/nixpkgs) on the master branch as `niv`. It is also available on the release-19.09 branch as `haskellPackages.niv`. Otherwise, run:

```bash
nix-env -iA niv -f https://github.com/nmattia/niv/tarball/master \
    --substituters https://niv.cachix.org \
    --trusted-public-keys niv.cachix.org-1:X32PCg2e/zAm3/uD1ScqW2z/K0LtDyNV7RdaxIuLgQM=
```

If you're using `home-manager`, you can add it to your `home.nix` profile via the [nixpkgs](https://github.com/NixOS/nixpkgs) channel.

```nix
home.packages = with pkgs; [
  niv
  ...
];
```

In your project directory, run `niv init` to bootstrap `niv`. Now you can install latest version of `talismanpkgs` by running the following:

```bash
niv add talismanco/talismanpkgs
```

This will pull directly fromt the `master` branch. You can target a specific branch by applying the `-b <BRANCH>` flag:

```bash
niv add talismanco/talismanpkgs -b alpha
```

You can add a specific version of the collection via:

```bash
niv add talismanpkgs \
  -v 1.1.0-alpha.1 \
  -t "https://github.com/talismanco/talismanpkgs/archive/v<version>.tar.gz"
```
