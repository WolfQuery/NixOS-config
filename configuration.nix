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

  # Enable bluetooth
  hardware.bluetooth = {
  enable = true;
  powerOnBoot = true;
  settings = {
    General = {
      # Shows battery charge of connected devices on supported
      # Bluetooth adapters. Defaults to 'false'.
      Experimental = true;
      # When enabled other devices can connect faster to us, however
      # the tradeoff is increased power consumption. Defaults to
      # 'false'.
      FastConnectable = false;
    };
    Policy = {
      # Enable all controllers when they are found. This includes
      # adapters present on start as well as adapters that are plugged
      # in later on. Defaults to 'true'.
      AutoEnable = true;
    };
  };
};


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
tree git lazygit killall acpi wirelesstools brightnessctl
    fastfetch auto-cpufreq btop virtualbox

    cargo
    rustc
    clippy
    xclip

    texstudio
    texlive.combined.scheme-full
    godotPackages_4_5.godot


   ];
nixpkgs.config.allowUnfree = true;

fonts = {
  enableDefaultPackages = true;
  packages = with pkgs; [
	fira-code
	noto-fonts
	noto-fonts-emoji
  ];
};

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
    neogit
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

   vim.g.mapleader = " "

   vim.api.nvim_set_keymap('n', '<leader>cd', ':NERDTreeCWD<CR>', { noremap = true, silent = true })


    require("telescope").setup{}

    -- Normal mode tab navigation
vim.keymap.set('n', 'gt', ':tabnext<CR>', { noremap = true, silent = true })     -- next tab
vim.keymap.set('n', 'gT', ':tabprevious<CR>', { noremap = true, silent = true }) -- previous tab

-- Open / close tabs
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { noremap = true, silent = true }) --open a new tab
vim.keymap.set('n', '<leader>tc', ':tabclose<CR>', { noremap = true, silent = true }) -- close the current tab

  '';
};

programs.kitty = {
enable = true;

extraConfig = ''
# BEGIN_KITTY_THEME

# I prefer Maple Mono, but you can use a different font if you prefer.
# Font, my favorite font is maple mono :)
font_family Fira Code
bold_font Fira Code Bold
italic_font Fira Code Light

# Make the cursor shape a beam
shell_integration no-cursor
cursor_shape beam

# Padding
window_padding_width 7
window_padding_height 10

# Scroll back up to 3000 lines.
scrollback_lines 3000

#Default font size.
font_size 11

# Just a keybind to change font size to your liking, it's CTRL + scroll wheel up or down.
map ctrl+shift+plus change_font_size all +1.0
map ctrl+shift+minus change font size all -1.0

# Background opacity, set to 0.7.
# Blur works with hyprland, or sway-fx as a drop-in replacement for sway.
background_opacity 0.7


# Finally, the COLORS! these use the design system I made for this rice.
cursor               #AC82E9

selection_background #d8cab8
selection_foreground #141216

background           #141216
foreground           #d8cab8

color0               #2b2135
color8               #92fcfa
color1               #fc4649
color9               #fc4649
color2               #c4e881
color10              #c4e881
color3               #AC82E9
color11              #AC82E9
color4               #7b91fc
color12              #7b91fc
color5               #f3fc7b
color13              #f3fc7b
color6               #8F56E1
color14              #8F56E1
color7               #fc92fc
color15              #d8cab8


# END_KITTY_THEME
'';
};

services.polybar = {
	enable = true;
	script = "polybar example;";
	config = ''
		;==========================================================
;
;
;   ██████╗  ██████╗ ██╗  ██╗   ██╗██████╗  █████╗ ██████╗
;   ██╔══██╗██╔═══██╗██║  ╚██╗ ██╔╝██╔══██╗██╔══██╗██╔══██╗
;   ██████╔╝██║   ██║██║   ╚████╔╝ ██████╔╝███████║██████╔╝
;   ██╔═══╝ ██║   ██║██║    ╚██╔╝  ██╔══██╗██╔══██║██╔══██╗
;   ██║     ╚██████╔╝███████╗██║   ██████╔╝██║  ██║██║  ██║
;   ╚═╝      ╚═════╝ ╚══════╝╚═╝   ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
;
;
;   To learn more about how to configure Polybar
;   go to https://github.com/polybar/polybar
;
;   The README contains a lot of information
;
;==========================================================

[colors]
background = #1c182d
background-alt = #2b1b3d
foreground = #d0b6fd
primary = #cfb5fd
secondary = #8a78b0
alert = #7b91fc
disabled = #707880

[bar/example]
width = 100%
height = 30pt
radius = 15

; dpi = 96

background = "$${colors.background}"
foreground = $${colors.foreground}

line-size = 4pt

border-size = Opt
border-color = #00000000

padding-left = 0
padding-right = 1

module-margin = 1

separator = |
separator-foreground = $${colors.disabled}

font-0 = monospace;2

modules-left = xworkspaces xwindow
modules-right = filesystem memory cpu wlan xkeyboard battery date

cursor-click = pointer
cursor-scroll = ns-resize

enable-ipc = true

; wm-restack = generic
; wm-restack = bspwm
; wm-restack = i3

; override-redirect = true

; This module is not active by default (to enable it, add it to one of the
; modules-* list above).
; Please note that only a single tray can exist at any time. If you launch
; multiple bars with this module, only a single one will show it, the others
; will produce a warning. Which bar gets the module is timing dependent and can
; be quite random.
; For more information, see the documentation page for this module:
; https://polybar.readthedocs.io/en/stable/user/modules/tray.html
[module/systray]
type = internal/tray

format-margin = 8pt
tray-spacing = 16pt

[module/xworkspaces]
type = internal/xworkspaces

label-active = %name%
label-active-background = $${colors.background-alt}
label-active-underline= $${colors.primary}
label-active-padding = 1

label-occupied = %name%
label-occupied-padding = 1

label-urgent = %name%
label-urgent-background = $${colors.alert}
label-urgent-padding = 1

label-empty = %name%
label-empty-foreground = $${colors.disabled}
label-empty-padding = 1

[module/xwindow]
type = internal/xwindow
label = %title:0:60:...%

[module/filesystem]
type = internal/fs
interval = 25

mount-0 = /

label-mounted = %{F#F0C674}%mountpoint%%{F-} %percentage_used%%

label-unmounted = %mountpoint% not mounted
label-unmounted-foreground = $${colors.disabled}

[module/pulseaudio]
type = internal/pulseaudio

format-volume-prefix = "VOL "
format-volume-prefix-foreground = $${colors.primary}
format-volume = <label-volume>

label-volume = %percentage%%

label-muted = muted
label-muted-foreground = $${colors.disabled}

[module/xkeyboard]
type = internal/xkeyboard
blacklist-0 = num lock

label-layout = %layout%
label-layout-foreground = $${colors.primary}

label-indicator-padding = 2
label-indicator-margin = 1
label-indicator-foreground = $${colors.background}
label-indicator-background = $${colors.secondary}

[module/memory]
type = internal/memory
interval = 2
format-prefix = "RAM "
format-prefix-foreground = $${colors.primary}
label = %percentage_used:2%%

[module/cpu]
type = internal/cpu
interval = 2
format-prefix = "CPU "
format-prefix-foreground = $${colors.primary}
label = %percentage:2%%

[network-base]
type = internal/network
interval = 5
format-connected = <label-connected>
format-disconnected = <label-disconnected>
label-disconnected = %{F#F0C674}%ifname%%{F#707880} disconnected

[module/wlan]
inherit = network-base
interface-type = wireless
label-connected = %{F#F0C674}%ifname%%{F-} %essid%

[module/eth]
inherit = network-base
interface-type = wired
label-connected = %{F#F0C674}%ifname%%{F-}

[module/date]
type = internal/date
interval = 1

date = %H:%M
date-alt = %Y-%m-%d %H:%M:%S

label = %date%
label-foreground = $${colors.primary}

[settings]
screenchange-reload = true
pseudo-transparency = true

[module/battery]
type = internal/battery

; This is useful in case the battery never reports 100% charge
; Default: 100
full-at = 100

; format-low once this charge percentage is reached
; Default: 10
; New in version 3.6.0
low-at = 15

; Use the following command to list batteries and adapters:
; $ ls -1 /sys/class/power_supply/
battery = BAT0
adapter = ADP1

; If an inotify event haven't been reported in this many
; seconds, manually poll for new values.
;
; Needed as a fallback for systems that don't report events
; on sysfs/procfs.
;
; Disable polling by setting the interval to 0.
;
; Default: 5
poll-interval = 5
; vim:ft=dosini
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

  # Enable the OpenS/pipeSH daemon.
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

