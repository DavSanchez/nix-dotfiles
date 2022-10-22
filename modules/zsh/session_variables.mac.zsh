# export SSL_CERT_FILE=~/.nix-profile/etc/ssl/certs/ca-bundle.crt

# $(brew --prefix)/bin is mac specific and where brew installs stuff. As we are
# making use of brew as fallback so we need to add it
export PATH="$HOME/.local/bin:$HOME/.nix-profile/bin:$(brew --prefix)/bin:$PATH"
