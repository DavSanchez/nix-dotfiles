{ lib, ... }:
{
  programs.starship = {
    enable = true;

    settings = {
      format = lib.concatStrings [
        "[>>-](bright-black) $all"
        "$fill"
        "$shell$shlvl$time"
        "$line_break"
        "[>>-](bright-black) $character"
      ];
      add_newline = true;
      fill.symbol = " ";
      time = {
        disabled = false;
        format = "[ $time](fg:blue bold)";
        time_format = "%F %R";
      };

      shell = {
        style = "cyan bold";
        disabled = false;
      };

      shlvl.disabled = false;
      direnv.disabled = false;
    };
  };
}
