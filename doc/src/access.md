# Access

Once your ssh key has been added to the `everest-ci` config,
you can access the machine from Inria's internal network:

```bash
ssh everest@everest-ci.paris.inria.fr
```

You can inspect the GitHub runner logs using systemd:

```bash
sudo systemctl status github-runner-everest-ci.service
```

If the GitHub runner stops responding, maybe try restarting it:

```bash
sudo systemctl restart github-runner-everest-ci.service
```

But don't try to edit its configuration from the machine, it is read-only! To
edit the server's configuration, you need to have Nix installed on your local
machine. Then you can edit the configuration in
[hacl-ci](https://github.com/hacl-bot/hacl-ci) and deploy the updated
configuration by running the `switch.sh` script.
