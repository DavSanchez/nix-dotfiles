{ config, ... }:
{
  services.jankyborders.enable = true;
  services.aerospace = {
    enable = true;
    settings = {

      # You can use it to add commands that run after AeroSpace startup.
      # "after-startup-command' is run after 'after-login-command";
      # Available commands : https://nikitabobko.github.io/AeroSpace/commands
      after-startup-command = [
        # JankyBorders has a built-in detection of already running process,
        # so it won't be run twice on AeroSpace restart
        "exec-and-forget ${config.services.jankyborders.package}/bin/borders active_color=0xffe1e3e4 inactive_color=0xff494d64 width=5.0"
      ];

      # Mouse follows focus when focused monitor changes
      # Drop it from your config, if you don't like this behavior
      # See https://nikitabobko.github.io/AeroSpace/guide#on-focus-changed-callbacks
      # See https://nikitabobko.github.io/AeroSpace/commands#move-mouse
      # Fallback value (if you omit the key): on-focused-monitor-changed = []
      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];

      # You can effectively turn off macOS "Hide application" (cmd-h) feature by toggling this flag
      # Useful if you don't use this macOS feature, but accidentally hit cmd-h or cmd-alt-h key
      # Also see: https://nikitabobko.github.io/AeroSpace/goodies#disable-hide-app
      automatically-unhide-macos-hidden-apps = false;

      # Gaps between windows (inner-*) and between monitor edges (outer-*).
      # Possible values:
      # - Constant:     gaps.outer.top = 8
      # - Per monitor:  gaps.outer.top = [{ monitor.main = 16 }, { monitor."some-pattern" = 32 }, 24]
      #                 In this example, 24 is a default value when there is no match.
      #                 Monitor pattern is the same as for 'workspace-to-monitor-force-assignment'.
      #                 See: https://nikitabobko.github.io/AeroSpace/guide#assign-workspaces-to-monitors
      gaps = {
        inner.horizontal = 8;
        inner.vertical = 8;
        outer.left = 8;
        outer.bottom = 8;
        outer.top = 8;
        outer.right = 8;
      };
      # 'main' binding mode declaration
      # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
      # 'main' binding mode must be always presented
      # Fallback value (if you omit the key): mode.main.binding = {}
      mode.main.binding = {
        # All possible keys:
        # - Letters.        a, b, c, ..., z
        # - Numbers.        0, 1, 2, ..., 9
        # - Keypad numbers. keypad0, keypad1, keypad2, ..., keypad9
        # - F-keys.         f1, f2, ..., f20
        # - Special keys.   minus, equal, period, comma, slash, backslash, quote, semicolon, backtick,
        #                   leftSquareBracket, rightSquareBracket, space, enter, esc, backspace, tab
        # - Keypad special. keypadClear, keypadDecimalMark, keypadDivide, keypadEnter, keypadEqual,
        #                   keypadMinus, keypadMultiply, keypadPlus
        # - Arrows.         left, down, up, right

        # All possible modifiers: cmd, alt, ctrl, shift

        # All possible commands: https://nikitabobko.github.io/AeroSpace/commands

        # See: https://nikitabobko.github.io/AeroSpace/commands#exec-and-forget
        # You can uncomment the following lines to open up terminal with alt + enter shortcut (like in i3)
        # alt-enter = "exec-and-forget wezterm";

        # See: https://nikitabobko.github.io/AeroSpace/commands#layout
        ctrl-period = "layout tiles horizontal vertical";
        ctrl-comma = "layout accordion horizontal vertical";

        # See: https://nikitabobko.github.io/AeroSpace/commands#focus
        alt-shift-h = "focus left";
        alt-shift-j = "focus down";
        alt-shift-k = "focus up";
        alt-shift-l = "focus right";

        # See: https://nikitabobko.github.io/AeroSpace/commands#move
        alt-ctrl-shift-h = "move left";
        alt-ctrl-shift-j = "move down";
        alt-ctrl-shift-k = "move up";
        alt-ctrl-shift-l = "move right";

        # See: https://nikitabobko.github.io/AeroSpace/commands#resize
        alt-ctrl-shift-comma = "resize smart -50";
        alt-ctrl-shift-period = "resize smart +50";

        # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
        alt-shift-1 = "workspace 1";
        alt-shift-2 = "workspace 2";
        alt-shift-3 = "workspace 3";
        alt-shift-4 = "workspace 4";
        alt-shift-5 = "workspace 5";
        alt-shift-6 = "workspace 6";
        alt-shift-7 = "workspace 7";
        alt-shift-8 = "workspace 8";
        alt-shift-9 = "workspace 9";
        alt-shift-a = "workspace A"; # In your config, you can drop workspace bindings that you don't need
        alt-shift-b = "workspace B";
        alt-shift-c = "workspace C";
        alt-shift-d = "workspace D";
        alt-shift-e = "workspace E";
        alt-shift-f = "workspace F";
        alt-shift-g = "workspace G";
        alt-shift-i = "workspace I";
        alt-shift-m = "workspace M";
        alt-shift-n = "workspace N";
        alt-shift-o = "workspace O";
        alt-shift-p = "workspace P";
        alt-shift-q = "workspace Q";
        alt-shift-r = "workspace R";
        alt-shift-s = "workspace S";
        alt-shift-t = "workspace T";
        alt-shift-u = "workspace U";
        alt-shift-v = "workspace V";
        alt-shift-w = "workspace W";
        alt-shift-x = "workspace X";
        alt-shift-y = "workspace Y";
        alt-shift-z = "workspace Z";

        # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
        alt-ctrl-shift-1 = "move-node-to-workspace 1";
        alt-ctrl-shift-2 = "move-node-to-workspace 2";
        alt-ctrl-shift-3 = "move-node-to-workspace 3";
        alt-ctrl-shift-4 = "move-node-to-workspace 4";
        alt-ctrl-shift-5 = "move-node-to-workspace 5";
        alt-ctrl-shift-6 = "move-node-to-workspace 6";
        alt-ctrl-shift-7 = "move-node-to-workspace 7";
        alt-ctrl-shift-8 = "move-node-to-workspace 8";
        alt-ctrl-shift-9 = "move-node-to-workspace 9";
        alt-ctrl-shift-a = "move-node-to-workspace A";
        alt-ctrl-shift-b = "move-node-to-workspace B";
        alt-ctrl-shift-c = "move-node-to-workspace C";
        alt-ctrl-shift-d = "move-node-to-workspace D";
        alt-ctrl-shift-e = "move-node-to-workspace E";
        alt-ctrl-shift-f = "move-node-to-workspace F";
        alt-ctrl-shift-g = "move-node-to-workspace G";
        alt-ctrl-shift-i = "move-node-to-workspace I";
        alt-ctrl-shift-m = "move-node-to-workspace M";
        alt-ctrl-shift-n = "move-node-to-workspace N";
        alt-ctrl-shift-o = "move-node-to-workspace O";
        alt-ctrl-shift-p = "move-node-to-workspace P";
        alt-ctrl-shift-q = "move-node-to-workspace Q";
        alt-ctrl-shift-r = "move-node-to-workspace R";
        alt-ctrl-shift-s = "move-node-to-workspace S";
        alt-ctrl-shift-t = "move-node-to-workspace T";
        alt-ctrl-shift-u = "move-node-to-workspace U";
        alt-ctrl-shift-v = "move-node-to-workspace V";
        alt-ctrl-shift-w = "move-node-to-workspace W";
        alt-ctrl-shift-x = "move-node-to-workspace X";
        alt-ctrl-shift-y = "move-node-to-workspace Y";
        alt-ctrl-shift-z = "move-node-to-workspace Z";

        # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
        alt-shift-tab = "workspace-back-and-forth";
        # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
        alt-ctrl-shift-tab = "move-workspace-to-monitor --wrap-around next";

        # See: https://nikitabobko.github.io/AeroSpace/commands#mode
        alt-ctrl-shift-quote = "mode service";

        alt-ctrl-f = "fullscreen";

      };

      # 'service' binding mode declaration.
      # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
      mode.service.binding = {
        esc = [
          "reload-config"
          "mode main"
        ];
        r = [
          "flatten-workspace-tree"
          "mode main"
        ]; # reset layout
        f = [
          "layout floating tiling"
          "mode main"
        ]; # Toggle between floating and tiling layout
        backspace = [
          "close-all-windows-but-current"
          "mode main"
        ];

        # sticky is not yet supported https://github.com/nikitabobko/AeroSpace/issues/2
        #s = ['layout sticky tiling', 'mode main']

        alt-ctrl-shift-h = [
          "join-with left"
          "mode main"
        ];
        alt-ctrl-shift-j = [
          "join-with down"
          "mode main"
        ];
        alt-ctrl-shift-k = [
          "join-with up"
          "mode main"
        ];
        alt-ctrl-shift-l = [
          "join-with right"
          "mode main"
        ];

        down = "volume down";
        up = "volume up";
        shift-down = [
          "volume set 0"
          "mode main"
        ];
      };
    };
  };
}
