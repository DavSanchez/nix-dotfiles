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
        inner.horizontal = 0;
        inner.vertical = 0;
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
        alt-enter = ''
          exec-and-forget osascript -e '
                    tell application "Wezterm"
                        do script
                        activate
                    end tell'
        '';

        # See: https://nikitabobko.github.io/AeroSpace/commands#layout
        ctrl-period = "layout tiles horizontal vertical";
        ctrl-comma = "layout accordion horizontal vertical";

        # See: https://nikitabobko.github.io/AeroSpace/commands#focus
        ctrl-alt-h = "focus left";
        ctrl-alt-j = "focus down";
        ctrl-alt-k = "focus up";
        ctrl-alt-l = "focus right";

        # See: https://nikitabobko.github.io/AeroSpace/commands#move
        ctrl-alt-shift-h = "move left";
        ctrl-alt-shift-j = "move down";
        ctrl-alt-shift-k = "move up";
        ctrl-alt-shift-l = "move right";

        # See: https://nikitabobko.github.io/AeroSpace/commands#resize
        ctrl-alt-shift-comma = "resize smart -50";
        ctrl-alt-shift-period = "resize smart +50";

        # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
        ctrl-alt-1 = "workspace 1";
        ctrl-alt-2 = "workspace 2";
        ctrl-alt-3 = "workspace 3";
        ctrl-alt-4 = "workspace 4";
        ctrl-alt-5 = "workspace 5";
        ctrl-alt-6 = "workspace 6";
        ctrl-alt-7 = "workspace 7";
        ctrl-alt-8 = "workspace 8";
        ctrl-alt-9 = "workspace 9";
        ctrl-alt-a = "workspace A"; # In your config, you can drop workspace bindings that you don't need
        ctrl-alt-b = "workspace B";
        ctrl-alt-c = "workspace C";
        ctrl-alt-d = "workspace D";
        ctrl-alt-e = "workspace E";
        ctrl-alt-f = "workspace F";
        ctrl-alt-g = "workspace G";
        ctrl-alt-i = "workspace I";
        ctrl-alt-m = "workspace M";
        ctrl-alt-n = "workspace N";
        ctrl-alt-o = "workspace O";
        ctrl-alt-p = "workspace P";
        ctrl-alt-q = "workspace Q";
        ctrl-alt-r = "workspace R";
        ctrl-alt-s = "workspace S";
        ctrl-alt-t = "workspace T";
        ctrl-alt-u = "workspace U";
        ctrl-alt-v = "workspace V";
        ctrl-alt-w = "workspace W";
        ctrl-alt-x = "workspace X";
        ctrl-alt-y = "workspace Y";
        ctrl-alt-z = "workspace Z";

        # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
        ctrl-alt-shift-1 = "move-node-to-workspace 1";
        ctrl-alt-shift-2 = "move-node-to-workspace 2";
        ctrl-alt-shift-3 = "move-node-to-workspace 3";
        ctrl-alt-shift-4 = "move-node-to-workspace 4";
        ctrl-alt-shift-5 = "move-node-to-workspace 5";
        ctrl-alt-shift-6 = "move-node-to-workspace 6";
        ctrl-alt-shift-7 = "move-node-to-workspace 7";
        ctrl-alt-shift-8 = "move-node-to-workspace 8";
        ctrl-alt-shift-9 = "move-node-to-workspace 9";
        ctrl-alt-shift-a = "move-node-to-workspace A";
        ctrl-alt-shift-b = "move-node-to-workspace B";
        ctrl-alt-shift-c = "move-node-to-workspace C";
        ctrl-alt-shift-d = "move-node-to-workspace D";
        ctrl-alt-shift-e = "move-node-to-workspace E";
        ctrl-alt-shift-f = "move-node-to-workspace F";
        ctrl-alt-shift-g = "move-node-to-workspace G";
        ctrl-alt-shift-i = "move-node-to-workspace I";
        ctrl-alt-shift-m = "move-node-to-workspace M";
        ctrl-alt-shift-n = "move-node-to-workspace N";
        ctrl-alt-shift-o = "move-node-to-workspace O";
        ctrl-alt-shift-p = "move-node-to-workspace P";
        ctrl-alt-shift-q = "move-node-to-workspace Q";
        ctrl-alt-shift-r = "move-node-to-workspace R";
        ctrl-alt-shift-s = "move-node-to-workspace S";
        ctrl-alt-shift-t = "move-node-to-workspace T";
        ctrl-alt-shift-u = "move-node-to-workspace U";
        ctrl-alt-shift-v = "move-node-to-workspace V";
        ctrl-alt-shift-w = "move-node-to-workspace W";
        ctrl-alt-shift-x = "move-node-to-workspace X";
        ctrl-alt-shift-y = "move-node-to-workspace Y";
        ctrl-alt-shift-z = "move-node-to-workspace Z";

        # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
        ctrl-alt-tab = "workspace-back-and-forth";
        # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
        ctrl-alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

        # See: https://nikitabobko.github.io/AeroSpace/commands#mode
        ctrl-alt-shift-semicolon = "mode service";

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

        ctrl-alt-shift-h = [
          "join-with left"
          "mode main"
        ];
        ctrl-alt-shift-j = [
          "join-with down"
          "mode main"
        ];
        ctrl-alt-shift-k = [
          "join-with up"
          "mode main"
        ];
        ctrl-alt-shift-l = [
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
