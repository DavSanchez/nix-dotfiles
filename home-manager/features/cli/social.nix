{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # gomuks # Matrix client

    neonmodem # BB client
  ];
  programs = {
    # TUI IRC client written in Rust.
    tiny = {
      enable = false;
      settings = {
        servers = [
          {
            addr = "irc.libera.chat";
            port = 6697;
            tls = true;
            realname = "David Sánchez";
            nicks = [ "DavSanchez" ];
            join = [ ];
          }
          {
            addr = "irc.dejatoons.net";
            port = 6697;
            realname = "David";
            nicks = [ "4rch1v4d0r" ];
            join = [ ];
          }
        ];
        defaults = {
          realname = "David Sánchez";
          nicks = [ "DavSanchez" ];
          join = [ ];
          tls = true;
        };
      };
    };
  };
}
