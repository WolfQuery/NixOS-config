##############
# neovim.nix #
##############

# Mun's Neovim config (home-manager)
{ config, pkgs, ... }:

{
	programs.neovim = {
		enable = true;
		viAlias = true;
		vimAlias = true;
		vimdiffAlias = true;

		# Set as default editor
		defaultEditor = true;

		# Plugins
		plugins = with pkgs.vimPlugins; [
			nerdtree
			rust-vim
			catppuccin-nvim
		];

		# NVim Options
		extraConfig = ''
			" Line numbers
    			set number
			set relativenumber

    			" Syntax highlighting
			syntax on
			filetype plugin indent on

    			" Rust specific
    			autocmd BufRead,BufNewFile *.rs setlocal filetype=rust

    			" Colorscheme
    			colorscheme catppuccin
  		'';
	};
}
