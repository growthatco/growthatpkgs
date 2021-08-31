{ stdenv, fetchurl, oniguruma }:

{ name, version, sha256, vendorSha256, packageFile }@args:

stdenv.mkDerivation rec {
  inherit version vendorSha256;

  pname = name;

  src = fetchurl {
    inherit sha256;
    url =
      "https://github.com/stedolan/jq/releases/download/jq-${version}/jq-${version}.tar.gz";
  };

  outputs = [ "bin" "doc" "man" "dev" "lib" "out" ];

  buildInputs = [ oniguruma ];

  configureFlags = [
    "--bindir=\${bin}/bin"
    "--sbindir=\${bin}/bin"
    "--datadir=\${doc}/share"
    "--mandir=\${man}/share/man"
  ]
  # jq is linked to libjq:
    ++ stdenv.lib.optional (!stdenv.isDarwin) "LDFLAGS=-Wl,-rpath,\\\${libdir}";

  doInstallCheck = true;
  installCheckTarget = "check";

  postInstallCheck = ''
    $bin/bin/jq --help >/dev/null
  '';

  meta = with stdenv.lib; {
    description = "A lightweight and flexible command-line JSON processor";
    license = licenses.mit;
    platforms = with platforms; linux ++ darwin;
    downloadPage = "http://stedolan.github.io/jq/download/";
    updateWalker = true;
    inherit version;
  };
}
