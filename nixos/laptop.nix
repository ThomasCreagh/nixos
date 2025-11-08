{ config, pkgs, ... }:

{
  imports =
    [
      ./laptop-hardware.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [
    "amdgpu.runpm=0"
    "amdgpu.deep_color=0"
  ];

  hardware.enableRedistributableFirmware = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  networking.firewall = {
    allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
  };
  # Enable WireGuard
  #networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
  #  wg0 = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
  #    ips = [ "10.100.0.3/24" ];
  #    listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

  #    # Path to the private key file.
  #    #
  #    # Note: The private key can also be included inline via the privateKey option,
  #    # but this makes the private key world-readable; thus, using privateKeyFile is
  #    # recommended.
  #    privateKeyFile = "/etc/wireguard/privatekey";

  #    peers = [
  #      # For a client configuration, one peer entry for the server will suffice.

  #      {
  #        # Public key of the server (not a file path).
  #        publicKey = "SiK03VH5ayt0NRwAzf9O3IoxbE05Qh0LfT6G6vnBeGw=";

  #        # Forward all the traffic via VPN.
  #        allowedIPs = [ "0.0.0.0/0" ];
  #        # Or forward only particular subnets
  #        #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];

  #        # Set this to the server IP and port.
  #        endpoint = "91.98.237.217:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

  #        # Send keepalives every 25 seconds. Important to keep NAT tables alive.
  #        persistentKeepalive = 25;
  #      }
  #    ];
  #  };
  #};

  services.logind.lidSwitch = "ignore";
  services.logind.lidSwitchDocked = "ignore";
  services.power-profiles-daemon.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  swapDevices = [
    {
      device = "/swapfile";
      size   = 16384;
    }
  ];

  console.keyMap = "us";

}
