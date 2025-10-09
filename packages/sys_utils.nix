#################
# sys_utils-nix #
#################

{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    tree git lazygit killall acpi wirelesstools brightnessctl
    fastfetch auto-cpufreq btop
  ];
}

