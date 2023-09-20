let
  keys = import ../keys.nix;
in {
  # https certificate
  "everest-ci.cer.age".publicKeys = keys;
  "everest-ci.key.age".publicKeys = keys;

  # binary cache
  "cache-priv-key.age".publicKeys = keys;

  # github runner
  "github-runner-token.age".publicKeys = keys;

  # gitlab runner
  "gitlab-runner-registration.age".publicKeys = keys;

  # cachix
  "cachix-hacl-token.age".publicKeys = keys;
}
