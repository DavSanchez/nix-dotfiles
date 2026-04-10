_: {
  programs = {
    git.signing = {
      key = "5485C37B9941B0BF";
      signByDefault = true;
    };
    jujutsu.settings.signing = {
      behavior = "own";
      backend = "gpg";
      key = "5485C37B9941B0BF";
    };
  };
}
