{ sources ? import ./sources.nix }: (import ./packages.nix { inherit sources; })
