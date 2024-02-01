{pkgs, ...}: {
  home.packages = with pkgs; [
    gomuks # Matrix client

    neonmodem # BB client
  ];
  programs = {
    # TUI IRC client written in Rust.
    tiny = {
      enable = true;
      settings = {
        servers = [
          {
            addr = "irc.libera.chat";
            port = 6697;
            tls = true;
            realname = "David Sánchez";
            nicks = ["DavSanchez"];
          }
        ];
        defaults = {
          realname = "David Sánchez";
          nicks = ["DavSanchez"];
          join = [];
          tls = true;
        };
      };
    };
  };
}
