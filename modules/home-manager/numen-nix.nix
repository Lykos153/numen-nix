{ numen, vosk-model-small-en-us }: { config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.numen;
in
{
  options.services.numen = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    package = mkOption {
      type = types.package;
      default = numen;
    };

    # models = mkOption {
    #   type = types.uniq types.listOf types.package;
    #   default = [vosk-model-small-en-us];
    #   example = "[vosk-model-small-en-us]";
    #   description = ''
    #     List of vosk models to be loaded by numen. They can be referred to using the index, eg. model0 or model1.
    #   '';
    # };

    model = mkOption {
      type = types.pathInStore;
      default = "${vosk-model-small-en-us}/usr/share/vosk-models/small-en-us/";
      example = "vosk-model-small-en-us";
      description = ''
        Vosk model to be loaded by numen.
      '';
    };

    phrases = mkOption {
      type = types.listOf types.path;
      default = [ ];
      description = ''
        Phrases to be loaded by numen. If empty, the default phrases are used.
      '';
    };

    extraArgs = mkOption {
      type = types.singleLineStr;
      default = "";
      description = ''
        Additional arguments to be passed to numen.
      '';
    };

    xkbLayout = mkOption {
      type = types.singleLineStr;
      default = "en";
      description = ''
        The XKB keyboard layout that should be used by dotool.
      '';
    };

    xkbVariant = mkOption {
      type = types.singleLineStr;
      default = "";
      description = ''
        The XKB keyboard variant that should be used by dotool.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
        cfg.package
    ];
    systemd.user.services.numen = {
      Unit = {
        Description = "Numen voice control";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Install.WantedBy = [ "graphical-session.target" ];
      Service.Environment = [
        "DOTOOL_XKB_LAYOUT=${cfg.xkbLayout}"
        "DOTOOL_XKB_VARIANT=${cfg.xkbVariant}"
        "NUMEN_MODEL=${cfg.model}"
        "NUMEN_SCRIPTS_DIR=${cfg.package}/etc/numen/scripts"
      ];
      Service.ExecStart = "${cfg.package}/bin/numen ${cfg.extraArgs} ${lib.strings.concatStringsSep " " cfg.phrases}";
    };
  };
}
