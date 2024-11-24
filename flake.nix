{
  inputs = rec {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-24.11";

    cura5_appimage.url = "https://github.com/Ultimaker/Cura/releases/download/5.7.2-RC2/UltiMaker-Cura-5.7.2-linux-X64.AppImage";
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
              src = cura5_appimage;
            };
          };
        };
      };
}
