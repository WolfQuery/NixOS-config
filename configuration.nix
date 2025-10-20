{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    <home-manager/nixos>
    ];

  # === System Settings ===
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "kronos";
  networking.networkmanager.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General.Experimental = true;
      Policy.AutoEnable = true;
    };
  };

  time.timeZone = "Europe/Prague";

  services.xserver = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [ polybar picom rofi i3lock-fancy-rapid ];
    };
  };

  services.displayManager.defaultSession = "none+i3";
  services.displayManager.ly.enable = true;

  services.xserver.xkb.layout = "cz";
  services.xserver.xkb.options = "eurosign:e,caps:escape";

  services.printing.enable = true;
  services.pipewire = { enable = true; pulse.enable = true; };
  services.libinput.enable = true;

  users.users.mun = {
    isNormalUser = true;
    extraGroups = [ "wheel" "bluetooth" "networkmanager" ];
    packages = with pkgs; [ tree ];
    shell = pkgs.zsh;
  };

  programs.firefox.enable = true;
  programs.zsh.enable = true;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    neovim wget gcc clang stdenv tree-sitter discord kitty xfce.thunar thunderbird
    flameshot libreoffice spotify tor-browser alsa-utils helvum
    blueman bluez cava i3status i3lock-fancy-rapid xss-lock polybar
    picom rofi feh clipman tree git lazygit killall acpi wirelesstools
    brightnessctl fastfetch auto-cpufreq btop virtualbox cargo rustc
    clippy xclip texstudio texlive.combined.scheme-full godotPackages_4_5.godot 
    gcc clang tree-sitter ripgrep fd unzip zathura lua-language-server stylua
    rust-analyzer rustfmt cargo rustc texlive.combined.scheme-full zathura
    ruff vtsls pyright
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [ fira-code noto-fonts noto-fonts-emoji ];
  };

  # === Home Manager User Config ===
  home-manager.users.mun = { pkgs, ... }: {
    home = {
      stateVersion = "25.05";
      packages = with pkgs; [
        thefuck zathura ripgrep fd git lazygit tree-sitter
      ];
    };
   
    programs = {
      # --- ZSH ---
      zsh = {
        enable = true;
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

        initContent = "fastfetch";
      };

      # --- Neovim ---
      neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
      
      extraPackages = with pkgs; [
        # lazyVim
        lua-language-server
        stylua
        # Telescope
        ripgrep
      ];
      plugins = with pkgs.vimPlugins; [
        lazy-nvim
      ];

      extraLuaConfig = 
        let
          plugins = with pkgs.vimPlugins; [
            # LazyVim
            LazyVim
            bufferline-nvim
            cmp-buffer
            cmp-nvim-lsp
            cmp-path
            cmp_luasnip
            conform-nvim
            dashboard-nvim
            dressing-nvim
            flash-nvim
            friendly-snippets
            gitsigns-nvim
            indent-blankline-nvim
            lualine-nvim
            neo-tree-nvim
            neoconf-nvim
            neodev-nvim
            noice-nvim
            nui-nvim
            nvim-cmp
            nvim-lint
            nvim-lspconfig
            nvim-notify
            nvim-spectre
            nvim-treesitter
            nvim-treesitter-context
            nvim-treesitter-textobjects
            nvim-ts-autotag
            nvim-ts-context-commentstring
            nvim-web-devicons
            persistence-nvim
            plenary-nvim
            telescope-fzf-native-nvim
            telescope-nvim
            todo-comments-nvim
            tokyonight-nvim
            trouble-nvim
            vim-illuminate
            vim-startuptime
            which-key-nvim
            { name = "LuaSnip"; path = luasnip; }
            { name = "catppuccin"; path = catppuccin-nvim; lazy = false;}
            { name = "mini.ai"; path = mini-nvim; }
            { name = "mini.bufremove"; path = mini-nvim; }
            { name = "mini.comment"; path = mini-nvim; }
            { name = "mini.indentscope"; path = mini-nvim; }
            { name = "mini.pairs"; path = mini-nvim; }
            { name = "mini.surround"; path = mini-nvim; }
          ];
          mkEntryFromDrv = drv:
            if lib.isDerivation drv then
              { name = "${lib.getName drv}"; path = drv; }
            else
              drv;
          lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
         in
         ''
          require("lazy").setup({
            defaults = {
              lazy = true,
            },
            dev = {
              -- reuse files from pkgs.vimPlugins.*
              path = "${lazyPath}",
              patterns = { "" },
              -- fallback to download
              fallback = true,
            },
            spec = {
              { "LazyVim/LazyVim", import = "lazyvim.plugins" },
              -- The following configs are needed for fixing lazyvim on nix
              -- force enable telescope-fzf-native.nvim
              { "nvim-telescope/telescope-fzf-native.nvim", enabled = true },
              -- disable mason.nvim, use programs.neovim.extraPackages
              { "williamboman/mason-lspconfig.nvim", enabled = false },
              { "williamboman/mason.nvim", enabled = false },
              -- import/override with your plugins
              { import = "plugins" },
              -- treesitter handled by xdg.configFile."nvim/parser", put this line at the end of spec to clear ensure_installed
              { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = {} } },
            },
          })
        '';
      };
    };
     # https://github.com/nvim-treesitter/nvim-treesitter#i-get-query-error-invalid-node-type-at-position

      xdg.configFile."nvim/parser".source =
        let
          parsers = pkgs.symlinkJoin {
            name = "treesitter-parsers";
            paths = (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: with plugins; [
              c
              lua
            ])).dependencies;
          };
        in
        "${parsers}/parser";

      # Normal LazyVim config here, see https://github.com/LazyVim/starter/tree/main/lua
      xdg.configFile."nvim/lua/config/options.lua".text = ''
        vim.opt.number = true
        vim.opt.relativenumber = true
        vim.opt.termguicolors = true
        vim.opt.expandtab = true
        vim.opt.shiftwidth = 2
        vim.opt.tabstop = 2
        vim.opt.smartindent = true
        vim.opt.cursorline = true
        vim.opt.scrolloff = 8
        vim.opt.ignorecase = true
        vim.opt.smartcase = true

        -- set Catppuccin theme
        vim.cmd([[colorscheme catppuccin]])
        vim.g.catppuccin_flavour = "macchiato"
      '';



      # --- Kitty Terminal ---
      programs.kitty = {
        enable = true;
        extraConfig = ''
          font_family Fira Code
          bold_font Fira Code Bold
          italic_font Fira Code Light
          shell_integration no-cursor
          cursor_shape beam
          window_padding_width 7
          window_padding_height 10
          scrollback_lines 3000
          font_size 11
          map ctrl+shift+plus change_font_size all +1.0
          map ctrl+shift+minus change_font_size all -1.0
          background_opacity 0.7
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
        '';
      };

    xsession = {
      windowManager = {
        i3 = {
          enable = true;
          config = {
            bars = [];
            };
          extraConfig = ''
          # This file has been auto-generated by i3-config-wizard(1).
# It will not be overwritten, so edit it as you like.
#
# Should you change your keyboard layout some time, delete
# this file and re-run i3-config-wizard(1).
#

# i3 config file (v4)
#
# Please see https://i3wm.org/docs/userguide.html for a complete reference!

set $mod Mod4

# Font for window titles. Will also be used by the bar unless a different font
# is used in the bar {} block below.
font pango:Fira Code 10

# This font is widely installed, provides lots of unicode glyphs, right-to-left
# text rendering and scalability on retina/hidpi displays (thanks to pango).
#font pango:DejaVu Sans Mono 8

# Start XDG autostart .desktop files using dex. See also
# https://wiki.archlinux.org/index.php/XDG_Autostart
exec --no-startup-id dex-autostart --autostart --environment i3

# The combination of xss-lock, nm-applet and pactl is a popular choice, so
# they are included here as an example. Modify as you see fit.

# xss-lock grabs a logind suspend inhibit lock and will use i3lock to lock the
# screen before suspend. Use loginctl lock-session to lock your screen.
exec --no-startup-id xss-lock --transfer-sleep-lock -- i3lock-fancy-rapid 5 3 --nofork

# NetworkManager is the most popular way to manage wireless networks on Linux,
# and nm-applet is a desktop environment-independent system tray GUI for it.
exec --no-startup-id nm-applet

# tartup bluetooth applet
exec --no-startup-id blueman-applet

# automatically startup picom
exec_always --no-startup-id sh -c "sleep 1 && picom --config ~/.config/picom/picom.conf"

# automatically merge .Xresources to avoid bugs
exec --no-startup-id -merge ~/.Xresources

# automatically call feh to set the background wallpaper
exec_always --no-startup-id feh --bg-scale ~/Pictures/wallpapers/may2025/2CB.png

# automatically start xautolock to lock the screen after 3 minutes of inactivity
#exec --no-startup-id xautolock -time 3 -locker "i3lock-fancy"

# start polybar
exec_always --no-startup-id sh -c "killall -q polybar; sleep 1; polybar example --config=~/.config/polybar/config.ini &"

# automatically start flameshot
exec --no-startup-id flameshot

# Brightness
bindsym XF86MonBrightnessDown exec brightnessctl set 10%-
bindsym XF86MonBrightnessUp exec brightnessctl set +10%

# Volume
bindsym XF86AudioMute exec amixer set Master toggle
bindsym XF86AudioLowerVolume exec amixer set Master 5%-
bindsym XF86AudioRaiseVolume exec amixer set Master 5%+


# Mic mute toggle
bindsym XF86AudioMicMute exec amixer set Capture toggle



# Use Mouse+$mod to drag floating windows to their wanted position
floating_modifier $mod

# open flameshot
bindsym $mod+Shift+s exec flameshot gui


# start a terminal
bindsym $mod+Return exec kitty

# lock the screen
bindsym $mod+Control+l exec --no-startup-id i3lock-fancy-rapid 5 3

# open rofi as app launcher
bindsym $mod+m exec rofi -show drun

# open rofi as a file browser
bindsym $mod+Shift+m exec rofi -show filebrowser

# open firefox 
bindsym $mod+n exec firefox

# kill focused window
bindsym $mod+Shift+q kill

# start dmenu (a program launcher)
bindsym $mod+d exec --no-startup-id "dmenu_run -nf '#BBBBBB' -nb '#222222' -sb '#005577' -sf '#EEEEEE' -fn 'monospace-10'"
# A more modern dmenu replacement is rofi:
# bindcode $mod+40 exec "rofi -modi drun,run -show drun"
# There also is i3-dmenu-desktop which only displays applications shipping a
# .desktop file. It is a wrapper around dmenu, so you need that installed.
# bindcode $mod+40 exec --no-startup-id i3-dmenu-desktop

# change focus
bindsym $mod+j focus left
bindsym $mod+k focus down
bindsym $mod+l focus up
bindsym $mod+uring focus right

# alternatively, you can use the cursor keys:
bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right

# move focused window
bindsym $mod+Shift+j move left
bindsym $mod+Shift+k move down
bindsym $mod+Shift+l move up
bindsym $mod+Shift+uring move right

# alternatively, you can use the cursor keys:
bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right

# split in horizontal orientation
bindsym $mod+h split h

# split in vertical orientation
bindsym $mod+v split v

# enter fullscreen mode for the focused container
bindsym $mod+f fullscreen toggle

# change container layout (stacked, tabbed, toggle split)
bindsym $mod+s layout stacking
bindsym $mod+w layout tabbed
bindsym $mod+e layout toggle split

# toggle tiling / floating
bindsym $mod+Shift+space floating toggle

# change focus between tiling / floating windows
bindsym $mod+space focus mode_toggle

# focus the parent container
bindsym $mod+a focus parent

# focus the child container
#bindsym $mod+d focus child

# Define names for default workspaces for which we configure key bindings later on.
# We use variables to avoid repeating the names in multiple places.
set $ws1 "1"
set $ws2 "2"
set $ws3 "3"
set $ws4 "4"
set $ws5 "5"
set $ws6 "6"
set $ws7 "7"
set $ws8 "8"
set $ws9 "9"
set $ws10 "10"

# switch to workspace
bindsym $mod+plus workspace number $ws1
bindsym $mod+ecaron workspace number $ws2
bindsym $mod+scaron workspace number $ws3
bindsym $mod+ccaron workspace number $ws4
bindsym $mod+rcaron workspace number $ws5
bindsym $mod+zcaron workspace number $ws6
bindsym $mod+yacute workspace number $ws7
bindsym $mod+aacute workspace number $ws8
bindsym $mod+iacute workspace number $ws9
bindsym $mod+eacute workspace number $ws10

# move focused container to workspace
bindsym $mod+Shift+plus move container to workspace number $ws1
bindsym $mod+Shift+ecaron move container to workspace number $ws2
bindsym $mod+Shift+scaron move container to workspace number $ws3
bindsym $mod+Shift+ccaron move container to workspace number $ws4
bindsym $mod+Shift+rcaron move container to workspace number $ws5
bindsym $mod+Shift+zcaron move container to workspace number $ws6
bindsym $mod+Shift+yacute move container to workspace number $ws7
bindsym $mod+Shift+aacute move container to workspace number $ws8
bindsym $mod+Shift+iacute move container to workspace number $ws9
bindsym $mod+Shift+eacute move container to workspace number $ws10

# reload the configuration file
bindsym $mod+Shift+c reload
# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
bindsym $mod+Shift+r restart
# exit i3 (logs you out of your X session)
bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'"

# resize window (you can also use the mouse for that)
mode "resize" {
        # These bindings trigger as soon as you enter the resize mode

        # Pressing left will shrink the window’s width.
        # Pressing right will grow the window’s width.
        # Pressing up will shrink the window’s height.
        # Pressing down will grow the window’s height.
        bindsym j resize shrink width 10 px or 10 ppt
        bindsym k resize grow height 10 px or 10 ppt
        bindsym l resize shrink height 10 px or 10 ppt
        bindsym uring resize grow width 10 px or 10 ppt

        # same bindings, but for the arrow keys
        bindsym Left resize shrink width 10 px or 10 ppt
        bindsym Down resize grow height 10 px or 10 ppt
        bindsym Up resize shrink height 10 px or 10 ppt
        bindsym Right resize grow width 10 px or 10 ppt

        # back to normal: Enter or Escape or $mod+r
        bindsym Return mode "default"
        bindsym Escape mode "default"
        bindsym $mod+r mode "default"
}

bindsym $mod+r mode "resize"

# class                 border  bground text    indicator child_border
client.focused          #FFFFFF #FFFFFF #FFFFFF #FFFFFF   #b12cbf
client.focused_inactive #8C8C8C #4C4C4C #FFFFFF #4C4C4C   #FFFFFF
client.unfocused        #4C4C4C #222222 #888888 #292D2E   #500096
client.urgent           #EC69A0 #DB3279 #FFFFFF #DB3279   #DB3279
client.placeholder      #000000 #0C0C0C #FFFFFF #000000   #FFFFFF

client.background       #FFFFFF

# Start i3bar to display a workspace bar (plus the system information i3status
# finds out, if available)
#bar {
#  colors {
#    background #000000
#    statusline #b12cbf
#    separator  #500096
#
#    focused_workspace  #500096 #b12cbf #000000
#    active_workspace   #500096 #b12cbf #000000
#    inactive_workspace #500096 #000000 #b12cbf
#    urgent_workspace   #500096 #b12cbf #000000
#    binding_mode       #500096 #b12cbf #000000
#  }
#  status_command i3blocks
#  position top
#}


# defualt border style for new windows
default_border pixel 3
default_floating_border pixel 3
# 0default_border_color # 500096
# hide container  edges if theyre at the screen edge
hide_edge_borders smart 
          '';
        };
      };
    };

  services = {
    polybar = {
      enable = true;
      extraConfig = let
  colors = {
    background = "#1c182d";
    background-alt = "#2b1b3d";
    foreground = "#d0b6fd";
    primary = "#cfb5fd";
    secondary = "#8a78b0";
    alert = "#7b91fc";
    disabled = "#707880";
    };
      in 
''
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

;[colors]
;background = #1c182d
;background-alt = #2b1b3d
;foreground = #d0b6fd
;primary = #cfb5fd
;secondary = #8a78b0
;alert = #7b91fc
;disabled = #707880

[bar/example]
width = 100%
height = 30pt
radius = 15

; dpi = 96

background = ${colors.background}
foreground = ${colors.foreground}

line-size = 4pt

border-size = Opt
border-color = #00000000

padding-left = 0
padding-right = 1

module-margin = 1

separator = |
separator-foreground = ${colors.disabled}

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
label-active-background = ${colors.background-alt}
label-active-underline= ${colors.primary}
label-active-padding = 1

label-occupied = %name%
label-occupied-padding = 1

label-urgent = %name%
label-urgent-background = ${colors.alert}
label-urgent-padding = 1

label-empty = %name%
label-empty-foreground = ${colors.disabled}
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
label-unmounted-foreground = ${colors.disabled}

[module/pulseaudio]
type = internal/pulseaudio

format-volume-prefix = "VOL "
format-volume-prefix-foreground = ${colors.primary}
format-volume = <label-volume>

label-volume = %percentage%%

label-muted = muted
label-muted-foreground = ${colors.disabled}

[module/xkeyboard]
type = internal/xkeyboard
blacklist-0 = num lock

label-layout = %layout%
label-layout-foreground = ${colors.primary}

label-indicator-padding = 2
label-indicator-margin = 1
label-indicator-foreground = ${colors.background}
label-indicator-background = ${colors.secondary}

[module/memory]
type = internal/memory
interval = 2
format-prefix = "RAM "
format-prefix-foreground = ${colors.primary}
label = %percentage_used:2%%

[module/cpu]
type = internal/cpu
interval = 2
format-prefix = "CPU "
format-prefix-foreground = ${colors.primary}
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
label-foreground = ${colors.primary}

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
    script = "polybar example --config~/.config/polybar/config.ini &";
    };

    picom = {
      enable = true;
      backend = "glx";
      vSync = true;
      inactiveOpacity = .9;
      activeOpacity = 1;
      fade = true;
      fadeSteps = [ 0.09 0.09 ];
      fadeDelta = 5;
      shadow = true;
      shadowOffsets = [ 12 12 ];
      shadowOpacity = 0.5;
    };
  };
};
  services.openssh.enable = true;

  system.copySystemConfiguration = true;
  system.stateVersion = "25.05";
}


