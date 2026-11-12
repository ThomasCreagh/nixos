{ ... }:

{
  # hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";

    # The config itself is plain Lua so it can be edited with Hyprland's API
    # stubs; Home Manager links it in and require()s it from hyprland.lua.
    extraLuaFiles.user = ../../extra-config/hypr/user.lua;
  };
}
