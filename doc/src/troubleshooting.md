# Troubleshooting

Once your ssh key has been added to the `everest-ci` config, you can access the
machine from Inria's internal network or through Inria's VPN:

```bash
ssh everest@everest-ci.paris.inria.fr
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

If a runner is unable to connect to GitHub, try
[re-registering](./registration.md) it. Disconnections often happen after an
update of the runner version.
