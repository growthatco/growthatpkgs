{ buildHashiCorpPackage }:

{ name, version, packageFile, sha256 }@args:

buildHashiCorpPackage rec { inherit name version dir sha256; }
