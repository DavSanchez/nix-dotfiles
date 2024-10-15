# Curated shortcuts using hyper key (ctrl+shift+alt+meta) for navigating
# requires single hyper key using custom keyboard or use:
# https:#gist.github.com/nat-418/135a62fb9f37cc87cd70af1ab72e276a
#
# Be warned that you may need to remove or change some emoji/unicode
# bindings in ibus-setup as I found these clashed on RedHat and Ubuntu
[
  # error navigation
  {
    key = "ctrl+shift+alt+meta+\\";
    command = "editor.action.marker.prev";
    when = "editorFocus";
  }
  {
    key = "ctrl+shift+alt+meta+'";
    command = "editor.action.marker.next";
    when = "editorFocus";
  }
  # changes navigation
  {
    key = "ctrl+shift+alt+meta+'";
    command = "workbench.action.compareEditor.nextChange";
    when = "textCompareEditorVisible";
  }
  {
    key = "ctrl+shift+alt+meta+\\";
    command = "workbench.action.compareEditor.previousChange";
    when = "textCompareEditorVisible";
  }
  # These are for navigating between panes ----------------------------------
  #
  # switch to terminal
  {
    key = "alt+ctrl+shift+meta+k";
    command = "workbench.action.terminal.focus";
  }
  # switch to editors
  {
    key = "alt+ctrl+shift+meta+i";
    command = "workbench.action.focusActiveEditorGroup";
    when = "!editorFocus";
  }
  # focus to the right in editors
  {
    key = "alt+ctrl+shift+meta+l";
    command = "workbench.action.focusNextGroup";
  }
  # focus left in editors
  {
    key = "alt+ctrl+shift+meta+j";
    command = "workbench.action.focusPreviousGroup";
    when = "activeEditorGroupIndex!=1";
  }
  # focus the sidebar, moving left from first group
  {
    key = "ctrl+shift+alt+meta+j";
    command = "workbench.action.focusSideBar";
    when = "activeEditorGroupIndex==1";
  }
  # focus the activity bar, moving left from the sidebar
  {
    key = "ctrl+shift+alt+meta+j";
    command = "workbench.action.focusActivityBar";
    when = "sideBarFocus";
  }
  # focus the first group, moving right from the side bar
  {
    key = "ctrl+shift+alt+meta+l";
    command = "workbench.action.focusFirstEditorGroup";
    when = "sideBarFocus";
  }
  # focus right in terminals
  {
    key = "alt+ctrl+shift+meta+l";
    command = "workbench.action.terminal.focusNextPane";
    when = "terminalFocus";
  }
  # focus left in terminals
  {
    key = "alt+ctrl+shift+meta+j";
    command = "workbench.action.terminal.focusPreviousPane";
    when = "terminalFocus";
  }
  # These are for splitting / sizing panes -------------------------------------------
  # split terminal
  {
    key = "alt+ctrl+shift+meta+y";
    command = "workbench.action.terminal.split";
    when = "terminalFocus";
  }
  # split editor left right
  {
    key = "alt+ctrl+shift+meta+y";
    command = "workbench.action.splitEditor";
    when = "editorFocus";
  }
  # split editor up down
  {
    key = "alt+ctrl+shift+meta+6";
    command = "workbench.action.splitEditorOrthogonal";
    when = "editorFocus";
  }
  # close terminal pane
  {
    key = "alt+ctrl+shift+meta+0";
    command = "workbench.action.terminal.kill";
    when = "terminalFocus";
  }
  # close other pane
  {
    key = "alt+ctrl+shift+meta+0";
    command = "workbench.action.closeActiveEditor";
    when = "!terminalFocus";
  }
  # close all other editors in group
  {
    key = "ctrl+shift+alt+meta+P";
    command = "workbench.action.closeOtherEditors";
  }
  # terminal resize ---------------------------------------------------------
  {
    key = "alt+ctrl+shift+meta+8";
    command = "workbench.action.terminal.resizePaneUp";
    when = "terminalFocus";
  }
  {
    key = "alt+ctrl+shift+meta+,";
    command = "workbench.action.terminal.resizePaneDown";
    when = "terminalFocus";
  }
  {
    key = "ctrl+shift+alt+meta+h";
    command = "workbench.action.terminal.resizePaneLeft";
    when = "terminalFocus";
  }
  {
    key = "ctrl+shift+alt+meta+;";
    command = "workbench.action.terminal.resizePaneRight";
    when = "terminalFocus";
  }
  # editor resize  ----------------------------------------------------------
  {
    key = "ctrl+shift+alt+meta+8";
    command = "workbench.action.increaseViewHeight";
    when = "!terminalFocus";
  }
  {
    key = "ctrl+shift+alt+meta+,";
    command = "workbench.action.decreaseViewHeight";
    when = "!terminalFocus";
  }
  {
    key = "ctrl+shift+alt+meta+;";
    command = "workbench.action.increaseViewWidth";
    when = "!terminalFocus";
  }
  {
    key = "ctrl+shift+alt+meta+h";
    command = "workbench.action.decreaseViewWidth";
    when = "!terminalFocus";
  }
  {
    key = "alt+ctrl+shift+meta+9";
    command = "workbench.action.increaseViewSize";
    when = "!terminalFocus";
  }
  {
    key = "alt+ctrl+shift+meta+7";
    command = "workbench.action.decreaseViewSize";
    when = "!terminalFocus";
  }
  {
    key = "alt+ctrl+shift+meta+n";
    command = "workbench.action.evenEditorWidths";
    when = "!terminalFocus";
  }
  # shift editor windows between groups
  {
    key = "shift+alt+ctrl+shift+meta+o";
    command = "workbench.action.moveEditorToNextGroup";
  }
  {
    key = "shift+alt+ctrl+shift+meta+u";
    command = "workbench.action.moveEditorToPreviousGroup";
  }
  # move between editor pages
  {
    key = "ctrl+shift+alt+meta+.";
    command = "workbench.action.nextEditor";
  }
  {
    key = "ctrl+shift+alt+meta+m";
    command = "workbench.action.previousEditor";
  }
  # a few other useful things ------------------------------------------------
  # my preferred save all shortcut
  {
    key = "ctrl+shift+s";
    command = "workbench.action.files.saveFiles";
  }
  # navigate forward (like browser)
  # {
  #   key = "alt+right";
  #   command = "workbench.action.navigateForward";
  #   when = "canNavigateForward";
  # }
  # navigate back (like browser)
  # {
  #   key = "alt+left";
  #   command = "workbench.action.navigateBack";
  #   when = "canNavigateBack";
  # }
  # easier jumps to side bar items using hyper key plus left hand top row,
  # a, d, f
  #
  #  hyper plus:
  #  a = activity bar (which can access the rest using arrows
  #  d = debug
  #  e = explorer
  #  r / f = repositories / source control
  # rest of top row left hand:
  #  q = extensions, w = timeline, t = testing
  {
    key = "shift+alt+ctrl+shift+meta+a";
    command = "workbench.action.focusActivityBar";
  }
  {
    key = "ctrl+shift+e";
    command = "-workbench.view.explorer";
    when = "viewContainer.workbench.view.explorer.enabled";
  }
  {
    key = "alt+ctrl+shift+meta+e";
    command = "workbench.view.explorer";
  }
  {
    key = "alt+ctrl+shift+meta+r";
    command = "workbench.scm.repositories.focus";
  }
  {
    # scm is the key below source repositories like it is in the panel
    key = "shift+alt+ctrl+shift+meta+f";
    command = "workbench.view.scm";
  }
  {
    key = "alt+ctrl+shift+meta+d";
    command = "workbench.view.debug";
  }
  {
    key = "alt+ctrl+shift+meta+t";
    command = "workbench.view.testing.focus";
  }
  {
    key = "alt+ctrl+shift+meta+q";
    command = "workbench.view.extensions";
  }
  {
    key = "alt+ctrl+shift+meta+w";
    command = "timeline.focus";
    # end of manually edited keybindings   -----------------------------------
  }
  {
    key = "shift+cmd+2";
    command = "coverage-gutters.displayCoverage";
  }
]
