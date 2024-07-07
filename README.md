## CLYZ Minecraft

A NixOS-powered project that concentrates on helping you develop, test and deploy a Minecraft service.

This project is initial used by the fellowship of [CLYZ-OI](https://github.com/clyz-oi), but you can also choose it as your Minecraft service solution.

### Setup

#### Remotely

For a setup tutorial written in Chinese, please refer to this [post](https://oo-infty.netlify.app/posts/deploy-a-minecraft-server-with-nixos/).

If your remote host is not a NixOS system, you need to install it with official NixOS installer or [NixOS-infect](https://github.com/elitak/nixos-infect).

Using NixOS-infect is recommend, since it can transform your OS to NixOS automatically. If you'd like to use NixOS-infect, generate SSH key and push it to the remote machine:

```bash
ssh-keygen -t ed25519 # You may skip this step if you already prepared keys for it
ssh-copy-key root@example.com # Change the host address
ssh root@example.com
```

Now you should successfully login into the remote machine. Run the commands below:

```bash
curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect > nixos-infect
NIX_CHANNEL=nixos-unstable bash -x nixos-infect
```

Wait the SSH session terminated, and run the commands below to adjust hardware configurations:

```bash
scp root@example.com:/etc/nixos/hardware-configuration.nix hardware-configuration.nix
```

Clone this repository: 

```bash
git clone https://github.com/clyz-oi/clyz-minecraft
cd clyz-minecraft
```

Replacing all lines started with `boot` or `fileSystems` in `./system/entry-points/production.nix` with the corresponding occurrences in recently copied `hardware-configuration.nix`. The resulting configurations should look like this:

```nix
# ./system/entry-points/production.nix
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

```

Remember to change user configurations in `./system/default.nix`, especially those related to SSH keys, otherwise you may not able to login into your server. Parts needed to be modify are presented below:

```nix
# ./system/default.nix
{ config, lib, pkgs, ... }:

{
  # ...
  networking.hostName = "your-server";
  
  users.users = {
    username = {
      isNormalUser = true;
      initialPassword = "";
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "networkmanager" ];
      openssh.authorizedKeys.keys = [
        # Place your SSH public keys here
      ];
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    # Place your SSH public keys here
  ];
  # ...
}
```

Run the following commands to finish the final deployment:

```bash
nix run nixpkgs#colmena apply
nix run nixpkgs#colmena exec reboot
```

The service `minecraft-server.service` should be running.

#### Locally

If you prefer local deployment, the above procedure just requires a slight change.

To apply changes, run the following command:

```bash
nix run nixpkgs#colmena apply-local --sudo
```

Keep in mind, never use `nixos-rebuild`.

### Configration

All Minecraft-related configurations are located at `./system/service.nix`. Search [NixOS Options](https://search.nixos.org/options?) and `./modules/minecraft-server` for `services.minecraft-server`.

If you'd like to change the server core, search [NixOS Packages](https://search.nixos.org/packages) for existing ones or write your derivation (package).

### Testing

Before push changes to remote, you can also test your configurations by launching a VM. Run the following command to do so:

```bash
nix run .#vm
```

You should enter a QEMU/KVM interface. Feel free to do any thing you want in this VM.

Note that you should never run `nixos-rebuild switch --flake .#vm-clyz-minecraft` because it uses totally different hardware configurations that are designed for VMs. The guest will mount the host's Nix Store as readonly filesystem. When applying it to the host, it will definitely break your system.

If you only want to test the server core, run the following command:

```bash
nix run .#minecraft-server
```
