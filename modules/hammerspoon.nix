{ config, ... }:
{
  home.file.".hammerspoon/init.lua".text = ''
    local hyper = {"cmd", "ctrl", "alt", "shift"}

    local function focus(app)
      return function()
        hs.application.launchOrFocus(app)
      end
    end

    local zathuraBundleID = "org.pwmt.zathura.nix.viewer"

    local function isZathuraWindow(window)
      local app = window:application()
      return app and app:bundleID() == zathuraBundleID and window:isStandard()
    end

    local function zathuraWindows()
      local windows = {}
      for _, window in ipairs(hs.window.allWindows()) do
        if isZathuraWindow(window) then
          table.insert(windows, window)
        end
      end
      table.sort(windows, function(a, b) return a:id() < b:id() end)
      return windows
    end

    local function focusZathura()
      for _, window in ipairs(hs.window.orderedWindows()) do
        if isZathuraWindow(window) then
          window:focus()
          return
        end
      end
      hs.application.launchOrFocus("/Applications/Zathura.app")
    end

    local function cycleZathuraWindows(step)
      return function()
        local windows = zathuraWindows()
        if #windows < 2 then return end

        local focused = hs.window.focusedWindow()
        local current = 1
        if focused then
          for index, window in ipairs(windows) do
            if window:id() == focused:id() then
              current = index
              break
            end
          end
        end

        local target = ((current - 1 + step) % #windows) + 1
        windows[target]:focus()
        windows[target]:raise()
      end
    end

    local zathuraNextWindow = hs.hotkey.new({"cmd"}, "`", cycleZathuraWindows(1))
    local zathuraPreviousWindow = hs.hotkey.new(
      {"cmd", "shift"}, "`", cycleZathuraWindows(-1)
    )

    local function updateZathuraWindowHotkeys()
      local app = hs.application.frontmostApplication()
      local isZathura = app and app:bundleID() == zathuraBundleID
      if isZathura then
        zathuraNextWindow:enable()
        zathuraPreviousWindow:enable()
      else
        zathuraNextWindow:disable()
        zathuraPreviousWindow:disable()
      end
    end

    zathuraAppWatcher = hs.application.watcher.new(function(_, event)
      if event == hs.application.watcher.activated then
        updateZathuraWindowHotkeys()
      end
    end)
    zathuraAppWatcher:start()
    updateZathuraWindowHotkeys()

    hs.hotkey.bind(hyper, "T", focus("kitty"))
    hs.hotkey.bind(hyper, "C", focus("Claude"))
    hs.hotkey.bind(hyper, "V", focus("Calendar"))
    hs.hotkey.bind(hyper, "B", focus("Google Chrome"))
    hs.hotkey.bind(hyper, "Z", focus("Zotero"))
    hs.hotkey.bind(hyper, "F", focus("Finder"))
    hs.hotkey.bind(hyper, "P", focusZathura)
    hs.hotkey.bind(hyper, "X", focus("Codex"))

    local function openDir(path)
      return function() hs.execute('open "' .. path .. '"') end
    end

    local chooserActions = {
      ["MATH245"]       = openDir(os.getenv("HOME") .. "/Courses/MATH245"),
      ["ECMA30770"]     = openDir(os.getenv("HOME") .. "/Courses/ECMA30770"),
      ["PHYS131"]       = openDir(os.getenv("HOME") .. "/Courses/PHYS131"),
      ["BUSN33914"]     = openDir(os.getenv("HOME") .. "/Courses/BUSN33914"),
      ["Reload config"] = hs.reload,
    }

    local chooserItems = {
      { text = "MATH245",       subText = "~/Courses/MATH245" },
      { text = "ECMA30770",     subText = "~/Courses/ECMA30770" },
      { text = "PHYS131",       subText = "~/Courses/PHYS131" },
      { text = "BUSN33914",     subText = "~/Courses/BUSN33914" },
      { text = "Reload config", subText = "Hammerspoon" },
    }

    local chooser = hs.chooser.new(function(item)
      if item then chooserActions[item.text]() end
    end)
    chooser:choices(chooserItems)

    hs.hotkey.bind(hyper, "space", function()
      if chooser:isVisible() then chooser:hide() else chooser:show() end
    end)

    -- Home Manager replaces this symlink; watch its directory, not its store target.
    local configPath = hs.configdir .. "/init.lua"
    local reloadTimer = hs.timer.delayed.new(0.5, function()
      -- Wait until the replacement file exists before reloading.
      if hs.fs.attributes(configPath, "mode") == "file" then
        hs.reload()
      end
    end)
    configWatcher = hs.pathwatcher.new(hs.configdir, function(paths)
      for _, path in ipairs(paths) do
        if path == configPath then
          reloadTimer:start()
          return
        end
      end
    end):start()
  '';
}
