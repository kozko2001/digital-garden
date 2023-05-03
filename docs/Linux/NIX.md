# Nix

## Install

from https://nixos.org/download.html

```
sh <(curl -L https://nixos.org/nix/install) --daemon
```

## How nix work

- Nix Store everything in the **nix store** usually at `/nix/store`
- **Nix profiles** make the package visible to the user, a profile describes an environment normally don with `nix-env`

```bash
nix-env -i package_name.  ## install a package in the default profile
nix-env --query "*"       ## query packages in the current profile
nix-env -e package_name.  ## remove a package in the current profile
nix-env --rollback.       ## rollback to a previous generation
```

- **Chanenels**: is a repository with packages for nix

```bash
nix-channel --list
nix-channel --add https://nixos.org/channels/nixpkgs-unstable unstable
nix-channel --update

nix-env -iA unstable.simgrid  ## Install simgrid from the unstable
```

- **packages**

```bash
nix-env upgrade simgrid
nix search nixpkgs simgrid
```

- **Shells**: makes visible packages of an specific profile to a new shell (like virtualenv)

```
nix-shell
```

- **Flakes**: Like templates for scaffolding nix packages for different packages

It's still experimental, you need to activate it with:

```bash
echo 'experimental-features = nix-command flakes' >> /etc/nix/nix.conf
```

```bash
nix flake show templates                 ## shows templates available
nix flake init -t templates#trivial      ## create the nix
```

## Nix as build tool

Nix can be used as a tool to build software in a consistent manner

```
{
  pkgs ? import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/4fe8d07066f6ea82cda2b0c9ae7aee59b2d241b3.tar.gz";
    sha256 = "sha256:06jzngg5jm1f81sc4xfskvvgjy5bblz51xpl788mnps1wrkykfhp";
  }) {}
}:
pkgs.stdenv.mkDerivation rec {
  pname = "chord";
  version = "0.1.0";

  src = pkgs.fetchgit {
    url = "https://gitlab.inria.fr/nix-tutorial/chord-tuto-nix-2022";
    rev = "069d2a5bfa4c4024063c25551d5201aeaf921cb3";
    sha256 = "sha256-MlqJOoMSRuYeG+jl8DFgcNnpEyeRgDCK2JlN9pOqBWA=";
  };

  buildInputs = [
    pkgs.simgrid
    pkgs.boost
    pkgs.cmake
  ];

  configurePhase = ''
    cmake .
  '';

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv chord $out/bin
  '';
}
```

```
nix-build chord.nix
```

## Build to create a docker image

```
{
  pkgs ? import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/4fe8d07066f6ea82cda2b0c9ae7aee59b2d241b3.tar.gz";
    sha256 = "sha256:06jzngg5jm1f81sc4xfskvvgjy5bblz51xpl788mnps1wrkykfhp";
  }) {}
}:

with pkgs;

let
  packages = rec {
    chord-docker = dockerTools.buildImage {
      name = "chord-docker";
      tag = "tuto-nix";
      contents = [ chord ];
      config = {
        Cmd = [ "${chord}/bin/chord" ];
        WorkingDir = "/data";
        Volumes = { "/data" = { }; };
      };
    };
  };
in
  packages
```

```
nix-build default.nix -A chord-docker
```

This will generate a result tarball thar we need to load into docker

```
docker load < result
```

## Example of how to use nix-shell

```
 This shell defines a development environment for the Chord project.
{
  pkgs ? import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/4fe8d07066f6ea82cda2b0c9ae7aee59b2d241b3.tar.gz";
    sha256 = "sha256:06jzngg5jm1f81sc4xfskvvgjy5bblz51xpl788mnps1wrkykfhp";
  }) {}
}:
pkgs.mkShell rec {
   buildInputs = with pkgs; [
    cmake
    boost
    simgrid

    # debugging tools
    gdb
    valgrind
   ];
}
```

```
nix-shell shell.nix
```

## Links

- [Nix in X minutes](https://learnxinyminutes.com/docs/nix/)
- [Nix Manual - Nix expression language](https://nixos.org/manual/nix/stable/language/index.html)
- [James Fisher - Nix by example - Part 1: The Nix expression language](https://jameshfisher.com/2014/09/28/nix-by-example/)
- [Susan Potter - Nix Cookbook - Nix By Example](https://ops.functionalalgebra.com/nix-by-example/)
