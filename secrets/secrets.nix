let
  keys = import ../keys.nix;
in {
  # https certificate
  "everest-ci.cer.age".publicKeys = keys;
  "everest-ci.key.age".publicKeys = keys;

  # binary cache
  "cache-priv-key.age".publicKeys = keys;

  # github runners
  "github-runner-hacl-ci-token.age".publicKeys = keys;
  "github-runner-hacl-nix-ci-token.age".publicKeys = keys;
  "github-runner-starmalloc-ci-token.age".publicKeys = keys;
  "github-runner-charon-ci-token.age".publicKeys = keys;
  "github-runner-aeneas-ci-token.age".publicKeys = keys;
  "github-runner-mls-star-ci-token.age".publicKeys = keys;
  "github-runner-comparse-ci-token.age".publicKeys = keys;

  # gitlab runner
  "gitlab-runner-registration.age".publicKeys = keys;

  # cachix
  "cachix-hacl-token.age".publicKeys = keys;
}
