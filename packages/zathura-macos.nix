{ pkgs }:
let
  lib = pkgs.lib;
  zathura = pkgs.zathura;
  zathuraCore = pkgs.zathuraPkgs.zathura_core;
  zathuraCoreBin = lib.getBin zathuraCore;
  zathuraCoreOut = lib.getOutput "out" zathuraCore;
  gsettingsSchemas = pkgs.gsettings-desktop-schemas;
  gtk = pkgs.gtk3;

  xdgDataDirs = lib.concatStringsSep ":" [
    "${gsettingsSchemas}/share/gsettings-schemas/${gsettingsSchemas.name}"
    "${gtk}/share/gsettings-schemas/${gtk.name}"
    "${zathuraCoreOut}/share"
  ];

  launcherSource = pkgs.writeText "zathura-macos-launcher.m" ''
    #import <AppKit/AppKit.h>

    @interface ZathuraAppDelegate : NSObject <NSApplicationDelegate>
    @property(nonatomic) BOOL handledOpenEvent;
    @end

    @implementation ZathuraAppDelegate

    - (BOOL)launchZathuraWithFiles:(NSArray<NSString *> *)filenames {
      NSString *executable = [[NSBundle mainBundle]
        pathForAuxiliaryExecutable:@"zathura-bin"];

      if (executable == nil) {
        NSLog(@"Unable to find the bundled Zathura executable");
        return NO;
      }

      NSTask *task = [[NSTask alloc] init];
      task.executableURL = [NSURL fileURLWithPath:executable];
      task.arguments = filenames;

      NSError *error = nil;
      if (![task launchAndReturnError:&error]) {
        NSLog(@"Unable to launch Zathura: %@", error);
        return NO;
      }

      return YES;
    }

    - (void)application:(NSApplication *)application
               openFiles:(NSArray<NSString *> *)filenames {
      self.handledOpenEvent = YES;
      BOOL success = [self launchZathuraWithFiles:filenames];
      [application replyToOpenOrPrint:
        success ? NSApplicationDelegateReplySuccess
                : NSApplicationDelegateReplyFailure];
    }

    - (void)applicationDidFinishLaunching:(NSNotification *)notification {
      NSApplication *application = notification.object;

      if (!self.handledOpenEvent) {
        [self launchZathuraWithFiles:@[]];
      }

      [application terminate:nil];
    }

    @end

    int main(void) {
      @autoreleasepool {
        NSApplication *application = [NSApplication sharedApplication];
        ZathuraAppDelegate *delegate = [[ZathuraAppDelegate alloc] init];
        application.delegate = delegate;
        [application run];
      }

      return 0;
    }
  '';
in
pkgs.symlinkJoin {
  name = "zathura-macos-${zathura.version}";
  paths = [ zathura ];
  nativeBuildInputs = [
    pkgs.libicns
    pkgs.makeWrapper
    pkgs.stdenv.cc
  ];

  postBuild = ''
    app="$out/Applications/Zathura.app"
    mkdir -p "$app/Contents/MacOS" "$app/Contents/Resources"

    cp "${zathuraCoreBin}/bin/.zathura-wrapped" "$app/Contents/MacOS/zathura-bin"
    chmod +x "$app/Contents/MacOS/zathura-bin"

    "$CC" -fobjc-arc -framework AppKit \
      "${launcherSource}" -o "$app/Contents/MacOS/Zathura"

    png2icns "$app/Contents/Resources/Zathura.icns" \
      "${zathuraCoreOut}/share/icons/hicolor/16x16/apps/org.pwmt.zathura.png" \
      "${zathuraCoreOut}/share/icons/hicolor/32x32/apps/org.pwmt.zathura.png" \
      "${zathuraCoreOut}/share/icons/hicolor/128x128/apps/org.pwmt.zathura.png" \
      "${zathuraCoreOut}/share/icons/hicolor/256x256/apps/org.pwmt.zathura.png"

    cat > "$app/Contents/Info.plist" <<EOF
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>CFBundleDisplayName</key>
      <string>Zathura</string>
      <key>CFBundleDocumentTypes</key>
      <array>
        <dict>
          <key>CFBundleTypeExtensions</key>
          <array>
            <string>pdf</string>
          </array>
          <key>CFBundleTypeName</key>
          <string>PDF document</string>
          <key>CFBundleTypeRole</key>
          <string>Viewer</string>
          <key>LSHandlerRank</key>
          <string>Alternate</string>
          <key>LSItemContentTypes</key>
          <array>
            <string>com.adobe.pdf</string>
          </array>
        </dict>
      </array>
      <key>CFBundleExecutable</key>
      <string>Zathura</string>
      <key>CFBundleIconFile</key>
      <string>Zathura.icns</string>
      <key>CFBundleIdentifier</key>
      <string>org.pwmt.zathura</string>
      <key>CFBundleInfoDictionaryVersion</key>
      <string>6.0</string>
      <key>CFBundleName</key>
      <string>Zathura</string>
      <key>CFBundlePackageType</key>
      <string>APPL</string>
      <key>CFBundleShortVersionString</key>
      <string>${zathura.version}</string>
      <key>CFBundleVersion</key>
      <string>${zathura.version}</string>
      <key>LSEnvironment</key>
      <dict>
        <key>GDK_PIXBUF_MODULE_FILE</key>
        <string>${zathuraCore.GDK_PIXBUF_MODULE_FILE}</string>
        <key>PATH</key>
        <string>${lib.makeBinPath [ pkgs.file ]}:/usr/bin:/bin</string>
        <key>XDG_DATA_DIRS</key>
        <string>${xdgDataDirs}</string>
        <key>ZATHURA_PLUGINS_PATH</key>
        <string>$out/lib/zathura</string>
      </dict>
      <key>LSMinimumSystemVersion</key>
      <string>10.13</string>
      <key>NSHighResolutionCapable</key>
      <true/>
    </dict>
    </plist>
    EOF

    /usr/bin/codesign --force --deep --sign - "$app"

    rm "$out/bin/zathura"
    makeWrapper "$app/Contents/MacOS/zathura-bin" "$out/bin/zathura" \
      --prefix PATH : "${lib.makeBinPath [ pkgs.file ]}" \
      --set GDK_PIXBUF_MODULE_FILE "${zathuraCore.GDK_PIXBUF_MODULE_FILE}" \
      --prefix XDG_DATA_DIRS : "${xdgDataDirs}" \
      --prefix ZATHURA_PLUGINS_PATH : "$out/lib/zathura" \
      --run 'unset DBUS_LAUNCHD_SESSION_BUS_SOCKET DBUS_SESSION_BUS_ADDRESS' \
      --run 'dbus_service="gui/$(/usr/bin/id -u)/org.nix-community.home.dbus-session"' \
      --run 'dbus_socket=$(/bin/launchctl print "$dbus_service" 2>/dev/null | /usr/bin/awk "\$1 == \"DBUS_LAUNCHD_SESSION_BUS_SOCKET\" && \$2 == \"=>\" { print \$3; exit }")' \
      --run 'if [ -n "$dbus_socket" ]; then export DBUS_LAUNCHD_SESSION_BUS_SOCKET="$dbus_socket"; export DBUS_SESSION_BUS_ADDRESS="unix:path=$dbus_socket"; fi'
  '';
}
