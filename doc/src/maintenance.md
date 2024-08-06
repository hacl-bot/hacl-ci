# Maintenance

The CI machine runs NixOS. The system configuration is contained in the flake
[github:hacl-bot/hacl-ci](https://github.com/hacl-bot/hacl-ci). Deployment of
the configuration is acheived from Inria's local network or through the VPN by
running the `switch.sh` script.

## System updates

To update the system, you need to update the flake's lock file and re-deploy:

```bash
nix flake update
./switch.sh
```

Then, check if the runners re-connected properly. Updates will sometimes cause
disconnections and you are going to need to [re-register](./registration.md)
disconnected runners.
