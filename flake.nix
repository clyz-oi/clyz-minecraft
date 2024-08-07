{
  description = "CLYZ Minecraft Server Flake";

  nixConfig = {
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"      
      "https://microvm.cachix.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    microvm = {
      url = "github:astro/microvm.nix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, microvm, ... }@inputs: let
    pkgs = import nixpkgs { system = "x86_64-linux"; };
  in {
    packages.x86_64-linux.minecraft-server = pkgs.callPackage ./pkgs/minecraft-server {};
    packages.x86_64-linux.vm = self.nixosConfigurations.vm-clyz-minecraft.config.microvm.declaredRunner;

    nixosModules.minecraft-server = import ./modules/minecraft-server;

    # Don't use `nixos-rebuild switch` here! It's only for VM testing.
    # If you want to deploy configurations locally, use `colmena apply-local`
    # instead.
    nixosConfigurations.vm-clyz-minecraft = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
        ./system/entry-points/testing.nix
        self.nixosModules.minecraft-server
        microvm.nixosModules.microvm
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
          allowLocalDeployment = true;
        };

        imports = [
          ./system/entry-points/production.nix
          self.nixosModules.minecraft-server
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
