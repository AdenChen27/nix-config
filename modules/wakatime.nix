# TODO: Re-enable when setting up time tracking again (Wakapi self-hosted or Hakatime).
# Requires WAKATIME_API_KEY in env.nix and importing this module in home.nix.
# This module is NOT currently imported in home.nix.
{ config, pkgs, lib, ... }:
let
  env = import ../env.nix;
  # apiKey = env.WAKATIME_API_KEY;
in {
  home.file = {
    ".wakatime.cfg".text = lib.concatStringsSep "\n" (with lib; [
      "[settings]"
      "debug = false"
      "hidefilenames = false"
      "ignore ="
      "    COMMIT_EDITMSG$"
      "    PULLREQ_EDITMSG$"
      "    MERGE_MSG$"
      "    TAG_EDITMSG$"
      "api_url = https://wakapi.dev/api"
      "api_key = ${env.WAKATIME_API_KEY}"
      ""
      "[projectmap]"
      ".*/courses/MATH* = MATH"
      ".*/courses/ECON*  = ECON"
      ".*/courses/STAT*  = STAT"
      ".*/courses/SOSC*  = SOSC"
    ]);
  };
}

