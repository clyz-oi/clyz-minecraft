{ config, lib, pkgs, ... }:

let
  cfg = config.services.minecraft-server;

  operatorType = lib.types.submodule {
    options = {
      uuid = lib.mkOption {
        type = lib.types.strMatching
          "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}";
        example = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
        description = "UUID of an operator.";
      };

      level = lib.mkOption {
        type = lib.types.enum [ 1 2 3 4 ];
        default = 1;
        description = "Permission level of an operator.";
      };

      bypassesPlayerLimit = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to allow an operator enter the server even if current number
          of players has reached the limit.
        '';
      };
    };
  };
in {
  options.services.minecraft-server = {
    operator = lib.mkOption {
      type = lib.types.attrsOf operatorType;
      default = {};
      example = {
        op = {
          uuid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
          level = 4;
          bypassesPlayerLimit = false;
        };
      };
      description = "Operator configurations of this server";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.minecraft-server.preStart = let
      operatorList = lib.mapAttrsToList
        (name: attrs: attrs // { inherit name; })
        cfg.operator;
      operatorFile = pkgs.writeText "ops.json" (builtins.toJSON operatorList);
    in
      if cfg.declarative then ''
        if [[ -e .declarative-op ]]; then
          ln -sf ${operatorFile} ops.json
        else
          ln -sb --suffix=.stateful ${operatorFile} ops.json
          touch .declarative-op
        fi
      '' else ''
        rm .declarative-op || true
      '';
  };
}
