let
  keys = import ../keys.nix;
in
{
  # github runners
  "github-runner-aeneasverif1-ci-token.age".publicKeys = keys;
  "github-runner-aeneasverif2-ci-token.age".publicKeys = keys;
  "github-runner-aeneasverif3-ci-token.age".publicKeys = keys;
  "github-runner-aeneasverif4-ci-token.age".publicKeys = keys;
  "github-runner-aeneasverif5-ci-token.age".publicKeys = keys;
  "github-runner-aeneasverif6-ci-token.age".publicKeys = keys;
  "github-runner-aeneasverif7-ci-token.age".publicKeys = keys;
  "github-runner-aeneasverif8-ci-token.age".publicKeys = keys;
  "github-runner-aeneas-2-ci-token.age".publicKeys = keys;
  "github-runner-aeneas-ci-token.age".publicKeys = keys;
  "github-runner-charon-2-ci-token.age".publicKeys = keys;
  "github-runner-charon-ci-token.age".publicKeys = keys;
  "github-runner-circus-green-ci-token.age".publicKeys = keys;
  "github-runner-comparse-ci-token.age".publicKeys = keys;
  "github-runner-dolev-yao-star-ci-token.age".publicKeys = keys;
  "github-runner-dolev-yao-star-tutorial-ci-token.age".publicKeys = keys;
  "github-runner-eurydice-ci-token.age".publicKeys = keys;
  "github-runner-scylla-ci-token.age".publicKeys = keys;
  "github-runner-hacl-1-ci-token.age".publicKeys = keys;
  "github-runner-hacl-2-ci-token.age".publicKeys = keys;
  "github-runner-hacl-nix-ci-token.age".publicKeys = keys;
  "github-runner-mls-star-ci-token.age".publicKeys = keys;
  "github-runner-prosecco-green-ci-token.age".publicKeys = keys;
  "github-runner-starmalloc-ci-token.age".publicKeys = keys;

  # gitlab runner
  "gitlab-runner-cryptoverif-registration.age".publicKeys = keys;

  # cachix
  "cachix-hacl-token.age".publicKeys = keys;

  # hacl-bot credentials
  "hacl-bot.age".publicKeys = keys;
}
