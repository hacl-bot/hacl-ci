let
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINta9hgVN7WHEbVWeXeUFimDY4EP7WgkW6psxS1U4IHk" # pnm laptop
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJBARXKy2p3RKO0tnhtmMO49uCstEpJ9iHhU8UOtPJw1 root@everest-ci" # everest-ci
  ];
in {
  "everest-ci.cer.age".publicKeys = keys;
  "everest-ci.key.age".publicKeys = keys;
}
