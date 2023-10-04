# Security

The use of self-hosted runners is discouraged for public repositories. Indeed,
GitHub gives no warranty about the isolation of workflows inside the self-hosted
runners. This means any PR can run potentially harmful code on the CI machine.
The risk is mitigated by three things:

- We require approval for workflow runs on PRs by new contributors.

- The CI machine is entirely dedicated to continuous integration and should not
  contain secrets interesting for anything else than its own operation. It is
  not even used for deployment other than this documentation.

- The CI machine runs on its own virtual LAN and can't be used as a meaningful
  bounce to anything else.
