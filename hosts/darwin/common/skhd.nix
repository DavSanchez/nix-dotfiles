_: {
  services = {
    skhd = {
      enable = true;
      skhdConfig = ''
        # ################################################################ #
        # THE FOLLOWING IS AN EXPLANATION OF THE GRAMMAR THAT SKHD PARSES. #
        # FOR SIMPLE EXAMPLE MAPPINGS LOOK FURTHER DOWN THIS FILE..        #
        # ################################################################ #

        # A list of all built-in modifier and literal keywords can
        # be found at https://github.com/koekeishiya/skhd/issues/1
        #
        # A hotkey is written according to the following rules:
        #
        #   hotkey       = <mode> '<' <action> | <action>
        #
        #   mode         = 'name of mode' | <mode> ',' <mode>
        #
        #   action       = <keysym> '[' <proc_map_lst> ']' | <keysym> '->' '[' <proc_map_lst> ']'
        #                  <keysym> ':' <command>          | <keysym> '->' ':' <command>
        #                  <keysym> ';' <mode>             | <keysym> '->' ';' <mode>
        #
        #   keysym       = <mod> '-' <key> | <key>
        #
        #   mod          = 'modifier keyword' | <mod> '+' <mod>
        #
        #   key          = <literal> | <keycode>
        #
        #   literal      = 'single letter or built-in keyword'
        #
        #   keycode      = 'apple keyboard kVK_<Key> values (0x3C)'
        #
        #   proc_map_lst = * <proc_map>
        #
        #   proc_map     = <string> ':' <command> | <string>     '~' |
        #                  '*'      ':' <command> | '*'          '~'
        #
        #   string       = '"' 'sequence of characters' '"'
        #
        #   command      = command is executed through '$SHELL -c' and
        #                  follows valid shell syntax. if the $SHELL environment
        #                  variable is not set, it will default to '/bin/bash'.
        #                  when bash is used, the ';' delimeter can be specified
        #                  to chain commands.
        #
        #                  to allow a command to extend into multiple lines,
        #                  prepend '\' at the end of the previous line.
        #
        #                  an EOL character signifies the end of the bind.
        #
        #   ->           = keypress is not consumed by skhd
        #
        #   *            = matches every application not specified in <proc_map_lst>
        #
        #   ~            = application is unbound and keypress is forwarded per usual, when specified in a <proc_map>
        #
        # A mode is declared according to the following rules:
        #
        #   mode_decl = '::' <name> '@' ':' <command> | '::' <name> ':' <command> |
        #               '::' <name> '@'               | '::' <name>
        #
        #   name      = desired name for this mode,
        #
        #   @         = capture keypresses regardless of being bound to an action
        #
        #   command   = command is executed through '$SHELL -c' and
        #               follows valid shell syntax. if the $SHELL environment
        #               variable is not set, it will default to '/bin/bash'.
        #               when bash is used, the ';' delimeter can be specified
        #               to chain commands.
        #
        #               to allow a command to extend into multiple lines,
        #               prepend '\' at the end of the previous line.
        #
        #               an EOL character signifies the end of the bind.

        # opens WezTerm
        alt - return : /usr/bin/env wezterm

        # Show system statistics
        # fn + lalt - 1 : ~/.config/yabai/scripts/show_cpu.sh
        # fn + lalt - 2 : ~/.config/yabai/scripts/show_mem.sh
        # fn + lalt - 3 : ~/.config/yabai/scripts/show_bat.sh
        # fn + lalt - 4 : ~/.config/yabai/scripts/show_disk.sh
        # fn + lalt - 5 : ~/.config/yabai/scripts/show_song.sh

        # Navigation
        alt - h : yabai -m window --focus west
        alt - j : yabai -m window --focus south
        alt - k : yabai -m window --focus north
        alt - l : yabai -m window --focus east

        # Moving windows
        shift + alt - h : yabai -m window --warp west
        shift + alt - j : yabai -m window --warp south
        shift + alt - k : yabai -m window --warp north
        shift + alt - l : yabai -m window --warp east

        # Move focus container to workspace
        shift + alt - m : yabai -m window --space last; yabai -m space --focus last
        shift + alt - p : yabai -m window --space prev; yabai -m space --focus prev
        shift + alt - n : yabai -m window --space next; yabai -m space --focus next
        shift + alt - 1 : yabai -m window --space 1; yabai -m space --focus 1
        shift + alt - 2 : yabai -m window --space 2; yabai -m space --focus 2
        shift + alt - 3 : yabai -m window --space 3; yabai -m space --focus 3
        shift + alt - 4 : yabai -m window --space 4; yabai -m space --focus 4

        # Resize windows
        lctrl + alt - h : yabai -m window --resize left:-50:0; \
                          yabai -m window --resize right:-50:0
        lctrl + alt - j : yabai -m window --resize bottom:0:50; \
                          yabai -m window --resize top:0:50
        lctrl + alt - k : yabai -m window --resize top:0:-50; \
                          yabai -m window --resize bottom:0:-50
        lctrl + alt - l : yabai -m window --resize right:50:0; \
                          yabai -m window --resize left:50:0

        # Equalize size of windows
        lctrl + alt - e : yabai -m space --balance

        # Toggle window split type
        alt - e : yabai -m window --toggle split

        # Enable / Disable gaps in current workspace
        lctrl + alt - g : yabai -m space --toggle padding; yabai -m space --toggle gap

        # Rotate windows clockwise and anticlockwise
        alt - r         : yabai -m space --rotate 270
        shift + alt - r : yabai -m space --rotate 90

        # Rotate on X and Y Axis
        shift + alt - x : yabai -m space --mirror x-axis
        shift + alt - y : yabai -m space --mirror y-axis

        # Set insertion point for focused container
        shift + lctrl + alt - h : yabai -m window --insert west
        shift + lctrl + alt - j : yabai -m window --insert south
        shift + lctrl + alt - k : yabai -m window --insert north
        shift + lctrl + alt - l : yabai -m window --insert east

        # Float / Unfloat window
        shift + alt - space : \
            yabai -m window --toggle float; \
            yabai -m window --toggle border

        # Restart Yabai
        # shift + lctrl + alt - r : \
        #     /usr/bin/env osascript <<< \
        #         "display notification \"Restarting Yabai\" with title \"Yabai\""; \
        #     launchctl kickstart -k "gui/$(echo -n $UID)/homebrew.mxcl.yabai"

        # Make window native fullscreen
        alt - f         : yabai -m window --toggle zoom-fullscreen
        shift + alt - f : yabai -m window --toggle native-fullscreen
      '';
    };
  };
}
