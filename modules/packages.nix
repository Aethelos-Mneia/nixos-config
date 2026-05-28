{ config, lib, pkgs, ... }:

{
  # System packages — installed for everyone, available at boot.
  # User-specific stuff (apps, editors, dev tools) lives in home/packages.
  environment.systemPackages = with pkgs; [
    # Core CLI
    git
    vim
    wget
    curl
    file
    tree
    htop
    btop
    ripgrep
    fd
    bat
    eza
    fzf
    jq
    unzip
    p7zip

    # Wayland / Hyprland support tooling
    wl-clipboard
    grim                # screenshots
    slurp               # region selection
    swappy              # screenshot annotation
    brightnessctl
    playerctl
    pavucontrol
    networkmanagerapplet

    # Hyprland session bits
    hyprpicker          # color picker
    hyprshot            # nicer screenshot wrapper

    # Asus
    asusctl

    # System
    pciutils
    usbutils
    lm_sensors
    iotop
    nvtopPackages.full
  ];

  # Bash completions, etc.
  programs.bash.completion.enable = true;

  # GnuPG agent (for git signing, ssh-via-gpg, etc.)
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;     # flip true if you use yubikey-as-ssh-key
  };
}
