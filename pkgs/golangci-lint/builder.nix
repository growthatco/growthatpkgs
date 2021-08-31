{ buildGoModule, fetchFromGitHub, lib }:

{ name, version, sha256, vendorSha256, packageFile }@args:

buildGoModule rec {
  inherit version vendorSha256;

  pname = name;

  src = fetchFromGitHub {
    inherit sha256;

    owner = "golangci";
    repo = "golangci-lint";
    rev = "v${version}";
  };

  subPackages = [ "cmd/golangci-lint" ];

  meta = with lib; {
    description =
      "Linters Runner for Go. 5x faster than gometalinter. Nice colored output.";
    homepage = "https://golangci.com/";
    license = licenses.agpl3;
    platforms = platforms.unix;
  };
}
