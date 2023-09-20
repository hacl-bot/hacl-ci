{
  config,
  pkgs,
  ...
}: {
  users.users.fusion-inventory.group = "fusion-inventory";
  users.groups.fusion-inventory = {};
  services.fusionInventory = {
    enable = true;
    servers = ["https://gtpi.inria.fr/plugins/fusioninventory"];
    extraConfig = ''
      tag = PRO
    '';
  };
}
