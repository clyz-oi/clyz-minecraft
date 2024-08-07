{ config, lib, pkgs, ... }:

{
  imports = [
    ../.
  ];

  boot.loader.grub.device = "/dev/vda";

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi" ];
  boot.initrd.kernelModules = [ "nvme" ];

  boot.tmp.cleanOnBoot = true;
  fileSystems."/" = { device = "/dev/vda1"; fsType = "ext4"; };
  zramSwap.enable = true;
}
