############
# i3wm.nix #
############

# Mun's i3wm config (home-manager)
{ config, pkgs, ... }:

{
  # Enable i3 via Home Manager (for config management only)
  	xsession.windowManager.i3 = {
    		enable = true;

		config = {
			modifier = "Mod4"; # Super/Windows key
			floating.modifier = "Mod4"; # Enables mouse + Mod4 to drag/resize floating windows

			# Define names for default workspaces
			ws1 = "1";
			ws2 = "2";
			ws3 = "3";
			ws4 = "4";
			ws5 = "5";
			ws6 = "6";
			ws7 = "7";
			ws8 = "8";
			ws9 = "9";
			ws10 = "10";
      			terminal = "kitty";
      			startup = [
				{ command = "dex-autostart --autostart --environment i3"; }
				{ command = "xss-lock --transfer-sleep-lock -- i3lock-fancy-rapid 5 3 --nofork"; }
        			{ command = "nm-applet"; }
        			{ command = "blueman-applet"; }
				{ command = "xrdb -merge ~/.Xresources"; }
				{ command = "feh --bg-scale /etc/wallpapers/diinki/2CB.png"; }
				{ command = "flameshot"; }
				# NOTE: Picom and Polybar autostart with home-manager reload as they have their own configs.
				];

			keybindings = {
				# Brightness
				"XF86MonBrightnessUp" = "exec brightnessctl set +10%";
				"XF86MonBrightnessDown" = "exec brightnessctl set -10%";

				# Volume
				"XF86AudioMute" = "exec amixer set Master toggle";
				"XF86AudioRaiseVolume" = "exec amixer set Master 5%+";
				"XF86AudioLowerVolume" = "exec amixer set Master 5%-";

				# Microphone
				"XF86AudioMicMute" = "exec amixer set Capture toggle";

				# Open Flameshot
				"${config.xsession.windowManager.i3.config.modifier}+Shift+s" = "exec flameshot gui";

				# Open Kitty
				"${config.xsession.windowManager.i3.config.modifier}+Return" = "exec kitty";

				# Lock the screen
				"${config.xsession.windowManager.i3.config.modifier}+Control+l" = "exec --no-startup-id i3lock-fancy-rapid 5 3";
				# Open Rofi
				# As app launcher:
				"${config.xsession.windowManager.i3.config.modifier}+m" = "exec rofi -show drun";
				# As file browser:
				"${config.xsession.windowManager.i3.config.modifier}+Shift+m" = "exec rofi -show filebrowser";
        			# Open Firefox
				"${config.xsession.windowManager.i3.config.modifier}+n" = "exec firefox";

				# Kill focused window
				"${config.xsession.windowManager.i3.config.modifier}+Shift+q" = "kill";

				# Reload i3	
				"${config.xsession.windowManager.i3.config.modifier}+Shift+r" = "restart";

				# Exit i3
				"${config.xsession.windowManager.i3.config.modifier}+Shift+Control+e" = "exit";

				# Change focus
				"${config.xsession.windowManager.i3.config.modifier}+h" = "focus left";
				"${config.xsession.windowManager.i3.config.modifier}+Left" = "focus left";
				"${config.xsession.windowManager.i3.config.modifier}+k" = "focus up";
				"${config.xsession.windowManager.i3.config.modifier}+Up" = "focus up";
				"${config.xsession.windowManager.i3.config.modifier}+l" = "focus right";
				"${config.xsession.windowManager.i3.config.modifier}+Right" = "focus right";
				"${config.xsession.windowManager.i3.config.modifier}+j" = "focus down";
				"${config.xsession.windowManager.i3.config.modifier}+Down" = "focus down";

				# Move focused window
				"${config.xsession.windowManager.i3.config.modifier}+Shift+h" = "move left";
				"${config.xsession.windowManager.i3.config.modifier}+Shift+Left" = "move left";
				"${config.xsession.windowManager.i3.config.modifier}+Shift+k" = "move up";
				"${config.xsession.windowManager.i3.config.modifier}+Shift+Up" = "move up";
				"${config.xsession.windowManager.i3.config.modifier}+Shift+l" = "move right";
				"${config.xsession.windowManager.i3.config.modifier}+Shift+Right" = "move right";
				"${config.xsession.windowManager.i3.config.modifier}+Shift+j" = "move down";
				"${config.xsession.windowManager.i3.config.modifier}+Shift+Down" = "move down";

				# Split horizontally
				"${config.xsession.windowManager.i3.config.modifier}+b" = "split h";

				# Split vertically
				"${config.xsession.windowManager.i3.config.modifier}+v" = "split v";

				# Toggle fullscreen
				"${config.xsession.windowManager.i3.config.modifier}+f" = "fullscreen toggle";

				# Change container layout (stacked, tabbed, toggle split)
				"${config.xsession.windowManager.i3.config.modifier}+s" = "layout stacking";
				"${config.xsession.windowManager.i3.config.modifier}+w" = "layout tabbed";
				"${config.xsession.windowManager.i3.config.modifier}+e" = "toggle split";

				# Toggle tiling / floating for focused window
				"${config.xsession.windowManager.i3.config.modifier}+Shift+space" = "floating toggle";

				# Change focus between tiling / floating windows
				"${config.xsession.windowManager.i3.config.modifier}+space" = "focus mode_toggle";

				# Change focus to the parent container
				"${config.xsession.windowManager.i3.config.modifier}+a" = "focus parent";

				# Change focus to the child container
				"${config.xsession.windowManager.i3.config.modifier}+d" = "focus child";

				# Switch workspace view
				"${config.xsession.windowManager.i3.config.modifier}+plus" = "workspace number ${config.xsession.windowManager.i3.config.ws1}";
				"${config.xsession.windowManager.i3.config.modifier}+ecaron" = "workspace number ${config.xsession.windowManager.i3.config.ws2}";
				"${config.xsession.windowManager.i3.config.modifier}+scaron" = "workspace number ${config.xsession.windowManager.i3.config.ws3}";
				"${config.xsession.windowManager.i3.config.modifier}+ccaron" = "workspace number ${config.xsession.windowManager.i3.config.ws4}";
				"${config.xsession.windowManager.i3.config.modifier}+rcaron" = "workspace number ${config.xsession.windowManager.i3.config.ws5}";
				"${config.xsession.windowManager.i3.config.modifier}+zcaron" = "workspace number ${config.xsession.windowManager.i3.config.ws6}";
				"${config.xsession.windowManager.i3.config.modifier}+yacute" = "workspace number ${config.xsession.windowManager.i3.config.ws7}";
				"${config.xsession.windowManager.i3.config.modifier}+aacute" = "workspace number ${config.xsession.windowManager.i3.config.ws8}";
				"${config.xsession.windowManager.i3.config.modifier}+iacute" = "workspace number ${config.xsession.windowManager.i3.config.ws9}";
				"${config.xsession.windowManager.i3.config.modifier}+eacute" = "workspace number ${config.xsession.windowManager.i3.config.ws10}";

				# Move focused window to workspace
				# Switch workspace view
				"${config.xsession.windowManager.i3.config.modifier}+Shift+plus" = "move container to workspace number ${config.xsession.windowManager.i3.config.ws1}";
				"${config.xsession.windowManager.i3.config.modifier}+Shift+ecaron" = "move container to workspace number ${config.xsession.windowManager.i3.config.ws2}";
				"${config.xsession.windowManager.i3.config.modifier}+Shift+scaron" = "move container to workspace number ${config.xsession.windowManager.i3.config.ws3}";
				"${config.xsession.windowManager.i3.config.modifier}+Shift+ccaron" = "move container to workspace number ${config.xsession.windowManager.i3.config.ws4}";
				"${config.xsession.windowManager.i3.config.modifier}+Shift+rcaron" = "move container to workspace number ${config.xsession.windowManager.i3.config.ws5}";
				"${config.xsession.windowManager.i3.config.modifier}+Shift+zcaron" = "move container to workspace number ${config.xsession.windowManager.i3.config.ws6}";
				"${config.xsession.windowManager.i3.config.modifier}+Shift+yacute" = "move container to workspace number ${config.xsession.windowManager.i3.config.ws7}";
				"${config.xsession.windowManager.i3.config.modifier}+Shift+aacute" = "move container to workspace number ${config.xsession.windowManager.i3.config.ws8}";
				"${config.xsession.windowManager.i3.config.modifier}+Shift+iacute" = "move container to workspace number ${config.xsession.windowManager.i3.config.ws9}";
				"${config.xsession.windowManager.i3.config.modifier}+Shift+eacute" = "move container to workspace number ${config.xsession.windowManager.i3.config.ws10}";

				# Resize window (doable with rmouse + super as well)
				"${config.xsession.windowManager.i3.config.modifier}+r" = "mode resize";
			};

			modes = {
				# Window resize mode
				resize = {
					"h" = "resize shrink width 10 px or 10 ppt";
        				"j" = "resize grow height 10 px or 10 ppt";
        				"k" = "resize shrink height 10 px or 10 ppt";
        				"l" = "resize grow width 10 px or 10 ppt";

        				# Exit resize mode
        				"Return" = "mode default";
        				"Escape" = "mode default";
					"${config.xsession.windowManager.i3.config.modifier}+r" = "mode default";
				};
			};
			colors = {
				focused = {
					border = "#FFFFFF";
					background = "#FFFFFF";
					text = "#FFFFFF";
					indicator = "#FFFFFF";
					childBorder = "#B12CBF";
				};
				focusedInactive = {
					border = "#8C8C8C";
					background = "#4C4C4C";
					text = "#FFFFFF";
					indicator = "#4C4C4C";
					childBorder = "#FFFFFF";
				};
				unfocused = {
					border = "4C4C4C";
					background = "#222222";
					text = "#888888";
					indicator = "#292D2E";
					childBorder = "#500096";
				};
				urgent = {
					border = "#EC69A0";
					background = "#DB3279";
					text = "#FFFFFF";
					indicator = "#DB3279";
					childBorder = "#DB3279";
				};
				placeholder = {
					border = "#000000";
					background = "#0C0C0C";
					text = "#FFFFFF";
					indicator = "#000000";
					childBorder = "#FFFFFF";
				};
			};
			# Border sizes
			window = {
				border = 3;
				floatingBorder = 3;
				hideEdgeBorders = "smart";
			};
		};
	};
}

