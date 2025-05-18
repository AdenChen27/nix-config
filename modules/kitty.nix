{ config, pkgs, ... }: {
  xdg.configFile."kitty/kitty.conf".text = ''
    include themes/ayu-light.conf

    font_family JetBrainsMono Nerd Font
    font_size   13.0

    window_padding_width 8
    confirm_os_window_close 0
    enable_audio_bell no
  '';

  xdg.configFile."kitty/themes/ayu-light.conf".source = ../themes/ayu-light.conf;
}

