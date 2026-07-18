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
in
pkgs.symlinkJoin {
  name = "zathura-macos-${zathura.version}";
  paths = [ zathura ];
  nativeBuildInputs = [
    pkgs.libicns
    pkgs.makeWrapper
  ];

  postBuild = ''
    app="$out/Applications/Zathura.app"
    mkdir -p "$app/Contents/MacOS" "$app/Contents/Resources"

    cp "${zathuraCoreBin}/bin/.zathura-wrapped" "$app/Contents/MacOS/Zathura"
    chmod +x "$app/Contents/MacOS/Zathura"

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

    rm "$out/bin/zathura"
    makeWrapper "$app/Contents/MacOS/Zathura" "$out/bin/zathura" \
      --prefix PATH : "${lib.makeBinPath [ pkgs.file ]}" \
      --set GDK_PIXBUF_MODULE_FILE "${zathuraCore.GDK_PIXBUF_MODULE_FILE}" \
      --prefix XDG_DATA_DIRS : "${xdgDataDirs}" \
      --prefix ZATHURA_PLUGINS_PATH : "$out/lib/zathura"
  '';
}
