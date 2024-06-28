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

    mods = {
      fabric-api = {
        mcVersion = "1.20.1";
        addonVersion = "0.92.2";
        url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/P7uGFii0/fabric-api-0.92.2%2B1.20.1.jar";
        hash = "sha256-RQD4RMRVc9A51o05Y8mIWqnedxJnAhbgrT5d8WxncPw=";
      };

      banner = {
        mcVersion = "1.20.1";
        addonVersion = "664";
        url = "https://cdn.modrinth.com/data/7ntInrAy/versions/aTkeI3Og/banner-1.20.1-664.jar";
        hash = "sha256-rLqOBbu+uaAZxtYtM2Tt2Fb6ewDYiG4I7+10JEmQMR8=";
      };

      carpet = {
        mcVersion = "1.20.1";
        addonVersion = "1.4.112";
        url = "https://cdn.modrinth.com/data/TQTTVgYE/versions/K0Wj117C/fabric-carpet-1.20-1.4.112%2Bv230608.jar";
        hash = "sha256-AK0O0VxFf97A5u7+hNeeG7e4+R9fOhM8+Jyytg/7PRE=";
      };

      immersive-aircraft = {
        mcVersion = "1.20.1";
        addonVersion = "1.0.1";
        url = "https://cdn.modrinth.com/data/x3HZvrj6/versions/3hpofkRO/immersive_aircraft-1.0.1%2B1.20.1-fabric.jar";
        hash = "sha256-oDP3NRESX7wMO+v1SNlbPBaRQn2/E1tBsj8kZJU+WRw=";
      };
    };

    plugins = {
      multi-login = {
        addonVersion = "0.6.10";
        url = "https://github.com/CaaMoe/MultiLogin/releases/download/v0.6.10/MultiLogin-Bukkit-0.6.10.jar";
        hash = "sha256-izUPvUiN08WU7Od/SCmI0SLLVAGax9UM6RdeFm1xVLw=";
      };

      world-edit = {
        mcVersion = "1.20.1";
        addonVersion = "7.3.1";
        url = "https://cdn.modrinth.com/data/1u6JkXh5/versions/j8KJp1Ch/worldedit-bukkit-7.3.1.jar";
        hash = "sha256-EWg4q0pIuwbn471t0PT4jTaTSCc4O+WzhXXaBZtQUZk=";
      };
    };
  };
}
