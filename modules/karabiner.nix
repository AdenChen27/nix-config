{ lib, ... }: {
  home.activation.karabinerConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.config/karabiner"
    cp ${../karabiner.json} "$HOME/.config/karabiner/karabiner.json"
    chmod 644 "$HOME/.config/karabiner/karabiner.json"
  '';
}
