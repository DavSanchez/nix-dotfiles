{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.paneru.homeModules.paneru
  ];

  services.paneru = {
    enable = true;

    # Start from Paneru's defaults to judge ergonomics; only pin down what
    # differs per-host or is needed for the multi-monitor setup.
    settings = {
      options = {
        # Defaults are true for both; stated explicitly so the trial
        # makes the focus/mouse behavior obvious.
        focus_follows_mouse = true;
        mouse_follows_focus = true;

        # Solio: LG 4K landscape (main) + HP 25x rotated portrait.
        # Physically the portrait panel sits beside/below the 4K, but macOS
        # sees them stacked vertically, so warp at horizontal screen edges.
        # Sign flips direction: -1 warps left-edge -> display above,
        # right-edge -> display below. Tune sign/offset live on the host.
        horizontal_mouse_warp = -1;
        horizontal_mouse_warp_offset = 0;

        preset_column_widths = [
          0.25
          0.33
          0.5
          0.66
          0.75
          1.0
          1.5
          2.0
        ];
      };

      padding = {
        top = 8;
        bottom = 8;
        left = 8;
        right = 8;
      };

      bindings = {
        # Focus — mirror the OmniWM Control+Option+Arrows habit where
        # possible without colliding with macOS/reserved combos.
        window_focus_west = "ctrl + alt - leftarrow";
        window_focus_east = "ctrl + alt - rightarrow";
        window_focus_north = "ctrl + alt - uparrow";
        window_focus_south = "ctrl + alt - downarrow";

        # Move focused window in the strip.
        window_swap_west = "ctrl + alt + shift - leftarrow";
        window_swap_east = "ctrl + alt + shift - rightarrow";

        # Reorder windows *within a stack* (app a up / app b down -> swapped).
        # North/south on a stack swaps the focused window with the one
        # above/below it in the same column.
        window_swap_north = "ctrl + alt + shift - uparrow";
        window_swap_south = "ctrl + alt + shift - downarrow";

        # Width cycling (was resizeGrow/Shrink).
        window_resize = "ctrl + alt - equal";
        window_shrink = "ctrl + alt - minus";

        # Center / balance.
        window_center = "ctrl + alt - c";
        window_balance = "ctrl + alt - b";

        # Full width toggle (approximates OmniWM primary-span full).
        window_fullwidth = "ctrl + alt - f";

        # Stacks — merge a window into the column on the left (arranges
        # windows vertically within a column; useful on the portrait display),
        # pull it back out, and even up stacked heights.
        window_stack = "ctrl + alt - s";
        window_unstack = "ctrl + alt - d";
        window_equalize = "ctrl + alt - e";

        # Rescue a window that has slid out of the viewport.
        window_snap = "ctrl + alt - r";

        # Displays.
        window_nextdisplay = "ctrl + alt + shift - n";
        window_nextdisplaysend = "ctrl + alt + shift - j";
        mouse_nextdisplay = "ctrl + alt + shift - m";

        # Virtual workspace rows (experimental): slide between stacked window
        # rows within a single macOS Space.
        window_virtual_north = "ctrl + alt + cmd - uparrow";
        window_virtual_south = "ctrl + alt + cmd - downarrow";
        window_virtualmove_north = "ctrl + alt + cmd + shift - uparrow";
        window_virtualmove_south = "ctrl + alt + cmd + shift - downarrow";
      };
    };
  };

  services.jankyborders = {
    enable = true;
    settings = {
      active_color = "0xffe1e3e4";
      inactive_color = "0xff494d64";
      width = 5.0;
    };
  };
}
