# Reusable nix-darwin module test infrastructure.
# Mirrors nix-darwin's release.nix makeTest pattern.
#
# Usage:
#   let
#     darwinTests = import ./lib/darwin-tests.nix { inherit lib darwin; };
#   in {
#     checks.aarch64-darwin = darwinTests.makeTestSuite {
#       system = "aarch64-darwin";
#       modules = [ self.darwinModules.networking self.darwinModules.stevenBlack ];
#       dir = ./tests/darwin;
#     };
#   }
{ lib, darwin }:

let
  makeTest =
    {
      system,
      modules ? [ ],
      testFile,
    }:
    let
      testHarness =
        { config, pkgs, ... }:
        {
          options = {
            out = lib.mkOption { type = lib.types.package; };
            test = lib.mkOption { type = lib.types.lines; };
          };

          config = {
            out = config.system.build.toplevel;
            system.stateVersion = lib.mkDefault config.system.maxStateVersion or 6;
            system.build.run-test =
              pkgs.runCommand "darwin-test-${builtins.replaceStrings [ ".nix" ] [ "" ] (baseNameOf testFile)}"
                {
                  allowSubstitutes = false;
                  preferLocalBuild = true;
                }
                ''
                  #! ${pkgs.stdenv.shell}
                  set -e
                  echo >&2 "running tests for system ${config.out}"
                  ${config.test}
                  echo >&2 ok
                  touch $out
                '';
          };
        };

      configuration = darwin.lib.darwinSystem {
        inherit system;
        modules = modules ++ [
          testFile
          testHarness
        ];
      };
    in
    configuration.config.system.build.run-test;

  makeTestSuite =
    {
      system,
      modules ? [ ],
      dir,
    }:
    let
      testFiles = lib.filter (f: lib.hasSuffix ".nix" f) (builtins.attrNames (builtins.readDir dir));
      testName = f: builtins.replaceStrings [ ".nix" ] [ "" ] f;
    in
    builtins.listToAttrs (
      map (f: {
        name = testName f;
        value = makeTest {
          inherit system modules;
          testFile = dir + "/${f}";
        };
      }) testFiles
    );
in
{
  inherit makeTest makeTestSuite;
}
