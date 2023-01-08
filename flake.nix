{
  inputs = rec {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";

    cura5_appimage.url = "https://github.com/Ultimaker/Cura/releases/download/5.2.1/Ultimaker-Cura-5.2.1-linux-modern.AppImage";
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
