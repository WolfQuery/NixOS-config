##########
# ly.nix #
##########

# The config for the ly Display Manager
{ config, pkgs, ... }:

{

# =========== ly =========== #
	services.displayManager.ly = {
		enable = true;

		settings = {
			auth_fails = "5"; # Number of times an incorrect password can be inputed
			clear_password = "true"; # Clear the password after an incorrect input
			bigclock = "en"; # Big clock display, english format (HH:MM)
			full_color = "true"; # Use 32-bit color
			
			animation = "colormix"; # Use the colormix animation
			colormix_col1 = "0x1C182D"; # colormix animation 1st color (HEX)
      			colormix_col2 = "0xD0B6FD"; # colormix animation 2nd color (HEX)
      			colormix_col3 = "Ox8A78B0"; # colormix animation 3rd color (HEX)
		};
	};
}
