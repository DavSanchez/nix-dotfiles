# The Hermes Electron GUI. Standalone from services.hermes-agent: on a host
# with no backend/gateway running (see hermes-common.nix), the app spawns its
# own local backend on demand instead of connecting to a managed one.
#
# Since the upstream split, the desktop application is installed through the
# `programs.hermes-agent.desktop.enable` option (it adds `hermes-desktop` to
# home.packages, plus a launcher that carries HERMES_HOME and connects to the
# service's backend when one is configured).
{
  programs.hermes-agent.desktop.enable = true;
}
