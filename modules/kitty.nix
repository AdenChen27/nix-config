{ config, pkgs, ... }: {
  xdg.configFile."kitty/kitty.conf".text = ''
    include themes/ayu-light.conf

    font_family JetBrainsMono Nerd Font
    font_size   13.0

    window_padding_width 8
    confirm_os_window_close 0
    enable_audio_bell no

    map cmd+1 goto_tab 1
    map cmd+2 goto_tab 2
    map cmd+3 goto_tab 3
    map cmd+4 goto_tab 4
    map cmd+5 goto_tab 5
    map cmd+6 goto_tab 6
    map cmd+7 goto_tab 7
    map cmd+8 goto_tab 8
    map cmd+9 goto_tab 9
  '';

  xdg.configFile."kitty/themes/ayu-light.conf".source = ../themes/ayu-light.conf;
}

