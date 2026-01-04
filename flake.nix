{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      utils,
      nixpkgs,
      ...
    }:
    let
      inherit (utils.lib) eachDefaultSystem;

      mikuboot' =
        pkgs:
        pkgs.stdenvNoCC.mkDerivation {
          pname = "mikuboot-plymouth-theme";
          version = "1.0.0";
          src = ./.;
          installPhase = ''
            mkdir -p $out/share/plymouth/themes
            mv mikuboot $out/share/plymouth/themes/mikuboot
            sed -i "s@\/usr\/@$out\/@" $out/share/plymouth/themes/mikuboot/mikuboot.plymouth
          '';
        };
      overlay = final: prev: {
        mikuboot = mikuboot' final;
      };
      nixosModule =
        { ... }:
        {
          config = {
            nixpkgs.overlays = [ overlay ];
          };
        };
    in
    {
      overlays.default = overlay;
      nixosModules.default = nixosModule;
    }
    // eachDefaultSystem (system: {
      packages = rec {
        mikuboot = mikuboot' (import nixpkgs { inherit system; });
        default = mikuboot;
      };
    });
}
