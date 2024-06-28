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
      ensure-secure-profile = false;
      allow-flight = true;
    };

    jvmOpts = "-Xmx3896M -Xms2048M";
  };
}
