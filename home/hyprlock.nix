{ pkgs, ... }:
let
  art = ./art.txt;   # same file you give programs.screensaver.artFile
      artPng = pkgs.runCommand "lock-art.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
    magick -background none -fill white \
      -font ${pkgs.dejavu_fonts}/share/fonts/truetype/DejaVuSansMono.ttf \
      -pointsize 32 -interline-spacing -4 \
      label:"$(cat ${art})" PNG32:$out
 '';
in
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };

      background = [{
        path = "/etc/nixos/wallpaper.png";
        color = "rgba(0, 0, 0, 1.0)";
      }];

      # ASCII art, read from a file so it keeps its line breaks
            image = [{
        path = "${artPng}";
        size = 200;
        border_size = 0;
        rounding = 0;
        position = "0, 120";
        halign = "center";
        valign = "center";
      }];

      input-field = [{
        size = "300, 48";
        position = "0, -140";
        halign = "center";
        valign = "center";
        outline_thickness = 2;
        rounding = 0;
        dots_size = 0.25;
        dots_spacing = 0.4;
        hide_input = false;
        fade_on_empty = false;
        placeholder_text = "";
        inner_color = "rgba(0, 0, 0, 1.0)";
        outer_color = "rgba(255, 255, 255, 1.0)";
        font_color = "rgba(255, 255, 255, 1.0)";
        check_color = "rgba(170, 170, 170, 1.0)";
        fail_color = "rgba(255, 51, 51, 1.0)";
        fail_text = "";
      }];
    };
  };
}
