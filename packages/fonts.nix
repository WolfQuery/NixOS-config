#############
# fonts,nix #
#############

{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
fira-code
noto-fonts
noto-fonts-emoji
	];
}

