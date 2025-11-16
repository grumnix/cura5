{
  inputs = rec {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    cura5_appimage.url = "https://github.com/Ultimaker/Cura/releases/download/5.11.0/UltiMaker-Cura-5.11.0-linux-X64.AppImage";
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
              pname = "cura5";
              version = "5.10.1";
              src = cura5_appimage;
            };
          };
        };
      };
}
