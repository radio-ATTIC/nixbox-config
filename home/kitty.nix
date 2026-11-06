{ ... }:
{
  programs.kitty = {
    enable = true;

    font = {
      name = "JetbrainsMono Nerd Font";
      size = 12;
    };
 themeFile = "gruvbox-dark-hard";


    settings = {
      enable_audio_bell = false;
      confirm_os_window_close = 0;
         };

    keybindings = {
      # "ctrl+shift+t" = "new_tab";
    };

    extraConfig = ''
      # anything you can't translate goes here, written exactly as in kitty.conf
    '';
  };
}
