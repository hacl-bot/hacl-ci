{ config, pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "everest-ci";

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "en_IE.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  security.sudo.wheelNeedsPassword = false;

  users.users.everest = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = import ./keys.nix;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    htop
    git
    tmux
    jq
  ];

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
    ports = [ 22 ];
  };

  nix = {
    settings.trusted-users = [ "@wheel" ];
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    gc = {
      automatic = true;
      dates = "weekly";
    };
  };

  age.secrets."everest-ci.cer" = {
    file = ./secrets/everest-ci.cer.age;
    owner = config.services.nginx.user;
    group = config.services.nginx.group;
  };
  age.secrets."everest-ci.key" = {
    file = ./secrets/everest-ci.key.age;
    owner = config.services.nginx.user;
    group = config.services.nginx.group;
  };
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;

    virtualHosts."everest-ci.paris.inria.fr" = {
      default = true;
      forceSSL = true;
      sslCertificate = config.age.secrets."everest-ci.cer".path;
      sslCertificateKey = config.age.secrets."everest-ci.key".path;
    };
  };
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
