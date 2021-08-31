{ build-hashi-corp-package }:

{ name, version, sha256, packageFile }@args:

build-hashi-corp-package rec { inherit name version sha256; }
