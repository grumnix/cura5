{
  inputs = rec {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        packages = flake-utils.lib.flattenTree rec {
          cura5 = pkgs.appimageTools.wrapType2 rec {
            name = "cura5";
            src = pkgs.fetchurl {
	            url = "https://github.com/Ultimaker/Cura/releases/download/5.1.0/Ultimaker-Cura-5.1.0-linux.AppImage";
              sha256 = "0xmcjabb51ww6x7lx1w2w8l2a67d1gq4srpjp8gi06rcq4qjxfga";
            };
            profile = ''
              export LIBGL_DRIVERS_PATH="${pkgs.mesa.drivers}/lib/dri"
              export LD_LIBRARY_PATH="${pkgs.mesa.drivers}/lib"
            '';
          };
          default = cura5;
        };
      }
    );
}
