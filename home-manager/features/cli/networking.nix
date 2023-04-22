{pkgs, ...}: {
  home.packages = with pkgs; [
    curl
    wget
    xh
    wrk
    mtr
    grpcurl
    termshark
    inetutils
    nmap
    q # Replacing dogdns
    gping
    bandwhich
  ];
}
