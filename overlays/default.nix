# This file defines overlays
{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # When applied, the stable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.stable'
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  # rosetta-packages = final: _prev: {
  #   rosetta = if final.stdenv.hostPlatform.isDarwin && final.stdenv.isAarch64 then final.pkgsx86_64Darwin else final;
  # };

  # AI coding agents from numtide/llm-agents.nix, namespaced as
  # `pkgs.llm-agents.<name>` so nothing collides with a nixpkgs attribute name.
  # Re-exported unchanged: the upstream overlay builds each package against the
  # consumer's own pkgs instance, so allowUnfree and its predicates still apply.
  llm-agents = inputs.llm-agents.overlays.shared-nixpkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = _final: _prev: { };
}
