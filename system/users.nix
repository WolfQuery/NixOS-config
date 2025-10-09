#############
# users.nix #
#############

{ config, pkgs, ... }:

{
	users.users.mun = {
		isNormalUser = true;
		description = "Natasha Nightshade";
		extraGroups = [ "networkmanager" "wheel" "bluetooth" ];
		shell = pkgs.zsh;
	};
}
