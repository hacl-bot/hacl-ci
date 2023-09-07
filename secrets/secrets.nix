let keys = import ../keys.nix;
in {
  # https certificate
  "everest-ci.cer.age".publicKeys = keys;
  "everest-ci.key.age".publicKeys = keys;

  # binary cache
  "cache-priv-key.age".publicKeys = keys;

  # github runner
  "github-runner-token.age".publicKeys = keys;
}
