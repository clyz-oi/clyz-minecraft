{ config, lib, pkgs, ... }:

let
  cfg = config.services.minecraft-server;

  addonType = lib.types.submodule ({ config, ... }: {
    options = {
      mcVersion = lib.mkOption {
        type = lib.types.str;
        default = "any";
        example = "1.20.1";
        description = "The version of Minecraft that load this mod or plugin";
      };

      addonVersion = lib.mkOption {
        type = lib.types.str;
        example = "0.1.0";
        description = "The version of this mod or plugin";
      };

      version = lib.mkOption {
        type = lib.types.str;
        default = "addon.${config.addonVersion}-mc.${config.mcVersion}";
        defaultText = "addon.<addonVersion>-mc.<mcVersion>";
        description = "Combination of Minecraft version and addon version";
      };

      url = lib.mkOption {
        type = lib.types.str;
        description = "The URL used to fetch this mod or plugin";
      };

      hash = lib.mkOption {
        type = lib.types.str;
        description = "The hash of this mod or plugin";
      };
    };
  });

  cleanupAddonsScript = dir: ''
    # Only change jar files.
    addons=${dir}/*.jar

    for file in $addons ; do
      if [[ ! -L "$file" ]]; then
        # Change files that aren't symlinks.
        mv "$file" "$file.stateful"
      else
        # Remove symlinks in case of already abandoned mods or plugins.
        rm "$file"
      fi
    done
  '';

  # A workaround which fixes URLs that contain '+'.
  santinizeUrl = url: builtins.replaceStrings [ "%2B" ] [ "+" ] url;

  installAddonScript = dir: addon: attr: let
    src = pkgs.fetchurl {
      inherit (attr) hash;
      url = santinizeUrl attr.url;
    };
    name = "${addon}-${attr.version}.jar";
  in ''
    ln -s "${src}" "${dir}/${name}"
  '';

  installAllAddonScript = dir: addons: let
    installScriptList = lib.mapAttrsToList
      (addon: attr: installAddonScript dir addon attr)
      addons;
  in
    builtins.concatStringsSep "\n" installScriptList;
in {
  options.services.minecraft-server = {
    mods = lib.mkOption {
      type = lib.types.attrsOf addonType;
      default = {};
      example = {
        fabric-api = {
          mcVersion = "1.20.1";
          addonVersion = "0.92.2";
          url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/P7uGFii0/fabric-api-0.92.2%2B1.20.1.jar";
          hash = "sha256-RQD4RMRVc9A51o05Y8mIWqnedxJnAhbgrT5d8WxncPw=";
        };
      };
      description = "All needed mods";
    };

    plugins = lib.mkOption {
      type = lib.types.attrsOf addonType;
      default = {};
      example = {
        world-edit = {
          mcVersion = "1.20.1";
          addonVersion = "7.3.1";
          url = "https://cdn.modrinth.com/data/1u6JkXh5/versions/j8KJp1Ch/worldedit-bukkit-7.3.1.jar";
          hash = "sha256-EWg4q0pIuwbn471t0PT4jTaTSCc4O+WzhXXaBZtQUZk=";
        };
      };
      description = "All needed plugins";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.minecraft-server.preStart = ''
      ${cleanupAddonsScript "${cfg.dataDir}/mods"}
      ${installAllAddonScript "${cfg.dataDir}/mods" cfg.mods}

      ${cleanupAddonsScript "${cfg.dataDir}/plugins"}
      ${installAllAddonScript "${cfg.dataDir}/plugins" cfg.plugins}
    '';
  };
}
