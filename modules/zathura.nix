{
  lib,
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.duti ];

  home.activation.setZathuraDefaultPdfViewer = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister \
      -f -R -trusted /Applications/Zathura.app
    $DRY_RUN_CMD ${pkgs.duti}/bin/duti -s org.pwmt.zathura com.adobe.pdf all
  '';

  launchd.agents.dbus-session = {
    enable = true;
    config = {
      ProgramArguments = [
        "/opt/homebrew/opt/dbus/bin/dbus-daemon"
        "--nofork"
        "--session"
      ];
      Sockets.unix_domain_listener.SecureSocketWithKey = "DBUS_LAUNCHD_SESSION_BUS_SOCKET";
    };
  };

  xdg.configFile."zathura/zathurarc".text = ''
    set font "monospace normal 12"
    set scroll-step 20

    map t toggle_index
    map = zoom in
    map + zoom specific

    map [fullscreen] = zoom in
    map [fullscreen] + zoom specific
  '';
}
