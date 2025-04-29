{ config
, lib
, pkgs
, ...
}:
let
  cleanup = pkgs.writeShellScript "cleanup.sh" "rm -rf $GITHUB_WORKSPACE/*";
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
      nodeRuntimes = [
        "node16"
        "node20"
      ];
      extraLabels = [ "nix" ];
      extraEnvironment.ACTIONS_RUNNER_HOOK_JOB_STARTED = cleanup;
      extraEnvironment.ACTIONS_RUNNER_HOOK_JOB_COMPLETED = cleanup;
    };
  };
in
{
  users.groups."github-runner" = { };
  users.users."github-runner" = {
    isSystemUser = true;
    group = "github-runner";
  };

  imports = [
    (aux "aeneasverif1" "https://github.com/aeneasverif")
    (aux "aeneasverif2" "https://github.com/aeneasverif")
    (aux "aeneasverif3" "https://github.com/aeneasverif")
    (aux "aeneasverif4" "https://github.com/aeneasverif")
    (aux "aeneasverif5" "https://github.com/aeneasverif")
    (aux "aeneasverif6" "https://github.com/aeneasverif")
    (aux "aeneasverif7" "https://github.com/aeneasverif")
    (aux "aeneasverif8" "https://github.com/aeneasverif")
    (aux "aeneas-2" "https://github.com/aeneasverif/aeneas")
    (aux "aeneas" "https://github.com/aeneasverif/aeneas")
    (aux "circus-green" "https://github.com/inria-prosecco/circus-green")
    (aux "comparse" "https://github.com/twal/comparse")
    (aux "dolev-yao-star" "https://github.com/reprosec/dolev-yao-star-extrinsic")
    (aux "dolev-yao-star-tutorial" "https://github.com/reprosec/dolev-yao-star-tutorial-code")
    (aux "eurydice" "https://github.com/aeneasverif/eurydice")
    (aux "hacl-1" "https://github.com/hacl-star/hacl-star")
    (aux "hacl-2" "https://github.com/hacl-star/hacl-star")
    (aux "hacl-nix" "https://github.com/hacl-star/hacl-nix")
    (aux "mls-star" "https://github.com/inria-prosecco/mls-star")
    (aux "prosecco-green" "https://github.com/inria-prosecco/prosecco-green")
    (aux "scylla" "https://github.com/aeneasverif/scylla")
    (aux "starmalloc" "https://github.com/inria-prosecco/starmalloc")
  ];

  nixpkgs.config.permittedInsecurePackages = [ "nodejs-16.20.2" ];
}
