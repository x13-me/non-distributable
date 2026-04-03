{
  description = "Non-redistributable assets";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;

      assets = {
        wallpapers = {
          "Great-Wave" = {
            name = "Great-Wave-2355x1575.png";
            sha256 = "sha256-C1NyfzYZKrRpM8tNngwsmzP6H78qkEgs1p4MZAtB4Xc=";
          };
        };
      };

      mkAsset =
        pkgs:
        { name, sha256 }:
        pkgs.requireFile {
          inherit name sha256;
          message = ''
            "${name}" cannot be fetched automatically.
            Add it to the Nix store, then retry:

              nix-store --add-fixed sha256 ./${name}
          '';
        };

    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          wallpapers = nixpkgs.lib.mapAttrs (_: mkAsset pkgs) assets.wallpapers;
        }
      );
    };
}
