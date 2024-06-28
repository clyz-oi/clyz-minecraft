{ config, lib, pkgs, ... }:

{
  # NixOS modules that add extra options for services.minecraft-server.
  imports = [
    ./operator.nix
  ];
}
