# home/kitty.nix
{ ... }:
{
programs.kitty = {
  enable = true;

  font = {
    name = "JetBrainsMono Nerd Font";
    size = 12;
  };

  settings = {
    background_opacity = "0.9";
    confirm_os_window_close = 0;
    scrollback_lines = 10000;
  };

  keybindings = {
    "ctrl+shift+t" = "new_tab";
  };

  extraConfig = ''
  '';
};
}
