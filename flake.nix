{
  inputs = rec {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    #    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    cura5_appimage.url = "https://github.com/Ultimaker/Cura/releases/download/5.1.0/Ultimaker-Cura-5.1.0-linux-modern.AppImage";
    cura5_appimage.flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, cura5_appimage }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
      {
        packages = {
          "x86_64-linux" = rec {
            default = cura5;

            cura5 = pkgs.appimageTools.wrapType2 rec {
              name = "cura5";
              src = pkgs.fetchurl {
	              url = "https://github.com/Ultimaker/Cura/releases/download/5.1.0/Ultimaker-Cura-5.1.0-linux.AppImage";
                sha256 = "0xmcjabb51ww6x7lx1w2w8l2a67d1gq4srpjp8gi06rcq4qjxfga";
              };
              profile = ''
               # export LIBGL_DRIVERS_PATH="${pkgs.mesa.drivers}/lib/dri"
               # export LD_LIBRARY_PATH="${pkgs.mesa.drivers}/lib"
              '';
            };

            cura5-modern = pkgs.appimageTools.wrapType2 rec {
              name = "cura5-modern";
              src = pkgs.fetchurl {
            	  url = "https://github.com/Ultimaker/Cura/releases/download/5.1.0/Ultimaker-Cura-5.1.0-linux-modern.AppImage";
                sha256 = "sha256-OvwC4gk4eF9O4MklNwZZ9UScTGfjarf0xhevg2FHbzI=";
              };
              profile = ''
               # export LIBGL_DRIVERS_PATH="${pkgs.mesa.drivers}/lib/dri"
               # export LD_LIBRARY_PATH="${pkgs.mesa.drivers}/lib"
              '';
            };

            cura5-modern-appimage = pkgs.stdenv.mkDerivation rec {
              name = "cura5";
              src = cura5_appimage;
              unpackPhase = "# do nothing";
              installPhase = ''
                mkdir -p $out/bin/
                cp -vi "${src}" "$out/bin/Ultimaker-Cura-5.1.0-linux-modern.AppImage";
                chmod +x "$out/bin/Ultimaker-Cura-5.1.0-linux-modern.AppImage";
              '';
            };

            cura5-modern-fhs = pkgs.buildFHSUserEnv {
              name = "cura5-modern-fhs";

              targetPkgs = pkgs: (with pkgs; [
                pkgs.zlib
                pkgs.fuse
                pkgs.appimage-run
                cura5-modern-appimage
              ]);

              runScript = "/bin/Ultimaker-Cura-5.1.0-linux-modern.AppImage";
            };
          };
        };
      };
}
