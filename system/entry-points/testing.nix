{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ../.
  ];

  microvm = {
    hypervisor = "qemu";
    vcpu = 2;
    mem = 4096;
    socket = "control.socket";

    shares = [
      {
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
      }
    ];

    volumes = [
      {
        image = "var.img";
        mountPoint = "/var";
        size = 2048;
      }
    ];

    interfaces = [
      {
        type = "user";
        id = "vm-clyz-mc";
        mac = "02:00:00:00:00:01";
      }
    ];
  };
}
