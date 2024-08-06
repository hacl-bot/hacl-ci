# Access

To give `sudo` access to the machine to someone, add the person's ssh key to
`./keys.nix` in the hacl-ci repository. Then re-encrypt the secrets for that
key.

```bash
cd secrets
nix run nixpkgs:ryantm/agenix -- -r
```

Then rebuild and deploy the configuration by running `switch.sh`.
