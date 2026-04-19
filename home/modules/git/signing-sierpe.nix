_: {
  programs = {
    git.signing = {
      key = "03747679A51FECE9";
      signByDefault = true;
    };
    jujutsu.settings.signing = {
      behavior = "own";
      backend = "gpg";
      key = "03747679A51FECE9";
    };
  };
}
