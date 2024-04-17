# Organisation

This section contains details about the overall CI workflow of HACL*.

## hacl-star

The hacl-star flake exposes three main packages:
- `hacl`: HACL*, also the default package
- `hacl.passthru.build-products`: tarballs for `hints` and `dist`
- `hacl.passthru.resource-monitor`: a log of the CPU and RAM consumption

As mentionned in the overview, hacl-star does not contain a lock file. Every run
uses the latest versions of F* and Karamel.

The main workflow for the hacl-star repository is
[.github/workflows/nix.yml](https://github.com/hacl-star/hacl-star/blob/main/.github/workflows/nix.yml)
It runs on two self-hosted runners to build hacl, monitor the CPU and RAM
consumption of the build, and generate tarballs of the products of the build
(`hints/` and `dist/`). Build products are then made available as GitHub
artifacts, attached to each workflow run.

[./github/workflows/hintsanddist.yml](https://github.com/hacl-star/hacl-star/blob/main/.github/workflows/hintsanddist.yml)
also runs on the self-hosted runner. It is configured to run every week and opens
a PR with the new `hints` and `dist`.

[./github/workflows/hacl-packages-create-branch](https://github.com/hacl-star/hacl-star/blob/main/.github/workflows/hacl-packages-create-branch.yml)
and
[./github/workflows/hacl-packages-delete-branch](https://github.com/hacl-star/hacl-star/blob/main/.github/workflows/hacl-packages-delete-branch.yml)
run on GitHub hosted runners. They maintain corresponding branches on
hacl-packages for every PR on hacl-star. hacl-packages runs more extensive tests
and benchmarks on the generated code than the hacl-star repository.

## hacl-nix

The hacl-nix flake exposes the same packages as hacl-star,
but it holds a lock file.

[./github/workflows/nixflakeupdate.yml](https://github.com/hacl-star/hacl-nix/blob/main/.github/workflows/nixflakeupdate.yml)
runs on a self-hosted runner every day. It updates the lock file and commits the
changes if hacl is still building. It can be used to build hacl with the last
working set of dependencies:

```bash
nix build --inputs-from github:hacl-star/hacl-nix github:hacl-star/hacl-star
```
