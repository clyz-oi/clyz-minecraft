{ config, lib, pkgs, inputs, ... }:

{
  services.minecraft-server = {
    enable = true;
    package = inputs.self.packages.${pkgs.system}.minecraft-server;
    eula = true;
    openFirewall = true;
    declarative = true;

    serverProperties = {
      level-seed = -4495076908537055101;
      server-port = 25600;
      difficulty = "hard";
      white-list = false;
      enforce-secure-profile = false;
      allow-flight = true;
    };

    operator = {
      oo_infty = {
        uuid = "6b93f3cf-2dd8-4640-8852-011e91931684";
        level = 4;
      };

      whitepaperdog = {
        uuid = "9a319d7f-425a-4768-ae00-add32a945d2c";
        level = 4;
      };
    };

    jvmOpts = "-Xmx3896M -Xms2048M";
  };
}
