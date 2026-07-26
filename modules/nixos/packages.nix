{ config, pkgs, ... }:

{

  # user packages
  users.users.tom.packages = with pkgs; [
    # music
    reaper
    vital
    surge-xt
    helm
    airwindows
    # programming
    python3
    libgcc
    clang
    swi-prolog
    wineWow64Packages.stable
    ollama
    uv
    # cli tools
    ripgrep
    unzip
    unixtools.netstat
    usbutils
    file
    p7zip
    pandoc
    traceroute
    texliveSmall
    netcat
    xautomation
    htop
    dig
    pwgen
    wget
    exfat
    pomodoro
    nmap
    # system
    pavucontrol
    home-manager
    libnotify
    grimblast
    wl-clipboard
    openvpn
    bluetui
    alsa-utils
    # desktop
    obsidian
    discord
    spotify
    discord
    steam
    vlc
    thunderbird
    gimp
    signal-desktop
    bitwarden-desktop
    davinci-resolve
    obs-studio

    # last
  ];

  environment.systemPackages = with pkgs; [
    networkmanager
    fastfetch
    neovim
    bash
    egl-wayland
    tree
    git
    dnsmasq
    openssl
  ];
}
