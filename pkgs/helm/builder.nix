{ stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

{ name, version, sha256, vendorSha256, packageFile, packageFile }@args:

buildGoModule rec {
  inherit version vendorSha256;

  pname = name;

  src = fetchFromGitHub {
    inherit sha256;

    owner = "helm";
    repo = "helm";
    rev = "v${version}";
  };
  doCheck = false;

  subPackages = [ "cmd/helm" ];
  buildFlagsArray = [
    "-ldflags=-w -s -X helm.sh/helm/v3/internal/version.version=v${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    $out/bin/helm completion bash > helm.bash
    $out/bin/helm completion zsh > helm.zsh
    installShellCompletion helm.{bash,zsh}
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/kubernetes/helm";
    description = "A package manager for kubernetes";
    license = licenses.asl20;
  };
}
