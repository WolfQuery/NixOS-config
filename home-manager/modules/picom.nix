#############
# picom.nix #
#############

# Mun's Picom config via home-manager
{ config, pkgs, ... }:

{
	services.picom = {
		enable = true;

# =========== BASICS =========== #
		backend = "glx";
		vsync = true;
		unredirIfPossible = true;

# =========== TRANSPARENCY / FADING =========== #
		inactiveOpacity = 0.9;
		activeOpacity = 1.0;
		frameOpacity = 0.9;
		inactiveDim = 0.05;
		fading = true;
		fadeInStep = 0.09;
		fadeOutStep = 0.09;

# =========== SHADOWS =========== #
		shadow = true;
		shadowRadius = 12;
		shadowOffsetX = -12;
		shadowOffsetY = -12;
		shadowOpacity = 0.5;

# =========== CORNERS =========== #
		cornerRadius = 8;
		roundBorders = 1;

# =========== MISC =========== #
		detectClientOpacity = true;
		detectTransient = true;
		detectRoundedCorners = true;
		useDamage = true;

# =========== RESTART SCRIPT =========== #
		package = pkgs.writeShellScriptBin "restart-picom" ''
	    	#!/usr/bin/env bash
	    	pkill picom || true
	    	picom --experimental-backends --config ${config.xdg.configHome}/picom/picom.conf &
		'';
	};
}

