#######################
# audio-bluetooth.nix #
#######################

{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
alsa-utils
helvum
blueman
bluez
cava
  ];
}

