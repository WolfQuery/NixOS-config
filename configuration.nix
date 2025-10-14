# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];
  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

networking.hostName = "kronos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Prague";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        polybar
	picom
	rofi
	i3lock-fancy-rapid
      ];
    };
  };

  services.displayManager.defaultSession = "none+i3";
  services.displayManager.ly.enable = true;

  

  # Configure keymap in X11
   services.xserver.xkb.layout = "cz";
   services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
   services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
   services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.mun = {
     isNormalUser = true;
     extraGroups = [ "wheel" "bluetooth" "networkmanager"]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
       tree
     ];
     shell = pkgs.zsh;
   };

   programs.firefox.enable = true;
   programs.zsh.enable = true;

   nixpkgs.config.allowUnFree = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
   environment.systemPackages = with pkgs; [
neovim
wget
discord
obsidian
kitty
xfce.thunar
thunderbird
flameshot
libreoffice
spotify
tor-browser
alsa-utils
helvum
blueman
bluez
cava
i3status
i3lock-fancy-rapid
xss-lock
polybar
picom
rofi
feh
clipman
fira-code
noto-fonts
noto-fonts-emoji
tree git lazygit killall acpi wirelesstools brightnessctl
    fastfetch auto-cpufreq btop virtualbox

    cargo
    rustc
    clippy

   ];
nixpkgs.config.allowUnfree = true;
home-manager.users.mun = {
	home.stateVersion = "25.05";

	programs.zsh = {
		enable = true;
		# enableCompletions = true;
	 	# autosuggestions.enable = true;
 		syntaxHighlighting.enable = true;

		shellAliases = {
			ll = "ls -l";
			rebuild = "sudo nixos-rebuild switch";
		};
		history.size = 10000;

		oh-my-zsh = {
			enable = true;
			plugins = [ "git" "thefuck" ];
			theme = "simple";


		};
		
		initContent = ''
			fastfetch
		'';

		sessionVariables = {
		};
	};

	home.packages = [
  		pkgs.thefuck
	];
	
	programs.neovim = {
  enable = true;
  viAlias = true;
  vimAlias = true;
  defaultEditor = true;

  plugins = with pkgs.vimPlugins; [
    nerdtree
    rust-vim
    catppuccin-nvim
    telescope-nvim
    nvim-treesitter
    vim-commentary
  ];

  # Vimscript settings (run early)
  extraConfig = ''
    set number
    set relativenumber
    syntax on
    filetype plugin indent on

    " Rust specific
    autocmd BufRead,BufNewFile *.rs setlocal filetype=rust

    autocmd vimenter * if !argc() | NERDTree | endif

  '';

  # Lua plugin configuration (runs after plugins are loaded)
  extraLuaConfig = ''
    require("catppuccin").setup({
      flavour = "macchiato",
      integrations = {
        treesitter = true,
        telescope = true,
      },
    })
    vim.cmd.colorscheme "catppuccin"

    require("telescope").setup{}
  '';
};


};
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
   services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
   system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}

