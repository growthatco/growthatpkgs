{ constants ? import ../constants { } }:
rec {
	nixpkgsDir = { version }: constants.rootDir + "/modules/" version;
}
