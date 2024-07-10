_: {
  programs.fish = {
    enable = true;

    functions = {
      __fish_command_not_found_handler = {
        body = "__fish_default_command_not_found_handler $argv[1]";
        onEvent = "fish_command_not_found";
      };
      gitignore = "curl -sL https://www.gitignore.io/api/$argv";
    };

    interactiveShellInit = ''
      fish_config theme choose "Rosé Pine Moon"
    '';

    loginShellInit = "";

    plugins = [ ];

    shellAbbrs = { };

    shellAliases = { };

    shellInit = "";

    shellInitLast = "";
  };

  xdg.configFile."fish/themes" = {
    source = ./themes;
    recursive = true;
  };
}
