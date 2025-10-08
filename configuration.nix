#####################
# configuration.nix #
#####################

# The main config file
{ config, pkgs, ... }:

{
# =========== IMPORTS =========== #
	imports = [
		./hardware-configuration.nix; # Hardware config
		<home-manager/nixos>

		# System #
		./system/ly.nix; # ly Display Manager
		./system/xserver.nix; # X11 Display Server

		# Home Manager #
		./home-manager/mun.nix;



# =========== BOOTLOADER =========== #
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;


# =========== KERNEL =========== #
	boot.kernelPackages = pkgs.linuxPackages_latest; # Use latest kernel


# =========== NETWORKING =========== #
	networking.hostname = "kronos"; # Network Hostname of the Machine
	networking.networkmanager = {
		enable = true;
	};


# =========== GENERATIONS =========== #
	nix.gc = {
		automatic = true;
		dates = "weekly";
		options = "--delete-older-than 30d";
	};

}
