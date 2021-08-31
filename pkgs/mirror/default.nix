{ stdenv
, buildGoModule
, fetchFromGitHub }:

{ version
, sha256
, vendorSha256 } @args:

buildGoModule rec {
  inherit 
    version
    vendorSha256
  ;

  pname = "mirror";

  src = fetchFromGitHub {
    inherit 
      sha256
    ;
    
    owner  = "talismanco";
    repo   = "mirror";
    rev    = "v${version}";
  };

  subPackages = [ "cmd/mirror" ];

  buildFlagsArray = ''
    -ldflags=
      -s -w
      -X github.com/talismanco/mirror/release.version=${version}
  '';

  meta = with stdenv.lib; {
    description = " A command-line utility that creates projects from mirrors (project templates).";
    homepage = "https://github.com/talismanco/mirror";
    license = licenses.mit;
  };
}