###########
# zsh.nix #
###########

{ config, pkgs, ... }:

# Mun's zsh config via home-manager
{
	programs.zsh = {
		enable = true;
		enableCompletion = true;
		autosuggestions.enable = true;
		syntaxHighlighting.enable = true;

		ohMyZsh = {
			enable = true;
			theme = "catppuccin"
			plugins = [ "git" "history-substring-search" "z" ];
			};

			initExtra = ''
				export CATPPUCCIN_FLAVOR="mocha"
				export CATPPUCCIN_SHOW_TIME=true
    			'';
	};

  	# Use local theme path
  	home.file.".oh-my-zsh/custom/themes/catppuccin.zsh-theme".source =
    	./zsh/catppuccin-theme/catppuccin.zsh-theme;
}

		};

	home.shell = pkgs.zsh;
}

