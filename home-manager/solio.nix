# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  pkgs,
  ...
}:

{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # inputs.self.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default
    inputs.nixvim.homeManagerModules.nixvim
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.mac-app-util.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    ./features/ai
    ./features/aws
    ./features/cli
    ./features/dev
    ./features/direnv
    # ./features/emacs
    ./features/git
    ./features/git/signing-mini.nix
    ./features/neovim
    ./features/nu
    ./features/starship
    ./features/vscode
    ./features/zed
    ./features/zellij
    ./features/zsh
    ./features/bash
    ./features/fish
    ./features/terminals

    ./features/app.nix
    ./features/fonts.nix
    ./features/helix.nix
    ./features/tmux.nix
    ./features/cava.nix

    # Darwin specifics
    # ./features/darwin.nix
    # ./darwin/colima.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays your own flake exports (from overlays dir):
      inputs.self.overlays.additions
      inputs.self.overlays.stable-packages
      inputs.self.overlays.rosetta-packages
      inputs.self.overlays.modifications
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "david";
    homeDirectory = "/Users/david";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  xdg.enable = true;

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.sessionVariables = {
    DOTFILES = "$HOME/.dotfiles";
    EDITOR = "hx";
  };

  xdg.configFile."amethyst/amethyst.yml".source = ./darwin/amethyst.yml;

  catppuccin.enable = true;
  catppuccin.flavor = "mocha";

  # https://www.dzombak.com/blog/2024/03/Keeping-a-SMB-share-mounted-on-macOS-and-alerting-when-it-does-down.html
  launchd.agents = {
    "smb-you-come-back-alive" = {
      enable = true;
      config = {
        Program =
          pkgs.writers.writeHaskellBin "you-come-back-alive" { } ''
            {-# LANGUAGE TypeApplications #-}

            import Control.Exception (catch, IOException)
            import Control.Monad (void)
            import Data.List (find, isPrefixOf)
            import Data.Time (getCurrentTime)
            import System.Directory (withCurrentDirectory)
            import System.Process (callProcess, readProcess)
            import System.IO (hPutStrLn, stderr)

            main :: IO ()
            main = do
              currentTime <- getCurrentTime
              catch keepMountAlive (\e -> hPutStrLn stderr (show currentTime ++ ":" ++ show @IOException e))
              where
                keepMountAlive :: IO ()
                keepMountAlive = do
                  mounts <- lines <$> readProcess "/sbin/mount" [] []
                  let mountPoint = maybe (mountSmb >> pure "/Volumes/echoes") pure (mountLookup mounts)
                  mountPoint >>= \mp -> withCurrentDirectory mp (void $ readFile ".liveness.txt")

                mountLookup :: [String] -> Maybe FilePath
                mountLookup mountList =
                  find (\m -> "//david@eter/echoes" `isPrefixOf` m || "//david@eter.local/echoes" `isPrefixOf` m) mountList
                    >>= \mountLine -> pure (words mountLine !! 2) -- Get the mount path from line of `mount` output

                mountSmb :: IO ()
                mountSmb = callProcess "/sbin/mount" ["-t", "smbfs", "//david@eter/echoes.local", "/Volumes/echoes"]
          ''
          + /bin/you-come-back-alive;
        StartInterval = 10;
        StandardErrorPath = "/Users/david/log/launchd/smb-you-come-back-alive/err.log";
        StandardOutPath = "/Users/david/log/launchd/smb-you-come-back-alive/out.log";
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
