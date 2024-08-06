# Troubleshooting

Once your ssh key has been added to the NixOS config, you can access the machine
from Inria's internal network or through Inria's VPN:

```bash
ssh hacl@128.93.101.164
```

You can inspect the GitHub runners:

```bash
sudo systemctl status github-runner-hacl-1-ci.service
sudo systemctl status github-runner-hacl-2-ci.service
```

If a GitHub runner stops responding, try restarting it:

```bash
sudo systemctl restart github-runner-hacl-1-ci.service
sudo systemctl restart github-runner-hacl-2-ci.service
```

If the problem persists, go through the detailed logs:

```bahs
sudo journalctl -xeu github-runner-hacl-1-ci.service
sudo journalctl -xeu github-runner-hacl-2-ci.service
```

If a runner is unable to connect to GitHub, you probably need to do a [system
update](./maintenance.md) because the runner version is deprecated. This should
be indicated clearly in the GitHub interface. If the runner is up-to-date and is
still unable to connect, try [re-registering](./registration.md). Note that
re-registration is often (but not always) required after an update. Always check
if the runners re-connected properly after an update!
