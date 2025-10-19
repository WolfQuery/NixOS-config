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

        extraLuaConfig = ''
          -- Bootstrap LazyVim
          local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
          if not vim.loop.fs_stat(lazypath) then
            vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable",
            lazypath,
            })
          end
          vim.opt.rtp:prepend(lazypath)

          -- Install LazyVim and setup
          require("lazy").setup({
            spec = {
              { "LazyVim/LazyVim", import = "lazyvim.plugins" },
              { import = "lazyvim.plugins.extras.lang.latex" },
              { import = "lazyvim.plugins.extras.lang.markdown" },
              { import = "lazyvim.plugins.extras.ui.mini-animate" },
	            { import = "lazyvim.plugins.extras.lang.typescript" },
	            { import = "lazyvim.plugins.extras.lang.python" },
	            { import = "lazyvim.plugins.extras.lang.rust" },
              { "lervag/vimtex",
                lazy = false,     -- we don't want to lazy load VimTeX
                -- tag = "v2.15", -- uncomment to pin to a specific release
                init = function()
                -- VimTeX configuration goes here, e.g.
                vim.g.vimtex_view_method = "zathura"
              end},
              },
            defaults = { lazy = false, version = false },
            install = { colorscheme = { "tokyonight", "habamax" } },
            checker = { enabled = true },
            performance = {
              rtp = {
                disabled_plugins = {
                  "gzip",
                  "tarPlugin",
                  "tohtml",
                  "tutor",
                  "zipPlugin",
                },
              },
            },
          })
        '';
      };

      # --- Kitty Terminal ---
      kitty = {
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
    };
    xsession = {
      windowManager = {
        i3 = {
          enable = true;

          config = {
            extraConfig = ''

            '';
          };
        };
      };
    };
  };
  # --- Other Services ---
  services.openssh.enable = true;
  system.copySystemConfiguration = true;
  system.stateVersion = "25.05";
}
