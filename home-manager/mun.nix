###########
# mun.nix #
###########

# Mun's home-manager config file
{ config, pkgs, ... }:

{
	home-manager.users.mun = { ... }@hmConfig: {
		home.stateVersion = "24.05";

		# Import submodules
		imports = [
			./modules/neovim.nix
			./modules/i3wm.nix
			./modules/polybar.nix
			./modules/picom.nix
			./modules/kitty.nix
			./modules/rofi.nix
			./modules/zsh.nix
			];


	};
}
