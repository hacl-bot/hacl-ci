# Troubleshooting

Once your ssh key has been added to the `everest-ci` config, you can access the
machine from Inria's internal network or through Inria's VPN:

```bash
ssh everest@everest-ci.paris.inria.fr
```

You can inspect the GitHub runner:

```bash
sudo systemctl status github-runner-hacl-ci.service
```

If the GitHub runner stops responding, maybe try restarting it:

```bash
sudo systemctl restart github-runner-hacl-ci.service
```

If the problem persists, go through the detailed logs:

```bahs
sudo journalctl -xeu github-runner-hacl-ci.service
```

If the runner is unable to talk to GitHub, maybe try
[re-registering](./registration.md) it.
