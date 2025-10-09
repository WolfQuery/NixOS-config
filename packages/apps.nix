############
# apps.nix #
############

{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
discord
obsidian
kitty
xfce.thunar
thunderbird
flameshot
libreoffice
spotify
tor-browser

  ];
}

