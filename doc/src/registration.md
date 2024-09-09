# Registering a GitHub runner

This section details how to re-register a runner that disconnected from GitHub,
using the example of the hacl-star runner.

The process is quite simple:
1. remove the old runner from the repository
2. generate a new registration token on GitHub
3. edit the token in the configuration and deploy

Go to
[https://github.com/hacl-star/hacl-star/settings/actions/runners](https://github.com/hacl-star/hacl-star/settings/actions/runners)
and remove `hacl-ci` if it still appears in the list. Then add a new Linux
runner and copy the token that's given somewhere in the script.

Go to `./secrets` and edit the token:

```bash
nix run github:ryantm/agenix -- -e github-runner-hacl-ci-token.age
```

Then deploy the new configuration by running `./switch.sh`.

Go back to
[https://github.com/hacl-star/hacl-star/settings/actions/runners](https://github.com/hacl-star/hacl-star/settings/actions/runners)
and verify that `hacl-ci` appears green.

Lastly, verify that workflows are still disabled for PRs of new contributors.
