{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./service.nix
  ];

  networking.hostName = "clyz-minecraft";

  time.timeZone = "Asia/Shanghai";

  users.users = {
    oo-infty = {
      isNormalUser = true;
      initialPassword = "";
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "networkmanager" ];
      openssh.authorizedKeys.keys = [ ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyy0QeqzONPideu1mBNPXZvmPmf6hV7yoCSjrkOSzaT oo-infty@oo-laptop'' ];
    };

    whitepaperdog = {
      isNormalUser = true;
      initialPassword = "";
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "networkmanager" ];
      openssh.authorizedKeys.keys = [ ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9NphohvVsEoT5enkjORs8p32UvD+k6nVptsUNXkzJ0lp1CXzPgTzA1jWJ0ALWdn4bwa7cp/pPCyVNu0mSC5zaWPK/YQnnviMjamcmA6gu9VrXuUml9Veei4wiQDcxjhL6/Po9tfY6E3IpRvUYBmrKhS3d8gsyHw2SYuwH1nDnqxd+uR7Ohr0OYcGo8ZsCGzCLifwW39T68+Rd8cPH+WglKRTKleEMVPqlX0QO68+soWuLQjG78JnHbKOXTEeuiKmN+DppCECrW//4d5mQ9bW+vxFizNDScHArVqswIwXeI6fxSx5mcTxAhih1vIp2htzNx0P+ZvE+2ioMg2pWj+T3e5DU9B2KHNLb4P5vYTJYg02ryI/Ct8L8oH0ETrShppLVj96cMoPIzJD/Y1qvc2Z14DQZdHXys4vU0XpWUURk6z44VP41MoEHhXTUtyaMZ31/vtvFw4Y9EAOqBd816xfFV81RvL28gbX2gA+OxUsuyJkcNQy+oZdad2m6Tb/KGYE= whitepaperdog@whitepaperdog-OmenPC'' ];
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyy0QeqzONPideu1mBNPXZvmPmf6hV7yoCSjrkOSzaT oo-infty@oo-laptop''
    ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9NphohvVsEoT5enkjORs8p32UvD+k6nVptsUNXkzJ0lp1CXzPgTzA1jWJ0ALWdn4bwa7cp/pPCyVNu0mSC5zaWPK/YQnnviMjamcmA6gu9VrXuUml9Veei4wiQDcxjhL6/Po9tfY6E3IpRvUYBmrKhS3d8gsyHw2SYuwH1nDnqxd+uR7Ohr0OYcGo8ZsCGzCLifwW39T68+Rd8cPH+WglKRTKleEMVPqlX0QO68+soWuLQjG78JnHbKOXTEeuiKmN+DppCECrW//4d5mQ9bW+vxFizNDScHArVqswIwXeI6fxSx5mcTxAhih1vIp2htzNx0P+ZvE+2ioMg2pWj+T3e5DU9B2KHNLb4P5vYTJYg02ryI/Ct8L8oH0ETrShppLVj96cMoPIzJD/Y1qvc2Z14DQZdHXys4vU0XpWUURk6z44VP41MoEHhXTUtyaMZ31/vtvFw4Y9EAOqBd816xfFV81RvL28gbX2gA+OxUsuyJkcNQy+oZdad2m6Tb/KGYE= whitepaperdog@whitepaperdog-OmenPC''
  ];

  services.openssh.enable = true;
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    bat
    fd
    git
    helix
    htop
    neofetch
    ripgrep
  ];

  system.stateVersion = "24.11";
}
