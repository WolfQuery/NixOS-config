############
# rofi.nix #
############

{ config, pkgs, ... }:

{
	programs.rofi = {
		enable = true;

		# TODO: Rewrite the config files in Nix

		configFile = ./rofi/config.rasi;

		extraOptions = [ "-theme" "./rofi/theme.rasi" ];
	};
}
