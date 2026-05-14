{ config, ... }: {
  home.file.".hammerspoon/init.lua".text = ''
    local hyper = {"cmd", "ctrl", "alt", "shift"}

    local function focus(app)
      return function()
        hs.application.launchOrFocus(app)
      end
    end

    hs.hotkey.bind(hyper, "T", focus("kitty"))
    hs.hotkey.bind(hyper, "C", focus("Google Chrome"))
    hs.hotkey.bind(hyper, "Z", focus("Zotero"))
    hs.hotkey.bind(hyper, "F", focus("Finder"))
    hs.hotkey.bind(hyper, "P", focus("Sioyek"))
    hs.hotkey.bind(hyper, "X", focus("Codex"))

    local function openDir(path)
      return function() hs.execute('open "' .. path .. '"') end
    end

    local chooserActions = {
      ["ECON21031"]     = openDir(os.getenv("HOME") .. "/Courses/ECON21031"),
      ["ECON297-Ben"]   = openDir(os.getenv("HOME") .. "/Courses/ECON297-Ben"),
      ["ECMA30760"]     = openDir(os.getenv("HOME") .. "/Courses/ECMA30760"),
      ["HIST15413"]     = openDir(os.getenv("HOME") .. "/Courses/HIST15413"),
      ["Reload config"] = hs.reload,
    }

    local chooserItems = {
      { text = "ECON21031",     subText = "~/Courses/ECON21031" },
      { text = "ECON297-Ben",   subText = "~/Courses/ECON297-Ben" },
      { text = "ECMA30760",     subText = "~/Courses/ECMA30760" },
      { text = "HIST15413",     subText = "~/Courses/HIST15413" },
      { text = "Reload config", subText = "Hammerspoon" },
    }

    local chooser = hs.chooser.new(function(item)
      if item then chooserActions[item.text]() end
    end)
    chooser:choices(chooserItems)

    hs.hotkey.bind(hyper, "space", function()
      if chooser:isVisible() then chooser:hide() else chooser:show() end
    end)

    hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/init.lua", hs.reload):start()
  '';
}
