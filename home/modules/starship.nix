{ lib, ... }:
{
  programs.starship = {
    enable = true;

    settings = {
      format = lib.concatStrings [
        "[>>-](lavender) $all"
        "$line_break"
        "[>>-](lavender) $character"
      ];
      right_format = "$shell$shlvl";
      add_newline = true;
      shell = {
        style = "cyan bold";
        disabled = false;
      };

      shlvl.disabled = false;
      direnv.disabled = false;
    };
  };
}
