# Work Laptop Install Notes

These notes are for installing this nix-darwin config on another Apple Silicon macOS laptop after pushing the repo to GitHub.

## Before Switching

Clone the repo locally rather than applying directly from `github:`.
This makes it easy to adjust machine-local settings before the first switch.

```bash
git clone git@github.com:YOURUSER/YOURREPO.git ~/nix-config
cd ~/nix-config
```

If the laptop username is different, edit `user.nix` first.

```nix
{
  username = "work-username";
  homeDirectory = "/Users/work-username";
}
```

This config currently targets Apple Silicon macOS only.
It will not work unchanged on an Intel Mac.

## Homebrew Cleanup

Check the Homebrew cleanup setting before the first switch.

```nix
homebrew.onActivation.cleanup = "zap";
```

`"zap"` is aggressive.
It can remove Homebrew casks not declared in this config, including apps that may already be installed or managed on the work laptop.
For a first work-laptop install, consider temporarily changing it to `"none"` before switching.

## Work Security Prompts

Karabiner and Hammerspoon may require Accessibility, Input Monitoring, and related macOS permissions.
Work MDM or security tools may block or prompt for these.
If the switch succeeds but the apps do not work, check System Settings permissions first.

## Box Paths

The Home Manager activation creates symlinks assuming Box is available at:

```text
~/Library/CloudStorage/Box-Box
```

It creates:

```text
~/Box
~/Courses
~/books
~/Econ
```

If Box is not installed or synced on the work laptop, these links may point nowhere.
The weekly `update-notes` LaunchAgent also assumes the Box notes script exists.

## Build First

Run checks and build before switching.

```bash
nix flake check --no-write-lock-file
darwin-rebuild build --flake ~/nix-config#"Aden's Brain"
```

Only switch after the build succeeds and the Homebrew cleanup setting is acceptable.

```bash
sudo darwin-rebuild switch --flake ~/nix-config#"Aden's Brain"
```

Do not run `switch` until you are comfortable with the system defaults, Homebrew casks, shell config, Git config, SSH config, Neovim links, LaunchAgents, and app permissions this config will apply.
