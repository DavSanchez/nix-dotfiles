[
  # Gemini CLI terminal interaction
  {
    key = "shift+enter";
    command = "workbench.action.terminal.sendSequence";
    when = "terminalFocus";
    args = {
      text = "\\\r\n";
    };
  }
  {
    key = "ctrl+enter";
    command = "workbench.action.terminal.sendSequence";
    when = "terminalFocus";
    args = {
      text = "\\\r\n";
    };
  }
]
