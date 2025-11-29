# This file defines overlays
{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # When applied, the stable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.stable'
  stable-packages = final: _prev: {
    stable-2505 = import inputs.nixpkgs-25-05 {
      system = final.system;
      config.allowUnfree = true;
    };
    stable-2511 = import inputs.nixpkgs-25-11 {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  rosetta-packages = final: _prev: {
    rosetta = if final.stdenv.isDarwin && final.stdenv.isAarch64 then final.pkgsx86_64Darwin else final;
  };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = _final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
    iosevka-term-custom = prev.iosevka.override {
      set = "TermCustom";
      privateBuildPlan = ''
        [buildPlans.IosevkaTermCustom]
        family = "Iosevka Term Custom"
        spacing = "term"
        serifs = "sans"
        noCvSs = false
        exportGlyphNames = true

        [buildPlans.IosevkaTermCustom.ligations]
        inherits = "haskell"
      '';
    };
    iosevka-term-slab-custom = prev.iosevka.override {
      set = "TermSlabCustom";
      privateBuildPlan = ''
        [buildPlans.IosevkaTermSlabCustom]
        family = "Iosevka Term Slab Custom"
        spacing = "term"
        serifs = "slab"
        noCvSs = false
        exportGlyphNames = true

        [buildPlans.IosevkaTermSlabCustom.ligations]
        inherits = "haskell"
      '';
    };
    iosevka-custom = prev.iosevka.override {
      set = "Custom";
      privateBuildPlan = ''
        [buildPlans.IosevkaCustom]
        family = "Iosevka Custom"
        spacing = "normal"
        serifs = "sans"
        noCvSs = false
        exportGlyphNames = true

        [buildPlans.IosevkaCustom.ligations]
        inherits = "haskell"
      '';
    };
    iosevka-slab-custom = prev.iosevka.override {
      set = "SlabCustom";
      privateBuildPlan = ''
        [buildPlans.IosevkaSlabCustom]
        family = "Iosevka Slab Custom"
        spacing = "normal"
        serifs = "slab"
        noCvSs = false
        exportGlyphNames = true

        [buildPlans.IosevkaSlabCustom.ligations]
        inherits = "haskell"
      '';
    };
  };
}
