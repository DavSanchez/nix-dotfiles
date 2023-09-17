{inputs, ...}: let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) lib;

  system = "aarch64-darwin";
  pkgs = import nixpkgs {inherit system;};
  linuxSystem = builtins.replaceStrings ["darwin"] ["linux"] system;

  darwin-builder = lib.nixosSystem {
    system = linuxSystem;
    modules = [
      "${nixpkgs}/nixos/modules/profiles/macos-builder.nix"
      {
        virtualisation.host.pkgs = pkgs;
        virtualisation.darwin-builder.diskSize = lib.mkForce (40 * 1024);
        virtualisation.darwin-builder.memorySize = lib.mkForce (4 * 1024);
        virtualisation.darwin-builder.workingDirectory = "/var/lib/darwin-builder";
        system.nixos.revision = nixpkgs.lib.mkForce null;
      }
    ];
  };
  # Following this guide: https://nixos.org/manual/nixpkgs/unstable/#sec-darwin-builder
  # In short:
  # 1. nix run nixpkgs#darwin.linux-builder
  # 2. Add /etc/ssh/ssh{,d}_config.d/100-linux-builder.conf (already via `environment.etc` below)
  # ```
  # Host linux-builder
  #   Hostname localhost
  #   HostKeyAlias linux-builder
  #   Port 31022
  # ```
  # 3. `nix.conf` should be already correct via `nix.buildMachines` setting below
in {
  nix.distributedBuilds = true;
  nix.buildMachines = [
    {
      protocol = "ssh-ng";
      hostName = "linux-builder";
      sshUser = "builder";
      system = linuxSystem;
      maxJobs = 4;
      supportedFeatures = ["kvm" "benchmark" "big-parallel"];
      sshKey = "/etc/nix/builder_ed25519";
      publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpCV2N4Yi9CbGFxdDFhdU90RStGOFFVV3JVb3RpQzVxQkorVXVFV2RWQ2Igcm9vdEBuaXhvcwo=";
    }
  ];

  # There's conflicting documentation, so I create it in both places just in case...
  environment.etc = {
    "ssh/ssh_config.d/100-linux-builder.conf".source = ./100-linux-builder.conf;
    "ssh/sshd_config.d/100-linux-builder.conf".source = ./100-linux-builder.conf;
  };

  launchd.daemons.darwin-builder = {
    command = "${darwin-builder.config.system.build.macos-builder-installer}/bin/create-builder";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/var/log/darwin-builder.log";
      StandardErrorPath = "/var/log/darwin-builder.log";
    };
    environment.NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
  };
}
