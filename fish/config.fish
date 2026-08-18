if status is-interactive

# ==================================================
# 1~ General Settings
# ==================================================

  set -g fish_greeting ""

# ==================================================
# 1~ Aliases
# ==================================================

  alias rebuild="cd /etc/nixos && sudo nixos-rebuild switch --flake"
  alias upgrade="cd /etc/nixos && sudo nix flake update && sudo nixos-rebuild switch"

  alias c-c="sudo nvim /etc/nixos/configuration.nix"
  alias c-p="sudo nvim /etc/nixos/modules/packages.nix"
  alias c-d="sudo nvim /etc/nixos/modules/amd-drivers.nix"
  alias c-f="sudo nvim /etc/nixos/modules/fish.nix"
  alias c-g="sudo nvim /etc/nixos/modules/gaming.nix"

  alias rvd="./Documents/Cloud/general/scripts/edition/to_dnxhd.fish"

end

# opencode
fish_add_path /home/gontry/.opencode/bin
