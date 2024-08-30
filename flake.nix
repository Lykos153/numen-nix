{
  description = "A flake for building numen";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs, }:
    with import nixpkgs { system = "x86_64-linux"; };
    let
      vosk-bin = pkgs.callPackage (import ./pkgs/vosk-bin.nix) { };
      vosk-model-small-en-us =
        pkgs.callPackage (import ./pkgs/vosk-model-small-en-us.nix) { };
      numen = pkgs.callPackage (import ./pkgs/numen.nix) {
        inherit vosk-bin vosk-model-small-en-us;
      };
    in
    {
      packages.x86_64-linux = {
        inherit vosk-bin vosk-model-small-en-us numen;
        default = numen;
      };
      overlays.default = final: prev: {
        inherit vosk-bin vosk-model-small-en-us numen;

      };
      homeManagerModules.numen-nix = (import ./modules/home-manager/numen-nix.nix) { inherit numen vosk-model-small-en-us; };
      homeManagerModule = self.homeManagerModules.numen-nix;
      formatter.x86_64-linux = pkgs.nixpkgs-fmt;
    };
}
