_: {
  programs = {
    git.signing = {
      key = "FB27FC70B15E6D6C";
      signByDefault = true;
    };
    jujutsu.settings.signing = {
      behavior = "own";
      backend = "gpg";
      key = "FB27FC70B15E6D6C";
    };
  };
}
