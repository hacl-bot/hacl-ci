{
  config,
  pkgs,
  ...
}: {
  users.users.demerigo = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7JxivYyrLXRojHqE9owop9mUTxB2qFm2k38Uv5PtrFBovPAReQQkrsyO/vSlidqxzZf9txw7GKgJbi3aVItD1jECKvxvUVMyGiRWX2AGN1/siN2JMevd2pnozAP9yhMW4tNTA6XYX+Eq4/3ebxef15MZ6PJL+t6Fhnrc0xEYwCajrEAG9g7MovtTitTLhhKpr74IzRyyVu3GyVBOto5b8R0WwImookH9dlWcwSB7YA07JMvkLy7MVxo276B2AzChjfKIWoAMHmdksEwzRqxK1kyvlQ7/a5Wv3Wl4AnAmys+3PdWR3lcQlzPX+55mGVsNFwQ9jQbbp2lnA/9lmUXAJ denis@denis-portable"
    ];
    packages = with pkgs; [
      afl
      clang
      git
      gmp
      gnumake
      nano
      opam
      perl
      pkg-config
    ];
  };
}
