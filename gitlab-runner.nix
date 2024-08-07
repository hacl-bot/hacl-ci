{
  config,
  lib,
  pkgs,
  ...
}:
{
  age.secrets.gitlab-runner-cryptoverif-registration = {
    file = ./secrets/gitlab-runner-cryptoverif-registration.age;
    owner = "gitlab-runner";
    mode = "0440";
  };

  users.groups."gitlab-runner" = { };
  users.users."gitlab-runner" = {
    isSystemUser = true;
    group = "gitlab-runner";
  };

  services.gitlab-runner = {
    enable = true;

    services.cryptoverif = {
      registrationConfigFile = config.age.secrets.gitlab-runner-cryptoverif-registration.path;
      dockerImage = "alpine";
      dockerVolumes = [
        "/nix/store:/nix/store:ro"
        "/nix/var/nix/db:/nix/var/nix/db:ro"
        "/nix/var/nix/daemon-socket:/nix/var/nix/daemon-socket:ro"
      ];
      dockerDisableCache = true;
      dockerPrivileged = true;
      preBuildScript = pkgs.writeScript "setup-container" ''
        mkdir -p -m 0755 /nix/var/log/nix/drvs
        mkdir -p -m 0755 /nix/var/nix/gcroots
        mkdir -p -m 0755 /nix/var/nix/profiles
        mkdir -p -m 0755 /nix/var/nix/temproots
        mkdir -p -m 0755 /nix/var/nix/userpool
        mkdir -p -m 1777 /nix/var/nix/gcroots/per-user
        mkdir -p -m 1777 /nix/var/nix/profiles/per-user
        mkdir -p -m 0755 /nix/var/nix/profiles/per-user/root
        mkdir -p -m 0700 "$HOME/.nix-defexpr"

        mkdir -p /etc/nix
        echo "sandbox = true" > /etc/nix/nix.conf

        . ${pkgs.nix}/etc/profile.d/nix.sh

        ${pkgs.nix}/bin/nix-env -i ${
          lib.concatStringsSep " " (
            with pkgs;
            [
              nix
              cacert
              git
              openssh
            ]
          )
        }

        ${pkgs.nix}/bin/nix-channel --add https://nixos.org/channels/nixpkgs-unstable
        ${pkgs.nix}/bin/nix-channel --update nixpkgs
      '';
      environmentVariables = {
        ENV = "/etc/profile";
        USER = "root";
        NIX_REMOTE = "daemon";
        PATH = "/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:/bin:/sbin:/usr/bin:/usr/sbin";
        NIX_SSL_CERT_FILE = "/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt";
      };
      tagList = [ "nix" ];
    };
  };

  systemd.services.gitlab-runer.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = "gitlab-runner";
    Group = "gitlab-runner";
  };
}
