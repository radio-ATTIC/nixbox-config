# screensaver.nix: home-manager module (kitty + swayidle + niri)
{ config, lib, pkgs, ... }:

let
  cfg = config.programs.screensaver;

  artFile =
    if cfg.artFile != null
    then cfg.artFile
    else pkgs.writeText "screensaver-art.txt" cfg.art;

  # "screensave[r]" matches "screensaver" but not its own text, so pkill/pgrep
  # can never match swayidle or the shell that runs them.
  stopCmd = "${pkgs.procps}/bin/pkill -f -- 'kitty --class screensave[r]'";

  # Runs inside each kitty window: loop random tte effects until a key is pressed.
  screensaver-run = pkgs.writeShellApplication {
    name = "screensaver-run";
    runtimeInputs = with pkgs; [ terminaltexteffects coreutils ncurses procps ];
    text = ''
      tput civis
      trap 'tput cnorm' EXIT

      loop() {
        while true; do
          effect=$(printf '%s\n' ${lib.escapeShellArgs cfg.effects} | shuf -n1)
          tput civis
          clear
          tput civis
          tput cup ${toString (cfg.heightTrim / 2)} 0
          tput civis
          tte -i ${artFile} --frame-rate ${toString cfg.frameRate} \
            --canvas-width 0 \
            --canvas-height ${if cfg.heightTrim == 0 then "0" else "$(( $(tput lines) - ${toString cfg.heightTrim} ))"} \
            --anchor-canvas c --anchor-text c "$effect" || true
            tput civis
            sleep 1
        done
      }

      loop &
      pid=$!
      read -rsn1
      pkill -P "$pid" || true
      kill "$pid" || true
      # close the screensaver window on every monitor
      pkill -f -- 'kitty --class screensave[r]' || true
    '';
  };

  # Opens one fullscreen kitty per monitor.
  screensaver-launch = pkgs.writeShellApplication {
    name = "screensaver-launch";
    runtimeInputs = with pkgs; [ jq procps kitty niri screensaver-run ];
    text = ''
      # don't stack duplicates if it's already running
      if pgrep -f -- 'kitty --class screensave[r]' > /dev/null; then
        exit 0
      fi

      kitty_args=(
        --class screensaver
        --start-as=fullscreen
        -o confirm_os_window_close=0
        -o hide_window_decorations=yes
        -o window_padding_width=0
        -o remember_window_size=no
        -o cursor_blink_interval=0
        -o background=#000000
        -o background_opacity=1
      )

      mapfile -t outputs < <(niri msg --json outputs | jq -r 'keys[]')

      for m in "''${outputs[@]}"; do
        niri msg action focus-monitor "$m"
        kitty "''${kitty_args[@]}" screensaver-run &
        sleep 0.3
      done
    '';
  };

  idleArgs =
    [ "timeout" (toString cfg.idleSeconds) "${screensaver-launch}/bin/screensaver-launch" ]
    ++ lib.optionals (cfg.lockCommand != null) [
      "timeout" (toString cfg.lockSeconds) "${stopCmd}; ${cfg.lockCommand}"
      "before-sleep" "${stopCmd}; ${cfg.lockCommand}"
    ];

  # Started by niri itself (see usage), so it inherits niri's environment.
  screensaver-idle = pkgs.writeShellApplication {
    name = "screensaver-idle";
    runtimeInputs = [ pkgs.swayidle ];
    text = ''
      exec swayidle -w ${lib.escapeShellArgs idleArgs}
    '';
  };
in
{
  options.programs.screensaver = {
    enable = lib.mkEnableOption "ASCII terminal-text-effects screensaver";
        heightTrim = lib.mkOption {
      type = lib.types.int;
      default = 2;
      description = "Rows to subtract from the tte canvas height. 0 = fill the terminal.";
    };
    art = lib.mkOption {
      type = lib.types.lines;
      default = ''
        PUT YOUR ASCII HERE
      '';
      description = "Plain-text ASCII art to animate.";
    };

    artFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = lib.literalExpression "./art.txt";
      description = "Use a file instead of `art`. Takes priority if set.";
    };

    effects = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "beams" "binarypath" "blackhole" "bouncyballs" "bubbles" "burn"
        "crumble" "thunderstorm" "RandomSequence" "decrypt" "errorcorrect" "expand" "fireworks"
        "highlight" "laseretch" "matrix" "middleout" "orbittingvolley"
        "overflow" "pour" "print" "rain" "rings" "scattered" "slice" "slide"
        "smoke" "spotlights" "spray" "swarm" "sweep" "synthgrid" "unstable"
        "vhstape" "waves" "wipe"
      ];
      description = "tte effects to pick from at random. Remove any your tte version lacks.";
    };

    frameRate = lib.mkOption {
      type = lib.types.int;
      default = 120;
      description = "Animation frame rate passed to tte.";
    };

    idleSeconds = lib.mkOption {
      type = lib.types.int;
      default = 120;
      description = "Idle time before the screensaver starts.";
    };

    lockCommand = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = "${pkgs.swaylock}/bin/swaylock -f";
      description = "Locker command. Set to null to disable locking.";
    };

    lockSeconds = lib.mkOption {
      type = lib.types.int;
      default = 300;
      description = "Idle time before locking (ignored if lockCommand is null).";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ screensaver-run screensaver-launch screensaver-idle ];
  };
}
