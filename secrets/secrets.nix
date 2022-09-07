let keys = import ../keys.nix;
in {
  # https certificate
  "everest-ci.cer.age".publicKeys = keys;
  "everest-ci.key.age".publicKeys = keys;

  # hydra tokens
  "github-token-hydra.age".publicKeys = keys;
  "github-token-nix-conf.age".publicKeys = keys;
  "hydra-users.age".publicKeys = keys;
  "id_ed25519.age".publicKeys = keys;
}
