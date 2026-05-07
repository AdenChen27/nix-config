{ config, ... }: {
  home.file."Library/Application Support/sioyek/keys_user.config".text = ''
    next_page          J
    previous_page      K
    prev_state         u
    close_window       x
    zoom_in            =
    fit_to_page_width  +
  '';

  home.file."Library/Application Support/sioyek/prefs_user.config".text = ''
    should_launch_new_window      1
    startup_commands              toggle_synctex
    inverse_search_command        ${config.home.homeDirectory}/bin/sioyek-inverse-search %1 %2
  '';
}
