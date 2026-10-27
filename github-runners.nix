{ config
, lib
, pkgs
, ...
}:
let
  aux = name: url: {
    age.secrets."github-runner-${name}-ci-token" = {
      file = ./secrets/github-runner-${name}-ci-token.age;
      owner = "github-runner";
      mode = "0440";
    };
    services.github-runners."${name}-ci" = {
      enable = true;
      inherit url;
      user = "github-runner";
      tokenFile = config.age.secrets."github-runner-${name}-ci-token".path;
      workDir = "%S/github-runner-work/${name}";
      nodeRuntimes = [
        "node24"
      ];
      extraLabels = [ "nix" ];
      serviceOverrides = {
        StateDirectory = lib.mkBefore [ "github-runner-work/${name}" ];
        # Restart after each job to wipe any state.
        # Note: GitHub plans to deprecate --once; we'll need to setup ephemeral
        # mode when that happens..
        ExecStart = lib.mkForce "${config.services.github-runners."${name}-ci".package}/bin/Runner.Listener run --startuptype service --once";
        Restart = lib.mkForce "always";
        RestartSec = 5;
        PrivateIPC = true;
      };
    };
  };
in
{
  users.groups."github-runner" = { };
  users.users."github-runner" = {
    isSystemUser = true;
    group = "github-runner";
  };
  environment.systemPackages = [ pkgs.github-runner ];

  imports = [
    (aux "aeneasverif1" "https://github.com/aeneasverif")
    (aux "aeneasverif2" "https://github.com/aeneasverif")
    (aux "aeneasverif3" "https://github.com/aeneasverif")
    (aux "aeneasverif4" "https://github.com/aeneasverif")
    (aux "aeneasverif5" "https://github.com/aeneasverif")
    (aux "aeneasverif6" "https://github.com/aeneasverif")
    (aux "aeneasverif7" "https://github.com/aeneasverif")
    (aux "aeneasverif8" "https://github.com/aeneasverif")
    (aux "circus-green" "https://github.com/inria-prosecco/circus-green")
    (aux "comparse" "https://github.com/twal/comparse")
    (aux "dolev-yao-star" "https://github.com/reprosec/dolev-yao-star-extrinsic")
    # (aux "dolev-yao-star-tutorial" "https://github.com/reprosec/dolev-yao-star-tutorial-code")
    (aux "hacl-1" "https://github.com/hacl-star/hacl-star")
    (aux "hacl-2" "https://github.com/hacl-star/hacl-star")
    (aux "hacl-nix" "https://github.com/hacl-star/hacl-nix")
    (aux "mls-star" "https://github.com/inria-prosecco/mls-star")
    (aux "prosecco-green" "https://github.com/inria-prosecco/prosecco-green")
    (aux "starmalloc" "https://github.com/inria-prosecco/starmalloc")
  ];
}
