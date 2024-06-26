{
  description = "CLYZ Minecraft Server Flake";

  nixConfig = {
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"      
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs: let
    pkgs = import nixpkgs { system = "x86_64-linux"; };
  in {
    packages.x86_64-linux.minecraft-server = pkgs.callPackage ./pkgs/minecraft-server {};

    nixosConfigurations.clyz-minecraft = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
        ./system
      ];
    };

    colmena = {
      meta = {
        nixpkgs = pkgs;
        specialArgs = { inherit inputs; };
      };

      clyz-minecraft = { name, nodes, pkgs, ... }: {
        deployment = {
          targetHost = "119.3.234.247";
          tags = [ "production" ];
        };

        imports = [
          ./system
        ];
      };
    };

    devShells.x86_64-linux.default = let
      mkShell = pkgs.mkShell.override { stdenv = pkgs.stdenvNoCC; };
    in
      mkShell {
        packages = with pkgs; [
          nil
          colmena
        ];
      };
  };
}
