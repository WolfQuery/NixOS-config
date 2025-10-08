###############
# xserver.nix #
###############

# The xserver config
{ config, pkgs, ...}:

{

# =========== X11 =========== #
	services.xserver.enable = true; # Enable the X11 windowing system

# =========== KEYMAP =========== #
	services.xserver.xkb = {
		layout = "cz";
		variant = "winkeys";
	};

# =========== DESKTOP ENVIRONMENT =========== #
	services.xserver.windowManager.i3.enable = true; # Enable i3wm

}
