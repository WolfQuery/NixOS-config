#######################
# de-wm-managment,nix #
#######################

{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
i3status
i3lock-fancy-rapid
xss-lock
polybar
picom
rofi
feh
clipman
	];
}

