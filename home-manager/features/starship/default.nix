{ lib, ... }:
{
  programs.starship = {
    enable = true;

    settings = {
      format = lib.concatStrings [
        "[>>-](lavender) $all"
        "$fill"
        "$shell$shlvl"
        "$line_break"
        "[>>-](lavender) $character"
      ];
      add_newline = true;
      fill.symbol = " ";
      shell = {
        style = "cyan bold";
        disabled = false;
      };

      shlvl.disabled = false;
      direnv.disabled = false;
    };
  };
}
